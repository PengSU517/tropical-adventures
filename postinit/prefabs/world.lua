AddPrefabPostInit("forest", function(inst)
    if TheWorld.ismastersim then
        inst:AddComponent("parrotspawner") -----这个东西很复杂--海浪在这里
        inst:AddComponent("economy")
        inst:AddComponent("contador")
        inst:AddComponent("bigfooter")
        inst:AddComponent("roottrunkinventory") ---------------这个是啥啊
        inst:AddComponent("tropicalgroundspawner")
        inst:AddComponent("tropicalspawner")
        inst:AddComponent("whalehunter")
        inst:AddComponent("rainbowjellymigration")
        inst:AddComponent("quaker_interior") ------------这是啥


        if TUNING.tropical.sealnado then
            inst:AddComponent("twisterspawner")
        end

        if TUNING.tropical.roc then
            inst:AddComponent("rocmanager")
        end

        -- if TUNING.tropical.aporkalypse then
        --     inst:AddComponent("aporkalypse")
        -- end
    end
end)


AddPrefabPostInit("cave", function(inst)
    if TheWorld.ismastersim then
        inst:AddComponent("roottrunkinventory")
        inst:AddComponent("quaker_interior")
        inst:AddComponent("economy")
        inst:AddComponent("contador")

        -- if TUNING.tropical.aporkalypse then
        --     inst:AddComponent("aporkalypse")
        -- end
    end
end)

AddPrefabPostInitAny(function(inst)
    if not TheWorld or TheWorld.net ~= inst then
        return
    end

    inst:AddComponent("aporkalypse")
end)
