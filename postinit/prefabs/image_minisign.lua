AddPrefabPostInitAny(function(inst)
    if inst.components.inventoryitem and inst.components.inventoryitem.atlasname then
        inst.components.inventoryitem.atlasname = nil
    end
end)
