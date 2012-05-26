function varargout = processargs( args, defaults )
% PROCESSARGS Process unparameterized optional input arguments against a set of defaults
%   Unparameterized optional input arguments are ordered and identified by
%   their position in the calling sequence. The following conventions are
%   used:
%   1) Any unparameterized arguments not included in the calling sequence 
%      are assigned their default values.
%   2) Any unparameterized arguments passed in as [] are assigned their
%      default value. So unparameterized arguments cannot be assigned empty
%      values by a caller (but these are permitted as default values). 
%
%   See also SPLITVARARGIN

%   Author: Nezar Abdennur <nabdennur@gmail.com>
%   Created: 2012-05-25


num_args = length(args);
num_supported = length(defaults);
if num_args > num_supported
    error('processargs:TooManyInputs', 'Too many optional input arguments');
end

varargout = defaults;
idx = find(~cellfun(@isempty, args));
varargout(idx) = args(idx);

