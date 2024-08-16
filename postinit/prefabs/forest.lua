AddPrefabPostInit("forest", function(inst)
    if GLOBAL.TheWorld.ismastersim then    --------------这是检测服务器还是客户端
        inst:AddComponent("parrotspawner") ----不是有birdspawner了吗 -----这个东西很复杂--海浪在这里
        inst:AddComponent("economy")
        inst:AddComponent("contador")

        if TUNING.tropical.sealnado then
            inst:AddComponent("twisterspawner")
        end

        inst:AddComponent("roottrunkinventory") ---------------这个是啥啊
        -- inst:AddComponent("aporkalypse")
        inst:AddComponent("tropicalgroundspawner")
        inst:AddComponent("tropicalspawner")
        inst:AddComponent("whalehunter")
        inst:AddComponent("rainbowjellymigration")
        -- inst:AddComponent("shadowmanager")
        inst:AddComponent("quaker_interior") ------------这是啥

        if TUNING.tropical.roc then
            inst:AddComponent("rocmanager")
        end
    end
end)

AddPrefabPostInit("cave", function(inst)
    if GLOBAL.TheWorld.ismastersim then
        -- inst:AddComponent("economy")
        -- inst:AddComponent("contador")
        if TUNING.tropical.aporkalypse then
            inst:AddComponent("aporkalypse")
        end
    end
end)
