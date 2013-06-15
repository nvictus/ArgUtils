function updated = updateFieldValues(defaults, inputs, assigned)
% 'assigned' is a reference to a java hash set
import ArgUtils.*
updated = defaults;
field_names = fieldnames(defaults);

input_names = fieldnames(inputs);
for i = 1:length(input_names)
    try
        name = validatestring(input_names{i}, field_names);
    catch e
        error(ArgUtils.KeyError,...
              'Did not find a match for keyword %s.', input_names{i});
    end
    updated.(name) = inputs.(input_names{i});
    assigned.add(name);
end

end