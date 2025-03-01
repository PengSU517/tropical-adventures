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
