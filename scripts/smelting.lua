-- @author: Runar
-- cooking style
local Path = "@../mods/workshop-2896126381/scripts/smelting.lua:"

local Attributes = {
    greengem = { gem = 27, }, -- gem
    yellowgem = { gem = 9, },
    orangegem = { gem = 3, },
    purplegem = { gem = 1, },
    bluegem = { gem = .5, },
    redgem = { gem = .5, },
    iron = { iron = 1, }, -- iron
    magnifying_glass = { iron = 1, },
    goldpan = { iron = 1, },
    ballpein_hammer = { iron = 1, },
    shears = { iron = 1, },
    candlehat = { iron = 1, },
    obsidian = { nitro = 2.5,}, -- nitro
    nitre = { nitro = 1, },
    flint = { nitro = .25, },
    goldnugget = { gold = 1, }, -- gold
    dubloon = { gold = .5, },
    gold_dust = { gold = .25, },
    rocks = { mineral = .25, }, -- mineral
}

local Products = require("smeltrecipes")

--- AddMeltAttributeValue({ "iron" }, { iron = 1 })
---@param names table 添加到炼钢炉的物品名表，如 "{ "iron" }"
---@param tags table 炼钢物品的属性键值表，如 "{ iron = 1 }"
function AddMeltAttributeValue(names, tags)
    for _, name in pairs(names) do
        if not Attributes[name] then
            Attributes[name] = {}
        end
        for tagname, tagval in pairs(tags) do
            assert(not Attributes[name][tagname], Path .. "49: attempt to add existed melt tag \"" .. tagname .. "\" to melt attribute \"" .. name .. "\"")
            Attributes[name][tagname] = tagval
        end
    end
end

-- AddMeltProduct({ alloy = { priority = 5, test = { iron = 4 } } })
---@param recipes table 添加到炼钢炉配方的表，需要有优先级 "priority" 以及测试函数 "test"
local function AddMeltProduct(recipes)
    for name, recipe in pairs(recipes) do
        assert(not Products[name], Path .. "59: attempt to add existed melt recipe \"" .. name .. "\"")
        assert(type(recipe.test) == "table", Path .. "59: attempt to add non recipe for \"" .. name .. "\"")
        Products[name] = { priority = recipe.priority or 0, test = {}, overridebuild = recipe.overridebuild or name, overridesymbolname = recipe.overridesymbolname or name }
        for attrtag, attrval in pairs(recipe.test) do
            assert(type(attrtag) == "string", Path .. "63: attempt to add non attribute tag to \"" .. name .. "\"")
            assert(type(attrval) == "number", Path .. "63: attempt to add non attribute value to \"" .. name .. "\"")
            Products[name].test[attrtag] = attrval
        end
    end
end

-- local function getNames(items)
-- end

local function getAttrs(items)
    local attrs = {}
    for item, val in pairs(items) do
        if Attributes[item] then
            for attrtag, attrval in pairs(Attributes[item]) do
                attrs[attrtag] = attrs[attrtag] and attrs[attrtag] + attrval * val or attrval * val
            end
        end
    end
    return attrs
end

--- getProd({iron = 2, gem = 2}, Player)
---@param items table 物品数量表
---@param worker table 操作者预制物
local function getProd(items, worker)
    local prod = { name = nil, prior = 0, attrs = getAttrs(items)}
    for testprod, recipe in pairs(Products) do
        if prod.prior <= recipe.priority and recipe.test(worker, items, prod.attrs) then
            prod.name = testprod
            prod.prior = recipe.priority
        end
    end
    return prod.name
end

local function getOverrideSymbol(item)
    return Products[item].overridebuild, Products[item].overridesymbolname
end

local function isAttribute(item)
    assert(type(item) == "string", Path .. "105: \"" .. item .. "\" is not a prefab name" )
    return Attributes[item] and true or false
end

return {
    -- attributes = Attributes,
    recipes = Products,
    AddMeltProduct = AddMeltProduct,
    -- getMeltAttr = getAttr,
    getMeltProd = getProd,
    getOverrideSymbol = getOverrideSymbol,
    isAttribute = isAttribute,
}
