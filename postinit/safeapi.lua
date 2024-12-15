--是否会显著影响性能开销是个问题

local function MODULE_ERROR(module)
    print("API_ERROR:", module)
end

local _AddPrefabPostInit = AddPrefabPostInit

function AddPrefabPostInit(prefab, fn)
    _AddPrefabPostInit(prefab, function(inst)
        if not pcall(function() fn(inst) end) then return MODULE_ERROR(prefab or "unknown prefab") end
    end)
end

local _AddComponentPostInit = AddComponentPostInit

function AddComponentPostInit(component, fn)
    _AddComponentPostInit(component, function(self)
        if not pcall(function() fn(self) end) then return MODULE_ERROR(component or "unknown component") end
    end)
end
