---@author: Runar 2025-04-30 09:50:48
---v1.1
local Immovables = {}
local Utils = require "tools/utils"
Utils.FnDecorator(Physics, "SetVel", function(p)
    if Immovables[p] ~= nil then
        return nil, true
    end
end)
Utils.FnDecorator(Physics, "Teleport", function(p)
    if Immovables[p] ~= nil then
        return nil, true
    end
end)
local function SetImmovable(inst, cancel)
    if not inst.Physics then return false end
    if cancel ~= false and Immovables[inst.Physics] == nil then
        Immovables[inst.Physics] = inst
    elseif cancel == false then
        Immovables[inst.Physics] = nil
    end
    return true
end
return {
    SetImmovable = SetImmovable,
}