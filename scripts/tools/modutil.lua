-- local Utils = require("tools/utils")

--pcall是否会显著影响性能开销是个问题
local function MODULE_ERROR(module)
    print("API_ERROR:", module)
end

function GetModEnv(modname)
    for k, mod_name in pairs(ModManager:GetEnabledModNames()) do
        if mod_name == modname then
            local mod = ModManager:GetMod(mod_name)
            return mod.env
        end
    end
end

--- import files outside the script folder or even from other mods
function Modrequire(modulename, modname, newenv)
    local rootpath
    local env = env
    if modname ~= nil then
        env = GetModEnv(modname)
    end
    rootpath = env.MODROOT
    modulename = string.gsub(modulename, "%.lua$", "")
    print("modimport (strings file): " .. rootpath .. modulename .. ".lua")
    local result = kleiloadlua(rootpath .. modulename .. ".lua")
    if result == nil then
        print("Error in custom import: Stringsfile " .. modulename .. " not found!")
    elseif type(result) == "string" then
        print("Error in custom import: importing/" .. modulename .. "!\n" .. result)
    else
        setfenv(result, newenv or env) -- in case we use mod data
        return result()
    end
end

-- local _AddPlayerPostInit = AddPlayerPostInit
-- -- local initprint = Utils.FindUpvalue(AddPlayerPostInit, "initprint")
-- AddPlayerPostInit = function(fn)
--     -- if initprint then initprint("AddPlayerPostInit_Overrided") end
--     if postinitfns.ComponentPostInit["playervision"] == nil then
--         postinitfns.ComponentPostInit["playervision"] = {}
--     end
--     table.insert(postinitfns.ComponentPostInit["playervision"], function(self)
--         if not pcall(fn, self and self.inst) then return MODULE_ERROR("player") end
--     end)
-- end

local _AddPrefabPostInit = AddPrefabPostInit
function AddPrefabPostInit(prefab, fn)
    _AddPrefabPostInit(prefab, function(...)
        if not pcall(fn, ...) then return MODULE_ERROR(prefab or "unknown prefab") end
    end)
end

local _AddComponentPostInit = AddComponentPostInit
function AddComponentPostInit(component, fn)
    _AddComponentPostInit(component, function(...)
        if not pcall(fn, ...) then return MODULE_ERROR(component or "unknown component") end
    end)
end

-- local _AddClassPostConstruct = AddClassPostConstruct
-- function AddClassPostConstruct(clas, fn)
--     _AddClassPostConstruct(clas, function(...)
--         if not pcall(fn, ...) then return MODULE_ERROR(clas or "unknown class") end
--     end)
-- end
