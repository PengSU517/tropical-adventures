local Container = require "components/container_replica"
local Utils = require "tools/utils"
Utils.FnDecorator(Container, "GetWidget", nil, function(rets, self)
    return self.inst.replica.inventoryitem and
           self.inst.replica.inventoryitem:IsHeld() and
           self.widgetinspect and { self.widgetinspect } or rets
end)