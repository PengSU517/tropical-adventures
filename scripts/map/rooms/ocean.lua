------------把联机内容加进来


AddRoom("Lilypond", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = WORLD_TILES.LILYPOND, --GROUND.OCEAN_COASTAL,
    tags = { "RoadPoison", "hamlet", "ExitPiece" },
    contents = {
        distributepercent = .2, --.22, --.26
        distributeprefabs =
        {
            watercress_planted = .05,
            -- grasswater = .05,
            lotus = 0.05,
            reeds_water = .05,
            bioluminescence = 0.05,
            bioluminescence_spawner = 0.001,
        },
        countprefabs =
        {
            hippopotamoose = math.random(2, 4),
            -- bill = math.random(1, 3),
            lilypad = math.random(3, 4),

        },

    }
})

AddRoom("WaterMangrove", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.MANGROVE,
    contents = {
        distributepercent = 0.2,
        distributeprefabs = {
            -- mangrovetree = 1,
            -- fishinhole = 1,
            -- grass_water = 1,
            -- seataro_planted = 0.5,

            tree_mangrove = 1,
            tree_mangrovebee = 0.5,
            fishinhole = 0.5,
            grass_water = 1,
            seataro_planted = 0.5,
            seacucumber_planted = 0.5,
            watertree_root = 0.5,
            ox = 0.5,
            oxbaby = 0.5,
            bioluminescence = 1,
            bioluminescence_spawner = 0.1,



        },

        countprefabs = {
            watertree_pillar2 = 1,

        },
        prefabspawnfn = {
            fishinhole = function(x, y, ents)
                return not SpawnUtil.IsCloseToLandTile(x, y, 8)
                --SpawnUtil.GetShortestDistToPrefab(x, y, ents, "shipgravefog") >= 16 * TILE_SCALE
            end
        },
    }
})


AddRoom("WaterAll", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.OCEAN_SHALLOW_SHORE,
    contents = {
        distributepercent = 0.009,
        distributeprefabs = {},

        countprefabs = {
            ia_messagebottleempty = 15
        },
    }
})

AddRoom("WaterShallowShore", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.OCEAN_SHALLOW,
    contents = {
        distributepercent = 0.005,
        distributeprefabs = {
            wobster_den_spawner_shore = 1,
            lobsterhole = 1,

        },

    }
})

AddRoom("WaterShallow", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.OCEAN_SHALLOW,
    contents = {
        distributepercent = 0.01,
        distributeprefabs = {


            driftwood_log = 1,
            bullkelp_plant = 2,
            messagebottle = 0.3,
            -- messagebottle1 = 20,

            messagebottle1 = 0.3,
            seaweed_planted = 3 / 2,
            mussel_farm = 4 / 2,
            lobsterhole = 1 / 2,
            ballphinhouse = .1 / 2,
            solofish_spawner = 1 / 2,
            jellyfish_spawner = 1 / 2,
            rainbowjellyfish_spawner = 0.25 / 2,
            bioluminescence_spawner = 0.1,
        },

        countstaticlayouts = {
            ["BullkelpFarmSmall"] = 6,
            ["BullkelpFarmMedium"] = 3,
            -- ["AbandonedRaftBoon"] = 2,
            -- ["WilburUnlock"] = 1,

        }
    }
})

AddRoom("WaterMedium", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.OCEAN_MEDIUM,
    contents = {
        distributepercent = 0.005,
        distributeprefabs = {
            seastack = 1.0,
            seastack_spawner_swell = 0.10,
            oceanfish_shoalspawner = 0.07,

            ballphinhouse = 5,
            fishinhole = 5,
            -- jellyfish_spawner = 4 * 2,
            -- rainbowjellyfish_spawner = 1 * 2,
            -- solofish_spawner = 12 * 2,
            redbarrel = 1,
            -- barrel_gunpowder = 2,
            seagullspawner = 6,
            -- stungray_spawner = 8,
            oceanfog = 2,
            tar_pool = 1,
            bioluminescence_spawner = 5,
        },
        countstaticlayouts =
        {
            -- ["CrabKing"] = 1,
        },
    }
})

AddRoom("WaterDeep", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.OCEAN_DEEP,
    contents = {
        distributepercent = 0.01,
        distributeprefabs = {

            seastack = 1,
            waterplant = 1.5,
            seastack_spawner_rough = 0.09,
            waterplant_spawner_rough = 0.04,


            fishinhole = 0.5,
            -- solofish_spawner = 0.2,
            -- ballphin_spawner = 0.2,
            -- swordfish_spawner = 0.2,
            redbarrel = 0.1,
            -- barrel_gunpowder = 1, -- redbarrel = 1,
            bioluminescence_spawner = .5,
            oceanfog = 0.1,
        },

        countprefabs = {
            luggagechest = 4,
            rawling = 1
        },

        --     prefabdata = {
        --         luggagechest = { joeluggage = true },
        --     },

        countstaticlayouts = {

            -- ["HermitcrabIsland"] = 1,
            -- ["MonkeyIsland"] = 1,
            -- ["AbandonedSailBoon"] = 2,
            -- ["FeedingFrenzy"] = 1,
            -- ["Volcano"] = 1
        },

        --     staticlayoutspawnfn = {
        --         ["Volcano"] = function(x, y, ents)
        --             local width, height = WorldSim:GetWorldSize()
        --             local dist_from_edge = GetDistFromEdge(x, y, width, height)
        --             return 24 <= dist_from_edge and dist_from_edge <= 100 and
        --                 SpawnUtil.GetDistToSpawnPoint(x, y, ents) >= 600
        --         end,
        --     }
    }
})

AddRoom("WaterCoral", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.OCEAN_CORAL,
    contents = {
        countprefabs = {
            coral_brain_rock = math.random(3, 5),
            octopusking = 1,
        },

        distributepercent = 0.2,
        distributeprefabs = {

            coralreef = 0.5,
            ballphinhouse = .3,
            seaweed_planted = .3,
            jellyfish_planted = .3,
            rainbowjellyfish_planted = 0.2,
            spidercoralhole = 0.1,


            -- fishinhole = .75,
            -- rock_coral = 1,
            -- ballphinhouse = .1,
            -- seaweed_planted = .3,
            -- jellyfish_planted = .3,
            -- rainbowjellyfish_planted = 0.2,
            -- solofish_spawner = .3,
        },

        countstaticlayouts = {
            -- ["octopuskinghome"] = 1,
            -- ["OctopusKing"] = 1,
            -- ["CritterDenSW"] = 1,
            -- ["Wreck"] = 2,
        },
    }
})



AddRoom("WaterShipGraveyard", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.OCEAN_SHIPGRAVEYARD,
    contents = {

        countprefabs = {
            kraken = 1,
        },

        distributepercent = 0.15,
        distributeprefabs = {

            -- boatfragment03 = 1,
            boatfragment04 = 0.3,
            boatfragment05 = 0.3,
            seastack = 1,


            fishinhole = .6,
            waterygrave = 1,
            wreck = .8,
            seaweed_planted = .6,

            pirateghost = .8,
            redbarrel = 0.4,
            bishopwaterfixo = .1,
            rookwater = .1,
            knightboat = .1,

            luggagechest_spawner = .05,
            boatfragment01 = 0.2,
            boatfragment02 = 0.2,
            boatfragment03 = 0.2,
            whale_bluefinal = 0.2,



            -- fishinhole = .3,
            -- waterygrave = .7,
            -- shipwreck = .4,
            -- seaweed_planted = .3,
            -- solofish_spawner = .03,
            -- shipgravefog = .3,
            -- swordfish_spawner = .12,
        },

        -- prefabdata = {
        --     shipwreck = { haunted = true }
        -- },

        -- prefabspawnfn = {
        --     shipgravefog = function(x, y, ents)
        --         return SpawnUtil.GetShortestDistToPrefab(x, y, ents, "shipgravefog") >= 16 * TILE_SCALE
        --     end
        -- },

        -- countprefabs = {
        --     waterygrave = 6,
        -- },

        countstaticlayouts = {
            -- ["wreck"] = 1,
            -- ["wreck2"] = 1,
            -- ["kraken"] = 1,
            -- ["Wreck"] = 2,
            -- ["ShipgraveLuggage"] = math.random(4, 8)
        },
    }
})


AddRoom("OceanBrinepool", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.OCEAN_BRINEPOOL,
    contents = {
        distributepercent = 0.2,
        distributeprefabs =
        {

            coralreef = 0.5,
            ballphinhouse = .3,
            seaweed_planted = .3,
            jellyfish_planted = .3,
            rainbowjellyfish_planted = 0.2,
            spidercoralhole = 0.1,


            -- fishinhole = .75,
            -- rock_coral = 1,
            -- ballphinhouse = .1,
            -- seaweed_planted = .3,
            -- jellyfish_planted = .3,
            -- rainbowjellyfish_planted = 0.2,
            -- solofish_spawner = .3,
        },
    }
})
