function nvlist = unstruct(s)
% Unpack a struct into a name-value cell array. (struct2cell only returns values)
%   Designed to make scalar structs and cell arrays interchangeable through
%   the reciprocal relationship:
%       --> nvlist = unstruct(tostruct(nvlist)) -or- unstruct(tostruct(nvlist{:}))
%       --> s      = tostruct(unstruct(s));

nvlist = reshape([fieldnames(s), struct2cell(s)]', 1,[]);