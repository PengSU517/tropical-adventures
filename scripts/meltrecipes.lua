local Products = {
    ash = {
        priority = -1,
        test = function(worker, names, attrs) return true end,
        overridebuild = "ash",
        overridesymbolname = "ashes01"
    },
    opalpreciousgem = { -- gem
        priority = 20,
        test = function(worker, names, attrs) return attrs.gem and attrs.gem >= 42 end,
        overridebuild = "gems",
        overridesymbolname = "opalgem"
    },
    greengem = {
        priority = 10,
        test = function(worker, names, attrs) return attrs.gem and attrs.gem >= 28 end,
        overridebuild = "gems",
        overridesymbolname = "greengem"
    },
    yellowgem = {
        priority = 5,
        test = function(worker, names, attrs) return attrs.gem and attrs.gem >= 10 end,
        overridebuild = "gems",
        overridesymbolname = "yellowgem"
    },
    orangegem = {
        priority = 3,
        test = function(worker, names, attrs) return attrs.gem and attrs.gem >= 4 end,
        overridebuild = "gems",
        overridesymbolname = "orangegem"
    },
    alloy = { -- iron
        priority = 5,
        test = function(worker, names, attrs) return attrs.iron and attrs.iron >= 4 end,
        overridebuild = "alloy",
        overridesymbolname = "alloy01"
    },
    gunpowder = { -- nitro
        priority = 3,
        test = function(worker, names, attrs) return attrs.nitro and attrs.nitro >= 4 end,
        overridebuild = "gunpowder",
        overridesymbolname = "gunpowder01"
    },
    nitre = {
        priority = 1,
        test = function(worker, names, attrs) return attrs.nitro and attrs.nitro >= 1 end,
        overridebuild = "nitre",
        overridesymbolname = "nitre01"
    },
    goldenbar = { -- gold
        priority = 10,
        test = function(worker, names, attrs) return attrs.gold and attrs.gold >= 2 end,
        overridebuild = "alloygold",
        overridesymbolname = "alloy01"
    },
    goldnugget = {
        priority = 5,
        test = function(worker, names, attrs) return attrs.gold and attrs.gold >= 1 end,
        overridebuild = "gold_dust",
        overridesymbolname = "gold_dust01"
    },
    stonebar = { -- mineral
        priority = 1,
        test = function(worker, names, attrs) return attrs.mineral and attrs.mineral >= 1 end,
        overridebuild = "alloystone",
        overridesymbolname = "alloy01"
    }
}

return Products