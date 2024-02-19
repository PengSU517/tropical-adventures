---------------------------------indicador de veneno by EvenMr---------------------------------------------------
AddClassPostConstruct("widgets/healthbadge", function(inst)
    function inst:OnUpdate(dt)
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
    end
end)
