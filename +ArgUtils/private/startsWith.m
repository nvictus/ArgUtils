function tf = startsWith(str, prefix)

k = length(prefix);
n = length(str);

if k <= n
    if k == 0
        tf = true;
    else
        tf = strcmp(str(1:k), prefix);
    end
else
    tf = false;
end


end