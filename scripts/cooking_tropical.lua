-- 修改原版配方，贴图不同的保留
local foods = require("preparedfoods")
-- foods.butterflymuffin.test = function(cooker, names, tags) return (names.butterflywings or names.moonbutterflywings or names.butterfly_tropical_wings) and not tags.meat and tags.veggie and tags.veggie >= 0.5 end
foods.californiaroll.test = function(cooker, names, tags) return ((names.kelp or 0) + (names.kelp_cooked or 0) + (names.kelp_dried or 0) + (names.seaweed or 0)) == 2 and (tags.fish and tags.fish >= 1) end
foods.lobsterbisque.test = function(cooker, names, tags) return (names.wobster_sheller_land or names.lobster_dead or names.lobster_dead_cooked or names.lobster_land) and tags.frozen end
foods.lobsterdinner.test = function(cooker, names, tags) return (names.wobster_sheller_land or names.lobster_dead or names.lobster_dead_cooked or names.lobster_land) and names.butter and (tags.meat and tags.meat >= 1.0) and (tags.fish and tags.fish >= 1.0) and not tags.frozen end

local foodsGrandDef = require("preparedfoods_tro")
for tabIdx, foodTab in pairs(foodsGrandDef) do
    for _, foodDef in pairs(foodTab) do
        if foodDef.isMasterfood == nil then
            AddCookerRecipe("cookpot", foodDef)
            AddCookerRecipe("archive_cookpot", foodDef)
        end
        AddCookerRecipe("portablecookpot", foodDef)
        if foodDef.card_def then
            AddRecipeCard("cookpot", foodDef)
        end
    end
    GenerateSpicedFoods(foodTab)
end

-- local foods_sw = require("preparedfoods_sw")
-- for k, v in pairs (foods_sw) do
--     if v.mod and v.mod == true then
--         -- RegisterInventoryItemAtlas(inventoryitems_atlas_sw, v.name..".tex")
--     end
--     if v.isMasterfood == nil then -- 不是大厨料理才加入到烹饪锅
--         AddCookerRecipe("cookpot", v)
--         AddCookerRecipe("archive_cookpot", v)
--     end
--     AddCookerRecipe("portablecookpot", v)
--     if v.card_def then
--         AddRecipeCard("cookpot", v)
--     end
-- end

-- local foods_ham = require("preparedfoods_ham")
-- for k, v in pairs (foods_ham) do
--     if v.mod and v.mod == true then
--         -- RegisterInventoryItemAtlas(inventoryitems_atlas_ham, v.name..".tex")
--     end
--     if v.isMasterfood == nil then
--         AddCookerRecipe("cookpot", v)
--         AddCookerRecipe("archive_cookpot", v)
--     end
--     AddCookerRecipe("portablecookpot", v)
--     if v.card_def then
--         AddRecipeCard("cookpot", v)
--     end
-- end


-- GenerateSpicedFoods(foods_sw)
-- GenerateSpicedFoods(foods_ham)
local spicedfoods = require("spicedfoods")
for k, recipe in pairs(spicedfoods) do
    if recipe.mod and recipe.mod == true then
        recipe.official = false
        AddCookerRecipe("portablespicer", recipe)
    end
end

-- 食物属性，仅海难和哈姆
AddIngredientValues({ "butterfly_tropical_wings" }, { decoration = 2 }, true, false)

AddIngredientValues({ "limpets_cooked" }, { fish = 0.5 }, true, false)
AddIngredientValues({ "limpets" }, { fish = 0.5 }, true, false)
AddIngredientValues({ "coconut_cooked", "coconut_halved" }, { fruit = 1, fat = 1 }, true, false)
AddIngredientValues({ "coffeebeans" }, { fruit = .5 }, true, false)
AddIngredientValues({ "coffeebeans_cooked" }, { fruit = 1 }, true, false)
AddIngredientValues({ "sweet_potato" }, { veggie = 1 }, true, false)
AddIngredientValues({ "sweet_potatos_cooked" }, { veggie = 1 }, true, false)
AddIngredientValues({ "fish_med" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "dead_swordfish" }, { fish = 1.5 }, true, false)
AddIngredientValues({ "fish_raw" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish_med_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "quagmire_crabmeat" }, { fish = 0.5, crab = 1 }, true, false)
AddIngredientValues({ "quagmire_crabmeat_cooked" }, { fish = 0.5, crab = 1 }, true, false)
AddIngredientValues({ "lobster_land" }, { meat = 1.0, fish = 1.0 }, true, false)
AddIngredientValues({ "lobster_dead" }, { meat = 1.0, fish = 1.0 }, true, false)
AddIngredientValues({ "lobster_dead_cooked" }, { meat = 1.0, fish = 1.0 }, true, false)
AddIngredientValues({ "fish_dogfish" }, { fish = 1 }, true, false)
AddIngredientValues({ "mussel_cooked" }, { fish = 0.5 }, true, false)
AddIngredientValues({ "mussel" }, { fish = 0.5 }, true, false)
AddIngredientValues({ "shark_fin" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "crab" }, { fish = 0.5 }, true, false)
AddIngredientValues({ "seaweed" }, { veggie = 1 }, true, false)
AddIngredientValues({ "seaweed_cooked" }, { veggie = 1 }, true, false)
AddIngredientValues({ "seaweed_dried" }, { veggie = 1 }, true, false)
AddIngredientValues({ "doydoyegg" }, { egg = 1 }, true, false)
AddIngredientValues({ "dorsalfin" }, { inedible = 1 }, true, false)
AddIngredientValues({ "jellyfish" }, { fish = 1, jellyfish = 1, monster = 1 }, true, false)
AddIngredientValues({ "jellyfish_cooked" }, { fish = 1, jellyfish = 1, monster = 1 }, true, false)
AddIngredientValues({ "jellyfish_dead" }, { fish = 1, jellyfish = 1, monster = 1 }, true, false)
AddIngredientValues({ "jellyjerky" }, { fish = 1, jellyfish = 1, monster = 1 }, true, false)

AddIngredientValues({ "fish2" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish2_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish3" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish3_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish4" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish4_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish5" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish5_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish6" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish6_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish7" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "fish7_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "salmon" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "salmon_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "coi" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "coi_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "snowitem" }, { meat = 0.5, frozen = 1 }, true, false)

AddIngredientValues({ "roe" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "roe_cooked" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "quagmire_spotspice_sprig" }, { veggie = 1 }, true, false)
AddIngredientValues({ "quagmire_sap" }, { sweetener = 1 }, true, false)

AddIngredientValues({ "seataro" }, { veggie = 1, frozen = 1 }, true, false)
AddIngredientValues({ "seataro_cooked" }, { veggie = 1, frozen = 1 }, true, false)

AddIngredientValues({ "blueberries" }, { fruit = 0.5, frozen = 0.25 }, true, false)
AddIngredientValues({ "blueberries_cooked" }, { fruit = 0.75 }, true, false)

AddIngredientValues({ "seacucumber" }, { veggie = 1 }, true, false)
AddIngredientValues({ "seacucumber_cooked" }, { veggie = 1 }, true, false)

AddIngredientValues({ "gooseberry" }, { veggie = 1 }, true, false)
AddIngredientValues({ "gooseberry_cooked" }, { veggie = 1 }, true, false)

AddIngredientValues({ "quagmire_mushrooms" }, { mushroom = 1, veggie = 0.5 }, true, false)
AddIngredientValues({ "quagmire_mushrooms_cooked" }, { mushroom = 1, veggie = 0.5 }, true, false)

AddIngredientValues({ "oceanfish_small_61_inv" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "oceanfish_small_61_inv_cooked" }, { meat = 0.5, fish = 1 }, true, false)

AddIngredientValues({ "oceanfish_small_71_inv" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "oceanfish_small_71_inv_cooked" }, { meat = 0.5, fish = 1 }, true, false)

AddIngredientValues({ "oceanfish_small_81_inv" }, { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "oceanfish_small_81_inv_cooked" }, { meat = 0.5, fish = 1 }, true, false)

AddIngredientValues({ "foliage" }, { veggie = 1 }, true, false)
AddIngredientValues({ "jellybug" }, { bug = 1 }, true, false)
AddIngredientValues({ "jellybug_cooked" }, { bug = 1 }, true, false)
AddIngredientValues({ "slugbug" }, { bug = 1 }, true, false)
AddIngredientValues({ "slugbug_cooked" }, { bug = 1 }, true, false)
AddIngredientValues({ "cutnettle" }, { antihistamine = 1 }, true, false)
AddIngredientValues({ "radish" }, { veggie = 1 }, true, false)
AddIngredientValues({ "radish_cooked" }, { veggie = 1 }, true, false)

AddIngredientValues({ "turnip" }, { veggie = 1 }, true, false)
AddIngredientValues({ "turnip_cooked" }, { veggie = 1 }, true, false)

AddIngredientValues({ "asparagus" }, { veggie = 1 }, true, false)
AddIngredientValues({ "asparagus_cooked" }, { veggie = 1 }, true, false)
AddIngredientValues({ "aloe" }, { veggie = 1 }, true, false)
AddIngredientValues({ "aloe_cooked" }, { veggie = 1 }, true, false)
AddIngredientValues({ "weevole_carapace" }, { inedible = 1 }, true, false)
AddIngredientValues({ "piko_orange" }, { filter = 1 }, true, false)
AddIngredientValues({ "snake_bone" }, { bone = 1 }, true, false)
AddIngredientValues({ "yelow_cap" }, { veggie = 0.5 }, true, false)
AddIngredientValues({ "yelow_cooked" }, { veggie = 0.5 }, true, false)


-- 食物属性，废案拓展
AddIngredientValues({ "lotus_flower1" }, { veggie = 1 }, true, false)
AddIngredientValues({ "fennel" }, { veggie = 0.5 }, true, false)
AddIngredientValues({ "quagmire_smallmeat" }, { meat = 0.5, smallmeat = 1 }, true, false) -- "smallmeat" for quagmire, I think


-- 烹饪指南中的食材贴图
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "weevole_carapace.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "lotus_flower1.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hamletinventory.xml", "lotus_flower1_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fennel.tex")
RegisterInventoryItemAtlas("images/inventoryimages/volcanoinventory.xml", "fennel_cooked.tex")
