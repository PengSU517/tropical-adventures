--------------------------------indicador de veneno by EvenMr-----------------------------------------
local function preventpick(cmp)
    local oldfn = cmp.TakeActiveItemFromEquipSlot
    function cmp:TakeActiveItemFromEquipSlot(eslot)
        local item = self:GetEquippedItem(eslot)
        if item and item:HasTag("boat") then return end
        oldfn(self, eslot)
    end

    function cmp:IsInsulated() -- from electricity, not temperature
        for k, v in pairs(self.equipslots) do
            if v and v.components.equippable:IsInsulated() then
                return true
            end
        end
        if self.isexternallyinsulated then
            return self.isexternallyinsulated:Get()
        end
        return false
    end
end
AddComponentPostInit("inventory", preventpick)

local function preventpickclassified(cmp)
    local oldfn = cmp.TakeActiveItemFromEquipSlot
    function cmp:TakeActiveItemFromEquipSlot(eslot)
        local item = self:GetEquippedItem(eslot)
        if item and item:HasTag("boat") then return end
        oldfn(self, eslot)
    end
end


AddPrefabPostInit("inventory_classified", preventpickclassified)
