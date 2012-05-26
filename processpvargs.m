function varargout = processpvargs( pvargs, defaults, expand )
% PROCESSPVARGS Process parameterized input arguments against a set of defaults
%   Parameterized optional input arguments are specified by a sequence of
%   name-value pairs. The supported parameter names and default values are
%   provided in a struct called DEFAULTS. Name strings are compared using
%   matlab's string validator, allowing for the use of lazy (shortened) and
%   case-insensitive names, as long as the corresponding parameter name can
%   be identified unambiguously.
%
%   Returns:
%   1) No output assignment: 
%       Parameters are assigned as variables in the caller (the dirty way).
%   2) Default return value:
%       The processed parameters are returned in a struct. 
%   3) If the EXPAND option is true:
%       Then the parameter values are returned separately in ASCII order of
%       the corresponding parameter names.
%
%   See also SPLITVARARGIN

%   Author: Nezar Abdennur <nabdennur@gmail.com>
%   Created: 2012-05-25

if ~exist('expand', 'var') || isempty(expand)
    expand = false;
end

if rem(length(pvargs),2)~=0
    error('processpvargs:NameValueMismatch',...
          'Parameterized input arguments must be given as name-value pairs.');
end

processed_pvargs = orderfields(defaults);
supported_names = fieldnames(processed_pvargs);

% Override default values with input args
for i = 1:2:length(pvargs)
    try
        argname = validatestring(pvargs{i}, supported_names);
    catch exception
        if ~ischar(pvargs{i})
            error('processpvargs:InvalidParameter',...
                  'Error setting parameter.\nExpected string input for parameter name, instead got %s.', class(pvargs{i}));
        else
            error('processpvargs:InvalidParameter',...
                 ['Error setting parameter.\n', exception.message]);
        end
    end
    processed_pvargs.(argname) = pvargs{i+1};
end

if nargout == 0
    % assign variables in caller the dirty way
    for i = 1:length(processed_pvargs)
        assignin('caller', supported_names{i}, processed_pvargs{i});
    end
elseif expand
    % return list of parameters in ASCII order
    varargout = struct2cell(processed_pvargs);
else
    % return struct as unique output
    varargout{1} = processed_pvargs;
end
    
end