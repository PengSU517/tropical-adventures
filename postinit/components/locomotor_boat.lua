-------------------------------Boat Speed by EvenMr----------------------------
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

local heavybonus = 0.35
local driftspeed = 2

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
        if inst.replica.inventory:IsHeavyLifting() then
            local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
            if item.replica.container and item.replica.container:GetItemInSlot(1) and
                item.replica.container:GetItemInSlot(1):HasTag("sail") then
                return val * 0.2
            else
                return 0
            end
        end
    end
    return math.min(val, 1.8)
end

--------------------这里控制水上的速度-------------------------

AddComponentPostInit("locomotor", function(self)
    local OldGetSpeedMultiplier = self.GetSpeedMultiplier
    function self:GetSpeedMultiplier()
        if (self.inst and self.inst:HasTag("aquatic") and self.inst:HasTag("player")) then
            return (getspeedbonus(self.inst) - 1) + OldGetSpeedMultiplier(self) ------乘算改为加算
        end
        return OldGetSpeedMultiplier(self)
    end

    local OldUpdate = self.OnUpdate
    function self:OnUpdate(dt)
        OldUpdate(self, dt)
        if self.inst:HasTag("aquatic") and self.inst:HasTag("player") and self.inst.replica.inventory
            and self.inst.replica.inventory:IsHeavyLifting() and not self.driftangle then
            local item = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
            if item.replica.container and item.replica.container:GetItemInSlot(1) and
                item.replica.container:GetItemInSlot(1):HasTag("sail") then
                if self.inst.Physics:GetMotorSpeed() > 0 then
                    local desired_speed = self.isrunning and self:RunSpeed() or self.walkspeed
                    local speed_mult = self:GetSpeedMultiplier()
                    if self.dest and self.dest:IsValid() then
                        local destpos_x, destpos_y, destpos_z = self.dest:GetPoint()
                        local mypos_x, mypos_y, mypos_z = self.inst.Transform:GetWorldPosition()
                        local dsq = GLOBAL.distsq(destpos_x, destpos_z, mypos_x, mypos_z)
                        if dsq <= .25 then
                            speed_mult = math.max(.33, math.sqrt(dsq))
                        end
                    end

                    self.inst.Physics:SetMotorVel(desired_speed * speed_mult * heavybonus, 0, 0)
                end
            else
                self.inst.Physics:SetMotorVel(0, 0, 0)
                self:Stop()
            end
        elseif self.driftangle and self.inst:HasTag("player") and self.inst:HasTag("aquatic") then
            local speed_mult = self:GetSpeedMultiplier()
            local desired_speed = self.isrunning and self:RunSpeed() or self.walkspeed
            if self.dest and self.dest:IsValid() then
                local destpos_x, destpos_y, destpos_z = self.dest:GetPoint()
                local mypos_x, mypos_y, mypos_z = self.inst.Transform:GetWorldPosition()
                local dsq = GLOBAL.distsq(destpos_x, destpos_z, mypos_x, mypos_z)
                if dsq <= .25 then
                    speed_mult = math.max(.33, math.sqrt(dsq))
                end
            end
            if not self.dest then
                desired_speed = 0
            end
            local angle = self.inst.Transform:GetRotation()
            local driftx = math.cos(math.rad(-self.driftangle + angle + 180)) * 1.5
            local drifty = math.sin(math.rad(-self.driftangle + angle + 180)) * 1.5

            local extramult = 1

            if self.inst.replica.inventory and self.inst.replica.inventory:IsHeavyLifting() then
                extramult = heavybonus
            end

            self.inst.Physics:SetMotorVel((desired_speed * speed_mult + driftx) * extramult, 0, drifty * extramult)
            if GLOBAL.StopUpdatingComponents[self] == self.inst then
                self:StartUpdatingInternal()
            end
        end
    end

    local OldStop = self.Stop
    function self:Stop(sgparam)
        OldStop(self, sgparam)
        if self.driftangle and self.inst:HasTag("aquatic") and self.inst:HasTag("player") and GLOBAL.StopUpdatingComponents[self] == self.inst then
            self:StartUpdatingInternal()
        end
    end
end)
