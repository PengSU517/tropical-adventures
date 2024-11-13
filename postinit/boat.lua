local Utils = require("tools/utils")

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

-- -----------防止重新进档落水---------------需要和playerpost配合使用
AddComponentPostInit("playerspawner", function(self)
	local OldSpawnAtLocation = self.SpawnAtLocation
	function self:SpawnAtLocation(inst, player, x, y, z, isloading, ...)
		if isloading then
			local ship = player.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
			if ship then
				if player.components.drownable ~= nil then
					player.components.drownable.enabled = false
					player.undrownable_bcz_ship = true
				end
			end
		end
		OldSpawnAtLocation(self, inst, player, x, y, z, isloading, ...)

		-- local ship = player.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
		-- if ship then
		--     if player.components.drownable ~= nil then
		--         player.components.drownable.enabled = true
		--     end
		-- end
	end
end)


AddPlayerPostInit(function(inst)
	if TheWorld.ismastersim then
		inst:DoTaskInTime(2 * FRAMES, function()
			if inst.undrownable_bcz_ship and inst.components.drownable then
				inst.components.drownable.enabled = true
				inst.undrownable_bcz_ship = nil
			end
		end)
	end
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
