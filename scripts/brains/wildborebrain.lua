require "behaviours/wander"
require "behaviours/follow"
require "behaviours/faceentity"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/doaction"
--require "behaviours/choptree"
require "behaviours/findlight"
require "behaviours/panic"
require "behaviours/chattynode"
require "behaviours/leash"
require "behaviours/chaseandram"



local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 5
local MAX_FOLLOW_DIST = 9
local MAX_WANDER_DIST = 20

local LEASH_RETURN_DIST = 10
local LEASH_MAX_DIST = 30

local START_FACE_DIST = 6
local KEEP_FACE_DIST = 8
local START_RUN_DIST = 3
local STOP_RUN_DIST = 5
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 30
local SEE_LIGHT_DIST = 20
local TRADE_DIST = 20
local SEE_TREE_DIST = 15
local SEE_TARGET_DIST = 20
local SEE_FOOD_DIST = 10

local KEEP_CHOPPING_DIST = 10

local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8

local MAX_CHARGE_TIME = 5
local MAX_CHARGE_DIST = 15
local CHASE_GIVEUP_DIST = 10

local ANNOYANCE_THRESHOLD = 2


--------------jueying begin

local function SafeLightDist(inst, target)
    return (target:HasTag("player") or target:HasTag("playerlight")
            or (target.inventoryitem and target.inventoryitem:GetGrandOwner() and target.inventoryitem:GetGrandOwner():HasTag("player")))
        and 4
        or target.Light:GetCalculatedRadius() / 3
end


-------------jueying end

local function GetFaceTargetFn(inst)
    local target = GetClosestInstWithTag("player", inst, START_FACE_DIST)
    if target and not target:HasTag("notarget") then
        return target
    end
end

local function KeepFaceTargetFn(inst, target)
    return inst:IsNear(target, KEEP_FACE_DIST) and not target:HasTag("notarget")
end

local function ShouldRunAway(inst, target)
    return not inst.components.trader:IsTryingToTradeWithMe(target)
end

local function GetTraderFn(inst)
    return FindEntity(inst, TRADE_DIST, function(target) return inst.components.trader:IsTryingToTradeWithMe(target) end, {"player"})
end

local function KeepTraderFn(inst, target)
    return inst.components.trader:IsTryingToTradeWithMe(target)
end

local function FindFoodAction(inst)
    local target = nil

	if inst.sg:HasStateTag("busy") then
		return
	end
    
    if inst.components.inventory and inst.components.eater then
        target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
    end
    
    local time_since_eat = inst.components.eater:TimeSinceLastEating()
    local noveggie = time_since_eat and time_since_eat < TUNING.PIG_MIN_POOP_PERIOD*4
    
    local notags = {"FX", "NOCLICK", "DECOR","INLIMBO"}
    if not target and (not time_since_eat or time_since_eat > TUNING.PIG_MIN_POOP_PERIOD*2) then
        target = FindEntity(inst, SEE_FOOD_DIST, function(item) 
				if item:GetTimeAlive() < 8 then return false end
				if item.prefab == "mandrake" then return false end
				if noveggie and item.components.edible and item.components.edible.foodtype ~= "MEAT" then
					return false
				end
				if not item:IsOnValidGround() then
					return false
				end
				return inst.components.eater:CanEat(item) 
			end, nil, notags)
    end
    if target then
        return BufferedAction(inst, target, ACTIONS.EAT)
    end

    if not target and (not time_since_eat or time_since_eat > TUNING.PIG_MIN_POOP_PERIOD*2) then
        target = FindEntity(inst, SEE_FOOD_DIST, function(item) 
                if not item.components.shelf then return false end
                if not item.components.shelf.itemonshelf or not item.components.shelf.cantakeitem then return false end
                if noveggie and item.components.shelf.itemonshelf.components.edible and item.components.shelf.itemonshelf.components.edible.foodtype ~= "MEAT" then
                    return false
                end
                if not item:IsOnValidGround() then
                    return false
                end
                return inst.components.eater:CanEat(item.components.shelf.itemonshelf) 
            end, nil, notags)
    end

    if target then
        return BufferedAction(inst, target, ACTIONS.TAKEITEM)
    end

end


local function KeepChoppingAction(inst)
    local notags = {"FX", "NOCLICK", "DECOR","INLIMBO"}
    local keep_chop = inst.components.follower.leader and inst.components.follower.leader:GetDistanceSqToInst(inst) <= KEEP_CHOPPING_DIST*KEEP_CHOPPING_DIST
    local target = FindEntity(inst, SEE_TREE_DIST/3, function(item)
        return item.prefab == "deciduoustree" and item.monster and item.components.workable and item.components.workable.action == ACTIONS.CHOP 
    end, nil, notags)    
    if inst.tree_target ~= nil then target = inst.tree_target end

    return (keep_chop or target ~= nil)
end

local function StartChoppingCondition(inst)
    local notags = {"FX", "NOCLICK", "DECOR","INLIMBO"}
    local start_chop = inst.components.follower.leader and inst.components.follower.leader.sg and inst.components.follower.leader.sg:HasStateTag("chopping")
    local target = FindEntity(inst, SEE_TREE_DIST/3, function(item) 
        return item.components.workable and item.components.workable.action == ACTIONS.CHOP 
    end, nil, notags)
    if inst.tree_target ~= nil then target = inst.tree_target end
    
    return (start_chop and target ~= nil)
end


local function FindTreeToChopAction(inst)
    local notags = {"FX", "NOCLICK", "DECOR","INLIMBO"}
    local target = FindEntity(inst, SEE_TREE_DIST, function(item) return item.components.workable and item.components.workable.action == ACTIONS.CHOP and not item:HasTag("machetecut") end)
    if target then
        local decid_monst_target = FindEntity(inst, SEE_TREE_DIST/3, function(item)
            return item.prefab == "deciduoustree" and item.monster and item.components.workable and item.components.workable.action == ACTIONS.CHOP 
        end, nil, notags)
        if decid_monst_target ~= nil then 
            target = decid_monst_target 
        end
        if inst.tree_target then 
            target = inst.tree_target
            inst.tree_target = nil 
        end
        return BufferedAction(inst, target, ACTIONS.CHOP)
    end
end

local function KeepHackingAction(inst)
    local keep_hack = inst.components.follower.leader and inst.components.follower.leader:GetDistanceSqToInst(inst) <= KEEP_CHOPPING_DIST*KEEP_CHOPPING_DIST
    return keep_hack
end

local function StartHackingCondition(inst)
    local notags = {"FX", "NOCLICK", "DECOR","INLIMBO"}
    local start_chop = inst.components.follower.leader and inst.components.follower.leader.sg and inst.components.follower.leader.sg:HasStateTag("chopping")
    local target = FindEntity(inst, SEE_TREE_DIST/3, function(item) 
        return item.components.workable and item.components.workable.action == ACTIONS.HACK
    end, nil, notags)
    if inst.tree_target ~= nil then target = inst.tree_target end
    
    return (start_chop and target and target:HasTag("machetecut"))
end

local function FindBushToHackAction(inst)
    local notags = {"FX", "NOCLICK", "DECOR","INLIMBO"}
    local target = FindEntity(inst, SEE_TREE_DIST, function(item) return item.components.workable and item.components.workable.action == ACTIONS.HACK and item:HasTag("machetecut") end, nil, notags)
 if target then
        return BufferedAction(inst, target, ACTIONS.HACK)
    end
end

local function HasValidHome(inst)
    return inst.components.homeseeker and 
       inst.components.homeseeker.home and 
       not inst.components.homeseeker.home:HasTag("fire") and
       not inst.components.homeseeker.home:HasTag("burnt") and
       inst.components.homeseeker.home:IsValid()
end

local function GoHomeAction(inst)
    if not inst.components.follower.leader and
        HasValidHome(inst) and
        not inst.components.combat.target then
            return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function GetLeader(inst)
    return inst.components.follower.leader 
end

local function GetHomePos(inst)
    return HasValidHome(inst) and inst.components.homeseeker:GetHomePos()
end

local function GetNoLeaderHomePos(inst)
    if GetLeader(inst) then
        return nil
    end
    return GetHomePos(inst)
end

local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

local function GetAnnoyedFn(inst, target)
    inst.annoyance = 0
    if inst.reset_annoyance_task then
        inst.reset_annoyance_task:Cancel()
    end

    if inst.components.combat then
        inst.components.combat:SuggestTarget(target)
    end
end

local function ShouldRunFromPlayerFn(hunter, inst)
    inst.annoyance = inst.annoyance + 1

    local resetfn = function()
        inst.annoyance = 0
    end

    if inst.reset_annoyance_task then
        inst.reset_annoyance_task:Cancel()
    end

    inst.reset_annoyance_task = inst:DoTaskInTime(10, resetfn)

    print(string.format("%2.0f/%2.0f", inst.annoyance, ANNOYANCE_THRESHOLD))

    if inst.annoyance >= ANNOYANCE_THRESHOLD then
        GetAnnoyedFn(inst, hunter)
        return false
    end

    return true
end

local PigBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function PigBrain:OnStart()
    --print(self.inst, "PigBrain:OnStart")
    
    local day = WhileNode( function() return TheWorld.state.isday end, "IsDay",
        PriorityNode{
            ChattyNode(self.inst, STRINGS.BORE_TALK_FIND_MEAT,
                DoAction(self.inst, FindFoodAction )),
            IfNode(function() return StartChoppingCondition(self.inst) end, "chop", 
                WhileNode(function() return KeepChoppingAction(self.inst) end, "keep chopping",
                    LoopNode{ 
                        ChattyNode(self.inst, STRINGS.BORE_TALK_HELP_CHOP_WOOD,
                            DoAction(self.inst, FindTreeToChopAction ))})),
            IfNode(function() return StartHackingCondition(self.inst) end, "hack", 
                WhileNode(function() return KeepHackingAction(self.inst) end, "keep hacking",
                    LoopNode{ 
                        ChattyNode(self.inst, STRINGS.BORE_TALK_HELP_HACK,
                            DoAction(self.inst, FindBushToHackAction ))})),
            ChattyNode(self.inst, STRINGS.BORE_TALK_FOLLOWWILSON, 
                Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST)),
            IfNode(function() return GetLeader(self.inst) end, "has leader",
				ChattyNode(self.inst, STRINGS.BORE_TALK_FOLLOWWILSON,
					FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn ))),

            Leash(self.inst, GetNoLeaderHomePos, LEASH_MAX_DIST, LEASH_RETURN_DIST),

            ChattyNode(self.inst, STRINGS.BORE_TALK_RUNAWAY_WILSON,
                    RunAway(self.inst, "player", START_RUN_DIST, STOP_RUN_DIST, function(target) return ShouldRunFromPlayerFn(target, self.inst) end)),
                    --DoAction(self.inst, GetAnnoyedFn),
            ChattyNode(self.inst, STRINGS.BORE_TALK_LOOKATWILSON,
                FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn)),
            Wander(self.inst, GetNoLeaderHomePos, MAX_WANDER_DIST)
        },.5)
        
    
    local night = WhileNode( function() return  not TheWorld.state.isday end, "IsNight",
        PriorityNode{
            ChattyNode(self.inst, STRINGS.BORE_TALK_RUN_FROM_SPIDER,
                RunAway(self.inst, "spider", 4, 8)),
            ChattyNode(self.inst, STRINGS.BORE_TALK_FIND_MEAT,
                DoAction(self.inst, FindFoodAction )),
            RunAway(self.inst, "player", START_RUN_DIST, STOP_RUN_DIST, function(target) return ShouldRunAway(self.inst, target) end ),
            ChattyNode(self.inst, STRINGS.BORE_TALK_GO_HOME,
                DoAction(self.inst, GoHomeAction, "go home", true )),			
            ChattyNode(self.inst, STRINGS.BORE_TALK_FIND_LIGHT,
                FindLight(self.inst, SEE_LIGHT_DIST, SafeLightDist)),
            ChattyNode(self.inst, STRINGS.BORE_TALK_PANIC,
                Panic(self.inst)),
        },1)
    
    
    local root = 
        PriorityNode(
        {
            
            WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire",
				ChattyNode(self.inst, STRINGS.BORE_TALK_PANICFIRE,
					Panic(self.inst))),
            ChattyNode(self.inst, STRINGS.BORE_TALK_FIGHT,
                WhileNode( function() return self.inst.components.combat.target and not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
                    PriorityNode({
                            WhileNode( function() return self.inst.components.combat.target and (distsq(self.inst.components.combat.target:GetPosition(), self.inst:GetPosition()) > 6*6 or self.inst.sg:HasStateTag("charging")) end,
                                --If you're far away or already doing a charge, charge.
                                "RamAttack", ChaseAndRam(self.inst, MAX_CHARGE_TIME, CHASE_GIVEUP_DIST, MAX_CHARGE_DIST)),
                            WhileNode( function() return self.inst.components.combat.target and distsq(self.inst.components.combat.target:GetPosition(), self.inst:GetPosition()) < 6*6 and not self.inst.sg:HasStateTag("charging") end,
                                --If you're close and not already charging just do a regular attack.
                                "NormalAttack", ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST)),
                        }, 0.1)
                     )),
            ChattyNode(self.inst, STRINGS.BORE_TALK_FIGHT,
                WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge",
                    RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST, 
                        function(target) return self.inst.components.combat:InCooldown() end))),
            RunAway(self.inst, function(guy) return guy:HasTag("pig") and guy.components.combat and guy.components.combat.target == self.inst end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST ),
            ChattyNode(self.inst, STRINGS.BORE_TALK_ATTEMPT_TRADE,
                FaceEntity(self.inst, GetTraderFn, KeepTraderFn)),            
            day,
            night
        }, .5)
    
    self.bt = BT(self.inst, root)
    
end

return PigBrain
