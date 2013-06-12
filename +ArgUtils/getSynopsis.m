function s = getSynopsis(default_args, required)
import ArgUtils.*

if ~exist('required','var') || isempty(required)
    required = {};
end
required = toHashSet(required);
names = fieldnames(default_args);

fprintf('\n ');

str = evalc('disp(default_args)');
s = regexp(str, '\n', 'split');
s = s(1:end-2);
for i = 1:length(s)
    s{i} = strtrim(s{i});
    if required.contains(names{i})
        j = find(s{i}==':', 1, 'first');
        s{i}(j+1:end) = [];
        s{i} = [s{i}, ' <required>'];
    end
end

end

function set = toHashSet(cell_array)

set = java.util.HashSet();
for i = 1:length(cell_array)
    set.add(cell_array{i});
end 

end