AddPrefabPostInit("forest", function(inst)
    if TheWorld.ismastersim then
        inst:AddComponent("climatespawner") -----这个东西很复杂--海浪在这里
        inst:AddComponent("economy")
        inst:AddComponent("contador")
        inst:AddComponent("bigfooter")
        inst:AddComponent("roottrunkinventory") ---------------这个是啥啊
        inst:AddComponent("creature_spawner")   ----不只有生物，还有旋涡，天光之类的内容
        -- inst:AddComponent("tropicalspawner")
        inst:AddComponent("whalehunter")
        inst:AddComponent("rainbowjellymigration")
        inst:AddComponent("quaker_interior") ------------这是啥


        if TUNING.sealnado then
            inst:AddComponent("twisterspawner")
        end


        if TUNING.hamlet then
            inst:AddComponent("banditmanager")

            if TUNING.roc then
                inst:AddComponent("rocmanager")
            end
        end
    end
end)


AddPrefabPostInit("cave", function(inst)
    if TheWorld.ismastersim then
        inst:AddComponent("roottrunkinventory")
        inst:AddComponent("quaker_interior")
        inst:AddComponent("economy")
        inst:AddComponent("contador")
    end
end)

AddPrefabPostInitAny(function(inst)
    if not TheWorld or TheWorld.net ~= inst then
        return
    end

    if TUNING.aporkalypse then
        print("add aporkalypse in world net")
        inst:AddComponent("aporkalypse")
    else
        print("not add aporkalypse in world net")
    end
end)


AddPrefabPostInit("forest_network", function(inst)
    print("print forest_network", inst)
    inst:AddComponent("weatherham")
end)
