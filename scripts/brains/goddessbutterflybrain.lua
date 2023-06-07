require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/findflower"
require "behaviours/panic"

local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 10
local POLLINATE_FLOWER_DIST = 10
local SEE_FLOWER_DIST = 30
local MAX_WANDER_DIST = 8

local MIN_FOLLOW = 0
local MAX_FOLLOW = 11
local MED_FOLLOW = 6


local function NearestFlowerPos(inst)
    local flower = GetClosestInstWithTag("goddess_flower", inst, SEE_FLOWER_DIST)
    if flower and 
       flower:IsValid() then
        return Vector3(flower.Transform:GetWorldPosition() )
    end
end

local function GoHomeAction(inst)
    local flower = GetClosestInstWithTag("goddess_flower", inst, SEE_FLOWER_DIST)
    if flower and 
       flower:IsValid() then
        return BufferedAction(inst, flower, ACTIONS.GOHOME, nil, Vector3(flower.Transform:GetWorldPosition() ))
    end
end

local ButterflyBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function ButterflyBrain:OnStart()

    local root =
        PriorityNode(
        {
            WhileNode( function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
            WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
            Wander(self.inst, NearestFlowerPos, MAX_WANDER_DIST),
			Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW, MED_FOLLOW, MAX_FOLLOW, true),			
        },1)
    
    
    self.bt = BT(self.inst, root)
    
         
end

return ButterflyBrain