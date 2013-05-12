function updated = updateFieldValues(defaults, inputs)

updated = defaults;
target_names = fieldnames(updated);

input_names = fieldnames(inputs);
for i = 1:length(input_names)
    try
        name = validatestring(input_names{i}, target_names);
    catch exception
            error('assignOptions:KeywordFieldMismatch',...
                  'Did not find a match for keyword %s.\n', input_names{i});
    end
    updated.(name) = inputs.(input_names{i});
end

end