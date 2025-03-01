local assets =
{
    Asset("ANIM", "anim/peekhen_shadow.zip"),
    Asset("ANIM", "anim/peekhen_build.zip"),
}

local spawner_assets =
{
    Asset("MINIMAP_IMAGE", "peekhen"),
}

local prefabs =
{
    "peekhen",
    "circlingpeekhen",
}

local FOOD_TAGS = { "edible_" .. FOODTYPE.MEAT, "prey" }
local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }

local function RemovepeekhenShadow(inst, shadow)
    shadow:KillShadow()
    for i, v in ipairs(inst.peekhenshadows) do
        if v == shadow then
            table.remove(inst.peekhenshadows, i)
            return
        end
    end
end

local function SpawnpeekhenShadow(inst)
    local shadow = SpawnPrefab("circlingpeekhen")
    shadow.components.circler:SetCircleTarget(inst)
    shadow.components.circler:Start()
    table.insert(inst.peekhenshadows, shadow)
end

local function UpdateShadows(inst)
    local count = inst.components.childspawner.childreninside
    local old = #inst.peekhenshadows
    if old < count then
        for i = old + 1, count do
            SpawnpeekhenShadow(inst)
        end
    elseif old > count then
        for i = old, count + 1, -1 do
            RemovepeekhenShadow(inst, inst.peekhenshadows[i])
        end
    end
end

local function ReturnChildren(inst)
    for k, child in pairs(inst.components.childspawner.childrenoutside) do
        if child.components.homeseeker ~= nil then
            child.components.homeseeker:GoHome()
        end
        child:PushEvent("gohome")
    end
end

local function OnSpawn(inst, child)
    for i, shadow in ipairs(inst.peekhenshadows) do
        local dist = shadow.components.circler.distance
        local angle = shadow.components.circler.angleRad
        local pos = inst:GetPosition()
        local offset = FindWalkableOffset(pos, angle, dist, 8, false)
        if offset ~= nil then
            child.Transform:SetPosition(pos.x + offset.x, 30, pos.z + offset.z)
        else
            child.Transform:SetPosition(pos.x, 30, pos.y)
        end
        child.sg:GoToState("glide")
        RemovepeekhenShadow(inst, shadow)
        return
    end
end

local function stophuntingfood(inst)
    local food = inst.foodHunted or inst
    local peekhen = inst.peekhenHunted or inst
    if food ~= nil and peekhen ~= nil then
        food.peekhenHunted = nil
        peekhen.foodHunted = nil
        food:RemoveEventCallback("onpickup", stophuntingfood)
        food:RemoveEventCallback("onremove", stophuntingfood)
        peekhen:RemoveEventCallback("onremove", stophuntingfood)
    end
end

local function CanBeHunted(food)
    return food.peekhenHunted == nil and food:IsOnValidGround() and
        FindEntity(food, 3, nil, { "peekhen" }, NO_TAGS) == nil
end

local function LookForFood(inst)
    if not inst.components.childspawner:CanSpawn() or math.random() <= .25 then
        return
    end

    local food = FindEntity(inst, 25, CanBeHunted, nil, NO_TAGS, FOOD_TAGS)
    if food ~= nil then
        local peekhen = inst.components.childspawner:SpawnChild()
        if peekhen ~= nil then
            local x, y, z = food.Transform:GetWorldPosition()
            peekhen.Transform:SetPosition(x + math.random() * 3 - 1.5, 30, z + math.random() * 3 - 1.5)
            peekhen:FacePoint(x, y, z)

            if food:HasTag("prey") then
                peekhen.sg.statemem.target = food
            end

            food.peekhenHunted = peekhen
            peekhen.foodHunted = food
            food:ListenForEvent("onpickup", stophuntingfood)
            food:ListenForEvent("onremove", stophuntingfood)
            peekhen:ListenForEvent("onremove", stophuntingfood)

            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/peekhen/distant")
        end
    end
end

local function CancelAwakeTasks(inst)
    if inst.waketask ~= nil then
        inst.waketask:Cancel()
        inst.waketask = nil
    end
    if inst.foodtask ~= nil then
        inst.foodtask:Cancel()
        inst.foodtask = nil
    end
end

local function OnEntitySleep(inst)
    for i = #inst.peekhenshadows, 1, -1 do
        inst.peekhenshadows[i]:Remove()
        table.remove(inst.peekhenshadows, i)
    end
    CancelAwakeTasks(inst)
end

local function OnWakeTask(inst)
    inst.waketask = nil
    if not inst:IsAsleep() then
        UpdateShadows(inst)
    end
end

local function OnEntityWake(inst)
    if inst.waketask == nil then
        inst.waketask = inst:DoTaskInTime(.5, OnWakeTask)
    end
    if inst.foodtask == nil then
        inst.foodTask = inst:DoPeriodicTask(math.random(20, 40) * .1, LookForFood)
    end
end

local function SpawnerOnIsNight(inst, isnight)
    if isnight then
        inst.OnEntityWake = nil
        inst.components.childspawner:StopSpawning()
        if not inst.components.childspawner.regening and inst.components.childspawner.numchildrenoutside + inst.components.childspawner.childreninside < inst.components.childspawner.maxchildren then
            inst.components.childspawner:StartRegen()
        end
        ReturnChildren(inst)
        CancelAwakeTasks(inst)
    else
        inst.OnEntityWake = OnEntityWake
        inst.components.childspawner:StartSpawning()
        if not inst:IsAsleep() then
            OnEntityWake(inst)
        end
    end
end

local function SpawnerOnIsWinter(inst, iswinter)
    if iswinter then
        inst.OnEntityWake = nil
        inst:StopWatchingWorldState("isnight", SpawnerOnIsNight)
        inst.components.childspawner:StopSpawning()
        inst.components.childspawner:StopRegen()
        ReturnChildren(inst)
        CancelAwakeTasks(inst)
    else
        inst:WatchWorldState("isnight", SpawnerOnIsNight)
        SpawnerOnIsNight(inst, TheWorld.state.isnight)
    end
end

local function OnAddChild(inst)
    UpdateShadows(inst)
    if inst.components.childspawner.numchildrenoutside + inst.components.childspawner.childreninside >= inst.components.childspawner.maxchildren then
        inst.components.childspawner:StopRegen()
    end
end

local function SpawnerOnInit(inst)
    inst.OnEntitySleep = OnEntitySleep
    inst:WatchWorldState("iswinter", SpawnerOnIsWinter)
    SpawnerOnIsWinter(inst, TheWorld.state.iswinter)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("peekhen.tex")

    inst:AddTag("peekhenspawner")
    inst:AddTag("CLASSIFIED")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "peekhen"
    inst.components.childspawner:SetSpawnedFn(OnSpawn)
    inst.components.childspawner:SetOnAddChildFn(OnAddChild)
    inst.components.childspawner:SetMaxChildren(2)
    inst.components.childspawner:SetSpawnPeriod(TUNING.BUZZARD_SPAWN_PERIOD +
        math.random(-TUNING.BUZZARD_SPAWN_VARIANCE, TUNING.BUZZARD_SPAWN_VARIANCE))
    inst.components.childspawner:SetRegenPeriod(TUNING.BUZZARD_REGEN_PERIOD)
    inst.components.childspawner:StopRegen()

    inst.peekhenshadows = {}
    inst.foodtask = nil
    inst.waketask = nil
    inst:DoTaskInTime(0, SpawnerOnInit)

    return inst
end

-----------------------------------------------------------------------------------

local MAX_FADE_FRAME = math.floor(3 / FRAMES + .5)

local function OnUpdateFade(inst, dframes)
    local done
    if inst._isfadein:value() then
        local frame = inst._fadeframe:value() + dframes
        done = frame >= MAX_FADE_FRAME
        inst._fadeframe:set_local(done and MAX_FADE_FRAME or frame)
    else
        local frame = inst._fadeframe:value() - dframes
        done = frame <= 0
        inst._fadeframe:set_local(done and 0 or frame)
    end

    local k = inst._fadeframe:value() / MAX_FADE_FRAME
    inst.AnimState:OverrideMultColour(1, 1, 1, k)

    if done then
        inst._fadetask:Cancel()
        inst._fadetask = nil
        if inst._killed then
            --don't need to check ismastersim, _killed will never be set on clients
            inst:Remove()
            return
        end
    end

    if TheWorld.ismastersim then
        if inst._fadeframe:value() > 0 then
            inst:Show()
        else
            inst:Hide()
        end
    end
end

local function OnFadeDirty(inst)
    if inst._fadetask == nil then
        inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade, nil, 1)
    end
    OnUpdateFade(inst, 0)
end

local function CircleOnIsNight(inst, isnight)
    inst._isfadein:set(not isnight)
    inst._fadeframe:set(inst._fadeframe:value())
    OnFadeDirty(inst)
end

local function CircleOnIsWinter(inst, iswinter)
    if iswinter then
        inst:StopWatchingWorldState("isnight", CircleOnIsNight)
        CircleOnIsNight(inst, true)
    else
        inst:WatchWorldState("isnight", CircleOnIsNight)
        CircleOnIsNight(inst, TheWorld.state.isnight)
    end
end

local function CircleOnInit(inst)
    inst:WatchWorldState("iswinter", CircleOnIsWinter)
    CircleOnIsWinter(inst, TheWorld.state.iswinter)
end

local function DoFlap(inst)
    if math.random() > 0.66 then
        inst.AnimState:PlayAnimation("shadow_flap_loop")
        for i = 2, math.random(3, 6) do
            inst.AnimState:PushAnimation("shadow_flap_loop")
        end
        inst.AnimState:PushAnimation("shadow")
    end
end

local function KillShadow(inst)
    if inst._fadeframe:value() > 0 and not inst:IsAsleep() then
        inst:StopWatchingWorldState("iswinter", CircleOnIsWinter)
        inst:StopWatchingWorldState("isnight", CircleOnIsNight)
        inst._killed = true
        inst._isfadein:set(false)
        inst._fadeframe:set(inst._fadeframe:value())
        OnFadeDirty(inst)
    else
        inst:Remove()
    end
end

local function circlingpeekhenfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("peekhen_shadow")
    inst.AnimState:SetBuild("peekhen_shadow")
    inst.AnimState:PlayAnimation("shadow", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:OverrideMultColour(1, 1, 1, 0)

    inst:AddTag("FX")

    inst._fadeframe = net_byte(inst.GUID, "circlingpeekhen._fadeframe", "fadedirty")
    inst._isfadein = net_bool(inst.GUID, "circlingpeekhen._isfadein", "fadedirty")
    inst._fadetask = nil

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("fadedirty", OnFadeDirty)

        return inst
    end

    inst:AddComponent("circler")

    inst:DoTaskInTime(0, CircleOnInit)
    inst:DoPeriodicTask(math.random(3, 5), DoFlap)

    inst.KillShadow = KillShadow

    inst.persists = false

    return inst
end

return Prefab("peekhenspawner", fn, spawner_assets, prefabs),
    Prefab("circlingpeekhen", circlingpeekhenfn, assets)
