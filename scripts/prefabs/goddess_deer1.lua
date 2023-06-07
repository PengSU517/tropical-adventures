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

local brain = require("brains/goddessdeergembrain")

SetSharedLootTable('goddess_deer2',
{
    {'meat',            	  	1.00},
	{'smallmeat',         		1.00},
	{'smallmeat',      	   		0.50},
	{'gem_seeds',         		1.00},
    {'gem_seeds',         		0.25},
	{'gem_seeds',         		0.05},
	{'gem_seeds',         		0.01},
	{'goddess_fishingrod',      1.00},
})

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function ShareTargetFn(dude)
    return dude:HasTag("goddess_deer_gem") and not dude.components.health:IsDead()
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 20, ShareTargetFn, 5)
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

local function GemmedShouldSleep(inst)
    return false
end

local function GemmedShouldWake(inst)
    return true
end

local SPELL_OVERLAP_MIN = 3
local SPELL_OVERLAP_MAX = 6

local function NoSpellOverlap(x, y, z, r)
    return #TheSim:FindEntities(x, 0, z, r or SPELL_OVERLAP_MIN, nil, nil, { "greentornado2" }) <= 0
end

--Hard limit target list size since casting does multiple passes it
local SPELL_MAX_TARGETS = 20
local function FindCastTargets(inst, target)
    if target ~= nil then
        --Single target for deer without keeper
        return target.components.health ~= nil
            and not (target.components.health:IsDead() or
                    target:HasTag("playerghost") or
                    target:HasTag("deergemresistance"))
            and target:IsNear(inst, TUNING.DEER_GEMMED_CAST_RANGE)
            and NoSpellOverlap(target.Transform:GetWorldPosition())
            and { target }
            or nil
    end
    --Multi-target when receiving commands from keeper
    local x, y, z = inst.Transform:GetWorldPosition()
    local targets = {}
    local priorityindex = 1
    for i, v in ipairs(TheSim:FindEntities(x, y, z, TUNING.DEER_GEMMED_CAST_RANGE, { "_combat", "_health" }, { "INLIMBO", "playerghost", "deergemresistance" })) do
        if not v.components.health:IsDead() then
            if v:HasTag("player") then
                table.insert(targets, priorityindex, v)
                if #targets >= SPELL_MAX_TARGETS then
                    return targets
                end
                priorityindex = priorityindex + 1
            elseif v.components.combat.target ~= nil and v.components.combat.target:HasTag("deergemresistance") then
                table.insert(targets, v)
                if #targets >= SPELL_MAX_TARGETS then
                    return targets
                end
            end
        end
    end
    return #targets > 0 and targets or nil
end

local function SpawnSpell(inst, x, z)
    local spell = SpawnPrefab("greentornado2")
    spell.Transform:SetPosition(x, 0, z)
    spell:DoTaskInTime(inst.castduration, spell.KillFX)
    return spell
end

local function SpawnSpells(inst, targets)
    local spells = {}
    local nextpass = {}
    for i, v in ipairs(targets) do
        if v:IsValid() and v:IsNear(inst, TUNING.DEER_GEMMED_CAST_MAX_RANGE) then
            local x, y, z = v.Transform:GetWorldPosition()
            if NoSpellOverlap(x, 0, z, SPELL_OVERLAP_MAX) then
                table.insert(spells, SpawnSpell(inst, x, z))
                if #spells >= TUNING.DEER_GEMMED_MAX_SPELLS then
                    return spells
                end
            else
                table.insert(nextpass, { x = x, z = z })
            end
        end
    end
    if #nextpass <= 0 then
        return spells
    end
    for range = SPELL_OVERLAP_MAX - 1, SPELL_OVERLAP_MIN, -1 do
        local i = 1
        while i <= #nextpass do
            local v = nextpass[i]
            if NoSpellOverlap(v.x, 0, v.z, range) then
                table.insert(spells, SpawnSpell(inst, v.x, v.z))
                if #spells >= TUNING.DEER_GEMMED_MAX_SPELLS or #nextpass <= 1 then
                    return spells
                end
                table.remove(nextpass, i)
            else
                i = i + 1
            end
        end
    end
    return #spells > 0 and spells or nil
end

local function DoCast(inst, targets)
    local spells = targets ~= nil and SpawnSpells(inst, targets) or nil
    inst.components.timer:StopTimer("deercast_cd")
    inst.components.timer:StartTimer("deercast_cd", spells ~= nil and inst.castcd or TUNING.DEER_GEMMED_FIRST_CAST_CD)
    return spells
end

local function OnNewTarget(inst, data)
    if data.target ~= nil then
        inst:SetEngaged(true)
    end
end

local function GemmedRetargetFn(inst)
    return FindEntity(inst, 16, nil, { "player" }, { "playerghost", "INLIMBO", "abigail" } or { "playerghost", "INLIMBO" })
end

local function SetEngaged(inst, engaged)
    --NOTE: inst.engaged is nil at instantiation, and engaged must not be nil
    if inst.engaged ~= engaged then
        inst.engaged = engaged
        inst.components.timer:StopTimer("deercast_cd")
        if engaged then
            inst.components.timer:StartTimer("deercast_cd", TUNING.DEER_GEMMED_FIRST_CAST_CD)
            inst:RemoveEventCallback("newcombattarget", OnNewTarget)
        else
            inst:ListenForEvent("newcombattarget", OnNewTarget)
        end
    end
end

local function leader(inst)
	local Fountain = TheSim:FindFirstEntityWithTag("goddess_fountain_gem")
	Fountain.components.leader:AddFollower(inst)
end

local function ondeath(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local a = math.random()
	if a <= 0.25 then
		inst.gem = SpawnPrefab("gem_flower1")
		inst.gem.Transform:SetPosition(x, y, z)
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
	inst.AnimState:OverrideSymbol("swap_antler_red", "goddess_deer_build", "swap_antler_blue")
	
	inst.AnimState:OverrideSymbol("deer_hair", "deer_build", "deer_hair_winter")	
	inst.AnimState:OverrideSymbol("deer_chest", "deer_build", "deer_chest_winter")	
	
	inst.AnimState:Hide("CHAIN")

	inst:AddTag("goddess_deer_gem")
    inst:AddTag("animal")
	inst:AddTag("healthinfo")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.gem = gem
	
    inst:AddComponent("timer")
    inst:AddComponent("knownlocations")
	
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.DEER_GEMMED_HEALTH*2)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.DEER_GEMMED_DAMAGE*2)
    inst.components.combat.hiteffectsymbol = "deer_torso"
    inst.components.combat:SetRange(TUNING.DEER_ATTACK_RANGE)
    inst.components.combat:SetAttackPeriod(TUNING.DEER_ATTACK_PERIOD)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat:SetTarget(nil)
    inst.components.combat:SetHurtSound("dontstarve/creatures/together/deer/hit")
	inst.components.combat:SetRetargetFunction(3, GemmedRetargetFn)
	inst:ListenForEvent("attacked", OnAttacked)
	SetEngaged(inst, false)

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(11)
	inst.components.sleeper:SetSleepTest(GemmedShouldSleep)
	inst.components.sleeper:SetWakeTest(GemmedShouldWake)
	inst.components.sleeper.diminishingreturns = true
	inst.components.sleeper.testperiod = 1

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('goddess_deer2')

    inst:AddComponent("inspectable")
	
	inst:AddComponent("follower")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.DEER_WALK_SPEED
    inst.components.locomotor.runspeed = TUNING.DEER_RUN_SPEED
	
	
	inst.castduration = 4
	inst.castcd = TUNING.DEER_FIRE_CAST_CD

    MakeHauntablePanic(inst)
	
	inst:ListenForEvent("death", ondeath)

    SetupSounds(inst)
    inst:SetStateGraph("SGggdeer")

    inst:SetBrain(brain)
	
	inst.SetEngaged = SetEngaged
	
	inst.FindCastTargets = FindCastTargets
	
	inst.DoCast = DoCast
	
	inst:DoTaskInTime(0, leader)
	
	return inst
end

local function fn()
    return common_fn()
end

return 	Prefab("goddess_deer_gem", fn, assets, prefabs)