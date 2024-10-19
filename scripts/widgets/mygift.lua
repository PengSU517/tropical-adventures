local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
return Class(Widget, function(self)
	Widget._ctor(self, "mygift")	
    self:SetPosition(0, 0, 0)
	self.text = self:AddChild(Text(NUMBERFONT, 25))
	self.text:SetHAlign(ANCHOR_LEFT)
	self.text:SetVAlign(ANCHOR_MIDDLE)
    self.text:SetColour({1,1,1,1})
	self.text:SetPosition(200,-100,0) 
	function self:SetString(str)
		self.text:SetString(str)
	end
end)
