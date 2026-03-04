local WikiBookPopupScreen = require "screens/wikibookpopupscreen"

AddClassPostConstruct("screens/playerhud", function(self, anim, owner)
    function self:OpenWikiBookScreen()
        self:CloseWikiBookScreen()
        self.wikibookscreen = WikiBookPopupScreen(self.owner)
        self:OpenScreenUnderPause(self.wikibookscreen)
        return true
    end

    function self:CloseWikiBookScreen()
        if self.wikibookscreen ~= nil then
            if self.wikibookscreen.inst:IsValid() then
                TheFrontEnd:PopScreen(self.wikibookscreen)
            end
            self.wikibookscreen = nil
        end
    end
end)

AddPopup("WIKIBOOK")
POPUPS.WIKIBOOK.fn = function(inst, show)
    if inst.HUD then
        if not show then
            inst.HUD:CloseWikiBookScreen()
        elseif not inst.HUD:OpenWikiBookScreen() then
            POPUPS.WIKIBOOK:Close(inst)
        end
    end
end

local wikiIcon = require("widgets/wikiicon")
AddClassPostConstruct("widgets/controls", function(self)
    self.wikiIcon = self:AddChild(wikiIcon())     --说明页图标
    if self.hover ~= nil then
        self.hover:MoveToFront()
    end
end)
