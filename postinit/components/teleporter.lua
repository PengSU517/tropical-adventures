local Teleporter = require "components/teleporter"
local Util = require "tools/utils"
local interior = resolvefilepath("images/colour_cubes/pigshop_interior_cc.tex")
local batvision = resolvefilepath("images/colour_cubes/bat_vision_on_cc.tex")

local OVERRIDE_SEASON_COLOURCUBES = {
    interior = {
        day = interior,
        dusk = interior,
        night = interior,
        full_moon = interior

    },
    batvision = {
        day = batvision,
        dusk = batvision,
        night = batvision,
        full_moon = batvision
    },
}

local VISION_PHASEFN = {
    interior = {
        blendtime = 0.5,
        events = {},
        fn = nil,
    },
}

local HAMROOM_NIGHTVISION_NAME = "tropical.inhamroom"
local function ToggleNightVision(inst)
    inst = inst or ThePlayer
    if not inst then return end
    inst:DoTaskInTime(.5, function()
        if inst:IsInHamRoom() then
            inst.components.playervision:PushForcedNightVision(HAMROOM_NIGHTVISION_NAME, 1,
                OVERRIDE_SEASON_COLOURCUBES.interior, true)
        else
            inst.components.playervision:PopForcedNightVision(HAMROOM_NIGHTVISION_NAME)
        end
    end)
end


AddClientModRPCHandler("tropical_adventures", "player.teleport", ToggleNightVision)

Util.FnDecorator(Teleporter, "Teleport", nil, function(rets, self, obj)
    if obj ~= nil and obj:HasTag("player") then
        ToggleNightVision(obj)
        SendModRPCToClient(GetClientModRPC("tropical_adventures", "player.teleport"), obj)
    end
    return rets
end)
