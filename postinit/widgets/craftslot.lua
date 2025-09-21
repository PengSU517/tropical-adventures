-- local UIAnim = require "widgets/uianim"
local TropicalToolTip = require "widgets/tropical_tooltip"
local Util = require "tools/utils"

local CraftSlot = require "widgets/craftslot"
local function HideTip(self)
    if self.tropicaltip ~= nil then
        self.tropicaltip.item_tip = nil
        self.tropicaltip.skins_spinner = nil
        self.tropicaltip:HideTip()
    end
end
local function ShowTip(self)
    HideTip(self)

    self.tropicaltip = self:AddChild(TropicalToolTip())

    if self.tropicaltip ~= nil and self.recipe ~= nil and self.recipepopup ~= nil and self.recipe.name and STRINGS.TROPICAL_RECIPETOOLTIP[string.upper(self.recipe.name)] ~= nil then
        self.tropicaltip.item_tip = self.recipe.name
        self.tropicaltip.skins_spinner = self.recipepopup.skins_spinner or nil
        self.tropicaltip:ShowTip()
    end
end
Util.FnDecorator(CraftSlot, "ShowRecipe", ShowTip)
Util.FnDecorator(CraftSlot, "OnControl", ShowTip)
Util.FnDecorator(CraftSlot, "HideRecipe", HideTip)

local CraftingMenu_Hud = require "widgets/redux/craftingmenu_hud"
Util.FnDecorator(CraftingMenu_Hud, "OnUpdate", function(self)
    if self.craftingmenu ~= nil and self.tropicaltip == nil then
        self.tropicaltip = self.craftingmenu:AddChild(TropicalToolTip())
        self.tropicaltip:SetPosition(-105, -215)
        self.tropicaltip:SetScale(0.35)
    end

    if self.craftingmenu ~= nil and
        self.craftingmenu.crafting_hud ~= nil and
        self.craftingmenu.crafting_hud:IsCraftingOpen() and
        self.tropicaltip ~= nil and
        self.craftingmenu.details_root ~= nil and
        self.craftingmenu.details_root.data and
        self.craftingmenu.details_root.data.recipe ~= nil and
        self.craftingmenu.details_root.data.recipe.name and
        STRINGS.TROPICAL_RECIPETOOLTIP[string.upper(self.craftingmenu.details_root.data.recipe.name)] ~= nil then
        self.tropicaltip.item_tip = self.craftingmenu.details_root.data.recipe.name
        self.tropicaltip.skins_spinner = self.craftingmenu.details_root.skins_spinner or nil
        self.tropicaltip:ShowTip()
    elseif self.tropicaltip ~= nil then
        self.tropicaltip.item_tip = nil
        self.tropicaltip.skins_spinner = nil
        self.tropicaltip:HideTip()
    end
end)
