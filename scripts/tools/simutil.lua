local atlas_list = {
    sw_icons = resolvefilepath("images/inventoryimages/inventory_shipwrecked.xml"),
    ham_icons = resolvefilepath("images/inventoryimages/inventory_hamlet.xml"),
    rog_icons = resolvefilepath("images/inventoryimages/inventory_rog.xml"),
    swfood_icons = resolvefilepath("images/inventoryimages/cookpotfoods_sw.xml"),
    hamfood_icons = resolvefilepath("images/inventoryimages/cookpotfoods_ham.xml"),
    sw_map_icons = resolvefilepath("images/minimap/minimap_shipwrecked.xml"),
    ham_map_icons = resolvefilepath("images/minimap/minimap_hamlet.xml"),
    rog_map_icons = resolvefilepath("images/minimap/minimap_rog.xml"),
    sw_icons1 = resolvefilepath("images/inventoryimages/hamletinventory.xml"),
    ham_icons1 = resolvefilepath("images/inventoryimages/volcanoinventory.xml"),
    extension = resolvefilepath("images/inventoryimages/inventory_extension.xml"),
}




local old_GetInventoryItemAtlas_Internal = GetInventoryItemAtlas_Internal

function GetInventoryItemAtlas_Internal(imagename, no_fallback)
    ----inventoryimages3.xml 不知道在哪里，很奇怪，里面包含了海难哈姆的内容
    -- print "using new GetInventoryItemAtlas_Internal"

    -- print("IMG match ATL", imagename or "nil", atlasname or "nil")


    local rst = nil
    for i, v in pairs(atlas_list) do
        if TheSim:AtlasContains(v, imagename) then
            rst = v
            break
        end
    end

    if rst ~= nil then
        -- print("IMG match ATL defaullt", imagename or "nil", rst or "nil")
        return rst
    else
        local atlasname = old_GetInventoryItemAtlas_Internal(imagename, no_fallback)
        -- print("IMG match ATL new", imagename or "nil", atlasname or "nil")

        return atlasname
    end
end

-- local upvaluehelper = require("tools/upvaluehelper")
-- local inventoryItemAtlasLookup = upvaluehelper.Get(GetInventoryItemAtlas, "inventoryItemAtlasLookup")

-- function GetInventoryItemAtlas(imagename, no_fallback)
--     local atlas = inventoryItemAtlasLookup[imagename]

--     if atlas then
--         if atlas == sw_icons1 or atlas == ham_icons1 then
--             print("IMG match ATL cache", imagename or "nil", atlas or "nil")
--         end
--         return atlas
--     end

--     atlas = GetInventoryItemAtlas_Internal(imagename, no_fallback)

--     if atlas ~= nil then
--         inventoryItemAtlasLookup[imagename] = atlas
--     else
--         print("IMG match ATL cache miss", imagename or "nil")
--     end

--     return atlas
-- end


local old_GetInventoryItemAtlas = GetInventoryItemAtlas

function GetInventoryItemAtlas(imagename, no_fallback)
    local atlas = old_GetInventoryItemAtlas(imagename, no_fallback)

    -----------用来打印一些漏网之鱼----------
    if atlas then
        if atlas == atlas_list.sw_icons1 or atlas == atlas_list.ham_icons1 then
            print("IMG match ATL cache", imagename or "nil", atlas or "nil")
        end
        return atlas
    end
    return atlas
end
