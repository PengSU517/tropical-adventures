local Utils = require("tools/utils")

local function shardDMGRedirect(self, attacker, damage, weapon, ...) -- 碎裂武器伤害重定向
    if weapon then
        if weapon.prefab == "shard_sword" and self.inst:HasTag("shadow") then -- 碎裂剑对梦魇生物
            local health = self.inst.components.health
            if health then
                if health.currenthealth <= damage * TUNING.SWP_SHARD_DMG.SHADOW_MODIFIER_MAXIMUM then
                    return nil, false,
                           {self, attacker,
                            math.max(damage * TUNING.SWP_SHARD_DMG.SHADOW_MODIFIER_MINIMUM, health.currenthealth - 1),
                            weapon, ...}
                else
                    if attacker and attacker.components.combat then
                        attacker:DoTaskInTime(0, function()
                            attacker.components.combat:GetAttacked(weapon, math.random(1, 5))
                            attacker:PushEvent("thorns")
                        end)
                    end
                    return nil, false,
                           {self, attacker, damage * TUNING.SWP_SHARD_DMG.SHADOW_MODIFIER_MAXIMUM, weapon, ...}
                end
            end
        elseif weapon.prefab == "shard_beak" and -- 碎裂喙对建筑和巢
            (self.inst:HasTag("wall") or self.inst:HasTag("structure") or self.inst.components.childspawner) then
            return nil, false, {self, attacker, damage * TUNING.SWP_SHARD_DMG.STRUCTURE_MODIFIER, weapon, ...}
        end
    end
end

AddComponentPostInit("combat", function(self, inst) Utils.FnDecorator(self, "GetAttacked", shardDMGRedirect) end)
