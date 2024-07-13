--------------试试看
AddPrefabPostInitAny(function(inst)
    if inst.components.inventoryitem and inst.components.inventoryitem.atlasname --[[ and inst.caminho]] then
        if inst.components.inventoryitem.atlasname == "images/inventoryimages/hamletinventory.xml"
            or inst.components.inventoryitem.atlasname == "images/inventoryimages/volcanoinventory.xml" then
            inst.components.inventoryitem.atlasname = resolvefilepath(inst.components.inventoryitem.atlasname)
        end
    end

    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"
    -- inst.caminho = "images/inventoryimages/volcanoinventory.xml"
end)
