local sw_icons = resolvefilepath("images/inventoryimages/inventory_shipwrecked.xml")
local ham_icons = resolvefilepath("images/inventoryimages/inventory_hamlet.xml")
local rog_icons = resolvefilepath("images/inventoryimages/inventory_rog.xml")
local swfood_icons = resolvefilepath("images/inventoryimages/cookpotfoods_sw.xml")
local hamfood_icons = resolvefilepath("images/inventoryimages/cookpotfoods_ham.xml")

local sw_map_icons = resolvefilepath("images/minimap/minimap_shipwrecked.xml")
local ham_map_icons = resolvefilepath("images/minimap/minimap_hamlet.xml")
local rog_map_icons = resolvefilepath("images/minimap/minimap_rog.xml")

local sw_icons1 = resolvefilepath("images/inventoryimages/hamletinventory.xml")
local ham_icons1 = resolvefilepath("images/inventoryimages/volcanoinventory.xml")


local old_GetInventoryItemAtlas_Internal = GetInventoryItemAtlas_Internal

function GetInventoryItemAtlas_Internal(imagename, no_fallback)
    ----inventoryimages3.xml 不知道在哪里，很奇怪，里面包含了海难哈姆的内容
    -- print "using new GetInventoryItemAtlas_Internal"

    -- print("IMG match ATL", imagename or "nil", atlasname or "nil")



    local rst = TheSim:AtlasContains(swfood_icons, imagename) and swfood_icons
        or TheSim:AtlasContains(hamfood_icons, imagename) and hamfood_icons
        or TheSim:AtlasContains(sw_icons, imagename) and sw_icons
        or TheSim:AtlasContains(ham_icons, imagename) and ham_icons
        or TheSim:AtlasContains(rog_icons, imagename) and rog_icons

        or TheSim:AtlasContains(sw_map_icons, imagename) and sw_map_icons
        or TheSim:AtlasContains(ham_map_icons, imagename) and ham_map_icons
        or TheSim:AtlasContains(rog_map_icons, imagename) and rog_map_icons
        or TheSim:AtlasContains(sw_icons1, imagename) and sw_icons1
        or TheSim:AtlasContains(ham_icons1, imagename) and ham_icons1
        or nil
    if rst ~= nil then
        -- print("IMG match ATL defaullt", imagename or "nil", rst or "nil")
        return rst
    else
        local atlasname = old_GetInventoryItemAtlas_Internal(imagename, no_fallback)
        -- print("IMG match ATL new", imagename or "nil", atlasname or "nil")

        return atlasname
    end
end

local upvaluehelper = require("tools/upvaluehelper")
local inventoryItemAtlasLookup = upvaluehelper.Get(GetInventoryItemAtlas, "inventoryItemAtlasLookup")

function GetInventoryItemAtlas(imagename, no_fallback)
    local atlas = inventoryItemAtlasLookup[imagename]

    if atlas then
        if atlas == sw_icons1 or atlas == ham_icons1 then
            print("IMG match ATL cache", imagename or "nil", atlas or "nil")
        end
        return atlas
    end

    atlas = GetInventoryItemAtlas_Internal(imagename, no_fallback)

    if atlas ~= nil then
        inventoryItemAtlasLookup[imagename] = atlas
    else
        print("IMG match ATL cache miss", imagename or "nil")
    end

    return atlas
end
