---------------------------- new recipe tab for obsidian tools ---------------------
local _G = GLOBAL
local require = _G.require
local TechTree = require("techtree")
table.insert(TechTree.AVAILABLE_TECH, "OBSIDIAN")
table.insert(TechTree.AVAILABLE_TECH, "CITY")
table.insert(TechTree.AVAILABLE_TECH, "HOME")
table.insert(TechTree.AVAILABLE_TECH, "GODDESS")

TechTree.Create = function(t)
	t = t or {}
	for i, v in ipairs(TechTree.AVAILABLE_TECH) do
		t[v] = t[v] or 0
	end
	return t
end

_G.TECH.NONE.OBSIDIAN = 0
_G.TECH.OBSIDIAN_ONE = { OBSIDIAN = 1 }
_G.TECH.OBSIDIAN_TWO = { OBSIDIAN = 2 }

_G.TECH.NONE.CITY = 0
_G.TECH.CITY_ONE = { CITY = 1 }
_G.TECH.CITY_TWO = { CITY = 2 }

_G.TECH.NONE.HOME = 0
_G.TECH.HOME_ONE = { HOME = 1 }
_G.TECH.HOME_TWO = { HOME = 2 }

_G.TECH.NONE.GODDESS = 0
_G.TECH.GODDESS_ONE = { GODDESS = 1 }
_G.TECH.GODDESS_TWO = { GODDESS = 2 }

--------------------------------------------------------------------------
--[[ 解锁等级中加入自己的部分 ]]
--------------------------------------------------------------------------

for k, v in pairs(TUNING.PROTOTYPER_TREES) do
	v.OBSIDIAN = 0
	v.CITY = 0
	v.HOME = 0
	v.GODDESS = 0
end


TUNING.PROTOTYPER_TREES.OBSIDIAN_ONE = TechTree.Create({
	OBSIDIAN = 1,
})
TUNING.PROTOTYPER_TREES.OBSIDIAN_TWO = TechTree.Create({
	OBSIDIAN = 2,
})

TUNING.PROTOTYPER_TREES.CITY_ONE = TechTree.Create({
	CITY = 1,
})
TUNING.PROTOTYPER_TREES.CITY_TWO = TechTree.Create({
	CITY = 2,
})

TUNING.PROTOTYPER_TREES.HOME_ONE = TechTree.Create({
	HOME = 1,
})
TUNING.PROTOTYPER_TREES.HOME_TWO = TechTree.Create({
	HOME = 2,
})

TUNING.PROTOTYPER_TREES.GODDESS_ONE = TechTree.Create({
	GODDESS = 1,
})
TUNING.PROTOTYPER_TREES.GODDESS_TWO = TechTree.Create({
	GODDESS = 2,
})

for i, v in pairs(_G.AllRecipes) do
	if v.level.OBSIDIAN == nil then
		v.level.OBSIDIAN = 0
	end
	if v.level.CITY == nil then
		v.level.CITY = 0
	end
	if v.level.HOME == nil then
		v.level.HOME = 0
	end
	if v.level.GODDESS == nil then
		v.level.GODDESS = 0
	end
end


GLOBAL.RECIPETABS['OBSIDIANTAB'] = {
	str = "OBSIDIANTAB",
	sort = 90,
	icon = "tab_volcano.tex",
	icon_atlas = "images/tabs.xml",
	crafting_station = true
}
AddPrototyperDef("obsidian_workbench",
	{
		action_str = "OBSIDIANTAB",
		icon_image = "tab_volcano.tex",
		icon_atlas = "images/tabs.xml",
		is_crafting_station = true
	})

GLOBAL.RECIPETABS['CITY'] = {
	str = "CITY",
	sort = 91,
	icon = "tab_city.tex",
	icon_atlas = "images/tabs.xml",
	crafting_station = true
}
AddPrototyperDef("key_to_city",
	{ action_str = "CITY", icon_image = "tab_city.tex", icon_atlas = "images/tabs.xml", is_crafting_station = true })

GLOBAL.RECIPETABS['HOME'] = {
	str = "HOME",
	sort = 92,
	icon = "tab_home_decor.tex",
	icon_atlas = "images/tabs.xml",
	crafting_station = true
}
AddPrototyperDef("wallrenovation",
	{ action_str = "HOME", icon_image = "tab_home_decor.tex", icon_atlas = "images/tabs.xml", is_crafting_station = true })

GLOBAL.RECIPETABS['GODDESSTAB'] = {
	str = "GODDESSTAB",
	sort = 93,
	icon = "windyfan1.tex",
	icon_atlas = "images/inventoryimages/windyfan1.xml",
	crafting_station = true
}
AddPrototyperDef("goddess_shrine",
	{
		action_str = "GODDESSTAB",
		icon_image = "windyfan1.tex",
		icon_atlas = "images/inventoryimages/windyfan1.xml",
		is_crafting_station = true
	}
)