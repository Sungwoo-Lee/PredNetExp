% Inline ternary operator to convert boolean to 'yes' or 'no'
function result = convertBooleanToYesNo(value)
    if value
        result = 'Yes';
    else
        result = 'No';
    end
end