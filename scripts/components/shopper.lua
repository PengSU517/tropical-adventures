--Sits on the player prefab, not a pig.

local Shopper = Class(function(self, inst)
	self.inst = inst
end)


function Shopper:IsWatching(prefab)
	if prefab.components.shopped then
		local x, y, z = prefab.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 50, { "shopkeep" })
		if #ents > 0 then
			for i, ent in ipairs(ents) do
				if not ent.components.sleeper or not ent.components.sleeper:IsAsleep() then
					return true
				end
			end
		end
	end
	return false
end

function Shopper:CanPayFor(prefab)
	local player = self.inst
	local inventory = player.components.inventory

	if self:IsWatching(prefab) == false then
		print("NOT WATCHED")
		return true
	end

	if prefab.components.shopped then
		if prefab.components.shopdispenser == nil or prefab.components.shopdispenser:GetItem() == nil then
			return false
		end

		local prefab_wanted = prefab.costprefab

		if prefab_wanted == "oinc" then
			if inventory:HasMoney() >= prefab.cost then
				return true
			end
		else
			if inventory ~= nil and prefab_wanted ~= nil then
				local item = inventory:FindItem(function(look) return look.prefab == prefab_wanted end)
				if item ~= nil then
					return true
				end
			end
		end
	else
		if inventory:HasMoney() >= 1 then
			return true
		end
	end
	return false, "REPAIRBOAT"
end

function Shopper:BoughtItem(prefab, player)
	--    if self.items ~= nil then
	if player.components.inventory and prefab.components.shopdispenser then
		local item = SpawnPrefab(prefab.components.shopdispenser:GetItem())
		if item.OnBought then
			item.OnBought(item)
		end

		player.components.inventory:GiveItem(item, nil, Vector3(TheSim:GetScreenPos(prefab.Transform:GetWorldPosition())))
		--            local newItem = GetRandomItem(self.items)
		--            prefab:SoldItem() -- TimedInventory(newItem)
		--        end
	end
end

function Shopper:PayFor(prefab)
	local player = self.inst
	local inventory = player.components.inventory


	local prefab_wanted = prefab.costprefab
	--		local shop = prefab.components.shopped.shop.components.shopinterior
	if prefab.components.shopdispenser == nil or prefab.components.shopdispenser:GetItem() == nil then
		return false
	end

	if inventory ~= nil and prefab_wanted ~= nil then
		if prefab_wanted == "oinc" then
			inventory:PayMoney(prefab.cost)
			self:BoughtItem(prefab, player)
		elseif prefab_wanted == "goldenbar" then
			inventory:ConsumeByName("goldenbar", 1)
			self:BoughtItem(prefab, player)
		elseif prefab_wanted == "lucky_goldnugget" then
			inventory:ConsumeByName("lucky_goldnugget", 1)
			self:BoughtItem(prefab, player)
		else
			local item = inventory:FindItem(function(look) return look.prefab == prefab_wanted end)
			if item ~= nil then
				inventory:RemoveItem(item)
				self:BoughtItem(prefab, player)
			end
		end
	end
end

function Shopper:Take(prefab)
	local player = self.inst
	local inventory = player.components.inventory
	if prefab.components.shopdispenser == nil or prefab.components.shopdispenser:GetItem() == nil then
		return false
	end

	if inventory ~= nil then
		self:BoughtItem(prefab, player)
	end
end

return Shopper
