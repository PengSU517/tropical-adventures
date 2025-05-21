local Utils = require "tools/utils"
AddPrefabPostInit("inventory_classified", function(inst)
    Utils.FnDecorator(inst, "GetOverflowContainer", nil, function(rets, inst)
        if inst.ignoreoverflow then
            return
        end
        if rets[1] ~= nil and rets[1]:IsFull() ~= true then
            return rets
        end
        local barco = inst:GetEquippedItem(EQUIPSLOTS.BARCO)
        return barco ~= nil and { barco.replica.container } or rets
    end)
end)
