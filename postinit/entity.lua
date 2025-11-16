AddGlobalClassPostConstruct("entityscript", "EntityScript", function(self)
    local tbl = Upvaluehelper.GetUpvalue(self.CollectActions, "COMPONENT_ACTIONS")
    if not Upvaluehelper.GetUpvalue(tbl.INVENTORY.equippable, "oldfn") then
        local oldfn = tbl.INVENTORY.equippable
        tbl.INVENTORY.equippable = function(inst, ...)
            if not inst:HasTag("boat") then oldfn(inst, ...) end
        end
    end
end)

local OldLoad = GLOBAL.Profile.Load
function GLOBAL.Profile:Load(fn)
    local initfn = Upvaluehelper.GetUpvalue(fn, "OnFilesLoaded", "OnUpdatePurchaseStateComplete", "DoResetAction", "DoGenerateWorld", "DoInitGame")
    Upvaluehelper.SetUpvalue(fn, function(savedata, profile)
        GLOBAL.global("currentworld")
        GLOBAL.currentworld = savedata.map.prefab
        if savedata.map.prefab == "forest" then
            local tbl = Upvaluehelper.GetUpvalue(initfn, "GroundTiles")

            Upvaluehelper.SetUpvalue(initfn, tbl, "GroundTiles")
        end
        return initfn(savedata, profile)
    end, "OnFilesLoaded", "OnUpdatePurchaseStateComplete", "DoResetAction", "DoGenerateWorld", "DoInitGame")
    return OldLoad(self, fn)
end
