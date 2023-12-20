AddPrefabPostInitAny(function(inst)
    if inst.prefab == "skeleton" or inst.prefab == "skeleton_player" then
        local function ondropped(inst)
            local map = GLOBAL.TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            if x and y and z then
                -- local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

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
        --inst.components.inventoryitem:SetOnDroppedFn(ondropped)
        inst:DoTaskInTime(0, ondropped)
    end

    if inst.prefab == "ash" then
        if GLOBAL.TheWorld.ismastersim then
            inst:AddComponent("fertilizecoffee")
        end
    end
    ------------------------
    if inst.prefab == "anchor" then
        inst:AddTag("ancora")
    end
    ------------------------
    if inst.prefab == "gogglesnormalhat" or
        inst.prefab == "gogglesheathat" or
        inst.prefab == "gogglesarmorhat" or
        inst.prefab == "gogglesshoothat" or
        inst.prefab == "bathat" or
        inst.prefab == "pithhat" or
        inst.prefab == "armor_weevole" then
        inst:AddTag("velocidadenormal")
    end
    ------------------------para a onda quebrar--------------
    if inst.prefab == "cave_entrance_open" or inst.prefab == "cave_entrance_vulcao" then
        inst:AddTag("teleportapracaverna")
    end

    if inst.prefab == "cave_exit" or inst.prefab == "cave_exit_vulcao" then
        inst:AddTag("teleportaprafloresta")
    end


    if inst.prefab == "seastack" or inst.prefab == "coralreef" or inst.prefab == "wreck" or inst.prefab == "waterygrave" or inst.prefab == "octopusking" or inst.prefab == "kraken" or inst.prefab == "ballphinhouse" or inst.prefab == "coral_brain_rock" or inst.prefab == "saltstackthen" or inst.prefab == "wall_enforcedlimestone" or inst.prefab == "kraken_tentacle" or inst.prefab == "sea_chiminea" or inst.prefab == "sea_yard" or inst.prefab == "buoy" then
        inst:AddTag("quebraonda")
    end

    if inst.prefab == "window_round_light" or inst.prefab == "window_round_light_backwall" then
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        inst:AddTag("DECOR")
        inst:AddTag("NOBLOCK")
    end

    if inst.prefab == "saplingnova" or inst.prefab == "sapling" then
        inst.entity:AddSoundEmitter()
        inst:AddTag("saplingsw")
    end

    if inst.prefab == "sewing_tape" then
        inst:AddTag("boatrepairkit")
        if GLOBAL.TheWorld.ismastersim then
            inst:AddComponent("interactions")
        end
    end

    if inst.prefab == "wurt" then

    end


    if inst.prefab == "spider_warrior" then
        inst:DoTaskInTime(0.5, function(inst)
            local map = GLOBAL.TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            if x and y and z then
                local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
                if ground == GROUND.MAGMAFIELD or ground == GROUND.JUNGLE or ground == GROUND.ASH or ground == GROUND.VOLCANO or ground == GROUND.TIDALMARSH or ground == GROUND.MEADOW or ground == GROUND.BEAH then
                    local bolha = SpawnPrefab("spider_tropical")
                    if bolha then
                        bolha.Transform:SetPosition(x, y, z)
                    end
                    inst:Remove()
                end
            end
        end)
    end


    -----mostra neve--------------
    if inst:HasTag("SnowCovered") then
        local function mostraneve(inst)
            local map = GLOBAL.TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            if x and y and z then
                local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
                if ground == GROUND.WATER_MANGROVE or ground == GROUND.ANTFLOOR then
                    inst:AddTag("mostraneve")
                end
            end
        end
        inst:DoTaskInTime(0.5, mostraneve)
    end

    --------------negocia com porcos------------------
    if inst.prefab == "houndstooth" or inst.prefab == "gunpowder" or inst.prefab == "boards" or inst.prefab == "mosquitosack" or inst.prefab == "nightmarefuel" or inst.prefab == "stinger" or inst.prefab == "spear" or inst.prefab == "spear_wathgrithr" then
        if GLOBAL.TheWorld.ismastersim then
            inst:AddComponent("tradable")
        end
    end

    --------------mod rangers------------------
    if inst.prefab == "levelx_vest" then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("krampus_sack")
        end
    end
    ------------------------koalefant_summer se transforma no chao de neve-----------------
    if inst.prefab == "koalefant_summer" then
        local function ondropped(inst)
            local map = GLOBAL.TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            if x and y and z then
                local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

                if (ground == GROUND.WATER_MANGROVE) or (ground == GROUND.ANTFLOOR) then
                    inst:DoTaskInTime(0.5, function(inst)
                        local bolha = SpawnPrefab("koalefant_winter")
                        if bolha then
                            bolha.Transform:SetPosition(x, y, z)
                        end
                        inst:Remove()
                    end)
                end
            end
        end

        inst:DoTaskInTime(0, ondropped)
    end


    ------------------------------------------------------
    if inst.prefab == "mole" or inst.prefab == "rabbit" then
        local function ondropped(inst)
            local map = GLOBAL.TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            if x and y and z then
                local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

                if (ground == GROUND.UNDERWATER_ROCKY) or (ground == GROUND.UNDERWATER_SANDY) or (ground == GROUND.PAINTED and GLOBAL.TheWorld:HasTag("cave")) or (ground == GROUND.MAGMAFIELD and GLOBAL.TheWorld:HasTag("cave")) or (ground == GROUND.BEACH and GLOBAL.TheWorld:HasTag("cave")) then
                    inst:DoTaskInTime(0.1, function(inst)
                        inst:Remove()
                    end)
                end
            end
        end

        inst:DoTaskInTime(0.1, ondropped)
    end


    if inst.prefab == "worm" then
        local function ondropped(inst)
            local map = GLOBAL.TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            if x and y and z then
                local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

                if (ground == GROUND.UNDERWATER_ROCKY) or (ground == GROUND.UNDERWATER_SANDY) or (ground == GROUND.PAINTED and GLOBAL.TheWorld:HasTag("cave")) or (ground == GROUND.MAGMAFIELD and GLOBAL.TheWorld:HasTag("cave")) or (ground == GROUND.BEACH and GLOBAL.TheWorld:HasTag("cave")) then
                    inst:DoTaskInTime(0.1, function(inst)
                        local bolha = SpawnPrefab("seatentacle")
                        if bolha then
                            bolha.Transform:SetPosition(x, y, z)
                        end
                        inst:Remove()
                    end)
                end
            end
        end

        inst:DoTaskInTime(0.1, ondropped)
    end
    --------------------------apaga depois de um tempo----------------------

    if inst.prefab == "snake_amphibious"
        or inst.prefab == "bat"
        or inst.prefab == "scorpion"
        or inst.prefab == "ghost"
        or inst.prefab == "antman_warrior"
        or inst.prefab == "antman"
        or inst.prefab == "hanging_vine"
        or inst.prefab == "grabbing_vine"
        or inst.prefab == "hanging_vine_patch"
        or inst.prefab == "mean_flytrap"
        or inst.prefab == "adult_flytrap"
        or inst.prefab == "lightrays_jungle"
        or inst.prefab == "pog"
        or inst.prefab == "zeb"
        or inst.prefab == "lightrays" then
        local function OnTimerDone(inst, data)
            if data.name == "vaiembora" then
                local invader = GLOBAL.GetClosestInstWithTag("player", inst, 25)
                if not invader then
                    inst:Remove()
                else
                    inst.components.timer:StartTimer("vaiembora", 10)
                end
            end
        end

        inst:AddTag("tropicalspawner")

        if GLOBAL.TheWorld.ismastersim then
            inst:AddComponent("timer")
            inst:ListenForEvent("timerdone", OnTimerDone)
            inst.components.timer:StartTimer("vaiembora", 80 + math.random() * 80)
        end
    end
end)
