local Utils = require("tools/utils")

local function DoSpringBefore(self)
    if self.target
        and self.target:IsValid()
        and not self.target:IsInLimbo()
        and not (self.target.components.health ~= nil and self.target.components.health:IsDead())
        and self.target.components.inventoryitem ~= nil
        and self.target.components.inventoryitem.trappable
    then
        local old = self.target.prefab
        self.target.prefab = old == "lobster" and "lobster_land"
            or old == "wobster_sheller" and "wobster_sheller_land"
            or old == "wobster_moonglass" and "wobster_moonglass_land"
    end
end

AddComponentPostInit("trap", function(self)
    Utils.FnDecorator(self, "DoSpring", DoSpringBefore)
end)
