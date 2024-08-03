local TROENV = env
GLOBAL.setfenv(1, GLOBAL)


----------------------------------------------------------------------------------------
local Curseditem = require("components/curseditem")

function Curseditem:lookforplayer()
    if self.inst.findplayertask then
        self.inst.findplayertask:Cancel()
        self.inst.findplayertask = nil
    end

    self.inst.findplayertask = self.inst:DoPeriodicTask(1, function()
        local x, y, z = self.inst.Transform:GetWorldPosition()
        local player = FindClosestPlayerInRangeSq(x, y, z, 10 * 10, true)

        if player and not self:checkplayersinventoryforspace(player) then
            player = nil
        end

        if player and player:HasTag("wilbur") then
            player = nil
        end

        if player and player.components.cursable and player.components.cursable:IsCursable(self.inst) and not player.components.debuffable:HasDebuff("spawnprotectionbuff") then
            if self.inst.findplayertask then
                self.inst.findplayertask:Cancel()
                self.inst.findplayertask = nil
            end

            self.target = player
            self.starttime = GetTime()
            self.startpos = Vector3(self.inst.Transform:GetWorldPosition())
        end
    end)
end
