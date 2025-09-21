local Widget = require "widgets/widget"
local Image = require "widgets/image"

local Tooltip = Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "Tropical RecipeTooltip")

    self.icon_tro = self:AddChild(Image("images/tro_icon.xml", "TA_ICON.tex"))

    self.icon_tro:SetPosition(300, 300, 0)
    self.icon_tro:SetScaleMode(.01)
    self.icon_tro:SetScale(.7, .7, .7)

    self:Hide()
    self:RefreshTooltips()
    self.item_tip = nil
    self.skins_spinner = nil
end)

function Tooltip:ShowTip()
    self:RefreshTooltips()
    self:Show()
end

function Tooltip:HideTip()
    self:RefreshTooltips()
    self:Hide()
end

function Tooltip:RefreshTooltips()
    self.icon_tro:SetPosition(300, 245, 0)

    local tooltip = self.item_tip ~= nil and STRINGS.TROPICAL_RECIPETOOLTIP[string.upper(self.item_tip)] ~= nil and
        STRINGS.TROPICAL_RECIPETOOLTIP[string.upper(self.item_tip)]

    if self.item_tip ~= nil then
        self.icon_tro:SetTooltip(tooltip)
        self.icon_tro:Show()
    else
        self.icon_tro:Hide()
    end
end

return Tooltip
