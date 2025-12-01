local Attributes = {
    ferrum = { tex = "iron" },
    corundum = { tex = "purplegem" },
    nitro = { tex = "nitre" },
    aurum = { tex = "goldnugget" },
    silicate = { tex = "rocks" },
}

local Ingredients = {
    greengem = { corundum = 54 / 22 }, -- gem
    yellowgem = { corundum = 18 / 22 },
    orangegem = { corundum = 6 / 22 },
    purplegem = { corundum = 2 / 22, },
    bluegem = { corundum = 1 / 22, },
    redgem = { corundum = 1 / 22, },

    ferrum = { ferrum = 1, }, -- iron
    magnifying_glass = { ferrum = 1, },
    goldpan = { ferrum = 1, },
    ballpein_hammer = { ferrum = 1, },
    shears = { ferrum = 1, },
    candlehat = { ferrum = 1, },
    halberd = { ferrum = 1, },
    armor_metalplate = { ferrum = 1, },
    metalplatehat = { ferrum = 1, },

    obsidian = { nitro = 2.5, }, -- nitro
    nitre = { nitro = 1, },
    flint = { nitro = .25, },

    goldnugget = { aurum = 1, }, -- gold
    dubloon = { aurum = .5, },
    gold_dust = { aurum = .25, },

    rocks = { silicate = .25, }, -- mineral
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
        test = function(worker, names, attrs) return attrs.corundum and attrs.corundum >= 4 end,
        overridebuild = "gems",
        overridesymbolname = "opalgem",
        card_def = {
            attributes = { { "greengem", 1 }, { "yellowgem", 1 }, { "orangegem", 2 } },
        },
    },
    greengem = {
        priority = 10,
        test = function(worker, names, attrs) return attrs.corundum and attrs.corundum >= 2.7 end,
        overridebuild = "gems",
        overridesymbolname = "greengem",
        card_def = {
            attributes = { { "yellowgem", 1 }, { "orangegem", 3 } },
        },
    },
    yellowgem = {
        priority = 5,
        test = function(worker, names, attrs) return attrs.corundum and attrs.corundum >= 1 end,
        overridebuild = "gems",
        overridesymbolname = "yellowgem",
        card_def = {
            attributes = { { "orangegem", 1 }, { "purplegem", 3 } },
        },
    },
    orangegem = {
        priority = 3,
        test = function(worker, names, attrs) return attrs.corundum and attrs.corundum >= .35 end,
        overridebuild = "gems",
        overridesymbolname = "orangegem",
        card_def = {
            attributes = { { "purplegem", 2 }, { "bluegem", 3 } },
        },
    },
    alloy = { -- iron
        priority = 5,
        test = function(worker, names, attrs) return attrs.ferrum and attrs.ferrum >= 4 end,
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
        test = function(worker, names, attrs) return attrs.aurum and attrs.aurum >= 2 end,
        overridebuild = "alloygold",
        overridesymbolname = "alloy01",
        card_def = {
            attributes = { { "goldnugget", 1 }, { "dubloon", 1 }, { "gold_dust", 2 } },
        },
    },
    goldnugget = {
        priority = 5,
        test = function(worker, names, attrs) return attrs.aurum and attrs.aurum >= 1 end,
        overridebuild = "tree_rock_normal",
        overridesymbolname = "swap_goldnugget", ---用的 宝石树的资源
        card_def = {
            attributes = { { "gold_dust", 4 } },
        },
    },
    stonebar = { -- mineral
        priority = 1,
        test = function(worker, names, attrs) return attrs.silicate and attrs.silicate >= 1 end,
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
