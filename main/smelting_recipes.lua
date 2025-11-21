local ingredients = require("datadefs/smeltrecipes").ingredients
local recipes = require("datadefs/smeltrecipes").recipes
local attributes = require("datadefs/smeltrecipes").attributes
local cooking = require("cooking")
local smelting = require("tools/smelting")


for item, ingredient in pairs(ingredients) do
    AddIngredientValues({ item }, ingredient, false, false)
    AddMeltAttributeValue({ item }, ingredient)
end

for _, meltDef in pairs(recipes) do
    AddMeltProduct({ [_] = meltDef })
    AddCookerRecipe("smelter", meltDef)

    if meltDef.card_def then
        -- AddRecipeCard("smelter", meltDef)
        AddSmeltCard(meltDef)
    end
end


local isingre = cooking.IsCookingIngredient

cooking.IsCookingIngredient = function(prefabname)
    return isingre(prefabname) and not smelting.isAttribute(prefabname)
    -----可能会导致某些食材放不进烹饪锅？
end


----客机添加智能烹饪锅UI
if AddCookingPot then
    AddCookingPot("smelter")
end


----注册食材度的 图标
if AddFoodTag then
    -- print("注册食材度图标")
    for i, v in pairs(attributes) do
        local tex = v.tex .. ".tex"
        local atlas = GetInventoryItemAtlas(tex)
        AddFoodTag(i, { name = i, tex = tex, atlas = atlas })
    end
end
