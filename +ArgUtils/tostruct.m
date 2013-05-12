function s = tostruct(varargin)
% because MATLAB's struct constructor is a disaster

if nargin == 1 && iscell(varargin{1})
    varargin = varargin{1};
end

s = struct();
for i = 1:2:length(varargin)
    s.(varargin{i}) = varargin{i+1};
end

end