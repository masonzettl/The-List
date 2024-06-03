-- Converts a boolean value to an integer value (1 for true, 0 for false)
function boolToNum(bool)
    return bool and 1 or 0
end

-- Loops through the table to see if it contains the given value
function tableContains(table, value)
    for i=1, #table do
        if table[i] == value then
            return true
        end
    end

    return false
end

function tableCount(table)
    local count = 0
    for k, v in pairs(table) do
        count += 1
    end
    return count
end