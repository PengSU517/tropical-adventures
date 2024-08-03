local Utils = require("tools/utils")

modimport("postinit/player_load")

-- 不会落水
local function DrownableShouldDrownBefore(self)
    if self.inst.components.driver then
        return { false }, true
    end

    local x, y, z = self.inst.Transform:GetWorldPosition()
    if #TheSim:FindEntities(x, y, z, 1, { "boat" }) > 0
    then
        return { false }, true
    end
end


AddComponentPostInit("drownable", function(self)
    Utils.FnDecorator(self, "ShouldDrown", DrownableShouldDrownBefore)
end)

---"armor_lifejacket"是否消失呢

--[[ function Drownable:TakeDrowningDamage()
	local tunings = self.customtuningsfn ~= nil and self.customtuningsfn(self.inst)
		or TUNING.DROWNING_DAMAGE[string.upper(self.inst.prefab)]
		or TUNING.DROWNING_DAMAGE[self.inst:HasTag("player") and "DEFAULT" or "CREATURE"]

	if self.inst.components.moisture ~= nil and tunings.WETNESS ~= nil then
		self.inst.components.moisture:DoDelta(tunings.WETNESS, true)
	end

	if self.inst.components.inventory ~= nil then
		local body_item = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
		if body_item ~= nil and body_item.components.flotationdevice ~= nil and body_item.components.flotationdevice:IsEnabled() then
			body_item.components.flotationdevice:OnPreventDrowningDamage()
			if body_item.prefab == "armor_lifejacket" then body_item:Remove() end
			return
		end
	end ]]





------------------测试内容------------------
-- require "components/map"

-- local old_IsPassableAtPoint = Map.IsPassableAtPoint

-- function Map:IsPassableAtPoint(x, y, z, allow_water, exclude_boats)
--     local valid_tile, is_overhang = self:IsPassableAtPointWithPlatformRadiusBias(x, y, z, allow_water, exclude_boats, 0)

--     -- if is_overhang == nil then
--     --     if not allow_water and not valid_tile then
--     --         if not exclude_boats then
--     --             if TheSim:FindEntities(x, y, z, 0.1, { "boatsw" }) then
--     --                 return true
--     --             end
--     --         end
--     --         return false
--     --     end
--     -- end
--     return valid_tile, is_overhang
-- end
