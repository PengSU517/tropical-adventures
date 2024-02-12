require "prefabutil"
require "recipes"

local assets =
{
    -------house
    Asset("ANIM", "anim/pig_house_sale.zip"),


    Asset("ANIM", "anim/player_small_house1.zip"),
    Asset("ANIM", "anim/player_large_house1.zip"),
    Asset("ANIM", "anim/player_large_house1_manor_build.zip"),
    Asset("ANIM", "anim/player_large_house1_villa_build.zip"),
    Asset("ANIM", "anim/player_small_house1_cottage_build.zip"),
    Asset("ANIM", "anim/player_small_house1_tudor_build.zip"),
    Asset("ANIM", "anim/player_small_house1_gothic_build.zip"),
    Asset("ANIM", "anim/player_small_house1_brick_build.zip"),
    Asset("ANIM", "anim/player_small_house1_turret_build.zip"),


    ---------doors?-----------
    -- Asset("ANIM", "anim/pisohamlet.zip"),
    -- Asset("ANIM", "anim/pig_shop_doormats.zip"),
    -- Asset("ANIM", "anim/wallhamletcity1.zip"),
    -- Asset("ANIM", "anim/wallhamletcity2.zip"),
    Asset("ANIM", "anim/portas.zip"),
}





local prefabs =
{

}

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end

    data.build = inst.build
    data.bank = inst.bank
    data.icon = inst.icon


    data.room = inst.room or nil
end

local function onload(inst, data)
    if data and data.burnt then
        inst.components.burnable.onburnt(inst)
    end

    if data and data.build then
        inst.build = data.build
        inst.AnimState:SetBuild(inst.build)
    end

    if data and data.bank then
        inst.bank = data.bank
        inst.AnimState:SetBank(inst.bank)
    end

    if data and data.icon then
        inst.icon = data.icon
        inst.MiniMapEntity:SetIcon(inst.icon)
    end

    if data and data.sounds then
        inst.usesounds = data.sounds
    end

    if data and data.room then
        inst.room = data.room or false
    end
end

local function onbuild_interior(inst)
    local size = 1
    local length = 7 * size --5.5
    local width = 12 * size --8.5

    if not TheWorld.components.getposition_hamroom or TheWorld.components.getposition_hamroom:IsMax() then
        return
    end

    local x, z = TheWorld.components.getposition_hamroom:GetPosition()

    local exit = SpawnPrefab("playerhouse_city_door_saida")
    exit.Transform:SetPosition(x + 6 * size, 0, z)

    inst.components.teleporter.targetTeleporter = exit
    exit.components.teleporter.targetTeleporter = inst

    -- exit.components.myth_teleporter:Target(inst)
    -- inst.components.myth_teleporter:Target(exit) --使得出口和入口互相锁定为传送目标

    -- local part = SpawnPrefab("playerhouse_center")
    -- if part ~= nil then
    --     part.Transform:SetPosition(x - 1.5 * size, 0, z) -----------------怪不得，这是视角的中心
    -- end

    local part = SpawnPrefab("playerhouse_city_floor")
    if part ~= nil then
        part.Transform:SetPosition(x - 1.5 * size, 0, z) -----------------怪不得，这是视角的中心
    end

    inst.room = true
    TheWorld.components.getposition_hamroom:BuildHouse()




    local POS = {}
    for x = -length, length do
        for z = -width, width do
            if x == -length or x == (length) or z == -width or z == width then
                table.insert(POS, { x = x, z = z })
            end
        end
    end


    local count = 0
    for _, v in pairs(POS) do
        count = count + 1
        local part = SpawnPrefab("house_wall2")
        part.Transform:SetPosition(x + v.x, 0, z + v.z)
    end


    local part = SpawnPrefab("wallinteriorplayerhouse") -----------墙纸贴图
    if part ~= nil then
        part.Transform:SetPosition(x - 6 * size, -1.4, z)
        part.Transform:SetRotation(90)
    end





    -- local part = SpawnPrefab("playerhouse_room_pedra_cima")
    -- if part ~= nil then
    --     part.Transform:SetPosition(x - 6.5, 0, z + 3.9)
    --     part.Transform:SetRotation(90)
    -- end

    -- local part = SpawnPrefab("deco_roomglow") ---这个是光亮效果？-------仍然不知道啥用
    -- if part ~= nil then
    -- 	part.Transform:SetPosition(x, 0, z)
    -- end

    -- local part = SpawnPrefab("shelves_cinderblocks")
    -- if part ~= nil then
    --     part.Transform:SetPosition(x - 5.5 * size, 0, z - 4 * size)
    --     part.Transform:SetRotation(-90)
    -- end

    -- local part = SpawnPrefab("deco_antiquities_wallfish")
    -- --门也是替代的这个墙纸
    -- if part ~= nil then
    --     part.Transform:SetPosition(x - 6.5 * size, 0, z + 4 * size)
    --     part.Transform:SetRotation(90)
    -- end

    local part = SpawnPrefab("deco_antiquities_cornerbeam")
    if part ~= nil then
        part.Transform:SetPosition(x - 6.5 * size, 0, z - 11.5 * size)
        --	part.Transform:SetRotation(180)
        part.Transform:SetScale(1, 1.3, 1) ---设置z没用
    end

    local part = SpawnPrefab("deco_antiquities_cornerbeam")
    if part ~= nil then
        part.Transform:SetPosition(x - 6.5 * size, 0, z + 11.5 * size)
        part.Transform:SetRotation(90)
        part.Transform:SetScale(1, 1.3, 1) ---设置z没用
    end

    local part = SpawnPrefab("deco_antiquities_cornerbeam2")
    if part ~= nil then
        part.Transform:SetPosition(x + 6.5 * size, 0, z - 11.5 * size)
        --	part.Transform:SetRotation(180)
        part.Transform:SetScale(1, 1.2, 1)
    end

    local part = SpawnPrefab("deco_antiquities_cornerbeam2")
    if part ~= nil then
        part.Transform:SetPosition(x + 6.5 * size, 0, z + 11.5 * size)
        part.Transform:SetRotation(180)
        part.Transform:SetScale(1, 1.2, 1) ---设置z没用
    end


    local part = SpawnPrefab("swinging_light_rope_1")
    if part ~= nil then
        part.Transform:SetPosition(x - 0 * size, 3, z)
        part.Transform:SetRotation(-90)
    end

    local part = SpawnPrefab("window_round_curtains_nails") -----------之前的亮度设置时通过窗户影响光亮的，反而灯没有受影响
    if part ~= nil then
        part.Transform:SetPosition(x, 0, z + 11.5 * size)
    end

    local part = SpawnPrefab("window_round_curtains_nails") -----------之前的亮度设置时通过窗户影响光亮的，反而灯没有受影响
    if part ~= nil then
        part.Transform:SetPosition(x, 0, z - 11.5 * size)
    end
end

--------------------------------------do teleporter------------------------
local function OnDoneTeleporting(inst, obj) ------------这是从房间出来
    if obj ~= nil and obj.Transform then
        local pos = obj:GetPosition()
        local offset = FindWalkableOffset(pos, math.random() * 2 * PI, 2, 10)
        if offset ~= nil then
            pos.x = pos.x + math.abs(offset.x)
            pos.z = pos.z + offset.z
        end
        if obj.Physics ~= nil then
            obj.Physics:Teleport(pos.x, pos.y, pos.z)
        elseif obj.Transform ~= nil then
            obj.Transform:SetPosition(pos.x, pos.y, pos.z)
        end
    end

    if obj and obj:HasTag("player") then
        obj.mynetvarCameraMode:set(6)
    end

    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_close")
end


local function OnActivateByOther(inst, source, doer)
    if doer ~= nil and doer.Physics ~= nil then
        doer.Physics:CollidesWith(COLLISION.WORLD)
    end
end

local function OnActivate(inst, doer)
    if doer:HasTag("player") then
        doer.mynetvarCameraMode:set(1)
    end
    if inst.SoundEmitter ~= nil then
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_open")
    end

    if doer and doer:HasTag("player") then
        if doer.SoundEmitter ~= nil then
            doer.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_open")
        end
    end
end

local function ShouldAcceptItem(inst, item)
    if item:HasTag("decoradordecasa") then
        return true
    else
        return false
    end
end

local function onaccept(inst, giver, item)
    inst.components.inventory:DropItem(item)
    inst.components.teleporter:Activate(item)
end

local function OnGetItemFromPlayer(inst, giver, item)
    if inst.prefab:find("playerhouse_city") then
        if item.prefab:find("player_house_") and item.prefab:find("_craft") then
            local craftname1 = item.prefab:gsub("player_house_", "", 1)
            local craftname = craftname1:gsub("_craft", "")


            inst.icon = "player_house_" .. craftname .. ".png"

            if craftname == "villa" or craftname == "manor" then
                inst.bank = "playerhouse_large"
                inst.build = "player_large_house1_" .. craftname .. "_build"
            else
                inst.bank = "playerhouse_small"
                inst.build = "player_small_house1_" .. craftname .. "_build"
            end


            inst.AnimState:SetBank(inst.bank)
            inst.AnimState:SetBuild(inst.build)
            inst.MiniMapEntity:SetIcon(inst.icon)
        end
    else
        onaccept(inst, giver, item)
    end
    -- if item.prefab == "player_house_cottage_craft" then
    --     inst.build = "player_small_house1_cottage_build"
    --     inst.AnimState:SetBuild("player_small_house1_cottage_build")
    --     inst.bank = "playerhouse_small"
    --     inst.AnimState:SetBank("playerhouse_small")
    --     inst.MiniMapEntity:SetIcon("player_house_cottage.png")
    -- end
end

local function onhammered(inst, worker)
    local targetpos = inst:GetPosition()
    local package = SpawnPrefab("bundled_structure")
    if package and package.components.bundled_structure then
        if inst.components.teleporter ~= nil and inst.components.teleporter:IsBusy() then
            return false
        end
        package.components.bundled_structure:Pack(inst)
        package.Transform:SetPosition(targetpos:Get())
        SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
        if worker and worker.SoundEmitter then
            worker.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
            ---------为啥这里是人播放音效啊，不该是锤烂的房子吗
        end
    end
end

local function OnSnowCoveredChagned(inst, covered)
    if TheWorld.state.issnowcovered then
        inst.AnimState:OverrideSymbol("snow", inst.build, "snow")
    else
        inst.AnimState:OverrideSymbol("snow", inst.build, "emptysnow")
    end
end




local function updatelight(inst, phase)
    if phase == "night" or phase == "dusk" then
        inst.Light:Enable(true)
        inst.AnimState:PlayAnimation("lit") -------------光亮的动画有问题
    else
        inst.Light:Enable(false)
        inst.AnimState:PlayAnimation("idle")
    end
end


local function makehousefn(name, build, bank, data)
    local function fn(Sim)
        local inst = CreateEntity()
        local trans = inst.entity:AddTransform()
        local anim = inst.entity:AddAnimState()
        local light = inst.entity:AddLight()
        inst.entity:AddNetwork()
        inst.entity:AddSoundEmitter()
        inst.build = build
        inst.bank = bank

        local minimap = inst.entity:AddMiniMapEntity()
        minimap:SetIcon("pig_house_sale.png")

        light:SetFalloff(1)     --没看出来干啥的
        light:SetIntensity(0.5) --设置光的衰减速度
        light:SetRadius(5)
        light:Enable(true)
        light:SetColour(180 / 255, 195 / 255, 50 / 255) ---RGB色彩调节
        -------SetColour(180 / 255, 195 / 255, 50 / 255)黄光太暖了
        inst.Transform:SetScale(0.75, 0.75, 0.75)

        MakeObstaclePhysics(inst, 0.75)

        anim:SetBank(bank)
        anim:SetBuild(build)
        anim:PlayAnimation("idle", true)
        inst.AnimState:Hide("boards")

        inst:AddTag(name)
        inst:AddTag("structure")
        inst:AddTag("hamletteleport")
        inst:AddTag("antlion_sinkhole_blocker")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("lootdropper")
        inst:AddComponent("interactions")

        inst:AddComponent("teleporter")
        inst.components.teleporter.onActivate = OnActivate
        inst.components.teleporter.onActivateByOther = OnActivateByOther
        inst.components.teleporter.offset = 0
        inst.components.teleporter.hamlet = true
        inst.components.teleporter.travelcameratime = 0.3
        inst.components.teleporter.travelarrivetime = 0
        inst:ListenForEvent("doneteleporting", OnDoneTeleporting)


        inst:AddComponent("inventory")
        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(ShouldAcceptItem)
        inst.components.trader.acceptnontradable = true
        inst.components.trader.onaccept = OnGetItemFromPlayer
        inst.components.trader.deleteitemonaccept = false


        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(4)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit)


        inst:AddComponent("inspectable")

        inst:WatchWorldState("issnowcovered", OnSnowCoveredChagned)
        OnSnowCoveredChagned(inst) --为啥要写两次啊，还少了个参数

        inst:WatchWorldState("phase", updatelight)
        updatelight(inst, TheWorld.state.phase)

        -- print("before dotaskintime !!!!!!!!!!!!!!!!!")
        -- print(inst.room) ------------这时候调用不到任何东西,所有需要调用onsave的东西需要在dotaskintime里

        inst:DoTaskInTime(0.1, function(inst)
            if not inst.room then
                onbuild_interior(inst)
            end
        end)

        inst:ListenForEvent("onbuilt", onbuilt)

        inst.OnSave = onsave
        inst.OnLoad = onload

        return inst
    end
    return fn
end

local function makehouse(name, build, bank, data)
    return Prefab("common/objects/" .. name, makehousefn(name, build, bank, data), assets, prefabs)
end


--------------------------------------do teleporter------------------------
local function OnDoneDoorTeleporting(inst, obj) ------------这是从房间出来
    if obj ~= nil and obj.Transform then
        local pos = obj:GetPosition()
        local offset = FindWalkableOffset(pos, math.random() * 2 * PI, 2, 10)
        if offset ~= nil then
            pos.x = pos.x + math.abs(offset.x)
            pos.z = pos.z + offset.z
        end
        if obj.Physics ~= nil then
            obj.Physics:Teleport(pos.x, pos.y, pos.z)
        elseif obj.Transform ~= nil then
            obj.Transform:SetPosition(pos.x, pos.y, pos.z)
        end
    end

    if obj and obj:HasTag("player") then
        obj.mynetvarCameraMode:set(4)
    end

    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_close")
end


local function OnActivateDoorByOther(inst, source, doer)
    -- if doer ~= nil and doer.Physics ~= nil then
    --     doer.Physics:CollidesWith(COLLISION.WORLD)
    -- end
end

local function OnActivateDoor(inst, doer)
    if doer:HasTag("player") then
        doer.mynetvarCameraMode:set(6)
    end
    if inst.SoundEmitter ~= nil then
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_open")
    end

    if doer and doer:HasTag("player") then
        if doer.SoundEmitter ~= nil then
            doer.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/store/door_open")
        end
    end
end




local function makedoorfn(name, build, bank, animation, data)
    local function fn(Sim)
        local inst = CreateEntity()
        local trans = inst.entity:AddTransform()
        local anim = inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.entity:AddSoundEmitter()
        inst.build = build
        inst.bank = bank

        local minimap = inst.entity:AddMiniMapEntity()
        -- minimap:SetIcon("pig_house_sale.png")


        inst.Transform:SetScale(2, 2, 2)

        -- MakeObstaclePhysics(inst, 0)

        anim:SetBank(bank)
        anim:SetBuild(build)

        anim:PlayAnimation(animation, true)

        inst:AddTag("structure")
        inst:AddTag("hamletteleport")
        inst:AddTag("trader")
        inst:AddTag("alltrader")
        inst:AddTag("guard_entrance")
        inst:AddTag("liberado")
        inst:AddTag("portadacasa")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("lootdropper")
        inst:AddComponent("interactions")

        inst:AddComponent("teleporter")
        inst.components.teleporter.onActivate = OnActivateDoor
        inst.components.teleporter.onActivateByOther = OnActivateDoorByOther
        inst.components.teleporter.offset = 0
        inst.components.teleporter.hamlet = true
        inst.components.teleporter.travelcameratime = 0.3
        inst.components.teleporter.travelarrivetime = 0
        inst:ListenForEvent("doneteleporting", OnDoneDoorTeleporting)


        inst:AddComponent("inventory")
        inst:AddComponent("trader")
        -- inst.components.trader:SetAcceptTest(ShouldAcceptItem)
        inst.components.trader.acceptnontradable = true
        inst.components.trader.onaccept = OnGetItemFromPlayer
        inst.components.trader.deleteitemonaccept = false


        -- inst:AddComponent("workable")
        -- inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        -- inst.components.workable:SetWorkLeft(4)
        -- inst.components.workable:SetOnFinishCallback(onhammered)
        -- inst.components.workable:SetOnWorkCallback(onhit)


        inst:AddComponent("inspectable")
        inst.components.inspectable.nameoverride = "playerhouse_city_door_" .. animation .. "_cima"
        local instname = "PLAYERHOUSE_CITY_DOOR_" .. animation:upper() .. "_CIMA"
        inst.name = STRINGS.NAMES[instname] ----------套用别的prefab的名字

        inst:DoTaskInTime(0.1, function(inst)
            if not inst.room then
                onbuild_interior(inst)
            end
        end)

        inst:ListenForEvent("onbuilt", onbuilt)

        inst.OnSave = onsave
        inst.OnLoad = onload

        return inst
    end
    return fn
end



local function makedoor(name, build, bank, animation, data)
    return Prefab("common/objects/" .. name, makedoorfn(name, build, bank, animation, data), assets, prefabs)
end

local function placefn(inst)
    inst.Transform:SetScale(0.75, 0.75, 0.75)
    inst.AnimState:Hide("snow")
    inst.AnimState:Hide("boards")
end

local function placedoorfn(inst)
    inst.Transform:SetScale(2, 2, 2)
    -- inst.AnimState:Hide("snow")
    -- inst.AnimState:Hide("boards")
end

return makehouse("playerhouse_city", "pig_house_sale", "pig_house_sale", { indestructable = true }),
    makedoor("playerhouse_city_door_pedra_cima", "portas", "portas", "pedra", { indestructable = true }),
    makedoor("playerhouse_city_door_metal_cima", "portas", "portas", "metal", { indestructable = true }),
    makedoor("playerhouse_city_door_pano_cima", "portas", "portas", "pano", { indestructable = true }),
    makedoor("playerhouse_city_door_peagank_cima", "portas", "portas", "peagank", { indestructable = true }),

    ---------------------------需要根据原本的调整camera
    -- MakePlacer("common/playerhouse_city_placer", "pig_house_sale", "pig_house_sale", "idle", false, false, false)
    MakePlacer("common/playerhouse_city_placer", "pig_house_sale", "pig_house_sale", "idle", nil, nil, nil, nil, nil, nil,
        placefn)
