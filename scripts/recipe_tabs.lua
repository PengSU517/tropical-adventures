---------------------------- new recipe tab for obsidian tools ---------------------
local require = require
local TechTree = require("techtree")

local tab_atlas = "images/ui/tabs.xml"


table.insert(TechTree.AVAILABLE_TECH, "OBSIDIAN")
table.insert(TechTree.AVAILABLE_TECH, "CITY")
table.insert(TechTree.AVAILABLE_TECH, "HOME")

TechTree.Create = function(t)
	t = t or {}
	for i, v in ipairs(TechTree.AVAILABLE_TECH) do
		t[v] = t[v] or 0
	end
	return t
end

TECH.NONE.OBSIDIAN = 0
TECH.OBSIDIAN_ONE = { OBSIDIAN = 1 }
TECH.OBSIDIAN_TWO = { OBSIDIAN = 2 }

TECH.NONE.CITY = 0
TECH.CITY_ONE = { CITY = 1 }
TECH.CITY_TWO = { CITY = 2 }

TECH.NONE.HOME = 0
TECH.HOME_ONE = { HOME = 1 }
TECH.HOME_TWO = { HOME = 2 }



--------------------------------------------------------------------------
--[[ 解锁等级中加入自己的部分 ]]
--------------------------------------------------------------------------

for k, v in pairs(TUNING.PROTOTYPER_TREES) do
	v.OBSIDIAN = 0
	v.CITY = 0
	v.HOME = 0
end


TUNING.PROTOTYPER_TREES.OBSIDIAN_ONE = TechTree.Create({ OBSIDIAN = 1, })
TUNING.PROTOTYPER_TREES.OBSIDIAN_TWO = TechTree.Create({ OBSIDIAN = 2, })

TUNING.PROTOTYPER_TREES.CITY_ONE = TechTree.Create({ CITY = 1, })
TUNING.PROTOTYPER_TREES.CITY_TWO = TechTree.Create({ CITY = 2, })

TUNING.PROTOTYPER_TREES.HOME_ONE = TechTree.Create({ HOME = 1, })
TUNING.PROTOTYPER_TREES.HOME_TWO = TechTree.Create({ HOME = 2, })



for i, v in pairs(AllRecipes) do
	if v.level.OBSIDIAN == nil then v.level.OBSIDIAN = 0 end
	if v.level.CITY == nil then v.level.CITY = 0 end
	if v.level.HOME == nil then v.level.HOME = 0 end
end


GLOBAL.RECIPETABS['OBSIDIANTAB'] = {
	str = "OBSIDIANTAB",
	sort = 90,
	icon = "tab_volcano.tex",
	icon_atlas = tab_atlas,
	crafting_station = true
}
AddPrototyperDef("obsidian_workbench",
	{ action_str = "OBSIDIANTAB", icon_image = "tab_volcano.tex", icon_atlas = tab_atlas, is_crafting_station = true })

GLOBAL.RECIPETABS['CITY'] = { str = "CITY", sort = 91, icon = "tab_city.tex", icon_atlas = tab_atlas, crafting_station = false }
AddPrototyperDef("key_to_city",
	{ action_str = "CITY", icon_image = "tab_city.tex", icon_atlas = tab_atlas, is_crafting_station = false })


GLOBAL.RECIPETABS['HOME'] = { str = "HOME", sort = 92, icon = "tab_home_decor.tex", icon_atlas = tab_atlas, crafting_station = false }
AddPrototyperDef("wallrenovation",
	{ action_str = "HOME", icon_image = "tab_home_decor.tex", icon_atlas = tab_atlas, is_crafting_station = false })





AddRecipeFilter({ name = "NAUTICAL", atlas = tab_atlas, image = "tab_nautical.tex" })
AddRecipeFilter({ name = "HAMLET", atlas = tab_atlas, image = "tab_city.tex" })
AddRecipeFilter({ name = "INTERIOR", atlas = tab_atlas, image = "tab_home_decor.tex" })
AddRecipeFilter({ name = "LEGACY", atlas = tab_atlas, image = "tab_archaeology.tex" })
