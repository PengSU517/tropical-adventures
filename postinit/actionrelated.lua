AddComponentPostInit(
    "deployable",
    function(self, inst)
        self.ForceDeploy = function(self, pt, deployer)
            -- if not self:CanDeploy(pt) then
            --  return
            -- end
            local prefab = self.inst.prefab
            if self.ondeploy ~= nil then
                self.ondeploy(self.inst, pt, deployer)
            end
            -- self.inst is removed during ondeploy
            deployer:PushEvent("deployitem", { prefab = prefab })
            return true
        end
    end
)

AddComponentPostInit("playeractionpicker", function(PlayerActionPicker)
    local GetRightClickActions = PlayerActionPicker.GetRightClickActions
    function PlayerActionPicker:GetRightClickActions(position, target, spellbook)
        local boat = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
        local acts = GetRightClickActions(self, position, target, spellbook)
        if act ~= nil and #acts <= 0 and boat then
            acts = self:GetPointActions(position, boat, true)
        end
        return acts
    end

    local GetLeftClickActions = PlayerActionPicker.GetLeftClickActions
    function PlayerActionPicker:GetLeftClickActions(position, target)
        local boat = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
        local acts = GetLeftClickActions(self, position, target)
        if act ~= nil and #acts <= 0 and boat and TheWorld.Map:IsPassableAtPoint(position:Get()) then
            acts = self:GetPointActions(position, boat, nil)
        end
        return acts
    end
end)


AddComponentPostInit("fueled", function(self)
    function self:CanAcceptFuelItem(item)
        if self.fueltype == "TAR" and item:HasTag("tar") then return true end
        return self.accepting and item and item.components.fuel and
            (item.components.fuel.fueltype == self.fueltype or item.components.fuel.fueltype == self.secondaryfueltype)
    end
end)
