------------没有应用，先留着

-- local simutil_old = require("simutil") ---由于没有显式返回这里的require会直接将定义的全局函数返回至env里， simutil_old是个boolen

-- if GetInventoryItemAtlas_Internal then
--     print("simutil_oldGetInventoryItemAtlas_Internal is not nil")
-- else
--     print("simutil_oldGetInventoryItemAtlas_Internal is nil")
-- end


local old_GetInventoryItemAtlas_Internal = GetInventoryItemAtlas_Internal

------------------------试试看--------------------
function GetInventoryItemAtlas_Internal(imagename, no_fallback)
    -- print "using new GetInventoryItemAtlas_Internal"
    local atlasname = old_GetInventoryItemAtlas_Internal(imagename, no_fallback)
    -- print("IMG match ATL", imagename or "nil", atlasname or "nil")
    if atlasname ~= nil then
        return atlasname
    else
        local sw_icons = resolvefilepath("images/inventoryimages/volcanoinventory.xml")
        local ham_icons = resolvefilepath("images/inventoryimages/hamletinventory.xml")
        -- local creep_icons = resolvefilepath("images/inventoryimages/creepindedeepinventory.xml") -- TA怎么会用creep的
        local swfood_icons = resolvefilepath("images/inventoryimages/cookpotfoods_sw.xml")
        local hamfood_icons = resolvefilepath("images/inventoryimages/cookpotfoods_ham.xml")


        -- local swfood_icons = resolvefilepath("images/inventoryimages/creepindedeepinventory.xml")
        -- local indi_icons = resolvefilepath("images/" .. imagename .. ".xml") --为了兼容一些其他mod 但怎么解决路径下没有文件的问题
        --porto_armouredboat 似乎不在图集里

        return TheSim:AtlasContains(swfood_icons, imagename) and swfood_icons
            or TheSim:AtlasContains(hamfood_icons, imagename) and hamfood_icons
            or TheSim:AtlasContains(sw_icons, imagename) and sw_icons
            or TheSim:AtlasContains(ham_icons, imagename) and ham_icons
            -- or TheSim:AtlasContains(creep_icons, imagename) and ham_icons
            -- or TheSim:AtlasContains(indi_icons, imagename) and ham_icons
            or nil
    end
end
