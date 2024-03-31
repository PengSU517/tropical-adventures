local TAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------
local Locomotor = require("components/locomotor")

local SPEED_MOD_TIMER_DT = FRAMES

----------------------------------------------------------------------------------------
--These functions have a server variant and a client variant
if TheNet:GetIsServer() then
    function Locomotor:GetOverrideAngle()
        return self.override_angle
    end

    function Locomotor:HasOverrideAngle()
        return self.hasoverride_angle
    end

    function Locomotor:HasMomentum()
        return self.hasmomentum
    end

    function Locomotor:IsDisabled()
        return self.disable
    end

    function Locomotor:ExternalSpeedAdder()
        return self.externalspeedadder
    end

    function Locomotor:GetSpeedAdder()
        local add = self:ExternalSpeedAdder()
        return add
    end

    function Locomotor:ExternalAccelerationAdder()
        return self.externalaccelerationadder
    end

    function Locomotor:GetAccelerationAdder()
        local add = self:ExternalAccelerationAdder()
        return add
    end

    function Locomotor:ExternalAccelerationMultiplier()
        return self.externalaccelerationmultiplier
    end

    function Locomotor:GetAccelerationMultiplier()
        local mult = self:ExternalAccelerationMultiplier()
        return mult
    end

    function Locomotor:ExternalDecelerationAdder()
        return self.externaldecelerationadder
    end

    function Locomotor:GetDecelerationAdder()
        local add = self:ExternalDecelerationAdder()
        return add
    end

    function Locomotor:ExternalDecelerationMultiplier()
        return self.externaldecelerationmultiplier
    end

    function Locomotor:GetDecelerationMultiplier()
        local mult = self:ExternalDecelerationMultiplier()
        return mult
    end
else
    function Locomotor:GetOverrideAngle()
        return self.inst.player_classified ~= nil and self.inst.player_classified.override_angle:value() or
        self.override_angle
    end

    function Locomotor:HasOverrideAngle()
        return self.inst.player_classified ~= nil and self.inst.player_classified.hasoverride_angle:value() or
        self.hasoverride_angle
    end

    function Locomotor:HasMomentum()
        return self.inst.player_classified ~= nil and self.inst.player_classified.hasmomentum:value() or self
        .hasmomentum
    end

    function Locomotor:IsDisabled()
        return self.inst.player_classified ~= nil and self.inst.player_classified.disable:value() or self.disable
    end

    function Locomotor:ExternalSpeedAdder()
        return self.inst.player_classified ~= nil and self.inst.player_classified.externalspeedadder:value() or
        self.externalspeedadder
    end

    function Locomotor:GetSpeedAdder()
        local add = self:ExternalSpeedAdder()
        return add
    end

    function Locomotor:ExternalAccelerationAdder()
        return self.inst.player_classified ~= nil and self.inst.player_classified.externalaccelerationadder:value() or
        self.externalaccelerationadder
    end

    function Locomotor:GetAccelerationAdder()
        local add = self:ExternalAccelerationAdder()
        return add
    end

    function Locomotor:ExternalAccelerationMultiplier()
        return self.inst.player_classified ~= nil and self.inst.player_classified.externalaccelerationmultiplier:value() or
        self.externalaccelerationmultiplier
    end

    function Locomotor:GetAccelerationMultiplier()
        local mult = self:ExternalAccelerationMultiplier()
        return mult
    end

    function Locomotor:ExternalDecelerationAdder()
        return self.inst.player_classified ~= nil and self.inst.player_classified.externaldecelerationadder:value() or
        self.externaldecelerationadder
    end

    function Locomotor:GetDecelerationAdder()
        local add = self:ExternalDecelerationAdder()
        return add
    end

    function Locomotor:ExternalDecelerationMultiplier()
        return self.inst.player_classified ~= nil and self.inst.player_classified.externaldecelerationmultiplier:value() or
        self.externaldecelerationmultiplier
    end

    function Locomotor:GetDecelerationMultiplier()
        local mult = self:ExternalDecelerationMultiplier()
        return mult
    end

    function Locomotor:GetWindMult()
        return self.inst.player_classified ~= nil and self.inst.player_classified.windspeedmult:value() or nil
    end
end

----------------------------------------------------------------------------------------

function Locomotor:IsAmphibious()
    return self:CanPathfindOnWater() == true and self:CanPathfindOnLand() == true
end

function Locomotor:IsSlowing()
    return self.slowing == true
end

----------------------------------------------------------------------------------------

function Locomotor:SetExternalAccelerationAdder(source, key, a)
    if key == nil then
        return
    elseif a == nil or a == 0 then
        self:RemoveExternalAccelerationAdder(source, key)
        return
    end
    local src_params = self._externalaccelerationadders[source]
    if src_params == nil then
        self._externalaccelerationadders[source] = {
            adders = { [key] = a },
            onremove = function(source)
                self._externalaccelerationadders[source] = nil
                self.externalaccelerationadder = self:RecalculateExternalAccelerationAdder(self
                ._externalaccelerationadders)
            end,
        }
        self.inst:ListenForEvent("onremove", self._externalaccelerationadders[source].onremove, source)
        self.externalaccelerationadder = self:RecalculateExternalAccelerationAdder(self._externalaccelerationadders)
    elseif src_params.adders[key] ~= a then
        src_params.adders[key] = a
        self.externalaccelerationadder = self:RecalculateExternalAccelerationAdder(self._externalaccelerationadders)
    end
end

function Locomotor:RemoveExternalAccelerationAdder(source, key)
    local src_params = self._externalaccelerationadders[source]
    if src_params == nil then
        return
    elseif key ~= nil then
        src_params.adders[key] = nil
        if next(src_params.adders) ~= nil then
            --this source still has other keys
            self.externalaccelerationadder = self:RecalculateExternalAccelerationAdder(self._externalaccelerationadders)
            return
        end
    end
    --remove the entire source
    self.inst:RemoveEventCallback("onremove", src_params.onremove, source)
    self._externalaccelerationadders[source] = nil
    self.externalaccelerationadder = self:RecalculateExternalAccelerationAdder(self._externalaccelerationadders)
end

function Locomotor:RecalculateExternalAccelerationAdder(sources)
    local a = 0
    for source, src_params in pairs(sources) do
        for k, v in pairs(src_params.adders) do
            a = a + v
        end
    end
    return a
end

function Locomotor:GetExternalAccelerationAdder(source, key)
    local src_params = self._externalaccelerationadders[source]
    if src_params == nil then
        return 0
    elseif key == nil then
        local a = 0
        for k, v in pairs(src_params.adders) do
            a = a + v
        end
        return a
    end
    return src_params.adders[key] or 0
end

function Locomotor:SetExternalAccelerationMultiplier(source, key, m)
    if key == nil then
        return
    elseif m == nil or m == 1 then
        self:RemoveExternalAccelerationMultiplier(source, key)
        return
    end
    local src_params = self._externalaccelerationmultipliers[source]
    if src_params == nil then
        self._externalaccelerationmultipliers[source] = {
            multipliers = { [key] = m },
            onremove = function(source)
                self._externalaccelerationmultipliers[source] = nil
                self.externalaccelerationmultiplier = self:RecalculateExternalAccelerationMultiplier(self
                ._externalaccelerationmultipliers)
            end,
        }
        self.inst:ListenForEvent("onremove", self._externalaccelerationmultipliers[source].onremove, source)
        self.externalaccelerationmultiplier = self:RecalculateExternalAccelerationMultiplier(self
        ._externalaccelerationmultipliers)
    elseif src_params.multipliers[key] ~= m then
        src_params.multipliers[key] = m
        self.externalaccelerationmultiplier = self:RecalculateExternalAccelerationMultiplier(self
        ._externalaccelerationmultipliers)
    end
end

function Locomotor:RemoveExternalAccelerationMultiplier(source, key)
    local src_params = self._externalaccelerationmultipliers[source]
    if src_params == nil then
        return
    elseif key ~= nil then
        src_params.multipliers[key] = nil
        if next(src_params.multipliers) ~= nil then
            --this source still has other keys
            self.externalaccelerationmultiplier = self:RecalculateExternalAccelerationMultiplier(self
            ._externalaccelerationmultipliers)
            return
        end
    end
    --remove the entire source
    self.inst:RemoveEventCallback("onremove", src_params.onremove, source)
    self._externalaccelerationmultipliers[source] = nil
    self.externalaccelerationmultiplier = self:RecalculateExternalAccelerationMultiplier(self
    ._externalaccelerationmultipliers)
end

function Locomotor:RecalculateExternalAccelerationMultiplier(sources)
    local m = 1
    for source, src_params in pairs(sources) do
        for k, v in pairs(src_params.multipliers) do
            m = m * v
        end
    end
    return m
end

function Locomotor:GetExternalAccelerationMultiplier(source, key)
    local src_params = self._externalaccelerationmultipliers[source]
    if src_params == nil then
        return 1
    elseif key == nil then
        local m = 1
        for k, v in pairs(src_params.multipliers) do
            m = m * v
        end
        return m
    end
    return src_params.multipliers[key] or 1
end

function Locomotor:SetExternalDecelerationAdder(source, key, a)
    if key == nil then
        return
    elseif a == nil or a == 0 then
        self:RemoveExternalDecelerationAdder(source, key)
        return
    end
    local src_params = self._externaldecelerationadders[source]
    if src_params == nil then
        self._externaldecelerationadders[source] = {
            adders = { [key] = a },
            onremove = function(source)
                self._externaldecelerationadders[source] = nil
                self.externaldecelerationadder = self:RecalculateExternalDecelerationAdder(self
                ._externaldecelerationadders)
            end,
        }
        self.inst:ListenForEvent("onremove", self._externaldecelerationadders[source].onremove, source)
        self.externaldecelerationadder = self:RecalculateExternalDecelerationAdder(self._externaldecelerationadders)
    elseif src_params.adders[key] ~= a then
        src_params.adders[key] = a
        self.externaldecelerationadder = self:RecalculateExternalDecelerationAdder(self._externaldecelerationadders)
    end
end

function Locomotor:RemoveExternalDecelerationAdder(source, key)
    local src_params = self._externaldecelerationadders[source]
    if src_params == nil then
        return
    elseif key ~= nil then
        src_params.adders[key] = nil
        if next(src_params.adders) ~= nil then
            --this source still has other keys
            self.externaldecelerationadder = self:RecalculateExternalDecelerationAdder(self._externaldecelerationadders)
            return
        end
    end
    --remove the entire source
    self.inst:RemoveEventCallback("onremove", src_params.onremove, source)
    self._externaldecelerationadders[source] = nil
    self.externaldecelerationadder = self:RecalculateExternalDecelerationAdder(self._externaldecelerationadders)
end

function Locomotor:RecalculateExternalDecelerationAdder(sources)
    local a = 0
    for source, src_params in pairs(sources) do
        for k, v in pairs(src_params.adders) do
            a = a + v
        end
    end
    return a
end

function Locomotor:GetExternalDecelerationAdder(source, key)
    local src_params = self._externaldecelerationadders[source]
    if src_params == nil then
        return 0
    elseif key == nil then
        local a = 0
        for k, v in pairs(src_params.adders) do
            a = a + v
        end
        return a
    end
    return src_params.adders[key] or 0
end

function Locomotor:SetExternalDecelerationMultiplier(source, key, m)
    if key == nil then
        return
    elseif m == nil or m == 1 then
        self:RemoveExternalDecelerationMultiplier(source, key)
        return
    end
    local src_params = self._externaldecelerationmultipliers[source]
    if src_params == nil then
        self._externaldecelerationmultipliers[source] = {
            multipliers = { [key] = m },
            onremove = function(source)
                self._externaldecelerationmultipliers[source] = nil
                self.externaldecelerationmultiplier = self:RecalculateExternalDecelerationMultiplier(self
                ._externaldecelerationmultipliers)
            end,
        }
        self.inst:ListenForEvent("onremove", self._externaldecelerationmultipliers[source].onremove, source)
        self.externaldecelerationmultiplier = self:RecalculateExternalDecelerationMultiplier(self
        ._externaldecelerationmultipliers)
    elseif src_params.multipliers[key] ~= m then
        src_params.multipliers[key] = m
        self.externaldecelerationmultiplier = self:RecalculateExternalDecelerationMultiplier(self
        ._externaldecelerationmultipliers)
    end
end

function Locomotor:RemoveExternalDecelerationMultiplier(source, key)
    local src_params = self._externaldecelerationmultipliers[source]
    if src_params == nil then
        return
    elseif key ~= nil then
        src_params.multipliers[key] = nil
        if next(src_params.multipliers) ~= nil then
            --this source still has other keys
            self.externaldecelerationmultiplier = self:RecalculateExternalDecelerationMultiplier(self
            ._externaldecelerationmultipliers)
            return
        end
    end
    --remove the entire source
    self.inst:RemoveEventCallback("onremove", src_params.onremove, source)
    self._externaldecelerationmultipliers[source] = nil
    self.externaldecelerationmultiplier = self:RecalculateExternalDecelerationMultiplier(self
    ._externaldecelerationmultipliers)
end

function Locomotor:RecalculateExternalDecelerationMultiplier(sources)
    local m = 1
    for source, src_params in pairs(sources) do
        for k, v in pairs(src_params.multipliers) do
            m = m * v
        end
    end
    return m
end

function Locomotor:GetExternalDecelerationMultiplier(source, key)
    local src_params = self._externaldecelerationmultipliers[source]
    if src_params == nil then
        return 1
    elseif key == nil then
        local m = 1
        for k, v in pairs(src_params.multipliers) do
            m = m * v
        end
        return m
    end
    return src_params.multipliers[key] or 1
end

function Locomotor:GetDeceleration()
    local add = self:GetDecelerationAdder()
    local mult = self:GetDecelerationMultiplier()
    return (self.deceleration + add) * mult
end

function Locomotor:GetAcceleration()
    local add = self:GetAccelerationAdder()
    local mult = self:GetAccelerationMultiplier()
    return (self.acceleration + add) * mult
end

function Locomotor:SetExternalSpeedAdder(source, key, a, timer)
    if key == nil then
        return
    elseif a == nil or a == 0 then
        self:RemoveExternalSpeedAdder(source, key)
        return
    end
    local src_params = self._externalspeedadders[source]
    if src_params == nil then
        self._externalspeedadders[source] = {
            adders = { [key] = a },
            onremove = function(source)
                self._externalspeedadders[source] = nil
                self.externalspeedadder = self:RecalculateExternalSpeedAdder(self._externalspeedadders)
            end,
        }
        self.inst:ListenForEvent("onremove", self._externalspeedadders[source].onremove, source)
        self.externalspeedadder = self:RecalculateExternalSpeedAdder(self._externalspeedadders)
    elseif src_params.adders[key] ~= a then
        src_params.adders[key] = a
        self.externalspeedadder = self:RecalculateExternalSpeedAdder(self._externalspeedadders)
    end

    if timer then
        local externaltimers = self.externalspeedadder_timer[source]
        if externaltimers == nil then
            self.externalspeedadder_timer[source] = {
                timers = { [key] = timer },
                onremove = function(source)
                    self.externalspeedadder_timer[source] = nil
                end,
            }
            self.inst:ListenForEvent("onremove", self.externalspeedadder_timer[source].onremove, source)
        else
            externaltimers.timers[key] = timer
        end

        if not self.updating_mods_task then
            self.updating_mods_task = self.inst:DoPeriodicTask(SPEED_MOD_TIMER_DT,
                function() self:UpdateSpeedModifierTimers(SPEED_MOD_TIMER_DT) end)
        end
    end
end

function Locomotor:RemoveExternalSpeedAdder(source, key)
    local src_params = self._externalspeedadders[source]
    if src_params == nil then
        return
    elseif key ~= nil then
        src_params.adders[key] = nil
        if self.externalspeedadder_timer[source] and self.externalspeedadder_timer[source].timers[key] then
            self.externalspeedadder_timer[source].timers[key] = nil
        end
        if next(src_params.adders) ~= nil then
            --this source still has other keys
            self.externalspeedadder = self:RecalculateExternalSpeedAdder(self._externalspeedadders)
            return
        end
    end
    --remove the entire source
    self.inst:RemoveEventCallback("onremove", src_params.onremove, source)
    if self.externalspeedadder_timer[source] then
        self.inst:RemoveEventCallback("onremove", self.externalspeedadder_timer[source].onremove, source)
        self.externalspeedadder_timer[source] = nil
    end
    self._externalspeedadders[source] = nil
    self.externalspeedadder = self:RecalculateExternalSpeedAdder(self._externalspeedadders)
end

function Locomotor:RecalculateExternalSpeedAdder(sources)
    local a = 0
    for source, src_params in pairs(sources) do
        for k, v in pairs(src_params.adders) do
            a = a + v
        end
    end
    return a
end

function Locomotor:GetExternalSpeedAdder(source, key)
    local src_params = self._externalspeedadders[source]
    if src_params == nil then
        return 0
    elseif key == nil then
        local a = 0
        for k, v in pairs(src_params.adders) do
            a = a + v
        end
        return a
    end
    return src_params.adders[key] or 0
end

function Locomotor:UpdateSpeedModifierTimers(dt)
    local function CheckForRemainingTimers()
        for k, source in pairs(self.externalspeedadder_timer) do
            for key, time in pairs(source.timers) do
                if time > 0 then
                    return true
                end
            end
        end

        for k, source in pairs(self.externalspeedmultipliers_timer) do
            for key, time in pairs(source.timers) do
                if time > 0 then
                    return true
                end
            end
        end

        return false
    end

    for k, source in pairs(self.externalspeedadder_timer) do
        for key, time in pairs(source.timers) do
            source.timers[key] = time - dt
            if source.timers[key] <= 0 then
                self:RemoveExternalSpeedAdder(k, key)
                if not CheckForRemainingTimers() then
                    return
                end
            end
        end
    end

    for k, source in pairs(self.externalspeedmultipliers_timer) do
        for key, time in pairs(source.timers) do
            source.timers[key] = time - dt
            if source.timers[key] <= 0 then
                self:RemoveExternalSpeedMultiplier(k, key)
                if not CheckForRemainingTimers() then
                    return
                end
            end
        end
    end

    if not CheckForRemainingTimers() then
        --Why is this only done here and not in the above returns too? -M
        self.updating_mods_task:Cancel()
        self.updating_mods_task = nil
    end
end

local _SetExternalSpeedMultiplier = Locomotor.SetExternalSpeedMultiplier
function Locomotor:SetExternalSpeedMultiplier(source, key, m, timer, ...)
    if key == nil then
        return
    elseif m == nil or m == 1 then
        self:RemoveExternalSpeedMultiplier(source, key)
        return
    end
    _SetExternalSpeedMultiplier(self, source, key, m, ...)
    if timer then
        local externaltimers = self.externalspeedmultipliers_timer[source]
        if externaltimers == nil then
            self.externalspeedmultipliers_timer[source] = {
                timers = { [key] = timer },
                onremove = function(source)
                    self.externalspeedmultipliers_timer[source] = nil
                end,
            }
            self.inst:ListenForEvent("onremove", self.externalspeedmultipliers_timer[source].onremove, source)
        else
            externaltimers.timers[key] = timer
        end

        if not self.updating_mods_task then
            self.updating_mods_task = self.inst:DoPeriodicTask(SPEED_MOD_TIMER_DT,
                function() self:UpdateSpeedModifierTimers(SPEED_MOD_TIMER_DT) end)
        end
    end
end

local _RemoveExternalSpeedMultiplier = Locomotor.RemoveExternalSpeedMultiplier
function Locomotor:RemoveExternalSpeedMultiplier(source, key, ...)
    local src_params = self._externalspeedmultipliers[source]
    if src_params == nil then
        return
    end
    if key == nil then
        if self.externalspeedmultipliers_timer[source] then
            self.inst:RemoveEventCallback("onremove", self.externalspeedmultipliers_timer[source].onremove, source)
            self.externalspeedmultipliers_timer[source] = nil
        end
    end
    if key ~= nil then
        if self.externalspeedmultipliers_timer[source] and self.externalspeedmultipliers_timer[source].timers[key] then
            self.externalspeedmultipliers_timer[source].timers[key] = nil
        end
    end
    _RemoveExternalSpeedMultiplier(self, source, key, ...)
end

function Locomotor:SetOverrideAngle(adjuster, angle)
    if self._override_angles[adjuster] ~= angle then
        self._override_angles[adjuster] = angle

        local hasangles = (next(self._override_angles) ~= nil)
        if self.hasoverride_angle ~= hasangles then
            self.hasoverride_angle = hasangles
        end
        if hasangles then
            self.override_angle = self:CalculateOverrideAngle()
        end
    end
end

--https://www.themathdoctors.org/averaging-angles/
function Locomotor:CalculateOverrideAngle()
    local Num = 0
    local Den = 0
    for i, v in pairs(self._override_angles) do
        Num = Num + math.sin(math.rad(v))
        Den = Den + math.cos(math.rad(v))
    end
    return math.deg(math.atan2(Num, Den))
end

local _StopMoving = Locomotor.StopMoving
function Locomotor:StopMoving(...)
    self.slowing = false
    return _StopMoving(self, ...)
end

local _Stop = Locomotor.Stop
function Locomotor:Stop(sgparams, stopmomentum, ...)
    if self:HasMomentum() and not stopmomentum then
        self.slowing = true
    elseif (not self:HasMomentum()) or stopmomentum then
        if self.softstop and self.inst.sg ~= nil and self.inst.sg:HasStateTag("softstop") then
            self.slowing = false
        end
        return _Stop(self, sgparams, ...)
    end
end

local _OnSave = Locomotor.OnSave
function Locomotor:OnSave(...)
    local data, refs = _OnSave and _OnSave(self, ...) or {}, nil
    data._externalspeedmultipliers = self._externalspeedmultipliers[self.inst] and
    self._externalspeedmultipliers[self.inst].multipliers or nil
    data.externalspeedmultipliers_timer = self.externalspeedmultipliers_timer[self.inst] and
    self.externalspeedmultipliers_timer[self.inst].timers or nil

    data._externalspeedadders = self._externalspeedadders[self.inst] and self._externalspeedadders[self.inst].adders or
    nil
    data.externalspeedadder_timer = self.externalspeedadder_timer[self.inst] and
    self.externalspeedadder_timer[self.inst].timers or nil
    return data, refs
end

local _OnLoad = Locomotor.OnLoad
function Locomotor:OnLoad(data, ...)
    if _OnLoad then _OnLoad(self, data, ...) end
    if data._externalspeedmultipliers then
        for key, mult in pairs(data._externalspeedmultipliers) do
            local timer = data.externalspeedmultipliers_timer and data.externalspeedmultipliers_timer[key] or nil
            --we only want to load speed values that have a timer.
            if timer then
                self:SetExternalSpeedMultiplier(self.inst, key, mult, timer)
            end
        end
    end

    if data._externalspeedadders then
        for key, add in pairs(data._externalspeedadders) do
            local timer = data.externalspeedadder_timer and data.externalspeedadder_timer[key] or nil
            --we only want to load speed values that have a timer.
            if timer then
                self:SetExternalSpeedAdder(self.inst, key, add, timer)
            end
        end
    end
end

local _LongUpdate = Locomotor.LongUpdate
function Locomotor:LongUpdate(dt, ...)
    if _LongUpdate then _LongUpdate(self, dt, ...) end
    if self.updating_mods_task then
        self:UpdateSpeedModifierTimers(dt)
    end
end

local _GetWalkSpeed = Locomotor.GetWalkSpeed
function Locomotor:GetWalkSpeed(...)
    local spd = _GetWalkSpeed(self, ...)
    local spd_mp = self:GetSpeedMultiplier()
    local spd_ad = self:GetSpeedAdder()
    return ((spd / spd_mp) + spd_ad) * spd_mp
end

local _GetRunSpeed = Locomotor.GetRunSpeed
function Locomotor:GetRunSpeed(...)
    local spd = _GetRunSpeed(self, ...)
    local spd_mp = self:GetSpeedMultiplier()
    local spd_ad = self:GetSpeedAdder()
    return ((spd / spd_mp) + spd_ad) * spd_mp
end

local _OnUpdate = Locomotor.OnUpdate
function Locomotor:OnUpdate(dt, ...)
    if self:IsDisabled() then return end
    --all these return _OnUpdate(self, dt) are basicaly a way to prevent execution from reaching our momentum code if it shouldnt...
    if self.hopping or not self.inst:IsValid() then
        return _OnUpdate(self, dt, ...)
    end
    local dsq = 0 --distance to target, squared
    if self.dest then
        --Print(VERBOSITY.DEBUG, "    w dest")
        if (not self.dest:IsValid() or (self.bufferedaction and not self.bufferedaction:IsValid())) or self.inst.components.health and self.inst.components.health:IsDead() then
            return _OnUpdate(self, dt, ...)
        end

        local destpos_x, destpos_y, destpos_z = self.dest:GetPoint()
        local mypos_x, mypos_y, mypos_z = self.inst.Transform:GetWorldPosition()
        dsq = distsq(destpos_x, destpos_z, mypos_x, mypos_z)
    end

    --OKAY SO:
    --we make GetMotorSpeed return 0, so that a if block inside _OnUpdate never executes
    --lastly make make self:Stop() always get called with a true to stopmomentum inside the update loop.
    local _GetMotorSpeed = Physics.GetMotorSpeed
    function Physics.GetMotorSpeed(physics, ...)
        if physics == self.inst.Physics and (self.inst:HasTag("player") or not (self.allow_platform_hopping and (self.bufferedaction == nil or not self.bufferedaction.action.disable_platform_hopping))) and self:HasMomentum() then
            --only return zero if _OnUpdate would SetMotorVel or a player with momentum will auto platform hop
            return 0
        end
        return _GetMotorSpeed(physics, ...)
    end

    local _RealStop = self.Stop
    function self:Stop(sgparams, ...)
        _RealStop(self, sgparams, true, ...)
    end

    _OnUpdate(self, dt, ...)

    Physics.GetMotorSpeed = _GetMotorSpeed

    self.Stop = _RealStop

    local cur_speed = self.inst.Physics:GetMotorSpeed()

    --wave boosting, only works with momentum...
    if self.boost then
        cur_speed = cur_speed + self.boost
        self.boost = nil
    end

    if self:HasMomentum() then
        local currentSpeed = cur_speed
        -- Im a bit worried about the safety of this check.... hopefully it doesnt cause problems... -Half
        -- The issue is momentum is applied to overridelocomote and other state tags that prevent movement...
        local is_moving = self.inst.sg ~= nil and self.inst.sg:HasStateTag("moving")
        if self.wantstomoveforward and (is_moving or cur_speed > 0) then
            local targetSpeed = self.isrunning and self:GetRunSpeed() or self:GetWalkSpeed()

            --print("runspeed is ", self.runspeed)
            --print("multiplied speed is ", targetSpeed)
            local dist = math.sqrt(dsq)

            local deceleration = self:GetDeceleration()
            local acceleration = self:GetAcceleration()

            local stopdistance = math.pow(currentSpeed, 2) / (deceleration * 2.0)

            if (stopdistance >= dist and dist > 0) then
                targetSpeed = currentSpeed - deceleration * GetTickTime()
            end

            if self.slowing then
                targetSpeed = 0
            end

            if (targetSpeed > currentSpeed) then
                currentSpeed = currentSpeed + acceleration * GetTickTime()
                --I don't think we have to clamp the speed here, it gets done down below
                if (currentSpeed > targetSpeed) then
                    currentSpeed = targetSpeed
                end
            elseif (targetSpeed < currentSpeed or targetSpeed == 0) then
                currentSpeed = currentSpeed - deceleration * GetTickTime()
                if (currentSpeed <= 0) then
                    currentSpeed = 0
                    self:Stop(nil, true)
                end
            end
        end
        currentSpeed = math.min(currentSpeed, (self.maxSpeed + self:GetSpeedAdder()) * self:GetSpeedMultiplier())
        self.inst.Physics:SetMotorVel(currentSpeed, 0, 0)
    elseif cur_speed > 0 then
        if not (self.allow_platform_hopping and (self.bufferedaction == nil or not self.bufferedaction.action.disable_platform_hopping)) then
            local speed_mult = self:GetSpeedMultiplier()
            local desired_speed = (self.isrunning and self:RunSpeed() or self.walkspeed) + self:GetSpeedAdder()
            if self.dest and self.dest:IsValid() then
                local destpos_x, destpos_y, destpos_z = self.dest:GetPoint()
                local mypos_x, mypos_y, mypos_z = self.inst.Transform:GetWorldPosition()
                local dsq = distsq(destpos_x, destpos_z, mypos_x, mypos_z)
                if dsq <= .25 then
                    speed_mult = math.max(.33, math.sqrt(dsq))
                end
            end

            self.inst.Physics:SetMotorVel(desired_speed * speed_mult, 0, 0)
        end
    end

    if self.ismastersim and cur_speed > 0 and self.inst.components.drydrownable ~= nil and not self.inst.components.drydrownable:IsOnABreak() and self.inst.sg ~= nil and not self.inst.sg:HasStateTag("jumping") then
        if self.inst.components.drydrownable:ShouldDrown() then
            self.inst:PushEvent("onhitcoastline")
        end
        self.inst.components.drydrownable:TakeABreak()
    end
end

local _RunForward = Locomotor.RunForward
function Locomotor:RunForward(direct, ...)
    if self:HasMomentum() then
        self.isrunning = true
        if direct then self.wantstomoveforward = true end
        self:StartUpdatingInternal()
    else
        return _RunForward(self, direct, ...)
    end
end

local _WalkForward = Locomotor.WalkForward
function Locomotor:WalkForward(direct, ...)
    if self:HasMomentum() then
        self.isrunning = false
        if direct then self.wantstomoveforward = true end
        self:StartUpdatingInternal()
    else
        return _WalkForward(self, direct, ...)
    end
end

function Locomotor:PushTargetSpeed()
    if self.isupdating then
        self.inst.Physics:SetMotorVel(self.isrunning and self:GetRunSpeed() or self:GetWalkSpeed(), 0, 0)
    end
end

local _WalkInDirection = Locomotor.WalkInDirection
function Locomotor:WalkInDirection(direction, ...)
    _WalkInDirection(self, direction, ...)
    self.slowing = false
end

local _RunInDirection = Locomotor.RunInDirection
function Locomotor:RunInDirection(direction, throttle, ...)
    _RunInDirection(self, direction, throttle, ...)
    self.slowing = false
end

local _GoToEntity = Locomotor.GoToEntity
function Locomotor:GoToEntity(inst, bufferedaction, run, ...)
    self.slowing = false
    return _GoToEntity(self, inst, bufferedaction, run, ...)
end

local _GoToPoint = Locomotor.GoToPoint
function Locomotor:GoToPoint(pt, bufferedaction, run, overridedest, ...)
    self.slowing = false
    return _GoToPoint(self, pt, bufferedaction, run, overridedest, ...)
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------
local function onoverride_angle(self, override_angle)
    if self.inst.player_classified ~= nil then
        self.inst.player_classified.override_angle:set(override_angle)
    end
end

local function onhasoverride_angle(self, hasoverride_angle)
    if self.inst.player_classified ~= nil then
        self.inst.player_classified.hasoverride_angle:set(hasoverride_angle)
    end
end

local function onhasmomentum(self, hasmomentum)
    if self.inst.player_classified ~= nil then
        self.inst.player_classified.hasmomentum:set(hasmomentum)
    end
end

local function ondisable(self, disable)
    if self.inst.player_classified ~= nil then
        self.inst.player_classified.disable:set(disable)
    end
end

local function onexternalspeedadder(self, externalspeedadder)
    if self.inst.player_classified ~= nil then
        self.inst.player_classified.externalspeedadder:set(externalspeedadder)
    end
end

local function onexternalaccelerationadder(self, externalaccelerationadder)
    if self.inst.player_classified ~= nil then
        self.inst.player_classified.externalaccelerationadder:set(externalaccelerationadder)
    end
end

local function onexternalaccelerationmultiplier(self, externalaccelerationmultiplier)
    if self.inst.player_classified ~= nil then
        self.inst.player_classified.externalaccelerationmultiplier:set(externalaccelerationmultiplier)
    end
end

local function onexternaldecelerationadder(self, externaldecelerationadder)
    if self.inst.player_classified ~= nil then
        self.inst.player_classified.externaldecelerationadder:set(externaldecelerationadder)
    end
end

local function onexternaldecelerationmultiplier(self, externaldecelerationmultiplier)
    if self.inst.player_classified ~= nil then
        self.inst.player_classified.externaldecelerationmultiplier:set(externaldecelerationmultiplier)
    end
end

TAENV.AddComponentPostInit("locomotor", function(cmp)
    cmp._override_angles = {}
    cmp.override_angle = nil
    cmp.hasoverride_angle = false

    cmp._externalspeedadders = {}
    cmp.externalspeedadder = 0

    cmp.externalspeedadder_timer = {}
    cmp.externalspeedmultipliers_timer = {}

    cmp._externalaccelerationadders = {}
    cmp.externalaccelerationadder = 0

    cmp._externalaccelerationmultipliers = {}
    cmp.externalaccelerationmultiplier = 1

    cmp._externaldecelerationadders = {}
    cmp.externaldecelerationadder = 0

    cmp._externaldecelerationmultipliers = {}
    cmp.externaldecelerationmultiplier = 1

    cmp.hasmomentum = false

    cmp.disable = false

    cmp.acceleration = 6
    cmp.deceleration = 6
    cmp.currentSpeed = 0
    cmp.abruptdeceleration = 8
    cmp.abruptAngleThreshold = 120
    cmp.maxSpeed = 12
    cmp.slowing = false

    if TheWorld.ismastersim then
        local _GetSpeedMultiplier = cmp.GetSpeedMultiplier
        function cmp:GetSpeedMultiplier(...)
            local windmult = 1

            if TheWorld.state.hurricane and not (self.inst:HasTag("wind_immune") or self.inst:HasTag("playerghost")) and IsInIAClimate(self.inst) then
                local windangle = self.inst.Transform:GetRotation() -
                ((self:HasOverrideAngle() and self:GetOverrideAngle()) or TheWorld.state.gustangle)
                local windspeed = (self:HasOverrideAngle() and (TUNING.SAILSTICK_BONUSSPEEDMULT * TheWorld.state.gustspeed)) or
                TheWorld.state.gustspeed
                local windproofness = 1.0
                if not self.inst.components.sailor or not self.inst.components.sailor:IsSailing() then
                    if self.inst.components.inventory then
                        windproofness = 1.0 - self.inst.components.inventory:GetWindproofness()
                    end
                end
                local windfactor = TUNING.WIND_PUSH_MULTIPLIER * windproofness * windspeed *
                math.cos(windangle * DEGREES) + 1.0
                windmult = math.max(0.1, windfactor)
                -- if self.inst:HasTag("player") then
                -- print(string.format("Loco wind angle %4.2f, factor %4.2f (%4.2f), %s\n", windangle, windfactor, math.cos(windangle * DEGREES) + 1.0, self.inst.prefab))
                -- end
            end
            if self.inst.player_classified ~= nil then
                --TODO This would probably be a lot easier on the network if we just send the windproofness -M
                self.inst.player_classified.windspeedmult:set(windmult)
            end

            local floodmult = 1
            if TheWorld.components.flooding and not (self.inst:HasTag("flying") or self.inst:HasTag("flood_immune") or self.inst:HasTag("playerghost") or self.inst:HasTag("weregoose")) and TheWorld.components.flooding:OnFlood(self.inst.Transform:GetWorldPosition()) then
                floodmult = TUNING.FLOOD_SPEED_MULTIPLIER
            end

            return _GetSpeedMultiplier(self, ...) * windmult * floodmult
        end

        addsetter(cmp, "override_angle", onoverride_angle)
        addsetter(cmp, "hasoverride_angle", onhasoverride_angle)
        addsetter(cmp, "hasmomentum", onhasmomentum)
        addsetter(cmp, "disable", ondisable)
        addsetter(cmp, "externalspeedadder", onexternalspeedadder)
        addsetter(cmp, "externalaccelerationadder", onexternalaccelerationadder)
        addsetter(cmp, "externalaccelerationmultiplier", onexternalaccelerationmultiplier)
        addsetter(cmp, "externaldecelerationadder", onexternaldecelerationadder)
        addsetter(cmp, "externaldecelerationmultiplier", onexternaldecelerationmultiplier)
    else
        local _GetSpeedMultiplier = cmp.GetSpeedMultiplier
        function cmp:GetSpeedMultiplier(...)
            local windmult = self:GetWindMult()

            if windmult == nil then
                windmult = 1
                if TheWorld.state.hurricane and not (self.inst:HasTag("wind_immune") or self.inst:HasTag("playerghost")) and IsInIAClimate(self.inst) then
                    local windangle = self.inst.Transform:GetRotation() -
                    ((self:HasOverrideAngle() and self:GetOverrideAngle()) or TheWorld.state.gustangle)
                    local windspeed = (self:HasOverrideAngle() and (TUNING.SAILSTICK_BONUSSPEEDMULT * TheWorld.state.gustspeed)) or
                    TheWorld.state.gustspeed
                    local windproofness = 1.0
                    --Client does not have these components, but at least we can calculate the angle -M
                    -- if not self.inst.components.sailor or not self.inst.components.sailor:IsSailing() then
                    -- if self.inst.components.inventory then
                    -- windproofness = 1.0 - self.inst.components.inventory:GetWindproofness()
                    -- end
                    -- end
                    local windfactor = TUNING.WIND_PUSH_MULTIPLIER * windproofness * windspeed *
                    math.cos(windangle * DEGREES) + 1.0
                    windmult = math.max(0.1, windfactor)
                end
            end

            local floodmult = 1
            if TheWorld.components.flooding and not (self.inst:HasTag("flying") or self.inst:HasTag("flood_immune") or self.inst:HasTag("playerghost") or self.inst:HasTag("weregoose")) and TheWorld.components.flooding:OnFlood(self.inst.Transform:GetWorldPosition()) then
                floodmult = TUNING.FLOOD_SPEED_MULTIPLIER
            end

            return _GetSpeedMultiplier(self, ...) * windmult * floodmult
        end
    end
end)
