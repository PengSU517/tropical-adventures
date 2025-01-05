AddPrefabPostInit("mosquitosack", function(inst)
    if not GLOBAL.TheWorld.ismastersim then return end

    inst:AddComponent("fuel")
    inst.components.fuel.fueltype = FUELTYPE.BLOOD  --新燃料值：血，可以用蚊子血嚢给蝙蝠帽回耐久
    inst.components.fuel.fuelvalue = TUNING.TOTAL_DAY_TIME * .5
end)