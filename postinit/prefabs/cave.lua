AddPrefabPostInit("cave", function(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst:AddComponent("roottrunkinventory")
        inst:AddComponent("quaker_interior")
        inst:AddComponent("economy")
        inst:AddComponent("contador")
    end
end)
