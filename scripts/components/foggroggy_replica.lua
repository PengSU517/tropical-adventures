local function OnFoggroggylevelDirty(inst)
    local foggroggylevel = inst.replica.foggroggy._foggroggylevel:value() or 0
    -- print("foggroggylevel is dirty")
    -- print(foggroggylevel)
    inst:PushEvent("updatefoggroggy", { foggroggylevel = foggroggylevel })
end

local Foggroggy = Class(function(self, inst)
    self.inst = inst

    self._foggroggylevel = net_float(inst.GUID, "foggroggy.foggroggylevel", "foggroggyleveldirty")

    if not TheNet:IsDedicated() then
        inst:ListenForEvent("foggroggyleveldirty", OnFoggroggylevelDirty)
    end
end)

function Foggroggy:Setfoggroggy(foggroggy)
    print("set froggy in replica")
    print(foggroggy)
    self._foggroggylevel:set(foggroggy)
end

function Foggroggy:Getfoggroggy()
    return self._foggroggylevel:value()
end

function Foggroggy:OnRemoveEntity()
    if not TheNet:IsDedicated() then
        self.inst:RemoveEventCallback("foggroggyleveldirty", OnFoggroggylevelDirty)
    end
end

return Foggroggy
