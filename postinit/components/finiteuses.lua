AddComponentPostInit("finiteuses", function(cmp)
    local function oncurrentchange()
        if cmp.inst.components.armor then
            cmp.inst.components.armor.condition = cmp.current
        end
        cmp.inst:PushEvent("percentusedchange", { percent = cmp:GetPercent() })
    end

    addsetter(cmp, "current", oncurrentchange)
end)
