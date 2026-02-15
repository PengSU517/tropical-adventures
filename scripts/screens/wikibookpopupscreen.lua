local Screen = require "widgets/screen"
local MapWidget = require("widgets/mapwidget")
local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local WikibookWidget = require "widgets/redux/wikibookwidget"
local TEMPLATES = require "widgets/redux/templates"

local WikibookPopupScreen = Class(Screen, function(self, owner)
    self.owner = owner
    Screen._ctor(self, "WikibookPopupScreen")

    local black = self:AddChild(ImageButton("images/global.xml", "square.tex"))
    black.image:SetVRegPoint(ANCHOR_MIDDLE)
    black.image:SetHRegPoint(ANCHOR_MIDDLE)
    black.image:SetVAnchor(ANCHOR_MIDDLE)
    black.image:SetHAnchor(ANCHOR_MIDDLE)
    black.image:SetScaleMode(SCALEMODE_FILLSCREEN)
    black.image:SetTint(0, 0, 0, .5)
    black:SetOnClick(function()
        TheFrontEnd:PopScreen()
    end)
    black:SetHelpTextMessage("")

    local root = self:AddChild(Widget("root"))
    root:SetScaleMode(SCALEMODE_PROPORTIONAL)
    root:SetHAnchor(ANCHOR_MIDDLE)
    root:SetVAnchor(ANCHOR_MIDDLE)
    root:SetPosition(0, -25)

    self.book = root:AddChild(WikibookWidget(owner))

    self.default_focus = self.book

    SetAutopaused(true)
end)

function WikibookPopupScreen:OnDestroy()
    SetAutopaused(false)

    POPUPS.WIKIBOOK:Close(self.owner)

    -- TheWikibook:ClearNewFlags()
    -- TheWikibook:Save() -- for saving filter settings

    WikibookPopupScreen._base.OnDestroy(self)
end

function WikibookPopupScreen:OnBecomeInactive()
    WikibookPopupScreen._base.OnBecomeInactive(self)
end

function WikibookPopupScreen:OnBecomeActive()
    WikibookPopupScreen._base.OnBecomeActive(self)
end

function WikibookPopupScreen:OnControl(control, down)
    if WikibookPopupScreen._base.OnControl(self, control, down) then
        return true
    end

    if not down and (control == CONTROL_MENU_BACK or control == CONTROL_CANCEL) then
        TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
        TheFrontEnd:PopScreen()
        return true
    end

    return false
end

function WikibookPopupScreen:GetHelpText()
    local controller_id = TheInput:GetControllerID()
    local t = {}

    table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_CANCEL) .. " " .. STRINGS.UI.HELP.BACK)

    return table.concat(t, "  ")
end

return WikibookPopupScreen
