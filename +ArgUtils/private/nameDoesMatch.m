function tf = nameDoesMatch(name, list)

tf = false;
try
    validatestring(name, list);
    tf = true;
end

end