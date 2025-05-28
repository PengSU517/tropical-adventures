AddComponentPostInit("finiteuses", function(cmp)
    local function oncurrentchange()
        local repairable = cmp.inst.components.repairable
        if repairable then
            repairable:SetFiniteUsesRepairable(cmp.current < cmp.total)
        elseif cmp.inst.components.forgerepairable ~= nil then
            cmp.inst.components.forgerepairable:SetRepairable(cmp.current < cmp.total)
        end

        if cmp.inst.components.armor then
            cmp.inst.components.armor.condition = cmp.current
        end
        cmp.inst:PushEvent("percentusedchange", { percent = cmp:GetPercent() })
    end

    addsetter(cmp, "current", oncurrentchange)
end)
