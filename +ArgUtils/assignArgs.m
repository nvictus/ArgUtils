function varargout = assignArgs( defaults, args_kwargs, varargin )
%ASSIGNARGS Assign input and default values to named target variables
%   Keywords are matched using MATLAB's string validator, so matching is
%   case-insensitive and abbreviated keywords are acceptable as long as
%   they can be matched unambiguously.
%
%   Input (required):
%       defaults    - struct of default target assignments
%       args_kwargs - cell-array of zero or more args followed by zero or
%                     more keyword args (i.e., name-value pairs) 
%                                       -or-
%                     a struct of keyword args
%       
%   Options (accepts keywords):
%       Expand      - boolean <false>
%       Required    - cell-array of names of required args <none>
%       Prefix      - prefix to identify keyword strings <none>
%                     (only applies to cell-array input, ignored on struct 
%                     input)
%
%   Returns:
%   	1) if Expand==false:
%           The target variables are returned in a struct with the same
%           field structure as the defaults struct.
%
%       2) if Expand==true:
%           The target variables are returned individually in the same
%           order that the fields are arranged in the defaults struct.
%           However, if nargout == 0, the variables are assigned in the
%           caller workspace the "dirty" way.
%
%   Examples:
%       Assume the following defaults struct in the examples below
%       -------------------
%       defaults.x = [];
%       defaults.y = 2;
%       defaults.z = 3;
%       defaults.state = 'off';
%       defaults.tol = 0.001;
%       -------------------
%
%       >> inputs = {100, 'state', 'on', 'z', 300};
%       >> args = assignArgs( defaults, inputs );
%           args.x == 100
%           args.y == 2
%           args.z == 300
%           args.state == 'on'
%           args.tol == 0.001
%
%       >> inputs = {100, 200, 'tol', 0.999};
%       >> [x,y,z,state,tol] = assignArgs( defaults, inputs, 'Expand', true );
%       	x == 100
%       	y == 200
%       	z == 3
%       	state == 'off'
%       	tol == 0.999
%
%       >> inputs = {'y', 200, 'z', 300};
%       >> [x,y,z,state,tol] = assignArgs( defaults, inputs, 'Expand', true, 'Required', {'x'});
%       	Error: Required argument x is missing.
%
%       >> inputs = {'x', 'state', '-tol', 'tol', '-state', 'thinking'};
%       >> [x,y,z,state,tol] = assignArgs( defaults, inputs, 'Expand', true, 'Prefix', '-');
%           x == 'x'
%           y == 'state'
%           z == 3
%           state == 'thinking'
%           tol = 'tol'

%   Author: Nezar Abdennur <nabdennur@gmail.com>
%   Created: 2012-05-25

import ArgUtils.*

% Parse the options
options.Required = {};
options.Prefix = '';
options.Expand = false;
if ~isempty(varargin)
    options = assignArgs(options, varargin);
end

% Initialize target fields
target_struct = defaults;
target_names = fieldnames(target_struct);
num_targets = length(target_names);

% Keep track of assigned args (Requires JVM!)
assigned = java.util.HashSet();

% Parse struct or cell array
if isstruct(args_kwargs)
    % 1) struct of keyword arguments 
    try
        target_struct = updateFieldValues(target_struct, args_kwargs, assigned);
    catch e
        if strcmp(e.identifier, ArgUtils.KeyError)
            throwAsCaller(e);
        else
            rethrow(e);
        end
    end
else
    % 2) cell array with 0 or more args followed by 0 or more keyword args 
    %    (name-value pairs)
    
    % Start assigning non-keyword args until we detect a keyword
    kwargs = {};
    for i = 1:length(args_kwargs)
        arg = args_kwargs{i};

        if ischar(arg)
            % Check for prefix or look for keyword match
            if options.Prefix
                if startsWith(arg, options.Prefix);
                    % treat everything as kwargs from here on
                    kwargs = args_kwargs(i:end);
                    break;
                end
            else
                name_matched = false;
                try
                    validatestring(arg, target_names);
                    name_matched = true;
                end
                if name_matched
                    % treat everything as kwargs from here on
                    kwargs = args_kwargs(i:end);
                    break;
                end
            end
        end
        
        if i > num_targets
            throwAsCaller(MException(ArgUtils.TypeError, ...
                'Too many input arguments.'));
        end
        target_struct.(target_names{i}) = arg;
        assigned.add(target_names{i});
    end

    % Assign keyword args
    if ~isempty(kwargs)
        if rem(length(kwargs),2)~=0
            throwAsCaller(MException(ArgUtils.TypeError,...
                  'Keyword arguments must be given as name-value pairs.'));
        end

        for i = 1:2:length(kwargs)
            kwarg = kwargs{i};

            if ~ischar(kwarg)
                throwAsCaller(MException(ArgUtils.TypeError,...
                    'Invalid keyword. Expected string, instead got %s.', class(kwarg)));                
            elseif options.Prefix
                kwarg = stripPrefix(kwarg, options.Prefix);
            end

            try
                name = validatestring(kwarg, target_names);
            catch e
                throwAsCaller(MException(ArgUtils.KeyError,...
                    'The name %s did not match any argument keywords', kwarg));
            end

            if assigned.contains(name)
                throwAsCaller(MException(ArgUtils.TypeError,...
                      'Got multiple values for keyword %s', name));
            else
                target_struct.(name) = kwargs{i+1};
                assigned.add(name);
            end
        end
    end
end

% Check requirements
if ~isempty(options.Required)
    for i = 1:length(options.Required)
        if ~assigned.contains(options.Required{i})
            throwAsCaller(MException(ArgUtils.TypeError,...
                  'Required argument %s is missing', options.Required{i}));
        end
    end
end

% Output
nout = nargout;
if options.Expand
    if ~nout
        % assign variables in caller the dirty way
        for i = 1:length(target_names)
            assignin('caller', target_names{i}, target_struct.(target_names{i}));
        end
    elseif nout > num_targets
        error(ArgUtils.TypeError,...
            'Too many outputs. More assignment targets than default values.');
    else
        % return target values individually
        target_vars = struct2cell(target_struct);
        [varargout{1:nargout}] = target_vars{:};
    end
elseif nout > 1
    error(ArgUtils.TypeError,...
        'Too many outputs. Use the ''Expand'' option to return assigned variables individually');
else
    % return target variables as fields of a struct
    varargout{1} = target_struct;
end

end