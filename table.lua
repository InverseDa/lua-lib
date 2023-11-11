-- 深拷贝
table.deepcopy = function(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = table.deepcopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end