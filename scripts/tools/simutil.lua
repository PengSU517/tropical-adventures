local atlas_list = { -----有序表，需要有一定的优先级
    [1] = "images/inventoryimages/cookpotfoods_sw.xml",
    [2] = "images/inventoryimages/cookpotfoods_ham.xml",
    [3] = "images/inventoryimages/inventory_shipwrecked.xml",
    [4] = "images/inventoryimages/inventory_hamlet.xml",
    [5] = "images/inventoryimages/inventory_extension.xml",
    -- [6] = "images/hud/customization_shipwrecked.xml",
    -- [7] = "images/hud/customization_porkland.xml",
    [6] = "images/inventoryimages/pigmancity.xml",
}



local old_GetInventoryItemAtlas_Internal = GetInventoryItemAtlas_Internal

function GetInventoryItemAtlas_Internal(imagename, no_fallback)
    ----inventoryimages3.xml 不知道在哪里，很奇怪，里面包含了海难哈姆的内容
    local rst = nil
    for i, v in ipairs(atlas_list) do
        local path = resolvefilepath( v )
        if TheSim:AtlasContains(path, imagename) then
            rst = path
            break
        end
    end

    if rst ~= nil then
        return rst
    else
        local atlasname = old_GetInventoryItemAtlas_Internal(imagename, no_fallback)
        return atlasname
    end
end

local old_GetInventoryItemAtlas = GetInventoryItemAtlas

function GetInventoryItemAtlas(imagename, no_fallback)
    local atlas = old_GetInventoryItemAtlas(imagename, no_fallback)
    -----------用来打印一些漏网之鱼----------
    if not atlas then print("IMG without ATL !!!", imagename or "nil") end
    return atlas
end
