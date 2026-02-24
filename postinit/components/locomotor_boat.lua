local speed_bonus = {
    raft_old = 5 / 6,
    lograft_old = 4 / 6,
    rowboat = 6 / 6,
    armouredboat = 6 / 6,
    cargoboat = 5 / 6,
    encrustedboat = 4 / 6,
    surfboard = 6.5 / 6,
    woodlegsboat = 6 / 6,
    corkboat = 4 / 6,
    -- more entries here
}

local sail_bonus = {
    sail = 1.2,
    clothsail = 1.3,
    snakeskinsail = 1.35,
    feathersail = 1.4,
    ironwind = 1.5,
    woodlegssail = 1.01,
    trawlnet = 0.8,
    malbatrossail = 1.5,
    -- more entries here
}

local function getspeedbonus(inst)
    local val = 1
    if inst.replica.inventory then
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
        if item then
            local bonus = speed_bonus[item.prefab] or 1
            if item.replica.container then
                local sail = item.replica.container:GetItemInSlot(1)
                local sailbonus = sail and sail_bonus[sail.prefab] or 1
                val = bonus * sailbonus
            else
                val = bonus
            end
        end
    end
    return math.max(math.min(val - 1, 1), 0)
end

--------------------这里控制水上的速度-------------------------

AddComponentPostInit("locomotor", function(self)
    local OldGetSpeedMultiplier = self.GetSpeedMultiplier
    function self:GetSpeedMultiplier()
        if (self.inst and self.inst:HasTag("aquatic") and self.inst:HasTag("player")) then
            return getspeedbonus(self.inst) + OldGetSpeedMultiplier(self) ------乘算改为加算
        end
        return OldGetSpeedMultiplier(self)
    end

    local OldStartHopping = self.StartHopping
    function self:StartHopping(x, z, target_platform)
        if self.inst:HasTag("aquatic") and self.inst.components.driver then
            self.inst.components.driver:BoatDetached(self.inst)
            self.inst:RemoveTag("aquatic")
        end
        OldStartHopping(self, x, z, target_platform)
    end
end)


AddComponentPostInit("oar", function(self, inst)
    inst:AddTag("oar") --科雷真抠门，桨连个自己的标签也没有
end)
