local Milker = Class(function(self, inst)
    self.inst = inst

    self.milkprefab = nil
end)

function Milker:Fill()
    if self.milkprefab == nil then
        return false
    end

    local milkitem = SpawnPrefab(self.milkprefab)
    if milkitem == nil then
        return false
    end

    local owner = self.inst.components.inventoryitem ~= nil and self.inst.components.inventoryitem:GetGrandOwner() or nil
    if owner ~= nil then
        local container = owner.components.inventory or owner.components.container
        local item = container:RemoveItem(self.inst, false) or self.inst
        item:Remove()
        container:GiveItem(milkitem, nil, owner:GetPosition())
    else
        milkitem.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
        local item =
            self.inst.components.stackable ~= nil and
            self.inst.components.stackable:IsStack() and
            self.inst.components.stackable:Get() or
            self.inst
        item:Remove()
    end
    return true
end

return Milker
