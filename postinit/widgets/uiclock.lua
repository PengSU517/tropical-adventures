local UIClock = require "widgets/uiclock"
local Util = require "tools/utils"

Util.FnDecorator(UIClock, "_ctor", nil, function(rets, clock)
    if not clock._cave then
        clock.inst:ListenForEvent("aporkalypsephasechanged", function(_, phase)
            if phase == "aporkalypse" then
                clock:ShowMoon()
                clock:OnClockSegsChanged()
            else
                local _phase = clock._phase
                clock._phase = nil
                clock:OnPhaseChanged(_phase)
                if TheWorld.net then
                    TheWorld.net:PushEvent("segsdirty")
                end
            end
        end, TheWorld)
    end
    return rets
end)

Util.FnDecorator(UIClock, "ShowMoon", function(clock)
    if TheWorld.state.isaporkalypse then
        clock._moonanim:GetAnimState():OverrideSymbol("swap_moon", "moon_aporkalypse_phases", "moon_full")
        clock._moonanim:GetAnimState():PlayAnimation("idle")
        clock._moonanim:Show()
        return nil, true
    end
end)

Util.FnDecorator(UIClock, "OnClockSegsChanged", function(clock, _data, ...)
    if TheWorld.state.isaporkalypse then
        return nil, nil, { clock, { night = 16 }, ... }
    end
end)
