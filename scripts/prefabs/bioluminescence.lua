local assets =
{
    Asset("ANIM", "anim/bioluminessence.zip"),
}

local INTENSITY = .65

local function randomizefadein()
    return math.random(1, 31)
end

local function randomizefadeout()
    return math.random(32, 63)
end

local function immediatefadeout()
    return 0
end

local function resolvefaderate(x)
    --immediate fadeout -> 0
    --randomize fadein -> INTENSITY * FRAMES / (3 + math.random() * 2)
    --randomize fadeout -> -INTENSITY * FRAMES / (.75 + math.random())
    return (x == 0 and 0)
        or (x < 32 and INTENSITY * FRAMES / (3 + (x - 1) / 15))
        or INTENSITY * FRAMES / ((32 - x) / 31 - .75)
end

local function updatefade(inst, rate)
    inst._fadeval:set_local(math.clamp(inst._fadeval:value() + rate, 0, INTENSITY))

    --Client light modulation is enabled:
    inst.Light:SetIntensity(inst._fadeval:value())

    if rate == 0 or
        (rate < 0 and inst._fadeval:value() <= 0) or
        (rate > 0 and inst._fadeval:value() >= INTENSITY) then
        inst._fadetask:Cancel()
        inst._fadetask = nil
        if inst._fadeval:value() <= 0 and TheWorld.ismastersim then
            inst:AddTag("NOCLICK")
            inst.Light:Enable(false)
        end
    end
end

local function fadein(inst)
    local ismastersim = TheWorld.ismastersim
    if not ismastersim or resolvefaderate(inst._faderate:value()) <= 0 then
        if ismastersim then
            inst:RemoveTag("NOCLICK")
            inst.Light:Enable(true)
            inst.AnimState:PlayAnimation("idle_pre")
            inst.AnimState:PushAnimation("idle_loop", true)
            inst._faderate:set(randomizefadein())
        end
        if inst._fadetask ~= nil then
            inst._fadetask:Cancel()
        end
        local rate = resolvefaderate(inst._faderate:value()) * math.clamp(1 - inst._fadeval:value() / INTENSITY, 0, 1)
        inst._fadetask = inst:DoPeriodicTask(FRAMES, updatefade, nil, rate)
        if not ismastersim then
            updatefade(inst, rate)
        end
    end
end

local function fadeout(inst)
    local ismastersim = TheWorld.ismastersim
    if not ismastersim or resolvefaderate(inst._faderate:value()) > 0 then
        if ismastersim then
            inst.AnimState:PlayAnimation("idle_pst")
            inst._faderate:set(randomizefadeout())
        end
        if inst._fadetask ~= nil then
            inst._fadetask:Cancel()
        end
        local rate = resolvefaderate(inst._faderate:value()) * math.clamp(inst._fadeval:value() / INTENSITY, 0, 1)
        inst._fadetask = inst:DoPeriodicTask(FRAMES, updatefade, nil, rate)
        if not ismastersim then
            updatefade(inst, rate)
        end
    end
end

local function OnFadeRateDirty(inst)
    local rate = resolvefaderate(inst._faderate:value())
    if rate > 0 then
        fadein(inst)
    elseif rate < 0 then
        fadeout(inst)
    elseif inst._fadetask ~= nil then
        inst._fadetask:Cancel()
        inst._fadetask = nil
        inst._fadeval:set_local(0)

        --Client light modulation is enabled:
        inst.Light:SetIntensity(0)
    end
end

local function updatelight(inst)
    if not TheWorld.state.isday and inst.components.inventoryitem.owner == nil then
        fadein(inst)
    else
        fadeout(inst)
    end
end

local function ondropped(inst)
    inst.components.workable:SetWorkLeft(1)
    inst._fadeval:set(0)
    inst._faderate:set_local(immediatefadeout())
    fadein(inst)
    inst:DoTaskInTime(2 + math.random(), updatelight)
end

local function onpickup(inst)
    if inst._fadetask ~= nil then
        inst._fadetask:Cancel()
        inst._fadetask = nil
    end
    inst._fadeval:set_local(0)
    inst._faderate:set(immediatefadeout())
    inst.Light:SetIntensity(0)
    inst.Light:Enable(false)
end

local function onworked(inst, worker)
    if worker.components.inventory ~= nil then
        worker.components.inventory:GiveItem(inst, nil, inst:GetPosition())
    end
end

local function getstatus(inst)
    if inst.components.inventoryitem.owner ~= nil then
        return "HELD"
    end
end

local function OnIsNight(inst)
    inst:DoTaskInTime(2 + math.random(), updatelight)
end

local function OnTimerDone(inst, data)
    if data.name == "vaiembora" then
        local invader = GetClosestInstWithTag("player", inst, 25)
        if not invader then
            inst:Remove()
        else
            inst.components.timer:StartTimer("vaiembora", 10)
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddPhysics()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")

    inst.Light:SetFalloff(.45)
    inst.Light:SetIntensity(0.65)
    inst.Light:SetRadius(0.9)
    inst.Light:SetColour(0 / 255, 180 / 255, 255 / 255)
    inst.Light:Enable(false)
    inst.Light:EnableClientModulation(true)

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.AnimState:SetBank("bioluminessence")
    inst.AnimState:SetBuild("bioluminessence")
    inst.AnimState:SetRayTestOnBB(true)

    inst:AddTag("cattoyairborne")

    inst._fadeval = net_float(inst.GUID, "fireflies._fadeval")
    inst._faderate = net_smallbyte(inst.GUID, "fireflies._faderate", "onfaderatedirty")
    inst._fadetask = nil

    inst.entity:SetPristine()

    inst:AddTag("aquatic")
    --	inst:AddTag("tropicalspawner")	
    inst:AddTag("bioluminescence")

    if not TheWorld.ismastersim then
        inst:ListenForEvent("onfaderatedirty", OnFadeRateDirty)

        return inst
    end

    inst:AddComponent("playerprox")

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onworked)

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst.components.stackable.forcedropsingle = true

    inst:AddComponent("inventoryitem")


    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem:SetOnPickupFn(onpickup)
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true

    inst:AddComponent("tradable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
    inst.components.fuel.fueltype = FUELTYPE.CAVE

    inst.components.playerprox:SetDist(3, 5)
    inst.components.playerprox:SetOnPlayerNear(updatelight)
    inst.components.playerprox:SetOnPlayerFar(updatelight)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:WatchWorldState("isnight", OnIsNight)
    inst:WatchWorldState("stopday", OnIsNight)

    updatelight(inst)

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)
    inst.components.timer:StartTimer("vaiembora", 480)

    return inst
end

return Prefab("common/bioluminescence", fn, assets, prefabs)
