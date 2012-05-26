function [args, pvargs] = splitvarargin( varargs )
% SPLITVARARGIN Split variable input arguments into two sets: unparameterized and parameterized
%   ARGS are "unparameterized" optional arguments passed in prior to
%   parameterized arguments.
%   PVARGS are "parameterized" arguments passed in as name-value pairs or
%   as a single struct.
%
%   To determine the separation, the first string or struct encountered in 
%   the argument list signals the beginning of a set of parameterized 
%   arguments. Anything before that is considered unparameterized.
%
%   If the first element encountered is:
%   1) string: It is interpreted as the beginning of a comma-separated list
%      of name-value pairs and returned as-is, as a cell array.
%   2) struct: It is interpreted as a mapping of names to values and is 
%      returned as a cell array of name-value pairs.
%
%   Because string and struct input arguments delimit unparameterized from 
%   parameterized arguments in a varargin sequence, the following 
%   restriction must be followed or the results will be unpredictable:
%
%   *Unparameterized optional input arguments cannot be char or struct*
%
%   See also PROCESSARGS, PROCESSPVARGS

%   Author: Nezar Abdennur <nabdennur@gmail.com>
%   Created: 2012-05-25

pvidx = find(cellfun(@(x) isstruct(x) || ischar(x), varargs), 1, 'first');

if pvidx
    args = varargs(1:pvidx-1);
    if ischar(varargs{pvidx})
        pvargs = varargs(pvidx:end);
    else
        pvargs = reshape([fieldnames(varargs{pvidx}), ...
                          struct2cell(varargs{pvidx})]', 1,[]);
    end
else
    args = varargs;
    pvargs = varargs(1:0);
end

end