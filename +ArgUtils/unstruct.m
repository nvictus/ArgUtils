function nv = unstruct(s)
% Unpack a struct into a cell-array of name-value pairs.
%   Note that struct2cell only returns values, not field names.
%
%   Designed to make scalar structs and cell-arrays interchangeable through
%   the reciprocal relationship:
%       nv = unstruct(tostruct(nv)) -or- unstruct(tostruct(nv{:}))
%       s  = tostruct(unstruct(s));
%
%   Example:
%       >> s.a = 1;
%       >> s.b = 2;
%       >> nv = unstruct(s)
%              nv=={'a', 1, 'b', 2}       

nv = reshape([fieldnames(s), struct2cell(s)]', 1,[]);