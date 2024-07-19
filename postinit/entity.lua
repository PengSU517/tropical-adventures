-----------------------------Thanks EvenMr for this code --------TEXTURA IMPASSABLE------------------------------------------
local function getval(fn, path)
    local val = fn
    for entry in path:gmatch("[^%.]+") do
        local i = 1
        while true do
            local name, value = GLOBAL.debug.getupvalue(val, i)
            if name == entry then
                val = value
                break
            elseif name == nil then
                return
            end
            i = i + 1
        end
    end
    return val
end

local function setval(fn, path, new)
    local val = fn
    local prev = nil
    local i
    for entry in path:gmatch("[^%.]+") do
        i = 1
        prev = val
        while true do
            local name, value = GLOBAL.debug.getupvalue(val, i)
            if name == entry then
                val = value
                break
            elseif name == nil then
                return
            end
            i = i + 1
        end
    end
    GLOBAL.debug.setupvalue(prev, i, new)
end

AddGlobalClassPostConstruct("entityscript", "EntityScript", function(self)
    local tbl = getval(self.CollectActions, "COMPONENT_ACTIONS")
    if not getval(tbl.INVENTORY.equippable, "oldfn") then
        local oldfn = tbl.INVENTORY.equippable
        tbl.INVENTORY.equippable = function(inst, ...)
            if not inst:HasTag("boat") then oldfn(inst, ...) end
        end
    end
end)

local hackpath = "OnFilesLoaded.OnUpdatePurchaseStateComplete.DoResetAction.DoGenerateWorld.DoInitGame"
local OldLoad = GLOBAL.Profile.Load
function GLOBAL.Profile:Load(fn)
    local initfn = getval(fn, hackpath)
    setval(fn, hackpath, function(savedata, profile)
        GLOBAL.global("currentworld")
        GLOBAL.currentworld = savedata.map.prefab
        if savedata.map.prefab == "forest" then
            local tbl = getval(initfn, "GroundTiles")

            setval(initfn, "GroundTiles", tbl)
        end
        return initfn(savedata, profile)
    end)
    return OldLoad(self, fn)
end
