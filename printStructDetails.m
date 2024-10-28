function printStructDetails(structName, structData)
    disp('============================================================');
    fprintf(' *** %s ***\n', upper(structName));
    disp('============================================================');
    
    structFields = fieldnames(structData);
    for i = 1:numel(structFields)
        fieldValue = structData.(structFields{i});
        
        if isnumeric(fieldValue) && numel(fieldValue) == 1
            fprintf(' %-30s: %.2f\n', structFields{i}, fieldValue);
        elseif ischar(fieldValue)
            fprintf(' %-30s: %s\n', structFields{i}, fieldValue);
        elseif islogical(fieldValue)
            fprintf(' %-30s: %s\n', structFields{i}, convertBooleanToYesNo(fieldValue));
        elseif isnumeric(fieldValue) && numel(fieldValue) > 1
            fprintf(' %-30s: %s\n', structFields{i}, mat2str(fieldValue));
        elseif isstruct(fieldValue)
            % Recursively print struct fields
            fprintf(' %-30s:\n', structFields{i});
            printStructDetails(structFields{i}, fieldValue);  % Recursively handle sub-structs
        else
            fprintf(' %-30s: [Complex Data Type]\n', structFields{i});
        end
    end
end