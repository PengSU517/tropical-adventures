require "stategraphs/SGcrab"

local assets =
{
	Asset("ANIM", "anim/crabbit_build.zip"),
	Asset("ANIM", "anim/crabbit_beardling_build.zip"),
	Asset("ANIM", "anim/beardling_crabbit.zip"),

	Asset("ANIM", "anim/crabbit.zip"),
}

local CRAB_WALK_SPEED = 1.5
local CRAB_RUN_SPEED = 5
local CRAB_HEALTH = 50
local BEARDLING_SANITY = .4

local prefabs =
{
	"fishmeat_small",
	"fishmeat_small_cooked",
	"beardhair",
	"monstermeat",
    "cookedmonstermeat",
    "nightmarefuel",
	"shadow_despawn",
    "statue_transition_2",
}

local crabbitsounds =
{
	scream = "dontstarve_DLC002/creatures/crab/scream",
	hurt = "dontstarve_DLC002/creatures/crab/scream_short",
}

local beardsounds =
{
	scream = "dontstarve_DLC002/creatures/crab/scream",
	hurt = "dontstarve_DLC002/creatures/crab/scream_short",
}

local crabbitloot = {"fishmeat_small"}
local forced_beardlingloot = {"nightmarefuel"}

local brain = require "brains/crabbrain"

local function DoShadowFx(inst, isnightmare)
    local x, y, z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab("statue_transition_2")
    fx.Transform:SetPosition(x, y, z)
    fx.Transform:SetScale(.5, .5, .5)

    --When forcing into nightmare state, shadow_trap would've already spawned this fx
    if not isnightmare then
        fx = SpawnPrefab("shadow_despawn")
        local platform = inst:GetCurrentPlatform()
        if platform ~= nil then
            fx.entity:SetParent(platform.entity)
            fx.Transform:SetPosition(platform.entity:WorldToLocalSpace(x, y, z))
            fx:ListenForEvent("onremove", function()
                fx.Transform:SetPosition(fx.Transform:GetWorldPosition())
                fx.entity:SetParent(nil)
            end, platform)
        else
            fx.Transform:SetPosition(x, y, z)
        end
    end
end

local function IsCrazyGuy(guy)
    local sanity = guy ~= nil and guy.replica.sanity or nil
    return sanity ~= nil and sanity:IsInsanityMode() and sanity:GetPercentNetworked() <= (guy:HasTag("dappereffects") and TUNING.DAPPER_BEARDLING_SANITY or TUNING.BEARDLING_SANITY)
end

local function IsForcedNightmare(inst)
    return inst.components.timer:TimerExists("forcenightmare")
end

local function SetRabbitLoot(lootdropper)
    if lootdropper.loot ~= crabbitloot and not lootdropper.inst._fixedloot then
        lootdropper:SetLoot(crabbitloot)
    end
end

local function SetBeardlingLoot(lootdropper)
    if not lootdropper.inst._fixedloot then
        lootdropper:SetLoot(nil)
        lootdropper:AddRandomLoot("beardhair", .5)
        lootdropper:AddRandomLoot("monstermeat", 1)
        lootdropper:AddRandomLoot("nightmarefuel", 1)
        lootdropper.numrandomloot = 1
    end
end

local function SetForcedBeardlingLoot(lootdropper)
    if not lootdropper.inst._fixedloot then
        lootdropper:SetLoot(forced_beardlingloot)
        if math.random() < .5 then
            lootdropper:AddRandomLoot("beardhair", .5)
            lootdropper:AddRandomLoot("monstermeat", 1)
            lootdropper.numrandomloot = 1
        end
    end
end

local function BecomeRabbit(inst)
    if IsForcedNightmare(inst) or inst.components.health:IsDead() then
        return
    end
    inst.AnimState:SetBuild("crabbit_build")
    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName("crab")
    end
    inst.sounds = crabbitsounds
end

local function OnEnterLimbo(inst)
    inst.components.timer:PauseTimer("forcenightmare")
end

local function OnExitLimbo(inst)
    inst.components.timer:ResumeTimer("forcenightmare")
end

local function OnTimerDone(inst, data)
    if data ~= nil and data.name == "forcenightmare" then
        if not (inst:IsInLimbo() or inst:IsAsleep()) then
            if inst.sg:HasStateTag("busy") and not inst.sg:HasStateTag("sleeping") then
                inst.components.timer:StartTimer("forcenightmare", 1)
                return
            end
            DoShadowFx(inst, false)
        end
        inst:RemoveEventCallback("timerdone", OnTimerDone)
        inst:RemoveEventCallback("enterlimbo", OnEnterLimbo)
        inst:RemoveEventCallback("exitlimbo", OnExitLimbo)
        BecomeRabbit(inst)
    end
end

local function BecomeBeardling(inst, duration)
    -- duration nil is loading, so don't perform checks
    if duration ~= nil then
        if inst.components.health:IsDead() then
            return
        end
        local t = inst.components.timer:GetTimeLeft("forcenightmare")
        if t ~= nil then
            if t < duration then
                inst.components.timer:SetTimeLeft("forcenightmare", duration)
            end
            return
        end
        inst.components.timer:StartTimer("forcenightmare", duration, inst:IsInLimbo())
    end
    inst.AnimState:SetBuild("crabbit_beardling_build")
    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem:ChangeImageName("crabbit_beardling")
    end
    inst.sounds = beardsounds
    inst:ListenForEvent("timerdone", OnTimerDone)
    inst:ListenForEvent("enterlimbo", OnEnterLimbo)
    inst:ListenForEvent("exitlimbo", OnExitLimbo)
end

local function OnForceNightmareState(inst, data)
    if data ~= nil and data.duration ~= nil then
        DoShadowFx(inst, true)
        BecomeBeardling(inst, data.duration)
    end
end

local function OnWake(inst)
    --inst:WatchWorldState("iswinter", OnIsWinter)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
		BecomeRabbit(inst)
end

local function OnSleep(inst)
    --inst:StopWatchingWorldState("iswinter", OnIsWinter)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
end

local function OnLoad(inst)
	if IsForcedNightmare(inst) then
		BecomeBeardling(inst, nil)
		if inst:IsInLimbo() then
			inst.components.timer:PauseTimer("forcenightmare")
		else
			inst.components.timer:ResumeTimer("forcenightmare")
		end
	end
end

local function SetBeardlingTrapData(inst)
	local t = inst.components.timer:GetTimeLeft("forcenightmare")
	return t ~= nil and {
		beardlingtime = t,
	} or nil
end

local function RestoreBeardlingFromTrap(inst, data)
	if data ~= nil and data.beardlingtime ~= nil then
		BecomeBeardling(inst, data.beardlingtime)
	end
end

local function CalcSanityAura(inst, observer)
    return (IsForcedNightmare(inst) or IsCrazyGuy(observer)) and -TUNING.SANITYAURA_MED or 0
end

local function GetCookProductFn(inst, cooker, chef)
    return (IsForcedNightmare(inst) or IsCrazyGuy(chef)) and "cookedmonstermeat" or "fishmeat_small_cooked"
end

local function OnCookedFn(inst)
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/crab/scream_short")
end

local function LootSetupFunction(lootdropper)
    local guy = lootdropper.inst.causeofdeath
	if IsForcedNightmare(lootdropper.inst) then
		SetForcedBeardlingLoot(lootdropper)
	elseif IsCrazyGuy(guy ~= nil and guy.components.follower ~= nil and guy.components.follower.leader or guy) then
        SetBeardlingLoot(lootdropper)
    else
        SetRabbitLoot(lootdropper)
    end
end

local function OnAttacked(inst, data)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 30, { 'crab' })

	local num_friends = 0
	local maxnum = 5
	for k, v in pairs(ents) do
		v:PushEvent("gohome")
		num_friends = num_friends + 1

		if num_friends > maxnum then
			break
		end
	end
end

local function OnDug(inst, worker)
	local rnd = math.random()
	local home = inst.components.homeseeker and inst.components.homeseeker.home
	if rnd >= 0.66 or not home then
		--Sometimes just go to stunned state

		inst:PushEvent("stunned")
	else
		--Sometimes return home instantly?
		worker:DoTaskInTime(1, function()
			worker:PushEvent("crab_fail")
		end)

		inst.components.lootdropper:SpawnLootPrefab("sand")
		local home = inst.components.homeseeker.home
		home.components.spawner:GoHome(inst)
	end
end

local function DisplayName(inst)
	if inst.sg:HasStateTag("invisible") then
		return STRINGS.NAMES.CRAB_HIDDEN
	end
	return STRINGS.NAMES.CRAB
end

local function getstatus(inst)
	if inst.sg:HasStateTag("invisible") then
		return "HIDDEN"
	end
end

local function OnDropped(inst)
    inst.sg:GoToState("stunned")
end

local function getmurdersound(inst, doer)
    return (IsForcedNightmare(inst) or IsCrazyGuy(doer)) and beardsounds.hurt or inst.sounds.hurt
end

local function getincineratesound(inst, doer)
    return (IsForcedNightmare(inst) or IsCrazyGuy(doer)) and beardsounds.scream or inst.sounds.scream
end

local function drawimageoverride(inst, viewer)
    return (IsForcedNightmare(inst) or IsCrazyGuy(viewer)) and "crabbit_beardling"
end

local function fn(Sim)
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize(1.5, .5)
	inst.Transform:SetFourFaced()

	MakeCharacterPhysics(inst, 1, 0.5)

    inst.AnimState:SetBank("crabbit")
    inst.AnimState:SetBuild("crabbit_build")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("animal")
    inst:AddTag("prey")
    inst:AddTag("rabbit")
	inst:AddTag("crab")
    inst:AddTag("smallcreature")
    inst:AddTag("canbetrapped")
    inst:AddTag("cattoy")
    inst:AddTag("catfood")
    inst:AddTag("stunnedbybomb")
    inst:AddTag("cookable")

    inst.AnimState:SetClientsideBuildOverride("insane", "crabbit_build", "crabbit_beardling_build")
    inst:SetClientSideInventoryImageOverride("insane", "crab.tex", "crabbit_beardling.tex")

    MakeFeedableSmallLivestockPristine(inst)

    inst.displaynamefn = DisplayName

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor.runspeed = CRAB_RUN_SPEED
	inst.components.locomotor.walkspeed = CRAB_WALK_SPEED
    inst:SetStateGraph("SGcrab")

    inst:SetBrain(brain)

	inst.data = {}

	inst:AddComponent("eater")
    local diet = {FOODTYPE.MEAT, FOODTYPE.VEGGIE, FOODTYPE.INSECT}
    inst.components.eater:SetDiet(diet, diet)

	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true
    inst.components.inventoryitem:SetSinks(true)

	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = CalcSanityAura

	inst:AddComponent("cookable")
	inst.components.cookable.product = GetCookProductFn
	inst.components.cookable:SetOnCookedFn(OnCookedFn)

	inst:AddComponent("knownlocations")
	inst:AddComponent("timer")

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(CRAB_HEALTH)
    inst.components.health.murdersound = getmurdersound
    inst.incineratesound = getincineratesound

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable.workable = false
	inst.components.workable:SetOnFinishCallback(OnDug)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLootSetupFn(LootSetupFunction)
    LootSetupFunction(inst.components.lootdropper)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "chest"
	MakeSmallBurnableCharacter(inst, "chest")
	MakeTinyFreezableCharacter(inst, "chest")

    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("sleeper")
    inst.components.sleeper.watchlight = true

    inst:AddComponent("tradable")

    inst.sounds = nil
    inst.task = nil
    BecomeRabbit(inst)

    MakeHauntablePanic(inst)

    inst:ListenForEvent("attacked", OnAttacked)

	--shadow_trap interaction
	inst.has_nightmare_state = true
	inst:ListenForEvent("ms_forcenightmarestate", OnForceNightmareState)

    MakeFeedableSmallLivestock(inst, TUNING.TOTAL_DAY_TIME*2, nil, OnDropped)

    inst.drawimageoverride = drawimageoverride
	inst.settrapdata = SetBeardlingTrapData
	inst.restoredatafromtrap = RestoreBeardlingFromTrap

	inst.OnEntityWake = OnWake
	inst.OnEntitySleep = OnSleep
	inst.OnLoad = OnLoad

	return inst
end

return Prefab("crab", fn, assets, prefabs)
