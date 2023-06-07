local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local Widget = require "widgets/widget"

local SpeediconBadge = Class(Widget, function(self, owner)
	Widget._ctor(self, "speedicon", owner)
	
	self.speediconanim = self:AddChild(UIAnim())
	self.speediconanim:GetAnimState():SetBank("speedicon")
	self.speediconanim:GetAnimState():SetBuild("speedicon")
	self.speediconanim:GetAnimState():PlayAnimation("frame01")

	self:Hide()

end)

return SpeediconBadge