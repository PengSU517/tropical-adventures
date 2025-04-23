local Unwrappable = require "components/unwrappable"
local Utils = require "tools/utils"
Utils.FnDecorator(Unwrappable, "_ctor", nil, function(rets, self, inst)
    if TheWorld.ismastersim and inst.components.tradable == nil then
        inst:AddComponent("tradable")
    end
    return rets
end)
