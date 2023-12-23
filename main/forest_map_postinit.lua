-- require("map/ocean_gen_new") -------------啊？

local function HackGenChecksForIslands()
    local generate_fn = GLOBAL.require("map/forest_map").Generate

    local SKIP_GEN_CHECKS, SKIP_GEN_CHECKS_index = Getupvalue(generate_fn, "SKIP_GEN_CHECKS")

    Setupvalue(generate_fn, SKIP_GEN_CHECKS_index, true)
end

HackGenChecksForIslands()
