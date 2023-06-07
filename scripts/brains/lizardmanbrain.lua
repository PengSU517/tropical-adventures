require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/panic"
require "behaviours/attackwall"
require "behaviours/faceentity"
require "behaviours/doaction"
require "behaviours/standstill"
require "behaviours/runaway"

local LizardmanBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local SEE_DIST = 30
local frenzyRecharge = 30
local frenzyDuration = 15

local function EatFoodAction(inst)
	if not inst.isFrenzy then
		local notags = {"FX", "NOCLICK", "DECOR", "INLIMBO"}
		local target = FindEntity(inst, SEE_DIST, function(item) return inst.components.eater:CanEat(item) and item:IsOnValidGround() end, nil, notags)
		if target then
			return BufferedAction(inst, target, ACTIONS.EAT)
		end
	end
end

local function GetHome(inst)
	return inst.components.homeseeker and inst.components.homeseeker.home
end

local function GetHomePos(inst)
	local home = GetHome(inst)
	return home and home:GetPosition()
end

local function GetWanderPoint(inst)
	local target = GetHome(inst) or inst

	if target then
		return target:GetPosition()
	end 
end

local function GoHomeAction(inst)
	if inst.components.homeseeker 
		and inst.components.homeseeker.home 
		and inst.components.homeseeker.home:IsValid() 
		and not inst.components.combat.target
	then
    	return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function ShouldFrenzy(inst)
	return not inst.isFrenzy
		and inst.components.combat.target == nil 
		and GetTime() - inst.lastFrenzyTime > frenzyRecharge
end

local function ShouldNormal(inst)
	return inst.isFrenzy
		and inst.components.combat.target == nil 
		and GetTime() - inst.lastFrenzyTime > frenzyDuration
end

local function CheckSpells(inst)
	if inst.sg:HasStateTag("busy") then
        return
	end
	local splcstr = inst.components.gfspellcaster
	if splcstr then
		local spellData = splcstr:GetValidAiSpell()
		if spellData then
			local act = BufferedAction(inst, inst, ACTIONS.GFCASTSPELL)
			act.target = spellData.target
			act.distance = spellData.distance or 12
			act.pos = spellData.pos
			act.spell = spellData.spell

			return act
		end
	end

	return false
end

function LizardmanBrain:OnStart()
	
	local root = PriorityNode(
	{
		WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst) ),
		WhileNode(function() return self.inst.components.gfspellcaster end, "Can Cast",
			DoAction(self.inst, CheckSpells, "Cast Spell", true, 3)),
		ChattyNode(self.inst, "LIZARDMAN_TALK_FIGHT",
			WhileNode(function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
				ChaseAndAttack(self.inst, 8, 30) )),
		ChattyNode(self.inst, "LIZARDMAN_TALK_FIGHT",
			WhileNode(function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge",
				RunAway(self.inst, function() return self.inst.components.combat.target end, 8, 16) )),
		ChattyNode(self.inst, "LIZARDMAN_TALK_FRENZY",
			WhileNode(function() return ShouldFrenzy(self.inst) end, "Wants try frenzy",
				ActionNode(function() self.inst:PushEvent("gofrenzy") end))),
		ChattyNode(self.inst, "LIZARDMAN_TALK_EAT",
			DoAction(self.inst, EatFoodAction, "eat food", true )),
		ChattyNode(self.inst, "LIZARDMAN_TALK_GOHOME",
			WhileNode( function() return TheWorld.state.iscavenight end, "Night",
				DoAction(self.inst, GoHomeAction, "go home", true ))),
		WhileNode(function() return GetHome(self.inst) end, "HasHome", Wander(self.inst, GetHomePos, 8) ),
		Wander(self.inst, GetWanderPoint, 20),

	}, .5)
	
	self.bt = BT(self.inst, root)
	
end

return LizardmanBrain
