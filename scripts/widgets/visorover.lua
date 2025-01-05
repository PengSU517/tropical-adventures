local Widget = require "widgets/widget"
local Image = require "widgets/image"

local VisorOver = Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "VisorOver")
	self:SetClickable(false)

	self.bg = self:AddChild(Image("images/overlays/visorvision.xml", "reduced_over.tex"))
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
    self.bg:SetVAnchor(ANCHOR_MIDDLE)
    self.bg:SetScaleMode(SCALEMODE_FILLSCREEN)
    self.bg:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(ANCHOR_MIDDLE)

	self.owner:ListenForEvent("equip", function() return self:UpdateVisor() end)
	self.owner:ListenForEvent("unequip", function() return self:UpdateVisor() end)
	self.owner:ListenForEvent("ms_respawnedfromghost", function() return self:UpdateVisor() end)
	self.owner:ListenForEvent("ms_becameghost", function() return self:UpdateVisor() end)

    self:Hide()
end)

function VisorOver:UpdateVisor(data)
	local hat = self.owner.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
	if hat and hat:HasTag("visorvision") then
		self:Show()
	else
		self:Hide()
	end
end

return VisorOver