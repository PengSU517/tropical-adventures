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

function SpeediconBadge:OnUpdate(dt)
	-- ---------------------------这是船的速度图标-----但是似乎没啥效果-------------------------------------------------
	if self.owner then
		if self.owner:HasTag("tropicalbouillabaisse") then
			self.speediconanim:GetAnimState():PlayAnimation("frame02")
			self:Show()
		elseif self.owner:HasTag("coffee") then
			self.speediconanim:GetAnimState():PlayAnimation("frame01")
			self:Show()
		else
			self:Hide()
		end
	end



	-- -- ---------------------------这是船的速度图标-----但是似乎没啥效果-------------------------------------------------
	-- if self.owner and self.owner:HasTag("tropicalbouillabaisse") then
	-- 	local iconedavelocidade = self.owner.velocidadeativa
	-- 	if iconedavelocidade then
	-- 		iconedavelocidade.speediconanim:GetAnimState():PlayAnimation("frame02")
	-- 		iconedavelocidade:Show()
	-- 	end
	-- end

	-- if self.owner and self.owner:HasTag("coffee") then
	-- 	local iconedavelocidade = self.owner.velocidadeativa
	-- 	if iconedavelocidade then
	-- 		iconedavelocidade.speediconanim:GetAnimState():PlayAnimation("frame01")
	-- 		iconedavelocidade:Show()
	-- 	end
	-- end

	-- if not self.owner:HasTag("coffee") and not self.owner:HasTag("tropicalbouillabaisse") then
	-- 	local iconedavelocidade = self.owner.velocidadeativa
	-- 	if iconedavelocidade then iconedavelocidade:Hide() end
	-- end
end

return SpeediconBadge
