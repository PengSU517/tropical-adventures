local Container = require "components/container_replica"
local Utils = require "tools/utils"
Utils.FnDecorator(Container, "GetWidget", function(self)
    return { self.widgetinspect }, not (self.inst.replica.inventoryitem and
                                        self.inst.replica.inventoryitem:IsHeld() and
                                        self.widgetinspect)
end)