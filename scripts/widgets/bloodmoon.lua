local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"

local BloodmoonBadge = Class(Badge, function(self, owner)
    Badge._ctor(self, "bloodmoon", owner)

    self._moonanim = self:AddChild(UIAnim())
    self._moonanim:GetAnimState():SetBank("moon_phases_clock")
    self._moonanim:GetAnimState():SetBuild("moon_phases_clock")
    self._moonanim:GetAnimState():PlayAnimation("idle")
    self._moonanim:GetAnimState():OverrideSymbol("swap_moon", "moon_aporkalypse_phases", "moon_full")


    -- self._anim = self:AddChild(UIAnim())
    -- self._anim:GetAnimState():SetBank("clock01")
    -- self._anim:GetAnimState():SetBuild("clock_transitions")
    -- self._anim:GetAnimState():PlayAnimation("idle_day", true)
    -- self._anim:GetAnimState():AnimateWhilePaused(false)

    self._face = self:AddChild(Image("images/hud.xml", "clock_NIGHT.tex"))
    self._face:SetClickable(false)

    self._text = self:AddChild(Text(BODYTEXTFONT, 33 / 1))
    self._text:SetPosition(5, 0, 0)
    self._text:SetString("Red Moon")
    self._text:SetColour({ 0.5, 0, 0, 1 })

    self:Hide()
    self:SetScale(1)
    self:StartUpdating()
end)

function BloodmoonBadge:OnUpdate(dt)
    -- if self.owner and self.owner:IsInHamletArea() and TheWorld.state.isaporkalypse then
    if TheWorld.state.isaporkalypse and not TheWorld:HasTag("cave") then self:Show() else self:Hide() end
end

return BloodmoonBadge
