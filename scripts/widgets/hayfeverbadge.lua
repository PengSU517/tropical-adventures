local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local HayfeverBadge = Class(UIAnim, function(self, owner)
    self.owner = owner
    UIAnim._ctor(self)

    self:SetClickable(false)

    self:SetHAnchor(ANCHOR_MIDDLE)
    self:SetVAnchor(ANCHOR_MIDDLE)
    self:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)

    -- self:GetAnimState():SetBank("vagner_over")
    -- self:GetAnimState():SetBuild("vagner_over")
    -- self:GetAnimState():PlayAnimation("polenfraco", true)

    self:StartUpdating()
    self:Hide()
    self.hayfever = 0
end)

function HayfeverBadge:OnUpdate(dt)
    local hayfeverval = self.owner.components.hayfever and self.owner.components.hayfever.fevervalue
    if hayfeverval and hayfeverval > 0 then
        local a = math.max(math.min(hayfeverval / 3400, 1), 0)
        self:GetAnimState():SetBank("vagner_over")
        self:GetAnimState():SetBuild("vagner_over")
        self:GetAnimState():SetMultColour(a, a, a, a * 0.7)
        self:GetAnimState():PlayAnimation("polenforte", true)
        self:Show()
    else
        self:Hide()
    end
end

return HayfeverBadge
