require "brains/grabbing_vinebrain"
require "stategraphs/SGgrabbing_vine"

local GRABBING_VINE_HEALTH = 100
local GRABBING_VINE_DAMAGE = 10
local GRABBING_VINE_ATTACK_PERIOD = 1
local GRABBING_VINE_TARGET_DIST = 3

local assets =
{
	Asset("ANIM", "anim/cave_exit_rope.zip"),
	Asset("ANIM", "anim/copycreep_build.zip"),
	Asset("SOUND", "sound/frog.fsb"),
}

local prefabs =
{
	"plantmeat",
	"rope",
}

SetSharedLootTable('grabbing_vine',
	{
		{ 'plantmeat', 0.4 },
		{ 'rope',      0.4 },
	})

local function retargetfn(inst)
	if not inst.components.health:IsDead() then
		local notags = { "FX", "NOCLICK", "INLIMBO", "plantkin" }
		return FindEntity(inst, GRABBING_VINE_TARGET_DIST, function(guy)
			if guy.components.combat and guy.components.health and not guy.components.health:IsDead() then
				return guy.components.inventory ~= nil
			end
		end, nil, notags)
	end
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(data.attacker, 30,
		function(dude) return dude:HasTag("frog") and not dude.components.health:IsDead() end, 5)
end

local function OnGoingHome(inst)
end

local function shadownon(inst)
	inst.shadow:SetSize(1.5, .75)
end

local function shadowoff(inst)
	inst.shadow:SetSize(0, 0)
end


local function onnear(inst)
	if not inst.near then
		inst.near = true
		inst:PushEvent("godown")
	end
end

local function onfar(inst)
	if inst.near then
		inst.near = nil
		inst:PushEvent("goup")
	end
end

local function canbeattackedfn(inst, attacker)
	return not inst:HasTag("up")
end


local function onsave(inst, data)
	local references = {}
	if inst.spawnpatch then
		data.spawnpatch = inst.spawnpatch.GUID
		references = { data.leader }
	end
	return references
end

local function onload(inst, data)
end

local function loadpostpass(inst, ents, data)
	if data then
		if data.spawnpatch then
			local spawnpatch = ents[data.spawnpatch]
			if spawnpatch then
				inst.spawnpatch = spawnpatch.entity
			end
		end
	end
end

local function OnKilled(inst)
	if inst.spawnpatch then
		inst.spawnpatch.spawnNewVine(inst.spawnpatch, inst.prefab)
	end
end

local function commonfn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	inst.entity:AddAnimState()
	local physics = inst.entity:AddPhysics()
	local sound = inst.entity:AddSoundEmitter()
	inst.shadow = inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()

	inst.shadow:SetSize(1.5, .75)
	--inst.Transform:SetFourFaced()
	inst:SetPrefabNameOverride("grabbing_vine")
	inst.shadownon = shadownon
	inst.shadowoff = shadowoff

	inst.AnimState:SetBank("exitrope")
	inst.AnimState:SetBuild("copycreep_build")
	inst.AnimState:PlayAnimation("idle_loop")

	MakeCharacterPhysics(inst, 1, .3)
	inst.Physics:SetCollisionGroup(COLLISION.FLYERS)
	inst.Physics:CollidesWith(COLLISION.FLYERS)

	inst:AddTag("flying")

	inst:AddTag("hangingvine")
	inst:AddTag("animal")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor.walkspeed = 4
	inst.components.locomotor.runspeed = 8

	inst:SetStateGraph("SGgrabbing_vine")

	local brain = require "brains/grabbing_vinebrain"
	inst:SetBrain(brain)

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(GRABBING_VINE_HEALTH)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('grabbing_vine')

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(GRABBING_VINE_DAMAGE)
	inst.components.combat:SetAttackPeriod(GRABBING_VINE_ATTACK_PERIOD)
	inst.components.combat:SetRange(3, 4)
	inst.components.combat:SetRetargetFunction(1, retargetfn)
	inst.components.combat.canbeattackedfn = canbeattackedfn

	inst.components.combat.onhitotherfn = function(inst, other, damage) inst.components.thief:StealItem(other, nil, nil,
			true) end

	inst:AddComponent("thief")

	--MakeTinyFreezableCharacter(inst, "frogsack")

	inst:AddComponent("knownlocations")
	inst:DoTaskInTime(0, function()
		inst.components.knownlocations:RememberLocation("home", Point(inst.Transform:GetWorldPosition()), true)
	end)

	inst:AddComponent("playerprox")
	inst.components.playerprox:SetOnPlayerNear(onnear)
	inst.components.playerprox:SetOnPlayerFar(onfar)
	inst.components.playerprox:SetDist(10, 16)

	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })

	inst:AddComponent("inspectable")

	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("goinghome", OnGoingHome)
	inst:ListenForEvent("death", OnKilled)

	inst.OnSave = onsave
	inst.OnLoad = onload
	inst.LoadPostPass = loadpostpass

	onfar(inst)
	inst.sg:GoToState("idle_up")

	return inst
end

return Prefab("forest/animals/grabbing_vine", commonfn, assets, prefabs),
	Prefab("forest/animals/grabbing_vinefixo", commonfn, assets, prefabs)
