---@author: Runar 2025-05-13 21:31:51
-- Usage: require("tools/loadutils")
-- function AddHotPrefab 游戏内动态添加热加载PrefabFile
-- function AddHotClass 游戏内动态添加热加载Klass
-- 被热加载的Klass需要在_ctor内被动态require,否则不生效
-- 热加载PrefabFile不会影响已有的Prefab,只有新的Prefab会受到影响

if GLOBAL ~= nil then return end
-- 写入静态热加载的PrefabFile
local HotPrefabFiles = {
    -- k:prefab v:filename
}
-- 写入静态热加载的Class
local HotClasses = {
    -- k:package v:true
}

local function t_print(str, ...)
    print("Tropical Adventures:" .. string.format(str, ...))
end

local function getklassdesc(package)
    local base = string.match(package, "/") and string.match(package, "^[^/]*") or "klass"
    local klass = string.match(package, "[^/]*$")
    return base, klass
end

local old_SpawnPrefab = SpawnPrefab
function SpawnPrefab(prefab, ...)
    if HotPrefabFiles[prefab] then
        LoadPrefabFile("prefabs/" .. HotPrefabFiles[prefab])
        t_print("Reloaded PrefabFile \"%s\"", HotPrefabFiles[prefab])
    end
    return old_SpawnPrefab(prefab, ...)
end

local old_require = require
function require(package)
    if HotClasses[package] and package.loaded[package] then
        package.loaded[package] = nil
        t_print("Reloaded %s %s", getklassdesc(package))
    end
    return old_require(package)
end

local function AddHotPrefab(prefab, prefabfile)
    prefabfile = prefabfile or prefab
    t_print("Added hot load Prefab %s(%s)", prefab, prefabfile)
    HotPrefabFiles[prefab] = prefabfile
end

local function AddHotClass(package)
    t_print("Added hot load %s %s", getklassdesc(package))
    HotClasses[package] = true
end

return {
    AddHotPrefab = AddHotPrefab,
    AddHotClass = AddHotClass,
}