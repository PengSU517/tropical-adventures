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
    if inst.Physics and cancel ~= false then
        Immovables[inst.Physics] = true
        return
    end
    if cancel == false then
        Immovables[inst.Physics] = nil
    end
end
return {
    SetImmovable = SetImmovable,
}