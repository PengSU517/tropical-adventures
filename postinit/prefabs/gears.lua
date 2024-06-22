AddPrefabPostInit("gears", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 480
    inst.components.fuel.fueltype = "REPARODEBARCO"
end)
