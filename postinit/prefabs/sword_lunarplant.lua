AddPrefabPostInit("sword_lunarplant", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local tool = inst:AddComponent("tool")
    tool:SetAction(ACTIONS.HACK, 1.5)

    inst.components.finiteuses:SetConsumption(ACTIONS.HACK, 2/3)

end)