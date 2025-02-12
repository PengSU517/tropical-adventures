require "stategraphs/SGpiko"

local INTENSITY = .5
local PIKO_HEALTH = 100
local PIKO_RUN_SPEED = 4
local PIKO_DAMAGE = 2
local PIKO_ATTACK_PERIOD = 2
local PIKO_TARGET_DIST = 20
local PIKO_RABID_SANITY_THRESHOLD = .8

local assets = {Asset("ANIM", "anim/ds_squirrel_basic.zip"), Asset("ANIM", "anim/squirrel_cheeks_build.zip"),
                Asset("ANIM", "anim/squirrel_build.zip"), Asset("ANIM", "anim/orange_squirrel_cheeks_build.zip"),
                Asset("ANIM", "anim/orange_squirrel_build.zip"), Asset("INV_IMAGE", "piko_orange"),
                Asset("SOUND", "sound/rabbit.fsb")}

local prefabs = {"smallmeat", "cookedsmallmeat"}

local pikosounds = {
    scream = "dontstarve_DLC003/creatures/piko/scream",
    hurt = "dontstarve_DLC003/creatures/piko/scream",
}

local brain = require "brains/pikobrain"

local function updatebuild(inst, cheeks)
    inst.AnimState:SetBuild(
        (inst:HasTag("orange") and "orange_" or "") .. "squirrel_" .. (cheeks and "cheeks_" or "") .. "build")
end

local function OnDrop(inst) inst.sg:GoToState("stunned") end

local function OnCooked(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/piko/scream") end

local function OnAttacked(inst, data)
    local x, y, z = inst.Transform:GetWorldPosition()
    local pikos = TheSim:FindEntities(x, y, z, 30, {"piko"})
    for i = 1, math.min(#pikos, 5) do
        if pikos[i] and pikos[i]:IsValid() then pikos[i]:PushEvent("gohome") end
    end
end

local function OnWentHome(inst)
    local tree = inst.components.homeseeker and inst.components.homeseeker.home
    if not tree then return end
    if tree.components.inventory then
        inst.components.inventory:TransferInventory(tree)
        updatebuild(inst, false)
    end
end

local function Retarget(inst)
    return FindEntity(inst, PIKO_TARGET_DIST, function(guy)
        return not guy:HasTag("piko") and inst.components.combat:CanTarget(guy) and guy.components.inventory and
                   (guy.components.inventory:NumItems() > 0)
    end)
end

local function KeepTarget(inst, target) return inst.components.combat:CanTarget(target) end

local function OnStolen(inst, victim, item) updatebuild(inst, true) end

local function fadein(inst)
    inst.components.fader:StopAll()
    inst.AnimState:Show("eye_red")
    inst.AnimState:Show("eye2_red")
    inst.Light:Enable(true)
    if inst:IsAsleep() then
        inst.Light:SetIntensity(INTENSITY)
    else
        inst.Light:SetIntensity(0)
        inst.components.fader:Fade(0, INTENSITY, 3 + math.random() * 2, function(v) inst.Light:SetIntensity(v) end)
    end
end

local function fadeout(inst)
    inst.components.fader:StopAll()
    inst.AnimState:Hide("eye_red")
    inst.AnimState:Hide("eye2_red")
    if inst:IsAsleep() then
        inst.Light:SetIntensity(0)
    else
        inst.components.fader:Fade(INTENSITY, 0, 0.75 + math.random() * 1, function(v) inst.Light:SetIntensity(v) end)
    end
end

local function updatelight(inst)
    if inst.currentlyRabid then
        if not inst.lighton then
            inst:DoTaskInTime(math.random() * 2, function() fadein(inst) end)
        else
            inst.Light:Enable(true)
            inst.Light:SetIntensity(INTENSITY)
        end
        inst.AnimState:Show("eye_red")
        inst.AnimState:Show("eye2_red")
        inst.AnimState:SetBuild("orange_squirrel_build")

        inst.lighton = true
    else
        if inst.lighton then
            inst:DoTaskInTime(math.random() * 2, function() fadeout(inst) end)
        else
            inst.Light:Enable(false)
            inst.Light:SetIntensity(0)
        end

        inst.AnimState:Hide("eye_red")
        inst.AnimState:Hide("eye2_red")
        inst.AnimState:SetBuild("squirrel_build")

        inst.lighton = false
    end
end

local function SetAsRabid(inst, rabid)
    inst.currentlyRabid = rabid
    inst.components.sleeper.nocturnal = rabid
    updatelight(inst)
end

local function transformtest(inst)
    if TheWorld.state.isnight and (TheWorld.state.moonphase == "full") or TheWorld.state.isaporkalypse then
        if not inst.currentlyRabid then
            inst:DoTaskInTime(1 + math.random(), function() SetAsRabid(inst, true) end)
        end
    else
        if inst.currentlyRabid then
            inst:DoTaskInTime(1 + math.random(), function() SetAsRabid(inst, false) end)
        end
    end
end

local function onpickup(inst, data)
    if data.owner.components.inventory or data.owner.components.container then
        inst.components.inventory:TransferInventory(data.owner)
    end
    updatebuild(inst, false)
end

local function fn()
    local inst = CreateEntity()

    local trans = inst.entity:AddTransform()
    trans:SetFourFaced()
    
    local anim = inst.entity:AddAnimState()
    anim:SetBank("squirrel")
    anim:SetBuild("squirrel_build")
    anim:PlayAnimation("idle", true)
    
    inst.entity:AddPhysics()
    inst.entity:AddSoundEmitter()

    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(1, 0.75)

    inst.entity:AddNetwork()

    local light = inst.entity:AddLight()
    light:SetIntensity(INTENSITY)
    light:SetColour(150 / 255, 40 / 255, 40 / 255) -- 197 10 10
    light:SetFalloff(.9)
    light:SetRadius(2)
    light:Enable(false)

    inst:AddComponent("fader")

    MakeCharacterPhysics(inst, 1, .12)

    inst.currentlyRabid = false

    inst:AddTag("animal")
    inst:AddTag("prey")
    inst:AddTag("piko")
    inst:AddTag("smallcreature")
    inst:AddTag("canbetrapped")
    inst:AddTag("cannotstealequipped")
    inst:AddTag("cattoy")
    inst:AddTag("catfood")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = PIKO_RUN_SPEED

    inst.data = {}

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({FOODTYPE.SEEDS}, {FOODTYPE.SEEDS})

    inst:AddComponent("inventory")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false

    inst.force_onwenthome_message = true
    inst:AddComponent("sanityaura")

    inst:AddComponent("cookable")
    inst.components.cookable.product = "cookedsmallmeat"
    inst.components.cookable:SetOnCookedFn(OnCooked)

    inst:AddComponent("knownlocations")

    local combat = inst:AddComponent("combat")
    combat:SetDefaultDamage(PIKO_DAMAGE)
    combat:SetAttackPeriod(PIKO_ATTACK_PERIOD)
    combat:SetRange(.7)
    combat:SetRetargetFunction(3, Retarget)
    combat:SetKeepTargetFunction(KeepTarget)
    combat.hiteffectsymbol = "chest"
    combat.onhitotherfn = function(inst, other, damage) inst.components.thief:StealItem(other) end

    inst:AddComponent("thief")
    inst.components.thief:SetOnStolenFn(OnStolen)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(PIKO_HEALTH)
    inst.components.health.murdersound = "dontstarve_DLC003/creatures/piko/death"

    MakeSmallBurnableCharacter(inst, "chest")
    MakeTinyFreezableCharacter(inst, "chest")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"smallmeat"})

    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")
    inst:AddComponent("sleeper")

    inst.sounds = pikosounds

    inst.OnSave = function(inst, data) if inst.lighton then data.lighton = inst.lighton end end

    inst.OnLoad = function(inst, data)
        if data and data.lighton then
            fadein(inst)
            inst.Light:Enable(true)
            inst.Light:SetIntensity(INTENSITY)
            inst.AnimState:Show("eye_red")
            inst.AnimState:Show("eye2_red")
            inst.lighton = true
        end
    end

    inst:SetStateGraph("SGpiko")
    inst:SetBrain(brain)

    inst:WatchWorldState("isnight", transformtest)
    inst:WatchWorldState("isday", transformtest)

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("death", function() inst.Light:Enable(false) end)
    inst:ListenForEvent("onwenthome", OnWentHome)
    inst:ListenForEvent("itemget", function() updatebuild(inst, true) end, inst)
    inst:ListenForEvent("itemlose", function() updatebuild(inst, false) end, inst)
    inst:ListenForEvent("onpickup", onpickup, inst)

    MakeFeedablePet(inst, 480 * 2, nil, OnDrop)

    -- When a piko is first created, ensure that it isn't rabid.
    SetAsRabid(inst, false)
    inst:WatchWorldState("startaporkalypse", function() transformtest(inst) end, TheWorld)
    inst:WatchWorldState("stopaporkalypse", function() transformtest(inst) end, TheWorld)
    inst:DoTaskInTime(FRAMES, function(inst)
        transformtest(inst)
    end)

    return inst
end

local function orangefn()
    local inst = fn()
    inst:AddTag("orange")
    updatebuild(inst, false)
    return inst
end

return Prefab("forest/animals/piko", fn, assets, prefabs),
       Prefab("forest/animals/piko_orange", orangefn, assets, prefabs)
