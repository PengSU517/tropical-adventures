local UIAnim = require "widgets/uianim"

AddClassPostConstruct("widgets/healthbadge", function(self, inst)
    self.poison = 0
	self.poisonanim = self.underNumber:AddChild(UIAnim())
    self.poisonanim:GetAnimState():SetBank("poison")
    self.poisonanim:GetAnimState():SetBuild("poison_meter_overlay")
    self.poisonanim:GetAnimState():PlayAnimation("deactivate")
    self.poisonanim:Hide()
    function self:OnUpdate(dt)
        local down =
            (self.owner.IsFreezing ~= nil and self.owner:IsFreezing()) or
            (self.owner.IsOverheating ~= nil and self.owner:IsOverheating()) or
            (self.owner.replica.hunger ~= nil and self.owner.replica.hunger:IsStarving()) or
            (self.owner.replica.health ~= nil and self.owner.replica.health:IsTakingFireDamage()) or
            (self.owner.IsBeaverStarving ~= nil and self.owner:IsBeaverStarving()) or
            GLOBAL.next(self.corrosives) ~= nil
        local small_down = self.owner.components.poisonable and self.owner.components.poisonable.dmg < 0

        -- Show the up-arrow when we're sleeping (but not in a straw roll: that doesn't heal us)
        local up = not down and
            ((self.owner.player_classified ~= nil and self.owner.player_classified.issleephealing:value()) or
                GLOBAL.next(self.hots) ~= nil or
                (self.owner.replica.inventory ~= nil and self.owner.replica.inventory:EquipHasTag("regen"))
            ) and
            self.owner.replica.health ~= nil and self.owner.replica.health:IsHurt()

        local anim =
            (down and "arrow_loop_decrease_most") or
            ((not up and small_down) and "arrow_loop_decrease") or
            (not up and "neutral") or
            (GLOBAL.next(self.hots) ~= nil and "arrow_loop_increase_most") or
            "arrow_loop_increase"

        if self.arrowdir ~= anim then
            self.arrowdir = anim
            self.sanityarrow:GetAnimState():PlayAnimation(anim, true)
        end

        local poisonable = self.owner.components.poisonable
        if not poisonable then return end
        local poison = poisonable.duration > 0 and 1 or poisonable.immuneduration > 0 and -1 or 0
        if self.poison ~= poison then
            self.poison = poison
            if self.poison ~= 0 then
                self.poisonanim:GetAnimState():PlayAnimation("activate")
                self.poisonanim:GetAnimState():PushAnimation("idle", true)
                self.poisonanim:GetAnimState():SetHue(poison == 1 and 0 or 130 / 360)
                self.poisonanim:Show()
            else
            	self.owner.SoundEmitter:PlaySound("dontstarve_DLC002/common/HUD_antivenom_use")
                self.poisonanim:GetAnimState():PlayAnimation("deactivate")
            end
        end
    end
end)
