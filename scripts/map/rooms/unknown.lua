AddRoom("BGNoisenew", {
    colour = { r = .66, g = .66, b = .66, a = .50 },
    value = WORLD_TILES.GROUND_NOISE,
    tags = { "ExitPiece", "Chester_Eyebone" },
    contents = {
        countstaticlayouts =
        {
            ["DefaultPigking"] = 1,
        },
        countprefabs = {
            deerspawningground = 1,
            -- pigking = 1,
        },
        distributepercent = .15,
        -- A bit of everything, and let terrain filters handle the rest.
        distributeprefabs =
        {
            -- flint=0.4,
            -- rocks=0.4,
            -- rock1=0.1,
            -- rock2=0.1,
            -- grass=0.09,
            -- smallmammal = {weight = 0.025, prefabs = {"rabbithole", "molehill"}},
            -- flower=0.003,
            -- spiderden=0.001,
            -- beehive=0.003,
            -- berrybush=0.05,
            -- berrybush_juicy = 0.025,
            -- sapling=0.2,
            -- twiggytree = 0.2,
            -- ground_twigs = 0.06,
            -- pond=.001,
            -- blue_mushroom = .001,
            -- green_mushroom = .001,
            -- red_mushroom = .001,
            -- evergreen=1.5,
        },
    }
})

AddTask("Dig that new rock", {
    locks = { LOCKS.ROCKS },
    keys_given = { KEYS.TRINKETS, KEYS.STONE, KEYS.WOOD, KEYS.TIER1 },
    region_id = "island111", ----------非主大陆没有background_room
    room_choices = {
        -- ["Graveyard"] = 1,
        ["Rocky"] = 3,  --- function() return 1 + math.random(SIZE_VARIATION) end,
        -- ["CritterDen"] = function() return 1 end,
        ["Forest"] = 1, --function() return math.random(SIZE_VARIATION) end,
        -- ["Clearing"] = function() return math.random(SIZE_VARIATION) end,
        -- ["BGNoise"] = 3,
    },
    room_bg = WORLD_TILES.ROCKY,
    background_room = "BGNoisenew", ------------似乎是旁边伴生的room ---对非主大陆无效
    colour = { r = 0, g = 0, b = 1, a = 1 }
})

--出生地设置相关
AddTask("Dig that hamlet", {
    locks = { LOCKS.ROCKS },
    keys_given = { KEYS.TRINKETS, KEYS.STONE, KEYS.WOOD, KEYS.TIER1 },
    room_choices = {
        ["MAINdeeprainforest_flytrap_grove"] = 1,
        ["MAINRockyham"] = 1,
        ["MAINdeeprainforest_ruins_exit"] = 1,
        --			["Forest"] = 1,				
    },
    room_bg = GROUND.PLAINS,
    background_room = "MAINRockyham",
    colour = { r = 0, g = 0, b = 1, a = 1 }
})

AddTask("iniciosw", {
    locks = LOCKS.NONE,
    keys_given = { KEYS.PICKAXE, KEYS.AXE, KEYS.GRASS, KEYS.WOOD, KEYS.TIER1 },
    room_choices = {
        ["MAINJungleDenseMedHome"] = 2,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "MAINBeachUnkeptInicio",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})

AddTask("iniciosw2", {
    locks = { LOCKS.ROCKS },
    keys_given = { KEYS.TRINKETS, KEYS.STONE, KEYS.WOOD, KEYS.TIER1 },
    room_choices = {
        ["MAINJungleGrassy"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "MAINJungleDenseMedHome",
    colour = { r = 0, g = 0, b = 1, a = 1 }
})

AddTask("inicioswsw", {
    locks = LOCKS.NONE,
    keys_given = { KEYS.PICKAXE, KEYS.AXE, KEYS.GRASS, KEYS.WOOD, KEYS.TIER1 },
    room_choices = {
        ["JungleDenseMedHome"] = 2,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "BeachUnkeptInicio",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})

AddTask("inicioswsw2", {
    locks = { LOCKS.ROCKS },
    keys_given = { KEYS.TRINKETS, KEYS.STONE, KEYS.WOOD, KEYS.TIER1 },
    room_choices = {
        ["JungleGrassy"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "JungleDenseMedHome",
    colour = { r = 0, g = 0, b = 1, a = 1 }
})

AddTask("inicioham", {
    locks = LOCKS.NONE,
    keys_given = { KEYS.PICKAXE, KEYS.AXE, KEYS.GRASS, KEYS.WOOD, KEYS.TIER1 },
    room_choices = {
        ["MAINBG_plains_inicio"] = 2,
    },
    room_bg = GROUND.PLAINS,
    background_room = "MAINBG_plains_base",
    colour = { r = 0, g = 1, b = 0, a = 1 }
})

AddTask("inicioham2", {
    locks = { LOCKS.ROCKS },
    keys_given = { KEYS.TRINKETS, KEYS.STONE, KEYS.WOOD, KEYS.TIER1 },
    room_choices = {
        ["MAINdeeprainforest_fireflygrove"] = 1,
    },
    room_bg = GROUND.DEEPRAINFOREST,
    background_room = "MAINBG_deeprainforest_base",
    colour = { r = 0, g = 0, b = 1, a = 1 }
})
