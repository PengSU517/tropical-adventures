require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/attackwall"
require "behaviours/panic"
require "behaviours/leash"
require "behaviours/minperiod"
require "behaviours/standstill"

local BrainCommon = require("brains/braincommon")

local WANDER_DIST_DAY = 10

local RUN_AWAY_DIST = 3
local STOP_RUN_AWAY_DIST = 12
local SOLO_START_FACE_DIST = 2
local SOLO_KEEP_FACE_DIST = 4

local MIN_FOLLOW = 0
local MAX_FOLLOW = 16
local MED_FOLLOW = 8
local TARGET_FOLLOW = 16

local MAX_WANDER_DIST = 5

local MAX_CHASE_TIME = 8

local MAX_CHASE_DIST = 10

-- NEW VARS
local HERD_KEEPUP_DIST = 18
local START_ALERT_DIST = 6
local KEEP_ALERT_DIST = 8

local function ResetData(inst)
    if TheWorld.components.deerherding ~= nil then
       TheWorld.components.deerherding:SetHerdAlertTarget(inst, FindClosestPlayerToInst(inst, START_ALERT_DIST, true))
    end
end

local function GetAlertTargetFn(inst)
    if inst:IsValid() then
        return TheWorld.components.deerherding:GetClosestHerdAlertTarget(inst)
    end
end

local function KeepAlertTargetFn(inst, target)
    if inst:IsValid() then
        return TheWorld.components.deerherding:HerdHasAlertTarget()
    end
end

local function GetNonHerdingFaceTargetFn(inst)
    return FindClosestPlayerToInst(inst, SOLO_START_FACE_DIST, true)
end

local function KeepNonHerdingFaceTargetFn(inst, target)
    return not target:HasTag("notarget")
        and inst:IsNear(target, SOLO_KEEP_FACE_DIST)
end

local function GetWanderDistFn(inst)
    return WANDER_DIST_DAY
end

local function GetLocationInHerd(inst)
    local herdpt = TheWorld.components.deerherding.herdlocation
    local offset = inst.components.knownlocations:GetLocation("herdoffset")
    return (herdpt and offset) and (herdpt + offset) or nil
end

local function ShouldMoveAsHerd(self)
    local herd_pt = GetLocationInHerd(self.inst)
    return herd_pt and (self.inst:GetDistanceSqToPoint(herd_pt:Get()) > (TUNING.DEER_HERD_MOVE_DIST * 0.5))
end

local function GetGrazingLocation(inst)
    local herdpt = TheWorld.components.deerherding.herdlocation
    local offset = inst.components.knownlocations:GetLocation("herdoffset")
    return (herdpt and offset) and (herdpt + offset * 2) or nil
end

local function GetGrazingAngle(inst)
    local offset = inst.components.knownlocations:GetLocation("herdoffset")
    return GetRandomWithVariance(math.atan2(offset.z, offset.x), 66*DEGREES)
end

local function IsHerdGrazing(self)
    return TheWorld.components.deerherding:IsGrazing()
    -- todo: Ask TheWorld.components.deerherding if it is grazing
end

local DeerBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function DeerBrain:OnStart()
    local root = PriorityNode(
    {	
		ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
		FaceEntity(self.inst, GetNonHerdingFaceTargetFn, KeepNonHerdingFaceTargetFn),
		Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW, MED_FOLLOW, MAX_FOLLOW, true),
        WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        Wander(self.inst),
        
    })

    self.bt = BT(self.inst, root)
end

return DeerBrain
