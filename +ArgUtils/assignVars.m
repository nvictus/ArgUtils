function varargout = assignVars( defaults, args )
% ASSIGNARGS Assign non-keyword arguments and default values to target variables
%   The target variables for assignment are typically implicit parameters
%   of a calling function that uses "varargin".
%   
%   Input:
%       args     - cell-array of input arguments to assign (from the calling function)
%       defaults - cell-array containing default values for all of the target variables
%
%   Returns:
%       cell-array containing updated values for all of the target variables
%
%   Arguments are processed as follows:
%   1) Each target variable will be assigned a matching value from args in 
%      the sequence provided.
%   2) A target variable whose matching arg is [] will be assigned its
%      default value.
%   3) If length(args) is less than the number of target variables, the
%      remaining unmatched target variables will be assigned their default
%      values.

%   Author: Nezar Abdennur <nabdennur@gmail.com>
%   Created: 2012-05-25


num_args = length(args);
num_targets = length(defaults);
if num_args > num_targets
    error('assignArgs:TooManyInputs', 'Too many input arguments');
end
if nargout > num_targets
    error('assignArgs:TooManyOutputs', 'More target variables than default values');
end

varargout = defaults;
idx = find(~cellfun(@isempty, args));
varargout(idx) = args(idx);

