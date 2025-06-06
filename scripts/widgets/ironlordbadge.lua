local Badge = require "widgets/badge"

local IronlordBadge = Class(Badge, function(self, owner)
     Badge._ctor(self, "livingartifact_meter", owner)

     self.maxfuel = TUNING.IRON_LORD_TIME
     self.currentfuel = self.maxfuel

     self:StartUpdating()
end)

function IronlordBadge:OnUpdate(dt)
     if TheNet:IsServerPaused() then return end

     self.currentfuel = ThePlayer.player_classified.artifactfuel:value()
     self:SetPercent(self.currentfuel / self.maxfuel)
end

return IronlordBadge