local function Check(inst)
    if TUNING.fog and TheWorld.state.isfoggy then
        inst.components.foggroggy:Enable()
    else
        inst.components.foggroggy:Disable()
    end
end

local function onfoggroggylevel(self, foggroggylevel)
    -- print("Setfoggroggy in components")
    -- print(foggroggylevel)
    self.inst.replica.foggroggy:Setfoggroggy(foggroggylevel)
end

--- 哈姆雷特雾气
local Foggroggy = Class(function(self, inst)
    self.inst              = inst
    self.inv               = self.inst.components.inventory
    self.enabled           = false
    self.groggy_bcz_foggy  = false
    self.should_clear      = false
    self.has_venting_equip = false
    self.foggroggylevel    = 0
    self.loco              = self.inst.components.locomotor
    inst:WatchWorldState("isfoggy", Check)
    inst:DoTaskInTime(0, Check)
    -- inst:StartUpdatingComponent(self)
end, nil, {
    foggroggylevel = onfoggroggylevel,
})

function Foggroggy:ShouldBeClear()
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local hasequip = self.inv and self.inv:EquipHasTag("clearfog")
    return hasequip or self.inst:IsInHamRoom() or not self.inst:AwareInHamletArea() or
        #TheSim:FindEntities(x, y, z, TUNING.FAN_RANGE, { "blows_air" }) > 0
end

function Foggroggy:HasVentingEquip()
    return self.should_clear or self.inv and self.inv:EquipHasTag("venting")
end

function Foggroggy:CanGroggy()
    return not self.has_venting_equip and not self.should_clear
end

function Foggroggy:OnUpdate(dt)
    self.should_clear = self:ShouldBeClear()
    self.has_venting_equip = self:HasVentingEquip()
    local foggyrate = math.clamp(TheWorld.state.fograte * 5, 0, 0.7)


    if self.should_clear then
        self.foggroggylevel = 0
    else
        if self.has_venting_equip then
            self.foggroggylevel = foggyrate * 0.5
        else
            self.foggroggylevel = foggyrate
            if foggyrate > 0.5 then
                if not self.inst:HasTag("groggy") then
                    self.inst:AddTag("groggy")
                    self.groggy_bcz_foggy = true
                end
                self.loco:SetExternalSpeedMultiplier(self.inst, "hamfogspeed",
                    1 - foggyrate)
                return
            end
        end
    end
    if self.groggy_bcz_foggy and self.inst:HasTag("groggy") then
        self.inst:RemoveTag("groggy")
        self.groggy_bcz_foggy = false
        self.loco:RemoveExternalSpeedMultiplier(self.inst, "hamfogspeed")
    end
end

Foggroggy.LongUpdate = Foggroggy.OnUpdate

function Foggroggy:OnSave()
    local data = {}
    local references = {}
    data.groggy_bcz_foggy = self.groggy_bcz_foggy
    return data, references
end

function Foggroggy:OnLoad(data, newents)
    if data then
        if data.groggy_bcz_foggy then
            self.groggy_bcz_foggy = data.groggy_bcz_foggy
        end
    end
end

function Foggroggy:Enable()
    self.enabled = true
    self.inst:StartUpdatingComponent(self)
    if self.inst.components.talker and not self.inst.components.health:IsDead() then
        -- 修复模组角色未定义 ANNOUNCE_TOO_HUMID 时, GetString 返回 nil 导致 format 报错的 bug
        -- NOTE: 测试时, 这段代码会导致长达几秒钟的断线加载, 不能确定是否是普遍情况, 没有找到原因
        local s = GetString(self.inst, "ANNOUNCE_TOO_HUMID")
        if s == nil then
            local idx = math.random(#STRINGS.CHARACTERS.GENERIC.ANNOUNCE_TOO_HUMID)
            s = STRINGS.CHARACTERS.GENERIC.ANNOUNCE_TOO_HUMID[idx]
        end
        self.inst.components.talker:Say(string.format(s, " "))
    end
end

function Foggroggy:Disable()
    if self.enabled == true then
        self.foggroggylevel = 0
        self.inst:StopUpdatingComponent(self)
        self.enabled = false
        if self.inst.components.talker and not self.inst.components.health:IsDead() then
            self.inst.components.talker:Say(GetString(self.inst, "ANNOUNCE_DEHUMID"))
        end
    end
end

function Foggroggy:OnRemoveEntity()
    self:Disable()
    self:StopWatchingWorldState("isfoggy", Check)
end

return Foggroggy
