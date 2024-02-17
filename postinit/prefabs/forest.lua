AddPrefabPostInit("forest", function(inst)
    if GLOBAL.TheWorld.ismastersim then --------------这是检测服务器还是客户端
        -- inst:AddComponent("parrotspawner") ----不是有birdspawner了吗 -----这个东西很复杂
        inst:AddComponent("economy")
        inst:AddComponent("contador")

        inst:AddComponent("twisterspawner")
        inst:AddComponent("roottrunkinventory") ---------------这个是啥啊
        -- inst:AddComponent("aporkalypse")
        inst:AddComponent("tropicalgroundspawner")
        inst:AddComponent("tropicalspawner")
        inst:AddComponent("whalehunter")
        inst:AddComponent("rainbowjellymigration")
        inst:AddComponent("shadowmanager")
        inst:AddComponent("rocmanager")
        inst:AddComponent("quaker_interior") ------------这是啥
    end
end)

AddPrefabPostInit("cave", function(inst)
    -- inst:AddComponent("economy")
    -- inst:AddComponent("contador")
    inst:AddComponent("aporkalypse")
end)
