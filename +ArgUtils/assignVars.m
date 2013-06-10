function varargout = assignVars( defaults, inputs )
% ASSIGNVARS Assign input and default values to target variables
%   The target variables for assignment are typically the implicit parameters
%   of a calling function that uses "varargin".
%   
%   Input:
%       defaults - cell_array containing default values for all of the target variables
%       inputs   - cell_array of input values to assign
%
%   Returns:
%       comma-separated list of correctly assigned values for all of the target variables
%
%   Examples:
%       input = {'alpha', 'bravo'};
%       [x,y,z] = assignVars({1,2,3}, input);
%       --> x == 'alpha'
%       --> y == 'bravo'
%       --> z == 3
%
%       input = {'alpha', [], 'charlie'};
%       [x,y,z] = assignVars({1,2,3}, input);
%       --> x == 'alpha'
%       --> y == 2
%       --> z == 'charlie'     
%
%       defaults = {1,2,3};
%       [x,y,z] = assignVars(defaults, varargin);
%
%   Assignment follows these rules:
%   1) Each target variable will be assigned a matching value from inputs
%      in the sequence provided.
%   2) A target variable whose matching input is [] will be assigned its
%      default value.
%   3) If length(inputs) is less than the number of target variables, the
%      remaining unmatched target variables will be assigned their default
%      values.

%   Author: Nezar Abdennur <nabdennur@gmail.com>
%   Created: 2012-05-25

import ArgUtils.*

num_inputs = length(inputs);
num_targets = length(defaults);
if num_inputs > num_targets
    error(ArgUtils.TypeError, 'More input values than assignment targets');
end
if nargout > num_targets
    error(ArgUtils.TypeError, 'More assignment targets than default values');
end

varargout = defaults;
idx = ~cellfun('isempty', inputs); %order of magnitude faster than @isempty
varargout(idx) = inputs(idx);

