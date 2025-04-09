local TechTree = require("techtree")
local Utils = require("tools/utils")

AddComponentPostInit("builder", function(self)
	Utils.FnDecorator(self, "MakeRecipeAtPoint", function(self, recipe)
		if not self:KnowsRecipe(recipe) and recipe.level.HOME and recipe.level.HOME <= 2 then
			self:AddRecipe(recipe.name)
		end
	end)

	-- function self:MakeRecipeAtPoint(recipe, pt, rot, skin)
	-- 	if recipe.placer ~= nil and
	-- 		self:KnowsRecipe(recipe.name) and ---为什么这个环节会出问题呢
	-- 		self:IsBuildBuffered(recipe.name) and
	-- 		TheWorld.Map:CanDeployRecipeAtPoint(pt, recipe, rot) then
	-- 		self:MakeRecipe(recipe, pt, rot, skin)
	-- 	end
	-- end

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
