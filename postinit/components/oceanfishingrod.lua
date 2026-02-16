local Utils = require "tools/utils"
local OceanFishingRod = require "components/oceanfishingrod"

Utils.FnDecorator(OceanFishingRod, "_LaunchFishProjectile", function(self, fish)
    local inventoryitem = self.inst.components.inventoryitem
    local fisher = inventoryitem and inventoryitem:GetGrandOwner()
    if not fisher:HasTag("aquatic") then return end
    fish:DoTaskInTime(.25, function(inst)
        local newprefab = SpawnAt(inst.prefab .. "_inv", inst) or SpawnAt(inst.prefab .. "_land", inst)
        if newprefab then
            fisher.components.inventory:GiveItem(newprefab)
            inst:Remove()
        end        
    end)
end)