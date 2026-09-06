local function ontempchange(iscooldown)
    return function(inst)
        local current = inst.components.temperature.current
        if inst.components.inventoryitem == nil then return end
        local owner = inst.components.inventoryitem:GetContainer()
        local slot = owner and owner:GetItemSlot(inst)
        local perishpercent = inst.components.perishable and inst.components.perishable:GetPercent()
        local stacksize = inst.components.stackable and inst.components.stackable.stacksize
        local tea = iscooldown and ReplacePrefab(inst, string.gsub(inst.prefab, "^icedtea", "tea"))
            or ReplacePrefab(inst, string.gsub(inst.prefab, "^tea", "icedtea"))
        if tea ~= nil then
            if owner then
                owner:GiveItem(tea, slot, owner.inst:GetPosition())
            end
            if perishpercent and tea.components.perishable then
                tea.components.perishable:SetPercent(perishpercent)
            end
            if stacksize and tea.components.stackable then
                tea.components.stackable:SetStackSize(stacksize)
            end
            if tea.components.temperature then
                tea.components.temperature:SetTemperature(current)
            end
        end
    end
end
local old_Prefab = Prefab
GLOBAL.Prefab = Class(old_Prefab, function(self, prefab, ...)
    old_Prefab._ctor(self, prefab, ...)
    if prefab then
        if string.match(prefab, "^icedtea") then
            AddPrefabPostInit(prefab, function(inst)
                if inst.components.edible ~= nil then
                    inst:AddComponent("temperature")
                    inst.components.temperature:SetTemperature(-10)
                    inst.components.temperature.overheattemp = 20
                    inst:ListenForEvent("startoverheating", ontempchange(true))
                end
            end)
        elseif string.match(prefab, "^tea") then
            AddPrefabPostInit(prefab, function(inst)
                if inst.components.edible ~= nil then
                    inst:AddComponent("temperature")
                    inst.components.temperature:SetTemperature(80)
                    inst:ListenForEvent("startfreezing", ontempchange(false))
                end
            end)
        end
    end
end)
