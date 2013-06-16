function tf = hasPrefix(str, prefix)

k = length(prefix);
n = length(str);
if k < n
    tf = strcmp(str(1:k), prefix);
else
    tf = false;
end

end