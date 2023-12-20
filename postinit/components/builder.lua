------------inicio builder----------------
function RoundBiasedUp(num, idp)
	local mult = 10 ^ (idp or 0)
	return math.floor(num * mult + 0.5) / mult
end



local TechTree = require("techtree")

AddComponentPostInit("builder", function(self)
	function self:GetMoney(inventory)
		local money = 0

		local hasoincs, oincamount = inventory:Has("oinc", 0)
		local hasoinc10s, oinc10amount = inventory:Has("oinc10", 0)
		local hasoinc100s, oinc100amount = inventory:Has("oinc100", 0)

		money = oincamount + (oinc10amount * 10) + (oinc100amount * 100)
		return money
	end

	function self:PayMoney(inventory, cost)
		local hasoincs, oincamount = inventory:Has("oinc", 0, true)
		local hasoinc10s, oinc10amount = inventory:Has("oinc10", 0, true)
		local hasoinc100s, oinc100amount = inventory:Has("oinc100", 0, true)
		local debt = cost

		local oincused = 0
		local oinc10used = 0
		local oinc100used = 0
		local oincgained = 0
		local oinc10gained = 0
		while debt > 0 do
			while debt > 0 and oincamount > 0 do
				oincamount = oincamount - 1
				debt = debt - 1
				oincused = oincused + 1
			end
			if debt > 0 then
				if oinc10amount > 0 then
					oinc10amount = oinc10amount - 1
					oinc10used = oinc10used + 1
					for i = 1, 10 do
						oincamount = oincamount + 1
						oincgained = oincgained + 1
					end
				elseif oinc100amount > 0 then
					oinc100amount = oinc100amount - 1
					oinc100used = oinc100used + 1
					for i = 1, 10 do
						oinc10amount = oinc10amount + 1
						oinc10gained = oinc10gained + 1
					end
				end
			end
		end
		local oincresult = oincgained - oincused
		if oincresult > 0 then
			for i = 1, oincresult do
				local coin = SpawnPrefab("oinc")
				inventory:GiveItem(coin)
			end
		end
		if oincresult < 0 then
			for i = 1, math.abs(oincresult) do
				--				inventory:ConsumeByName("oinc", 1 )	
				local item = next(inventory:GetItemByName("oinc", 1, true))
				if item then inventory:RemoveItem(item, false, true) end
			end
		end
		local oinc10result = oinc10gained - oinc10used
		if oinc10result > 0 then
			for i = 1, oinc10result do
				local coin = SpawnPrefab("oinc10")
				inventory:GiveItem(coin)
			end
		end
		if oinc10result < 0 then
			for i = 1, math.abs(oinc10result) do
				--				inventory:ConsumeByName("oinc10", 1 )
				local item = next(inventory:GetItemByName("oinc10", 1, true))
				if item then inventory:RemoveItem(item, false, true) end
			end
		end
		local oinc100result = 0 - oinc100used
		if oinc100result < 0 then
			for i = 1, math.abs(oinc100result) do
				--				inventory:ConsumeByName("oinc100", 1)
				local item = next(inventory:GetItemByName("oinc100", 1, true))
				if item then inventory:RemoveItem(item, false, true) end
			end
		end
	end

	function self:RemoveIngredients(ingredients, recname)
		local recipe = GetValidRecipe(recname)
		if recipe == nil then return false end

		for i, v in ipairs(recipe.ingredients) do
			if v.type == "oinc" and not self.freebuildmode then
				self:PayMoney(self.inst.components.inventory, v.amount)
			end
		end

		for item, ents in pairs(ingredients) do
			for k, v in pairs(ents) do
				for i = 1, v do
					if item ~= "oinc" then
						local item = self.inst.components.inventory:RemoveItem(k, false)

						-- If the item we're crafting with is a container,
						-- drop the contained items onto the ground.
						if item.components.container ~= nil then
							item.components.container:DropEverything(self.inst:GetPosition())
						end

						item:Remove()
					end
				end
			end
		end

		local recipe = AllRecipes[recname]
		if recipe then
			for k, v in pairs(recipe.character_ingredients) do
				if v.type == GLOBAL.CHARACTER_INGREDIENT.HEALTH then
					--Don't die from crafting!
					local delta = math.min(math.max(0, self.inst.components.health.currenthealth - 1), v.amount)
					self.inst:PushEvent("consumehealthcost")
					self.inst.components.health:DoDelta(-delta, false, "builder", true, nil, true)
				elseif v.type == GLOBAL.CHARACTER_INGREDIENT.MAX_HEALTH then
					self.inst:PushEvent("consumehealthcost")
					self.inst.components.health:DeltaPenalty(v.amount)
				elseif v.type == GLOBAL.CHARACTER_INGREDIENT.SANITY then
					self.inst.components.sanity:DoDelta(-v.amount)
				elseif v.type == GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY then
					--[[
                    Because we don't have any maxsanity restoring items we want to be more careful
                    with how we remove max sanity. Because of that, this is not handled here.
                    Removal of sanity is actually managed by the entity that is created.
                    See maxwell's pet leash on spawn and pet on death functions for examples.
                --]]
				end
			end
		end
		self.inst:PushEvent("consumeingredients")
	end

	local function GiveOrDropItem(self, recipe, item, pt)
		if recipe.dropitem then
			local angle = (self.inst.Transform:GetRotation() + GetRandomMinMax(-65, 65)) * DEGREES
			local r = item:GetPhysicsRadius(0.5) + self.inst:GetPhysicsRadius(0.5) + 0.1
			item.Transform:SetPosition(pt.x + r * math.cos(angle), pt.y, pt.z - r * math.sin(angle))
			item.components.inventoryitem:OnDropped()
		else
			self.inst.components.inventory:GiveItem(item, nil, pt)
		end
	end


	function self:DoBuild(recname, pt, rotation, skin)
		local recipe = GetValidRecipe(recname)
		if recipe ~= nil and (self:IsBuildBuffered(recname) or self:HasIngredients(recipe)) then
			if recipe.placer ~= nil and
				self.inst.components.rider ~= nil and
				self.inst.components.rider:IsRiding() then
				return false, "MOUNTED"
			elseif recipe.level.ORPHANAGE > 0 and (
					self.inst.components.petleash == nil or
					self.inst.components.petleash:IsFull() or
					self.inst.components.petleash:HasPetWithTag("critter")
				) then
				return false, "HASPET"
			elseif recipe.manufactured and (
					self.current_prototyper == nil or
					not self.current_prototyper:IsValid() or
					self.current_prototyper.components.prototyper == nil or
					not CanPrototypeRecipe(recipe.level, self.current_prototyper.components.prototyper.trees)
				) then
				-- manufacturing stations requires the current active protyper in order to work
				return false
			end

			if recipe.canbuild ~= nil then
				local success, msg = recipe.canbuild(recipe, self.inst, pt, rotation)
				if not success then
					return false, msg
				end
			end

			local is_buffered_build = self.buffered_builds[recname] ~= nil
			if is_buffered_build then
				self.buffered_builds[recname] = nil
				self.inst.replica.builder:SetIsBuildBuffered(recname, false)
			end

			if self.inst:HasTag("hungrybuilder") and not self.inst.sg:HasStateTag("slowaction") then
				local t = GetTime()
				if self.last_hungry_build == nil or t > self.last_hungry_build + TUNING.HUNGRY_BUILDER_RESET_TIME then
					self.inst.components.hunger:DoDelta(TUNING.HUNGRY_BUILDER_DELTA)
					self.inst:PushEvent("hungrybuild")
				end
				self.last_hungry_build = t
			end

			self.inst:PushEvent("refreshcrafting")

			if recipe.manufactured then
				local materials = self:GetIngredients(recname)
				self:RemoveIngredients(materials, recname)
				-- its up to the prototyper to implement onactivate and handle spawning the prefab
				return true
			end

			if self.inst and self.inst.components.inventory and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD):HasTag("brainjelly") then
				if self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).components.finiteuses then
					self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD).components.finiteuses:Use(1)
				end
			end

			local prod = SpawnPrefab(recipe.product, recipe.chooseskin or skin, nil, self.inst.userid) or nil
			if prod ~= nil then
				pt = pt or self.inst:GetPosition()

				if prod.components.inventoryitem ~= nil then
					if self.inst.components.inventory ~= nil then
						local materials = self:GetIngredients(recname)

						local wetlevel = self:GetIngredientWetness(materials)
						if wetlevel > 0 and prod.components.inventoryitem ~= nil then
							prod.components.inventoryitem:InheritMoisture(wetlevel, self.inst:GetIsWet())
						end

						if prod.onPreBuilt ~= nil then
							prod:onPreBuilt(self.inst, materials, recipe)
						end

						self:RemoveIngredients(materials, recname)

						--self.inst.components.inventory:GiveItem(prod)
						self.inst:PushEvent("builditem",
							{ item = prod, recipe = recipe, skin = skin, prototyper = self.current_prototyper })
						if self.current_prototyper ~= nil and self.current_prototyper:IsValid() then
							self.current_prototyper:PushEvent("builditem", { item = prod, recipe = recipe, skin = skin }) -- added this back for the gorge.
						end
						ProfileStatsAdd("build_" .. prod.prefab)

						if prod.components.equippable ~= nil
							and not recipe.dropitem
							and self.inst.components.inventory:GetEquippedItem(prod.components.equippable.equipslot) == nil
							and not prod.components.equippable:IsRestricted(self.inst) then
							if recipe.numtogive <= 1 then
								--The item is equippable. Equip it.
								self.inst.components.inventory:Equip(prod)
							elseif prod.components.stackable ~= nil then
								--The item is stackable. Just increase the stack size of the original item.
								prod.components.stackable:SetStackSize(recipe.numtogive)
								self.inst.components.inventory:Equip(prod)
							else
								--We still need to equip the original product that was spawned, so do that.
								self.inst.components.inventory:Equip(prod)
								--Now spawn in the rest of the items and give them to the player.
								for i = 2, recipe.numtogive do
									local addt_prod = SpawnPrefab(recipe.product)
									self.inst.components.inventory:GiveItem(addt_prod, nil, pt)
								end
							end
						elseif recipe.numtogive <= 1 then
							--Only the original item is being received.
							GiveOrDropItem(self, recipe, prod, pt)
						elseif prod.components.stackable ~= nil then
							--The item is stackable. Just increase the stack size of the original item.
							prod.components.stackable:SetStackSize(recipe.numtogive)
							GiveOrDropItem(self, recipe, prod, pt)
						else
							--We still need to give the player the original product that was spawned, so do that.
							GiveOrDropItem(self, recipe, prod, pt)
							--Now spawn in the rest of the items and give them to the player.
							for i = 2, recipe.numtogive do
								local addt_prod = SpawnPrefab(recipe.product)
								GiveOrDropItem(self, recipe, addt_prod, pt)
							end
						end

						NotifyPlayerProgress("TotalItemsCrafted", 1, self.inst)

						if self.onBuild ~= nil then
							self.onBuild(self.inst, prod)
						end
						prod:OnBuilt(self.inst)

						return true
					else
						prod:Remove()
						prod = nil
					end
				else
					if not is_buffered_build then -- items that have intermediate build items (like statues)
						local materials = self:GetIngredients(recname)
						self:RemoveIngredients(materials, recname)
					end

					local spawn_pos = pt

					-- If a non-inventoryitem recipe specifies dropitem, position the created object
					-- away from the builder so that they don't overlap.
					if recipe.dropitem then
						local angle = (self.inst.Transform:GetRotation() + GetRandomMinMax(-65, 65)) * DEGREES
						local r = prod:GetPhysicsRadius(0.5) + self.inst:GetPhysicsRadius(0.5) + 0.1
						spawn_pos = Vector3(
							spawn_pos.x + r * math.cos(angle),
							spawn_pos.y,
							spawn_pos.z - r * math.sin(angle)
						)
					end

					prod.Transform:SetPosition(spawn_pos:Get())
					--V2C: or 0 check added for backward compatibility with mods that
					--     have not been updated to support placement rotation yet
					prod.Transform:SetRotation(rotation or 0)
					self.inst:PushEvent("buildstructure", { item = prod, recipe = recipe, skin = skin })
					prod:PushEvent("onbuilt", { builder = self.inst, pos = pt })
					ProfileStatsAdd("build_" .. prod.prefab)
					NotifyPlayerProgress("TotalItemsCrafted", 1, self.inst)

					if self.onBuild ~= nil then
						self.onBuild(self.inst, prod)
					end

					prod:OnBuilt(self.inst)

					return true
				end
			end
		end
	end

	function self:KnowsRecipe(recipe)
		if type(recipe) == "string" then
			recipe = GetValidRecipe(recipe)
		end

		if recipe == nil then
			return false
		end
		if self.freebuildmode or self.inst:HasTag("brainjelly") then
			return true
		elseif recipe.builder_tag ~= nil and not self.inst:HasTag(recipe.builder_tag) then -- builder_tag cehck is require due to character swapping
			return false
		elseif self.station_recipes[recipe.name] or table.contains(self.recipes, recipe.name) then
			return true
		end

		local has_tech = true
		for i, v in ipairs(TechTree.AVAILABLE_TECH) do
			if recipe.level[v] > (self[string.lower(v) .. "_bonus"] or 0) then
				return false
			end
		end
		return true
	end

	function self:HasIngredients(recipe)
		if type(recipe) == "string" then
			recipe = GetValidRecipe(recipe)
		end
		if recipe ~= nil then
			if self.freebuildmode then
				return true
			end
			for i, v in ipairs(recipe.ingredients) do
				if v.type == "oinc" then
					if self:GetMoney(self.inst.components.inventory) >= v.amount then
						return true
					end
				end

				if not self.inst.components.inventory:Has(v.type, math.max(1, RoundBiasedUp(v.amount * self.ingredientmod)), true) then
					return false
				end
			end
			for i, v in ipairs(recipe.character_ingredients) do
				if not self:HasCharacterIngredient(v) then
					return false
				end
			end
			for i, v in ipairs(recipe.tech_ingredients) do
				if not self:HasTechIngredient(v) then
					return false
				end
			end
			return true
		end

		return false
	end

	function self:MakeRecipeAtPoint(recipe, pt, rot, skin)
		----------------------------------------------------------
		if recipe.product == "sprinkler1" and (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.FARMING_SOIL) then
			return
				self:MakeRecipe(recipe, pt, rot, skin)
		end
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.UNDERWATER_SANDY) then return false end                          --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.UNDERWATER_ROCKY) then return false end                          --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.BEACH and GLOBAL.TheWorld:HasTag("cave")) then return false end  --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.MAGMAFIELD and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.PAINTED and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.BATTLEGROUND and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.PEBBLEBEACH and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if recipe.placer ~= nil and
			--        self:KnowsRecipe(recipe.name) and
			self:IsBuildBuffered(recipe.name) and
			GLOBAL.TheWorld.Map:CanDeployRecipeAtPoint(pt, recipe, rot) then
			self:MakeRecipe(recipe, pt, rot, skin)
		end
	end
end)


AddClassPostConstruct("components/builder_replica", function(self)
	function self:KnowsRecipe(recipe)
		if type(recipe) == "string" then
			recipe = GetValidRecipe(recipe)
		end

		if self.inst.components.builder ~= nil then
			return self.inst.components.builder:KnowsRecipe(recipe)
		elseif self.classified ~= nil then
			if recipe ~= nil then
				if self.classified.isfreebuildmode:value() or self.inst:HasTag("brainjelly") then
					return true
				elseif recipe.builder_tag ~= nil and not self.inst:HasTag(recipe.builder_tag) then -- builder_tag check is require due to character swapping
					return false
				elseif self.classified.recipes[recipe.name] ~= nil and self.classified.recipes[recipe.name]:value() then
					return true
				end

				local has_tech = true
				for i, v in ipairs(TechTree.AVAILABLE_TECH) do
					local bonus = self.classified[string.lower(v) .. "bonus"]
					if recipe.level[v] > (bonus ~= nil and bonus:value() or 0) then
						return false
					end
				end

				return true
			end
		end
		return false
	end

	function self:GetMoney(inventory)
		local money = 0

		local hasoincs, oincamount = inventory:Has("oinc", 0)
		local hasoinc10s, oinc10amount = inventory:Has("oinc10", 0)
		local hasoinc100s, oinc100amount = inventory:Has("oinc100", 0)

		money = oincamount + (oinc10amount * 10) + (oinc100amount * 100)
		return money
	end

	function self:HasIngredients(recipe)
		if self.inst.components.builder ~= nil then
			return self.inst.components.builder:HasIngredients(recipe)
		elseif self.classified ~= nil then
			if type(recipe) == "string" then
				recipe = GetValidRecipe(recipe)
			end
			if recipe ~= nil then
				if self.classified.isfreebuildmode:value() then
					return true
				end
				for i, v in ipairs(recipe.ingredients) do
					if v.type == "oinc" then
						if self:GetMoney(self.inst.replica.inventory) >= v.amount then
							return true
						end
					end
					if not self.inst.replica.inventory:Has(v.type, math.max(1, RoundBiasedUp(v.amount * self:IngredientMod())), true) then
						return false
					end
				end
				for i, v in ipairs(recipe.character_ingredients) do
					if not self:HasCharacterIngredient(v) then
						return false
					end
				end
				for i, v in ipairs(recipe.tech_ingredients) do
					if not self:HasTechIngredient(v) then
						return false
					end
				end
				return true
			end
		end

		return false
	end

	function self:CanBuildAtPoint(pt, recipe, rot)
		if recipe.product == "sprinkler1" and (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.FARMING_SOIL) then return true end

		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.UNDERWATER_SANDY) then return false end                          --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.UNDERWATER_ROCKY) then return false end                          --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.BEACH and GLOBAL.TheWorld:HasTag("cave")) then return false end  --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.MAGMAFIELD and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.PAINTED and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.BATTLEGROUND and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		if (GLOBAL.TheWorld.Map:GetTile(GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.PEBBLEBEACH and GLOBAL.TheWorld:HasTag("cave")) then return false end --adicionado por vagner
		return GLOBAL.TheWorld.Map:CanDeployRecipeAtPoint(pt, recipe, rot)
	end
end)