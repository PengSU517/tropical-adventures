local Attributes = {
    iron = { tex = "iron" },
    gem = { tex = "purplegem" },
    nitro = { tex = "nitre" },
    gold = { tex = "goldnugget" },
    mineral = { tex = "rocks" },
}




local Ingredients = {
    greengem = { gem = 1 }, -- gem
    yellowgem = { gem = 0.5 },
    orangegem = { gem = 0.25 },
    purplegem = { gem = 0.1, },
    bluegem = { gem = .05, },
    redgem = { gem = .05, },

    iron = { iron = 1, }, -- iron
    magnifying_glass = { iron = 1, },
    goldpan = { iron = 1, },
    ballpein_hammer = { iron = 1, },
    shears = { iron = 1, },
    candlehat = { iron = 1, },
    halberd = { iron = 1, },
    armor_metalplate = { iron = 1, },
    metalplatehat = { iron = 1, },

    obsidian = { nitro = 2.5, }, -- nitro
    nitre = { nitro = 1, },
    flint = { nitro = .25, },


    goldnugget = { gold = 1, }, -- gold
    dubloon = { gold = .5, },
    gold_dust = { gold = .25, },


    rocks = { mineral = .25, }, -- mineral
}


local Recipes = {
    ash = {
        priority = -1,
        test = function(worker, names, attrs) return true end,
        overridebuild = "ash",
        overridesymbolname = "ashes01",
        stacksize = 4,
    },
    opalpreciousgem = { -- gem
        priority = 20,
        test = function(worker, names, attrs) return attrs.gem and attrs.gem >= 2 end,
        overridebuild = "gems",
        overridesymbolname = "opalgem",
        card_def = {
            attributes = { { "greengem", 1 }, { "yellowgem", 1 }, { "orangegem", 2 } },
        },
    },
    greengem = {
        priority = 10,
        test = function(worker, names, attrs) return attrs.gem and attrs.gem >= 1 end,
        overridebuild = "gems",
        overridesymbolname = "greengem",
        card_def = {
            attributes = { { "yellowgem", 1 }, { "orangegem", 3 } },
        },
    },
    yellowgem = {
        priority = 5,
        test = function(worker, names, attrs) return attrs.gem and attrs.gem >= 0.5 end,
        overridebuild = "gems",
        overridesymbolname = "yellowgem",
        card_def = {
            attributes = { { "orangegem", 1 }, { "purplegem", 3 } },
        },
    },
    orangegem = {
        priority = 3,
        test = function(worker, names, attrs) return attrs.gem and attrs.gem >= 0.3 end,
        overridebuild = "gems",
        overridesymbolname = "orangegem",
        card_def = {
            attributes = { { "purplegem", 2 }, { "bluegem", 3 } },
        },
    },
    alloy = { -- iron
        priority = 5,
        test = function(worker, names, attrs) return attrs.iron and attrs.iron >= 4 end,
        overridebuild = "alloy",
        overridesymbolname = "alloy01",
        card_def = {
            attributes = { { "iron", 4 } },
        },
    },
    gunpowder = { -- nitro
        priority = 3,
        test = function(worker, names, attrs) return attrs.nitro and attrs.nitro >= 4 end,
        overridebuild = "gunpowder",
        overridesymbolname = "gunpowder01",
        card_def = {
            attributes = { { "nitre", 4 } },
        },
    },
    nitre = {
        priority = 1,
        test = function(worker, names, attrs) return attrs.nitro and attrs.nitro >= 1 end,
        overridebuild = "nitre",
        overridesymbolname = "nitre01",
        card_def = {
            attributes = { { "flint", 4 } },
        },
    },
    goldenbar = { -- gold
        priority = 10,
        test = function(worker, names, attrs) return attrs.gold and attrs.gold >= 2 end,
        overridebuild = "alloygold",
        overridesymbolname = "alloy01",
        card_def = {
            attributes = { { "goldnugget", 1 }, { "dubloon", 1 }, { "gold_dust", 2 } },
        },
    },
    goldnugget = {
        priority = 5,
        test = function(worker, names, attrs) return attrs.gold and attrs.gold >= 1 end,
        overridebuild = "tree_rock_normal",
        overridesymbolname = "swap_goldnugget", ---用的 宝石树的资源
        card_def = {
            attributes = { { "gold_dust", 4 } },
        },
    },
    stonebar = { -- mineral
        priority = 1,
        test = function(worker, names, attrs) return attrs.mineral and attrs.mineral >= 1 end,
        overridebuild = "alloystone",
        overridesymbolname = "alloy01",
        card_def = {
            attributes = { { "rocks", 4 } },
        },
    },
}


for i, v in pairs(Recipes) do
    v.name = v.name or i
    v.weight = v.weight or 1
    v.priority = v.priority or 0
    v.no_cookbook = true --不显示在烹饪指南里
    -- v.cookbook_category = "smelter" -- 有这个键但是这样写没用
end

return {
    attributes = Attributes,
    ingredients = Ingredients,
    recipes = Recipes,
}
