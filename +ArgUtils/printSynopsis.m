function printSynopsis(default_args)
import ArgUtils.*

fprintf('\n ');

names = fieldnames(default_args);
for i =  1:length(names)-1
    fprintf( '%s', names{i});
    default = default_args.(names{i});
    if ~isempty(default)
        fprintf('=%s', tostring(default));
    end
    fprintf(',\n ');
end
fprintf('%s', names{end});
default = default_args.(names{end});
if ~isempty(default)
    fprintf('=%s', tostring(default));
end


end

