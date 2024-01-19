-- require("map/ocean_gen_new") -------------啊？
function GLOBAL.Getupvalue(func, name)
    local debug = GLOBAL.debug
    local i = 1
    while true do
        local n, v = debug.getupvalue(func, i)
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
    local debug = GLOBAL.debug
    debug.setupvalue(func, ind, value)
end


local function HackGenChecksForIslands()
    local generate_fn = GLOBAL.require("map/forest_map").Generate

    local SKIP_GEN_CHECKS, SKIP_GEN_CHECKS_index = Getupvalue(generate_fn, "SKIP_GEN_CHECKS")

    Setupvalue(generate_fn, SKIP_GEN_CHECKS_index, true)
end

HackGenChecksForIslands()
