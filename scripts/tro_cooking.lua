require "cooking"
require "spicedfoods"
local foods = require "preparedfoods"
-- if foods.butterflymuffin then
--     local posttest = foods.butterflymuffin.test
--     foods.butterflymuffin.test = function(cooker, names, tags)
--         return names.butterfly_tropical_wings and not tags.meat and tags.veggie or posttest(cooker, names, tags)
--     end
-- end
if foods.californiaroll then
    local posttest = foods.californiaroll.test
    foods.californiaroll.test = function(cooker, names, tags)
        return ((names.kelp or 0) + (names.kelp_cooked or 0) + (names.kelp_dried or 0) + (names.seaweed or 0)) == 2 and
            (tags.fish and tags.fish >= 1) or posttest(cooker, names, tags)
    end
end
if foods.lobsterbisque then
    local posttest = foods.lobsterbisque.test
    foods.lobsterbisque.test = function(cooker, names, tags)
        return names.lobster_land and tags.frozen or posttest(cooker, names, tags)
    end
end
if foods.lobsterdinner then
    local posttest = foods.lobsterdinner.test
    foods.lobsterdinner.test = function(cooker, names, tags)
        return
            names.lobster_land and names.butter and (tags.meat and tags.meat <= 1) and (tags.fish and tags.fish <= 1) and
            not tags.frozen or posttest(cooker, names, tags)
    end
end

local foodsGrandDef = require("datadefs/preparedfoods_tro")
for tabIdx, foodTab in pairs(foodsGrandDef) do
    for _, foodDef in pairs(foodTab) do
        if foodDef.isMasterfood == nil then
            AddCookerRecipe("cookpot", foodDef, true)
            AddCookerRecipe("archive_cookpot", foodDef, true)
        end
        AddCookerRecipe("portablecookpot", foodDef, true)
        if foodDef.card_def then
            AddRecipeCard("cookpot", foodDef)
        end
    end
    GenerateSpicedFoods(foodTab)
end

local spicedfoods = require("spicedfoods")
for _, foodDef in pairs(spicedfoods) do
    if foodDef.mod then
        AddCookerRecipe("portablespicer", foodDef, true)
    end
end

AddIngredientValues({ "butterfly_tropical_wings", }, { decoration = 2 }, true, false)
AddIngredientValues({ "crab", "limpets", "mussel", }, { fish = 0.5 }, true, false)
AddIngredientValues({ "coconut_cooked", "coconut_halved", }, { fruit = 1, fat = 1 }, true, false)
AddIngredientValues({ "coffeebeans", }, { fruit = .5 }, true, false)
AddIngredientValues({ "coffeebeans_cooked", }, { fruit = 1 }, true, false)
AddIngredientValues(
    { "aloe", "asparagus", "foliage", "gooseberry", "lotus_flower", "quagmire_spotspice_sprig", "radish", "seacucumber",
        "sweet_potato", "turnip", }, { veggie = 1 }, true, false)
AddIngredientValues({ "seaweed", }, { veggie = 1 }, true, true)
AddIngredientValues(
    { "coi", "dogfish_dead", "fish2", "fish3", "fish4", "fish5", "fish6", "fish7", "oceanfish_small_61_inv",
        "oceanfish_small_71_inv", "oceanfish_small_81_inv", "roe_cooked", "roe", "salmon", "shark_fin", },
    { meat = 0.5, fish = 1 }, true, false)
AddIngredientValues({ "swordfish_dead", }, { fish = 1.5 }, true, false)
AddIngredientValues({ "quagmire_crabmeat", }, { fish = 0.5, crab = 1 }, true, false)
AddIngredientValues({ "lobster_land", }, { meat = 1.0, fish = 1.0 }, false, false)
AddIngredientValues({ "fish_dogfish", }, { fish = 1 }, true, false)
AddIngredientValues({ "doydoyegg", }, { egg = 1 }, true, false)
AddIngredientValues({ "dorsalfin", }, { inedible = 1 }, true, false)
AddIngredientValues({ "jellyfish", "jellyfish_dead", "jellyjerky", }, { fish = 1, jellyfish = 1, monster = 1 }, true,
    false)
AddIngredientValues({ "snowitem", }, { meat = 0.5, frozen = 1 }, true, false)
AddIngredientValues({ "quagmire_sap", }, { sweetener = 1 }, true, false)
AddIngredientValues({ "seataro", }, { veggie = 1, frozen = 1 }, true, false)
AddIngredientValues({ "blueberries", }, { fruit = 0.5, frozen = 0.25 }, true, false)
AddIngredientValues({ "blueberries_cooked", }, { fruit = 0.75 }, true, false)
AddIngredientValues({ "quagmire_mushrooms", }, { mushroom = 1, veggie = 0.5 }, true, false)
AddIngredientValues({ "jellybug", "slugbug", }, { bug = 1 }, true, false)
AddIngredientValues({ "cutnettle", }, { antihistamine = 1 }, true, false)
AddIngredientValues({ "weevole_carapace", }, { inedible = 1 }, true, false)
AddIngredientValues({ "piko_orange", }, { filter = 1 }, true, false)
AddIngredientValues({ "snake_bone", }, { bone = 1 }, true, false)
AddIngredientValues({ "fennel", "yelow_cap", "yelow_cooked", }, { veggie = 0.5 }, true, false)
AddIngredientValues({ "quagmire_smallmeat", }, { meat = 0.5, smallmeat = 1 }, true, false) -- "smallmeat" for quagmire, I think
