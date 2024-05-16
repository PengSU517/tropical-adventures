local v_atlas = "images/inventoryimages/volcanoinventory.xml"
local h_atlas = "images/inventoryimages/hamletinventory.xml"
local hm_atlas = "map_icons/hamleticon.xml"
-- local cm_atlas = "map_icons/creepindedeepicon.xml"
-- local g_atlas = "images/quagmire_food_common_inv_images.xml"
local safe_atlas = "images/tabs.xml"
-- local hnew_atlas = "images/inventoryimages/tap_buildingimages.xml"

local TECH = GLOBAL.TECH

AddRecipeFilter({ name = "NAUTICAL", atlas = safe_atlas, image = "nauticaltab.png" })
AddRecipeFilter({ name = "HAMLET", atlas = safe_atlas, image = "tab_city.tex" })
AddRecipeFilter({ name = "INTERIOR", atlas = safe_atlas, image = "tab_home_decor.tex" })
AddRecipeFilter({ name = "LEGACY", atlas = safe_atlas, image = "tab_archaeology.tex" })



---------新物品
AddRecipe2("pugaliskfountain_made",
	{ Ingredient("cutstone", 6), Ingredient("moonrocknugget", 10), Ingredient("bluegem", 2) },
	TECH.LOST, ----TECH.CITY_ONE,
	{
		atlas = hm_atlas,
		-- nounlock = true,
		min_spacing = 3.2,
		placer = "pugaliskfountain_made_placer",
		image = "pig_ruins_well.png" ----  "pig_ruins_well.png"
		--"pighouse_city.tex"     --"kyno_fountainyouth.tex" ---- ---"pig_ruins_well.tex"---------------这个图在哪儿
	},
	{ "STRUCTURES", "LEGACY", "SUMMER" })



-- AddRecipe2("reno_window_greenhouse", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
-- 	{ atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("wildborehouse",
-- 	{ Ingredient("pigskin", 4), Ingredient("palmleaf", 5, v_atlas), Ingredient("bamboo", 8, v_atlas) }, TECH.SCIENCE_TWO,
-- 	{ atlas = v_atlas, placer = "wildborehouse_placer" }, { "STRUCTURES" })
-----------------这个为什么不需要图片

AddRecipe2("loot_pumper",
	{
		Ingredient("gears", 1),
		Ingredient("alloy", 2, h_atlas),
		Ingredient("transistor", 2)
	},
	TECH.SCIENCE_TWO,
	{
		atlas = "images/inventoryimages/loot_pump.xml",
		min_spacing = 3.2,
		placer = "loot_pumper_placer",
		image = "loot_pump.tex"
	},
	{ "PROTOTYPERS", "STRUCTURES" })




-- if GetModConfigData("frost_island") ~= 5 then
-- 	AddRecipe2("wildbeaver_house",
-- 		{ Ingredient("beaverskin", 4, v_atlas), Ingredient("boards", 4), Ingredient("cutstone", 3) }, TECH.SCIENCE_TWO,
-- 		{ placer = "wildbeaver_house_placer", atlas = v_atlas }, { "STRUCTURES" })
-- end

-- if GetModConfigData("Shipwrecked_plus") == true or GetModConfigData("Shipwreckedworld_plus") == true then
-- 	AddRecipe2("pandahouse", { Ingredient("pandaskin", 4, v_atlas), Ingredient("boards", 4), Ingredient("cutstone", 3) },
-- 		TECH.SCIENCE_TWO, { placer = "pandahouse_placer", atlas = v_atlas }, { "STRUCTURES" })
-- end

-- if GetModConfigData("gorgeisland") == true or GetModConfigData("Shipwreckedworld_plus") == true then
-- 	AddRecipe2("galinheiro",
-- 		{ Ingredient("seeds", 6), Ingredient("boards", 4), Ingredient("feather_chicken", 2, cm_atlas) },
-- 		TECH.SCIENCE_TWO, { placer = "galinheiro_placer", atlas = cm_atlas }, { "STRUCTURES" })
-- end

---------------------corrigindo bug estranho-------------
AddRecipe2("campfire", { Ingredient("cutgrass", 3), Ingredient("log", 2) }, TECH.NONE, { placer = "campfire_placer" })

--CHARACTER--
AddRecipe2("surfboarditem", { Ingredient("boards", 1), Ingredient("seashell", 1, v_atlas) }, TECH.NONE,
	{ builder_tag = "walani", atlas = v_atlas }, { "CHARACTER" })
AddRecipe2("porto_woodlegsboat",
	{ Ingredient("boards", 4), Ingredient("dubloon", 4, v_atlas), Ingredient("boatcannon", 1, v_atlas) }, TECH.NONE,
	{ builder_tag = "woodlegs", atlas = v_atlas }, { "CHARACTER" })
AddRecipe2("luckyhat",
	{ Ingredient("boneshard", 4), Ingredient("fabric", 3, v_atlas), Ingredient("dubloon", 10, v_atlas) },
	TECH.NONE, { builder_tag = "woodlegs", atlas = v_atlas }, { "CHARACTER" })
AddRecipe2("poisonbalm", { Ingredient("livinglog", 1), Ingredient("venomgland", 1, v_atlas) }, TECH.NONE,
	{ builder_tag = "plantkin", atlas = h_atlas }, { "CHARACTER" })
-- AddRecipe2("mutator_tropical",
-- 	{ Ingredient("monstermeat", 2), Ingredient("silk", 1), Ingredient("venomgland", 1, v_atlas) }, TECH.NONE,
-- 	{ builder_tag = "spiderwhisperer", atlas = cm_atlas }, { "CHARACTER" })
-- AddRecipe2("mutator_frost", { Ingredient("monstermeat", 2), Ingredient("silk", 3), Ingredient("ice", 4) }, TECH.NONE,
-- 	{ builder_tag = "spiderwhisperer", atlas = cm_atlas }, { "CHARACTER" })
AddRecipe2("mermfishhouse", { Ingredient("boards", 5), Ingredient("cutreeds", 3), Ingredient("fish2", 2, v_atlas) },
	TECH.SCIENCE_ONE,
	{
		builder_tag = "merm_builder",
		atlas = hm_atlas,
		placer = "mermfishhouse_placer",
		image = "mermhouse_tropical.png",
		testfn = function(pt, rot)
			local ground_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
			return ground_tile and (ground_tile == GROUND.MARSH or ground_tile == GROUND.TIDALMARSH)
		end
	}, { "CHARACTER" })
AddRecipe2("mermhouse_crafted", { Ingredient("boards", 4), Ingredient("cutreeds", 3), Ingredient("pondfish", 2) },
	TECH.SCIENCE_ONE,
	{
		builder_tag = "merm_builder",
		placer = "mermhouse_crafted_placer",
		testfn = function(pt, rot)
			local ground_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
			return ground_tile and (ground_tile == GROUND.MARSH or ground_tile == GROUND.TIDALMARSH)
		end
	}, { "CHARACTER" })
AddRecipe2("mermthrone_construction", { Ingredient("boards", 5), Ingredient("rope", 5) }, TECH.SCIENCE_ONE,
	{
		builder_tag = "merm_builder",
		placer = "mermthrone_construction_placer",
		testfn = function(pt, rot)
			local ground_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
			return ground_tile and (ground_tile == GROUND.MARSH or ground_tile == GROUND.TIDALMARSH)
		end
	}, { "CHARACTER" })
AddRecipe2("mermwatchtower", { Ingredient("boards", 5), Ingredient("tentaclespots", 1), Ingredient("spear", 2) },
	TECH.SCIENCE_TWO,
	{
		builder_tag = "merm_builder",
		placer = "mermwatchtower_placer",
		testfn = function(pt, rot)
			local ground_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
			return ground_tile and (ground_tile == GROUND.MARSH or ground_tile == GROUND.TIDALMARSH)
		end
	}, { "CHARACTER" })
AddRecipe2("shadowmower_builder", { Ingredient("nightmarefuel", 2), Ingredient(GLOBAL.CHARACTER_INGREDIENT.SANITY, 60) },
	TECH.SHADOW_TWO, { builder_tag = "shadowmagic", atlas = v_atlas, nounlock = true }, { "CRAFTING_STATION" })
AddRecipe2("shadowlumber_builder",
	{ Ingredient("nightmarefuel", 2),
		Ingredient(GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY, GLOBAL.TUNING.SHADOWWAXWELL_SANITY_PENALTY.SHADOWLUMBER) },
	TECH.SHADOW_TWO, nil, nil, true, nil, "shadowmagic")
AddRecipe2("shadowminer_builder",
	{ Ingredient("nightmarefuel", 2),
		Ingredient(GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY, GLOBAL.TUNING.SHADOWWAXWELL_SANITY_PENALTY.SHADOWMINER) },
	TECH.SHADOW_TWO, nil, nil, true, nil, "shadowmagic")
AddRecipe2("shadowdigger_builder",
	{ Ingredient("nightmarefuel", 2),
		Ingredient(GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY, GLOBAL.TUNING.SHADOWWAXWELL_SANITY_PENALTY.SHADOWDIGGER) },
	TECH.SHADOW_TWO, nil, nil, true, nil, "shadowmagic")
AddRecipe2("shadowduelist_builder",
	{ Ingredient("nightmarefuel", 2),
		Ingredient(GLOBAL.CHARACTER_INGREDIENT.MAX_SANITY, GLOBAL.TUNING.SHADOWWAXWELL_SANITY_PENALTY.SHADOWDUELIST) },
	TECH.SHADOW_TWO, nil, nil, true, nil, "shadowmagic")

--OBSIDIAN STATION--
AddRecipe2("axeobsidian",
	{ Ingredient("axe", 1), Ingredient("obsidian", 2, v_atlas), Ingredient("dragoonheart", 1, v_atlas) },
	TECH.OBSIDIAN_TWO, { atlas = v_atlas, nounlock = true }, { "CRAFTING_STATION" })
AddRecipe2("obsidianmachete",
	{ Ingredient("machete", 1, v_atlas), Ingredient("obsidian", 3, v_atlas), Ingredient("dragoonheart", 1, v_atlas) },
	TECH.OBSIDIAN_TWO, { atlas = v_atlas, nounlock = true }, { "CRAFTING_STATION" })
AddRecipe2("spear_obsidian",
	{ Ingredient("spear", 1), Ingredient("obsidian", 3, v_atlas), Ingredient("dragoonheart", 1, v_atlas) },
	TECH.OBSIDIAN_TWO, { atlas = v_atlas, nounlock = true }, { "CRAFTING_STATION" })
AddRecipe2("volcanostaff",
	{ Ingredient("firestaff", 1), Ingredient("obsidian", 4, v_atlas), Ingredient("dragoonheart", 1, v_atlas) },
	TECH.OBSIDIAN_TWO, { atlas = v_atlas, nounlock = true }, { "CRAFTING_STATION" })
AddRecipe2("armorobsidian",
	{ Ingredient("armorwood", 1), Ingredient("obsidian", 5, v_atlas), Ingredient("dragoonheart", 1, v_atlas) },
	TECH.OBSIDIAN_TWO, { atlas = v_atlas, nounlock = true }, { "CRAFTING_STATION" })
AddRecipe2("obsidianbomb",
	{ Ingredient("coconade", 3, v_atlas), Ingredient("obsidian", 3, v_atlas), Ingredient("dragoonheart", 1, v_atlas) },
	TECH.OBSIDIAN_TWO, { atlas = v_atlas, nounlock = true, numtogive = 3 }, { "CRAFTING_STATION" })
AddRecipe2("book_meteor1", { Ingredient("papyrus", 2), Ingredient("obsidian", 2, v_atlas) }, TECH.SCIENCE_TWO,
	{ atlas = v_atlas, builder_tag = "bookbuilder", }, { "CHARACTER" })
AddRecipe2("wind_conch",
	{ Ingredient("obsidian", 4, v_atlas), Ingredient("purplegem", 1), Ingredient("magic_seal", 1, h_atlas) },
	TECH.OBSIDIAN_TWO, { atlas = v_atlas, nounlock = true }, { "CRAFTING_STATION" })
AddRecipe2("sail_stick",
	{ Ingredient("obsidian", 2, v_atlas), Ingredient("nightmarefuel", 3), Ingredient("magic_seal", 1, h_atlas) },
	TECH.OBSIDIAN_TWO, { atlas = h_atlas, nounlock = true }, { "CRAFTING_STATION" })

--OTHER--
AddRecipe2("machete", { Ingredient("flint", 3), Ingredient("twigs", 1) }, TECH.NONE, { atlas = v_atlas }, { "TOOLS" })
AddRecipe2("goldenmachete", { Ingredient("twigs", 4), Ingredient("goldnugget", 2) }, TECH.SCIENCE_TWO,
	{ atlas = v_atlas },
	{ "TOOLS" })
AddRecipe2("telescope",
	{ Ingredient("goldnugget", 1), Ingredient("pigskin", 1), Ingredient("messagebottleempty1", 1, v_atlas) },
	TECH.SEAFARING_TWO, { atlas = v_atlas }, { "TOOLS" })
AddRecipe2("supertelescope",
	{ Ingredient("telescope", 1, v_atlas), Ingredient("goldnugget", 1), Ingredient("tigereye", 1, v_atlas) },
	TECH.SEAFARING_TWO, { atlas = v_atlas }, { "TOOLS" })
AddRecipe2("monkeyball", { Ingredient("cave_banana", 1), Ingredient("snakeskin", 2, v_atlas), Ingredient("rope", 2) },
	TECH.SCIENCE_ONE, { atlas = v_atlas }, { "TOOLS" })
AddRecipe2("chiminea", { Ingredient("log", 2), Ingredient("limestone", 3, v_atlas), Ingredient("sand", 2, v_atlas) },
	TECH.NONE, { atlas = v_atlas, placer = "chiminea_placer" }, { "LIGHT", "COOKING" })
AddRecipe2("bottlelantern", { Ingredient("messagebottleempty1", 1, v_atlas), Ingredient("bioluminescence", 2, v_atlas) },
	TECH.SCIENCE_TWO, { atlas = v_atlas }, { "LIGHT" })
AddRecipe2("boat_lantern",
	{ Ingredient("messagebottleempty1", 1, v_atlas), Ingredient("twigs", 2), Ingredient("bioluminescence", 1, v_atlas) },
	TECH.SCIENCE_TWO, { atlas = v_atlas }, { "LIGHT", "NAUTICAL" })
AddRecipe2("boat_torch", { Ingredient("torch", 1), Ingredient("twigs", 2) }, TECH.ONE, { atlas = v_atlas },
	{ "LIGHT", "NAUTICAL" })
AddRecipe2("porto_sea_chiminea",
	{ Ingredient("sand", 4, v_atlas), Ingredient("tar", 6, v_atlas), Ingredient("limestone", 6, v_atlas) },
	TECH.SCIENCE_ONE, { atlas = v_atlas, image = "sea_chiminea.tex" }, { "LIGHT" })
AddRecipe2("tarlamp", { Ingredient("seashell", 1, v_atlas), Ingredient("tar", 1, v_atlas) }, TECH.SCIENCE_ONE,
	{ atlas = v_atlas }, { "LIGHT" })
AddRecipe2("obsidianfirepit", { Ingredient("log", 3), Ingredient("obsidian", 8, v_atlas) }, TECH.SCIENCE_TWO,
	{ atlas = v_atlas, placer = "obsidianfirepit_placer" }, { "LIGHT", "COOKING" })
AddRecipe2("porto_researchlab5",
	{ Ingredient("limestone", 4, v_atlas), Ingredient("sand", 2, v_atlas), Ingredient("transistor", 2) },
	TECH.SCIENCE_ONE, { atlas = v_atlas, image = "researchlab5.tex" }, { "PROTOTYPERS" })
AddRecipe2("icemaker", { Ingredient("heatrock", 1), Ingredient("bamboo", 5, v_atlas), Ingredient("transistor", 2) },
	TECH.SCIENCE_TWO, { atlas = v_atlas, placer = "icemaker_placer" }, { "PROTOTYPERS" })
AddRecipe2("quackendrill", { Ingredient("quackenbeak", 1, v_atlas), Ingredient("gears", 1), Ingredient("transistor", 1) },
	TECH.SCIENCE_TWO, { atlas = v_atlas }, { "PROTOTYPERS" })
AddRecipe2("fabric", { Ingredient("bamboo", 3, v_atlas) }, TECH.SCIENCE_ONE, { atlas = v_atlas }, { "REFINE" })
AddRecipe2("messagebottleempty1", { Ingredient("sand", 3, v_atlas) }, TECH.SCIENCE_TWO, { atlas = v_atlas }, { "REFINE" })
AddRecipe2("limestone", { Ingredient("coral", 3, v_atlas) }, TECH.SCIENCE_ONE, { atlas = v_atlas }, { "REFINE" })
AddRecipe2("nubbin", { Ingredient("limestone", 3, v_atlas), Ingredient("corallarve", 1, v_atlas) }, TECH.SCIENCE_ONE,
	{ atlas = v_atlas }, { "REFINE" })
AddRecipe2("ice", { Ingredient("hail_ice", 4, v_atlas) }, TECH.SCIENCE_TWO, { "REFINE" })
AddRecipe2("goldnugget", { Ingredient("dubloon", 3, v_atlas) }, TECH.SCIENCE_ONE, { "REFINE" })
AddRecipe2("spear_poison", { Ingredient("spear", 1), Ingredient("venomgland", 1, v_atlas) }, TECH.SCIENCE_ONE,
	{ atlas = v_atlas }, { "WEAPONS" })
AddRecipe2("cutlass", { Ingredient("goldnugget", 2), Ingredient("twigs", 1), Ingredient("dead_swordfish", 1, v_atlas) },
	TECH.SCIENCE_TWO, { atlas = v_atlas }, { "WEAPONS" })
AddRecipe2("coconade", { Ingredient("coconut", 1, v_atlas), Ingredient("gunpowder", 1), Ingredient("rope", 1) },
	TECH.SCIENCE_ONE, { atlas = v_atlas }, { "WEAPONS" })
AddRecipe2("spear_launcher", { Ingredient("bamboo", 3, v_atlas), Ingredient("jellyfish", 1, v_atlas) }, TECH.SCIENCE_TWO,
	{ atlas = v_atlas }, { "WEAPONS" })
AddRecipe2("blowdart_poison",
	{ Ingredient("cutreeds", 2), Ingredient("venomgland", 1, v_atlas), Ingredient("feather_crow", 1) }, TECH.SCIENCE_ONE,
	{ atlas = v_atlas }, { "WEAPONS" })
AddRecipe2("armor_seashell",
	{ Ingredient("seashell", 10, v_atlas), Ingredient("rope", 1), Ingredient("seaweed", 2, v_atlas) }, TECH.SCIENCE_TWO,
	{ atlas = v_atlas }, { "ARMOUR" })
AddRecipe2("oxhat", { Ingredient("rope", 1), Ingredient("seashell", 4, v_atlas), Ingredient("ox_horn", 1, v_atlas) },
	TECH.SCIENCE_ONE, { atlas = v_atlas }, { "ARMOUR" })
AddRecipe2("armorcactus", { Ingredient("needlespear", 3, v_atlas), Ingredient("armorwood", 1) }, TECH.SCIENCE_TWO,
	{ atlas = v_atlas }, { "ARMOUR" })
AddRecipe2("snakeskinhat", { Ingredient("boneshard", 1), Ingredient("snakeskin", 1, v_atlas), Ingredient("strawhat", 1) },
	TECH.SCIENCE_TWO, { atlas = v_atlas }, { "CLOTHING", "RAIN" })
AddRecipe2("armor_snakeskin",
	{ Ingredient("boneshard", 2), Ingredient("snakeskin", 2, v_atlas), Ingredient("vine", 1, v_atlas) }, TECH
	.SCIENCE_TWO, { atlas = v_atlas }, { "CLOTHING", "RAIN" })
AddRecipe2("palmleaf_umbrella", { Ingredient("twigs", 4), Ingredient("petals", 6), Ingredient("palmleaf", 3, v_atlas) },
	TECH.NONE, { atlas = h_atlas }, { "CLOTHING", "RAIN" })
AddRecipe2("double_umbrellahat",
	{ Ingredient("umbrella", 1), Ingredient("shark_gills", 2, v_atlas), Ingredient("strawhat", 2) }, TECH.SCIENCE_TWO,
	{ atlas = v_atlas }, { "CLOTHING", "RAIN" })
AddRecipe2("aerodynamichat",
	{ Ingredient("coconut", 1, v_atlas), Ingredient("shark_fin", 1, v_atlas), Ingredient("vine", 2, v_atlas) },
	TECH.SCIENCE_TWO, { atlas = v_atlas }, { "CLOTHING" })
AddRecipe2("thatchpack", { Ingredient("palmleaf", 6, v_atlas) }, TECH.NONE, { atlas = v_atlas }, { "CLOTHING" })
AddRecipe2("piratehat", { Ingredient("boneshard", 2), Ingredient("rope", 1), Ingredient("silk", 2) }, TECH.SCIENCE_TWO,
	{ atlas = v_atlas }, { "CLOTHING" })
AddRecipe2("captainhat", { Ingredient("boneshard", 1), Ingredient("seaweed", 1, v_atlas), Ingredient("strawhat", 1) },
	TECH.SCIENCE_TWO, { atlas = v_atlas }, { "CLOTHING" })

AddRecipe2("tarsuit",
	{ Ingredient("tar", 4, v_atlas), Ingredient("fabric", 2, v_atlas), Ingredient("palmleaf", 2, v_atlas) },
	TECH.SCIENCE_ONE, { atlas = v_atlas }, { "CLOTHING", "RAIN" })
AddRecipe2("blubbersuit",
	{ Ingredient("blubber", 4, v_atlas), Ingredient("fabric", 2, v_atlas), Ingredient("palmleaf", 2, v_atlas) },
	TECH.SCIENCE_TWO, { atlas = v_atlas }, { "CLOTHING", "RAIN" })
AddRecipe2("brainjellyhat",
	{ Ingredient("coral_brain", 1, v_atlas), Ingredient("jellyfish", 1, v_atlas), Ingredient("rope", 2) },
	TECH.SCIENCE_TWO, { atlas = v_atlas }, { "CLOTHING" })
AddRecipe2("armor_windbreaker",
	{ Ingredient("blubber", 2, v_atlas), Ingredient("fabric", 1, v_atlas), Ingredient("rope", 1) }, TECH.SCIENCE_TWO,
	{ atlas = h_atlas }, { "CLOTHING", "WINTER" }) -- CHECK  THIS
AddRecipe2("gashat",
	{ Ingredient("coral", 2, h_atlas), Ingredient("messagebottleempty1", 2, v_atlas), Ingredient("jellyfish", 1, h_atlas) },
	TECH.SCIENCE_TWO, { atlas = h_atlas }, { "CLOTHING" })
AddRecipe2("antidote",
	{ Ingredient("venomgland", 1, v_atlas), Ingredient("coral", 2, v_atlas), Ingredient("seaweed", 2, v_atlas) },
	TECH.SCIENCE_ONE, { atlas = v_atlas }, { "RESTORATION" })
AddRecipe2("ox_flute", { Ingredient("ox_horn", 1, v_atlas), Ingredient("nightmarefuel", 2), Ingredient("rope", 1) },
	TECH.MAGIC_TWO, { atlas = v_atlas }, { "MAGIC" })
AddRecipe2("turf_snakeskinfloor", { Ingredient("snakeskin", 2, v_atlas), Ingredient("fabric", 1, v_atlas) },
	TECH.SCIENCE_TWO, { atlas = v_atlas, numtogive = 4 }, { "DECOR" })
AddRecipe2("sand_castle",
	{ Ingredient("sand", 4, v_atlas), Ingredient("palmleaf", 2, v_atlas), Ingredient("seashell", 3, v_atlas) }, TECH
	.NONE, { atlas = v_atlas, placer = "sand_castle_placer" }, { "STRUCTURES" })
AddRecipe2("turf_road", { Ingredient("cutstone", 1), Ingredient("flint", 2) }, TECH.SCIENCE_TWO, { numtogive = 4 },
	{ "DECOR" })
-- if GetModConfigData("kindofworld") == 10 then --WHAT?
-- 	AddRecipe2("turf_road", { Ingredient("boards", 1), Ingredient("turf_magmafield", 1, v_atlas) }, TECH.SCIENCE_TWO,
-- 		{ numtogive = 4 }, { "DECOR" })
-- end

AddRecipe2("dragoonden",
	{ Ingredient("dragoonheart", 1, v_atlas), Ingredient("rocks", 5), Ingredient("obsidian", 4, v_atlas) },
	TECH.SCIENCE_TWO, { atlas = v_atlas, placer = "dragoonden_placer" }, { "STRUCTURES" })
AddRecipe2("wildborehouse",
	{ Ingredient("pigskin", 4), Ingredient("palmleaf", 5, v_atlas), Ingredient("bamboo", 8, v_atlas) }, TECH.SCIENCE_TWO,
	{ atlas = v_atlas, placer = "wildborehouse_placer" }, { "STRUCTURES" })
AddRecipe2("primeapebarrel", { Ingredient("twigs", 10), Ingredient("cave_banana", 3), Ingredient("poop", 4) },
	TECH.SCIENCE_TWO, { atlas = v_atlas, placer = "primeapebarrel_placer" }, { "STRUCTURES" })
AddRecipe2("porto_ballphinhouse",
	{ Ingredient("limestone", 4, v_atlas), Ingredient("seaweed", 4, v_atlas), Ingredient("dorsalfin", 2, v_atlas) },
	TECH.SCIENCE_ONE, { atlas = v_atlas, image = "ballphinhouse.tex" }, { "STRUCTURES" })
AddRecipe2("sandbag_item", { Ingredient("fabric", 2, v_atlas), Ingredient("sand", 3, v_atlas) }, TECH.SCIENCE_TWO,
	{ atlas = v_atlas, numtogive = 4 }, { "STRUCTURES" })
AddRecipe2("doydoynest", { Ingredient("twigs", 8), Ingredient("doydoyfeather", 2, v_atlas), Ingredient("poop", 4) },
	TECH.SCIENCE_TWO, { atlas = v_atlas, placer = "doydoynest_placer" }, { "STRUCTURES" })
AddRecipe2("wall_limestone_item", { Ingredient("limestone", 2, v_atlas) }, TECH.SCIENCE_TWO, {
	atlas = v_atlas,
	numtogive = 4
}, { "STRUCTURES" })
AddRecipe2("wall_enforcedlimestone_item", { Ingredient("limestone", 2, v_atlas), Ingredient("seaweed", 4, v_atlas) },
	TECH.SCIENCE_ONE, { atlas = v_atlas, numtogive = 4 }, { "STRUCTURES" })
AddRecipe2("seasack",
	{ Ingredient("seaweed", 5, v_atlas), Ingredient("vine", 2, v_atlas), Ingredient("shark_gills", 1, v_atlas) },
	TECH.SCIENCE_TWO, { atlas = v_atlas }, { "CONTAINERS" })
AddRecipe2("porto_waterchest1", { Ingredient("boards", 4), Ingredient("tar", 1, v_atlas) }, TECH.SCIENCE_ONE,
	{ atlas = v_atlas, image = "waterchest1.png" }, { "CONTAINERS" })
AddRecipe2("mussel_stick",
	{ Ingredient("bamboo", 2, v_atlas), Ingredient("vine", 1, v_atlas), Ingredient("seaweed", 1, v_atlas) },
	TECH.SCIENCE_ONE, { atlas = v_atlas }, { "GARDENING" })
AddRecipe2("mussel_bed", { Ingredient("mussel", 1, v_atlas), Ingredient("coral", 1, v_atlas) }, TECH.SCIENCE_ONE,
	{ atlas = v_atlas }, { "GARDENING" })
AddRecipe2("porto_fish_farm", { Ingredient("silk", 2), Ingredient("rope", 2), Ingredient("coconut", 4, v_atlas) },
	TECH.SCIENCE_ONE, { atlas = v_atlas, image = "fish_farm.tex" }, { "GARDENING" })
AddRecipe2("doydoyfan", { Ingredient("cutreeds", 2), Ingredient("rope", 2), Ingredient("doydoyfeather", 5, v_atlas) },
	TECH.SCIENCE_TWO, { atlas = v_atlas }, { "SUMMER" })
AddRecipe2("palmleaf_hut",
	{ Ingredient("palmleaf", 4, v_atlas), Ingredient("bamboo", 4, v_atlas), Ingredient("rope", 3) },
	TECH.SCIENCE_TWO, { atlas = h_atlas, placer = "palmleaf_hut_placer" }, { "SUMMER" })

--SEAFARING--
AddRecipe2("boatmetal_item", { Ingredient("alloy", 4, h_atlas), Ingredient("iron", 4, h_atlas) }, TECH.SEAFARING_TWO,
	{ atlas = v_atlas }, { "SEAFARING" })
AddRecipe2("porto_lograft_old", { Ingredient("log", 6), Ingredient("cutgrass", 4) }, TECH.NONE, { atlas = v_atlas },
	{ "NAUTICAL" })
AddRecipe2("porto_raft_old", { Ingredient("bamboo", 4, v_atlas), Ingredient("vine", 3, v_atlas) }, TECH.NONE,
	{ atlas = v_atlas }, { "NAUTICAL" })

-- AddRecipe2("porto_lograft", { Ingredient("log", 6), Ingredient("cutgrass", 4) }, TECH.NONE, { atlas = v_atlas },
-- 	{ "SEAFARING" })
-- AddRecipe2("porto_raft", { Ingredient("bamboo", 4, v_atlas), Ingredient("vine", 3, v_atlas) }, TECH.NONE,
-- 	{ atlas = v_atlas }, { "SEAFARING" })

AddRecipe2("porto_rowboat", { Ingredient("boards", 3), Ingredient("vine", 4, v_atlas) }, TECH.SEAFARING_ONE,
	{ atlas = v_atlas }, { "NAUTICAL" })
AddRecipe2("boatrepairkit", { Ingredient("boards", 2), Ingredient("stinger", 2), Ingredient("rope", 2) },
	TECH.SEAFARING_ONE, { atlas = v_atlas }, { "NAUTICAL" })
AddRecipe2("porto_cargoboat", { Ingredient("boards", 6), Ingredient("rope", 3) }, TECH.SEAFARING_ONE, { atlas = v_atlas },
	{ "NAUTICAL" })
AddRecipe2("porto_armouredboat", { Ingredient("boards", 6), Ingredient("rope", 3), Ingredient("seashell", 10, v_atlas) },
	TECH.SEAFARING_ONE, { atlas = v_atlas }, { "NAUTICAL" })
AddRecipe2("porto_encrustedboat", { Ingredient("boards", 6), Ingredient("limestone", 4, v_atlas), Ingredient("rope", 3) },
	TECH.SEAFARING_ONE, { atlas = v_atlas }, { "NAUTICAL" })
AddRecipe2("sail",
	{ Ingredient("bamboo", 2, v_atlas), Ingredient("vine", 2, v_atlas), Ingredient("palmleaf", 4, v_atlas) },
	TECH.SEAFARING_ONE, { atlas = v_atlas }, { "NAUTICAL" })
AddRecipe2("feathersail",
	{ Ingredient("bamboo", 2, v_atlas), Ingredient("rope", 4), Ingredient("doydoyfeather", 4, v_atlas) },
	TECH.SEAFARING_ONE, { atlas = v_atlas }, { "NAUTICAL" })
AddRecipe2("clothsail", { Ingredient("bamboo", 2, v_atlas), Ingredient("fabric", 2, v_atlas), Ingredient("rope", 2) },
	TECH.SEAFARING_ONE, { atlas = v_atlas }, { "NAUTICAL" })
AddRecipe2("snakeskinsail", { Ingredient("log", 4), Ingredient("rope", 2), Ingredient("snakeskin", 2, v_atlas) },
	TECH.SEAFARING_ONE, { atlas = v_atlas }, { "NAUTICAL" })
AddRecipe2("ironwind",
	{ Ingredient("turbine_blades", 1, v_atlas), Ingredient("transistor", 1), Ingredient("goldnugget", 2) },
	TECH.SEAFARING_TWO, { atlas = v_atlas }, { "NAUTICAL" })
AddRecipe2("malbatrossail",
	{ Ingredient("driftwood_log", 4), Ingredient("rope", 2), Ingredient("malbatross_feather", 4) },
	TECH.SEAFARING_TWO, { atlas = v_atlas }, { "NAUTICAL" })
AddRecipe2("boatcannon", { Ingredient("coconut", 6, v_atlas), Ingredient("log", 5), Ingredient("gunpowder", 4) },
	TECH.SEAFARING_TWO, { atlas = v_atlas }, { "NAUTICAL" })
AddRecipe2("woodlegs_boatcannon",
	{ Ingredient("obsidian", 6, v_atlas), Ingredient("log", 5), Ingredient("gunpowder", 4) },
	TECH.SEAFARING_TWO, { atlas = v_atlas }, { "NAUTICAL" })
AddRecipe2("trawlnet", { Ingredient("bamboo", 2, v_atlas), Ingredient("rope", 3) }, TECH.SEAFARING_TWO,
	{ atlas = v_atlas },
	{ "NAUTICAL" })
AddRecipe2("armor_lifejacket",
	{ Ingredient("fabric", 2, v_atlas), Ingredient("vine", 2, v_atlas), Ingredient("messagebottleempty1", 2, v_atlas) },
	TECH.SEAFARING_TWO, { atlas = v_atlas }, { "NAUTICAL" })
AddRecipe2("seatrap",
	{ Ingredient("palmleaf", 4, v_atlas), Ingredient("messagebottleempty1", 2, v_atlas),
		Ingredient("jellyfish", 1, v_atlas) }, TECH.SEAFARING_TWO, { atlas = v_atlas }, { "NAUTICAL" })
AddRecipe2("porto_buoy",
	{ Ingredient("messagebottleempty1", 1, v_atlas), Ingredient("bamboo", 4, v_atlas),
		Ingredient("bioluminescence", 2, v_atlas) }, TECH.SEAFARING_TWO, { atlas = v_atlas, image = "buoy.tex" },
	{ "LIGHT", "NAUTICAL" })
AddRecipe2("quackeringram",
	{ Ingredient("quackenbeak", 1, v_atlas), Ingredient("bamboo", 4, v_atlas), Ingredient("rope", 4) },
	TECH.SEAFARING_TWO, { atlas = v_atlas }, { "NAUTICAL" })
AddRecipe2("porto_tar_extractor",
	{ Ingredient("coconut", 2, v_atlas), Ingredient("bamboo", 4, v_atlas), Ingredient("limestone", 4, v_atlas) },
	TECH.SEAFARING_TWO, { atlas = v_atlas, image = "tar_extractor.tex" }, { "NAUTICAL" })
AddRecipe2("porto_sea_yard", { Ingredient("limestone", 6, v_atlas), Ingredient("tar", 6, v_atlas), Ingredient("log", 4) },
	TECH.SEAFARING_TWO, { atlas = v_atlas, image = "sea_yard.tex" }, { "NAUTICAL" })

--HAMLET--
-- if GetModConfigData("Hamlet") ~= 5 or GetModConfigData("startlocation") == 15 or GetModConfigData("kindofworld") == 5 then --GetModConfigData("painted_sands")
AddRecipe2("shears", { Ingredient("twigs", 2), Ingredient("iron", 2, h_atlas) }, TECH.SCIENCE_ONE,
	{ atlas = h_atlas },
	{ "TOOLS" })
AddRecipe2("bugrepellent", { Ingredient("tuber_crop", 6, v_atlas), Ingredient("venus_stalk", 1, v_atlas) },
	TECH.SCIENCE_ONE, { atlas = h_atlas }, { "TOOLS" })
AddRecipe2("goldpan", { Ingredient("iron", 2, h_atlas), Ingredient("hammer", 1) }, TECH.SCIENCE_ONE, {
	atlas = h_atlas }, { "TOOLS", "LEGACY" })
AddRecipe2("bathat", { Ingredient("pigskin", 2), Ingredient("batwing", 1), Ingredient("compass", 1) },
	TECH.SCIENCE_TWO, { atlas = h_atlas }, { "LIGHT" })
AddRecipe2("candlehat", { Ingredient("cork", 4, h_atlas), Ingredient("iron", 2, h_atlas) }, TECH.SCIENCE_ONE,
	{ atlas = h_atlas }, { "LIGHT" })
AddRecipe2("glass_shards", { Ingredient("sand", 3, v_atlas) }, TECH.SCIENCE_ONE, { atlas = v_atlas }, { "REFINE" })
--AddRecipe2("goldnugget",			{Ingredient("gold_dust", 6, h_atlas)},  																	TECH.SCIENCE_ONE, {atlas=h_atlas}, {"REFINE"})
AddRecipe2("shard_sword",
	{ Ingredient("glass_shards", 3, v_atlas), Ingredient("nightmarefuel", 2), Ingredient("twigs", 2) },
	TECH.MAGIC_TWO, { atlas = v_atlas }, { "MAGIC" })
AddRecipe2("shard_beak", { Ingredient("glass_shards", 3, v_atlas), Ingredient("crow", 1), Ingredient("twigs", 2) },
	TECH.MAGIC_TWO, { atlas = v_atlas }, { "MAGIC" })
AddRecipe2("armor_weevole", { Ingredient("weevole_carapace", 4, v_atlas), Ingredient("chitin", 2, h_atlas) },
	TECH.SCIENCE_TWO, { atlas = h_atlas }, { "ARMOUR" })
AddRecipe2("antsuit", { Ingredient("chitin", 5, h_atlas), Ingredient("armorwood", 1) }, TECH.SCIENCE_ONE,
	{ atlas = h_atlas }, { "ARMOUR" })
AddRecipe2("antmaskhat", { Ingredient("chitin", 5, h_atlas), Ingredient("footballhat", 1) }, TECH.SCIENCE_ONE,
	{ atlas = h_atlas }, { "ARMOUR" })
AddRecipe2("metalplatehat", { Ingredient("alloy", 3, h_atlas), Ingredient("cork", 3, h_atlas) }, TECH.SCIENCE_ONE,
	{ atlas = h_atlas }, { "ARMOUR" })
AddRecipe2("armor_metalplate", { Ingredient("alloy", 3, h_atlas), Ingredient("hammer", 1) }, TECH.SCIENCE_ONE,
	{ atlas = h_atlas }, { "ARMOUR" })
AddRecipe2("halberd", { Ingredient("alloy", 1, h_atlas), Ingredient("twigs", 2) }, TECH.SCIENCE_ONE, {
	atlas =
		h_atlas
}, { "WEAPONS" })
AddRecipe2("cork_bat", { Ingredient("cork", 3, h_atlas), Ingredient("boards", 1) }, TECH.SCIENCE_ONE, {
	atlas =
		h_atlas
}, { "WEAPONS" })
AddRecipe2("blunderbuss", { Ingredient("oinc10", 1, h_atlas), Ingredient("boards", 2), Ingredient("gears", 1) },
	TECH.SCIENCE_ONE, { atlas = h_atlas }, { "WEAPONS" })
AddRecipe2("corkchest", { Ingredient("cork", 2, h_atlas), Ingredient("rope", 1) }, TECH.SCIENCE_ONE,
	{ atlas = h_atlas, min_spacing = 1, placer = "corkchest_placer" }, { "CONTAINERS" })
AddRecipe2("roottrunk_child",
	{ Ingredient("bramble_bulb", 1, h_atlas), Ingredient("venus_stalk", 2, v_atlas), Ingredient("boards", 2) },
	TECH.SCIENCE_ONE, { atlas = h_atlas, min_spacing = 1, placer = "roottrunk_child_placer" }, { "CONTAINERS" })
AddRecipe2("basefan", { Ingredient("alloy", 2, h_atlas), Ingredient("transistor", 2), Ingredient("gears", 1) },
	TECH.SCIENCE_TWO, { atlas = h_atlas, placer = "basefan_placer" }, { "PROTOTYPERS" })
AddRecipe2("sprinkler1", { Ingredient("alloy", 2, h_atlas), Ingredient("bluegem", 1), Ingredient("ice", 6) },
	TECH.SCIENCE_TWO, { atlas = h_atlas, placer = "sprinkler1_placer" }, { "GARDENING" })
AddRecipe2("smelter", { Ingredient("cutstone", 6), Ingredient("boards", 4), Ingredient("redgem", 1) },
	TECH.SCIENCE_TWO, { atlas = h_atlas, placer = "smetler_placer" }, { "PROTOTYPERS" })
AddRecipe2("ballpein_hammer", { Ingredient("iron", 2, h_atlas), Ingredient("twigs", 1) }, TECH.SCIENCE_ONE,
	{ atlas = h_atlas }, { "TOOLS", "LEGACY" })
AddRecipe2("magnifying_glass", { Ingredient("iron", 1, h_atlas), Ingredient("twigs", 1), Ingredient("bluegem", 1) },
	TECH.SCIENCE_TWO, { atlas = h_atlas }, { "TOOLS", "LEGACY" })
AddRecipe2("disguisehat", { Ingredient("twigs", 2), Ingredient("pigskin", 1), Ingredient("beardhair", 1) },
	TECH.SCIENCE_TWO, { atlas = h_atlas }, { "CLOTHING" })
AddRecipe2("pithhat",
	{ Ingredient("fabric", 1, v_atlas), Ingredient("vine", 3, v_atlas), Ingredient("cork", 6, h_atlas) },
	TECH.SCIENCE_TWO, { atlas = h_atlas }, { "CLOTHING" })
AddRecipe2("thunderhat",
	{ Ingredient("feather_thunder", 1, h_atlas), Ingredient("goldnugget", 1), Ingredient("cork", 2, h_atlas) },
	TECH.SCIENCE_TWO, { atlas = h_atlas }, { "CLOTHING" })
AddRecipe2("gasmaskhat",
	{ Ingredient("peagawkfeather", 4, h_atlas), Ingredient("fabric", 1, h_atlas), Ingredient("pigskin", 1) },
	TECH.SCIENCE_ONE, { atlas = h_atlas }, { "CLOTHING" })
AddRecipe2("corkboatitem", { Ingredient("rope", 1), Ingredient("cork", 4, h_atlas) }, TECH.NONE, { atlas = h_atlas },
	{ "NAUTICAL" })
-- end


-- AddRecipe2("antler",
-- 	{ Ingredient("hippo_antler", 1, h_atlas), Ingredient("bill_quill", 3, h_atlas), Ingredient("flint", 1) },
-- 	TECH.SCIENCE_TWO, { atlas = h_atlas }, { "TOOLS" })


if TUNING.tropical.startlocation == "hamlet" and TUNING.tropical.hamlet then
	AddRecipe2("researchlab4",
		{ Ingredient("pigskin", 4), Ingredient("boards", 4), Ingredient("feather_robin_winter", 2) },
		TECH.SCIENCE_TWO, { placer = "researchlab4_placer" }, { "MAGIC" })
end

if TUNING.tropical.startlocation == "shipwrecked" and TUNING.tropical.shipwrecked then
	AddRecipe2("researchlab4",
		{ Ingredient("piratehat", 1, v_atlas), Ingredient("boards", 4), Ingredient("parrot_pirate", 1, v_atlas) },
		TECH.SCIENCE_TWO, { placer = "researchlab4_placer" }, { "MAGIC" })
end



--CITY----------------------------


AddRecipe2("city_hammer", { Ingredient("iron", 2, h_atlas), Ingredient("twigs", 1) }, TECH.CITY_ONE,
	{ atlas = h_atlas, --[[nounlock = true]] }, { "HAMLET" })
AddRecipe2("securitycontract", { Ingredient("oinc", 10, h_atlas) }, TECH.CITY_ONE, { atlas = h_atlas, nounlock = false },
	{ "HAMLET" })
AddRecipe2("city_lamp", { Ingredient("alloy", 1, h_atlas), Ingredient("transistor", 1), Ingredient("lantern", 1) },
	TECH.CITY_ONE,
	{ atlas = h_atlas, nounlock = false, min_spacing = 1, placer = "city_lamp_placer", image = "city_lamp.tex" },
	{ "HAMLET" })
AddRecipe2("playerhouse_city",
	{ Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("oinc", 30, h_atlas) }, TECH.CITY_ONE,
	{
		atlas = hm_atlas,
		nounlock = false,
		min_spacing = 3.2,
		placer = "playerhouse_city_placer",
		image = "pig_house_sale.png",
		--[[build_mode = BUILDMODE.WATER]]
	},
	{ "HAMLET" })
AddRecipe2("pighouse_city", { Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4) },
	TECH.CITY_ONE,
	{ atlas = h_atlas, nounlock = false, min_spacing = 3.2, placer = "pighouse_city_placer", image = "pighouse_city.tex" },
	{ "HAMLET" })
AddRecipe2("pig_shop_deli_entrance", { Ingredient("boards", 4), Ingredient("honeyham", 1), Ingredient("pigskin", 4) },
	TECH.CITY_ONE,
	{ atlas = hm_atlas, nounlock = false, min_spacing = 3.2, placer = "pig_shop_deli_placer", image = "pig_shop_deli.png" },
	{ "HAMLET" })
AddRecipe2("pig_shop_general_entrance", { Ingredient("boards", 4), Ingredient("axe", 3), Ingredient("pigskin", 4) },
	TECH.CITY_ONE,
	{
		atlas = hm_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "pig_shop_general_placer",
		image = "pig_shop_general.png"
	}, { "HAMLET" })
AddRecipe2("pig_shop_hoofspa_entrance", { Ingredient("boards", 4), Ingredient("bandage", 3), Ingredient("pigskin", 4) },
	TECH.CITY_ONE,
	{
		atlas = hm_atlas,
		nounlock = false,
		min_spacing = 3.2,
		placer = "pig_shop_hoofspa_placer",
		image = "pig_shop_hoofspa.png"
	}, { "HAMLET" })
AddRecipe2("pig_shop_produce_entrance", { Ingredient("boards", 4), Ingredient("eggplant", 3), Ingredient("pigskin", 4) },
	TECH.CITY_ONE,
	{
		atlas = hm_atlas,
		nounlock = false,
		min_spacing = 3.2,
		placer = "pig_shop_produce_placer",
		image = "pig_shop_produce.png"
	}, { "HAMLET" })
AddRecipe2("pig_shop_florist_entrance", { Ingredient("boards", 4), Ingredient("petals", 12), Ingredient("pigskin", 4) },
	TECH.CITY_ONE,
	{
		atlas = hm_atlas,
		nounlock = false,
		min_spacing = 3.2,
		placer = "pig_shop_florist_placer",
		image = "pig_shop_florist.png"
	}, { "HAMLET" })
AddRecipe2("pig_antiquities_entrance",
	{ Ingredient("boards", 4), Ingredient("ballpein_hammer", 3, h_atlas), Ingredient("pigskin", 4) }, TECH.CITY_ONE,
	{
		atlas = hm_atlas,
		nounlock = false,
		min_spacing = 3.2,
		placer = "pig_shop_antiquities_placer",
		image = "pig_shop_antiquities.png"
	}, { "HAMLET" })
AddRecipe2("pig_shop_arcane_entrance",
	{ Ingredient("boards", 4), Ingredient("nightmarefuel", 1), Ingredient("pigskin", 4) }, TECH.CITY_ONE,
	{
		atlas = hm_atlas,
		nounlock = false,
		min_spacing = 3.2,
		placer = "pig_shop_arcane_placer",
		image =
		"pig_shop_arcane.png"
	}, { "HAMLET" })
AddRecipe2("pig_shop_weapons_entrance", { Ingredient("boards", 4), Ingredient("spear", 3), Ingredient("pigskin", 4) },
	TECH.CITY_ONE,
	{
		atlas = hm_atlas,
		nounlock = false,
		min_spacing = 3.2,
		placer = "pig_shop_weapons_placer",
		image = "pig_shop_weapons.png"
	}, { "HAMLET" })
AddRecipe2("pig_academy_entrance", { Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4) },
	TECH.CITY_ONE,
	{
		atlas = hm_atlas,
		nounlock = false,
		min_spacing = 3.2,
		placer = "pig_shop_academy_placer",
		image = "pig_shop_academy.png"
	}, { "HAMLET" })
AddRecipe2("hatshop_entrance", { Ingredient("boards", 4), Ingredient("tophat", 2), Ingredient("pigskin", 4) },
	TECH.CITY_ONE,
	{
		atlas = hm_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "pig_shop_hatshop_placer",
		image = "pig_shop_hatshop.png"
	}, { "HAMLET" })
AddRecipe2("pig_shop_bank_entrance",
	{ Ingredient("cutstone", 4), Ingredient("oinc", 100, h_atlas), Ingredient("pigskin", 4) }, TECH.CITY_ONE,
	{ atlas = hm_atlas, nounlock = false, min_spacing = 3.2, placer = "pig_shop_bank_placer", image = "pig_shop_bank.png" },
	{ "HAMLET" })
AddRecipe2("pig_shop_tinker_entrance", { Ingredient("magnifying_glass", 2, h_atlas), Ingredient("pigskin", 4) },
	TECH.CITY_ONE,
	{
		atlas = hm_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "pig_shop_tinker_placer",
		image =
		"pig_shop_tinker.png"
	}, { "HAMLET" })
AddRecipe2("pig_shop_cityhall_player_entrance",
	{ Ingredient("boards", 4), Ingredient("goldnugget", 4), Ingredient("pigskin", 4) }, TECH.CITY_ONE,
	{
		atlas = hm_atlas,
		nounlock = false,
		min_spacing = 3.2,
		placer = "pig_shop_cityhall_placer",
		image = "pig_shop_cityhall.png"
	}, { "HAMLET" })
AddRecipe2("pig_guard_tower", { Ingredient("cutstone", 3), Ingredient("halberd", 1, h_atlas), Ingredient("pigskin", 4) },
	TECH.CITY_ONE, { atlas = h_atlas, nounlock = false, min_spacing = 3.2, placer = "pig_guard_tower_placer" },
	{ "HAMLET" })
AddRecipe2("hedge_block", { Ingredient("clippings", 3, h_atlas), Ingredient("nitre", 1) }, TECH.CITY_ONE,
	{ atlas = v_atlas, nounlock = false, min_spacing = 1, placer = "hedge_block_placer" }, { "HAMLET" })
AddRecipe2("hedge_cone", { Ingredient("clippings", 3, h_atlas), Ingredient("nitre", 1) }, TECH.CITY_ONE,
	{ atlas = v_atlas, nounlock = false, min_spacing = 1, placer = "hedge_cone_placer" }, { "HAMLET" })
AddRecipe2("hedge_layered", { Ingredient("clippings", 3, h_atlas), Ingredient("nitre", 1) }, TECH.CITY_ONE,
	{ atlas = v_atlas, nounlock = false, min_spacing = 1, placer = "hedge_layered_placer" }, { "HAMLET" })
AddRecipe2("pig_guard_tower_palace",
	{ Ingredient("cutstone", 5), Ingredient("halberd", 1, h_atlas), Ingredient("pigskin", 4) }, TECH.CITY_ONE,
	{
		atlas = hm_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "pig_guard_tower_palace_placer",
		image = "pig_royal_tower.png"
	}, { "HAMLET" })
AddRecipe2("lawnornament_1", { Ingredient("cutstone", 2), Ingredient("oinc", 7, h_atlas) }, TECH.CITY_ONE,
	{ atlas = hm_atlas, nounlock = false, min_spacing = 1, placer = "lawnornament_1_placer", image = "lawnornament_1.png" },
	{ "HAMLET" })
AddRecipe2("lawnornament_2", { Ingredient("cutstone", 2), Ingredient("oinc", 7, h_atlas) }, TECH.CITY_ONE,
	{ atlas = hm_atlas, nounlock = false, min_spacing = 1, placer = "lawnornament_2_placer", image = "lawnornament_2.png" },
	{ "HAMLET" })
AddRecipe2("lawnornament_3", { Ingredient("cutstone", 2), Ingredient("oinc", 7, h_atlas) }, TECH.CITY_ONE,
	{ atlas = hm_atlas, nounlock = false, min_spacing = 1, placer = "lawnornament_3_placer", image = "lawnornament_3.png" },
	{ "HAMLET" })
AddRecipe2("lawnornament_4", { Ingredient("cutstone", 2), Ingredient("oinc", 7, h_atlas) }, TECH.CITY_ONE,
	{ atlas = hm_atlas, nounlock = false, min_spacing = 1, placer = "lawnornament_4_placer", image = "lawnornament_4.png" },
	{ "HAMLET" })
AddRecipe2("lawnornament_5", { Ingredient("cutstone", 2), Ingredient("oinc", 7, h_atlas) }, TECH.CITY_ONE,
	{ atlas = hm_atlas, nounlock = false, min_spacing = 1, placer = "lawnornament_5_placer", image = "lawnornament_5.png" },
	{ "HAMLET" })
AddRecipe2("lawnornament_6", { Ingredient("cutstone", 2), Ingredient("oinc", 7, h_atlas) }, TECH.CITY_ONE,
	{ atlas = hm_atlas, nounlock = false, min_spacing = 1, placer = "lawnornament_6_placer", image = "lawnornament_6.png" },
	{ "HAMLET" })
AddRecipe2("lawnornament_7", { Ingredient("cutstone", 2), Ingredient("oinc", 7, h_atlas) }, TECH.CITY_ONE,
	{ atlas = hm_atlas, nounlock = false, min_spacing = 1, placer = "lawnornament_7_placer", image = "lawnornament_7.png" },
	{ "HAMLET" })
AddRecipe2("topiary_1", { Ingredient("cutstone", 2), Ingredient("oinc", 9, h_atlas) }, TECH.CITY_ONE,
	{ atlas = hm_atlas, nounlock = false, min_spacing = 1, placer = "topiary_1_placer", image = "topiary_1.png" },
	{ "HAMLET" })
AddRecipe2("topiary_2", { Ingredient("cutstone", 2), Ingredient("oinc", 9, h_atlas) }, TECH.CITY_ONE,
	{ atlas = hm_atlas, nounlock = false, min_spacing = 1, placer = "topiary_2_placer", image = "topiary_2.png" },
	{ "HAMLET" })
AddRecipe2("topiary_3", { Ingredient("cutstone", 2), Ingredient("oinc", 9, h_atlas) }, TECH.CITY_ONE,
	{ atlas = hm_atlas, nounlock = false, min_spacing = 1, placer = "topiary_3_placer", image = "topiary_3.png" },
	{ "HAMLET" })
AddRecipe2("topiary_4", { Ingredient("cutstone", 2), Ingredient("oinc", 9, h_atlas) }, TECH.CITY_ONE,
	{ atlas = hm_atlas, nounlock = false, min_spacing = 1, placer = "topiary_4_placer", image = "topiary_4.png" },
	{ "HAMLET" })
AddRecipe2("turf_foundation", { Ingredient("cutstone", 1) }, TECH.CITY_ONE, {
	atlas = v_atlas,
	nounlock = false,
	numtogive = 4
}, { "HAMLET" })
AddRecipe2("turf_cobbleroad", { Ingredient("cutstone", 2), Ingredient("boards", 1) }, TECH.CITY_ONE,
	{ atlas = v_atlas, nounlock = false, numtogive = 4 }, { "HAMLET" })
AddRecipe2("turf_checkeredlawn", { Ingredient("cutgrass", 2), Ingredient("nitre", 1) }, TECH.CITY_ONE,
	{ atlas = v_atlas, nounlock = false, numtogive = 4 }, { "HAMLET" })

--TURFS--
AddRecipe2("turf_magmafield", { Ingredient("rocks", 2), Ingredient("ash", 1) }, TECH.TURFCRAFTING_ONE,
	{ numtogive = 4, atlas = v_atlas }, { "DECOR" })
AddRecipe2("turf_ash", { Ingredient("ash", 3) }, TECH.TURFCRAFTING_ONE, { numtogive = 4, atlas = v_atlas }, { "DECOR" })
AddRecipe2("turf_jungle", { Ingredient("bamboo", 1, v_atlas), Ingredient("cutgrass", 1) }, TECH.TURFCRAFTING_ONE,
	{ numtogive = 4, atlas = v_atlas }, { "DECOR" })
AddRecipe2("turf_volcano", { Ingredient("nitre", 2), Ingredient("ash", 1) }, TECH.TURFCRAFTING_ONE,
	{ numtogive = 4, atlas = v_atlas }, { "DECOR" })
AddRecipe2("turf_tidalmarsh", { Ingredient("cutgrass", 2), Ingredient("nitre", 1) }, TECH.TURFCRAFTING_ONE,
	{ numtogive = 4, atlas = v_atlas }, { "DECOR" })
AddRecipe2("turf_meadow", { Ingredient("cutgrass", 2) }, TECH.TURFCRAFTING_ONE, { numtogive = 4, atlas = v_atlas },
	{ "DECOR" })
AddRecipe2("turf_beach", { Ingredient("sand", 2, v_atlas) }, TECH.TURFCRAFTING_ONE, { numtogive = 4, atlas = v_atlas },
	{ "DECOR" })
AddRecipe2("turf_quagmire_gateway", { Ingredient("cutgrass", 2), Ingredient("nitre", 1) }, TECH.TURFCRAFTING_ONE,
	{ numtogive = 4, atlas = "images/inventoryimages/novositens.xml" }, { "DECOR" })
AddRecipe2("turf_quagmire_citystone", { Ingredient("cutgrass", 2), Ingredient("nitre", 1) }, TECH.TURFCRAFTING_ONE,
	{ numtogive = 4, atlas = "images/inventoryimages/novositens.xml" }, { "DECOR" })
AddRecipe2("turf_quagmire_parkfield", { Ingredient("cutgrass", 2), Ingredient("nitre", 1) }, TECH.TURFCRAFTING_ONE,
	{ numtogive = 4, atlas = "images/inventoryimages/novositens.xml" }, { "DECOR" })
AddRecipe2("turf_quagmire_parkstone", { Ingredient("cutgrass", 2), Ingredient("nitre", 1) }, TECH.TURFCRAFTING_ONE,
	{ numtogive = 4, atlas = "images/inventoryimages/novositens.xml" }, { "DECOR" })
AddRecipe2("turf_quagmire_peatforest", { Ingredient("cutgrass", 2), Ingredient("nitre", 1) }, TECH.TURFCRAFTING_ONE,
	{ numtogive = 4, atlas = "images/inventoryimages/novositens.xml" }, { "DECOR" })
--[[
AddRecipe2("turf_fields", 				{Ingredient("oinc", 1, h_atlas)},			 					TECH.TURFCRAFTING_ONE,  {numtogive=4, atlas=h_atlas}, {"DECOR"})
AddRecipe2("turf_suburb", 				{Ingredient("oinc", 1, h_atlas)}, 						        TECH.TURFCRAFTING_ONE,  {numtogive=4, atlas=h_atlas}, {"DECOR"})
AddRecipe2("turf_gasjungle", 			{Ingredient("oinc", 1, h_atlas)}, 						      	TECH.TURFCRAFTING_ONE,  {numtogive=4, atlas=h_atlas}, {"DECOR"})
AddRecipe2("turf_checkeredlawn", 		{Ingredient("oinc", 1, h_atlas)}, 						  		TECH.TURFCRAFTING_ONE,  {numtogive=4, atlas=h_atlas}, {"DECOR"})
AddRecipe2("turf_deeprainforest", 		{Ingredient("oinc", 1, h_atlas)}, 						 		TECH.TURFCRAFTING_ONE,  {numtogive=4, atlas=h_atlas}, {"DECOR"})
AddRecipe2("turf_rainforest", 			{Ingredient("oinc", 1, h_atlas)}, 						     	TECH.TURFCRAFTING_ONE,  {numtogive=4, atlas=h_atlas}, {"DECOR"})
AddRecipe2("turf_pigruins", 			{Ingredient("oinc", 1, h_atlas)}, 						       	TECH.TURFCRAFTING_ONE,  {numtogive=4, atlas=h_atlas}, {"DECOR"})
AddRecipe2("turf_antfloor", 			{Ingredient("oinc", 1, h_atlas)}, 						       	TECH.TURFCRAFTING_ONE,  {numtogive=4, atlas=h_atlas}, {"DECOR"})
AddRecipe2("turf_batfloor", 			{Ingredient("oinc", 1, h_atlas)}, 						       	TECH.TURFCRAFTING_ONE,  {numtogive=4, atlas=h_atlas}, {"DECOR"})
AddRecipe2("turf_battleground", 		{Ingredient("oinc", 1, h_atlas)}, 						   		TECH.TURFCRAFTING_ONE,  {numtogive=4, atlas=h_atlas}, {"DECOR"})
AddRecipe2("turf_painted", 				{Ingredient("oinc", 1, h_atlas)}, 						        TECH.TURFCRAFTING_ONE,  {numtogive=4, atlas=h_atlas}, {"DECOR"})
AddRecipe2("turf_plains", 				{Ingredient("oinc", 1, h_atlas)}, 						        TECH.TURFCRAFTING_ONE,  {numtogive=4, atlas=h_atlas}, {"DECOR"})
AddRecipe2("turf_beardrug", 			{Ingredient("oinc", 1, h_atlas)}, 								TECH.TURFCRAFTING_ONE,  {numtogive=4, atlas=h_atlas}, {"DECOR"})
]]
--GORGE--
-- AddRecipe2("dubloon", { Ingredient("quagmire_coin1", 2) }, TECH.GORGE_TWO, { atlas = h_atlas, nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("oinc", { Ingredient("quagmire_coin1", 2) }, TECH.GORGE_TWO, { atlas = h_atlas, nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_coin1", { Ingredient("quagmire_coin2", 1) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_coin2", { Ingredient("quagmire_coin1", 5) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_crate_pot_hanger", { Ingredient("quagmire_coin1", 6) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_crate_oven", { Ingredient("quagmire_coin1", 6) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_crate_grill_small", { Ingredient("quagmire_coin1", 6) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_crate_grill", { Ingredient("quagmire_coin1", 8) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("pot_syrup", { Ingredient("quagmire_coin1", 4) }, TECH.GORGE_TWO,
-- 	{ nounlock = true, image = "quagmire_pot_syrup.tex" }, { "CRAFTING_STATION" })
-- AddRecipe2("pot", { Ingredient("quagmire_coin2", 4) }, TECH.GORGE_TWO, { nounlock = true, image = "quagmire_pot.tex" },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("casseroledish", { Ingredient("quagmire_coin1", 4) }, TECH.GORGE_TWO,
-- 	{ nounlock = true, image = "quagmire_casseroledish.tex" }, { "CRAFTING_STATION" })
-- AddRecipe2("plate_silver", { Ingredient("quagmire_coin2", 3) }, TECH.GORGE_TWO, { atlas = g_atlas, nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("bowl_silver", { Ingredient("quagmire_coin2", 3) }, TECH.GORGE_TWO, { atlas = g_atlas, nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_key_park", { Ingredient("quagmire_coin1", 10) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_salt_rack_item", { Ingredient("quagmire_coin1", 8) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_slaughtertool", { Ingredient("quagmire_coin2", 1) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_sapbucket", { Ingredient("quagmire_coin1", 3) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_safe", { Ingredient("quagmire_coin1", 20) }, TECH.GORGE_TWO,
-- 	{ atlas = safe_atlas, nounlock = true, placer = "quagmire_safe_placer", image = "quagmire_safe.tex" },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_goatmilk", { Ingredient("quagmire_coin2", 3) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_seedpacket_1", { Ingredient("quagmire_coin1", 1) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_seedpacket_2", { Ingredient("quagmire_coin1", 1) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_seedpacket_3", { Ingredient("quagmire_coin1", 1) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_seedpacket_4", { Ingredient("quagmire_coin1", 1) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_seedpacket_5", { Ingredient("quagmire_coin1", 1) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_seedpacket_6", { Ingredient("quagmire_coin1", 1) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_seedpacket_7", { Ingredient("quagmire_coin1", 1) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })
-- AddRecipe2("quagmire_seedpacket_mix", { Ingredient("quagmire_coin1", 1) }, TECH.GORGE_TWO, { nounlock = true },
-- 	{ "CRAFTING_STATION" })


--INTERIOR--
AddRecipe2("stone_door", { Ingredient("oinc", 25, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = true,
		image = "stone_door.tex",
		min_spacing = 1,
		placer = "stone_door_placer",
		build_mode = "insidedoor"
	},
	{ "INTERIOR" })
AddRecipe2("plate_door", { Ingredient("oinc", 25, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = true,
		image = "plate_door.tex",
		min_spacing = 1,
		placer = "plate_door_placer",
		build_mode = "insidedoor"
	}, { "INTERIOR" })
AddRecipe2("organic_door", { Ingredient("oinc", 25, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = true,
		image = "organic_door.tex",
		min_spacing = 1,
		placer = "organic_door_placer",
		build_mode = "insidedoor"
	}, { "INTERIOR" })
AddRecipe2("round_door", { Ingredient("oinc", 25, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = true,
		image = "round_door.tex",
		min_spacing = 1,
		placer = "round_door_placer",
		build_mode = "insidedoor"
	}, { "INTERIOR" })


AddRecipe2("interior_floor_wood", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE, { atlas = h_atlas, nounlock = true },
	{ "INTERIOR" })
AddRecipe2("interior_floor_check", { Ingredient("oinc", 7, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true },
	{ "INTERIOR" })
AddRecipe2("interior_floor_plaid_tile", { Ingredient("oinc", 10, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true }, { "INTERIOR" })
AddRecipe2("interior_floor_sheet_metal", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true }, { "INTERIOR" })
AddRecipe2("interior_floor_transitional", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true }, { "INTERIOR" })
AddRecipe2("interior_floor_woodpanels", { Ingredient("oinc", 10, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true }, { "INTERIOR" })
AddRecipe2("interior_floor_herringbone", { Ingredient("oinc", 12, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true }, { "INTERIOR" })
AddRecipe2("interior_floor_hexagon", { Ingredient("oinc", 12, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true },
	{ "INTERIOR" })
AddRecipe2("interior_floor_hoof_curvy", { Ingredient("oinc", 12, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true }, { "INTERIOR" })
AddRecipe2("interior_floor_octagon", { Ingredient("oinc", 12, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true },
	{ "INTERIOR" })

AddRecipe2("interior_wall_checkered_metal", { Ingredient("oinc", 1, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true }, { "INTERIOR" })
AddRecipe2("interior_wall_circles", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true },
	{ "INTERIOR" })
AddRecipe2("interior_wall_marble", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true },
	{ "INTERIOR" })
AddRecipe2("interior_wall_sunflower", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true },
	{ "INTERIOR" })
AddRecipe2("interior_wall_wood", { Ingredient("oinc", 10, h_atlas) }, TECH.HOME_ONE, { atlas = h_atlas, nounlock = true },
	{ "INTERIOR" })
AddRecipe2("interior_wall_mayorsoffice", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true }, { "INTERIOR" })
AddRecipe2("interior_wall_harlequin", { Ingredient("oinc", 4, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true },
	{ "INTERIOR" })
AddRecipe2("interior_wall_fullwall_moulding", { Ingredient("oinc", 4, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true }, { "INTERIOR" })
AddRecipe2("interior_wall_floral", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true },
	{ "INTERIOR" })
AddRecipe2("interior_wall_upholstered", { Ingredient("oinc", 10, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true }, { "INTERIOR" })

---------------wall ornament---------------
-- AddRecipe2("reno_wallornament_photo", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE,
-- 	{ atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_wallornament_embroidery_hoop", { Ingredient("oinc", 3, h_atlas) }, TECH.HOME_ONE,
-- 	{ atlas = h_atlas, nounlock = true }, { "INTERIOR" })
-- AddRecipe2("reno_wallornament_mosaic", { Ingredient("oinc", 4, h_atlas) }, TECH.HOME_ONE, {
-- 	atlas = h_atlas,
-- 	nounlock = true
-- }, { "INTERIOR" })
-- AddRecipe2("reno_wallornament_wreath", { Ingredient("oinc", 4, h_atlas) }, TECH.HOME_ONE, {
-- 	atlas = h_atlas,
-- 	nounlock = true
-- }, { "INTERIOR" })
-- AddRecipe2("reno_wallornament_axe", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
-- 	{ atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_wallornament_hunt", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
-- 	{ atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_wallornament_periodic_table", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
-- 	{ atlas = h_atlas, nounlock = true }, { "INTERIOR" })
-- AddRecipe2("reno_wallornament_gears_art", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
-- 	{ atlas = h_atlas, nounlock = true }, { "INTERIOR" })
-- AddRecipe2("reno_wallornament_cape", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
-- 	{ atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_wallornament_no_smoking", { Ingredient("oinc", 3, h_atlas) }, TECH.HOME_ONE,
-- 	{ atlas = h_atlas, nounlock = true }, { "INTERIOR" })
-- AddRecipe2("reno_wallornament_black_cat", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
-- 	{ atlas = h_atlas, nounlock = true }, { "INTERIOR" })

-- AddRecipe2("reno_antiquities_wallfish", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE, {
-- 	atlas = h_atlas,
-- 	nounlock = true
-- }, { "INTERIOR" })
-- AddRecipe2("reno_antiquities_beefalo", { Ingredient("oinc", 10, h_atlas) }, TECH.HOME_ONE, {
-- 	atlas = h_atlas,
-- 	nounlock = true
-- }, { "INTERIOR" })

----------------------new windows------------------
local function AddWallSectionRecipe(name, oincvalue, data)
	local presetoincvalue = oincvalue or 5
	local prefabname = ((name:find("wallornament") or name:find("antiquities")) and ("deco_" .. name)) or name
	AddRecipe2(prefabname,
		{ Ingredient("oinc", presetoincvalue, h_atlas) }, TECH.HOME_ONE,
		{
			atlas = h_atlas,
			nounlock = true,
			build_mode = data and data.buildmode or "wallsection",
			min_spacing = 0,
			placer = prefabname .. "_placer",
			image = "reno_" .. name .. ".tex"
		},
		{ "INTERIOR" })
end

-- AddWallSectionRecipe("window_round", 3) ----------------这俩没制作栏贴图
-- AddWallSectionRecipe("window_round_curtains_nails", 4)
AddWallSectionRecipe("window_round_burlap", 4)

AddWallSectionRecipe("window_small_peaked", 3)
AddWallSectionRecipe("window_small_peaked_curtain", 4)

AddWallSectionRecipe("window_large_square", 4)
AddWallSectionRecipe("window_large_square_curtain", 5)

AddWallSectionRecipe("window_tall", 4)
AddWallSectionRecipe("window_tall_curtain", 5)

AddWallSectionRecipe("window_greenhouse", 8)

AddWallSectionRecipe("wallornament_axe", 5)
AddWallSectionRecipe("wallornament_photo", 2)
AddWallSectionRecipe("wallornament_embroidery_hoop", 3)
AddWallSectionRecipe("wallornament_mosaic", 4)
AddWallSectionRecipe("wallornament_wreath", 4)
AddWallSectionRecipe("wallornament_hunt", 5)
AddWallSectionRecipe("wallornament_periodic_table", 5)
AddWallSectionRecipe("wallornament_gears_art", 8)
AddWallSectionRecipe("wallornament_cape", 5)
AddWallSectionRecipe("wallornament_no_smoking", 3)
AddWallSectionRecipe("wallornament_black_cat", 5)
AddWallSectionRecipe("antiquities_wallfish", 5)
AddWallSectionRecipe("antiquities_beefalo", 10)
AddWallSectionRecipe("wallornament_fulllength_mirror", 10)
-- AddRecipe2("reno_antiquities_beefalo", { Ingredient("oinc", 10, h_atlas) }, TECH.HOME_ONE, {

-- AddWallSectionRecipe("wallornament_chalkboard") -----这些没有制作栏贴图
-- AddWallSectionRecipe("wallornament_whiteboard")
-- AddWallSectionRecipe("wallornament_fulllength_mirror")
-- AddWallSectionRecipe("wallornament_cage")
-- AddWallSectionRecipe("wallornament_shield03")
-- AddWallSectionRecipe("wallornament_shield02")
-- AddWallSectionRecipe("wallornament_shield")
-- AddWallSectionRecipe("wallornament_spears")
-- AddWallSectionRecipe("wallornament_violet")



local function AddShelfRecipe(name, oincvalue)
	local presetoincvalue = oincvalue or 5
	local prefabname = ((name:find("wallornament") or name:find("antiquities")) and ("deco_" .. name)) or name
	AddRecipe2(prefabname,
		{ Ingredient("oinc", presetoincvalue, h_atlas) }, TECH.HOME_ONE,
		{
			atlas = h_atlas,
			nounlock = true,
			-- build_mode = data and data.buildmode or "wallsection",
			min_spacing = 3.2,
			placer = prefabname .. "_placer",
			image = "reno_" .. name .. ".tex"
		},
		{ "INTERIOR" })
end

AddShelfRecipe("shelves_wood", 2)
AddShelfRecipe("shelves_basic")
AddShelfRecipe("shelves_floating")
AddShelfRecipe("shelves_wood")
AddShelfRecipe("shelves_basic")
AddShelfRecipe("shelves_marble")
AddShelfRecipe("shelves_glass")
AddShelfRecipe("shelves_ladder")
AddShelfRecipe("shelves_hutch")
AddShelfRecipe("shelves_industrial")
AddShelfRecipe("shelves_adjustable")
AddShelfRecipe("shelves_fridge")
AddShelfRecipe("shelves_cinderblocks")
AddShelfRecipe("shelves_midcentury")
AddShelfRecipe("shelves_wallmount")
AddShelfRecipe("shelves_aframe")
AddShelfRecipe("shelves_crates")
-- AddShelfRecipe("shelves_hooks")
AddShelfRecipe("shelves_pipe")
AddShelfRecipe("shelves_hattree")
AddShelfRecipe("shelves_pallet")
AddShelfRecipe("shelves_floating")
-- AddShelfRecipe("shelves_displaycase")
-- AddShelfRecipe("shelves_displaycase_metal")



local function AddLightRecipe(name, oincvalue)
	local presetoincvalue = oincvalue or 5
	local prefabname = "swinging_" .. name
	AddRecipe2(prefabname,
		{ Ingredient("oinc", presetoincvalue, h_atlas) }, TECH.HOME_ONE,
		{
			atlas = h_atlas,
			nounlock = true,
			-- build_mode = data and data.buildmode or "wallsection",
			min_spacing = 0,
			placer = prefabname .. "_placer",
			image = "reno_" .. name .. ".tex"
		},
		{ "INTERIOR" })
end

AddLightRecipe("light_basic_bulb", 4)
AddLightRecipe("light_basic_metal", 4)
AddLightRecipe("light_chandalier_candles", 5)
AddLightRecipe("light_rope_1", 5)
AddLightRecipe("light_rope_2", 5)
AddLightRecipe("light_floral_bulb", 8)
AddLightRecipe("light_pendant_cherries", 5)
AddLightRecipe("light_floral_scallop", 3)
AddLightRecipe("light_floral_bloomer", 5)
AddLightRecipe("light_tophat", 2)
AddLightRecipe("light_derby", 10)



AddRecipe2("reno_cornerbeam_wood", { Ingredient("oinc", 1, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true },
	{ "INTERIOR" })
AddRecipe2("reno_cornerbeam_millinery", { Ingredient("oinc", 1, h_atlas) }, TECH.HOME_ONE, {
	atlas = h_atlas,
	nounlock = true
}, { "INTERIOR" })
AddRecipe2("reno_cornerbeam_round", { Ingredient("oinc", 1, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true },
	{ "INTERIOR" })
AddRecipe2("reno_cornerbeam_marble", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true },
	{ "INTERIOR" })

AddRecipe2("deco_lamp_fringe", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_fringe_placer",
		image =
		"reno_lamp_fringe.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_lamp_stainglass", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_stainglass_placer",
		image = "reno_lamp_stainglass.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_lamp_downbridge", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_downbridge_placer",
		image = "reno_lamp_downbridge.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_lamp_2embroidered", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_2embroidered_placer",
		image = "reno_lamp_2embroidered.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_lamp_ceramic", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_ceramic_placer",
		image = "reno_lamp_ceramic.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_lamp_glass", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_glass_placer",
		image =
		"reno_lamp_glass.tex"
	},
	{ "INTERIOR" })
AddRecipe2("deco_lamp_2fringes", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_2fringes_placer",
		image = "reno_lamp_2fringes.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_lamp_candelabra", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_candelabra_placer",
		image = "reno_lamp_candelabra.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_lamp_elizabethan", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_elizabethan_placer",
		image = "reno_lamp_elizabethan.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_lamp_gothic", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_gothic_placer",
		image =
		"reno_lamp_gothic.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_lamp_orb", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = false, min_spacing = 1, placer = "deco_lamp_orb_placer", image = "reno_lamp_orb.tex" },
	{ "INTERIOR" })
AddRecipe2("deco_lamp_bellshade", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_bellshade_placer",
		image = "reno_lamp_bellshade.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_lamp_crystals", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_crystals_placer",
		image = "reno_lamp_crystals.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_lamp_upturn", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_upturn_placer",
		image =
		"reno_lamp_upturn.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_lamp_2upturns", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_2upturns_placer",
		image = "reno_lamp_2upturns.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_lamp_spool", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_spool_placer",
		image =
		"reno_lamp_spool.tex"
	},
	{ "INTERIOR" })
AddRecipe2("deco_lamp_edison", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_edison_placer",
		image =
		"reno_lamp_edison.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_lamp_adjustable", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_adjustable_placer",
		image = "reno_lamp_adjustable.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_lamp_rightangles", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_rightangles_placer",
		image = "reno_lamp_rightangles.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_lamp_hoofspa", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_lamp_hoofspa_placer",
		image = "reno_lamp_hoofspa.tex"
	}, { "INTERIOR" })

AddRecipe2("deco_table_round", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_table_round_placer",
		image =
		"reno_table_round.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_table_banker", { Ingredient("oinc", 4, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_table_banker_placer",
		image = "reno_table_banker.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_table_diy", { Ingredient("oinc", 3, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = false, min_spacing = 1, placer = "deco_table_diy_placer", image = "reno_table_diy.tex" },
	{ "INTERIOR" })
AddRecipe2("deco_table_raw", { Ingredient("oinc", 1, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = false, min_spacing = 1, placer = "deco_table_raw_placer", image = "reno_table_raw.tex" },
	{ "INTERIOR" })
AddRecipe2("deco_table_crate", { Ingredient("oinc", 1, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_table_crate_placer",
		image =
		"reno_table_crate.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_table_chess", { Ingredient("oinc", 1, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_table_chess_placer",
		image =
		"reno_table_chess.tex"
	}, { "INTERIOR" })

AddRecipe2("deco_plantholder_basic", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_basic_placer",
		image = "reno_plantholder_basic.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_wip", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_wip_placer",
		image = "reno_plantholder_wip.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_fancy", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_fancy_placer",
		image = "reno_plantholder_fancy.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_bonsai", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_bonsai_placer",
		image = "reno_plantholder_bonsai.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_dishgarden", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_dishgarden_placer",
		image = "reno_plantholder_dishgarden.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_philodendron", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_philodendron_placer",
		image = "reno_plantholder_philodendron.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_orchid", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_orchid_placer",
		image = "reno_plantholder_orchid.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_draceana", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_draceana_placer",
		image = "reno_plantholder_draceana.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_xerographica", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_xerographica_placer",
		image = "reno_plantholder_xerographica.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_birdcage", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_birdcage_placer",
		image = "reno_plantholder_birdcage.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_palm", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_palm_placer",
		image = "reno_plantholder_palm.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_zz", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_zz_placer",
		image = "reno_plantholder_zz.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_fernstand", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_fernstand_placer",
		image = "reno_plantholder_fernstand.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_fern", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_fern_placer",
		image = "reno_plantholder_fern.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_terrarium", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_terrarium_placer",
		image = "reno_plantholder_terrarium.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_plantpet", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_plantpet_placer",
		image = "reno_plantholder_plantpet.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_traps", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_traps_placer",
		image = "reno_plantholder_traps.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_plantholder_pitchers", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "deco_plantholder_pitchers_placer",
		image = "reno_plantholder_pitchers.tex"
	}, { "INTERIOR" })

AddRecipe2("deco_chair_classic", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "chair_classic_placer",
		image =
		"reno_chair_classic.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_chair_corner", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = false, min_spacing = 1, placer = "chair_corner_placer", image = "reno_chair_corner.tex" },
	{ "INTERIOR" })
AddRecipe2("deco_chair_bench", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = false, min_spacing = 1, placer = "chair_bench_placer", image = "reno_chair_bench.tex" },
	{ "INTERIOR" })
AddRecipe2("deco_chair_horned", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = false, min_spacing = 1, placer = "chair_horned_placer", image = "reno_chair_horned.tex" },
	{ "INTERIOR" })
AddRecipe2("deco_chair_footrest", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "chair_footrest_placer",
		image = "reno_chair_footrest.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_chair_lounge", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = false, min_spacing = 1, placer = "chair_lounge_placer", image = "reno_chair_lounge.tex" },
	{ "INTERIOR" })
AddRecipe2("deco_chair_massager", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "chair_massager_placer",
		image = "reno_chair_massager.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_chair_stuffed", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "chair_stuffed_placer",
		image =
		"reno_chair_stuffed.tex"
	}, { "INTERIOR" })
AddRecipe2("deco_chair_rocking", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = false,
		min_spacing = 1,
		placer = "chair_rocking_placer",
		image =
		"reno_chair_rocking.tex"
	}, { "INTERIOR" })



AddRecipe2("rug_round", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true, min_spacing = 0, placer = "rug_round_placer", image = "reno_rug_round.tex" },
	{ "INTERIOR" })
AddRecipe2("rug_square", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true, min_spacing = 0, placer = "rug_square_placer", image = "reno_rug_square.tex" },
	{ "INTERIOR" })
AddRecipe2("rug_oval", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true, min_spacing = 0, placer = "rug_oval_placer", image = "reno_rug_oval.tex" },
	{ "INTERIOR" })
AddRecipe2("rug_rectangle", { Ingredient("oinc", 3, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = true,
		min_spacing = 0,
		placer = "rug_rectangle_placer",
		image =
		"reno_rug_rectangle.tex"
	}, { "INTERIOR" })
AddRecipe2("rug_fur", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true, min_spacing = 0, placer = "rug_fur_placer", image = "reno_rug_fur.tex" },
	{ "INTERIOR" })
AddRecipe2("rug_hedgehog", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true, min_spacing = 0, placer = "rug_hedgehog_placer", image = "reno_rug_hedgehog.tex" },
	{ "INTERIOR" })
AddRecipe2("rug_porcupuss", { Ingredient("oinc", 10, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = true,
		min_spacing = 0,
		placer = "rug_porcupuss_placer",
		image =
		"reno_rug_porcupuss.tex"
	}, { "INTERIOR" })
AddRecipe2("rug_hoofprint", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = true,
		min_spacing = 0,
		placer = "rug_hoofprint_placer",
		image =
		"reno_rug_hoofprint.tex"
	}, { "INTERIOR" })
AddRecipe2("rug_octagon", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true, min_spacing = 0, placer = "rug_octagon_placer", image = "reno_rug_octagon.tex" },
	{ "INTERIOR" })
AddRecipe2("rug_swirl", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true, min_spacing = 0, placer = "rug_swirl_placer", image = "reno_rug_swirl.tex" },
	{ "INTERIOR" })
AddRecipe2("rug_catcoon", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true, min_spacing = 0, placer = "rug_catcoon_placer", image = "reno_rug_catcoon.tex" },
	{ "INTERIOR" })
AddRecipe2("rug_rubbermat", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{
		atlas = h_atlas,
		nounlock = true,
		min_spacing = 0,
		placer = "rug_rubbermat_placer",
		image =
		"reno_rug_rubbermat.tex"
	}, { "INTERIOR" })
AddRecipe2("rug_web", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true, min_spacing = 0, placer = "rug_web_placer", image = "reno_rug_web.tex" },
	{ "INTERIOR" })
AddRecipe2("rug_metal", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true, min_spacing = 0, placer = "rug_metal_placer", image = "reno_rug_metal.tex" },
	{ "INTERIOR" })
AddRecipe2("rug_wormhole", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true, min_spacing = 0, placer = "rug_wormhole_placer", image = "reno_rug_wormhole.tex" },
	{ "INTERIOR" })
AddRecipe2("rug_braid", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true, min_spacing = 0, placer = "rug_braid_placer", image = "reno_rug_braid.tex" },
	{ "INTERIOR" })
AddRecipe2("rug_beard", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true, min_spacing = 0, placer = "rug_beard_placer", image = "reno_rug_beard.tex" },
	{ "INTERIOR" })
AddRecipe2("rug_nailbed", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true, min_spacing = 0, placer = "rug_nailbed_placer", image = "reno_rug_nailbed.tex" },
	{ "INTERIOR" })
AddRecipe2("rug_crime", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true, min_spacing = 0, placer = "rug_crime_placer", image = "reno_rug_crime.tex" },
	{ "INTERIOR" })
AddRecipe2("rug_tiles", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{ atlas = h_atlas, nounlock = true, min_spacing = 0, placer = "rug_tiles_placer", image = "reno_rug_tiles.tex" },
	{ "INTERIOR" })

-- AddRecipe2("reno_shelves_wood", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE, { atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_shelves_basic", { Ingredient("oinc", 2, h_atlas) }, TECH.HOME_ONE, { atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_shelves_cinderblocks", { Ingredient("oinc", 1, h_atlas) }, TECH.HOME_ONE, {
-- 	atlas = h_atlas,
-- 	nounlock = true
-- }, { "INTERIOR" })
-- AddRecipe2("reno_shelves_marble", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE, { atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_shelves_glass", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE, { atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_shelves_ladder", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE, { atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_shelves_hutch", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE, { atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_shelves_industrial", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
-- 	{ atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_shelves_adjustable", { Ingredient("oinc", 8, h_atlas) }, TECH.HOME_ONE,
-- 	{ atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_shelves_midcentury", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
-- 	{ atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_shelves_wallmount", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
-- 	{ atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_shelves_aframe", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE, { atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_shelves_crates", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE, { atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_shelves_fridge", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE, { atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_shelves_floating", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
-- 	{ atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_shelves_pipe", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE, { atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_shelves_hattree", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE,
-- 	{ atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })
-- AddRecipe2("reno_shelves_pallet", { Ingredient("oinc", 6, h_atlas) }, TECH.HOME_ONE, { atlas = h_atlas, nounlock = true },
-- 	{ "INTERIOR" })

AddRecipe2("bed0", { Ingredient("oinc", 5, h_atlas) }, TECH.HOME_ONE,
	{ atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed0_placer" }, { "INTERIOR" })
AddRecipe2("bed1", { Ingredient("oinc", 7, h_atlas) }, TECH.HOME_ONE,
	{ atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed1_placer" }, { "INTERIOR" })
AddRecipe2("bed2", { Ingredient("oinc", 10, h_atlas) }, TECH.HOME_ONE,
	{ atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed2_placer" }, { "INTERIOR" })
AddRecipe2("bed3", { Ingredient("oinc", 12, h_atlas) }, TECH.HOME_ONE,
	{ atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed3_placer" }, { "INTERIOR" })
AddRecipe2("bed4", { Ingredient("oinc", 14, h_atlas) }, TECH.HOME_ONE,
	{ atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed4_placer" }, { "INTERIOR" })
AddRecipe2("bed5", { Ingredient("oinc", 16, h_atlas) }, TECH.HOME_ONE,
	{ atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed5_placer" }, { "INTERIOR" })
AddRecipe2("bed6", { Ingredient("oinc", 18, h_atlas) }, TECH.HOME_ONE,
	{ atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed6_placer" }, { "INTERIOR" })
AddRecipe2("bed7", { Ingredient("oinc", 20, h_atlas) }, TECH.HOME_ONE,
	{ atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed7_placer" }, { "INTERIOR" })
AddRecipe2("bed8", { Ingredient("oinc", 22, h_atlas) }, TECH.HOME_ONE,
	{ atlas = v_atlas, nounlock = true, min_spacing = 1, placer = "bed8_placer" }, { "INTERIOR" })


-- -----------------------------Sort keys----------------------------------------------------
-- ------------------------------Code was written by Baku--------------------------------------
-- local AllRecipes = GLOBAL.AllRecipes
-- ------------------------------[TOOLS]----------------------------------------------
-- AllRecipes.machete.sortkey = AllRecipes["goldenaxe"]["sortkey"] + 0.1
-- AllRecipes.goldenmachete.sortkey = AllRecipes["machete"]["sortkey"] + 0.1
-- ------------------------------[LIGHT]----------------------------------------------
-- AllRecipes.chiminea.sortkey = AllRecipes["firepit"]["sortkey"] + 0.1
-- AllRecipes.obsidianfirepit.sortkey = AllRecipes["coldfirepit"]["sortkey"] + 0.1
-- AllRecipes.tarlamp.sortkey = AllRecipes["torch"]["sortkey"] + 0.1
-- AllRecipes.bottlelantern.sortkey = AllRecipes["minerhat"]["sortkey"] + 0.1
-- AllRecipes.boat_torch.sortkey = AllRecipes["bottlelantern"]["sortkey"] + 0.1
-- AllRecipes.boat_lantern.sortkey = AllRecipes["boat_torch"]["sortkey"] + 0.1
-- AllRecipes.sea_chiminea.sortkey = AllRecipes["boat_lantern"]["sortkey"] + 0.1
-- ------------------------------[SURVIVAL]-------------------------------------------
-- AllRecipes.monkeyball.sortkey = AllRecipes["fishingrod"]["sortkey"] + 0.1
-- AllRecipes.palmleaf_umbrella.sortkey = AllRecipes["umbrella"]["sortkey"] - 0.1
-- AllRecipes.antidote.sortkey = AllRecipes["healingsalve"]["sortkey"] + 0.1
-- AllRecipes.thatchpack.sortkey = AllRecipes["backpack"]["sortkey"] + 0.1
-- AllRecipes.palmleaf_hut.sortkey = AllRecipes["siestahut"]["sortkey"] + 0.1
-- AllRecipes.doydoyfan.sortkey = AllRecipes["featherfan"]["sortkey"] + 0.1
-- AllRecipes.seasack.sortkey = AllRecipes["icepack"]["sortkey"] + 0.1
-- --doydoynest.sortkey = AllRecipes["seasack"]["sortkey"] + 0.1
-- ------------------------------[FARM]-----------------------------------------------
-- AllRecipes.mussel_stick.sortkey = 0
-- AllRecipes.fish_farm.sortkey = AllRecipes["icebox"]["sortkey"] + 0.1
-- AllRecipes.mussel_bed.sortkey = AllRecipes["porto_fish_farm"]["sortkey"] + 0.1
-- ------------------------------[SCIENCE]--------------------------------------------
-- AllRecipes.researchlab5.sortkey = AllRecipes["researchlab2"]["sortkey"] + 0.1 --SEA LAB
-- AllRecipes.icemaker.sortkey = AllRecipes["firesuppressor"]["sortkey"] + 0.1
-- AllRecipes.quackendrill.sortkey = AllRecipes["icemaker"]["sortkey"] + 0.1
-- ------------------------------[WAR]------------------------------------------------
-- AllRecipes.spear_poison.sortkey = AllRecipes["spear"]["sortkey"] + 0.1
-- AllRecipes.armor_seashell.sortkey = AllRecipes["armorwood"]["sortkey"] + 0.1
-- --armorlimestone.sortkey = AllRecipes["armormarble"]["sortkey"] + 0.1
-- --armorcactus.sortkey = AllRecipes["footballhat"]["sortkey"] - 0.1
-- AllRecipes.oxhat.sortkey = AllRecipes["footballhat"]["sortkey"] + 0.1
-- AllRecipes.coconade.sortkey = AllRecipes["trap_teeth"]["sortkey"] + 0.1
-- AllRecipes.spear_launcher.sortkey = AllRecipes["coconade"]["sortkey"] + 0.1
-- AllRecipes.cutlass.sortkey = AllRecipes["armordragonfly"]["sortkey"] - 0.1
-- ------------------------------[STRUCTURES]-----------------------------------------
-- AllRecipes.waterchest.sortkey = AllRecipes["treasurechest"]["sortkey"] + 0.1
-- AllRecipes.wall_limestone_item.sortkey = AllRecipes["wall_stone_item"]["sortkey"] + 0.1
-- AllRecipes.wall_enforcedlimestone_item.sortkey = AllRecipes["wall_limestone_item"]["sortkey"] + 0.1
-- AllRecipes.wildborehouse.sortkey = AllRecipes["pighouse"]["sortkey"] + 0.1
-- AllRecipes.ballphinhouse.sortkey = AllRecipes["wildborehouse"]["sortkey"] + 0.1
-- AllRecipes.primeapebarrel.sortkey = AllRecipes["porto_ballphinhouse"]["sortkey"] + 0.1
-- AllRecipes.dragoonden.sortkey = AllRecipes["wildborehouse"]["sortkey"] + 0.1 --or primeapebarrel if you add this
-- AllRecipes.turf_road.sortkey = AllRecipes["turf_woodfloor"]["sortkey"] - 0.1
-- AllRecipes.turf_snakeskinfloor.sortkey = AllRecipes["turf_woodfloor"]["sortkey"] + 0.1
-- AllRecipes.sand_castle.sortkey = AllRecipes["dragonflychest"]["sortkey"] - 0.1
-- AllRecipes.sandbag_item.sortkey = AllRecipes["sand_castle"]["sortkey"] - 0.1
-- ------------------------------[REFINE]----------------------------------------------
-- AllRecipes.fabric.sortkey = AllRecipes["papyrus"]["sortkey"] + 0.1
-- AllRecipes.limestone.sortkey = AllRecipes["fabric"]["sortkey"] + 0.1
-- AllRecipes.nubbin.sortkey = AllRecipes["limestone"]["sortkey"] + 0.1
-- AllRecipes.goldnugget.sortkey = AllRecipes["nubbin"]["sortkey"] + 0.1
-- AllRecipes.ice.sortkey = AllRecipes["messagebottleempty1"]["sortkey"] - 0.1
-- AllRecipes.messagebottleempty1.sortkey = AllRecipes["nightmarefuel"]["sortkey"] - 0.1
-- ------------------------------[MAGIC]-----------------------------------------------
-- --piratihatitator.sortkey = 0
-- AllRecipes.ox_flute.sortkey = AllRecipes["panflute"]["sortkey"] + 0.1
-- ------------------------------[DRESSUP]---------------------------------------------
-- AllRecipes.brainjellyhat.sortkey = AllRecipes["catcoonhat"]["sortkey"] + 0.1
-- --shark_teethhat.sortkey = AllRecipes["watermelonhat"]["sortkey"] + 0.1
-- AllRecipes.snakeskinhat.sortkey = AllRecipes["bushhat"]["sortkey"] + 0.1
-- AllRecipes.armor_snakeskin.sortkey = AllRecipes["raincoat"]["sortkey"] + 0.1
-- AllRecipes.blubbersuit.sortkey = AllRecipes["armor_snakeskin"]["sortkey"] + 0.1
-- AllRecipes.tarsuit.sortkey = AllRecipes["blubbersuit"]["sortkey"] + 0.1
-- AllRecipes.double_umbrellahat.sortkey = AllRecipes["eyebrellahat"]["sortkey"] + 0.1
-- AllRecipes.armor_windbreaker.sortkey = AllRecipes["double_umbrellahat"]["sortkey"] + 0.1
-- AllRecipes.gashat.sortkey = AllRecipes["armor_windbreaker"]["sortkey"] + 0.1
-- AllRecipes.gashatsw.sortkey = AllRecipes["armor_windbreaker"]["sortkey"] + 0.1

-- AllRecipes.mermhouse_crafted.sortkey = 0
-- AllRecipes.mermthrone_construction.sortkey = AllRecipes["mermhouse_crafted"]["sortkey"] + 0.1
-- AllRecipes.mermwatchtower.sortkey = AllRecipes["mermthrone_construction"]["sortkey"] + 0.1
-- AllRecipes.mermhouse_tropical.sortkey = AllRecipes["mermwatchtower"]["sortkey"] + 0.1
-- ------------------------------[SHADOW MAXWELL BOOK]-----------------------------------------
-- AllRecipes.shadowname_builder.sortkey = AllRecipes["shadowlumber_builder"]["sortkey"] + 0.1
-- ----This sortkey for Machete shadow puppet
-- ------------------------------Code was written by Baku--------------------------------------
