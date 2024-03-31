local TAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------
local PlantRegrowth = require("components/plantregrowth")

local time_multipliers = {
    palmtree = function()
        return TUNING.PALMTREE_REGROWTH_TIME_MULT * ((TheWorld.state.iswinter and 0) or 1)
    end,
    jungletree = function()
        return TUNING.JUNGLETREE_REGROWTH_TIME_MULT * ((TheWorld.state.iswinter and 0) or 1)
    end,
    mangrovetree = function()
        return TUNING.MANGROVETREE_REGROWTH_TIME_MULT *
        ((TheWorld.state.issummer and 3) or (TheWorld.state.isautumn and 2) or (TheWorld.state.iswinter and 0) or 1)
    end,
}

for i, v in pairs(time_multipliers) do
    PlantRegrowth.TimeMultipliers[i] = v
end
