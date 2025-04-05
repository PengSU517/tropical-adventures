local easing = require("easing")
local PollenOver = require("widgets/pollenover")
local FogOver = require("widgets/fogover")
local PlayerHud = require("screens/playerhud")
local _CreateOverlays = PlayerHud.CreateOverlays

function PlayerHud:CreateOverlays(owner, ...)
    _CreateOverlays(self, owner, ...)

    self.fogover = self.overlayroot:AddChild(FogOver(owner))
    -- self.fogover:MoveToBack()
    self.fogover:Hide()
    self.inst:ListenForEvent("updatefoggroggy",
        function(inst, data)
            -- print("updatefoggroggy in playerhud")
            -- print(data.foggroggylevel)
            return self.fogover:UpdateState(data.foggroggylevel)
        end,
        self.owner)

    self.pollenover = self.overlayroot:AddChild(PollenOver(owner))
    self.pollenover:Hide()
    self.inst:ListenForEvent("updatehayfever",
        function(inst, data)
            print("updatehayfever in playerhud")
            return self.pollenover:UpdateState(data.sneezetime)
        end,
        self.owner)
end
