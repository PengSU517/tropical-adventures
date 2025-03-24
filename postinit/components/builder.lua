local Utils = require("tools/utils")

AddComponentPostInit("builder", function(self)
	--- 对消耗呼噜币的扣除
	-- Utils.FnDecorator(self, "RemoveIngredients", function(self, ingredients, recname, ...)
	-- 	local recipe = GetValidRecipe(recname)
	-- 	if self.freebuildmode or not recipe then return end

	-- 	-- 自己扣除呼噜币
	-- 	for i, v in ipairs(recipe.ingredients) do
	-- 		if v.type == "oinc" then
	-- 			self.inst.components.inventory:PayMoney(v.amount)
	-- 		end
	-- 	end

	-- 	--移除呼噜币的扣除
	-- 	local newIngredients = {}
	-- 	for item, ents in pairs(ingredients) do
	-- 		if item ~= "oinc" then
	-- 			newIngredients[item] = ents
	-- 		end
	-- 	end
	-- 	return nil, false, { self, newIngredients, recname, ... }
	-- end)

	-- 装备智慧帽时解锁所有配方
	Utils.FnDecorator(self, "KnowsRecipe", function(self, recipe)
		if type(recipe) == "string" then
			recipe = GetValidRecipe(recipe)
		end

		if recipe and not recipe.nounlock and self.inst.components.inventory:EquipHasTag("brainjelly") then
			return { true }, true
		end
	end)
end)

----------------------------------------------------------------------------------------------------
AddClassPostConstruct("components/builder_replica", function(self)
	Utils.FnDecorator(self, "KnowsRecipe", function(self, recipe)
		if type(recipe) == "string" then
			recipe = GetValidRecipe(recipe)
		end

		if recipe and not recipe.nounlock and self.inst.replica.inventory:EquipHasTag("brainjelly") then
			return { true }, true
		end
	end)
end)
