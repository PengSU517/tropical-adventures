local function Check(inst)
    if TUNING.fog and TheWorld.state.isfoggy then
        inst.components.foggroggy:Enable()
    else
        inst.components.foggroggy:Disable()
    end
end

local function onfoggroggylevel(self, foggroggylevel)
    print("Setfoggroggy in components")
    print(foggroggylevel)
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
    inst:WatchWorldState("isfoggy", Check)
    inst:DoTaskInTime(0, Check)
    -- inst:StartUpdatingComponent(self)
end, nil, {
    foggroggylevel = onfoggroggylevel,
})

function Foggroggy:ShouldBeClear()
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local hasequip = self.inv and self.inv:EquipHasTag("clearfog")
    return hasequip or not self.inst:AwareInHamletArea() or
        #TheSim:FindEntities(x, y, z, TUNING.FAN_RANGE, { "blows_air" }) > 0
end

function Foggroggy:HasVentingEquip()
    return self.should_clear or self.inv and self.inv:EquipHasTag("venting")
end

function Foggroggy:CanGroggy()
    return not self.has_venting_equip
end

function Foggroggy:OnUpdate(dt)
    self.should_clear = self:ShouldBeClear()
    self.has_venting_equip = self:HasVentingEquip()
    local foggyrate = math.min(1, TheWorld.state.fograte * 5)
    if self:CanGroggy() then
        self.foggroggylevel = foggyrate

        self.inst:AddTag("hamfogspeed")
    else
        self.inst:RemoveTag("hamfogspeed")

        if self.should_clear then
            self.foggroggylevel = 0
        else
            self.foggroggylevel = foggyrate * 0.5
        end
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
        self.inst.components.talker:Say(string.format(GetString(self.inst, "ANNOUNCE_TOO_HUMID"), " "))
    end
end

function Foggroggy:Disable()
    if self.enabled == true then
        self.foggroggylevel = 0
        self.inst:RemoveTag("hamfogspeed")
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
