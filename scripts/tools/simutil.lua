local atlas_list = { -----有序表，需要有一定的优先级
    [1] = "cookpotfoods_sw",
    [2] = "cookpotfoods_ham",
    [3] = "inventory_shipwrecked",
    [4] = "inventory_hamlet",
    [5] = "inventory_extension",
}




local old_GetInventoryItemAtlas_Internal = GetInventoryItemAtlas_Internal

function GetInventoryItemAtlas_Internal(imagename, no_fallback)
    ----inventoryimages3.xml 不知道在哪里，很奇怪，里面包含了海难哈姆的内容
    local rst = nil
    for i, v in ipairs(atlas_list) do
        local path = resolvefilepath("images/inventoryimages/" .. v .. ".xml")
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

-- -- local upvaluehelper = require("tools/upvaluehelper")
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
    if not atlas then print("IMG without ATL !!!", imagename or "nil") end
    return atlas
end

---这个函数在modmain运行正常，thesim只在modmain存在
function ModGetLevelDataOverride()
    print("TA Mod Loading Custom Presets Manager33333")


    local filename = "../leveldataoverride.lua"
    local success, savedata

    local shardGameIndex = ShardGameIndex
    if not shardGameIndex then
        require("shardindex")
        shardGameIndex = ShardIndex()
        shardGameIndex:Load()
    end

    local function onload(load_success, str)
        if load_success == true then
            success, savedata = RunInSandboxSafe(str)
            if success and string.len(str) > 0 then
                print("TA Mod Found a level data override file with these contents:")
                if savedata ~= nil then
                    print("TA Mod Loaded and applied level data override from " .. filename)
                    return
                end
            else
                print("ERROR: Failed to load " .. filename)
            end
        end
        print("Not applying level data overrides.")
    end

    local slot = shardGameIndex:GetSlot()
    local shard = shardGameIndex:GetShard()
    local session_id = shardGameIndex:GetSession()

    if session_id ~= nil then ---只有服务器需要这个
        TheSim:GetPersistentStringInClusterSlot(slot, shard, filename, onload)
    else
        TheSim:GetPersistentString(filename, onload)
    end

    return savedata
end
