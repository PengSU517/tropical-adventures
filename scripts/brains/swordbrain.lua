require "behaviours/follow"
require "behaviours/wander"

local SealBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local MIN_FOLLOW = 0
local MAX_FOLLOW = 10
local MED_FOLLOW = 8
local MAX_CHASE_TIME = 10


local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end


function SealBrain:OnStart()
    local root = PriorityNode(
    {
		ChaseAndAttack(self.inst, MAX_CHASE_TIME),
        Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW, MED_FOLLOW, MAX_FOLLOW, true),
        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
		Wander(self.inst),
    }, .5)

    self.bt = BT(self.inst, root)
end

return SealBrain
