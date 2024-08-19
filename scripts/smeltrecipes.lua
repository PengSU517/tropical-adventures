local Products = {
    ash = {
        priority = -1,
        test = function(worker, names, attrs) return true end,
        overridebuild = "ash",
        overridesymbolname = "ashes01",
    },
    opalpreciousgem = { -- gem
        priority = 20,
        test = function(worker, names, attrs) return attrs.gem and attrs.gem >= 42 end,
        overridebuild = "gems",
        overridesymbolname = "opalgem",
        card_def = {
            attributes = {{"greengem", 1}, {"yellowgem", 1}, {"orangegem", 2}},
        },
    },
    greengem = {
        priority = 10,
        test = function(worker, names, attrs) return attrs.gem and attrs.gem >= 28 end,
        overridebuild = "gems",
        overridesymbolname = "greengem",
        card_def = {
            attributes = {{"yellowgem", 3}, {"purplegem", 1}},
        },
    },
    yellowgem = {
        priority = 5,
        test = function(worker, names, attrs) return attrs.gem and attrs.gem >= 10 end,
        overridebuild = "gems",
        overridesymbolname = "yellowgem",
        card_def = {
            attributes = {{"orangegem", 3}, {"purplegem", 1}},
        },
    },
    orangegem = {
        priority = 3,
        test = function(worker, names, attrs) return attrs.gem and attrs.gem >= 4 end,
        overridebuild = "gems",
        overridesymbolname = "orangegem",
        card_def = {
            attributes = {{"purplegem", 4}},
        },
    },
    alloy = { -- iron
        priority = 5,
        test = function(worker, names, attrs) return attrs.iron and attrs.iron >= 4 end,
        overridebuild = "alloy",
        overridesymbolname = "alloy01",
        card_def = {
            attributes = {{"iron", 4}},
        },
    },
    gunpowder = { -- nitro
        priority = 3,
        test = function(worker, names, attrs) return attrs.nitro and attrs.nitro >= 4 end,
        overridebuild = "gunpowder",
        overridesymbolname = "gunpowder01",
        card_def = {
            attributes = {{"nitre", 4}},
        },
    },
    nitre = {
        priority = 1,
        test = function(worker, names, attrs) return attrs.nitro and attrs.nitro >= 1 end,
        overridebuild = "nitre",
        overridesymbolname = "nitre01",
        card_def = {
            attributes = {{"flint", 4}},
        },
    },
    goldenbar = { -- gold
        priority = 10,
        test = function(worker, names, attrs) return attrs.gold and attrs.gold >= 2 end,
        overridebuild = "alloygold",
        overridesymbolname = "alloy01",
        card_def = {
            attributes = {{"goldnugget", 1}, {"dubloon", 1}, {"gold_dust", 2}},
        },
    },
    goldnugget = {
        priority = 5,
        test = function(worker, names, attrs) return attrs.gold and attrs.gold >= 1 end,
        overridebuild = "gold_dust",
        overridesymbolname = "gold_dust01",
        card_def = {
            attributes = {{"gold_dust", 4}},
        },
    },
    stonebar = { -- mineral
        priority = 1,
        test = function(worker, names, attrs) return attrs.mineral and attrs.mineral >= 1 end,
        overridebuild = "alloystone",
        overridesymbolname = "alloy01",
        card_def = {
            attributes = {{"rocks", 4}},
        },
    },
}

return Products
