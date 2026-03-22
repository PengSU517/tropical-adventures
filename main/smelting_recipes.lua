local ingredients = require("datadefs/smeltrecipes").ingredients
local recipes = require("datadefs/smeltrecipes").recipes
local attributes = require("datadefs/smeltrecipes").attributes
local cooking = require("cooking")
local smelting = require("tools/smelting")

-- 正常注入你的熔炼配方和标签
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

-- 保存原版的检测函数
local isingre = cooking.IsCookingIngredient

-- 核心重写：使用“动态标签检测”，完美免疫 Mod 加载顺序冲突
cooking.IsCookingIngredient = function(prefabname)
    -- 1. 如果底层系统认为它根本没有食材度（不在 cooking.ingredients 里），直接 false
    if not isingre(prefabname) then
        return false
    end

    -- 2. 如果它是我们注册的熔炼材料，我们需要判断它是“纯矿石”还是“跨界材料”
    if smelting.isAttribute(prefabname) then
        -- 获取这个物品在当前游戏环境下的所有食材度标签
        local is_pure_ore = true
        local tags = cooking.ingredients[prefabname].tags
        if tags then
            -- 遍历它身上的每一个标签
            for tag_name, val in pairs(tags) do
                -- 如果发现任何一个标签【不在】我们的熔炼 attributes 表里
                -- 意味着这是原版标签(如meat)或其他后加载Mod添加的标签！
                if not attributes[tag_name] then
                    -- print("[Smelting] Warning: Ingredient " ..
                    --     prefabname .. " has non-smelting ingredient tag " .. tag_name)
                    is_pure_ore = false
                    break
                end
            end
        end
        -- 如果它【只是】个纯矿石（全身只有熔炼标签，没有任何外界食物标签），则拦截！
        if is_pure_ore then
            return false
        end
    end

    -- 3. 其他所有情况（原版食材、其他Mod新增的纯食材、具备双重身份的石头），全部正常放行！
    return true
end


----客机添加智能烹饪锅UI
if AddCookingPot then
    AddCookingPot("smelter")
end


----注册食材度的 图标
if AddFoodTag then
    for i, v in pairs(attributes) do
        local tex = v.tex .. ".tex"
        local atlas = GetInventoryItemAtlas(tex)
        AddFoodTag(i, { name = i, tex = tex, atlas = atlas })
    end
end
