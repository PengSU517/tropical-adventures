-------------------------boat container sizing tweak by EvenMr-------------------------
AddClassPostConstruct("widgets/controls", function(self)
    local Widget = require("widgets/widget")
    self.containerroot_bottom = self:AddChild(Widget(""))
    self.containerroot_bottom:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)
    self.containerroot_bottom:SetVAnchor(GLOBAL.ANCHOR_BOTTOM)
    self.containerroot_bottom:SetScaleMode(GLOBAL.SCALEMODE_PROPORTIONAL)
    self.containerroot_bottom:SetMaxPropUpscale(GLOBAL.MAX_HUD_SCALE)
    self.containerroot_bottom:MoveToBack()
    self.containerroot_bottom = self.containerroot_bottom:AddChild(Widget("contaierroot_bottom"))
    local scale = GLOBAL.TheFrontEnd:GetHUDScale()
    self.containerroot_bottom:SetScale(scale, scale, scale)
    self.containerroot_bottom:Hide()

    local OldSetHUDSize = self.SetHUDSize
    function self:SetHUDSize()
        OldSetHUDSize(self)
        local scale = GLOBAL.TheFrontEnd:GetHUDScale()
        self.containerroot_bottom:SetScale(scale, scale, scale)
    end

    local OldShowCraftingAndInventory = self.ShowCraftingAndInventory
    function self:ShowCraftingAndInventory()
        OldShowCraftingAndInventory(self)
        self.containerroot_bottom:Show()
    end

    local OldHideCraftingAndInventory = self.HideCraftingAndInventory
    function self:HideCraftingAndInventory()
        OldHideCraftingAndInventory(self)
        self.containerroot_bottom:Hide()
    end
end)

AddClassPostConstruct("screens/playerhud", function(self)
    local ContainerWidget = require("widgets/containerwidget")
    local oldopen = self.OpenContainer
    function self:OpenContainer(container, side)
        if container.replica.container and container.replica.container:GetWidget() and container.replica.container:GetWidget().isboat then
            local containerwidget = ContainerWidget(self.owner)
            self.controls.containerroot_bottom:AddChild(containerwidget)
            containerwidget:Open(container, self.owner)
            self.controls.containers[container] = containerwidget
        else
            oldopen(self, container, side)
        end
    end
end)
