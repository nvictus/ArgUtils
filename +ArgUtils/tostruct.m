function s = tostruct(varargin)
% Because MATLAB's struct API is a disaster
%   Converts a sequence or cell-array of name-value pairs into a scalar
%   struct
%
%   Example:
%       >> nv = {'a', 1, 'b', 2};
%       >> s = tostruct(nv);
%              s.a==1
%              s.b==2
%
%       >> s = tostruct('a', 1, 'b', {2}, 'c', {3,4,5});
%              s.a==1
%              s.b=={2}
%              s.c=={3,4,5}
%
%    Compare these to what struct() does!

if nargin == 1 && iscell(varargin{1})
    varargin = varargin{1};
end

s = struct();
for i = 1:2:length(varargin)
    s.(varargin{i}) = varargin{i+1};
end

end