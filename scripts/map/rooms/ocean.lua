------------把联机内容加进来


AddRoom("Lilypond", {
    colour = { r = 1.0, g = 1.0, b = 1.0, a = 0.3 },
    value = WORLD_TILES.LILYPOND, --GROUND.OCEAN_COASTAL,
    tags = { "RoadPoison", "hamlet", "tropical" },
    contents = {
        distributepercent = .2, --.22, --.26
        distributeprefabs =
        {
            watercress_planted = .05,
            grasswater = .05,
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
    tags = { "RoadPoison", "shipwrecked", "tropical" },
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
            grasswater = 1,
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

AddRoom("OceanBrinepool", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = WORLD_TILES.OCEAN_BRINEPOOL,
    contents = {
        distributepercent = 0.2,
        distributeprefabs =
        {

            -- coralreef = 0.5,
            -- ballphinhouse = .3,
            -- seaweed_planted = .3,
            -- jellyfish_planted = .3,
            -- rainbowjellyfish_planted = 0.2,
            -- spidercoralhole = 0.1,


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
