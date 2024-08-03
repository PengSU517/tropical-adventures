-- @author: Runar
-- cooking style
local Path = "@../mods/workshop-2896126381/scripts/melting.lua:"

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

local Products = {
    ash = { priority = -1, test = {}, overridebuild = "ash", overridesymbolname = "ashes01" },
    opalpreciousgem = { priority = 20, test = { gem = 42 }, overridebuild = "gems", overridesymbolname = "opalgem" }, -- gem
    greengem = { priority = 10, test = { gem = 28 }, overridebuild = "gems", overridesymbolname = "greengem" },
    yellowgem = { priority = 5, test = { gem = 10 }, overridebuild = "gems", overridesymbolname = "yellowgem" },
    orangegem = { priority = 3, test = { gem = 4 }, overridebuild = "gems", overridesymbolname = "orangegem" },
    alloy = { priority = 5, test = { iron = 4 }, overridebuild = "alloy", overridesymbolname = "alloy01" }, -- iron
    gunpowder = { priority = 3, test = { nitro = 4 }, overridebuild = "gunpowder", overridesymbolname = "gunpowder01" }, -- nitro
    nitre = { priority = 1, test = { nitro = 1 }, overridebuild = "nitre", overridesymbolname = "nitre01" },
    goldenbar = { priority = 10, test = { gold = 2 }, overridebuild = "alloygold", overridesymbolname = "alloy01" }, -- gold
    goldnugget = { priority = 5, test = { gold = 1 }, overridebuild = "gold_dust", overridesymbolname = "gold_dust01" },
    stonebar = { priority = 1, test = { mineral = 1 }, overridebuild = "alloystone", overridesymbolname = "alloy01" }, -- mineral
}

-- AddMeltAttributeValue({ "iron" }, { iron = 1 })
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
function AddMeltProduct(recipes)
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

local function getAttr(items)
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

-- getProd({iron = 2, gem = 2})
local function getProd(items)
    local prod = { name = nil, prior = 0, attrs = getAttr(items)}
    for testprod, recipe in pairs(Products) do
        local replace = true
        for attrtag, attrval in pairs(recipe.test) do
            if not prod.attrs[attrtag] or prod.attrs[attrtag] < attrval then
                replace = false
                break
            end
        end
        if replace == true and prod.prior < recipe.priority then
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
    -- recipes = Products,
    -- getMeltAttr = getAttr,
    getMeltProd = getProd,
    getOverrideSymbol = getOverrideSymbol,
    isAttribute = isAttribute,
}
