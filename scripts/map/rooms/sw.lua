-------------------------------------start room to portal room-------------------------------------------------------------
--彩蛋和参数 ----这些参数该怎么放在一个独立的文件里呢
local GROUND = GROUND
local AddRoom = AddRoom


local meadow_fairy_rings =
{
    ["MushroomRingLarge"] = function()
        if math.random(1, 1000) > 985 then return 1 end
        return 0
    end,
    ["MushroomRingMedium"] = function()
        if math.random(1, 1000) > 985 then return 1 end
        return 0
    end,
    ["MushroomRingSmall"] = function()
        if math.random(1, 1000) > 985 then return 1 end
        return 0
    end,
}

local SIZE_VARIATION = 3 --GLOBAL.SIZE_VARIATION
local LIVINGJUNGLETREE_CHANCE = 0.9


AddRoom("ForceDisconnectedRoomSW", {
    colour = { r = .45, g = .75, b = .45, a = .50 },
    type = "blank",
    tags = { "ForceDisconnected" },
    value = WORLD_TILES.IMPASSABLE,
    contents = {},
})



AddRoom("Shipwrecked start", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        -- countstaticlayouts={["shipwrecked_start"]=1},
        distributepercent = .25,
        distributeprefabs =
        {
            rock_limpet = .05,
            crabhole = .2,
            palmtree = .5,
            rocks = .03,      --trying
            rock1 = .1,       --trying
            --rock2 = .2,
            beehive = .01,    --was .05,
            --flower = .04, --trying
            grassnova = .2,   --trying
            saplingnova = .2, --trying
            --fireflies = .02, --trying
            --spiderden = .03, --trying
            flint = .05,
            sandhill = .6,
            seashell_beached = .02,
            wildborehouse = .005,
            crate = .01,
        },
        countstaticlayouts = {
            ["start_sw"] = 1,
        },

    }
})








-------------------------------------------------------- SW PLUS ---------------------------------------------------------
AddRoom("strange_island_eldorado", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.QUAGMIRE_PARKFIELD,
    tags = {},
    contents = {
        countstaticlayouts = { ["eldorado"] = 1 },
        distributepercent = .2,
        distributeprefabs =
        {
            fireflies = 0.1,
            tree_forest_deep = 1,
            roc_nest_tree1 = 0.5,
            roc_nest_tree2 = 0.5,
            roc_nest_bush = 0.5,
            goldnugget = 1,
            berrybush2 = .1,
            flower = .05,
            --										bambootree = 0.5,
            --										bush_vine = .1,
            is_goldobi = .1,
            s_goldobi = .1,
        },

        countprefabs =
        {
            tidalpool = 3,
        }

    }
})



AddRoom("snapdragonforest", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.QUAGMIRE_PARKFIELD,
    tags = {},
    contents = {
        --					countstaticlayouts={["vacation"]=1},					
        distributepercent = .2,
        distributeprefabs =
        {
            fireflies = 0.1,
            tree_forest_deep = 1,
            roc_nest_tree1 = 0.5,
            roc_nest_tree2 = 0.5,
            roc_nest_bush = 0.5,
            goldnugget = 1,
            berrybush2 = .1,
            flower = .05,
            --										bambootree = 0.5,
            --										bush_vine = .1,
            is_goldobi = .1,
            s_goldobi = .1,
        },

        countprefabs =
        {
            snapdragon = 6,
        }
    }
})


AddRoom("snapdragonforestback", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.QUAGMIRE_PARKFIELD,
    tags = {},
    contents = {
        --					countstaticlayouts={["vacation"]=1},					
        distributepercent = .2,
        distributeprefabs =
        {
            fireflies = 0.1,
            tree_forest_deep = 1,
            roc_nest_tree1 = 0.5,
            roc_nest_tree2 = 0.5,
            roc_nest_bush = 0.5,
            goldnugget = 1,
            berrybush2 = .1,
            flower = .05,
            --										bambootree = 0.5,
            --										bush_vine = .1,
            is_goldobi = .1,
            s_goldobi = .1,
        },

        countprefabs =
        {

        }
    }
})


AddRoom("strange_island_walrusvacation", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        countstaticlayouts = { ["vacation"] = 1 },
        distributepercent = .2,
        distributeprefabs =
        {
            saplingnova = 0.25,
            grass = .5,
            palmtree = .1,
            wildborehouse = .05,
            limpetrock = 0.1,
            sandhill = .3,
            seashell_beached = .125,
        },

        countprefabs =
        {
        }

    }
})

AddRoom("strange_island_tikitribe", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.RAINFOREST,
    tags = {},
    contents = {
        countstaticlayouts = { ["tikitribe"] = 1 },
        distributepercent = .25,
        distributeprefabs =
        {
            fireflies = 0.1,
            tree_forest = .5,
            berrybush2 = .1,
            flower = .05,
            grass_tall = 0.25,
            cave_banana_tree = .1,
            marsh_bush = .1,
        },

        countprefabs =
        {
            tikistick = math.random(2, 5)
        }

    }
})
AddRoom("strange_island_tikitribe2", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.RAINFOREST,
    tags = {},
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            fireflies = 0.1,
            tree_forest = .5,
            berrybush2 = .1,
            flower = .05,
            grass_tall = 0.25,
            cave_banana_tree = .1,
            marsh_bush = .1,
        },

        countprefabs =
        {
            tikistick = math.random(2, 5)
        }

    }
})



AddRoom("JungleDense_plus", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.RAINFOREST,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > 0.9 and 1) or 0 end
        },
        distributepercent = 0.4,
        distributeprefabs =
        {
            fireflies = 0.02, --was 0.2,
            tree_forest = 3,  --was 4,
            rock1 = 0.05,
            rock2 = 0.1,      --was .05
            --grassnova = 1, --was .05
            --saplingnova = .8,
            berrybush2 = .1,
            berrybush2_snake = 0.04,
            red_mushroom = .03,
            green_mushroom = .02,
            blue_mushroom = .05,
            flower = 0.75,
            grass_tall = 1,
            flint = 0.1,
            spider_monkey_tree = .1, --was .01
            marsh_bush = 1,
            snake_hole = 0.1,
            --wildborehouse = 0.03, --was 0.015,
            --					                    primeapebarrel_plus = .2,
            cave_banana_tree = 0.01,
        },
    }
})

---------------------------------------------------------------------------------------------------
AddRoom("NoOxMeadow", {
    colour = { r = .8, g = .4, b = .4, a = .50 },
    value = GROUND.MEADOW,
    tags = { "ExitPiece" },
    contents = {
        countstaticlayouts = meadow_fairy_rings,
        distributepercent = .4, --.1, --lowered from .2
        distributeprefabs =
        {
            flint = 0.01,
            grassnova = .4,
            -- ox = 0.05,
            sweet_potato_planted = 0.05,
            beehive = 0.003,
            wasphive = 0.003,
            rocks = 0.003,
            rock_flintless = 0.01,
            flower = .25,
        },
    }
})

AddRoom("MeadowOxBoon", {
    colour = { r = .8, g = .4, b = .4, a = .50 },
    value = GROUND.MEADOW,
    tags = { "ExitPiece" },
    contents = {
        countstaticlayouts = meadow_fairy_rings,
        distributepercent = .4, --was .1,
        distributeprefabs =
        {
            --    ox = .5, --was 1,
            grassnova = 1,
            flower = .5,
            beehive = 0.1,
            wasphive = 0.003,
        },
    }
})

AddRoom("MeadowFlowery", {
    colour = { r = .8, g = .4, b = .4, a = .50 },
    value = GROUND.MEADOW,
    tags = { "ExitPiece" },
    contents = {
        countstaticlayouts = meadow_fairy_rings,
        distributepercent = .5, --.1, --lowered from .2
        distributeprefabs =
        {
            flower = .5,
            beehive = .05, --was .4
            grassnova = .4,
            rocks = .05,
            mandrake_planted = 0.005,
        },
    }
})

AddRoom("MeadowBees", {
    colour = { r = .8, g = .4, b = .4, a = .50 },
    value = GROUND.MEADOW,
    tags = { "ExitPiece" },
    contents = {
        countstaticlayouts = meadow_fairy_rings,
        distributepercent = .4, --.1, --lowered from .2
        distributeprefabs =
        {
            flint = 0.05,               --was .01
            grassnova = 3,              --was .4,
            --ox = 3,
            sweet_potato_planted = 0.1, --was .05,
            rock_flintless = 0.01,
            flower = 0.15,
            beehive = 0.2, -- lowered from 1
            wasphive = 0.05,
        },
    }
})

AddRoom("MeadowCarroty", {
    colour = { r = .8, g = .4, b = .4, a = .50 },
    value = GROUND.MEADOW,
    tags = { "ExitPiece" },
    contents = {
        countstaticlayouts = meadow_fairy_rings,
        distributepercent = .35, --was .1
        distributeprefabs =
        {
            sweet_potato_planted = 1,
            grassnova = 1.5,
            rocks = .2,
            flower = .5,
        },
    }
})


AddRoom("MeadowSappy", {
    colour = { r = .8, g = .4, b = .4, a = .50 },
    value = GROUND.MEADOW,
    tags = { "ExitPiece" },
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            grassnova = 3,
            --saplingnova = 1,
            flower = .5,
            beehive = .1, --was 1,
            wasphive = 0.003,
            sweet_potato_planted = 0.3,
            wasphive = 0.01, --was 0.001
        },
    }
})

AddRoom("MeadowSpider", {
    colour = { r = .8, g = .4, b = .4, a = .50 },
    value = GROUND.MEADOW,
    tags = { "ExitPiece" },
    contents = {
        distributepercent = .4, --was .2
        distributeprefabs =
        {
            spiderden = .1,
            grassnova = 1,
            --saplingnova = .8,
            --ox = .5,
            flower = .5,
        },
    }
})

AddRoom("MeadowRocky", {
    colour = { r = .8, g = .4, b = .4, a = .50 },
    value = GROUND.MEADOW,
    tags = { "ExitPiece" },
    contents = {
        distributepercent = .4, --was .1,
        distributeprefabs =
        {
            rock_flintless = 1,
            rocks = 1,
            rock1 = 1,
            rock2 = 1,
            grassnova = 4, --was 2
            flower = 1,
        },
    }
})

AddRoom("MeadowMandrake", {
    colour = { r = .8, g = .4, b = .4, a = .50 },
    value = GROUND.MEADOW,
    tags = { "ExitPiece" },
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            grassnova = .8,
            --saplingnova = .8,
            sweet_potato_planted = 0.05,
            rocks = 0.003,
            rock_flintless = 0.01,
            flower = .25,
        },
        countprefabs =
        {
            mandrake_planted = math.random(1, 2)
        }
    }
})

--Forest-magma-------------------------------------------------------------------------------------------------------------

AddRoom("Magma", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.MAGMAFIELD,
    tags = {},
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            magmarock = 2, --nitre
            magmarock_gold = 1,
            rock1 = .25,
            rock2 = .25, --gold
            rocks = .25,
            flint = 0.5, -- lowered from 3
            spiderden = .1,
            -- saplingnova = 1.0,
        },
    }
})

AddRoom("MagmaHome", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.MAGMAFIELD,
    tags = {},
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            magmarock_gold = 2,
            magmarock = 2,
            rock1 = .2, --nitre
            --rock2 = 2, --gold
            rock_flintless = 1,
            rocks = .25, --was 0.5
            flint = 0.1, -- lowered from 3
            -- rock_ice = 1,
            --tallbirdnest= --2, --.1,
            spiderden = .1,
            --saplingnova = 0.5,

        },

        countprefabs =
        {
            flint = 4
        }
    }
})

AddRoom("MagmaHomeBoon", {
    colour = { r = .66, g = .66, b = .66, a = .50 },
    value = GROUND.MAGMAFIELD,
    tags = {},
    contents = {
        distributepercent = .2,
        distributeprefabs =
        {
            magmarock = 1,
            magmarock_gold = 1,
            --rock1 = 2, --nitre
            rock2 = 1, --gold
            rock_flintless = 2,
            rocks = .25,
            flint = 1, -- lowered from 3
            -- rock_ice = 1,
            --tallbirdnest= --2, --.1,
            spiderden = .1,
            saplingnova = 0.5,
        },

        countprefabs =
        {
            flint = 4
        }
    }
})

AddRoom("BG_Magma", {
    colour = { r = .66, g = .66, b = .66, a = .50 },
    value = GROUND.MAGMAFIELD,
    tags = {},
    contents = {
        distributepercent = .2,
        distributeprefabs =
        {
            magmarock = 1,
            magmarock_gold = 1,
            flint = 0.5,
            rock1 = 0.2,
            rock2 = 1,
            rocks = 25,
            tallbirdnest = 0.08,
            saplingnova = 1.5,
            spiderden = .1,
        },
    }
})

AddRoom("GenericMagmaNoThreat", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.MAGMAFIELD,
    tags = {},
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            magmarock = 2,
            magmarock_gold = 1,
            rock1 = 0.3,
            rock2 = 0.3,
            --rock_ice = .75,
            rocks = .25,
            flint = 1.5,
            saplingnova = .05,
            blue_mushroom = .002,
            green_mushroom = .002,
            red_mushroom = .002,
            saplingnova = .5,
            spiderden = .1,
        },
    }
})

AddRoom("MagmaVolcano", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.MAGMAFIELD,
    tags = {},
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            magmarock = 1,
            magmarock_gold = 1,
            rock1 = 2,
            rock2 = 2,
            rocks = .25,
            flint = 0.,
            -- saplingnova = .5,
            spiderden = .1,
        },

    }
})

AddRoom("Volcano", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.VOLCANO,
    tags = {},
    --					required_prefabs = {"volcano"},
    contents = {
        --									countstaticlayouts={["Entradavulcao"]=1}, --adds 1 per room
        distributepercent = .2,
        distributeprefabs =
        {
            magmarock = .5,
            magmarock_gold = .5,
            rock_obsidian = .3,
            rock_charcoal = .3,
            volcano_shrub = .2,
            charcoal = 0.04,
            skeleton = 0.1,
        },

        countprefabs =
        {
            volcanofog = math.random(1, 2),
            -- volcano = 1,
            cave_entrance_vulcao = 1,
        },

        prefabdata =
        {
            magmarock = { regen = true },
            magmarock_gold = { regen = true }
        }
    }
})

AddRoom("Volcanofundo", {
    colour = { r = 0.8, g = .8, b = .1, a = .50 },
    value = GROUND.VOLCANO,
    tags = {},
    contents = {
        --						     green_mushroom = .05,
        --					         reeds =  2,
        countprefabs = {
        }
    }
})

AddRoom("Magmadragoon", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.MAGMAFIELD,
    tags = {},
    contents = {
        distributepercent = 0.2,
        distributeprefabs =
        {
            magmarock = 1,
            magmarock_gold = 1,
            rock1 = 0.1, --nitre
            rock2 = 0.1, --gold
            rock_flintless = 0.4,
            rocks = 0.4,
            flint = 0.2, -- lowered from 3
            --  tallbirdnest= .2, --.1,
            --					                    dragoonden= 0.7,
            saplingnova = .3,

        },
        countprefabs =
        {
            dragoonden = 4,
            rock_moon = 2,
        }
    }
})

AddRoom("MagmaGold", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.MAGMAFIELD,
    tags = {},
    contents = {
        distributepercent = .2,
        distributeprefabs =
        {
            magmarock = 0.8,
            magmarock_gold = 1, --gold
            rock1 = 0.5,
            rock2 = 0.3,
            rock_flintless = .1,
            rocks = 0.4,
            flint = .1,
            rock_moon = 0.1,
            goldnugget = .25,
            tallbirdnest = .2,
            saplingnova = .5,
            spiderden = .1,
        },
    }
})

AddRoom("MagmaGoldmoon", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.MAGMAFIELD,
    tags = {},
    contents = {
        --									countstaticlayouts={["CaveEntrance"]=1}, --adds 1 per room					
        distributepercent = .2,
        distributeprefabs =
        {
            magmarock = 0.8,
            magmarock_gold = 1, --gold
            rock1 = 0.5,
            rock2 = 0.3,
            rock_flintless = .1,
            rocks = 0.4,
            flint = .1,
            rock_moon = 0.1,
            goldnugget = .25,
            tallbirdnest = .2,
            saplingnova = .5,
            spiderden = .1,
        },
        countprefabs =
        {
            rock_moon_shell = 1,
            meteorspawner = 2,
        }
    }
})


AddRoom("MagmaGoldBoon", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.MAGMAFIELD,
    tags = {},
    contents = {
        distributepercent = .2,
        distributeprefabs =
        {
            magmarock_gold = 1,
            rock1 = 0.5,
            rock2 = 0.3,
            rocks = 3,
            flint = 1,
            goldnugget = 1,
            tallbirdnest = .1,
            rock_moon = 0.1,
            rock_moon = 2,
            -- saplingnova = .5,
            --spiderden= .1,
        },
    }
})

AddRoom("MagmaTallBird", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.MAGMAFIELD,
    tags = {},
    contents = {
        distributepercent = .2,
        distributeprefabs =
        {
            magmarock = 1,
            magmarock_gold = 0.75,
            rock1 = 0.5,
            rock2 = 0.3,
            rocks = 1,
            rock_moon = 0.1,
            rock_flintless = 1,
            tallbirdnest = .25,
            --saplingnova = .5,
            spiderden = .1,
        },
    }
})

AddRoom("MagmaForest", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.MAGMAFIELD,
    tags = {},
    contents = {
        distributepercent = .2,
        distributeprefabs =
        {
            magmarock = 1,
            magmarock_gold = 0.25,
            rock1 = 0.5,

            rock2 = 0.3,
            obsidian = .02,
            --elephantcactus = 0.2,
            rocks = 2,
            rock_flintless = 1,
            rock_moon = 0.1,
            jungletree = 0.5,
            saplingnova = 2,
            spiderden = .15,
        },

        prefabdata =
        {
            jungletree = { burnt = true },
        }
    }
})



AddRoom("MagmaSpiders", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.MAGMAFIELD,
    tags = { "ExitPiece" },
    contents = {
        distributepercent = .2,
        distributeprefabs =
        {
            magmarock = 2,
            magmarock_gold = 1,
            rock1 = 2, --nitre
            rock2 = 2, --gold
            rock_flintless = 2,
            rocks = 1,
            rock_moon = 0.1,
            flint = 1,         -- lowered from 3
            -- rock_ice = 1,
            tallbirdnest = .2, --.1,
            spiderden = 1.5,   --.5,
            saplingnova = .5,

        },
    }
})

--[[ROOMS]]
---------------------------------------------------------------------------------------------------------------
--Forest-volcano-------------------------------------------------------------------------------------------------------------

AddRoom("VolcanoRock", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.VOLCANO,
    tags = {},
    contents = {
        distributepercent = .15,
        distributeprefabs =
        {
            magmarock = .5,
            magmarock_gold = .5,
            flint = .5,
            obsidian = .02,
            --rocks = 1,
            charcoal = 0.04,
            skeleton = 0.25,
            --elephantcactus = 0.3,

            --coffeebush = 0.25,
            --dragoonden = .2,
        },

        countprefabs =
        {
            --palmtree = math.random(8, 16),
            volcanofog = math.random(1, 2)
        },
    }
})

AddRoom("VolcanoAsh", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.ASH,
    tags = {},
    contents = {
        distributepercent = .1,
        countstaticlayouts = { ["CoffeeBushBunch"] = 1 }, --adds 1 per room
        distributeprefabs =
        {
            --rocks = 1,
            skeleton = 0.05,
            coffeebush = 0.04,
            --elephantcactus = 0.09,
            --dragoonden = .2,
        },

        countprefabs =
        {
            --palmtree = math.random(4, 8),
            volcanofog = math.random(1, 2),
            coffeebush = 6,
            charcoal = 4,
            volcano_shrub = 3,
            elephantcactus = 5
        },
    }
})

AddRoom("VolcanoObsidian", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.VOLCANO_ROCK,
    tags = {},
    contents = {
        --									countstaticlayouts={["beaverking"]=1}, --adds 1 per room
        distributepercent = .2,
        distributeprefabs =
        {
            magmarock = .5,
            magmarock_gold = .5,
            rock_obsidian = .3,
            rock_charcoal = .3,
            volcano_shrub = .2,
            charcoal = 0.04,
            skeleton = 0.1,
            dragoonden = .05,
            elephantcactus = 0.1,
            --coffeebush = 1,
        },

        countprefabs =
        {
            volcanofog = math.random(1, 2)
        },
    }
})

AddRoom("VolcanoStart", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.VOLCANO,
    tags = {},
    contents = {
        countstaticlayouts = { ["Entradavulcao"] = 1 }, --adds 1 per room
        distributepercent = .2,
        distributeprefabs =
        {
            magmarock = .5,
            magmarock_gold = .5,
            rock_obsidian = .5,
            rock_charcoal = .5,
            volcano_shrub = .5,
            charcoal = 0.04,
            skeleton = 0.1,
        },

        countprefabs =
        {
            volcanofog = math.random(1, 2),
            cavelight = 3,
            cavelight_small = 3,
            cavelight_tiny = 3,
        },
    }
})

AddRoom("VolcanoNoise", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.VOLCANO,
    tags = {},
    contents = {
        countstaticlayouts = {
            ["CoffeeBushBunch"] = function() if math.random() < 0.25 then return 1 else return 0 end end },
        distributepercent = .1,
        distributeprefabs =
        {
            magmarock = .5,
            magmarock_gold = .5,
            rock_obsidian = .5,
            rock_charcoal = .5,
            volcano_shrub = .5,
            charcoal = 0.04,
            skeleton = 0.1,
            dragoonden = .05,
            elephantcactus = 1,
            coffeebush = 1,
        },

        countprefabs =
        {
            volcanofog = math.random(1, 2),
        },
    }
})

AddRoom("VolcanoObsidianBench", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.VOLCANO_ROCK,
    tags = {},
    contents = {
        countstaticlayouts = { ["ObsidianWorkbench"] = 1 }, --adds 1 per room
        distributepercent = .1,
        distributeprefabs =
        {
            magmarock = 1,
            magmarock_gold = 1,
            obsidian = .2,
            charcoal = 0.04,
            skeleton = 0.5,
        },
        countprefabs =
        {
            volcanofog = math.random(1, 2),
            cavelight = 2,
            cavelight_small = 2,
            firetwister = 1,
        },
    }
})

AddRoom("VolcanoAltar", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.VOLCANO_ROCK,
    tags = {},
    contents = {
        countstaticlayouts = { ["volcano_altar"] = 1 --[[GetModConfigData("forge")]], },
        distributepercent = .1,
        distributeprefabs =
        {
            magmarock = 1,
            charcoal = 0.04,
            skeleton = 0.5
        },

        countprefabs =
        {
            volcanofog = math.random(1, 2),
            cavelight = 2,
            cavelight_small = 2,
        },

    }
})


AddRoom("VolcanoLavaarena", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.VOLCANO_ROCK,
    tags = {},
    contents = {
        countstaticlayouts = { ["lava_arena"] = 0 --[[GetModConfigData("forge")]], },
        distributepercent = .1,
        distributeprefabs =
        {
            magmarock = 1,
            charcoal = 0.04,
            skeleton = 0.5
        },

        countprefabs =
        {
            volcanofog = math.random(1, 2)
        },

    }
})

AddRoom("VolcanoCage", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.VOLCANO_ROCK,
    tags = {},
    contents = {
        countstaticlayouts = { ["WoodlegsUnlock"] = 1, },
        distributepercent = .1,
        distributeprefabs =
        {
            magmarock = 1,
            charcoal = 0.04,
            skeleton = 0.5,
            dragoonden = .2,
            coffeebush = 0.25,
        },

        countprefabs =
        {
            volcanofog = 1,
            cavelight = 2,
            cavelight_small = 2,
        },
    }
})

AddRoom("VolcanoLava", {
    colour = { r = 1.0, g = 0.55, b = 0, a = .50 },
    value = GROUND.IMPASSABLE,
    type = "blank",
    tags = {},
    contents = {
        distributepercent = 0,
        distributeprefabs = {},
    }
})

--[[ROOMS]]
---------------------------------------------------------------------------------------------------------------
--Forest-tidalmarsh-------------------------------------------------------------------------------------------------------------					

AddRoom("TidalMarsh", {
    colour = { r = 0, g = .5, b = .5, a = .10 },
    value = GROUND.TIDALMARSH,
    tags = {},
    contents = {
        distributepercent = 0.4,
        distributeprefabs =
        {
            jungletree = .05,
            marsh_bush = .05,
            --					                    tidalpool = 0.08,										
            reeds = 1,
            spiderden = .01,
            green_mushroom = 1,
            --					                    mermhouse = 0.01, --was 0.04
            mermfishhouse = 0.05,
            poisonhole = 0.15,
            --					                    seaweed_planted = 0.5,
            --					                    fishinhole = .1,
            flupspawner = 0.7,
            flup = 1,
        },
        countprefabs =
        {
            --mermfishhouse = 5,
            tidalpool = 2,
            poisonhole = 8,
            mermfishhouse = 2,
            reeds = 3,
            --										mermhouse = 2,
            poisonhole = 3,
        },
    }
})

AddRoom("TidalMarsh1", {
    colour = { r = 0, g = .5, b = .5, a = .10 },
    value = GROUND.TIDALMARSH,
    tags = {},
    contents = {
        distributepercent = 0.4,
        distributeprefabs =
        {
            jungletree = .01,
            --marsh_bush = .05,
            reeds = 1,
            --spiderden=.01,
            poisonhole = 0.5,
            green_mushroom = 0.4,
            --                                        mermhouse = 0.2,
            --                                        mermfishhouse = 1.0,
            --                                        tidalpool = 0.8,
            -- poisonhole = 0.1,
            --                                        seaweed_planted = 0.5,
            --                                        fishinhole = .1,
            flupspawner_sparse = 0.2,
            --                                        flup = 1,
        },

        countprefabs =
        {
            mermfishhouse = 3,
            tidalpool = 3,

        },
    }
})


AddRoom("TidalMermMarsh", {
    colour = { r = 0, g = .5, b = .5, a = .10 },
    value = GROUND.TIDALMARSH,
    tags = {},
    contents = {
        distributepercent = 0.1,
        distributeprefabs =
        {
            jungletree = .05,
            marsh_bush = .05,
            reeds = 1,
            spiderden = .01,
            green_mushroom = 1.02,
            --					                    mermhouse = 0.2,
            --					                    mermfishhouse = 1.0,
            poisonhole = 0.2,
            --					                    seaweed_planted = 0.5,
            --					                    fishinhole = .1,
            flupspawner_sparse = 0.3,
            --										tidalpool = 1,
            --					                    flup = 1,
        },

        countprefabs =
        {
            mermfishhouse = 2,
            tidalpool = 2,
            reeds = 6,
        },
    }
})



AddRoom("TidalSharkHome", {
    colour = { r = 0.8, g = .8, b = .1, a = .50 },
    value = GROUND.IMPASSABLE,
    tags = {},
    required_prefabs = { "tigersharkpool" },
    contents = {
        green_mushroom = .05,
        reeds = 2,
        countstaticlayouts = { ["tigersharkarea"] = 1 }, --adds 1 per room
        countprefabs = {
            -- marsh_bush = 1,
            -- tidalpool = 3,
            -- reeds = 7,
            -- poisonhole = 5,
            -- mermfishhouse = 2,
            -- green_mushroom = 7,
            --tigersharkpool = 1,
            -- flupspawner = 3,
        }
    }
})




AddRoom("ToxicTidalMarsh", {
    colour = { r = 0, g = .5, b = .5, a = .10 },
    value = GROUND.TIDALMARSH,
    tags = {},
    contents = {
        distributepercent = 0.2,
        distributeprefabs =
        {
            jungletree = .05,
            marsh_bush = .05,
            tidalpool = 0.2,
            reeds = 2, --was 4
            spiderden = .01,
            green_mushroom = 1.02,
            mermhouse = 0.1, --was 0.04
            mermfishhouse = 0.05,
            poisonhole = 1,  --was 2
            --seaweed_planted = 0.5,
            -- fishinhole = .1,
            flupspawner_dense = 1,
            flup = 2,
        },
    }
})


----------------------------------------tidalnovo--------------------------------------------------------------------------------

AddRoom("TidalMarshnovo", {
    colour = { r = 0, g = .5, b = .5, a = .10 },
    value = GROUND.TIDALMARSH,
    tags = {},
    contents = {
        distributepercent = 0.4,
        distributeprefabs =
        {
            jungletree = .05,
            marsh_bush = .05,
            --					                    tidalpool = 0.08,										
            reeds = 1,
            spiderden = .01,
            green_mushroom = 1,
            --					                    mermhouse = 0.01, --was 0.04
            mermfishhouse = 0.05,
            poisonhole = 0.15,
            --					                    seaweed_planted = 0.5,
            --					                    fishinhole = .1,
            flupspawner = 0.7,
            flup = 1,
        },
        countprefabs =
        {
            --mermfishhouse = 5,
            tidalpool = 2,
            poisonhole = 8,
            mermfishhouse = 2,
            reeds = 3,
            --										mermhouse = 2,
            poisonhole = 3,
        },
    }
})






















--[[ROOMS]]
---------------------------------------------------------------------------------------------------------------
--Beach-------------------------------------------------------------------------------------------------------------					

AddRoom("BeachSand", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            rock_limpet = .05,
            crabhole = .2,
            palmtree = .3,
            rocks = .03,      --trying
            rock1 = .1,       --trying
            --rock2 = .2,
            beehive = .01,    --was .05,
            --flower = .04, --trying
            grassnova = .2,   --trying
            saplingnova = .2, --trying
            --fireflies = .02, --trying
            --spiderden = .03, --trying
            flint = .05,
            sandhill = .6,
            seashell_beached = .02,
            wildborehouse = .01,
            crate = .01,
        },

    }
})

AddRoom("BeachSandHome", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .3, --upped from .05
        distributeprefabs =
        {
            seashell_beached = .25,
            rock_limpet = .05,
            crabhole = .1,       --was 0.2
            palmtree = .3,
            rocks = .03,         --trying
            rock1 = .05,
            rock_flintless = .1, --trying
            --beehive = .05, --trying
            --flower = .04, --trying
            grassnova = .5,   --trying
            saplingnova = .2, --trying
            --fireflies = .02, --trying
            --spiderden = .03, --trying
            flint = .05,
            sandhill = .1, --was .6,
            crate = .025,
        },

        countprefabs =
        {
            flint = 1,
            saplingnova = 1,
        }

    }
})

AddRoom("BeachUnkept", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .3, --lowered from .3
        distributeprefabs =
        {
            seashell_beached = 0.125,
            grassnova = .3,   --down from 3
            saplingnova = .1, --lowered from 15
            --flower = 0.05,
            rock_limpet = .02,
            crabhole = .015, --was .03
            palmtree = .1,
            rocks = .003,
            beehive = .003,
            flint = .02,
            sandhill = .05,
            --rock2 = .01,
            dubloon = .001,
            wildborehouse = .007,
        },
        countprefabs = {
            flint = 3,
            --jungletree = 3, --one palm tree
            --seashell_beached = 1, --one seashell
            --coconut = 1, --one coconut
            --mandrake =0.05,
            saplingnova = 3,
            grassnova = 3,
            --sandhill = .05,
        }

    }
})
AddRoom("BeachUnkeptInicio", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .3, --lowered from .3
        distributeprefabs =
        {
            seashell_beached = 0.125,
            grassnova = .3,   --down from 3
            saplingnova = .1, --lowered from 15
            --flower = 0.05,
            rock_limpet = .02,
            crabhole = .015, --was .03
            palmtree = .1,
            rocks = .003,
            beehive = .003,
            flint = .02,
            sandhill = .05,
            --rock2 = .01,
            dubloon = .001,
            wildborehouse = .007,
        },
        countprefabs = {
            flint = 3,
            --jungletree = 3, --one palm tree
            --seashell_beached = 1, --one seashell
            --coconut = 1, --one coconut
            --mandrake =0.05,
            saplingnova = 6,
            grassnova = 6,
            --sandhill = .05,
        }

    }
})
AddRoom("BeachX", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        countstaticlayouts = { ["x_spot"] = 1 },
        distributepercent = .3, --lowered from .3
        distributeprefabs =
        {
            seashell_beached = 0.125,
            --grassnova = .3, --down from 3
            --saplingnova = .1, --lowered from 15
            --flower = 0.05,
            rock_limpet = .02,
            -- crabhole = .015, --was .03
            palmtree = .1,
            -- rocks = .003,
            -- beehive = .003,
            -- flint = .02,
            sandhill = .05,
            --rock2 = .01,
            dubloon = .001,
            --wildborehouse = .007,
        },
        countprefabs = {
            --flint = 2,
            --jungletree = 3, --one palm tree
            --seashell_beached = 1, --one seashell
            --coconut = 1, --one coconut
            --mandrake =0.05,
            --saplingnova = 3,
            --grassnova = 3,
            --sandhill = .05,
        }

    }
})
AddRoom("BeachUnkeptDubloon", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            seashell_beached = 0.025,
            grassnova = .1,    --was .3
            saplingnova = .05, --was .15
            --flower = 0.05,
            rock_limpet = .02,
            --crabhole = .015, --was .03
            palmtree = .1,
            rocks = .003,
            --beehive = .003,
            flint = .01, --was .02,
            sandhill = .05,
            --rock2 = .01,
            goldnugget = .007,
            dubloon = .01, -- this should be relatively high on this island
            skeleton = .025,
            wildborehouse = .005,
        },

    }
})

AddRoom("BeachGravel", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            rock_limpet = 0.01,
            rocks = 0.1,
            flint = 0.02,
            rock1 = 0.05,
            --rock2 = 0.05,
            rock_flintless = 0.05,
            grassnova = .05,
            --flower = 0.05, --removed as it's used on NoFlower island
            sandhill = .05,
            seashell_beached = .025,
            wildborehouse = .005,
        },
    }
})


AddRoom("BeachSinglePalmTreeHome", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            rock_limpet = .05,
            crabhole = .2,
            palmtree = .3,
            rocks = .03,      --trying
            rock1 = .1,       --trying
            --rock2 = .2,
            beehive = .01,    --was .05,
            --flower = .04, --trying
            grassnova = .2,   --trying
            saplingnova = .2, --trying
            --fireflies = .02, --trying
            --spiderden = .03, --trying
            flint = .05,
            sandhill = .6,
            seashell_beached = .02,
            wildborehouse = .01,
            crate = .01,
        },

    }
})

AddRoom("DoydoyBeach1", {
    colour = { r = .66, g = .66, b = .66, a = .50 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        distributepercent = .1,
        distributeprefabs =
        {
            flower_evil = 0.2,
            jungletree = 1,   --one palm tree
            fireflies = 1,    -- results in an empty beach because these only show at night
            flower = .4,
            bambootree = 0.5, --one palm tree
            bush_vine = 0.2,  --one palm tree
            --sandhill = .5,
        },
        countprefabs = {
            --doydoy = 1,
            --jungletree = 3, --one palm tree
            --seashell_beached = 1, --one seashell
            --coconut = 1, --one coconut
            --mandrake =0.05,
            --beachresurrector = 1,
            --sandhill = .05,
        }
    }
})

AddRoom("DoydoyBeach", {
    colour = { r = .66, g = .66, b = .66, a = .50 },
    value = GROUND.BEACH,
    tags = { "ExitPiece" },
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            flower_evil = 0.5,
            fireflies = 1, -- results in an empty beach because these only show at night
            flower = .3,
            sandhill = .5,
            palmtree = 1,   --one palm tree
            crabhole = 0.3, --one palm tree
            sandhill = .05,
        },
        countprefabs = {
            --doydoy = 1,
            crate = 2,
            --	palmtree = 1, --one palm tree
            seashell_beached = 1, --one seashell
            --coconut = 1, --one coconut
            --mandrake =0.05,
            --beachresurrector = 1,
            --sandhill = .05,
        }
    }
})

AddRoom("BeachWaspy", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .1, -- just copied this whole thing from EvilFlowerPatch in terrain_grass
        distributeprefabs =
        {
            flower_evil = 0.05,
            --fireflies = .1, -- was 1, now .1 (results in an empty beach because these only show at night)
            wasphive = .005,
            sandhill = .05,
            rock_limpet = 0.01,
            flint = .005,
            seashell_beached = .025,
        },

    }
})

AddRoom("BeachPalmForest", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .3,
        distributeprefabs =
        {
            palmtree = .5,
            sandhill = .05,
            crabhole = .025,
            crate = 0.02,
            grassnova = .05,
            rock_limpet = .015,
            flint = .005,
            seashell_beached = .025,
            wildborehouse = .005,
        },
    }
})

AddRoom("BeachPiggy", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .2, -- just copied this whole thing from EvilFlowerPatch in terrain_grass
        distributeprefabs =
        {
            saplingnova = 0.25,
            grassnova = .5,
            palmtree = .1,
            wildborehouse = .05,
            rock_limpet = 0.1,
            sandhill = .3,
            seashell_beached = .125,
        },

    }
})
AddRoom("BeachCassino", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .2, -- just copied this whole thing from EvilFlowerPatch in terrain_grass
        distributeprefabs =
        {
            saplingnova = 0.25,
            grassnova = .5,
            palmtree = .1,
            wildborehouse = .05,
            rock_limpet = 0.1,
            sandhill = .3,
            seashell_beached = .125,
        },

    }
})

AddRoom("BeesBeach", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .3, --Up from .025
        distributeprefabs =
        {
            seashell_beached = 0.025,
            rock_limpet = .05, --reducing from .2 (everything is so low here)
            crabhole = .2,
            palmtree = .3,
            rocks = .03,  --trying
            rock1 = .1,   --trying
            beehive = .1, --was .5
            wasphive = .05,
            --flower = .04, --trying
            grassnova = .4,   --trying
            saplingnova = .4, --trying
            --fireflies = .02, --trying
            --spiderden = .03, --trying
            flint = .05,
            sandhill = .4, --was .04
        },

    }
})

AddRoom("BeachCrabTown", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            rock_limpet = 0.005,
            crabhole = 1,
            saplingnova = .2,
            palmtree = .75,
            grassnova = .5,
            --flower=.1,
            seashell_beached = .01,
            rocks = .1,
            rock1 = .2,
            --fireflies=.1,
            --spiderden=.001,
            flint = .01,
            sandhill = .3,
        },

    }
})

AddRoom("BeachDunes", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .1,
        distributeprefabs =
        {
            sandhill = 1.5,
            grassnova = 1,
            seashell_beached = .5,
            saplingnova = 1,
            rock1 = .5,
            rock_limpet = 0.1,
            wildborehouse = .05,
        },

    }
})

AddRoom("BeachGrassy", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},

    contents = {
        distributepercent = .2, --was .1
        distributeprefabs =
        {
            grassnova = 1.5,
            rock_limpet = .25,
            beehive = .1,
            sandhill = 1,
            rock1 = .5,
            crabhole = .5,
            flint = .05,
            seashell_beached = .25,
        },

    }
})

AddRoom("BeachSappy", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .1,
        distributeprefabs =
        {
            saplingnova = 1,
            crabhole = .5,
            palmtree = 1,
            rock_limpet = 0.1,
            flint = .05,
            seashell_beached = .25,
        },

    }
})

AddRoom("BeachRocky", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .1,
        distributeprefabs =
        {
            rock1 = 1,
            --rock2 = 1, removing to take gold vein rocks out of all beaches
            rocks = 1,
            rock_flintless = 1,
            grassnova = 2,
            crabhole = 2,
            rock_limpet = 0.01,
            flint = .05,
            seashell_beached = .25,
            wildborehouse = .05,
        },

    }
})

AddRoom("BeachLimpety", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .1,
        distributeprefabs =
        {
            rock_limpet = 1,
            rock1 = 1,
            grassnova = 1,
            seashell = 1,
            saplingnova = .5,
            flint = .05,
            seashell_beached = .25,
            wildborehouse = .05,
        },

    }
})

AddRoom("BeachSpider", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .2,
        distributeprefabs =
        {
            rock_limpet = 0.01,
            spiderden = 0.5,
            palmtree = 1,
            grassnova = 1,
            rocks = 0.5,
            saplingnova = 0.2,
            flint = .05,
            seashell_beached = .25,
            wildborehouse = .025,
        },

    }
})

AddRoom("BeachNoFlowers", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .1, --Lowered a bit
        distributeprefabs =
        {
            seashell_beached = 0.0025,
            rock_limpet = .005, --reducing from .03 (everything is so low here)
            crabhole = .002,
            palmtree = .3,
            rocks = .003,     --trying
            beehive = .005,   --trying
            grassnova = .3,   --trying
            saplingnova = .2, --trying
            --fireflies = .002, --trying
            flint = .05,
            sandhill = .055,
        },

    }
})

AddRoom("BeachFlowers", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .5, --was .1
        distributeprefabs =
        {
            beehive = .1, --was .5
            flower = 2,   --was 1
            palmtree = .3,
            rock1 = .1,
            grassnova = .2,
            saplingnova = .1,
            seashell_beached = .025,
            rock_limpet = 0.01,
            flint = .05,
        },

    }
})

AddRoom("BeachNoLimpets", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .1, --Lowered a bit
        distributeprefabs =
        {
            seashell_beached = 0.0025,
            crabhole = .002,
            palmtree = .3,
            rocks = .003,     --trying
            beehive = .0025,  --trying
            --flower = 0.04, --trying
            grassnova = .3,   --trying
            saplingnova = .2, --trying
            --fireflies = .002, --trying
            flint = .05,
            sandhill = .055,
            wildborehouse = .05,
        },

    }
})

AddRoom("BeachNoCrabbits", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .1, --Lowered a bit
        distributeprefabs =
        {
            seashell_beached = 0.0025,
            rock_limpet = 0.01,
            palmtree = .3,
            rocks = .003,     --trying
            beehive = .005,   --trying
            --flower = 0.04, --trying
            grassnova = .3,   --trying
            saplingnova = .2, --trying
            --fireflies = .002, --trying
            flint = .05,
            sandhill = .055,
        },

    }
})

AddRoom("BeachPalmCasino", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        countstaticlayouts = { ["slotmachine"] = 1 }, --adds 1 per room
        distributepercent = .1,                       --Lowered a bit
        distributeprefabs =
        {
            seashell_beached = 0.025,
            rock_limpet = 0.01,
            palmtree = .3,
            rocks = .003,     --trying
            beehive = .005,   --trying
            --flower = 0.04, --trying
            grassnova = .3,   --trying
            saplingnova = .2, --trying
            --fireflies = .002, --trying
            flint = .05,
            sandhill = .055,
        },

        countprefabs = {
            packim_fishbone = 1,
            underwater_entrance1 = 1, --function() if GLOBAL.KnownModIndex:IsModEnabled("Creep in the deeps TE") then return 1 end return 0 end,
            gravestone = 5,
        }

    }
})
AddRoom("BeachShells", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            seashell_beached = 1.25,
            rock_limpet = .05,
            crabhole = .2,
            palmtree = .3,
            rocks = .03,
            rock1 = .025, --was .1,
            --rock2 = .05, --was .2,
            beehive = .02,
            --flower = .04,
            grassnova = .3, --was .2,
            saplingnova = .2,
            --fireflies = .02,
            --spiderden = .03,
            flint = .25,
            sandhill = .1, --was .6,
            wildborehouse = .05,
        },

        countprefabs = {
            --beachresurrector = 1,
            crate = 5,
            --sharkittenspawner = 1,
        }

    }
})
AddRoom("BeachShark", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            seashell_beached = 1.25,
            rock_limpet = .05,
            crabhole = .2,
            palmtree = .3,
            rocks = .03,
            rock1 = .025, --was .1,
            --rock2 = .05, --was .2,
            beehive = .02,
            --flower = .04,
            grassnova = .3, --was .2,
            saplingnova = .2,
            --fireflies = .02,
            --spiderden = .03,
            flint = .25,
            sandhill = .1, --was .6,
            wildborehouse = .05,
        },

        countprefabs = {
            --beachresurrector = 1,
            crate = 5,
            --sharkittenspawner = 1,
        }

    }
})
AddRoom("BeachShells1", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            seashell_beached = 1.25,
            rock_limpet = .05,
            crabhole = .2,
            palmtree = .3,
            rocks = .03,
            rock1 = .025, --was .1,
            --rock2 = .05, --was .2,
            beehive = .02,
            --flower = .04,
            grassnova = .3, --was .2,
            saplingnova = .2,
            --fireflies = .02,
            --spiderden = .03,
            flint = .25,
            sandhill = .1, --was .6,
            wildborehouse = .05,
        },

        countprefabs = {
            --beachresurrector = 1,
            crate = 5,
            --sharkittenspawner = 1,
        }

    }
})


AddRoom("BeachSkull", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        distributepercent = .25,
        distributeprefabs =
        {
            rock_limpet = .05,
            crabhole = .2,
            palmtree = .3,
            rocks = .03,
            rock1 = .1,
            beehive = .01,
            grassnova = .2,
            saplingnova = .2,
            flint = .05,
            sandhill = .6,
            seashell_beached = .02,
            wildborehouse = .005,
            crate = 0.04,
        },

    }
})

--[[ROOMS]]
---------------------------------------------------------------------------------------------------------------
--Forest-jungle-------------------------------------------------------------------------------------------------------------									

AddRoom("JunglePigs", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    --	required_prefabs = {"slipstor"},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        --countstaticlayouts={["DefaultPigking"]=1}, --adds 1 per room
        distributepercent = 0.3,
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = 0.05,
            jungletree = 3,
            rock1 = 0.05,
            flint = 0.05,
            --grassnova = .025,
            --saplingnova = .8,
            berrybush2 = .05,       --was .01,
            berrybush2_snake = .05, --was .01,
            red_mushroom = .06,
            green_mushroom = .04,
            blue_mushroom = .04,
            flower = 0.75,
            bambootree = 1,
            spiderden = .05,
            bush_vine = 1,
            snake_hole = 0.1,
            --					                    wildborehouse = 0.9, --was .015 and also was 2.15??
            --wildborehouse=.05,
        },
        countprefabs =
        {
            --doydoybaby = 1,
            --doydoy = 1,
            primeapebarrel = 2,
        },
    }
})


AddRoom("Beaverkinghome", {
    colour = { r = .55, g = .75, b = .75, a = .50 },
    value = GROUND.MEADOW,
    --required_prefabs = {"octopusking"},
    tags = {},
    contents = {
        --countstaticlayouts={["octopusking"]=1}, --adds 1 per room
        distributepercent = .2,
        distributeprefabs =
        {
            --sweet_potato_planted = 0.5,
            grassnova = 1,
            rocks = .2,
            --beehive = 0.003,
            rocks = 0.003,
            rock_flintless = 0.01,
            flower = .25,
        },
        countprefabs =
        {
            mandrake_planted = 1,
            --doydoybaby = 1,
            --doydoy = 1,
            --octopusking = 1,
            sweet_potato_planted = 7,
            beehive = 5,
        },
    }
})


AddRoom("Beaverkingcity", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.MEADOW,
    tags = {},
    contents = {
        --									countstaticlayouts=
        --									{
        --										["LivingJungleTree"]= function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end	
        --									},
        --countstaticlayouts={["DefaultPigking"]=1}, --adds 1 per room
        distributepercent = 0.35,
        distributeprefabs =
        {
            --   sweet_potato_planted = 1,
            grassnova = 1,
            rocks = .2,
            rock_flintless = 0.01,
            flower = 0.15,
            --beehive = 0.3, -- lowered from 1
        },
        countprefabs =

        {
            sweet_potato_planted = 7,
            beehive = 5,
        },
    }
})


AddRoom("JungleEyeplant", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = .5, --was 0.35
        distributeprefabs =
        {
            fireflies = 0.2,
            jungletree = 2,         --was 3
            berrybush2 = .05,       --was .01,
            berrybush2_snake = .05, --was .01,
            red_mushroom = .06,
            green_mushroom = .04,
            blue_mushroom = .04,
            flower = 1,
            bambootree = 0.5,
            spiderden = .25, --was .001
            bush_vine = 1,
            snake_hole = 0.1,
            --wildborehouse = .5, --just added
            eyeplant = 4,
        },

        countprefabs =
        {
            lureplant = 2,
        },
    }
})

AddRoom("JungleFrogSanctuary", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = 0.35,
        distributeprefabs =
        {
            fireflies = 1,
            --palmtree = 0.5,
            jungletree = 1,         --was 3
            rock1 = 0.05,
            berrybush2 = .05,       --was .01,
            berrybush2_snake = .05, --was .01,
            red_mushroom = .06,
            green_mushroom = .04,
            blue_mushroom = .04,
            flower = 1,
            bambootree = 0.5,
            spiderden = .05, --was .001
            bush_vine = 0.6,
            snake_hole = 0.1,
            pond = 0.1, --was 6


        },
    }
})

AddRoom("JungleBees", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = 0.3,
        distributeprefabs =
        {
            beehive = 0.2,
            fireflies = 0.2,
            jungletree = 4,
            rock1 = 0.05,
            flint = 0.05,
            --grassnova = .025,
            --saplingnova = .8,
            berrybush2 = .05,       --was .01,
            berrybush2_snake = .05, --was .01,
            red_mushroom = .06,
            green_mushroom = .04,
            blue_mushroom = .04,
            flower = 0.75,
            bambootree = 1,
            spiderden = .01, --was .001
            bush_vine = 1,
            snake_hole = 0.1,
        },
    }
})

AddRoom("JungleDenseVery", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = .4, -- lowered from 1.0
        distributeprefabs =
        {
            fireflies = 0.2,
            jungletree = 1, --lowered from 6
            rock2 = 0.05,
            flint = 0.05,
            berrybush2 = .05,       --was .01,
            berrybush2_snake = .05, --was .01,
            red_mushroom = .03,
            green_mushroom = .02,
            blue_mushroom = .02,
            flower = 0.75,
            bambootree = 1,
            spiderden = .05,
            bush_vine = 1,
            snake_hole = 0.1,
            primeapebarrel = 0.05,
            --					                    wildborehouse = .125, --was .05,
            cave_banana_tree = 0.02,
        },
    }
})

AddRoom("JungleClearing", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts = {
            ["MushroomRingLarge"] = function()
                if math.random(0, 1000) > 985 then
                    return 1
                end
                return 0
            end
        },

        distributepercent = .2, --was .1
        distributeprefabs =
        {
            fireflies = 0.2,
            jungletree = 1,
            rock1 = 0.03,
            rock1 = 0.03,
            primeapebarrel = 0.1,
            flint = 0.03,
            grassnova = .03, --was .05
            red_mushroom = .07,
            green_mushroom = .07,
            blue_mushroom = .07,
            flower = 0.75,
            bambootree = .5,
            wasphive = 0.125, --was 0.5
            spiderden = 0.1,
        },
    }
})


AddRoom("Jungle", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = 0.3, --was 0.2
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = 0.5, --lowered this from 6
            jungletree = 3,
            rock1 = 0.05, --was .01
            rock2 = 0.1,  --was .05
            flint = 0.1,  --was 0.03,
            --grassnova = .01, --was .05
            --saplingnova = .8,
            berrybush2 = .09, -- was .0003
            berrybush2_snake = 0.01,
            red_mushroom = .03,
            green_mushroom = .02,
            blue_mushroom = .02,
            flower = 1,          --was 0.75,
            bambootree = 1,
            bush_vine = .2,      -- was 1
            snake_hole = 0.01,   -- was 0.1
            primeapebarrel = .1, --was .05,
            cave_banana_tree = 0.005,
            spiderden = .05,     --was .01,
            --wildborehouse = 0.25,										
        },
    }
})

AddRoom("JungleRockSkull", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts = { ["skull_isle2"] = 1 }, --adds 1 per room
        distributepercent = .1,                       --Lowered a bit
        distributeprefabs =
        {
            fireflies = 0.2,
            jungletree = 3,
            rock1 = 0.05,     --was .01
            rock2 = 0.1,      --was .05
            flint = 0.1,      --was 0.03,
            berrybush2 = .09, -- was .0003
            berrybush2_snake = 0.01,
            red_mushroom = .03,
            green_mushroom = .02,
            blue_mushroom = .02,
            flower = 1,          --was 0.75,
            bambootree = 1,
            bush_vine = .2,      -- was 1
            snake_hole = 0.01,   -- was 0.1
            primeapebarrel = .1, --was .05,
            cave_banana_tree = 0.005,
            spiderden = .05,     --was .01,									
        },

    }
})
AddRoom("DoyDoyF", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts = { ["doydoyf"] = 1 }, --adds 1 per room
        distributepercent = .1,                   --Lowered a bit
        distributeprefabs =
        {
            fireflies = 0.2,
            jungletree = 3,
            rock1 = 0.05,     --was .01
            rock2 = 0.1,      --was .05
            flint = 0.1,      --was 0.03,
            berrybush2 = .09, -- was .0003
            red_mushroom = .03,
            green_mushroom = .02,
            blue_mushroom = .02,
            flower = 1,     --was 0.75,
            bambootree = 1,
            bush_vine = .2, -- was 1
            spiderden = 0,  --was .01,										
        },

    }
})
AddRoom("JungleSparse", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = 0.25,
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = .05,
            jungletree = 2, --.6,
            rock1 = 0.05,
            rock2 = 0.05,
            rocks = .3,
            flint = .1,       --dropped
            --saplingnova = .8,
            berrybush2 = .05, --was .03
            berrybush2_snake = 0.01,
            --grassnova = 1,
            red_mushroom = .03,
            green_mushroom = .02,
            blue_mushroom = .02,
            flower = .5,       --was 0.75
            bambootree = 1,
            bush_vine = .2,    -- was 1
            snake_hole = 0.01, -- was 0.1
            spiderden = 0.05,
            --wildborehouse = 0.25,
        },
    }
})

AddRoom("JungleSparseHome", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = 0.3, -- upped from 0.15
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = .05,
            jungletree = .6,
            rock_flintless = 0.05,
            -- rock2 = 0.05, --gold rock
            flint = .1, --dropped
            --grassnova = .6, --raised from 05
            --saplingnova = .8,
            berrybush2 = .05, --was .03
            berrybush2_snake = 0.01,
            red_mushroom = .03,
            green_mushroom = .02,
            blue_mushroom = .02,
            flower = 2, --was 0.75,
            bambootree = 1,
            bush_vine = 1,
            snake_hole = 0.1,
            spiderden = .01,
            --wildborehouse = 0.25,
        },
    }
})

AddRoom("JungleDense", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = 0.4,
        distributeprefabs =
        {
            fireflies = 0.02, --was 0.2,
            --palmtree = 0.05,
            jungletree = 3,   --was 4,
            rock1 = 0.05,
            rock2 = 0.1,      --was .05
            --grassnova = 1, --was .05
            --saplingnova = .8,
            berrybush2 = .1,
            berrybush2_snake = 0.04,
            red_mushroom = .03,
            green_mushroom = .02,
            blue_mushroom = .05,
            flower = 0.75,
            bambootree = 1,
            flint = 0.1,
            spiderden = .1, --was .01
            bush_vine = 1,
            snake_hole = 0.1,
            --wildborehouse = 0.03, --was 0.015,
            primeapebarrel = .2,
            cave_banana_tree = 0.01,
        },
    }
})

AddRoom("JungleDenseHome", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = 0.3, --lowered from 0.4
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = 0.05,
            jungletree = 4,
            rock1 = 0.05,
            --rock2 = 0.05, --gold rock
            --grassnova = 1, --was .05
            --saplingnova = .8,
            berrybush2 = .1,         --was .05,
            berrybush2_snake = 0.03, --was 0.01,
            red_mushroom = .03,
            green_mushroom = .02,
            blue_mushroom = .02,
            flower = 0.75,
            bambootree = 1,
            flint = 0.1,
            spiderden = .01,
            bush_vine = 1.5,
            snake_hole = 0.1,
            --wildborehouse = 0.03, --was 0.015,
            --wildborehouse=.05,
        },
    }
})

AddRoom("JungleDenseMed", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        distributepercent = 0.5, ---was 0.75
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = 0.05,
            jungletree = 2, --lowered from 6
            rock1 = 0.05,
            rock2 = 0.05,
            --grassnova = .02, --was .05
            --saplingnova = .8,
            berrybush2 = .06,       --was .03,
            berrybush2_snake = .02, --was .01,
            red_mushroom = .03,
            green_mushroom = .02,
            blue_mushroom = .02,
            flower = 0.75,
            bambootree = 1,
            spiderden = .05, --was .01,
            bush_vine = 2,
            snake_hole = 0.1,
            --wildborehouse = 0.03, --was 0.015,
        },
    }
})

AddRoom("JungleDenseBerries", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        countstaticlayouts = { ["BerryBushBunch"] = 1 }, --adds 1 per room
        distributepercent = 0.35,
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = 0.05,
            jungletree = 4, --was 6
            rock1 = 0.05,
            rock2 = 0.05,
            --grassnova = .02, --was .05
            --saplingnova = .8,
            berrybush2 = .6,        --was .03
            berrybush2_snake = .03, --was .01,
            red_mushroom = .03,
            green_mushroom = .02,
            blue_mushroom = .02,
            flower = 0.75,
            bambootree = 1,
            spiderden = .05, --was .01
            bush_vine = 1,
            snake_hole = 0.1,
            --wildborehouse = 0.15, --was 0.015,
        },
    }
})

AddRoom("JungleDenseMedHome", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = { "ExitPiece" },
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = 0.6, --was 0.75
        distributeprefabs =
        {
            fireflies = 0.2,
            jungletree = 2,         --was 6
            rock_flintless = 0.05,
            berrybush2 = .06,       --was .03,
            berrybush2_snake = .02, --was .01,
            red_mushroom = .03,
            green_mushroom = .02,
            blue_mushroom = .02,
            flower = 0.75,
            bambootree = 1,  -- was 1
            spiderden = .05, --was .01
            bush_vine = 0.8, -- was 1
            snake_hole = 0.1,
        },
        countprefabs =
        {
            bambootree = 5,
            bush_vine = 2,
        },
    }
})

AddRoom("JunglePigGuards", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts = { ["pigguard_berries_easy"] = 1 }, --adds 1 per room
        distributepercent = 0.3,
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = 0.05,
            jungletree = 3,
            rock1 = 0.05,
            flint = 0.05,
            --grassnova = .025,
            --saplingnova = .8,
            berrybush2 = .05,       --was .01,
            berrybush2_snake = .05, --was .01,
            red_mushroom = .06,
            green_mushroom = .04,
            blue_mushroom = .04,
            flower = 0.75,
            bambootree = 1,
            spiderden = .05,
            bush_vine = 1,
            snake_hole = 0.1,
            --wildborehouse=.05,
        },
    }
})

AddRoom("JungleFlower", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = .5, --was 0.35
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = 0.05,
            jungletree = 2, --was 3
            rock1 = 0.05,
            --flint=0.05,
            --grassnova = .025,
            --saplingnova = .4,
            berrybush2 = .05,       --was .01,
            berrybush2_snake = .05, --was .01,
            red_mushroom = .06,
            green_mushroom = .04,
            blue_mushroom = .04,
            flower = 1,
            bambootree = 0.5,
            spiderden = .05, --was .001
            bush_vine = 1,
            snake_hole = 0.1,
            --pond = 1, --frog pond
        },
        countprefabs =
        {
            --butterfly_areaspawner = 6,
        },
    }
})

AddRoom("JungleSpidersDense", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = 0.5, --lowered from .5
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = 0.05,
            jungletree = 4,
            rock1 = 0.05,
            rock2 = 0.05,
            --grassnova = 1, --was .05
            --saplingnova = .8,
            berrybush2 = .1,        --was .05,
            berrybush2_snake = .05, --was 0.01,
            red_mushroom = .03,
            green_mushroom = .02,
            blue_mushroom = .02,
            flower = 0.75,
            bambootree = 1,
            flint = 0.1,
            spiderden = .5,
            bush_vine = 1,
            snake_hole = 0.1,
            --wildborehouse = 0.015,
            primeapebarrel = .2, --was .05,
            cave_banana_tree = 0.01,
        },
    }
})

AddRoom("JungleSpiderCity", {
    colour = { r = .30, g = .20, b = .50, a = .50 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        countprefabs = {
            goldnugget = function() return 3 + math.random(3) end,
        },
        distributepercent = 0.3,
        distributeprefabs = {
            jungletree = 3,
            spiderden = 0.3,
        },
        prefabdata = {
            spiderden = function()
                if math.random() < 0.2 then
                    return { growable = { stage = 3 } }
                else
                    return { growable = { stage = 2 } }
                end
            end,
        },
    }
})

AddRoom("JungleBamboozled", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = .4, --was .5,
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = 0.05,
            jungletree = .09,
            rock1 = 0.05,
            -- flint=0.05,
            --grassnova = .025,
            --saplingnova = .04,
            berrybush2 = .05,       --was .01,
            berrybush2_snake = .05, --was .01,
            red_mushroom = .06,
            green_mushroom = .04,
            blue_mushroom = .04,
            flower = 0.1,
            bambootree = 1,  --was .5,
            spiderden = .05, --was .001,
            bush_vine = .04,
            snake_hole = 0.1,

        },


    }
})

AddRoom("JungleMonkeyHell", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = .3, --was .5
        distributeprefabs =
        {
            fireflies = 0.2,
            jungletree = 2,       --was .4,
            rock1 = 0.125,        --was 0.5,
            rock2 = 0.125,        --was 0.5,
            primeapebarrel = .04, --was .8,
            skeleton = .1,
            flint = 0.5,
            --grassnova = .75,
            --saplingnova = .4,
            berrybush2 = .1,
            berrybush2_snake = .02,
            red_mushroom = .06,
            green_mushroom = .04,
            blue_mushroom = .04,
            flower = .01,
            bambootree = 0.5,
            spiderden = .01,
            bush_vine = .04,
            snake_hole = 0.01,

        },
        countprefabs =
        {
            cave_banana_tree = 3,
        }
    }
})

AddRoom("JungleCritterCrunch", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = .25,
        distributeprefabs =
        {
            fireflies = 0.5,
            --palmtree = 0.05,
            jungletree = 3, --was 3
            rock1 = 0.05,
            --flint=0.05,
            --grassnova = .025,
            --saplingnova = .4,
            berrybush2 = .05,       --was .01,
            berrybush2_snake = .06, --was .01,
            red_mushroom = .06,
            green_mushroom = .04,
            blue_mushroom = .04,
            flower = 2,
            bambootree = 1,
            spiderden = 0.5,
            bush_vine = 0.2,
            snake_hole = 0.1,
            beehive = 1.5, --was 3,
            wasphive = 2,

        },
    }
})

AddRoom("JungleDenseCritterCrunch", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = 0.5, --was 0.75
        distributeprefabs =
        {
            fireflies = 1,
            --palmtree = 0.05,
            jungletree = 6,
            rock_flintless = 0.05,
            --rock2 = 0.05, --gold rock
            --grassnova = .05,
            --saplingnova = .8,
            berrybush2 = .75,       --was 0.3
            berrybush2_snake = .04, --was .01,
            red_mushroom = .03,
            green_mushroom = .02,
            blue_mushroom = .02,
            flower = 1.5,
            bambootree = 1,  --was 1
            spiderden = .05, --was .5,
            bush_vine = 0.8, --was 1
            snake_hole = 0.1,
            --wildborehouse = 0.03, --was 0.015,
            beehive = .01, --was 2,
        },
    }
})

AddRoom("JungleShroomin", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = .5, --was 0.35
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = .5,
            jungletree = 3,
            rock1 = 0.05,
            --flint=0.05,
            --grassnova = 1, --was .4,
            --saplingnova = .3,
            berrybush2 = .05,       --was .01,
            berrybush2_snake = .07, --was .01,
            red_mushroom = 3,
            green_mushroom = 3,
            blue_mushroom = 2,
            flower = 0.7,
            bambootree = 0.5,
            spiderden = .05, --was .001
            bush_vine = .5,
            snake_hole = 0.1,

        },
    }
})

AddRoom("JungleRockyDrop", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = .35,
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = 0.05,
            jungletree = 6,
            rock1 = 1,  --was 3
            rock2 = .5, --was 2
            rock_flintless = 2,
            rocks = 3,
            --flint = 0.05,
            --grassnova = .025,
            --saplingnova = .4,
            berrybush2 = .05,       --was .01,
            berrybush2_snake = .07, --was .01,
            red_mushroom = .06,
            green_mushroom = .04,
            blue_mushroom = .04,
            flower = .9,
            bambootree = 0.5,
            spiderden = .05, --was .001
            bush_vine = 1,
            snake_hole = 0.1,
        },
    }
})

AddRoom("JungleGrassy", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = .5, --was 0.35
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = 0.05,
            jungletree = 2, --was 3
            rock1 = 0.05,
            --flint=0.05,
            --grassnova = 5,
            --saplingnova = .4,
            berrybush2 = .05,       --was .01,
            berrybush2_snake = .05, --was .01,
            red_mushroom = .06,
            green_mushroom = .04,
            blue_mushroom = .04,
            flower = .2,
            bambootree = 0.5,
            spiderden = .05, --was .001
            bush_vine = 1,
            snake_hole = 0.1,
        },
    }
})

AddRoom("JungleSappy", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = .5, --was 0.35
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = 0.05,
            jungletree = 1.5, --was 3
            rock1 = 0.05,
            --flint = 0.05,
            --grassnova = .025,
            saplingnova = 6,
            berrybush2 = .05,       --was .01,
            berrybush2_snake = .05, --was .01,
            red_mushroom = .06,
            green_mushroom = .04,
            blue_mushroom = .04,
            flower = .3,
            bambootree = 0.5,
            spiderden = .001,
            bush_vine = 0.3,
            snake_hole = 0.1,
        },
    }
})

AddRoom("JungleEvilFlowers", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = .5, --was 0.35
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = 0.05,
            jungletree = 2, --was 3
            rock1 = 0.05,
            --flint = 0.05,
            --grassnova = .025,
            --saplingnova = .4,
            berrybush2 = .05,       --was .01,
            berrybush2_snake = .05, --was .01,
            red_mushroom = .06,
            green_mushroom = .04,
            blue_mushroom = .04,
            flower = .9,
            bambootree = 0.5,
            spiderden = .05, --was .001
            bush_vine = 1,
            snake_hole = 0.1,
            flower_evil = 10,
            wasphive = 0.25, --just added
        },

    }
})

AddRoom("JungleParrotSanctuary", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = 0.9,
        distributeprefabs =
        {
            --palmtree = 0.05,
            jungletree = .5,
            rock1 = 0.5,
            rock2 = 0.5,
            rocks = 0.4,
            --grassnova = 0.5, --was .05
            --saplingnova  = 8,
            berrybush2 = .1,        --was .05,
            berrybush2_snake = .05, --was .01,
            red_mushroom = 0.05,
            green_mushroom = 0.03,
            blue_mushroom = 0.02,
            flower = 0.2,
            bambootree = 0.5,
            flint = 0.001,
            spiderden = 0.5,
            bush_vine = 0.9,
            snake_hole = 0.1,
            --wildborehouse = 0.05, --was 0.005,
            primeapebarrel = 0.05,
            fireflies = 0.02,
            cave_banana_tree = 0.02,
        },

    }
})

AddRoom("JungleNoBerry", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = 0.3,
        distributeprefabs =
        {
            --palmtree = 0.05,
            jungletree = 5, --was .5,
            rock1 = 0.5,
            rock2 = 0.5,
            rocks = 0.4,
            --grassnova = 0.6, --was .05
            --saplingnova = .8,
            red_mushroom = 0.05,
            green_mushroom = 0.03,
            blue_mushroom = 0.02,
            flower = 0.2,
            bambootree = 3, --was 0.5,
            flint = 0.001,
            spiderden = 0.5,
            bush_vine = 0.9,
            snake_hole = 0.1,
            --wildborehouse = 0.05, --was 0.005,
            primeapebarrel = 0.05,
            fireflies = 0.02,
            cave_banana_tree = 0.02,
        },

    }
})

AddRoom("JungleNoRock", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = 0.2,
        distributeprefabs =
        {
            --palmtree = 0.05,
            jungletree = 5,
            --grassnova = 0.6, --was .05
            --saplingnova = .8,
            berrybush2 = .05,
            berrybush2_snake = 0.01,
            red_mushroom = 0.05,
            green_mushroom = 0.03,
            blue_mushroom = 0.02,
            flower = 0.2,
            bambootree = 0.5,
            flint = 0.001,
            spiderden = 0.5,
            bush_vine = 0.9,
            snake_hole = 0.1,
            --wildborehouse = 0.005,
            primeapebarrel = .25, --was .05,
            fireflies = 0.02,
            cave_banana_tree = 0.02,
        },

    }
})

AddRoom("JungleNoMushroom", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = 0.4, --was 0.2
        distributeprefabs =
        {
            --palmtree = 0.05,
            jungletree = 5,
            rock1 = 0.05,
            rock2 = 0.05,
            rocks = 0.04,
            --grassnova = 0.6, --was .05
            --saplingnova = .8,
            berrybush2 = .1,        --was .05,
            berrybush2_snake = .05, --was .01,
            flower = 0.2,
            bambootree = 0.5,
            flint = 0.001,
            spiderden = 0.5,
            bush_vine = 0.9,
            snake_hole = 0.1,
            --wildborehouse = 0.05, --was 0.005,
            primeapebarrel = .15, --was .05,
            fireflies = 0.02,
            cave_banana_tree = 0.01,
        },

    }
})

AddRoom("JungleNoFlowers", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =

        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },

        distributepercent = 0.2,
        distributeprefabs =
        {
            --palmtree = 0.05,
            jungletree = 5,
            rock1 = 0.05,
            rock2 = 0.05,
            rocks = 0.04,
            --grassnova = 0.6, --was .05
            --saplingnova = .8,
            berrybush2 = .1,        --was .05,
            berrybush2_snake = .05, --was .01,
            red_mushroom = 0.05,
            green_mushroom = 0.03,
            blue_mushroom = 0.02,
            bambootree = 0.5,
            flint = 0.001,
            spiderden = 0.5,
            bush_vine = 0.9,
            snake_hole = 0.1,
            --wildborehouse = 0.25,
            primeapebarrel = .15, --was .05,
            --pond = 0.05,
            fireflies = 0.02,
            cave_banana_tree = 0.01,
        },

    }
})



AddRoom("JungleMorePalms", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = .5,
        distributeprefabs =
        {
            --palmtree = 3,
            jungletree = .3,
            rock1 = 0.05,
            rock2 = 0.05,
            rocks = 0.04,
            --grassnova = 0.6, --was .05
            --saplingnova = .8,
            berrybush2 = .1,        --was .05,
            berrybush2_snake = .05, --was .01,
            red_mushroom = 0.05,
            green_mushroom = 0.03,
            blue_mushroom = 0.02,
            flower = 0.6,
            bambootree = 0.5,
            flint = 0.001,
            spiderden = 0.5,
            bush_vine = 0.9,
            snake_hole = 0.1,
            --wildborehouse = 0.005,
            primeapebarrel = .15, --was .05,
            fireflies = 0.02,
            cave_banana_tree = 0.01,
        },

    }
})

AddRoom("DoyDoyM", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts = { ["doydoym"] = 1 }, --adds 1 per room
        distributepercent = .1,                   --Lowered a bit
        distributeprefabs =
        {
            fireflies = 0.2,
            jungletree = 3,
            rock1 = 0.05,     --was .01
            rock2 = 0.1,      --was .05
            flint = 0.1,      --was 0.03,
            berrybush2 = .09, -- was .0003
            red_mushroom = .03,
            green_mushroom = .02,
            blue_mushroom = .02,
            flower = 1,          --was 0.75,
            bambootree = 1,
            bush_vine = .2,      -- was 1
            primeapebarrel = .1, --was .05,
            spiderden = 0,       --was .01,											
        },

    }
})

AddRoom("JungleSkeleton", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts =
        {
            ["LivingJungleTree"] = function() return (math.random() > LIVINGJUNGLETREE_CHANCE and 1) or 0 end
        },
        distributepercent = .5, --was 0.35
        distributeprefabs =
        {
            fireflies = 0.2,
            --palmtree = 0.05,
            jungletree = 1.5, --was 3
            rock1 = 0.05,
            --flint = 0.05,
            --grassnova = .025,
            --saplingnova = .4,
            berrybush2 = .05,       --was .01,
            berrybush2_snake = .05, --was .01,
            red_mushroom = .06,
            green_mushroom = .04,
            blue_mushroom = .04,
            flower = .9,
            bambootree = 0.5,
            spiderden = .05, --was .001
            bush_vine = 1,
            snake_hole = 0.1,
            flower_evil = .001,
            skeleton = 1.25,
        },
    }
})




-------------------------------------start room to portal room-------------------------------------------------------------
AddRoom("BeachPortalRoom", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.BEACH,
    tags = {},
    contents = {
        -- countstaticlayouts={["shipwrecked_start"]=1},
        distributepercent = .25,
        distributeprefabs =
        {
            rock_limpet = .05,
            crabhole = .2,
            palmtree = .5,
            rocks = .03,      --trying
            rock1 = .1,       --trying
            --rock2 = .2,
            beehive = .01,    --was .05,
            --flower = .04, --trying
            grassnova = .2,   --trying
            saplingnova = .2, --trying
            --fireflies = .02, --trying
            --spiderden = .03, --trying
            flint = .05,
            sandhill = .6,
            seashell_beached = .02,
            wildborehouse = .005,
            crate = .01,
        },
        countprefabs =
        {
            spawnpoint_multiplayer = 1,
            --vidanomar = 1,
            --lake = 1,
        }

    }
})

AddRoom("PigVillagesw", {
    colour = { r = 0.3, g = .8, b = .5, a = .50 },
    value = GROUND.JUNGLE,
    tags = {},
    contents = {
        countstaticlayouts = {
            ["Farmplot"] = function() return math.random(2, 5) end,
            ["wildboreking"] = 1,
        },

        countprefabs = {
            firepit = 1,
            wildborehouse = function() return 3 + math.random(4) end,
        },
        distributepercent = .1,
        distributeprefabs = {
            grassnova = .05,
            berrybush2 = .05,
            berrybush_juicy = 0.025,
        },
    }
})
