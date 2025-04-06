local Widget = require("widgets/widget")
local Image = require("widgets/image")
local UIAnim = require("widgets/uianim")

local FogOver = Class(Widget, function(self, owner)
    Widget._ctor(self, "FogOver")
    self:UpdateWhilePaused(false)

    self.owner = owner

    self:SetClickable(false)

    self.bg = self:AddChild(UIAnim())
    self.bg:GetAnimState():SetBank("clouds_ol")
    self.bg:GetAnimState():SetBuild("clouds_ol")
    self.bg:GetAnimState():PlayAnimation("idle", true)
    self.bg:GetAnimState():AnimateWhilePaused(false)
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
    self.bg:SetVAnchor(ANCHOR_MIDDLE)
    self.bg:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)

    self.bg2 = self:AddChild(Image("images/overlays/fog.xml", "fog_over.tex"))
    self.bg2:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetVAnchor(ANCHOR_MIDDLE)
    self.bg2:SetHAnchor(ANCHOR_MIDDLE)
    self.bg2:SetScaleMode(SCALEMODE_FILLSCREEN)

    self.nowlevel = 0
    self.foggroggylevel = 0
    self.transitiontime = 2.0
    self.time = self.transitiontime

    self:Hide()

    self:StartUpdating()
end)

function FogOver:UpdateState(foggroggylevel)
    self.foggroggylevel = foggroggylevel
    if self.foggroggylevel and self.foggroggylevel > 0 then
        -- -- -- print("startupdatingfoggy in widget")
        -- -- -- print(self.foggroggylevel)
        self:StartUpdating()
        self:Show()
    end
end

function FogOver:OnUpdate(dt)
    if self.foggroggylevel - self.nowlevel > 0.01 then
        self.nowlevel = self.nowlevel + 0.01
    elseif self.nowlevel - self.foggroggylevel > 0.01 then
        self.nowlevel = self.nowlevel - 0.01
    end

    self.bg:GetAnimState():SetMultColour(1, 1, 1, self.nowlevel / 2)
    self.bg2:SetTint(1, 1, 1, self.nowlevel)

    if self.nowlevel <= 0 then
        self:Hide()
        -- self.owner:DoTaskInTime(10, function() self:StopUpdating() end)
    else
        self:Show()
    end
end

return FogOver
