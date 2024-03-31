local TAENV = env
GLOBAL.setfenv(1, GLOBAL)

local unpack = unpack

----------------------------------------------------------------------------------------
local Drownable = require("components/drownable")

local _ShouldDrown = Drownable.ShouldDrown
function Drownable:ShouldDrown(...)
    return (self.inst.components.sailor == nil or not self.inst.components.sailor:IsSailing() and self.inst._embarkingboat == nil) and
    _ShouldDrown(self, ...)
end

local function _never_invincible()
    return false
end

local function _always_over_water()
    return true
end

function Drownable:CanDrownOverWater(allow_invincible)
    local _IsInvincible = allow_invincible and self.inst.components.health ~= nil and
    self.inst.components.health.IsInvincible or nil
    if _IsInvincible ~= nil then self.inst.components.health.IsInvincible = _never_invincible end
    local _enabled = self.enabled
    self.enabled = self.enabled ~= false
    local _IsOverWater = self.IsOverWater
    self.IsOverWater = _always_over_water
    local ret = self:ShouldDrown()
    self.IsOverWater = _IsOverWater
    self.enabled = _enabled
    if _IsInvincible ~= nil then self.inst.components.health.IsInvincible = _IsInvincible end
    return ret and
    not self.inst:HasTag("playerghost")                -- HACK: Playerghosts dont drown because they lack the onsink sg event
end

function Drownable:SetRescueData(data)
    self.rescue_data = data
end

function Drownable:GetRescueData()
    return self.rescue_data
end

function Drownable:FindRescueItemData()
    if self.inst.components.leader and self.inst.components.leader:CountFollowers() > 0 then
        --Ballphins
        for item, _ in pairs(self.inst.components.leader.followers) do
            if item.components.flotationdevice ~= nil and item.components.flotationdevice:IsEnabled() and item.components.flotationdevice:Test() then
                return item
            end
        end
    end

    if self.inst.components.inventory then
        -- Life Jacket
        for slot, item in pairs(self.inst.components.inventory.equipslots) do
            if item.components.flotationdevice ~= nil and item.components.flotationdevice:IsEnabled() and item.components.flotationdevice:Test() then
                return item
            end
        end
    end
end

function Drownable:FindRescueData()
    return self.rescuefn ~= nil and self.rescuefn(self.inst) -- Woodie
        or self:FindRescueItemData()
        or
        self.inst.sg ~= nil and
        (self.inst.sg:HasStateTag("jumping") and "PLANK_RESURRECT" or self.inst.sg:HasStateTag("should_not_drown_to_death") and "FAST_RESURRECT")
        or self.fallback_rescuefn ~= nil and self.fallback_rescuefn(self.inst) -- Wurt
        or nil
end

local _OnFallInOcean = Drownable.OnFallInOcean
function Drownable:OnFallInOcean(shore_x, shore_y, shore_z, ...)
    self:SetRescueData(self:FindRescueData())

    return _OnFallInOcean(self, shore_x, shore_y, shore_z, ...)
end

function Drownable:UseRescueData()
    local rescue_item = type(self.rescue_data) == "table" and self.rescue_data or nil
    if rescue_item ~= nil then
        if rescue_item.components.flotationdevice ~= nil then
            rescue_item.components.flotationdevice:OnPreventDrowningDamage()
        end
    end
    self:SetRescueData(nil)
end

function Drownable:TakeDrowningDamage()
    local rescue_tunings = self.rescue_data ~= nil and
    TUNING.RESCUE_DAMAGE[(type(self.rescue_data) == "table" and self.rescue_data.prefab or self.rescue_data)]
    local tunings = rescue_tunings
        or self.customtuningsfn ~= nil and self.customtuningsfn(self.inst)
        or TUNING.DROWNING_DAMAGE[string.upper(self.inst.prefab)]
        or TUNING.DROWNING_DAMAGE[self.inst:HasTag("player") and "DEFAULT" or "CREATURE"]

    if self.inst.components.moisture ~= nil and tunings.WETNESS ~= nil then
        self.inst.components.moisture:DoDelta(tunings.WETNESS, true)
    end

    if self.rescue_data ~= nil then
        self:UseRescueData()
        if rescue_tunings == nil then
            return
        end
    end

    if self.inst.components.hunger ~= nil and tunings.HUNGER ~= nil then
        local delta = -math.min(tunings.HUNGER, self.inst.components.hunger.current - 30)
        if delta < 0 then
            self.inst.components.hunger:DoDelta(delta)
        end
    end

    if self.inst.components.health ~= nil then
        if tunings.HEALTH_PENALTY ~= nil then
            self.inst.components.health:DeltaPenalty(tunings.HEALTH_PENALTY)
        end

        if tunings.HEALTH ~= nil then
            local delta = -math.min(tunings.HEALTH, self.inst.components.health.currenthealth - 30)
            if delta < 0 then
                self.inst.components.health:DoDelta(delta, false, "drowning", true, nil, true)
            end
        end
    end

    if self.inst.components.sanity ~= nil and tunings.SANITY ~= nil then
        local delta = -math.min(tunings.SANITY, self.inst.components.sanity.current - 30)
        if delta < 0 then
            self.inst.components.sanity:DoDelta(delta)
        end
    end

    if self.ontakedrowningdamage ~= nil then
        self.ontakedrowningdamage(self.inst, tunings)
    end
end

TAENV.AddComponentPostInit("drownable", function(cmp)
    if cmp.inst and TheWorld.has_ia_drowning then
        cmp.inst:RemoveComponent("drownable")
        cmp.inst:AddSpoofedComponent("ia_drownable", "drownable")
    end
end)
