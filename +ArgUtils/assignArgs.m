function varargout = assignArgs( defaults, args_kwargs, varargin )
%ASSIGNARGS Assign input arguments and default values to target variables
%   Input:
%       defaults    - struct of default target assignments
%       args_kwargs - cell-array of (args, followed by) keyword-value pairs
%       
%   Options:
%       Required    - cell-array of required arg names
%       Prefix      - string prefix for keyword names
%       Expand      - boolean
%
%   Returns:
%   	Expand==False:
%           The target variables are returned as fields of a struct with
%           the same field structure as the defaults struct. 
%       Expand==True:
%           The target variables are returned individually in the same
%           order that the fields were ordered in the defaults struct.
%           If nargout == 0, the values are assigned to variables in the
%           caller workspace (the "dirty" way).
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
%       inputs = {100, 'state', 'on', 'z', 300};
%       args = assignArgs( defaults, inputs );
%       --> args.x == 100
%       --> args.y == 2
%       --> args.z == 300
%       --> args.state == 'on'
%       --> args.tol == 0.001
%
%       inputs = {100, 200, 'tol', 0.999};
%       [x,y,z,state,tol] = assignArgs( defaults, inputs, 'Expand', true );
%       --> x == 100
%       --> y == 200
%       --> z == 3
%       --> state == 'off'
%       --> tol == 0.999
%
%       inputs = {'y', 200, 'z', 300};
%       [x,y,z,state,tol] = assignArgs( defaults, inputs, 'Expand', true, 'Required', {'x'});
%       --> error: Required argument x is missing.
%
%       inputs = {'x', 'state', '-tol', 'tol', '-state', 'thinking'};
%       [x,y,z,state,tol] = assignArgs( defaults, inputs, 'Expand', true, 'Prefix', '-');
%       --> x == 'x'
%       --> y == 'state'
%       --> z == 3
%       --> state == 'thinking'
%       --> tol = 'tol'

%   Author: Nezar Abdennur <nabdennur@gmail.com>
%   Created: 2012-05-25

import ArgUtils.*

% Parse the options
options.Required = {};
options.Prefix = '';
options.Expand = false;
if ~isempty(varargin)
    options = updateFieldValues(options, tostruct(varargin));
end

% Initialize target fields
target_struct = defaults;
target_names = fieldnames(target_struct);

% Start assigning non-keyword args until we detect a keyword
kwargs = {};
assigned = java.util.HashSet();
for i = 1:length(args_kwargs)
    arg = args_kwargs{i};
    
    if ischar(arg)
        if options.Prefix
            % Check for prefix
            if hasPrefix(arg, options.Prefix);
                % treat everything as kwargs from here on
                kwargs = args_kwargs(i:end);
                break;
            end
        else
            % Look for keyword match
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
    
    target_struct.(target_names{i}) = arg;
    assigned.add(target_names{i});
end

% Assign keyword args
if ~isempty(kwargs)
    if rem(length(kwargs),2)~=0
        error('assignArgs:NameValueMismatch',...
              'Keyword arguments must be given as name-value pairs.');
    end
    
    for i = 1:2:length(kwargs)
        kwarg = kwargs{i};
        
        if options.Prefix
            kwarg = stripPrefix(kwarg, options.Prefix);
        end
        
        try
            name = validatestring(kwarg, target_names);
        catch exception
            if ~ischar(kwarg)
                error('assignArgs:InvalidKeyword',...
                      'Invalid keyword. Expected string, instead got %s.', class(kwargs{i}));
            else
                error('assignArgs:KeywordNoMatch',...
                      'The name %s did not match any argument keywords', name);
            end
        end

        if assigned.contains(name)
            error('assignArgs:DoubleAssignment',...
                  'Got multiple values for keyword %s', name);
        else
            target_struct.(name) = kwargs{i+1};
            assigned.add(name);
        end
    end
end

% Check requirements
if ~isempty(options.Required)
    for i = 1:length(options.Required)
        if ~assigned.contains(options.Required{i})
            error('assignArgs:MissingRequirement',...
                  'Required argument %s is missing', options.Required{i});
        end
    end
end

% Output
if options.Expand
    if ~nargout
        % assign variables in caller the dirty way
        for i = 1:length(target_struct)
            assignin('caller', target_names{i}, target_struct.(target_names{i}));
        end
    else
        % return target values individually
        target_vars = struct2cell(target_struct);
        [varargout{1:nargout}] = target_vars{:};
    end
else
    % return target variables as fields of a stuct
    varargout{1} = target_struct;
end

end