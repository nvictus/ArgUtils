function str = tostring(obj)

if ismatrix(obj)

    if isempty(obj) && all(size(obj)) == 0
        if isnumeric(obj)
            str = '[]';
        elseif islogical(obj)
            str = 'logical([])';
        elseif ischar(obj)
            str = '''''';
        elseif iscell(obj)
            str = '{}';
        elseif isstruct(obj)
            str = '<0x0 struct>';
        else
            str = sprintf('<0x0 %s>', class(obj));
        end

    elseif isscalar(obj)
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
            str = '<1x1 cell>';
        elseif isstruct(obj)
            str = '<1x1 struct>';
        else
            str = sprintf('<1x1 %s>', class(obj));
        end

    elseif ischar(obj) && isrow(obj) && length(obj) <= 30
        str = sprintf('"%s"', obj);

    else
        [m,n] = size(obj);
        str = sprintf('<%dx%d %s>', m, n, class(obj));
    end

else 
    sz = num2cell(size(obj));
    str = ['<' num2str(sz{1})];
    for i = 2:length(sz)
        str = [str, 'x', num2str(sz{i})];
    end
    str = [str, ' ', class(obj), '>'];
end            

end