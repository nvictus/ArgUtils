function options = assignFields(defaults, inputs)

options = defaults;
option_names = fieldnames(options);

input_names = fieldnames(inputs);
for i = 1:length(input_names)
    try
        name = validatestring(input_names{i}, option_names);
    catch exception
            error('assignOptions:KeywordFieldMismatch',...
                  'Did not find a match for keyword %s.\n', input_names{i});
    end
    options.(name) = inputs.(input_names{i});
end

end