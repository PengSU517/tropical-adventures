local smelting = require("smelting")
local recipes = smelting.recipes

local function SetRecipe(inst, recipe_name)
    inst.recipe_name = recipe_name
    inst.components.named:SetName(subfmt(STRINGS.NAMES.SMELTINGRECIPECARD, { item = STRINGS.NAMES[string.upper(recipe_name)] or recipe_name }))
end

local function PickRandomRecipe(inst)
    local recipe_name = smelting.cards[math.random(#smelting.cards)]
    SetRecipe(inst, recipe_name)
end

local function getdesc(inst, viewer)
    local smelt_recipe = recipes[inst.recipe_name]
    if smelt_recipe then
        local card = smelt_recipe.card_def
        if card then
			local ing_str = subfmt(STRINGS.SMELTINGRECIPECARD_DESC.INGREDIENTS_FIRST, {num = card.attributes[1][2], ing = STRINGS.NAMES[string.upper(card.attributes[1][1])]})
			for i = 2, #card.attributes do
				ing_str = ing_str .. subfmt(STRINGS.SMELTINGRECIPECARD_DESC.INGREDIENTS_MORE, {num = card.attributes[i][2], ing = STRINGS.NAMES[string.upper(card.attributes[i][1])]})
			end

			return subfmt(STRINGS.SMELTINGRECIPECARD_DESC.BASE, {name = STRINGS.NAMES[string.upper(inst.recipe_name)], attributes = ing_str})
        end
    end
end

local function OnSave(inst, data)
    data.n = inst.recipe_name
end

local function OnLoad(inst, data)
    if data and data.n then
        SetRecipe(inst, data.n)
    end
end

local function fn()
    local inst = Prefabs.cookingrecipecard.fn()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:RemoveComponent("erasablepaper")

    inst:SetPrefabName("smeltingrecipecard")
    inst.components.inventoryitem.imagename = "cookingrecipecard"
	inst.components.inspectable.getspecialdescription = getdesc

	PickRandomRecipe(inst)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

    return inst
end

return Prefab("smeltingrecipecard", fn)
