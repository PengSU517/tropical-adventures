---@author: Runar 2025-05-13 21:31:51
---@version 20250525
---@usage: require("tools/loadutils")
-- function AddHotPrefab 游戏内动态添加热加载PrefabFile
-- function AddHotClass 游戏内动态添加热加载Klass
-- 被热加载的Klass需要在_ctor内被动态require,否则不生效
-- 热加载PrefabFile不会影响已有的Prefab,只有新的Prefab会受到影响
-- 此模块会导致内存泄漏,不要在任何长期存档中加载
local reloadsymbol = "01" -- 热加载此模块需更改此标记,才能区分是哪一版在起作用
local _g = _G or GLOBAL
setfenv(1, _g)

-- 写入静态热加载的PrefabFile
---@type table<string, string>
local HotPrefabFiles = {
    -- k:prefab v:filename
}
-- 写入静态热加载的Class
---@type table<string, boolean>
local HotClasses = {
    -- k:package v:true
}

local AUTO = false

local function l_print(str, ...)
    print(string.format(">> LoadUtils(%s): ", tostring(reloadsymbol)) .. string.format(str, ...))
end

local function getklassdesc(package)
    local base = string.match(package, "/") and string.match(package, "^[^/]*") or "klass"
    local klass = string.match(package, "[^/]*$")
    return base, klass
end

-----load commands-----
function l_autoremove(auto)
    AUTO = auto or not AUTO
    l_print("set auto as %s", tostring(AUTO))
end

function l_removeall()
    for k in pairs(HotPrefabFiles) do
        c_removeall(k)
    end
    l_print("remove all old hot prefabs")
end
----------------------

---GLOBAL overrides---
if not rawget(_g, "RAW_SPAWN") then
    rawset(_g, "RAW_SPAWN", SpawnPrefab)
end
function SpawnPrefab(prefab, ...)
    if HotPrefabFiles[prefab] then
        LoadPrefabFile("prefabs/" .. HotPrefabFiles[prefab])
        l_print("Reloaded PrefabFile \"%s\" by spawning \"%s\"", HotPrefabFiles[prefab], prefab)
        if AUTO then
            c_removeall(prefab)
        end
    end
    return RAW_SPAWN(prefab, ...)
end

if not rawget(_g, "RAW_REQUIRE") then
    rawset(_g, "RAW_REQUIRE", require)
end
function require(packagepath)
    if HotClasses[packagepath] and package.loaded[packagepath] then
        package.loaded[packagepath] = nil
        l_print("Reloaded %s %s", getklassdesc(packagepath))
    end
    return RAW_REQUIRE(packagepath)
end
----------------------

local function AddHotPrefab(prefab, prefabfile)
    prefabfile = prefabfile or prefab
    l_print("Added hot load Prefab %s(%s)", prefab, prefabfile)
    HotPrefabFiles[prefab] = prefabfile
end

local function AddHotClass(package)
    l_print("Added hot load %s %s", getklassdesc(package))
    HotClasses[package] = true
end

l_print("require \"loadutils\" (%s) ", tostring(reloadsymbol))

return {
    symbol = reloadsymbol,
    AddHotPrefab = AddHotPrefab,
    AddHotClass = AddHotClass,
}