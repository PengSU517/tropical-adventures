GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
function GLOBAL.Getupvalue(func, name)
    local Debug = debug
    local i = 1
    while true do
        local n, v = Debug.getupvalue(func, i)
        if not n then
            return nil, nil
        end
        if n == name then
            return v, i
        end
        i = i + 1
    end
end

function GLOBAL.Setupvalue(func, ind, value)
    local Debug = debug
    Debug.setupvalue(func, ind, value)
end
