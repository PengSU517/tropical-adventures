AddPrefabPostInit("forest", function(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst:AddComponent("parrotspawner") ----不是有birdspawner了吗
        inst:AddComponent("economy")
        inst:AddComponent("shadowmanager")
        inst:AddComponent("contador")

        if TUNING.tropical.sealnado then
            inst:AddComponent("twisterspawner")
        end

        if GetModConfigData("kindofworld") == 5 or GetModConfigData("Hamlet") ~= 5 then
            inst:AddComponent("roottrunkinventory")
        end

        if GetModConfigData("kindofworld") ~= 10 and (GetModConfigData("kindofworld") == 5 or GetModConfigData("Hamlet") ~= 5 and GetModConfigData("pigruins") ~= 0 and GetModConfigData("aporkalypse") == true) then
            inst:AddComponent("aporkalypse")
        end

        if GetModConfigData("kindofworld") ~= 10 and GetModConfigData("Hamlet") ~= 5 then
            inst:AddComponent("tropicalgroundspawner")
        end
        -- if GetModConfigData("kindofworld") == 15 or GetModConfigData("kindofworld") == 10 or GetModConfigData("kindofworld") == 20 then
        -- 	if GetModConfigData("aquaticcreatures") then
        inst:AddComponent("tropicalspawner")
        inst:AddComponent("whalehunter")
        inst:AddComponent("rainbowjellymigration")
        -- 	end
        -- end
        if GetModConfigData("kindofworld") == 5 then
            inst:AddComponent("shadowmanager")
            inst:AddComponent("rocmanager")
        end



        if GetModConfigData("kindofworld") ~= 10 then
            inst:AddComponent("quaker_interior")
        end

        --if TUNING.tropical.springflood or TUNING.tropical.kindofworld == 10 then	inst:AddComponent("floodspawner") end				
    end
end)
