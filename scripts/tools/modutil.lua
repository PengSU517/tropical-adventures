-- local moddir = KnownModIndex:GetModsToLoad(true)
-- local enablemods = {}

-- for k, dir in pairs(moddir) do
--     local info = KnownModIndex:GetModInfo(dir)
--     local name = info and info.name or "unknow"
--     enablemods[dir] = name
-- end
-- -- MOD是否开启
-- function IsModEnabled(name)
--     for k, v in pairs(enablemods) do
--         if v and (k:match(name) or v:match(name)) then return true end
--     end
--     return false
-- end

--- func desc
-- ---@param modname string
-- function GetModEnv(modname)
--     for i, name in pairs(GLOBAL.ModManager.modnames) do
--         if name == modname then
--             return GLOBAL.ModManager.modnames[i]
--         end
--     end
-- end


---@param modname string
function GetModEnv(modname)
    for k, mod_name in pairs(ModManager:GetEnabledModNames()) do
        if mod_name == modname then
            local mod = ModManager:GetMod(mod_name)
            return mod.env
        end
    end
end

--- import files outside the script folder or from other mods
---
function Modrequire(modulename, modname, newenv)
    local rootpath
    if modname == nil then
        rootpath = env.MODROOT
    else
        rootpath = GetModEnv(modname).MODROOT
    end
    modulename = string.gsub(modulename, "%.lua$", "")
    print("modimport (strings file): " .. rootpath .. "languages/" .. modulename .. ".lua")
    local result = kleiloadlua(rootpath .. "languages/" .. modulename .. ".lua")
    if result == nil then
        print("Error in custom import: Stringsfile " .. "languages/" .. modulename .. " not found!")
    elseif type(result) == "string" then
        print("Error in custom import: importing languages/" .. modulename .. "!\n" .. result)
    else
        setfenv(result, newenv or GLOBAL) -- in case we use mod data
        return result()
    end
end

---这个函数在modmain运行正常，modworldgenmain不行，原因未知
function ModGetLevelDataOverride()
    print("TA Mod Loading Custom Presets")


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

-- local leveldata = ModGetLevelDataOverride()

-- for i, v in pairs(leveldata.overrides) do
--     print("TA Mod Loading Custom Presets Manager: ")
--     print(i or "nil")
--     print(v or "nil")
-- end
