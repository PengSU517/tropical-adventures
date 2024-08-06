local Utils = require("tools/utils")

AddComponentPostInit("birdspawner", function(self)
    local BIRD_TYPES = Utils.ChainFindUpvalue(self.SpawnBird, "PickBird", "BIRD_TYPES")
    if BIRD_TYPES then
        BIRD_TYPES[GROUND.OCEAN_COASTAL] = { "puffin", "cormorant" }
        BIRD_TYPES[GROUND.OCEAN_COASTAL_SHORE] = { "puffin", "cormorant" }
        BIRD_TYPES[GROUND.OCEAN_SWELL] = { "puffin", "cormorant", "seagullwater" }
        BIRD_TYPES[GROUND.OCEAN_ROUGH] = { "puffin", "seagullwater", "cormorant" }
        BIRD_TYPES[GROUND.OCEAN_BRINEPOOL] = { "puffin", "seagullwater" }
        BIRD_TYPES[GROUND.OCEAN_BRINEPOOL_SHORE] = { "puffin" }
        BIRD_TYPES[GROUND.OCEAN_HAZARDOUS] = { "puffin", "seagullwater" }

        BIRD_TYPES[WORLD_TILES.LILYPOND] = { "cormorant", "seagullwater" } -------------------新添加----------------
        BIRD_TYPES[WORLD_TILES.OCEAN_CORAL] = { "puffin", "seagullwater" }
        BIRD_TYPES[WORLD_TILES.MANGROVE] = { "puffin", "seagullwater" }
        BIRD_TYPES[WORLD_TILES.OCEAN_SHALLOW_SHORE] = { "puffin", "seagullwater" }
        BIRD_TYPES[WORLD_TILES.OCEAN_SHALLOW] = { "puffin", "seagullwater" }
        BIRD_TYPES[WORLD_TILES.OCEAN_MEDIUM] = { "puffin", "seagullwater" }
        BIRD_TYPES[WORLD_TILES.OCEAN_DEEP] = { "puffin", "seagullwater" }
        BIRD_TYPES[WORLD_TILES.OCEAN_SHIPGRAVEYARD] = { "puffin", "seagullwater" }




        BIRD_TYPES[GROUND.RAINFOREST] = { "toucan_hamlet", "kingfisher", "parrot_blue" }
        --"kingfisher_swarm",      "toucan_hamlet_swarm", "parrot_blue_swarm"
        BIRD_TYPES[GROUND.DEEPRAINFOREST] = { "toucan_hamlet", "parrot_blue", "kingfisher" }
        ----"kingfisher_swarm",,      "toucan_hamlet_swarm", "parrot_blue_swarm"
        BIRD_TYPES[GROUND.GASJUNGLE] = { "parrot_blue" }
        BIRD_TYPES[GROUND.FOUNDATION] = { "canary", "quagmire_pigeon" }
        BIRD_TYPES[GROUND.FIELDS] = { "crow", "quagmire_pigeon" }
        BIRD_TYPES[GROUND.SUBURB] = { "crow", "quagmire_pigeon" }
        BIRD_TYPES[GROUND.PAINTED] = { "kingfisher", "crow" }
        BIRD_TYPES[GROUND.PLAINS] = { "toucan_hamlet", "kingfisher", "parrot_blue" }
        BIRD_TYPES[GROUND.CHECKEREDLAWN] = { "canary", "quagmire_pigeon" }
        BIRD_TYPES[GROUND.COBBLEROAD] = { "canary", "quagmire_pigeon" }

        BIRD_TYPES[GROUND.TIDALMARSH] = { "toucan" }
        BIRD_TYPES[GROUND.MAGMAFIELD] = { "toucan" }
        BIRD_TYPES[GROUND.MEADOW] = { "parrot", "toucan" }
        BIRD_TYPES[GROUND.BEACH] = { "toucan" }
        BIRD_TYPES[GROUND.JUNGLE] = { "parrot" }
    end
end)
