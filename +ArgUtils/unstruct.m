function nvpairs = unstruct(s)

nvpairs = reshape([fieldnames(s), struct2cell(s)]', 1,[]);