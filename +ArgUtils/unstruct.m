function nvlist = unstruct(s)
% because struct2cell only returns values
%   Unpack a struct into a comma-separated name-value list.
%   Designed to make structs and cell arrays interchangeable through the 
%   reciprocal relationship:
%       --> nvlist = unstruct(tostruct(nvlist))
%       --> s      = tostruct(unstruct(s));

nvlist = reshape([fieldnames(s), struct2cell(s)]', 1,[]);