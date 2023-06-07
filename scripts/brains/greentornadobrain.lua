require "behaviours/wander"
require "behaviours/leash"

local TornadoBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local MIN_FOLLOW = 0
local MAX_FOLLOW = 11
local MED_FOLLOW = 6

local wanderTimes = 
{
    minwalktime = .25,
    randwalktime = .25,
    minwaittime = .25,
    randwaittime = .25,
}

function TornadoBrain:OnStart()
    local root = 
    PriorityNode(
    {
        Leash(self.inst, function() return self.inst.components.knownlocations:GetLocation("target") end, 3, 1, true),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("target") end, 2, wanderTimes),
		Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW, MED_FOLLOW, MAX_FOLLOW, true),
    }, .25)
    self.bt = BT(self.inst, root)
end

return TornadoBrain