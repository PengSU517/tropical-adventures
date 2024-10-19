local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local HayfeverBadge = Class(UIAnim, function(self, owner)
    self.owner = owner
    UIAnim._ctor(self)

    self:SetClickable(false)

    self:SetHAnchor(ANCHOR_MIDDLE)
    self:SetVAnchor(ANCHOR_MIDDLE)
    self:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)

    -- self:GetAnimState():SetBank("vagner_over")
    -- self:GetAnimState():SetBuild("vagner_over")
    -- self:GetAnimState():PlayAnimation("polenfraco", true)

    self:StartUpdating()
    self:Hide()
    self.speed = false
    self.neblina = 0
end)

function HayfeverBadge:OnUpdate(dt)
    -------------------------------------fog--------------------------------------------
    local player = self.owner
    local fan = GetClosestInstWithTag("prevents_hayfever", player, 20)
    local isinhamlet = player.components.areaaware and player.components.areaaware:CurrentlyInTag("hamlet")

    local isinterior = GetClosestInstWithTag("interior_center", player, 15)

    local corpo = (player.replica and player.replica.inventory) and
        player.replica.inventory:GetEquippedItem(EQUIPSLOTS.BODY) or nil
    local cabeca = (player.replica and player.replica.inventory) and
        player.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
    local hasequip = (corpo and corpo:HasTag("velocidadenormal")) or (cabeca and cabeca:HasTag("velocidadenormal"))


    if (TheWorld.state.iswinter and TheWorld.state.precipitationrate > 0 and isinhamlet and (not fan)) then
        if self.neblina < 1000 then self.neblina = self.neblina + 1 end
    else
        if self.neblina > -10 then self.neblina = self.neblina - 2 end
    end

    -------------沙尘暴动画是sand_over,云雾是clouds_ol
    if self.neblina > 0 and not isinterior then
        local a = math.max(math.min(self.neblina / 1000, 1), 0)
        -- self:GetAnimState():SetBank("vagner_over")
        -- self:GetAnimState():SetBuild("vagner_over")
        -- self:GetAnimState():SetMultColour(a, a, a, a * 0.7)
        -- self:GetAnimState():PlayAnimation("foog_loop", true)


        self:GetAnimState():SetBank("clouds_ol")
        self:GetAnimState():SetBuild("clouds_ol")
        self:GetAnimState():SetMultColour(a, a, a, a * 0.9)
        -- self:GetAnimState():SetDeltaTimeMultiplier(0.3) -----似乎是控制播放速度  但是现在这个badge似乎是直接附在镜头上，需要改
        self:GetAnimState():PushAnimation("idle", true) --------要用push
        self:Show()
    else
        self:Hide()
    end




    if hasequip or self.neblina < 500 or (not isinhamlet) then
        self.speed = false
        player:RemoveTag("hamfogspeed")
    else
        self.speed = true
        player:AddTag("hamfogspeed")
    end
end

return HayfeverBadge
