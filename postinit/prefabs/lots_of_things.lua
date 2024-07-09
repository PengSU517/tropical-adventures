local AddPrefabPostInit = AddPrefabPostInit

for _, prefab in pairs({ "skeleton", "skeleton_player" }) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        local function ondropped(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            if x and y and z then
                if (TheWorld.Map:IsOceanTileAtPoint(x, 0, z)) then
                    inst:DoTaskInTime(0.5, function(inst)
                        local bolha = SpawnPrefab("frogsplash")
                        if bolha then
                            bolha.Transform:SetPosition(x, y, z)
                        end
                        inst:Remove()
                    end)
                end
            end
        end
        inst:DoTaskInTime(0, ondropped)
    end)
end

for _, prefab in pairs({ "ash" }) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("fertilizer")
    end)
end


for _, prefab in pairs({ "anchor" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("ancora")
    end)
end



for _, prefab in pairs({ "gogglesnormalhat", "gogglesheathat", "gogglesarmorhat", "gogglesshoothat", "bathat", "pithhat", "armor_weevole" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("velocidadenormal")
    end)
end

------------------------para a onda quebrar--------------

for _, prefab in pairs({ "cave_entrance_open", "cave_entrance_vulcao" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("teleportapracaverna")
    end)
end

for _, prefab in pairs({ "cave_exit", "cave_exit_vulcao" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("teleportaprafloresta")
    end)
end

for _, prefab in pairs({ "cave_exit", "cave_exit_vulcao" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("teleportaprafloresta")
    end)
end

for _, prefab in pairs(
    { "seastack",
        "coralreef",
        "wreck",
        "waterygrave",
        "octopusking",
        "kraken",
        "ballphinhouse",
        "coral_brain_rock",
        "saltstackthen",
        "wall_enforcedlimestone",
        "kraken_tentacle",
        "sea_chiminea",
        "sea_yard",
        "buoy" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst:AddTag("quebraonda")
    end)
end



for _, prefab in pairs({ "saplingnova", "sapling" }) do
    AddPrefabPostInit(prefab, function(inst)
        -- if not TheWorld.ismastersim then
        --     return
        -- end

        inst.entity:AddSoundEmitter() --ventania风相关
        inst:AddTag("saplingsw")
    end)
end


for _, prefab in pairs({ "sewing_tape" }) do
    AddPrefabPostInit(prefab, function(inst)
        inst:AddTag("boatrepairkit")
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("interactions")
    end)
end


for _, prefab in pairs({ "spider_warrior" }) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:DoTaskInTime(0.5, function(inst)
            local map = GLOBAL.TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            if x and y and z then
                local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
                if ground == GROUND.MAGMAFIELD
                    or ground == GROUND.JUNGLE
                    or ground == GROUND.ASH
                    or ground == GROUND.VOLCANO
                    or ground == GROUND.TIDALMARSH
                    or ground == GROUND.MEADOW
                    or ground == GROUND.BEAH then
                    local bolha = SpawnPrefab("spider_tropical")
                    if bolha then
                        bolha.Transform:SetPosition(x, y, z)
                    end
                    inst:Remove()
                end
            end
        end)
    end)
end


for _, prefab in pairs(
    { "houndstooth",
        "gunpowder",
        "boards",
        "mosquitosack",
        "nightmarefuel",
        "stinger",
        "spear",
        "spear_wathgrithr" }) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("tradable")
    end)
end



for _, prefab in pairs(
    { "snake_amphibious",
        "bat",
        "scorpion",
        "ghost",
        "antman_warrior",
        "antman",
        "hanging_vine",
        "grabbing_vine",
        "hanging_vine_patch",
        "mean_flytrap",
        "adult_flytrap",
        "lightrays_jungle",
        "pog",
        "zeb",
        "lightrays" }) do
    AddPrefabPostInit(prefab, function(inst)
        inst:AddTag("tropicalspawner")

        if not TheWorld.ismastersim then
            return
        end

        local function OnTimerDone(inst, data)
            if data.name == "vaiembora" then
                local invader = GetClosestInstWithTag("player", inst, 25)
                if not invader then
                    inst:Remove() --为什么要自删呢
                else
                    inst.components.timer:StartTimer("vaiembora", 10)
                end
            end
        end


        inst:AddComponent("timer")
        inst:ListenForEvent("timerdone", OnTimerDone)
        inst.components.timer:StartTimer("vaiembora", 80 + math.random() * 80)
    end)
end
