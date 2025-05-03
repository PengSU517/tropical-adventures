local Utils = require "tools/utils"
local OceanFishingRod = require "components/oceanfishingrod"

Utils.FnDecorator(OceanFishingRod, "_LaunchFishProjectile", function(self, fish)
    local inventoryitem = self.inst.components.inventoryitem
    local fisher = inventoryitem and inventoryitem:GetGrandOwner()
    if not fisher:HasTag("aquatic") then return end
    fish:DoTaskInTime(.25, function(inst)
        fisher.components.inventory:GiveItem(SpawnAt(inst.prefab .. "_inv", inst))
        inst:Remove()
    end)
end)