local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local desc_terms = require("datadefs/wikibook_contents").wiki_terms

local WikiIcon = Class(Widget, function(self)
    Widget._ctor(self, "WikiIcon")
    self.root = self:AddChild(Widget("ROOT"))
    self.pageIcon = self.root:AddChild(ImageButton(
        "images/inventoryimages1.xml", "book_research_station.tex",
        -- "images/scrapbook.xml", "icon_empty.tex",
        nil, nil, nil, nil, { 1, 1 }, { 0, 0 }))
    self.pageIcon:SetScale(1.5, 1.5, 1.5)
    self.pageIcon:SetHAnchor(1)                        -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.pageIcon:SetVAnchor(2)                        -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.pageIcon:SetPosition(70, 70, 0)
    self.pageIcon:SetTooltip(desc_terms.click_to_read) --tips
    self.pageIcon:SetOnClick(function()
        if ThePlayer and ThePlayer.HUD then
            ThePlayer.HUD:OpenWikiBookScreen()
        end
    end)
end)

return WikiIcon
