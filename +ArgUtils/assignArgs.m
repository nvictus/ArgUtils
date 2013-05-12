function varargout = assignArgs( defaults, args_kwargs, varargin )
%ASSIGNARGS Assign arguments and default values to target variables
%   Input:
%       defaults    - struct of target variable defaults
%       args_kwargs - cell-array of (args followed by) kwargs
%       
%   Options:
%       Required    - cell-array of required arg names
%       Prefix      - string
%       Expand      - boolean
%
%   Returns:
%   	if Expand==False:
%           The target variables are returned as fields of a struct with
%           the same field names as the defaults struct. 
%       if Expand==True:
%           The target variables are returned individually the same order
%           the fields were sorted in the defaults struct.
import ArgUtils.*

% Parse the options
options.Required = {};
options.Prefix = '';
options.Expand = false;
if ~isempty(varargin)
    options = assignFields(options, tostruct(varargin));
end

% Initialize target fields
target_struct = defaults;
target_names = fieldnames(target_struct);

% Start assigning non-keyword args until we detect a keyword
kwargs = {};
assigned = {};
for i = 1:length(args_kwargs)
    arg = args_kwargs{i};
    
    if ischar(arg)
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
    
    target_struct.(target_names{i}) = arg;
    assigned{i} = target_names{i};
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

        if strcmp(name, assigned)
            error('assignArgs:DoubleAssignment',...
                  'Got multiple values for keyword %s', name);
        else
            target_struct.(name) = kwargs{i+1};
            assigned{end+1} = name;
        end
    end
end

% Check requirements
if ~isempty(options.Required)
    for i = 1:length(options.Required)
        if ~ismember(options.Required{i}, assigned)
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