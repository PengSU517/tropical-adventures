local REGION_NAMES = REGION_NAMES
local REGIONS = REGIONS

local function onregion(self, region, _region)
    -- print("REGION CHANGED TO ", REGION_NAMES[self.region])

    -- self.inst:DoTaskInTime(0, function(inst)
    -------这里必须延迟足够的时间，否则在世界刚加载时，客机接收不到这次推送，
    ----------但这又会造成延迟，所以还是算了
    if self.inst.player_classified ~= nil then
        -- print("change classified")
        self.inst.player_classified._region:set(region or REGIONS.forest)
    end
    -- end)


    if _region then
        self.inst:RemoveTag("region_" .. REGION_NAMES[_region])
    end
    if region then
        self.inst:AddTag("region_" .. REGION_NAMES[region])
    end


    self.inst:PushEvent("regionchange", { region = region, oldregion = _region })
    ----------------这里在 加载完毕后会发送个事件，所以监听这个时间的组件们可以不用初始化
end

local RegionAware = Class(function(self, inst)
        self.inst = inst
        self.region = nil
        self.period = 10
        self.timetonextperiod = 0
        self.regionpos = nil

        if not inst.components.areaaware then ----基于areaaware组件
            inst:AddComponent("areaaware")
        end

        self.areaaware = inst.components.areaaware

        inst:DoTaskInTime(0, function(inst) self:GetRegion(true) end)
        inst:ListenForEvent("changearea", function(inst, data) self:GetRegion() end)
    end,
    nil,
    {
        region = onregion,
    })

function RegionAware:OnUpdate(dt)
    if self.timetonextperiod > 0 then
        self.timetonextperiod = self.timetonextperiod - dt
    else
        self.inst:StopUpdatingComponent(self)
    end
end

function RegionAware:GetRegionFromArea()
    if self.inst:IsInWorld() then
        for i = 1, (#REGION_NAMES - 1) do
            local tag = REGION_NAMES[i]
            if self.areaaware:CurrentlyInTag(tag) then
                return REGIONS[tag]
            end
        end
        return REGIONS.forest
    end
end

function RegionAware:GetRegion(force)
    local pt = self.inst:GetPosition()

    if self.timetonextperiod <= 0 or pt:Dist(self.regionpos) > 50 or force then
        local oldregion = self.region
        local newregion = self:GetRegionFromArea()

        -- print("Region changed from", oldregion or "nil", "to", newregion or "nil")
        if newregion then
            self.regionpos = pt
            if newregion ~= oldregion then
                self.region = newregion
            end
            self.timetonextperiod = self.period
            self.inst:StartUpdatingComponent(self)
        end
    end


    -- --print("RegionAware:GetRegion", self.region or "nil")
    return self.region
end

function RegionAware:IsInRegion(regionname)
    if not self.region then
        self:GetRegion()
    end
    return REGIONS[self.region] == regionname
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
    -- self.inst:PushEvent("regionchange", { region = self.region })
end

function RegionAware:GetDebugString()
    if self.region or self.regionpos then
        return (REGION_NAMES[self.region or 0] or "<nil>") ..
            " region, last test pos: " .. tostring(self.regionpos or "<nil>")
    end
end

return RegionAware
