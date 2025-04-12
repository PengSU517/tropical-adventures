local require = GLOBAL.require
local Image = require "widgets/image"
local ANCHOR_MIDDLE = 0
local SCALEMODE_FILLSCREEN = 1
local MapWidget = require("widgets/mapwidget")
local Widget = require "widgets/widget"
local MapScreen = require "screens/mapscreen"

local upvaluehelper = require("tools/upvaluehelper")
local CUBES = table.invert({ "default", "shipwrecked", "hamlet" })


local function GetCurrentRegion(player)

    if player:AwareInShipwreckedArea() then
        return CUBES.shipwrecked
    elseif player:AwareInHamletArea() then
        return CUBES.hamlet
    --[[elseif player:AwareInPigcityArea() then
        return CUBES.pigcity]]
    else
        return CUBES.default
    end
end


local MAP_CONFIG = {
    [CUBES.shipwrecked] = {
        bg_xml = "images/mapstyle/hud_shipwrecked.xml",
        bg_tex = "map_shipwrecked.tex"
    },
    [CUBES.hamlet] = {
        bg_xml = "images/mapstyle/hud_hamlet.xml",
        bg_tex = "map_hamlet.tex"
    },--[[
    [CUBES.pigcity] = {
        bg_xml = "images/mapstyle/hud_pigcity.xml",
        bg_tex = "images/mapstyle/map_pigcity.tex"
    },]]
}


AddClassPostConstruct("screens/mapscreen", function(self)
    local _activatedplayer

    function MapScreen:OnBecomeInactive()
        MapScreen._base.OnBecomeInactive(self)

        if GLOBAL.TheWorld.minimap.MiniMap:IsVisible() then
            GLOBAL.TheWorld.minimap.MiniMap:ToggleVisibility()
        end
        TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/map_close")
    end

    function MapScreen:OnBecomeActive()
        MapScreen._base.OnBecomeActive(self)

        if not GLOBAL.TheWorld.minimap.MiniMap:IsVisible() then
            GLOBAL.TheWorld.minimap.MiniMap:ToggleVisibility()
        end
        TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/map_open")
        self.minimap:UpdateTexture()
    end

    self.inst:ListenForEvent("playeractivated", function(src, player)
        if player and _activatedplayer ~= player then
            player:ListenForEvent("regionchange_client", function()
                local region = GetCurrentRegion(player)
                local config = MAP_CONFIG[region]
                if config then
                    local mapWidget = self:GetChild("mapwidget")
                    if mapWidget then
                        if mapWidget.bg then
                            mapWidget.bg:Kill()
                        end
                        mapWidget.bg = mapWidget:AddChild(Image(config.bg_xml, config.bg_tex))
                        mapWidget.bg:SetVRegPoint(ANCHOR_MIDDLE)
                        mapWidget.bg:SetHRegPoint(ANCHOR_MIDDLE)
                        mapWidget.bg:SetVAnchor(ANCHOR_MIDDLE)
                        mapWidget.bg:SetHAnchor(ANCHOR_MIDDLE)
                        mapWidget.bg:SetScaleMode(SCALEMODE_FILLSCREEN)
                        local BLENDMODE = {
                            Disabled = 0,
                            AlphaBlended = 1,
                            Additive = 2,
                            Premultiplied = 3,
                            InverseAlpha = 4,
                            AlphaAdditive = 5,
                            VFXTest = 6,
                        }
                        mapWidget.bg.inst.ImageWidget:SetBlendMode(BLENDMODE.Premultiplied)
                    end
                end
            end)
            _activatedplayer = player
        end
    end)
end)

AddClassPostConstruct("widgets/mapwidget", function(self)
    local BLENDMODE = {
        Disabled = 0,
        AlphaBlended = 1,
        Additive = 2,
        Premultiplied = 3,
        InverseAlpha = 4,
        AlphaAdditive = 5,
        VFXTest = 6,
    }
    local player = GLOBAL.ThePlayer
    local region = GetCurrentRegion(player)
    local config = MAP_CONFIG[region]
    if config then
        if self.bg then
            self.bg:Kill()
        end
        self.bg = self:AddChild(Image(config.bg_xml, config.bg_tex))
        self.bg:SetVRegPoint(ANCHOR_MIDDLE)
        self.bg:SetHRegPoint(ANCHOR_MIDDLE)
        self.bg:SetVAnchor(ANCHOR_MIDDLE)
        self.bg:SetHAnchor(ANCHOR_MIDDLE)
        self.bg:SetScaleMode(SCALEMODE_FILLSCREEN)
        self.bg.inst.ImageWidget:SetBlendMode(BLENDMODE.Premultiplied)
    end

    self.minimap = GLOBAL.TheWorld.minimap.MiniMap

    self.img = self:AddChild(Image())
    self.img:SetHAnchor(ANCHOR_MIDDLE)
    self.img:SetVAnchor(ANCHOR_MIDDLE)
    self.img.inst.ImageWidget:SetBlendMode(BLENDMODE.Additive)

    self.lastpos = nil
    self.minimap:ResetOffset()
    self:StartUpdating()
end)