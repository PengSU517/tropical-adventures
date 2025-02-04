require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/chaseandattack"

local STOP_RUN_DIST = 10
local SEE_PLAYER_DIST = 5
local AVOID_PLAYER_DIST = 3
local AVOID_PLAYER_STOP = 6
local SEE_BAIT_DIST = 20
local MAX_WANDER_DIST = 20
local SEE_STOLEN_ITEM_DIST = 10
local MAX_CHASE_TIME = 8

local PikoBrain = Class(Brain, function(self, inst) Brain._ctor(self, inst) end)

local function hasvalidhome(piko)
    local seeker = piko.components.homeseeker
    if not seeker then return false end
    local home = seeker:HasHome() and seeker.home
    local validhome = home and home:IsValid() and not home:HasTag("burnt") and not home:HasTag("stump") and
                          home.components.childspawner and not home.components.childspawner:IsFull() and
                          not piko.sg:HasStateTag("trapped")
    if home and (home:HasTag("burnt") or home:HasTag("stump")) then seeker.home = nil end
    if home and home.components.childspawner and
        (TheWorld.state.isdusk or TheWorld.state.isnight and TheWorld.state.moonphase ~= "new") then
        home.components.childspawner:StopSpawning()
    end
    return validhome
end

local function GoHomeAction(inst)
    return hasvalidhome(inst) and BufferedAction(inst, inst.components.seeker.home, ACTIONS.GOHOME)
end

local function EatFoodAction(inst)
    local target = FindEntity(inst, SEE_BAIT_DIST, function(item)
        return inst.components.eater:CanEat(item) and item.components.bait and not item:HasTag("planted") and
                   not (item.components.inventoryitem and item.components.inventoryitem:IsHeld())
    end)
    if target then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function()
            return not (target.components.inventoryitem and target.components.inventoryitem:IsHeld())
        end
        return act
    end
end

local function PickupAction(inst)
    if inst.components.inventory:NumItems() < 1 then
        local target = FindEntity(inst, SEE_STOLEN_ITEM_DIST, function(item)
            local x, y, z = item.Transform:GetWorldPosition()
            return
                x and y and z and item.components.inventoryitem and item.components.inventoryitem.cangoincontainer and
                    not item.components.inventoryitem:IsHeld() and item.components.inventoryitem.canbepickedup and
                    item:IsOnValidGround() and not item:HasTag("trap")
        end)
        if target then return BufferedAction(inst, target, ACTIONS.PICKUP) end
    end
end

local function findhome(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local trees = TheSim:FindEntities(x, y, z, 30, {"teatree"}, {"stump", "burnt"})
    local home = nil
    for _, tree in ipairs(trees) do
        if not tree:HasTag("burnt") and not tree:HasTag("stump") and not tree.components.childspawner and
            not tree.components.childspawner:IsFull() then
            home = tree
            break
        end
    end

    if home then
        if not home.components.childspawner then home.setupspawner(home) end
        home.components.childspawner:StopSpawning()
        home.components.childspawner:TakeOwnership(inst)
        inst.findhometask:Cancel()
        inst.findhometask = nil
    end
end

local function CheckForHome(inst)
    if not inst.components.homeseeker and not inst.findhometask then
        inst.findhometask = inst:DoPeriodicTask(10, function() findhome(inst) end)
        return true
    end
end

function PikoBrain:OnStart()
    local root = PriorityNode({
        WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire",
            Panic(self.inst)),
        WhileNode(function() return self.inst.components.inventory:NumItems() > 0 and self.inst.components.homeseeker end,
            "run off with prize", DoAction(self.inst, GoHomeAction, "go home", true)),
            DoAction(self.inst, PickupAction, "searching for prize", true),
        WhileNode(function() return self.inst.currentlyRabid end, "IsRabid",
            ChaseAndAttack(self.inst, MAX_CHASE_TIME)),
            RunAway(self.inst, "scarytoprey", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP),
            RunAway(self.inst, "scarytoprey", SEE_PLAYER_DIST, STOP_RUN_DIST, nil, true),
        EventNode(self.inst, "gohome", DoAction(self.inst, GoHomeAction, "go home", true)),
        WhileNode(function() return not TheWorld.state.isday and
            (not TheWorld.state.isnight or TheWorld.state.moonphase ~= "new") end, "IsNight",
            DoAction(self.inst, GoHomeAction, "go home", true)),
        -- WhileNode(function() return TheWorld.state.isspring end, "IsSpring",
            -- DoAction(self.inst, GoHomeAction, "go home", true )),
            DoAction(self.inst, EatFoodAction),
        WhileNode(function() return CheckForHome(self.inst) end, "wander to find home",
            Wander(self.inst)), Wander(self.inst, function() return hasvalidhome(self.inst) and
                self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)}, 0.25)
    self.bt = BT(self.inst, root)
end

return PikoBrain
