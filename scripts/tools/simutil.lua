------------没有应用，先留着

-- local simutil_old = require("simutil") ---由于没有显式返回这里的require会直接将定义的全局函数返回至env里， simutil_old是个boolen

-- if GetInventoryItemAtlas_Internal then
--     print("simutil_oldGetInventoryItemAtlas_Internal is not nil")
-- else
--     print("simutil_oldGetInventoryItemAtlas_Internal is nil")
-- end


local old_GetInventoryItemAtlas_Internal = GetInventoryItemAtlas_Internal


function GetInventoryItemAtlas_Internal(imagename, no_fallback)
    ----inventoryimages3.xml 不知道在哪里，很奇怪，里面包含了海难哈姆的内容
    -- print "using new GetInventoryItemAtlas_Internal"

    -- print("IMG match ATL", imagename or "nil", atlasname or "nil")

    local sw_icons = resolvefilepath("images/inventoryimages/inventory_shipwrecked.xml")
    local ham_icons = resolvefilepath("images/inventoryimages/inventory_hamlet.xml")
    local rog_icons = resolvefilepath("images/inventoryimages/inventory_rog.xml")
    local swfood_icons = resolvefilepath("images/inventoryimages/cookpotfoods_sw.xml")
    local hamfood_icons = resolvefilepath("images/inventoryimages/cookpotfoods_ham.xml")

    local sw_map_icons = resolvefilepath("images/minimap/minimap_shipwrecked.xml")
    local ham_map_icons = resolvefilepath("images/minimap/minimap_hamlet.xml")
    local rog_map_icons = resolvefilepath("images/minimap/minimap_rog.xml")

    local rst = TheSim:AtlasContains(swfood_icons, imagename) and swfood_icons
        or TheSim:AtlasContains(hamfood_icons, imagename) and hamfood_icons
        or TheSim:AtlasContains(sw_icons, imagename) and sw_icons
        or TheSim:AtlasContains(ham_icons, imagename) and ham_icons
        or TheSim:AtlasContains(rog_icons, imagename) and rog_icons

        or TheSim:AtlasContains(sw_map_icons, imagename) and sw_map_icons
        or TheSim:AtlasContains(ham_map_icons, imagename) and ham_map_icons
        or TheSim:AtlasContains(rog_map_icons, imagename) and rog_map_icons
        -- or TheSim:AtlasContains(creep_icons, imagename) and ham_icons
        -- or TheSim:AtlasContains(indi_icons, imagename) and ham_icons
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

MATCHED_IMAGE = {}
UNMATCHED_IMAGE = {}

local upvaluehelper = require("tools/upvaluehelper")
local inventoryItemAtlasLookup = upvaluehelper.Get(GetInventoryItemAtlas, "inventoryItemAtlasLookup")

function GetInventoryItemAtlas(imagename, no_fallback)
    local atlas = inventoryItemAtlasLookup[imagename]

    print("IMG match ATL cache", imagename or "nil", atlas or "nil")
    if atlas then
        return atlas
    end

    if MATCHED_IMAGE[imagename] then
        print("IMG match ATL cache miss one", imagename or "nil")
        table.insert(UNMATCHED_IMAGE, imagename)
    end

    atlas = GetInventoryItemAtlas_Internal(imagename, no_fallback)

    if atlas ~= nil then
        inventoryItemAtlasLookup[imagename] = atlas
        MATCHED_IMAGE[imagename] = true
        print("IMG match ATL cache hit", imagename or "nil", atlas or "nil")
    end

    if #UNMATCHED_IMAGE > 10 then
        print("IMG match ATL cache miss all", table.concat(UNMATCHED_IMAGE, ","))
    end

    return atlas
end
