function str = stripPrefix(str, prefix)

k = length(prefix);
if strcmp(str(1:k), prefix)
    str = str(k+1:end);
end

end