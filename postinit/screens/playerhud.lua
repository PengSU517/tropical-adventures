local easing = require("easing")
local PollenOver = require("widgets/pollenover")
local PlayerHud = require("screens/playerhud")
local _CreateOverlays = PlayerHud.CreateOverlays

function PlayerHud:CreateOverlays(owner, ...)
    _CreateOverlays(self, owner, ...)

    self.pollenover = self.overlayroot:AddChild(PollenOver(owner))
    self.pollenover:Show()
    self.inst:ListenForEvent("updatehayfever",
        function(inst, data)
            return self.pollenover:UpdateState(data.sneezetime)
        end,
        self.owner)
end
