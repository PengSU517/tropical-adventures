REGION_NAMES = { "forest", "cave", "shipwrecked", "volcano", "hamlet" }
REGIONS = table.invert(REGION_NAMES)


local function onregion(self, region, _region)
    --print("RegionAware:onregion11111111", region, _region)
    if self.inst.player_classified ~= nil then
        self.inst.player_classified._region:set(region or REGIONS.forest)
    end
    if _region then
        self.inst:RemoveTag("region_" .. REGION_NAMES[_region])
    end
    if region then
        self.inst:AddTag("region_" .. REGION_NAMES[region])
    end
end

local RegionAware = Class(function(self, inst)
        self.inst = inst
        self.region = nil
        self.period = 10
        self.timetonextperiod = 0
        self.regionpos = nil
        self.start_new_period = false

        if not inst.components.areaaware then ----基于areaaware组件
            inst:AddComponent("areaaware")
        end

        self.areaaware = inst.components.areaaware

        inst:StartUpdatingComponent(self)

        -- inst:DoTaskInTime(0, function() self:GetRegion() end)
    end,
    nil,
    {
        region = onregion,
    })

function RegionAware:OnUpdate(dt)
    if self.timetonextperiod > 0 then
        self.timetonextperiod = self.timetonextperiod - dt
    else
        -- print("RegionAware:OnUpdate")
        self:GetRegion()
        if self.start_new_period then
            self.timetonextperiod = self.period
            self.start_new_period = false
        end
    end
end

function RegionAware:GetRegionFromArea()
    if TheWorld:HasTag("cave") then
        return REGIONS.cave
    elseif self.inst:IsInHamRoom() then
        return
    else
        if not self.areaaware then return end
        for i, tag in pairs(REGION_NAMES) do
            if self.areaaware:CurrentlyInTag(tag) then
                return REGIONS[tag]
            end
        end
    end

    return REGIONS.forest
end

function RegionAware:GetRegion(forceupdate)
    local pt = self.inst:GetPosition()
    if forceupdate or not self.regionpos or pt:Dist(self.regionpos) > 8 then
        local oldregion = self.region
        local newregion = self:GetRegionFromArea()

        print("Region changed from", oldregion or "nil", "to", newregion or "nil")
        if newregion then
            self.regionpos = pt
            if newregion ~= oldregion then
                self.region = newregion

                -- print("region change server")
                -- print(self.region)
                self.inst:PushEvent("regionchange", { region = self.region, oldregion = oldregion })
                self.start_new_period = true
            end
        end
    end

    -- --print("RegionAware:GetRegion", self.region or "nil")
    return self.region
end

function RegionAware:IsInRegion(region, forceupdate)
    if not self.region or forceupdate then
        self:GetRegion(forceupdate)
    end
    return REGION_NAMES[self.region] == region
end

--convert region to string, and then back on save, incase the ordering changes.
function RegionAware:OnSave()
    local data = {}
    if self.region then
        data.region = REGION_NAMES[self.region]
    end
    if self.regionpos then
        data.regionpos = { x = self.regionpos.x, y = self.regionpos.y, z = self.regionpos.z }
    end
    if next(data) then
        return data
    end
end

function RegionAware:OnLoad(data, refs)
    if data.region then
        self.region = REGIONS[data.region]
    end
    if data.regionpos then
        self.regionpos = Vector3(data.regionpos.x, data.regionpos.y, data.regionpos.z)
    end
    self.inst:PushEvent("regionchange", { region = self.region })
end

function RegionAware:GetDebugString()
    if self.region or self.regionpos then
        return (REGION_NAMES[self.region or 0] or "<nil>") ..
            " region, last test pos: " .. tostring(self.regionpos or "<nil>")
    end
end

return RegionAware
