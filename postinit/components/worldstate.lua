local upvaluehelper = require("tools/upvaluehelper")

AddComponentPostInit("worldstate", function(self, inst)
    --------------------------------------------------------------------------
    --[[ Member variables ]]
    --------------------------------------------------------------------------
    assert(inst == TheWorld, "Invalid world")

    -- Private
    local data = self.data

    --------------------------------------------------------------------------
    --[[ Private member functions ]]
    --------------------------------------------------------------------------

    ----竟然有现成的函数hook这个东西
    local OnTemperatureTick = inst:GetEventCallbacks("temperaturetick", TheWorld, "scripts/components/worldstate.lua")
    local SetVariable = upvaluehelper.Get(OnTemperatureTick, "SetVariable")

    --------------------------------------------------------------------------
    --[[ Private event handlers ]]
    --------------------------------------------------------------------------

    local function OnAporkalypseChange(src, phase)
        -- print("aporkalypse world state changed:", phase)
        SetVariable("aporkalypse", phase)
        SetVariable("isaporkalypsecalm", phase == "calm", "aporkalypsecalm")
        SetVariable("isaporkalypsenear", phase == "near", "aporkalypsenear")
        SetVariable("isaporkalypse", phase == "aporkalypse", "aporkalypse")
        SetVariable("isfiesta", phase == "fiesta", "fiesta")
    end


    --------------------------------------------------------------------------
    --[[ Initialization ]]
    --------------------------------------------------------------------------
    data.isaporkalypsecalm = true
    data.isaporkalypsenear = false
    data.isaporkalypse = false
    data.isfiesta = false


    inst:ListenForEvent("aporkalypsephasechanged", OnAporkalypseChange)
end)
