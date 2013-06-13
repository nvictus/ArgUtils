function varargout = assignVars( defaults, inputs )
% ASSIGNVARS Assign input and default values to a sequence of target variables
%   Each target variable will be assigned a matching value from
%   the defaults sequence unless overriden by a value from the inputs
%   sequence. The number of outputs is the number of default values
%   provided.
%   
%   This function is useful for assigning values to the implied parameters
%   of a function that uses "varargin".
%   
%   Input:
%       defaults - sequence of default values (cell-array)
%       inputs   - sequence of overriding input values (cell-array)
%
%   Returns:
%       sequence of correctly assigned values
%
%   The matching input overrides the default, unless:
%   1) If the matching input is [], the target variable will be assigned
%      the default value.
%   2) If length(inputs) < length(defaults), the remaining unmatched target
%      variables will be assigned their default values.
%
%   Examples:
%       >> input = {'alpha', 'bravo'};
%       >> [x,y,z] = assignVars({1,2,3}, input);
%       	x == 'alpha'
%       	y == 'bravo'
%       	z == 3
%
%       >> input = {'alpha', [], 'charlie'};
%       >> [x,y,z] = assignVars({1,2,3}, input);
%       	x == 'alpha'
%       	y == 2
%       	z == 'charlie'     
%
%       function fooBar(varargin)
%           defaults = {1,2,3};
%           [x,y,z] = assignVars(defaults, varargin);

%   Author: Nezar Abdennur <nabdennur@gmail.com>
%   Created: 2012-05-25

import ArgUtils.*

num_inputs = length(inputs);
num_targets = length(defaults);
if num_inputs > num_targets
    error(ArgUtils.TypeError, 'More input values than default values');
end
if nargout > num_targets
    error(ArgUtils.TypeError, 'More assignment targets than default values');
end

varargout = defaults;
idx = ~cellfun('isempty', inputs); %order of magnitude faster than @isempty (see comments in http://blogs.mathworks.com/loren/2009/05/05/nice-way-to-set-function-defaults/)
varargout(idx) = inputs(idx);

