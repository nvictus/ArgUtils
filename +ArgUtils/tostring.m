function str = tostring(obj)

if isscalar(obj)
    if isnumeric(obj)
        str = num2str(obj);
    elseif islogical(obj)
        if obj
            str = 'true';
        else
            str = 'false';
        end
    elseif ischar(obj)
        str = sprintf('''%s''', obj);
    elseif iscell(obj)
        str = '[1x1 cell]';
    elseif isstruct(obj)
        str = '[1x1 struct]';
    else
        str = sprintf('[1x1 %s]', class(obj));
    end
elseif ischar(obj)
    if isrow(obj) && length(obj) <= 30
        str = sprintf('''%s''', obj);
    else
        str = '[string]';
    end
else
    [m,n] = size(obj);
    str = sprintf('[%dx%d %s]', m, n, class(obj));
end
        

end