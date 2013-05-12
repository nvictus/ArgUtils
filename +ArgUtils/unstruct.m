function nvlist = unstruct(s)

nvlist = reshape([fieldnames(s), struct2cell(s)]', 1,[]);