function str = stripPrefix(str, prefix)

k = length(prefix);
if startsWith(str, prefix)
    str = str(k+1:end);
end

end