local assets =
{
    Asset("ANIM", "anim/parrot_pirate_intro.zip"),
    Asset("ANIM", "anim/parrot_pirate.zip"),
    Asset("ANIM", "anim/portal_stone.zip"),
    Asset("MINIMAP_IMAGE", "portal_dst"),
}

local assets_stone =
{
    Asset("ANIM", "anim/portal_stone.zip"),
    Asset("MINIMAP_IMAGE", "portal_dst"),
}

local assets_construction =
{
    Asset("ANIM", "anim/portal_stone_construction.zip"),
    Asset("ANIM", "anim/portal_stone.zip"),
    Asset("ANIM", "anim/ui_construction_4x1.zip"),
    Asset("MINIMAP_IMAGE", "portal_dst"),
}

local assets_moonrock =
{
    Asset("ANIM", "anim/portal_moonrock.zip"),
    Asset("ANIM", "anim/portal_stone.zip"),
    Asset("MINIMAP_IMAGE", "portal_dst"),
}

local assets_fx =
{
    Asset("ANIM", "anim/portal_moonrock.zip"),
    Asset("ANIM", "anim/portal_stone.zip"),
}

local prefabs_construction =
{
    "multiplayer_portal_moonrock",
    "construction_container",
}

local prefabs_moonrock =
{
    "multiplayer_portal_moonrock_fx",
}

local function OnRezPlayer(inst)
    if not inst.sg:HasStateTag("construction") then
        inst.sg:GoToState("spawn_pre")
    end
end

local function GetVerb()
    return STRINGS.ACTIONS.ACTIVATE.GENERIC
end

local prefabs =
{
    "log",
    "boatrepairkit",
}


local function onhammered(inst)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function fn2(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.1)
    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst.AnimState:SetBank("parrot_pirate_intro")
    inst.AnimState:SetBuild("parrot_pirate_intro")
    inst.AnimState:PlayAnimation("debris_1")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "boards" })

    inst:AddComponent("inspectable")

    return inst
end

local function fn3(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.1)
    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst.AnimState:SetBank("parrot_pirate_intro")
    inst.AnimState:SetBuild("parrot_pirate_intro")
    inst.AnimState:PlayAnimation("debris_2")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "log", "log", "log" })

    inst:AddComponent("inspectable")

    return inst
end

local function fn4(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.1)
    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst.AnimState:SetBank("parrot_pirate_intro")
    inst.AnimState:SetBuild("parrot_pirate_intro")
    inst.AnimState:PlayAnimation("debris_3")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "boards", "boatrepairkit" })

    inst:AddComponent("inspectable")

    return inst
end

local function fn5(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.1)
    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst.AnimState:SetBank("parrot_pirate_intro")
    inst.AnimState:SetBuild("parrot_pirate_intro")
    inst.AnimState:PlayAnimation("idle_empty")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "log", "log", "log", "boatrepairkit" })

    inst:AddComponent("inspectable")

    return inst
end

local function fn6(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()

    local gamemode = TheNet:GetServerGameMode()
    if not GetIsSpawnModeFixed(gamemode) then
        --In this case, don't network this prefab, and always remove it locally.
        inst.entity:Hide()
        inst.persists = false
        inst:DoTaskInTime(0, inst.Remove)
        return inst
    end

    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    -- MakeObstaclePhysics(inst, 1)

    inst.MiniMapEntity:SetIcon("portal_dst.tex")

    inst.AnimState:SetBank("parrot_pirate")
    inst.AnimState:SetBuild("parrot_pirate")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("multiplayer_portal")
    inst:AddTag("antlion_sinkhole_blocker")

    inst:SetDeployExtraSpacing(2)

    inst.GetActivateVerb = GetVerb


    inst:AddComponent("talker")
    inst.components.talker.offset = Vector3(0, -550, 0)
    inst.components.talker:MakeChatter()
    inst:ListenForEvent("ontalk",
        function(inst, data)
            inst.AnimState:PlayAnimation("speak", true)
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/parrot/chirp", "talk")
        end)
    inst:ListenForEvent("ondonetalking", function(inst, data) inst.SoundEmitter:KillSound("talk") end)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    if GetPortalRez(gamemode) then
        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
        inst:AddTag("resurrector")
    end

    inst:ListenForEvent("ms_newplayercharacterspawned", function(world, data)
        if data and data.player then
            --            data.player.AnimState:SetMultColour(0,0,0,1)

            local map = TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()

            local xf
            local zf
            local tentativas = 0
            repeat
                xf = math.random(x - 6, x + 6)
                zf = math.random(z - 6, z + 6)
                local curr = map:GetTile(map:GetTileCoordsAtPoint(xf, 0, zf))
                local curr1 = map:GetTile(map:GetTileCoordsAtPoint(xf + 2, 0, zf))
                local curr2 = map:GetTile(map:GetTileCoordsAtPoint(xf - 2, 0, zf))
                local curr3 = map:GetTile(map:GetTileCoordsAtPoint(xf, 0, zf + 2))
                local curr4 = map:GetTile(map:GetTileCoordsAtPoint(xf, 0, zf - 2))
                tentativas = tentativas + 1
            until
                tentativas > 500 or (curr ~= GROUND.OCEAN_SWELL and curr ~= GROUND.OCEAN_WATERLOG and curr ~= GROUND.OCEAN_HAZARDOUS and curr ~= GROUND.OCEAN_ROUGH and curr ~= GROUND.OCEAN_COASTAL and curr ~= GROUND.OCEAN_BRINEPOOL and curr ~= GROUND.OCEAN_COASTAL_SHORE and curr ~= GROUND.OCEAN_BRINEPOOL_SHORE and
                    curr1 ~= GROUND.OCEAN_SWELL and curr1 ~= GROUND.OCEAN_WATERLOG and curr1 ~= GROUND.OCEAN_HAZARDOUS and curr1 ~= GROUND.OCEAN_ROUGH and curr1 ~= GROUND.OCEAN_COASTAL and curr1 ~= GROUND.OCEAN_BRINEPOOL and curr1 ~= GROUND.OCEAN_COASTAL_SHORE and curr1 ~= GROUND.OCEAN_BRINEPOOL_SHORE and
                    curr2 ~= GROUND.OCEAN_SWELL and curr2 ~= GROUND.OCEAN_WATERLOG and curr2 ~= GROUND.OCEAN_HAZARDOUS and curr2 ~= GROUND.OCEAN_ROUGH and curr2 ~= GROUND.OCEAN_COASTAL and curr2 ~= GROUND.OCEAN_BRINEPOOL and curr2 ~= GROUND.OCEAN_COASTAL_SHORE and curr2 ~= GROUND.OCEAN_BRINEPOOL_SHORE and
                    curr3 ~= GROUND.OCEAN_SWELL and curr3 ~= GROUND.OCEAN_WATERLOG and curr3 ~= GROUND.OCEAN_HAZARDOUS and curr3 ~= GROUND.OCEAN_ROUGH and curr3 ~= GROUND.OCEAN_COASTAL and curr3 ~= GROUND.OCEAN_BRINEPOOL and curr3 ~= GROUND.OCEAN_COASTAL_SHORE and curr3 ~= GROUND.OCEAN_BRINEPOOL_SHORE and
                    curr4 ~= GROUND.OCEAN_SWELL and curr4 ~= GROUND.OCEAN_WATERLOG and curr4 ~= GROUND.OCEAN_HAZARDOUS and curr4 ~= GROUND.OCEAN_ROUGH and curr4 ~= GROUND.OCEAN_COASTAL and curr4 ~= GROUND.OCEAN_BRINEPOOL and curr4 ~= GROUND.OCEAN_COASTAL_SHORE and curr4 ~= GROUND.OCEAN_BRINEPOOL_SHORE)
            data.player.Transform:SetPosition(xf, 0, zf)
            if data.player.prefab == "warly" then
                local mochila = SpawnPrefab("spicepack")
                mochila.Transform:SetPosition(xf - 0.5, 0, zf - 0.5)
            end
            if data.player.prefab == "webber" then
                local mochila = SpawnPrefab("disguisehat")
                data.player.components.inventory:GiveItem(mochila)
            end
            if data.player.prefab == "walani" then
                local mochila = SpawnPrefab("surfboard_item")
                mochila.Transform:SetPosition(xf - 0.5, 0, zf - 0.5)
            end

            data.player:Hide()
            data.player:DoTaskInTime(12 * FRAMES, function(inst)
                inst:FacePoint(data.player.Transform:GetWorldPosition())
                data.player:Show()
                data.player:DoTaskInTime(60 * FRAMES, function(inst)
                    data.player:DoTaskInTime(120 * FRAMES, function(inst)
                        inst.components.colourtweener:StartTween({ 1, 1, 1, 1 }, 14 * FRAMES, function(inst)
                            data.player.sg:GoToState("wakeup")
                        end)
                    end)
                end)
            end)
        end
        inst:DoTaskInTime(.3, function()
            data.player.sg:GoToState("sleep_intro")
        end)
        inst:DoTaskInTime(.4, function()
            inst.sg:GoToState("spawn_pre")
        end)
    end, TheWorld)

    inst:ListenForEvent("rez_player", OnRezPlayer)
    inst:SetStateGraph("SGparrotintro")
    return inst
end


local assets_stone =
{
    Asset("ANIM", "anim/portal_stone.zip"),
    Asset("MINIMAP_IMAGE", "portal_dst"),
}

local assets_construction =
{
    Asset("ANIM", "anim/portal_stone_construction.zip"),
    Asset("ANIM", "anim/portal_stone.zip"),
    Asset("ANIM", "anim/ui_construction_4x1.zip"),
    Asset("MINIMAP_IMAGE", "portal_dst"),
}

local assets_moonrock =
{
    Asset("ANIM", "anim/portal_moonrock.zip"),
    Asset("ANIM", "anim/portal_stone.zip"),
    Asset("MINIMAP_IMAGE", "portal_dst"),
}

local assets_fx =
{
    Asset("ANIM", "anim/portal_moonrock.zip"),
    Asset("ANIM", "anim/portal_stone.zip"),
}

local prefabs_construction =
{
    "multiplayer_portal_moonrock",
    "construction_container",
}

local prefabs_moonrock =
{
    "multiplayer_portal_moonrock_fx",
}

local function OnRezPlayer(inst)
    if not inst.sg:HasStateTag("construction") then
        inst.sg:GoToState("spawn_pre")
    end
end

local function MakePortal2(name, bank, build, assets, prefabs, common_postinit, master_postinit)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()

        local gamemode = TheNet:GetServerGameMode()
        if not GetIsSpawnModeFixed(gamemode) then
            --In this case, don't network this prefab, and always remove it locally.
            inst.entity:Hide()
            inst.persists = false
            inst:DoTaskInTime(0, inst.Remove)
            return inst
        end

        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        -- MakeObstaclePhysics(inst, 1)

        inst.MiniMapEntity:SetIcon("portal_dst.tex")

        --		inst.AnimState:SetBank("portal_dst")
        --		inst.AnimState:SetBuild("portal_stone")
        --        inst.AnimState:PlayAnimation("idle_loop", true)	


        if TUNING.multiplayerportal == "together" then
            inst.AnimState:SetBank("portal_dst")
            inst.AnimState:SetBuild("portal_stone")
            inst.AnimState:PlayAnimation("idle_loop", true)
        end




        inst:AddTag("multiplayer_portal")
        inst:AddTag("antlion_sinkhole_blocker")

        inst:SetDeployExtraSpacing(2)

        if common_postinit ~= nil then
            common_postinit(inst)
        end

        inst:AddComponent("talker")
        inst.components.talker.offset = Vector3(0, -550, 0)
        inst.components.talker:MakeChatter()

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:SetStateGraph("SGmultiplayerportal")

        inst:AddComponent("inspectable")
        inst.components.inspectable:RecordViews()

        if GetPortalRez(gamemode) then
            inst:AddComponent("hauntable")
            inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
            inst:AddTag("resurrector")
        end

        inst:ListenForEvent("ms_newplayercharacterspawned", function(world, data)
            if data and data.player then
                --            data.player.AnimState:SetMultColour(0,0,0,1)

                local map = TheWorld.Map
                local x, y, z = inst.Transform:GetWorldPosition()

                local xf
                local zf
                local tentativas = 0
                repeat
                    xf = math.random(x - 6, x + 6)
                    zf = math.random(z - 6, z + 6)
                    local curr = map:GetTile(map:GetTileCoordsAtPoint(xf, 0, zf))
                    local curr1 = map:GetTile(map:GetTileCoordsAtPoint(xf + 2, 0, zf))
                    local curr2 = map:GetTile(map:GetTileCoordsAtPoint(xf - 2, 0, zf))
                    local curr3 = map:GetTile(map:GetTileCoordsAtPoint(xf, 0, zf + 2))
                    local curr4 = map:GetTile(map:GetTileCoordsAtPoint(xf, 0, zf - 2))
                    tentativas = tentativas + 1
                until
                    tentativas > 500 or (curr ~= GROUND.OCEAN_SWELL and curr ~= GROUND.OCEAN_WATERLOG and curr ~= GROUND.OCEAN_HAZARDOUS and curr ~= GROUND.OCEAN_ROUGH and curr ~= GROUND.OCEAN_COASTAL and curr ~= GROUND.OCEAN_BRINEPOOL and curr ~= GROUND.OCEAN_COASTAL_SHORE and curr ~= GROUND.OCEAN_BRINEPOOL_SHORE and
                        curr1 ~= GROUND.OCEAN_SWELL and curr1 ~= GROUND.OCEAN_WATERLOG and curr1 ~= GROUND.OCEAN_HAZARDOUS and curr1 ~= GROUND.OCEAN_ROUGH and curr1 ~= GROUND.OCEAN_COASTAL and curr1 ~= GROUND.OCEAN_BRINEPOOL and curr1 ~= GROUND.OCEAN_COASTAL_SHORE and curr1 ~= GROUND.OCEAN_BRINEPOOL_SHORE and
                        curr2 ~= GROUND.OCEAN_SWELL and curr2 ~= GROUND.OCEAN_WATERLOG and curr2 ~= GROUND.OCEAN_HAZARDOUS and curr2 ~= GROUND.OCEAN_ROUGH and curr2 ~= GROUND.OCEAN_COASTAL and curr2 ~= GROUND.OCEAN_BRINEPOOL and curr2 ~= GROUND.OCEAN_COASTAL_SHORE and curr2 ~= GROUND.OCEAN_BRINEPOOL_SHORE and
                        curr3 ~= GROUND.OCEAN_SWELL and curr3 ~= GROUND.OCEAN_WATERLOG and curr3 ~= GROUND.OCEAN_HAZARDOUS and curr3 ~= GROUND.OCEAN_ROUGH and curr3 ~= GROUND.OCEAN_COASTAL and curr3 ~= GROUND.OCEAN_BRINEPOOL and curr3 ~= GROUND.OCEAN_COASTAL_SHORE and curr3 ~= GROUND.OCEAN_BRINEPOOL_SHORE and
                        curr4 ~= GROUND.OCEAN_SWELL and curr4 ~= GROUND.OCEAN_WATERLOG and curr4 ~= GROUND.OCEAN_HAZARDOUS and curr4 ~= GROUND.OCEAN_ROUGH and curr4 ~= GROUND.OCEAN_COASTAL and curr4 ~= GROUND.OCEAN_BRINEPOOL and curr4 ~= GROUND.OCEAN_COASTAL_SHORE and curr4 ~= GROUND.OCEAN_BRINEPOOL_SHORE)
                --data.player.Transform:SetPosition(xf, 0, zf)
                if data.player.prefab == "warly" then
                    local mochila = SpawnPrefab("spicepack")
                    mochila.Transform:SetPosition(xf - 0.5, 0, zf - 0.5)
                end
                if data.player.prefab == "webber" then
                    local mochila = SpawnPrefab("disguisehat")
                    data.player.components.inventory:GiveItem(mochila)
                end
                if data.player.prefab == "walani" then
                    local mochila = SpawnPrefab("surfboard_item")
                    mochila.Transform:SetPosition(xf - 0.5, 0, zf - 0.5)
                end

                data.player:Hide()
                data.player:DoTaskInTime(12 * FRAMES, function(inst)
                    inst:FacePoint(data.player.Transform:GetWorldPosition())
                    data.player:Show()
                    data.player:DoTaskInTime(60 * FRAMES, function(inst)
                        data.player:DoTaskInTime(120 * FRAMES, function(inst)
                            inst.components.colourtweener:StartTween({ 1, 1, 1, 1 }, 14 * FRAMES, function(inst)
                            end)
                        end)
                    end)
                end)
            end

            if TUNING.multiplayerportal == "together" then
                inst:DoTaskInTime(.4, function()
                    inst.sg:GoToState("spawn_pre")
                end)
            end
        end, TheWorld)

        inst:ListenForEvent("rez_player", OnRezPlayer)

        if master_postinit ~= nil then
            master_postinit(inst)
        end
        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

local function MakePortal(name, bank, build, assets, prefabs, common_postinit, master_postinit)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()

        local gamemode = TheNet:GetServerGameMode()
        if not GetIsSpawnModeFixed(gamemode) then
            --In this case, don't network this prefab, and always remove it locally.
            inst.entity:Hide()
            inst.persists = false
            inst:DoTaskInTime(0, inst.Remove)
            return inst
        end

        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        -- MakeObstaclePhysics(inst, 1)

        inst.MiniMapEntity:SetIcon("portal_dst.tex")

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle_loop", true)

        inst:AddTag("multiplayer_portal")
        inst:AddTag("antlion_sinkhole_blocker")

        inst:SetDeployExtraSpacing(2)

        inst:AddComponent("talker")
        inst.components.talker.offset = Vector3(0, -550, 0)
        inst.components.talker:MakeChatter()


        if common_postinit ~= nil then
            common_postinit(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:SetStateGraph("SGmultiplayerportal")

        inst:AddComponent("inspectable")
        inst.components.inspectable:RecordViews()

        if GetPortalRez(gamemode) then
            inst:AddComponent("hauntable")
            inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
            inst:AddTag("resurrector")
        end

        inst:ListenForEvent("ms_newplayercharacterspawned", function(world, data)
            if data and data.player then
                data.player.AnimState:SetMultColour(0, 0, 0, 1)
                data.player:Hide()
                data.player.components.playercontroller:Enable(false)
                data.player:DoTaskInTime(12 * FRAMES, function(inst)
                    data.player:Show()
                    data.player:DoTaskInTime(60 * FRAMES, function(inst)
                        inst.components.colourtweener:StartTween({ 1, 1, 1, 1 }, 14 * FRAMES, function(inst)
                            data.player.components.playercontroller:Enable(true)
                        end)
                    end)
                end)
            end
            if not inst.sg:HasStateTag("construction") then
                inst.sg:GoToState("spawn_pre")
            end
        end, TheWorld)

        inst:ListenForEvent("rez_player", OnRezPlayer)

        inst:ListenForEvent("ontalk",
            function(inst, data)
                inst.AnimState:PlayAnimation("speak", true)
                inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/parrot/chirp", "talk")
            end)
        inst:ListenForEvent("ondonetalking", function(inst, data) inst.SoundEmitter:KillSound("talk") end)


        if master_postinit ~= nil then
            master_postinit(inst)
        end

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

local STONE_SOUNDS =
{
    idle_loop = "dontstarve/common/together/spawn_vines/spawnportal_idle_LP",
    idle = "dontstarve/common/together/spawn_vines/spawnportal_idle",
    scratch = "dontstarve/common/together/spawn_vines/spawnportal_scratch",
    jacob = "dontstarve/common/together/spawn_vines/spawnportal_jacob",
    blink = "dontstarve/common/together/spawn_vines/spawnportal_blink",
    vines = "dontstarve/common/together/spawn_vines/vines",
    spawning_loop = "dontstarve/common/together/spawn_vines/spawnportal_spawning",
    armswing = "dontstarve/common/together/spawn_vines/spawnportal_armswing",
    shake = "dontstarve/common/together/spawn_vines/spawnportal_shake",
    open = "dontstarve/common/together/spawn_vines/spawnportal_open",
    glow_loop = nil,
    shatter = nil,
    place = nil,
    transmute_pre = nil,
    transmute = nil,
}

local function stone_common_postinit(inst)
    inst.sounds = TheWorld.ismastersim and STONE_SOUNDS or nil
end

local function construction_common_postinit(inst)
    inst.AnimState:Hide("stage2")
    inst.AnimState:Hide("stage3")
    inst.AnimState:AddOverrideBuild("portal_stone_construction")
    inst.AnimState:OverrideSymbol("portal_moonrock", "portal_moonrock", "portal_moonrock")
    inst.AnimState:OverrideSymbol("curtains", "portal_moonrock", "curtains")

    if TheWorld:HasTag("cave") then
        inst.AnimState:Hide("eyefx")
    else
        inst.AnimState:OverrideSymbol("glow", "portal_moonrock", "glow")
    end

    --constructionsite (from constructionsite component) added to pristine state for optimization
    inst:AddTag("constructionsite")

    inst.constructionname = "multiplayer_portal_moonrock"
    inst:SetPrefabNameOverride("multiplayer_portal")

    inst.sounds = TheWorld.ismastersim and
        {
            idle_loop = nil,
            idle = "dontstarve/common/together/spawn_vines/spawnportal_idle",
            scratch = nil,
            jacob = "dontstarve/common/together/spawn_vines/spawnportal_jacob",
            blink = nil,
            vines = "dontstarve/common/together/spawn_vines/vines",
            spawning_loop = "dontstarve/common/together/spawn_vines/spawnportal_spawning",
            armswing = nil,
            shake = "dontstarve/common/together/spawn_vines/spawnportal_shake",
            open = "dontstarve/common/together/spawn_vines/spawnportal_open",
            glow_loop = "dontstarve/common/together/spawn_vines/spawnportal_spawning",
            shatter = "dontstarve/common/together/spawn_vines/spawnportal_open",
            place = "dontstarve/common/together/spawn_portal_celestial/reveal",
            transmute_pre = "dontstarve/common/together/spawn_portal_celestial/cracking",
            transmute = "dontstarve/common/together/spawn_portal_celestial/shatter",
        } or nil
end

local function OnStartConstruction(inst)
    inst.sg:GoToState("placeconstruction")
end

local function CalculateConstructionPhase(inst)
    --single ingredients worth one phase each
    --remaining ingredient stacks worth percentage of remaining phases
    local singles_amount = 0
    local singles_total = 0
    local amount = 0
    local total = 0
    for i, v in ipairs(CONSTRUCTION_PLANS[inst.prefab] or {}) do
        if v.amount > 1 then
            amount = amount + inst.components.constructionsite:GetMaterialCount(v.type)
            total = total + v.amount
        else
            singles_amount = singles_amount + inst.components.constructionsite:GetMaterialCount(v.type)
            singles_total = singles_total + 1
        end
    end
    return (total > 0 and math.clamp(singles_amount + math.floor((3 - singles_total) * amount / total) + 1, 1, 4))
        or (singles_total > 0 and math.clamp(math.floor(3 * singles_amount / singles_total) + 1, 1, 4))
        or 1
end

local function OnConstructed(inst, doer)
    local amount = 0
    local total = 0
    for i, v in ipairs(CONSTRUCTION_PLANS[inst.prefab] or {}) do
        amount = amount + inst.components.constructionsite:GetMaterialCount(v.type)
        total = total + v.amount
    end
    inst.sg.mem.targetconstructionphase = CalculateConstructionPhase(inst)
    if not (inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("open")) then
        inst.sg:GoToState(inst.sg.mem.constructionphase >= 3 and inst.sg.mem.targetconstructionphase >= 4 and
            "constructionphase4" or "constructed")
    end
end

local function construction_onload(inst) --, data, newents)
    inst.sg.mem.targetconstructionphase = CalculateConstructionPhase(inst)
    inst.sg.mem.constructionphase = math.min(3, inst.sg.mem.targetconstructionphase)
    for i = 1, 3 do
        if i == inst.sg.mem.constructionphase then
            inst.AnimState:Show("stage" .. tostring(i))
        else
            inst.AnimState:Hide("stage" .. tostring(i))
        end
    end
    if inst.sg.mem.constructionphase == 3 then
        inst.AnimState:Hide("hidestage3")
        inst.sounds.vines = nil
    else
        inst.AnimState:Show("hidestage3")
    end
    if inst.sg.mem.targetconstructionphase ~= inst.sg.mem.constructionphase then
        inst.sg:GoToState("constructionphase" .. tostring(inst.sg.mem.targetconstructionphase))
    end
end

local function construction_master_postinit(inst)
    inst.sg.mem.nofunny = true
    inst.sg.mem.constructionphase = 1
    inst.sg.mem.targetconstructionphase = 1

    inst:AddComponent("constructionsite")
    inst.components.constructionsite:SetConstructionPrefab("construction_container")
    inst.components.constructionsite:SetOnConstructedFn(OnConstructed)

    inst:ListenForEvent("onstartconstruction", OnStartConstruction)

    inst.OnLoad = construction_onload
end

local MOONROCK_SOUNDS =
{
    idle_loop = nil,
    idle = "dontstarve/common/together/spawn_vines/spawnportal_idle",
    scratch = nil,
    jacob = "dontstarve/common/together/spawn_vines/spawnportal_jacob",
    blink = nil,
    vines = nil,
    spawning_loop = "dontstarve/common/together/spawn_vines/spawnportal_spawning",
    armswing = nil,
    shake = "dontstarve/common/together/spawn_vines/spawnportal_shake",
    open = "dontstarve/common/together/spawn_vines/spawnportal_open",
    glow_loop = nil,
    shatter = nil,
    place = nil,
    transmute_pre = nil,
    transmute = nil,
}

local function moonrock_common_postinit(inst)
    inst.AnimState:OverrideSymbol("portaldoormagic_cycle", "portal_stone", "portaldoormagic_cycle")
    inst.AnimState:OverrideSymbol("portalbg", "portal_stone", "portalbg")
    inst.AnimState:OverrideSymbol("spiralfx", "portal_stone", "spiralfx")

    if TheWorld:HasTag("cave") then
        inst.AnimState:OverrideSymbol("FX_ray", "portal_stone", "FX_ray")
        inst.AnimState:Hide("eyefx")
    else
        inst.AnimState:SetLightOverride(.04)
        inst.AnimState:Hide("eye")
        inst.AnimState:Hide("eyefx")
        inst.AnimState:Hide("FX_rays")

        inst:AddTag("moonportal")
    end

    --moontrader (from moontrader component) added to pristine state for optimization
    inst:AddTag("moontrader")

    if TheWorld.ismastersim then
        inst.fx = not TheWorld:HasTag("cave") and SpawnPrefab("multiplayer_portal_moonrock_fx") or nil
        inst.sounds = MOONROCK_SOUNDS
    end
end

local function moonrock_onsleep(inst)
    if inst._task ~= nil then
        inst._task:Cancel()
        inst._task = nil
    end
end

local function moonrock_onupdate(inst, instant)
    local x, y, z = inst.Transform:GetWorldPosition()
    for i, v in ipairs(TheSim:FindEntities(x, y, z, 8, { "moonportalkey" })) do
        v:PushEvent("ms_moonportalproximity", { instant = instant })
    end
end

local function moonrock_onwake(inst)
    if inst._task == nil then
        inst._task = inst:DoPeriodicTask(1, moonrock_onupdate)
        moonrock_onupdate(inst, true)
    end
end

local function moonrock_canaccept(inst, item) --, giver)
    if not item:HasTag("moonportalkey") then
        return false
    elseif TheWorld:HasTag("cave") then
        return false, "NOMOON"
    end
    return true
end

local function moonrock_onaccept(inst, giver) --, item)
    giver:PushEvent("ms_playerreroll")
    if giver.components.inventory ~= nil then
        giver.components.inventory:DropEverything()
    end
    inst._savedata[giver.userid] = giver.SaveForReroll ~= nil and giver:SaveForReroll() or nil
    TheWorld:PushEvent("ms_playerdespawnanddelete", giver)
end

local function moonrock_onsave(inst, data)
    data.players = next(inst._savedata) ~= nil and inst._savedata or nil
end

local function moonrock_onload(inst, data)
    inst._savedata = data ~= nil and data.players or inst._savedata
end

local function moonrock_master_postinit(inst)
    inst:AddComponent("moontrader")
    inst.components.moontrader:SetCanAcceptFn(moonrock_canaccept)
    inst.components.moontrader:SetOnAcceptFn(moonrock_onaccept)

    if not TheWorld:HasTag("cave") then
        inst.fx.entity:SetParent(inst.entity)
        inst._task = nil
        inst._savedata = {}
        inst.OnEntitySleep = moonrock_onsleep
        inst.OnEntityWake = moonrock_onwake
        inst.OnSave = moonrock_onsave
        inst.OnLoad = moonrock_onload

        inst:ListenForEvent("ms_newplayerspawned", function(world, player)
            if inst._savedata[player.userid] ~= nil then
                if player.LoadForReroll ~= nil then
                    player:LoadForReroll(inst._savedata[player.userid])
                end
                inst._savedata[player.userid] = nil
            end
        end, TheWorld)

        inst:ListenForEvent("ms_playerjoined", function(world, player)
            --In case despawn never finished after saving for reroll
            inst._savedata[player.userid] = nil
        end, TheWorld)
    end
end

local function moonrockfxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("portal_moonrock_dst")
    inst.AnimState:SetBuild("portal_moonrock")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:Hide("portal")
    inst.AnimState:OverrideSymbol("FX_ray", "portal_stone", "FX_ray")
    inst.AnimState:SetLightOverride(.2)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return
-- MakePortal2("multiplayer_portal_new", "portal_dst", "portal_stone", assets, nil, stone_common_postinit),
-- MakePortal("multiplayer_portal_moonrock_constr_new", "portal_construction_dst", "portal_stone", assets_construction,
--     prefabs_construction, construction_common_postinit, construction_master_postinit),
-- MakePortal("multiplayer_portal_moonrock_new", "portal_moonrock_dst", "portal_moonrock", assets_moonrock,
--     prefabs_moonrock, moonrock_common_postinit, moonrock_master_postinit),
-- Prefab("multiplayer_portal_moonrock_fx_new", moonrockfxfn, assets_fx),
    Prefab("wallyintro_debris_1", fn2, assets),
    Prefab("wallyintro_debris_2", fn3, assets),
    Prefab("wallyintro_debris_3", fn4, assets),
    Prefab("wallyintro_shipmast", fn5, assets)
