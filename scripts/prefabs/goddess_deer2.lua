local assets =
{
    Asset("ANIM", "anim/goddess_deer_build.zip"),
    Asset("ANIM", "anim/deer_basic.zip"),
    Asset("ANIM", "anim/deer_action.zip"),
}

local unshackle_assets =
{
    Asset("ANIM", "anim/deer_build.zip"),
    Asset("ANIM", "anim/deer_unshackle.zip"),
}

local prefabs =
{
    "meat",
    "boneshard",
    "deer_antler",
    "deer_growantler_fx",
}

local redprefabs =
{
    "redgem",
    "meat",
    "deer_fire_circle",
    "deer_fire_charge",
    "deer_unshackle_fx",
}

local blueprefabs =
{
    "bluegem",
    "meat",
    "deer_ice_circle",
    "deer_ice_charge",
    "deer_unshackle_fx",
}

local brain = require("brains/goddessdeerbrain")

SetSharedLootTable('goddess_deer',
{
    {'meat',              1.00},
	{'smallmeat',         1.00},
	{'smallmeat',         0.50},
    {'peach',             0.50},
})

SetSharedLootTable('goddess_deer1',
{
    {'meat',					1.00},
	{'smallmeat',				1.00},
	{'smallmeat',				0.50},
    {'peach',					0.50},
	{'goddess_ribbon',			1.00},
	{'full_bottle_green_milk',	0.50},
})

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function ShareTargetFn(dude)
    return dude:HasTag("goddess_deer") and not dude.components.health:IsDead()
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 20, ShareTargetFn, 3)
end

local function DoNothing()
end

local function DoChainIdleSound(inst, volume)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/chain_idle", nil, volume)
end

local function DoBellIdleSound(inst, volume)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/bell_idle", nil, volume)
end

local function DoChainSound(inst, volume)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/chain", nil, volume)
end

local function DoBellSound(inst, volume)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/bell", nil, volume)
end

local function NormalRetargetFn(inst)
    if inst.components.follower:GetLeader() ~= nil and inst.components.combat:TargetIs() == nil then
		local leader = inst.components.follower:GetLeader()
		inst.components.combat:SetTarget(leader.components.combat:TargetIs())
	end
end

local function SetupSounds(inst)
    if inst.gem == nil then
        inst.DoChainSound = DoNothing
        inst.DoChainIdleSound = DoNothing
        inst.DoBellSound = DoNothing
        inst.DoBellIdleSound = DoNothing
    elseif IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
        inst.DoChainSound = DoChainSound
        inst.DoChainIdleSound = DoChainIdleSound
        inst.DoBellSound = DoBellSound
        inst.DoBellIdleSound = DoBellIdleSound
    else
        inst.DoChainSound = DoChainSound
        inst.DoChainIdleSound = DoChainIdleSound
        inst.DoBellSound = DoNothing
        inst.DoBellIdleSound = DoNothing
    end
end

local function ShouldAcceptItem(inst, item)	
	if item:HasTag("ribbon") then
		return not inst:HasTag("windy4")
	elseif item.prefab == "greengem" then
		return not inst:HasTag("windy4")
	else
		local last_eat_time = inst.components.eater:TimeSinceLastEating()
        return (last_eat_time == nil or last_eat_time >= 150)
	end
end

local function done(inst)
	SpawnPrefab("goddess_deer_gem").Transform:SetPosition(inst.Transform:GetWorldPosition())
	if inst.magic == nil then
		inst.magic:Remove()
		inst.magic = nil
	end
	inst:Remove()
end

local function OnStarving(inst, dt)
end

local BLOOM_CHOICES =
{
    ["deer_flower"] = 1,
	["deer_flower_rose"] = 0.01,

}

local function DoPlantBloom(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local map = TheWorld.Map
    local offset = FindValidPositionByFan(
        math.random() * 2 * PI,
        math.random() * 3,
        8,
        function(offset)
            local x1 = x + offset.x
            local z1 = z + offset.z
            return map:IsPassableAtPoint(x1, 0, z1)
                and map:IsDeployPointClear(Vector3(x1, 0, z1), nil, 1)
                and #TheSim:FindEntities(x1, 0, z1, 2.5, { "deer_flower" }) < 2
        end
    )

    if offset ~= nil then
        SpawnPrefab(weighted_random_choice(BLOOM_CHOICES)).Transform:SetPosition(x + offset.x, 0, z + offset.z)
    end
end

local function OnStartBlooming(inst)
    inst._bloomtask = inst:DoPeriodicTask(3 * FRAMES, DoPlantBloom, 2 * FRAMES)
end

local function _StartBlooming(inst)
    if inst._bloomtask == nil then
        inst._bloomtask = inst:DoTaskInTime(0, OnStartBlooming)
    end
end

local function ForestOnEntityWake(inst)
    if inst._blooming then
        _StartBlooming(inst)
    end
end

local function ForestOnEntitySleep(inst)
    if inst._bloomtask ~= nil then
        inst._bloomtask:Cancel()
        inst._bloomtask = nil
    end
    if inst._trailtask ~= nil then
        inst._trailtask:Cancel()
        inst._trailtask = nil
    end
end

local function StartBlooming(inst)
	if inst:HasTag("Windy4") then
		if not inst._blooming then
			inst._blooming = true
			if not inst:IsAsleep() then
				_StartBlooming(inst)
			end
			inst:AddTag("flowering")
		end
	end
end

local function StopBlooming(inst)
    if inst._blooming then
        inst._blooming = false
        ForestOnEntitySleep(inst)
		inst:RemoveTag("flowering")
    end
end

local function OnHungerDelta(inst, data)
	local hunger = inst.components.hunger:GetPercent()
	if hunger > 0.25 and not inst:HasTag("flowering") then
		inst:AddTag("milkable")
		inst:DoTaskInTime(0, StartBlooming)
	else
		inst:RemoveTag("milkable")
		inst:DoTaskInTime(0, StopBlooming)
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	local x, y, z = inst.Transform:GetWorldPosition()
	if 	inst.components.eater:CanEat(item) and item:HasTag("peachy") and inst:HasTag("windy4") and inst.components.follower:GetLeader() == nil then
		giver:PushEvent("makefriend")
		giver.components.leader:AddFollower(inst)
		inst.components.hunger:SetPercent(1)
		inst.components.eater:Eat(item)
		inst.components.follower:AddLoyaltyTime(item.components.edible:GetHunger() * TUNING.PIG_LOYALTY_PER_HUNGER)
		inst.components.follower.maxfollowtime =
			giver:HasTag("polite")
			and TUNING.PIG_LOYALTY_MAXTIME + TUNING.PIG_LOYALTY_POLITENESS_MAXTIME_BONUS
			or TUNING.PIG_LOYALTY_MAXTIME
	elseif inst.components.eater:CanEat(item) and item:HasTag("peachy") then
		inst.components.hunger:SetPercent(1)
		inst.components.eater:Eat(item)
		inst:DoTaskInTime(3, SpawnPrefab("poop").Transform:SetPosition(inst.Transform:GetWorldPosition()))
	elseif inst.components.eater:CanEat(item) then
		inst.components.eater:Eat(item)
		inst:DoTaskInTime(3, SpawnPrefab("poop").Transform:SetPosition(inst.Transform:GetWorldPosition()))
	elseif item:HasTag("ribbon") then
		inst:AddTag("windy4")
		inst:AddTag("companion")
		inst.AnimState:OverrideSymbol("swap_antler_red", "goddess_deer_build", "swap_antler_red")
		inst.components.lootdropper:SetChanceLootTable('goddess_deer1')
		inst:DoTaskInTime(0, StartBlooming)
	elseif item.prefab == ("greengem") then
		inst.SoundEmitter:PlaySound("dontstarve/common/rebirth_amulet_raise")
		if inst.magic == nil then
			inst.magic = SpawnPrefab("goddess_telefx")
			inst.magic.Transform:SetPosition(x, y + 1, z)
			inst.magic.Transform:SetScale(2.25, 2.25, 2.25)
		end
		inst:DoTaskInTime(1, done)
    end
end

local function OnRefuseItem(inst, giver, item)
	if item:HasTag("ribbon") then
		giver.components.talker:Say("I've already given a ribbon to this deer.")
	elseif inst.components.eater:CanEat(item) then
		giver.components.talker:Say("It's already full.")
	end
end
	
local function OnEat(inst, food)
    if food.components.edible then
	end
end

local function onsave(inst, data)
    if inst:HasTag("windy4") then
		data.windy4 = inst:HasTag("windy4") ~= nil
	end
	if inst:HasTag("milked") then
		data.milked = inst:HasTag("milked") ~= nil
	end
end

local function onload(inst, data)
    if data ~= nil then
		if data.windy4 ~= nil then
			inst:AddTag("windy4")
			inst:AddTag("companion")
			inst:DoTaskInTime(0, OnHungerDelta)
			inst.AnimState:OverrideSymbol("swap_antler_red", "goddess_deer_build", "swap_antler_red")
			inst.components.lootdropper:SetChanceLootTable('goddess_deer1')
		end
		if data.windy4 ~= nil then
			inst:AddTag("milked")
		end
    end
end

local function common_fn(gem)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.DynamicShadow:SetSize(1.75, .75)

    inst.Transform:SetSixFaced()

    MakeCharacterPhysics(inst, 100, .5)

    inst.AnimState:SetBank("deer")
    inst.AnimState:SetBuild("goddess_deer_build")
    inst.AnimState:PlayAnimation("idle_loop", true)
	
	inst.AnimState:OverrideSymbol("swap_neck_collar", "goddess_deer_build", "swap_neck")
	inst.AnimState:OverrideSymbol("swap_antler_red", "deer_build", "swap_antler_red1")
	
	--inst.AnimState:OverrideSymbol("swap_antler_red", "deer_build", "swap_antler_red")
	inst.AnimState:OverrideSymbol("deer_hair", "deer_build", "deer_hair_winter")	
	inst.AnimState:OverrideSymbol("deer_chest", "deer_build", "deer_chest_winter")	
	
	inst.AnimState:Hide("CHAIN")
	
	local s = 0.8
	inst.Transform:SetScale(s,s,s)

	inst:AddTag("saltlicker")
    inst:AddTag("deer")
	inst:AddTag("goddess_deer")
    inst:AddTag("animal")
	inst:AddTag("goddess_deer")
	inst:AddTag("follower")
	inst:AddTag("healthinfo")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("timer")
    inst:AddComponent("knownlocations")
	
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.DEER_GEMMED_HEALTH)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.DEER_GEMMED_DAMAGE)
    inst.components.combat.hiteffectsymbol = "deer_torso"
    inst.components.combat:SetRange(TUNING.DEER_ATTACK_RANGE)
    inst.components.combat:SetAttackPeriod(TUNING.DEER_ATTACK_PERIOD)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)
    inst.components.combat:SetTarget(nil)
    inst.components.combat:SetHurtSound("dontstarve/creatures/together/deer/hit")
    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('goddess_deer')

    inst:AddComponent("inspectable")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.DEER_WALK_SPEED
    inst.components.locomotor.runspeed = TUNING.DEER_RUN_SPEED

    MakeHauntablePanic(inst)

    SetupSounds(inst)
    inst:SetStateGraph("SGdeer")

    inst:AddComponent("saltlicker")
    inst.components.saltlicker:SetUp(TUNING.SALTLICK_DEER_USES)
	
	inst:AddComponent("follower")
	inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem
	
	inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
--	inst.components.eater:SetOnEatFn(OnEat)

	inst:AddComponent("hunger")
	inst.components.hunger:SetMax(100)
    inst.components.hunger:SetRate(0.5)
    inst.components.hunger:SetPercent(1)
    inst.components.hunger:SetOverrideStarveFn(OnStarving)
	inst:ListenForEvent("hungerdelta", OnHungerDelta)

    inst:SetBrain(brain)
	
	inst._blooming = false
    inst.StartBlooming = StartBlooming
    inst.StopBlooming = StopBlooming
    inst.OnEntityWake = ForestOnEntityWake
    inst.OnEntitySleep = ForestOnEntitySleep
    StartBlooming(inst)

	inst.OnSave = onsave
    inst.OnLoad = onload
	
	return inst
end

local function fn()
    return common_fn()
end

return 	Prefab("goddess_deer", fn, assets, prefabs)