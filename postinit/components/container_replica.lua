local Container = require "components/container_replica"
local Utils = require "tools/utils"
Utils.FnDecorator(Container, "GetWidget", nil, function(rets, self)
    return self.inst.replica.inventoryitem ~= nil and
           self.inst.replica.inventoryitem:IsHeld() ~= true and
           self.widgetinspect ~= nil and { self.widgetinspect } or rets
end)