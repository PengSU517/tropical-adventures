-- ------------------------------------------------------------------------------SW continental task---------------------------------------------------	
-- --	if GetModConfigData("Shipwrecked") == 10 then

-- AddTask("MISTO6", {
--     locks = {},
--     keys_given = { KEYS.CAVE },
--     region_id = "island2",
--     room_choices = {
--         ["MagmaGold"] = 2,
--         ["MagmaGoldBoon"] = 1,
--     },
--     room_bg = GROUND.MAGMAFIELD,
--     background_room = "Magma",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("MISTO7", {
--     locks = { LOCKS.CAVE },
--     keys_given = { KEYS.CAVE },
--     region_id = "island2",
--     room_choices = {
--         ["PigVillagesw"] = 1,
--         ["JungleDenseBerries"] = 1,
--         ["BeachShark"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "JungleDenseMed",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("MISTO8", {
--     locks = { LOCKS.CAVE },
--     keys_given = { KEYS.INNERTIER },
--     region_id = "island2",
--     room_choices = {
--         ["MagmaTallBird"] = 1,
--         ["MagmaGoldBoon"] = 1,
--     },
--     room_bg = GROUND.MAGMAFIELD,
--     background_room = "BeachDunes",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("MISTO9", {
--     locks = { LOCKS.INNERTIER },
--     keys_given = { KEYS.INNERTIER },
--     region_id = "island2",
--     room_choices = {
--         [salasjungle[math.random(1, 24)]] = 1,
--         ["JungleRockSkull"] = 1,
--         [salasjungle[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = salasjungle[math.random(1, 24)],
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("MISTO11", {
--     locks = { LOCKS.INNERTIER },
--     keys_given = { KEYS.INNERTIER },
--     region_id = "island2",
--     room_choices = {
--         ["MagmaForest"] = 1, -- MR went from 1-3
--         ["JungleDense"] = 1,
--         ["JunglePigs"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "JungleDense",
--     colour = { 1, .5, .5, .2 },
-- })


-- AddTask("MISTO14", {
--     locks = { LOCKS.INNERTIER },
--     keys_given = { KEYS.OUTERTIER },
--     region_id = "island2",
--     room_choices = {
--         [salasvolcano[math.random(1, 5)]] = 1,
--         ["VolcanoAsh"] = 1,
--         ["Volcano"] = 1,
--         ["VolcanoObsidian"] = 1,
--     },
--     room_bg = GROUND.VOLCANO,
--     background_room = "VolcanoNoise",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("MISTO15", {
--     locks = { LOCKS.OUTERTIER },
--     keys_given = { KEYS.OUTERTIER },
--     region_id = "island2",
--     room_choices = {
--         ["TidalMermMarsh"] = 1,
--         [salasbeach[math.random(1, 24)]] = 1,
--         ["BeachSappy"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "BeachSand",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("MISTO16", {
--     locks = { LOCKS.OUTERTIER },
--     keys_given = { KEYS.OUTERTIER },
--     region_id = "island2",
--     room_choices = {
--         [salasjungle[math.random(1, 24)]] = 1,
--         [salasbeach[math.random(1, 24)]] = 1,

--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "BeachUnkept",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("MISTO17", {
--     locks = { LOCKS.OUTERTIER },
--     keys_given = { KEYS.LIGHT },
--     region_id = "island2",
--     room_choices = {
--         ["JungleDenseMed"] = 1,
--         [salasbeach[math.random(1, 24)]] = 1,
--         [salasbeach[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "BeachSand",
--     "BeachUnkept",
--     colour = { 1, .5, .5, .2 },
-- })


-- AddTask("MISTO20", {
--     locks = { LOCKS.LIGHT },
--     keys_given = { KEYS.LIGHT },
--     region_id = "island2",
--     room_choices = {
--         [salasjungle[math.random(1, 33)]] = 1,
--         --        [salasjungle[math.random(1, 33)]] = 1,
--         ["JungleMonkeyHell"] = 2,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "TidalMarsh",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("MISTO26", {
--     locks = { LOCKS.LIGHT },
--     keys_given = { KEYS.LIGHT },
--     region_id = "island2",
--     room_choices = {
--         [salasbeach[math.random(1, 24)]] = 1,
--         [salasbeach[math.random(1, 24)]] = 1,
--         [salastidal[math.random(1, 4)]] = 1,
--         [salasbeach[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.BEACH,
--     background_room = "BeachUnkept",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("MISTO27", {
--     locks = { LOCKS.LIGHT },
--     keys_given = { KEYS.LIGHT },
--     region_id = "island2",
--     room_choices = {
--         ["Magma"] = 1, -- MR went from 1-3
--         ["MagmaGold"] = 1,
--         ["MagmaGoldmoon"] = 1,
--     },
--     room_bg = GROUND.BEACH,
--     background_room = "MagmaGold",
--     "MagmaHomeBoon",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("MISTO28", {
--     locks = { LOCKS.LIGHT },
--     keys_given = { KEYS.FUNGUS },
--     region_id = "island2",
--     room_choices = {
--         ["JungleNoBerry"] = 1,
--         ["TidalSharkHome"] = 1,
--         ["JungleNoBerry"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "JungleRockyDrop",
--     colour = { 1, .5, .5, .2 },
-- })


-- AddTask("MISTO38", {
--     locks = { LOCKS.FUNGUS },
--     keys_given = { KEYS.FUNGUS },
--     region_id = "island2",
--     room_choices = {
--         ["Beaverkinghome"] = 1,
--         ["Beaverkingcity"] = 1,
--         [salasmeadow[math.random(1, 9)]] = 1,
--     },
--     room_bg = GROUND.MEADOW,
--     background_room = "MeadowFlowery",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("MISTO39", {
--     locks = { LOCKS.FUNGUS },
--     keys_given = { KEYS.FUNGUS },
--     region_id = "island2",
--     room_choices = {
--         ["BeachPalmCasino"] = 1,
--         [salasbeach[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.BEACH,
--     background_room = salasbeach[math.random(1, 24)],
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("MISTO43", {
--     locks = { LOCKS.FUNGUS },
--     keys_given = { KEYS.FUNGUS },
--     region_id = "island2",
--     room_choices = {
--         [salasbeach[math.random(1, 24)]] = 1,
--         --        [salasbeach[math.random(1, 24)]] = 1,		 --CM was 5 +
--         ["BeachShark"] = 1,
--     },
--     room_bg = GROUND.BEACH,
--     background_room = "BeachSand",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("MISTO45", {
--     locks = { LOCKS.FUNGUS },
--     keys_given = { KEYS.LABYRINTH },
--     region_id = "island2",
--     room_choices = {
--         ["BeachSand"] = 1,
--         ["BeachPiggy"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "JungleDenseMed",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("MISTO50", {
--     locks = { LOCKS.LABYRINTH },
--     keys_given = { KEYS.LABYRINTH },
--     region_id = "island2",
--     room_choices = {
--         [salasjungle[math.random(1, 24)]] = 1,
--         ["DoyDoyM"] = 1,
--         [salasjungle[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "Jungle",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("MISTO51", {
--     locks = { LOCKS.LABYRINTH },
--     keys_given = { KEYS.CAVE },
--     region_id = "island2",
--     room_choices = {
--         [salasjungle[math.random(1, 24)]] = 1,
--         ["DoyDoyF"] = 1,
--         [salasjungle[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "Jungle",
--     colour = { 1, .5, .5, .2 },
-- })



-- ------------------------------------
-- AddTask("MISTO_eldorado", {
--     locks = { LOCKS.LABYRINTH },
--     keys_given = { KEYS.CAVE },
--     region_id = "eldorado",
--     level_set_piece_blocker = true,
--     room_choices = {
--         ["strange_island_eldorado"] = 1,
--         ["strange_island_tikitribe"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "JungleDense_plus",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("MISTO_tikitribe", {
--     locks = { LOCKS.LABYRINTH },
--     keys_given = { KEYS.CAVE },
--     region_id = "eldorado",
--     level_set_piece_blocker = true,
--     crosslink_factor = math.random(0, 1),
--     make_loop = math.random(0, 100) < 50,
--     room_choices = {
--         ["strange_island_tikitribe"] = 1,
--         ["JungleDense_plus"] = 3,
--         ["BeachSand"] = 2,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "JungleDense_plus",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("MISTO_walrusvacation", {
--     locks = { LOCKS.LABYRINTH },
--     keys_given = { KEYS.CAVE },
--     region_id = "eldorado",
--     level_set_piece_blocker = true,
--     crosslink_factor = math.random(0, 1),
--     make_loop = math.random(0, 100) < 50,
--     room_choices = {
--         ["strange_island_walrusvacation"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "BeachSand",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })



-- AddTask("eldoradojunto", {
--     locks = { LOCKS.LABYRINTH },
--     keys_given = { KEYS.CAVE },
--     region_id = "junto",
--     level_set_piece_blocker = true,
--     room_choices = {
--         ["strange_island_eldorado"] = 1,
--         ["snapdragonforest"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "snapdragonforestback",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("tikitribejunto", {
--     locks = { LOCKS.LABYRINTH },
--     keys_given = { KEYS.CAVE },
--     region_id = "junto",
--     level_set_piece_blocker = true,
--     crosslink_factor = math.random(0, 1),
--     make_loop = math.random(0, 100) < 50,
--     room_choices = {
--         ["strange_island_tikitribe"] = 1,
--         ["strange_island_tikitribe2"] = 1,
--         ["JungleDense_plus"] = 3,
--         --			["BeachSand"] = 2,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "JungleDense_plus",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })

-- AddTask("walrusvacationjunto", {
--     locks = { LOCKS.LABYRINTH },
--     keys_given = { KEYS.CAVE },
--     region_id = "junto",
--     level_set_piece_blocker = true,
--     crosslink_factor = math.random(0, 1),
--     make_loop = math.random(0, 100) < 50,
--     room_choices = {
--         ["strange_island_walrusvacation"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "BeachSand",
--     colour = { r = 0.2, g = 0.6, b = 0.2, a = 0.3 }
-- })


-- ---------------------------------------------------------------SW islands tasks----------------------------------------------------------------------
-- --if GetModConfigData("Shipwrecked") == 15 or GetModConfigData("kindofworld") == 10 then
-- AddTask("TROPICAL6", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical1",
--     room_choices = {
--         ["MagmaGold"] = 2,    -- MR went from 1-3
--         ["MagmaGoldBoon"] = 1 -- MR went from 1-4
--     },
--     room_bg = GROUND.MAGMAFIELD,
--     background_room = "Magma",
--     colour = { 1, .5, .5, .2 },
-- })


-- AddTask("TROPICAL7", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical2",

--     room_choices = {
--         ["PigVillagesw"] = 1,
--         ["JungleDenseBerries"] = 1,
--         ["BeachShark"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "JungleDenseMed",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("TROPICAL8", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical3",
--     room_choices = {
--         ["MagmaTallBird"] = 1,
--         ["MagmaGoldBoon"] = 1,
--     },
--     room_bg = GROUND.MAGMAFIELD,
--     background_room = "BeachDunes",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("TROPICAL9", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical4",
--     room_choices = {
--         [salasjungle[math.random(1, 24)]] = 1,
--         ["JungleRockSkull"] = 1,
--         [salasjungle[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.VOLCANO,
--     background_room = "VolcanoNoise",
--     colour = { r = 1, g = 1, b = 0, a = 1 },
-- })


-- AddTask("TROPICAL11", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical5",
--     room_choices = {
--         ["MagmaForest"] = 1, -- MR went from 1-3
--         ["JungleDense"] = 1,
--         ["JunglePigs"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "JungleDense",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("TROPICAL14", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical6",
--     room_choices = {
--         [salasvolcano[math.random(1, 5)]] = 1,
--         ["VolcanoAsh"] = 1,
--         ["Volcano"] = 1,
--         ["VolcanoObsidian"] = 1,
--     },
--     room_bg = GROUND.VOLCANO,
--     background_room = "VolcanoNoise",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("TROPICAL15", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical7",
--     room_choices = {
--         ["TidalMermMarsh"] = 1,
--         [salasbeach[math.random(1, 24)]] = 1,
--         ["BeachSappy"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "BeachSand",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("TROPICAL16", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical8",
--     room_choices = {
--         [salasjungle[math.random(1, 24)]] = 1,
--         [salasbeach[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "BeachUnkept",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("TROPICAL17", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical9",
--     room_choices = {
--         ["JungleDenseMed"] = 1,
--         [salasbeach[math.random(1, 24)]] = 1,
--         [salasbeach[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "BeachSand",
--     "BeachUnkept",
--     colour = { 1, .5, .5, .2 },
-- })


-- AddTask("TROPICAL20", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical10",
--     room_choices = {
--         [salasjungle[math.random(1, 33)]] = 1,
--         --        [salasjungle[math.random(1, 33)]] = 1,
--         ["JungleMonkeyHell"] = 2,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "TidalMarsh",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("TROPICAL26", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical26",
--     room_choices = {
--         [salasbeach[math.random(1, 24)]] = 1,
--         [salasbeach[math.random(1, 24)]] = 1,
--         [salastidal[math.random(1, 4)]] = 1,
--         [salasbeach[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.BEACH,
--     background_room = "BeachUnkept",
--     colour = { 1, .5, .5, .2 },
-- })


-- AddTask("TROPICAL27", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical11",
--     room_choices = {
--         ["Magma"] = 1, -- MR went from 1-3
--         ["MagmaGold"] = 1,
--         ["MagmaGoldmoon"] = 1,
--     },
--     room_bg = GROUND.BEACH,
--     background_room = "MagmaGold",
--     "MagmaHomeBoon",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("TROPICAL28", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical12",
--     room_choices = {
--         ["JungleNoBerry"] = 1,
--         ["TidalSharkHome"] = 1,
--         ["JungleNoBerry"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "JungleRockyDrop",
--     colour = { 1, .5, .5, .2 },
-- })


-- AddTask("TROPICAL38", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical13",
--     room_choices = {
--         ["Beaverkinghome"] = 1,
--         ["Beaverkingcity"] = 1,
--         [salasmeadow[math.random(1, 9)]] = 1,
--     },
--     room_bg = GROUND.DIRT_NOISE,
--     background_room = "MeadowFlowery",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("TROPICAL39", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical14",
--     room_choices = {
--         ["BeachPalmCasino"] = 1,
--         [salasbeach[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.BEACH,
--     background_room = salasbeach[math.random(1, 24)],
--     colour = { 1, .5, .5, .2 },
-- })


-- AddTask("TROPICAL43", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical15",
--     room_choices = {
--         [salasbeach[math.random(1, 24)]] = 1,
--         --        [salasbeach[math.random(1, 24)]] = 1,	
--         ["BeachShark"] = 1,
--     },
--     room_bg = GROUND.BEACH,
--     background_room = "BeachSand",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("TROPICAL45", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical16",
--     room_choices = {
--         ["BeachSand"] = 1,
--         ["BeachPiggy"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "JungleDenseMed",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("TROPICAL50", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical18",
--     room_choices = {
--         [salasjungle[math.random(1, 24)]] = 1,
--         ["DoyDoyM"] = 1,
--         [salasjungle[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "Jungle",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("TROPICAL51", {
--     locks = {},
--     keys_given = {},
--     region_id = "tropical19",
--     room_choices = {
--         [salasjungle[math.random(1, 24)]] = 1,
--         ["DoyDoyF"] = 1,
--         [salasjungle[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "Jungle",
--     colour = { 1, .5, .5, .2 },
-- })


--if GetModConfigData("kindofworld") == 10 then
AddTask("HomeIslandVerySmall", {
    locks = {},
    keys_given = {},
    region_id = "ship1",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["JungleDenseMedHome"] = 1, -- + math.random(0, 2), --was 5+(0-2) --changed from JungleDense to remove monkeys
        ["BeachSandHome"] = 2,      --was 5
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachSandHome" }, --removed BeachUnkept, added unkept above
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("HomeIslandSmall", {
    locks = {},
    keys_given = {},
    region_id = "ship2",
    room_choices = {
        ["JungleDenseMedHome"] = 2, -- + math.random(0, 2), --was 5+(0-2) --changed from JungleDense to remove monkeys
        ["BeachUnkept"] = 1,        --was 3
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachSandHome" }, --removed BeachUnkept, added unkept above
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("HomeIslandSmallBoon", {
    locks = {},
    keys_given = {},
    region_id = "ship3",
    room_choices = {
        ["JungleDenseHome"] = 2,    -- + math.random(0, 2), --was 5+(0-2)
        ["JungleDenseMedHome"] = 1, -- + math.random(0, 2), --was 5+(0-2) --changed from JungleDense to remove monkeys
        ["BeachSandHome"] = 1,      --was 5
        ["BeachUnkept"] = 1,        --was 3
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachSandHome" }, --removed BeachUnkept, added unkept above
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("HomeIslandMed", {
    locks = {},
    keys_given = {},
    region_id = "ship4",
    room_choices = {
        ["JungleDenseMedHome"] = 3,
        ["BeachUnkept"] = 1, --was 3	
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachSandHome" }, --removed beach unkept, added unkept above
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("HomeIslandLarge", {
    locks = {},
    keys_given = {},
    region_id = "ship5",
    room_choices = {
        ["JungleDenseMedHome"] = 3,
        ["BeachUnkept"] = 2, --was 3
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachSandHome" }, --removed BeachUnkept, added unkept above
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("HomeIslandLargeBoon", {
    locks = {},
    keys_given = {},
    region_id = "ship6",
    room_choices = {
        ["JungleDenseMedHome"] = 3,
        ["BeachUnkept"] = 2, --was 3
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachSandHome" }, --removed BeachUnkept, added unkept above
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("DesertIsland", {
    locks = {},
    keys_given = {},
    region_id = "ship7",
    room_choices = {
        ["BeachSand"] = 2,
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachSand" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("VolcanoIsland", {
    locks = {},
    keys_given = {},
    region_id = "ship8",
    room_choices = {
        ["VolcanoRock"] = 1,
        ["MagmaVolcano"] = 1,
        ["VolcanoObsidian"] = 1,
        ["VolcanoObsidianBench"] = 1,
        ["VolcanoAltar"] = 1,
        ["VolcanoLava"] = 1
    },
    room_bg = GROUND.BEACH,
    background_room = { "VolcanoRock" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("JungleMarsh", {
    locks = {},
    keys_given = {},
    region_id = "ship9",
    room_choices = {
        ["TidalMarsh"] = 2,  --was 3
        ["JungleDense"] = 6, --was 8
        ["JungleDenseBerries"] = 2
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleDense" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("BeachJingleS", {
    locks = {},
    keys_given = {},
    region_id = "ship10",
    room_choices = {
        ["JungleDenseMed"] = 3, -- MR went from 1-3
        ["BeachUnkept"] = 1,    -- MR went from 1-3
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachUnkept" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("BeachBothJungles", {
    locks = {},
    keys_given = {},
    region_id = "ship11",
    room_choices = {
        ["JungleDenseMed"] = 1, -- MR went from 1-3
        ["JungleDense"] = 2,    -- MR went from 1-2
        ["BeachSand"] = 3,      -- MR went from 1-4
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachSand" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("BeachJungleD", {
    locks = {},
    keys_given = {},
    region_id = "ship12",
    room_choices = {
        ["JungleDense"] = 2, -- MR went from 1-2
        ["BeachSand"] = 1,   -- CM was 3
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachSand" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("BeachSavanna", {
    locks = {},
    keys_given = {},
    region_id = "ship13",
    room_choices = {
        ["BeachSand"] = 2,  -- MR went from 2-4
        ["NoOxMeadow"] = 2, -- MR went from 2-4
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachSand" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("GreentipA", {
    locks = {},
    keys_given = {},
    region_id = "ship14",
    room_choices = {
        ["BeachSand"] = 2,      -- MR went from 1-5
        ["MeadowCarroty"] = 1,  -- MR went from 1-3 Plain
        ["JungleDenseMed"] = 3, -- MR went from 1-3
        ["BeachUnkept"] = 1,    --newly added to the mix
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachSand" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("GreentipB", {
    locks = {},
    keys_given = {},
    region_id = "ship15",
    room_choices = {
        ["BeachSand"] = 1,   -- MR went from 1-3
        ["JungleDense"] = 3, -- MR went from 1-3
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachSand" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("HalfGreen", {
    locks = {},
    keys_given = {},
    region_id = "ship16",
    room_choices = {
        ["BeachSand"] = 3,      -- MR went from 1-3
        ["JungleDenseMed"] = 1, -- MR went from 1-2
        ["NoOxMeadow"] = 1,     -- MR went from 1-2
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachSand" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("BeachRockyland", {
    locks = {},
    keys_given = {},
    region_id = "ship17",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachSand"] = 1, --CM was 3 -- MR went from 1-5
        ["Magma"] = 1,     --cm was 3 -- MR went from 1-3
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachSand", "BeachUnkept" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("LotsaGrass", {
    locks = {},
    keys_given = {},
    region_id = "ship18",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["JungleDenseMed"] = 2,
        ["NoOxMeadow"] = 2, -- was 1
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachSand", "JungleSparse" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("AllBeige", {
    locks = {},
    keys_given = {},
    region_id = "ship19",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachSand"] = 1,
        ["Magma"] = 2,
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachSand", "BeachUnkept" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("BeachMarsh", {
    locks = {},
    keys_given = {},
    region_id = "ship20",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachSand"] = 1,
        ["TidalMarsh"] = 2, --was 1
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachSand", "BeachUnkept" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("Verdant", {
    locks = {},
    keys_given = {},
    region_id = "ship21",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachSand"] = 1,
        ["BeachPiggy"] = 1,
        ["JungleDenseMed"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachSand", "BeachUnkept" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("VerdantMost", {
    locks = {},
    keys_given = {},
    region_id = "ship22",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachSand"] = 1,
        ["BeachSappy"] = 1,
        ["JungleDenseMed"] = 1,
        ["JungleDenseBerries"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachSand", "BeachUnkept" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("Vert", {
    locks = {},
    keys_given = {},
    region_id = "ship23",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachSand"] = 1,
        ["MeadowCarroty"] = 1,
        ["JungleDense"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachSand", "BeachUnkept" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("Florida Timeshare", {
    locks = {},
    keys_given = {},
    region_id = "ship24",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["TidalMarsh"] = 1,
        ["JungleDenseMed"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachSand" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("JungleSRockyland", {
    locks = {},
    keys_given = {},
    region_id = "ship25",
    room_choices = {
        ["JungleDenseMed"] = 2, --CM was 3 --was 1
        ["Magma"] = 6,          --CM was 8 --was 1
    },
    room_bg = GROUND.JUNGLE,
    background_room = "JungleSparse",
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("JungleSSavanna", {
    locks = {},
    keys_given = {},
    region_id = "ship26",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["JungleDenseMed"] = 2
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleDenseMed" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("JungleBeige", {
    locks = {},
    keys_given = {},
    region_id = "ship27",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["Magma"] = 2,
        ["JungleDenseMed"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleSparse" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("FullofBees", {
    locks = {},
    keys_given = {},
    region_id = "ship28",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeesBeach"] = 2,
        ["JungleDense"] = 1, --was JungleSparse
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleBees", "SavannaBees" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("JungleDense", {
    ------THIS IS A GOOD EXAMPLE OF THEMED ISLAND
    locks = {},
    keys_given = {},
    region_id = "ship29",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["TidalMarsh"] = 1,
        ["JungleFlower"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "JungleDense",
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("JungleDMarsh", {
    locks = {},
    keys_given = {},
    region_id = "ship30",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["TidalMarsh"] = 1,
        ["JungleDense"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleDenseMed", "TidalMermMarsh" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("JungleDRockyland", {
    locks = {},
    keys_given = {},
    region_id = "ship31",
    room_choices = {
        ["JungleDense"] = 2, --CM was 3
        ["Magma"] = 4,       --CM was 4 --+ math.random(0,1),
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleDense", "Magma" }, --added Magma here instead ((CM - this makes it so that maybe we won't end up with any rock areas on this island))
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("JungleDRockyMarsh", {
    locks = {},
    keys_given = {},
    region_id = "ship32",
    room_choices = {
        -- included 1: Swamp, Magma, JungleDense
        ["TidalMarsh"] = 2,  --CM was 3
        ["JungleDense"] = 4, --CM was 8
        ["Magma"] = 2,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleDense", "BeachSand" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("JungleDSavanna", {
    locks = {},
    keys_given = {},
    region_id = "ship33",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["JungleDense"] = 2,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleDense" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("JungleDSavRock", {
    locks = {},
    keys_given = {},
    region_id = "ship34",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["Magma"] = 1,
        ["JungleDense"] = 2,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleDense" }, --"NoOxMangrove",
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("HotNSticky", {
    locks = {},
    keys_given = {},
    region_id = "ship35",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["TidalMarsh"] = 2,
        ["JungleDenseMed"] = 1,
        ["JungleDense"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleDense", "TidalMarsh" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("Marshy", {
    -- not being called
    locks = {},
    keys_given = {},
    region_id = "ship36",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["TidalMarsh"] = 1,
        ["TidalMermMarsh"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "TidalMarsh",
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("NoGreen A", {
    locks = {},
    keys_given = {},
    region_id = "ship37",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["TidalMarsh"] = 1,
        ["Magma"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "Magma", "TidalMarsh" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("NoGreen B", {
    locks = {},
    keys_given = {},
    region_id = "ship38",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["ToxicTidalMarsh"] = 3,
        ["Magma"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "ToxicTidalMarsh",
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("Savanna", {
    locks = {},
    keys_given = {},
    region_id = "ship39",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachUnkept"] = 2,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "BeachNoCrabbits",
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("Rockyland", {
    locks = {},
    keys_given = {},
    region_id = "ship40",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["Magma"] = 2, --was 1
        ["ToxicTidalMarsh"] = math.random(0, 1),
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachUnkept" }, --was BeachGravel
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("PalmTreeIsland", {
    locks = {},
    keys_given = {},
    region_id = "ship41",
    crosslink_factor = 1,
    make_loop = true,
    room_choices = {
        ["BeachSinglePalmTreeHome"] = 1, -- MR went from 1-5
    },
    room_bg = GROUND.BEACH,
    background_room = "BeachSinglePalmTreeHome",
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

--Test tasks ================================================================================================================================================================
AddTask("IslandParadise", {
    locks = {},
    keys_given = {},
    region_id = "ship42",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachSand"] = 1, --CM + math.random(0, 2),
        ["Jungle"] = 2,    --CM + math.random(0, 1),
        ["MeadowMandrake"] = 1,
        ["Magma"] = 1,     --CM + math.random(0, 1),
        ["JungleDenseVery"] = math.random(0, 1),
    },
    room_bg = GROUND.BEACH,
    --background_room={"BeachSand", "BeachGravel", "BeachUnkept", "Jungle"},
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("PiggyParadise", {
    locks = {},
    keys_given = {},
    region_id = "ship43",
    room_choices = {
        ["JungleDenseBerries"] = 3,
        ["BeachPiggy"] = 5 + math.random(1, 3),
    },
    room_bg = GROUND.TIDALMARSH,
    background_room = { "BeachSand", "BeachPiggy", "BeachPiggy", "BeachPiggy", "TidalMarsh" },
    colour = { r = 0.5, g = 0, b = 1, a = 1 }
})

AddTask("BeachPalmForest", {
    locks = {},
    keys_given = {},
    region_id = "ship44",
    room_choices = {
        ["BeachPalmForest"] = 1 + math.random(0, 3),
    },
    --room_bg=GROUND.IMPASSABLE,
    --background_room="BGImpassable",
    room_bg = GROUND.TIDALMARSH,
    background_room = "BeachPalmForest",
    colour = { r = 0.5, g = 0, b = 1, a = 1 }
})

AddTask("ThemeMarshCity", {
    locks = LOCKS.ISLAND3,
    locks = {},
    keys_given = {},
    region_id = "ship45",
    --entrance_room = "ForceDisconnectedRoom",
    room_choices = {
        ["TidalMermMarsh"] = 1 + math.random(0, 1),
        ["ToxicTidalMarsh"] = 1 + math.random(0, 1),
        ["JungleSpidersDense"] = 1, --CM was 3,
    },
    room_bg = GROUND.TIDALMARSH,
    background_room = { "BeachSand", "BeachPiggy", "TidalMarsh" },
    colour = { r = 0.5, g = 0, b = 1, a = 1 }
})

AddTask("Spiderland", {
    locks = {},
    keys_given = {},
    region_id = "ship46",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["MagmaSpiders"] = 1,
        ["JungleSpidersDense"] = 2,
        ["JungleSpiderCity"] = 1, --need to make this jungly instead of using basegame trees and ground
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "BeachGravel" }, --removed MagmaSpiders
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandJungleBamboozled", {
    locks = {},
    keys_given = {},
    region_id = "ship47",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["JungleBamboozled"] = 1 + math.random(0, 1), -- added the random bonus room
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleBamboozled" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandJungleMonkeyHell", {
    locks = {},
    keys_given = {},
    region_id = "ship48",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["JungleMonkeyHell"] = 3,
        --["JungleDenseBerries"] =1,
        --["JungleDenseMedHome"] =1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "Jungle" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandJungleCritterCrunch", {
    locks = {},
    keys_given = {},
    region_id = "ship49",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["JungleCritterCrunch"] = 2,
        ["JungleDenseCritterCrunch"] = 1,
        --["Jungle"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleDenseCritterCrunch" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandJungleShroomin", {
    locks = {},
    keys_given = {},
    region_id = "ship50",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["JungleShroomin"] = 2,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleDenseMedHome" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandJungleRockyDrop", {
    locks = {},
    keys_given = {},
    region_id = "ship51",
    room_choices = {
        ["MagmaSpiders"] = 2,    --CM was 3
        ["JungleRockyDrop"] = 4, --CM was 8
        ["Jungle"] = 2,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleDenseMedHome" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandJungleEyePlant", {
    locks = {},
    keys_given = {},
    region_id = "ship52",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["JungleEyeplant"] = 1,
        ["TidalMarsh"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleDenseMedHome" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandJungleBerries", {
    locks = {},
    keys_given = {},
    region_id = "ship53",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["JungleDenseBerries"] = 4,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleSparse", "Jungle" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandJungleNoBerry", {
    locks = {},
    keys_given = {},
    region_id = "ship54",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["JungleNoBerry"] = 3,
        --[[ ["Jungle"] = 1,
			["JungleDenseVery"] = 1, ]]
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleSparse", "Jungle" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandJungleNoRock", {
    locks = {},
    keys_given = {},
    region_id = "ship55",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["JungleNoRock"] = 1,
        --["JungleEyeplant"] = 1,
        ["TidalMarsh"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleDenseMed", "JungleDense" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandJungleNoMushroom", {
    locks = {},
    keys_given = {},
    region_id = "ship56",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["JungleNoMushroom"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleNoMushroom" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandJungleNoFlowers", {
    locks = {},
    keys_given = {},
    region_id = "ship57",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["JungleNoFlowers"] = math.random(3, 5),
        --["JungleDenseMedHome"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "Jungle", "JungleDense" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandJungleEvilFlowers", {
    locks = {},
    keys_given = {},
    region_id = "ship58",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["JungleEvilFlowers"] = 2,
        ["ToxicTidalMarsh"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleDenseMed", "JungleClearing" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandJungleSkeleton", {
    locks = {},
    keys_given = {},
    region_id = "ship59",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["JungleSkeleton"] = 1,
        ["JungleDenseMedHome"] = 1,
        ["TidalMermMarsh"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "Jungle", "JungleDense" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandBeachCrabTown", {
    locks = {},
    keys_given = {},
    region_id = "ship60",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachCrabTown"] = math.random(1, 3),
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachSand" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandBeachDunes", {
    locks = {},
    keys_given = {},
    region_id = "ship61",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachDunes"] = 1,
        ["BeachUnkept"] = 1,
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachSand", "BeachUnkept" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandBeachGrassy", {
    locks = {},
    keys_given = {},
    region_id = "ship62",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachGrassy"] = 1,
        ["BeachPalmForest"] = 1,
        ["BeachSandHome"] = 1,
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachUnkept", "BeachGravel" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandBeachSappy", {
    locks = {},
    keys_given = {},
    region_id = "ship63",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachSappy"] = 1,
        ["BeachSand"] = 1,
        ["BeachUnkept"] = 1, --was BeachGravel
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachSandHome", "BeachSappy" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandBeachRocky", {
    locks = {},
    keys_given = {},
    region_id = "ship64",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachRocky"] = 1,
        --["BeachGravel"] = 1,
        ["BeachUnkept"] = 1,
        ["BeachSandHome"] = 1,
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachUnkept", "BeachSandHome" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandBeachLimpety", {
    locks = {},
    keys_given = {},
    region_id = "ship65",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachLimpety"] = 1,
        ["BeachSand"] = 1,
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachSand", "BeachUnkept" }, --was BeachGravel instead of Unkept
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandBeachForest", {
    locks = {},
    keys_given = {},
    region_id = "ship66",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachPalmForest"] = 1,
        ["BeachSandHome"] = 1,
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachUnkept", "BeachSandHome" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandBeachSpider", {
    locks = {},
    keys_given = {},
    region_id = "ship67",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachSpider"] = 2,
        --["BeachUnkept"] = 1,
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachSand", "BeachUnkept" }, --was BeachGravel instead of Unkept
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandBeachNoFlowers", {
    locks = {},
    keys_given = {},
    region_id = "ship68",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachNoFlowers"] = 1,
        ["BeachUnkept"] = 1, --was BeachGravel
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachSand" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandBeachNoLimpets", {
    locks = {},
    keys_given = {},
    region_id = "ship69",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachNoLimpets"] = 1,
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachSand" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandBeachNoCrabbits", {
    locks = {},
    keys_given = {},
    region_id = "ship70",
    crosslink_factor = math.random(0, 1),
    make_loop = math.random(0, 100) < 50,
    room_choices = {
        ["BeachNoCrabbits"] = 2,
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachNoCrabbits" }, --was BeachGravel instead of Unkept
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandMangroveOxBoon", {
    locks = {},
    keys_given = {},
    region_id = "ship71",
    room_choices = {
        ["JungleNoRock"] = 2,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "JungleNoRock" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandMeadowBees", {
    locks = {},
    keys_given = {},
    region_id = "ship72",
    room_choices = {
        ["MeadowBees"] = 1,
        ["NoOxMeadow"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = { "NoOxMeadow" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandMeadowCarroty", {
    locks = {},
    keys_given = {},
    region_id = "ship73",
    room_choices = {
        ["MeadowCarroty"] = 1,
        ["NoOxMeadow"] = 1,
    },
    room_bg = GROUND.MEADOW,
    background_room = { "NoOxMeadow", },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandRockyGold", {
    locks = {},
    keys_given = {},
    region_id = "ship74",
    room_choices = {
        ["MagmaGoldBoon"] = 1,
        ["MagmaGold"] = 1,
        ["BeachSandHome"] = 1,
    },
    room_bg = GROUND.BEACH,
    background_room = { "BeachSandHome" },
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandRockyTallBeach", {
    locks = {},
    keys_given = {},
    region_id = "ship75",
    room_choices = {
        ["MagmaTallBird"] = 1,
        ["GenericMagmaNoThreat"] = 1,
        ["BeachUnkept"] = 1, --was BeachGravel
    },
    room_bg = GROUND.BEACH,
    background_room = "BeachUnkept",
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("IslandRockyTallJungle", {
    locks = {},
    keys_given = {},
    region_id = "ship76",
    room_choices = {
        ["MagmaTallBird"] = 1,
        ["BG_Magma"] = 1,
        ["JungleDenseMed"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "JungleDenseMed",
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("ShellingOut", {
    locks = {},
    keys_given = {},
    region_id = "ship78",
    room_choices = {
        ["BeachShells"] = 2,
    },
    room_bg = GROUND.BEACH,
    background_room = "BeachShells",
    colour = { r = 1, g = 0, b = 0.6, a = 1 },
})

AddTask("Cranium", {
    locks = {},
    keys_given = {},
    region_id = "ship79",
    room_choices = {
        ["BeachSkull"] = 1,
        ["Jungle"] = 2,
    },
    room_bg = GROUND.BEACH,
    background_room = "Jungle",
    colour = { r = 1, g = 0, b = 0.6, a = 1 },
})

AddTask("CrashZone", {
    locks = {},
    keys_given = {},
    region_id = "ship80",
    room_choices = {
        ["Jungle"] = 2,
        ["MagmaForest"] = 1,
    },
    room_bg = GROUND.BEACH,
    background_room = "Jungle",
    colour = { r = 1, g = 0, b = 0.6, a = 1 },
})

AddTask("PirateBounty", {
    locks = {},
    keys_given = {},
    region_id = "ship80",
    room_choices = {
        ["BeachX"] = 1,
    },
    room_bg = GROUND.BEACH,
    background_room = "BeachUnkeptDubloon",
    colour = { r = 1, g = 0, b = 0.6, a = 1 },
})


-- --if GetModConfigData("Shipwrecked") == 20 then  Mainland
-- AddTask("XISTO6", {
--     locks = LOCKS.NONE,
--     keys_given = { KEYS.PICKAXE, KEYS.AXE, KEYS.GRASS, KEYS.WOOD, KEYS.TIER1 },
--     room_choices = {
--         ["MAINMagmaGold"] = 2,
--         ["MAINMagmaGoldBoon"] = 1,
--     },
--     room_bg = GROUND.MAGMAFIELD,
--     background_room = "MAINMagma",
--     colour = { 1, .5, .5, .2 },
-- })


-- AddTask("XISTO7", {
--     locks = { LOCKS.ROCKS },
--     keys_given = { KEYS.TRINKETS, KEYS.STONE, KEYS.WOOD, KEYS.TIER1 },
--     room_choices = {
--         ["MAINPigVillagesw"] = 1,
--         ["MAINJungleDenseBerries"] = 1,
--         ["MAINBeachShark"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "MAINJungleDenseMed",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("XISTO8", {
--     locks = { LOCKS.ROCKS, LOCKS.BASIC_COMBAT, LOCKS.TIER1 },
--     keys_given = { KEYS.MEAT, KEYS.POOP, KEYS.WOOL, KEYS.GRASS, KEYS.TIER2 },
--     room_choices = {
--         ["MAINMagmaTallBird"] = 1,
--         ["MAINMagmaGoldBoon"] = 1,
--     },
--     room_bg = GROUND.MAGMAFIELD,
--     background_room = "MAINBeachDunes",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("XISTO9", {
--     locks = { LOCKS.SPIDERDENS, LOCKS.TIER2 },
--     keys_given = { KEYS.MEAT, KEYS.SILK, KEYS.SPIDERS, KEYS.TIER3 },
--     room_choices = {
--         [salasjungle1[math.random(1, 24)]] = 1,
--         ["MAINJungleRockSkull"] = 1,
--         [salasjungle1[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = salasjungle1[math.random(1, 24)],
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("XISTO11", {
--     locks = { LOCKS.BEEHIVE, LOCKS.TIER1 },
--     keys_given = { KEYS.HONEY, KEYS.TIER2 },
--     room_choices = {
--         ["MAINMagmaForest"] = 1, -- MR went from 1-3
--         ["MAINJungleDense"] = 1,
--         ["MAINJunglePigs"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "MAINJungleDense",
--     colour = { 1, .5, .5, .2 },
-- })


-- AddTask("XISTO14", {
--     locks = { LOCKS.PIGKING, LOCKS.TIER2 },
--     keys_given = { KEYS.PIGS, KEYS.GOLD, KEYS.TIER3 },
--     room_choices = {
--         [salasvolcano1[math.random(1, 5)]] = 1,
--         ["MAINVolcanoAsh"] = 1,
--         ["MAINVolcano"] = 1,
--         ["MAINVolcanoObsidian"] = 1,
--     },
--     room_bg = GROUND.VOLCANO,
--     background_room = "MAINVolcanoNoise",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("XISTO15", {
--     locks = { LOCKS.ADVANCED_COMBAT, LOCKS.MONSTERS_DEFEATED, LOCKS.TIER3 },
--     keys_given = { KEYS.WALRUS, KEYS.TIER4 },
--     room_choices = {
--         ["MAINTidalMermMarsh"] = 1,
--         [salasbeach1[math.random(1, 24)]] = 1,
--         ["MAINBeachSappy"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "MAINBeachSand",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("XISTO16", {
--     locks = { LOCKS.ADVANCED_COMBAT, LOCKS.MONSTERS_DEFEATED, LOCKS.TIER4 },
--     keys_given = { KEYS.HOUNDS, KEYS.TIER5, KEYS.ROCKS },
--     room_choices = {
--         [salasjungle1[math.random(1, 24)]] = 1,
--         [salasbeach1[math.random(1, 24)]] = 1,

--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "MAINBeachUnkept",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("XISTO17", {
--     locks = { LOCKS.BASIC_COMBAT, LOCKS.TIER2 },
--     keys_given = { KEYS.POOP, KEYS.WOOL, KEYS.WOOD, KEYS.GRASS, KEYS.TIER2 },
--     room_choices = {
--         ["MAINJungleDenseMed"] = 1,
--         [salasbeach1[math.random(1, 24)]] = 1,
--         [salasbeach1[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "MAINBeachSand",
--     "MAINBeachUnkept",
--     colour = { 1, .5, .5, .2 },
-- })


-- AddTask("XISTO20", {
--     locks = { LOCKS.SPIDERS_DEFEATED },
--     keys_given = { KEYS.PICKAXE, KEYS.TIER2 },
--     room_choices = {
--         [salasjungle1[math.random(1, 33)]] = 1,
--         --        [salasjungle1[math.random(1, 33)]] = 1,
--         ["MAINJungleMonkeyHell"] = 2,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "MAINTidalMarsh",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("XISTO26", {
--     locks = { LOCKS.PIGGIFTS, LOCKS.TIER1 },
--     keys_given = { KEYS.PIGS, KEYS.MEAT, KEYS.GRASS, KEYS.WOOD, KEYS.TIER2 },
--     room_choices = {
--         [salasbeach1[math.random(1, 24)]] = 1,
--         [salasbeach1[math.random(1, 24)]] = 1,
--         [salastidal1[math.random(1, 4)]] = 1,
--         [salasbeach1[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.BEACH,
--     background_room = "MAINBeachUnkept",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("XISTO27", {
--     locks = { LOCKS.SPIDERDENS, LOCKS.MONSTERS_DEFEATED, LOCKS.TIER3 },
--     keys_given = { KEYS.SPIDERS, KEYS.TIER4 },
--     room_choices = {
--         ["MAINMagma"] = 1, -- MR went from 1-3
--         ["MAINMagmaGold"] = 1,
--         ["MAINMagmaGoldmoon"] = 1,
--     },
--     room_bg = GROUND.BEACH,
--     background_room = "MAINMagmaGold",
--     "MAINMagmaHomeBoon",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("XISTO28", {
--     locks = { LOCKS.KILLERBEES, LOCKS.TIER3 },
--     keys_given = { KEYS.HONEY, KEYS.TIER3 },
--     room_choices = {
--         ["MAINJungleNoBerry"] = 1,
--         ["MAINTidalSharkHome"] = 1,
--         ["MAINJungleNoBerry"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "MAINJungleRockyDrop",
--     colour = { 1, .5, .5, .2 },
-- })


-- AddTask("XISTO38", {
--     locks = { LOCKS.SPIDERS_DEFEATED, LOCKS.TIER1 },
--     keys_given = { KEYS.BEEHAT, KEYS.GRASS, KEYS.TIER1 },
--     room_choices = {
--         ["MAINBeaverkinghome"] = 1,
--         ["MAINBeaverkingcity"] = 1,
--         [salasmeadow1[math.random(1, 9)]] = 1,
--     },
--     room_bg = GROUND.MEADOW,
--     background_room = "MAINMeadowFlowery",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("XISTO39", {
--     locks = { LOCKS.ADVANCED_COMBAT, LOCKS.MONSTERS_DEFEATED, LOCKS.TIER4 },
--     keys_given = { KEYS.WALRUS, KEYS.TIER5 },
--     room_choices = {
--         ["MAINBeachPalmCasino"] = 1,
--         [salasbeach1[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.BEACH,
--     background_room = salasbeach1[math.random(1, 24)],
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("XISTO43", {
--     locks = { LOCKS.TIER1 },
--     keys_given = { KEYS.GRASS, KEYS.MEAT, KEYS.TIER1 },
--     room_choices = {
--         [salasbeach1[math.random(1, 24)]] = 1,
--         [salasbeach1[math.random(1, 24)]] = 1, --CM was 5 +
--         ["MAINBeachShark"] = 1,
--     },
--     room_bg = GROUND.BEACH,
--     background_room = "MAINBeachSand",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("XISTO45", {
--     locks = { LOCKS.BASIC_COMBAT, LOCKS.TIER1 },
--     keys_given = { KEYS.MEAT, KEYS.GRASS, KEYS.HONEY, KEYS.TIER2 },
--     room_choices = {
--         ["MAINBeachSand"] = 1,
--         ["MAINBeachPiggy"] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "MAINJungleDenseMed",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("XISTO50", {
--     locks = { LOCKS.TIER1 },
--     keys_given = { KEYS.TIER2 },
--     room_choices = {
--         [salasjungle1[math.random(1, 24)]] = 1,
--         ["MAINDoyDoyM"] = 1,
--         [salasjungle1[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "MAINJungle",
--     colour = { 1, .5, .5, .2 },
-- })

-- AddTask("XISTO51", {
--     locks = { LOCKS.TIER1 },
--     keys_given = { KEYS.ROCKS, KEYS.GOLD, KEYS.TIER2 },
--     room_choices = {
--         [salasjungle1[math.random(1, 24)]] = 1,
--         ["MAINDoyDoyF"] = 1,
--         [salasjungle1[math.random(1, 24)]] = 1,
--     },
--     room_bg = GROUND.JUNGLE,
--     background_room = "MAINJungle",
--     colour = { 1, .5, .5, .2 },
-- })

-- --if GetModConfigData("Shipwrecked") == 25 or GetModConfigData("kindofworld") == 10 then  island or sw world
AddTask("A_MISTO39", {
    locks = {},
    keys_given = { KEYS.MUSHROOM, KEYS.RABBIT, KEYS.AREA, KEYS.CAVERN, KEYS.SINKHOLE, KEYS.PASSAGE },
    region_id = "island2",
    room_choices = {
        ["BeachPalmCasino"] = 1,
        [salasbeach[math.random(1, 24)]] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.BEACH,
    background_room = salasbeach[math.random(1, 24)],
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK1", {
    locks = { LOCKS.MUSHROOM },
    keys_given = { KEYS.CAVE },
    region_id = "island2",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})


AddTask("A_MISTO6", {
    locks = { LOCKS.CAVE },
    keys_given = { KEYS.EASY },
    region_id = "island2",
    room_choices = {
        ["MagmaGold"] = 2,
        ["MagmaGoldBoon"] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.MAGMAFIELD,
    background_room = "Magma",
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK7", {
    locks = { LOCKS.EASY },
    keys_given = { KEYS.EASY },
    region_id = "island2",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})


AddTask("A_MISTO7", {
    locks = { LOCKS.EASY },
    keys_given = { KEYS.EASY },
    region_id = "island2",
    room_choices = {
        ["PigVillagesw"] = 1,
        ["JungleDenseBerries"] = 1,
        ["BeachShark"] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.JUNGLE,
    background_room = "JungleDenseMed",
    colour = { 1, .5, .5, .2 },
})

AddTask("A_MISTO8", {
    locks = { LOCKS.EASY },
    keys_given = { KEYS.EASY },
    region_id = "island2",
    room_choices = {
        ["MagmaTallBird"] = 1,
        ["MagmaGoldBoon"] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.MAGMAFIELD,
    background_room = "BeachDunes",
    colour = { 1, .5, .5, .2 },
})


AddTask("A_BLANK2", {
    locks = { LOCKS.RABBIT },
    keys_given = { KEYS.INNERTIER },
    region_id = "island2",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("A_MISTO9", {
    locks = { LOCKS.INNERTIER },
    keys_given = { KEYS.MEDIUM },
    region_id = "island2",
    room_choices = {
        [salasjungle[math.random(1, 24)]] = 1,
        ["JungleRockSkull"] = 1,
        [salasjungle[math.random(1, 24)]] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.JUNGLE,
    background_room = salasjungle[math.random(1, 24)],
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK8", {
    locks = { LOCKS.MEDIUM },
    keys_given = { KEYS.MEDIUM },
    region_id = "island2",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("A_MISTO11", {
    locks = { LOCKS.MEDIUM },
    keys_given = { KEYS.MEDIUM },
    region_id = "island2",
    room_choices = {
        ["MagmaForest"] = 1, -- MR went from 1-3
        ["JungleDense"] = 1,
        ["JunglePigs"] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.JUNGLE,
    background_room = "JungleDense",
    colour = { 1, .5, .5, .2 },
})


AddTask("A_MISTO14", {
    locks = { LOCKS.MEDIUM },
    keys_given = { KEYS.MEDIUM },
    region_id = "island2",
    room_choices = {
        [salasvolcano[math.random(1, 5)]] = 1,
        ["VolcanoAsh"] = 1,
        ["Volcano"] = 1,
        ["VolcanoObsidian"] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.VOLCANO,
    background_room = "VolcanoNoise",
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK3", {
    locks = { LOCKS.AREA },
    keys_given = { KEYS.OUTERTIER },
    region_id = "island2",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("A_MISTO15", {
    locks = { LOCKS.OUTERTIER },
    keys_given = { KEYS.HARD },
    region_id = "island2",
    room_choices = {
        ["TidalMermMarsh"] = 1,
        [salasbeach[math.random(1, 24)]] = 1,
        ["BeachSappy"] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.JUNGLE,
    background_room = "BeachSand",
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK9", {
    locks = { LOCKS.HARD },
    keys_given = { KEYS.HARD },
    region_id = "island2",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("A_MISTO16", {
    locks = { LOCKS.HARD },
    keys_given = { KEYS.HARD },
    region_id = "island2",
    room_choices = {
        [salasjungle[math.random(1, 24)]] = 1,
        [salasbeach[math.random(1, 24)]] = 1,

    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.JUNGLE,
    background_room = "BeachUnkept",
    colour = { 1, .5, .5, .2 },
})

AddTask("A_MISTO17", {
    locks = { LOCKS.HARD },
    keys_given = { KEYS.HARD },
    region_id = "island2",
    room_choices = {
        ["JungleDenseMed"] = 1,
        [salasbeach[math.random(1, 24)]] = 1,
        [salasbeach[math.random(1, 24)]] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.JUNGLE,
    background_room = "BeachSand",
    "BeachUnkept",
    colour = { 1, .5, .5, .2 },
})


AddTask("A_BLANK4", {
    locks = { LOCKS.CAVERN },
    keys_given = { KEYS.LIGHT },
    region_id = "island2",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("A_MISTO20", {
    locks = { LOCKS.LIGHT },
    keys_given = { KEYS.BLUE },
    region_id = "island2",
    room_choices = {
        [salasjungle[math.random(1, 33)]] = 1,
        --        [salasjungle[math.random(1, 33)]] = 1,
        ["JungleMonkeyHell"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.JUNGLE,
    background_room = "TidalMarsh",
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK10", {
    locks = { LOCKS.BLUE },
    keys_given = { KEYS.BLUE },
    region_id = "island2",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("A_MISTO26", {
    locks = { LOCKS.BLUE },
    keys_given = { KEYS.BLUE },
    region_id = "island2",
    room_choices = {
        [salasbeach[math.random(1, 24)]] = 1,
        [salasbeach[math.random(1, 24)]] = 1,
        [salastidal[math.random(1, 4)]] = 1,
        [salasbeach[math.random(1, 24)]] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.BEACH,
    background_room = "BeachUnkept",
    colour = { 1, .5, .5, .2 },
})

AddTask("A_MISTO27", {
    locks = { LOCKS.BLUE },
    keys_given = { KEYS.BLUE },
    region_id = "island2",
    room_choices = {
        ["Magma"] = 1, -- MR went from 1-3
        ["MagmaGold"] = 1,
        ["MagmaGoldmoon"] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.BEACH,
    background_room = "MagmaGold",
    "MagmaHomeBoon",
    colour = { 1, .5, .5, .2 },
})



AddTask("A_BLANK5", {
    locks = { LOCKS.SINKHOLE },
    keys_given = { KEYS.FUNGUS },
    region_id = "island2",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("A_MISTO28", {
    locks = { LOCKS.FUNGUS },
    keys_given = { KEYS.RED },
    region_id = "island2",
    room_choices = {
        -- ["JungleNoBerry"] = 1,
        ["TidalSharkHome"] = 1,
        ["JungleNoBerry"] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.JUNGLE,
    background_room = "JungleRockyDrop",
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK11", {
    locks = { LOCKS.RED },
    keys_given = { KEYS.RED },
    region_id = "island2",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})


AddTask("A_MISTO38", {
    locks = { LOCKS.RED },
    keys_given = { KEYS.RED },
    region_id = "island2",
    room_choices = {
        ["Beaverkinghome"] = 1,
        ["Beaverkingcity"] = 1,
        [salasmeadow[math.random(1, 9)]] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.MEADOW,
    background_room = "MeadowFlowery",
    colour = { 1, .5, .5, .2 },
})



AddTask("A_MISTO43", {
    locks = { LOCKS.RED },
    keys_given = { KEYS.RED },
    region_id = "island2",
    room_choices = {
        [salasbeach[math.random(1, 24)]] = 1,
        --        [salasbeach[math.random(1, 24)]] = 1,		 --CM was 5 +
        ["BeachShark"] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.BEACH,
    background_room = "BeachSand",
    colour = { 1, .5, .5, .2 },
})


AddTask("A_BLANK6", {
    locks = { LOCKS.PASSAGE },
    keys_given = { KEYS.LABYRINTH },
    region_id = "island2",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})


AddTask("A_MISTO45", {
    locks = { LOCKS.LABYRINTH },
    keys_given = { KEYS.GREEN },
    region_id = "island2",
    room_choices = {
        ["BeachSand"] = 1,
        ["BeachPiggy"] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.JUNGLE,
    background_room = "JungleDenseMed",
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK12", {
    locks = { LOCKS.GREEN },
    keys_given = { KEYS.GREEN },
    region_id = "island2",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("A_MISTO50", {
    locks = { LOCKS.GREEN },
    keys_given = { KEYS.GREEN },
    region_id = "island2",
    room_choices = {
        [salasjungle[math.random(1, 24)]] = 1,
        ["DoyDoyM"] = 1,
        [salasjungle[math.random(1, 24)]] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.JUNGLE,
    background_room = "Jungle",
    colour = { 1, .5, .5, .2 },
})

AddTask("A_MISTO51", {
    locks = { LOCKS.GREEN },
    keys_given = { KEYS.GREEN },
    region_id = "island2",
    room_choices = {
        [salasjungle[math.random(1, 24)]] = 1,
        ["DoyDoyF"] = 1,
        [salasjungle[math.random(1, 24)]] = 1,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.JUNGLE,
    background_room = "Jungle",
    colour = { 1, .5, .5, .2 },
})

-- ---------------------------------------------------------------------------TASK ORIGINAL VOLCANO--------------------------------------------------------------
-- AddTask("TIDALMARSH_TASK_FOREST",
--     {
--         locks = { LOCKS.GREEN },
--         keys_given = { KEYS.GREEN },
--         room_choices =
--         {
--             ["TidalMarsh"] = 1,
--             ["TidalSharkHome"] = 1,
--             ["TidalMermMarsh"] = 1,
--         },
--         --	entrance_room = "TidalMarsh",
--         room_bg = GROUND.TIDALMARSH,
--         background_room = "TidalMarsh",
--         colour = { r = 1, g = 0, b = 0.6, a = 1 },
--     })

-- -----------------------------------------------------------

-- AddTask("VOLCANO_TASK_FOREST",
--     {
--         locks = { LOCKS.BATS },
--         keys_given = { KEYS.BATS },
--         room_choices =
--         {
--             ["VolcanoRock"] = 1,
--             ["VolcanoStart"] = 1,
--             ["VolcanoAsh"] = 1,
--             ["VolcanoNoise"] = 1,
--         },
--         --	entrance_room = "Magmadragoon",
--         room_bg = GROUND.VOLCANO,
--         background_room = "VolcanoNoise",
--         colour = { r = 1, g = 0, b = 0.6, a = 1 },
--     })

-- -----------------------------------------------------------


-- AddTask("BEACH_TASK_FOREST",
--     {
--         locks = { LOCKS.PASSAGE },
--         keys_given = { KEYS.PASSAGE },
--         room_choices =
--         {
--             ["BeachShells"] = 1,
--             ["BeachPiggy"] = 1,
--             ["BeachPalmForest"] = 2,
--             ["DoydoyBeach"] = 1,
--             ["JungleDenseMed"] = 1,
--             ["BeachPalmCasino"] = 1,
--             ["DoyDoyM"] = 1,
--         },

--         --	entrance_room = "BeachSandHome",
--         room_bg = GROUND.BEACH,
--         background_room = "BeachSandHome",
--         colour = { r = 1, g = 0, b = 0.6, a = 1 },
--     })

-- --------------------------------------------------
-- AddTask("JUNGLE_TASK_FOREST",
--     {
--         locks = { LOCKS.TREES, LOCKS.TIER2 },
--         keys_given = { KEYS.PIGS, KEYS.WOOD, KEYS.MEAT, KEYS.TIER2 },
--         room_choices =
--         {
--             ["JungleDense"] = 1,
--             ["JungleDenseHome"] = 1,
--             ["TidalMarsh1"] = 1,
--             ["JungleDenseCritterCrunch"] = 1,
--             ["JunglePigs"] = 1,
--             ["DoydoyBeach1"] = 1,
--             ["DoyDoyF"] = 1,
--             ["PigVillagesw"] = 1,
--         },
--         room_bg = GROUND.JUNGLE,
--         background_room = "Jungle",
--         colour = { r = 1, g = 0, b = 0.6, a = 1 },
--     })
-- --------------------------------------------------------
-- AddTask("MEADOW_TASK_FOREST",
--     {
--         locks = { LOCKS.BASIC_COMBAT, LOCKS.TIER2 },
--         keys_given = { KEYS.POOP, KEYS.WOOL, KEYS.WOOD, KEYS.GRASS, KEYS.TIER2 },
--         room_choices =
--         {
--             ["Beaverkinghome"] = 2,
--             ["Beaverkingcity"] = 1,
--         },
--         room_bg = GROUND.MEADOW,
--         background_room = "Beaverkingcity",
--         colour = { r = 1, g = 0, b = 0.6, a = 1 },
--     })
-- ----------------------------------------------
-- AddTask("MAGMAFIELD_TASK_FOREST",
--     {
--         locks = { LOCKS.TIER3, LOCKS.ADVANCED_COMBAT },
--         keys_given = { KEYS.TIER4 },
--         room_choices =
--         {
--             ["Magma"] = 1,
--             ["MagmaVolcano"] = 1,
--             ["MagmaGold"] = 2,
--             ["MagmaGoldmoon"] = 1,
--             ["MagmaGoldBoon"] = 2,
--         },
--         --	entrance_room = "Magmadragoon",
--         room_bg = GROUND.MAGMAFIELD,
--         background_room = "MagmaForest",
--         colour = { r = 1, g = 0, b = 0.6, a = 1 },
--     })

-- -- AddTask("separavulcao", {
-- --     locks = {
-- --         LOCKS.NONE,
-- --     },
-- --     keys_given = KEYS.LAND_DIVIDE_1,
-- --     room_choices = {
-- --         ["ForceDisconnectedRoom"] = 10,
-- --     },
-- --     entrance_room = "ForceDisconnectedRoom",
-- --     room_bg = GROUND.VOLCANO,
-- --     background_room = "ForceDisconnectedRoom",
-- --     colour = { r = 1, g = 1, b = 1, a = 0.3 }
-- -- })

-- AddTask("separavulcao", {
--     locks = {
--         LOCKS.RUINS,
--     },
--     keys_given = KEYS.LAND_DIVIDE_1,
--     room_choices = {
--         ["ForceDisconnectedRoom"] = 10,
--     },
--     entrance_room = "ForceDisconnectedRoom",
--     room_bg = GROUND.VOLCANO,
--     background_room = "ForceDisconnectedRoom",
--     colour = { r = 1, g = 1, b = 1, a = 0.3 }
-- })

-- ----------------------------volcano ------------------------------
-- AddTask("vulcaonacaverna", {
--     locks = { LOCKS.LAND_DIVIDE_1 },
--     keys_given = { KEYS.ISLAND_1 },
--     crosslink_factor = 0,
--     make_loop = true,
--     room_choices = {
--         ["VolcanoAsh"] = 5,
--         ["VolcanoNoise"] = 6,
--         ["VolcanoStart"] = 1,
--         ["VolcanoObsidian"] = 4,
--         ["VolcanoRock"] = 4,

--     },
--     entrance_room = "ForceDisconnectedRoom",
--     background_room = "VolcanoNoise",
--     room_bg = GROUND.VOLCANO,
--     colour = { r = 0.6, g = 0.4, b = 0.0, a = 0.9 },
-- })


-- AddTask("vulcaonacaverna1", {
--     locks = { LOCKS.ISLAND_1 },
--     keys_given = { KEYS.ISLAND_1 },
--     crosslink_factor = 0,
--     make_loop = true,
--     room_choices = {

--         ["VolcanoAltar"] = 1,

--     },
--     entrance_room = "VolcanoRock",
--     background_room = "VolcanoRock",
--     room_bg = GROUND.VOLCANO,
--     colour = { r = 0.6, g = 0.4, b = 0.0, a = 0.9 },
-- })


-- AddTask("vulcaonacaverna2", {
--     locks = { LOCKS.ISLAND_1 },
--     keys_given = { KEYS.ISLAND_1 },
--     crosslink_factor = 0,
--     make_loop = true,
--     room_choices = {

--         ["VolcanoObsidianBench"] = 1,
--     },
--     entrance_room = "VolcanoObsidian",
--     background_room = "VolcanoObsidian",
--     room_bg = GROUND.VOLCANO,
--     colour = { r = 0.6, g = 0.4, b = 0.0, a = 0.9 },
-- })


-- AddTask("vulcaonacaverna3", {
--     locks = { LOCKS.ISLAND_1 },
--     keys_given = { KEYS.LAND_DIVIDE_2 },
--     crosslink_factor = 0,
--     make_loop = true,
--     room_choices = {

--         ["VolcanoCage"] = 1,

--     },
--     entrance_room = "VolcanoAsh",
--     background_room = "VolcanoAsh",
--     room_bg = GROUND.VOLCANO,
--     colour = { r = 0.6, g = 0.4, b = 0.0, a = 0.9 },
-- })

-- AddTask("vulcaonacaverna4", {
--     locks = { LOCKS.LAND_DIVIDE_2 },
--     keys_given = { KEYS.LAND_DIVIDE_3 },
--     crosslink_factor = 0,
--     make_loop = true,
--     room_choices = {

--         ["VolcanoLavaarena"] = 1,

--     },
--     entrance_room = "ForceDisconnectedRoom",
--     background_room = "ForceDisconnectedRoom",
--     room_bg = GROUND.IMPASSABLE,
--     colour = { r = 0.6, g = 0.4, b = 0.0, a = 0.9 },
-- })


-- ------------------------------------------------------------------------------------------
-- -- Reef rooms
-- ------------------------------------------------------------------------------------------	

-- AddRoom("CoralReef", {
--     colour = { r = 0, g = 0, b = 0, a = 0 },
--     value = GROUND.UNDERWATER_SANDY,
--     tags = { "RoadPoison" },
--     contents = {
--         countprefabs = {
--             geothermal_vent = function() return (math.random(2) - 1) end,
--         },

--         distributepercent = 0.6,
--         distributeprefabs = {
--             sandstone_boulder = 0.01,
--             uw_coral = 1.5,
--             uw_coral_blue = 1.5,
--             uw_coral_green = 1,
--             reef_jellyfish = 0.4,
--             --			seatentacle = 0.5,
--             bubble_vent = 0.03,
--             squidunderwater = 0.001,
--             decorative_shell = 0.2,
--             sea_eel = 0.2,
--             sponge = 0.15,
--             rainbowjellyfish_underwater = 0.01,
--             commonfish = 0.1,
--             reeflight_small = 0.2,
--             reeflight_tiny = 0.2,
--         },
--     },
-- })

-- AddRoom("CoralReefJunked", {
--     colour = { r = 0, g = 0, b = 0, a = 0 },
--     value = GROUND.UNDERWATER_SANDY,
--     tags = { "RoadPoison" },
--     contents = {
--         countprefabs = {
--             geothermal_vent = function() return (math.random(2) - 1) end,
--             sunkenchest_spawner = function() return (math.random(2) - 1) end,
--         },

--         distributepercent = 0.3,
--         distributeprefabs = {
--             sandstone_boulder = 0.01,
--             uw_coral = 1.3,
--             uw_coral_blue = 1.3,
--             uw_coral_green = 1.3,
--             reef_jellyfish = 0.4,
--             --			seatentacle = 0.5,
--             bubble_vent = 0.03,
--             squidunderwater = 0.01,
--             cut_orange_coral = 1,
--             decorative_shell = 0.05,
--             sea_eel = 0.2,
--             sponge = 0.15,
--             commonfish = 0.2,
--             reeflight_small = 0.2,
--             reeflight_tiny = 0.2,
--         },
--     },
-- })

-- AddRoom("CoralReefLight", {
--     colour = { r = 0, g = 0, b = 0, a = 0 },
--     value = GROUND.UNDERWATER_SANDY,
--     tags = { "RoadPoison" },
--     contents = {
--         countprefabs = {
--             geothermal_vent = function() return (math.random(2) - 1) end,
--             gnarwailunderwater = 1,
--         },

--         distributepercent = 0.3,
--         distributeprefabs = {
--             sandstone_boulder = 0.05,
--             uw_coral = 1,
--             uw_coral_blue = 1,
--             uw_coral_green = 1,
--             iron_boulder = 0.5,
--             bubble_vent = 0.03,
--             rotting_trunk = 0.1,
--             reef_jellyfish = 0.4,
--             squidunderwater = 0.01,
--             decorative_shell = 0.1,
--             wormplant = 0.1,
--             sponge = 0.15,
--             commonfish = 0.2,
--             rainbowjellyfish_underwater = 0.01,
--             reeflight_small = 0.2,
--             reeflight_tiny = 0.2,
--         },
--     },
-- })

-- ------------------------------------------------------------------------------------------
-- -- Kelp rooms
-- ------------------------------------------------------------------------------------------

-- AddRoom("KelpForest", {
--     colour = { r = 0, g = 0, b = 0, a = 0 },
--     value = GROUND.UNDERWATER_SANDY,
--     tags = { "RoadPoison" },
--     contents = {
--         distributepercent = 0.6,
--         distributeprefabs = {
--             kelpunderwater = 2.5,
--             rotting_trunk = 0.01,
--             seagrass = 0.005,
--             sandstone_boulder = 0.0008,
--             squidunderwater = 0.001,
--             flower_sea = 0.1,
--             sea_eel = 0.001,
--             bubble_vent = 0.03,
--             commonfish = 0.2,
--             reeflight_small = 0.2,
--             reeflight_tiny = 0.2,
--         },
--     },
-- })

-- AddRoom("KelpForestLight", {
--     colour = { r = 0, g = 0, b = 0, a = 0 },
--     value = GROUND.UNDERWATER_SANDY,
--     tags = { "RoadPoison" },
--     contents = {
--         countprefabs = {
--             geothermal_vent = function() return (math.random(2) - 1) end,
--             sunkenchest_spawner = function() return (math.random(2) - 1) end,
--         },
--         distributepercent = 0.6,
--         distributeprefabs = {
--             kelpunderwater = 0.5,
--             rotting_trunk = 0.05,
--             seagrass = 0.005,
--             sandstone_boulder = 0.0008,
--             --			mermworkerhouse = 0.02,
--             squidunderwater = 0.0001,
--             --			seatentacle = 0.0001,
--             flower_sea = 0.1,
--             sea_eel = 0.002,
--             bubble_vent = 0.03,
--             commonfish = 0.05,
--             reeflight_small = 0.2,
--             reeflight_tiny = 0.2,
--         },
--     },
-- })

-- AddRoom("KelpForestInfested", {
--     colour = { r = 0, g = 0, b = 0, a = 0 },
--     value = GROUND.UNDERWATER_SANDY,
--     tags = { "RoadPoison" },
--     contents = {
--         distributepercent = 0.6,
--         distributeprefabs = {
--             kelpunderwater = 2.5,
--             rotting_trunk = 0.01,
--             seagrass = 0.005,
--             sandstone_boulder = 0.008,
--             reef_jellyfish = 0.2,
--             squidunderwater = 0.005,
--             flower_sea = 0.1,
--             sea_eel = 0.001,
--             rainbowjellyfish_underwater = 0.01,
--             bubble_vent = 0.03,
--             commonfish = 0.15,
--             reeflight_small = 0.2,
--             reeflight_tiny = 0.2,
--         },
--     },
-- })


-- ------------------------------------------------------------------------------------------
-- -- Rocky rooms
-- ------------------------------------------------------------------------------------------	

-- AddRoom("RockyBottom", {
--     colour = { r = 0, g = 0, b = 0, a = 0 },
--     value = GROUND.UNDERWATER_ROCKY,
--     tags = { "RoadPoison" },
--     contents = {
--         countprefabs = {
--             geothermal_vent = function() return (math.random(2)) end,
--         },

--         distributepercent = 0.225,
--         distributeprefabs = {
--             rock1 = 0.1,
--             rock2 = 0.05,
--             iron_boulder = 0.4,
--             squidunderwater = 0.002,
--             lava_stone = 0.005,
--             sponge = 0.001,
--             bubble_vent = 0.01,
--             commonfish = 0.1,
--             shrimp = 0.1,
--             reeflight_small = 0.2,
--             reeflight_tiny = 0.2,
--         },
--     },
-- })

-- AddRoom("RockyBottomBroken", {
--     colour = { r = 0, g = 0, b = 0, a = 0 },
--     value = GROUND.UNDERWATER_ROCKY,
--     tags = { "RoadPoison" },
--     contents = {
--         countprefabs = {
--             geothermal_vent = function() return (math.random(2)) end,
--         },

--         distributepercent = 0.15,
--         distributeprefabs = {
--             rocks = 0.1,
--             rock1 = 0.1,
--             rock2 = 0.05,
--             iron_ore = 0.03,
--             iron_boulder = 0.4,
--             squidunderwater = 0.002,
--             lava_stone = 0.005,
--             sponge = 0.001,
--             bubble_vent = 0.01,
--             commonfish = 0.1,
--             shrimp = 0.1,
--             reeflight_small = 0.2,
--             reeflight_tiny = 0.2,
--         },
--     },
-- })

-- ------------------------------------------------------------------------------------------
-- -- Lunnar rooms
-- ------------------------------------------------------------------------------------------	

-- AddRoom("LunnarBottom", {
--     colour = { r = 0, g = 0, b = 0, a = 0 },
--     value = GROUND.PEBBLEBEACH,
--     tags = { "RoadPoison" },
--     contents = {
--         countprefabs = {
--             geothermal_vent = function() return (math.random(2)) end,
--         },

--         distributepercent = 0.3,
--         distributeprefabs = {
--             squidunderwater = 0.002,
--             lava_stone = 0.005,
--             sponge = 0.001,
--             bubble_vent = 0.01,
--             shrimp = 0.1,
--             reeflight_small = 0.2,
--             reeflight_tiny = 0.2,
--             oceanfishableflotsam = 0.1,
--             trap_starfish = 0.5,
--             dead_sea_bones = 0.5,
--             pond_algae = 0.5,
--             seaweedunderwater = 2,
--         },
--     },
-- })

-- AddRoom("LunnarBottomBroken", {
--     colour = { r = 0, g = 0, b = 0, a = 0 },
--     value = GROUND.PEBBLEBEACH,
--     tags = { "RoadPoison" },
--     contents = {
--         countprefabs = {
--             geothermal_vent = 1,
--             gnarwailunderwater = 1,
--             sunkenchest_spawner = function() return (math.random(2) - 1) end,
--         },

--         distributepercent = 0.3,
--         distributeprefabs = {
--             squidunderwater = 0.002,
--             lava_stone = 0.005,
--             sponge = 0.001,
--             bubble_vent = 0.01,
--             shrimp = 0.1,
--             reeflight_small = 0.2,
--             reeflight_tiny = 0.2,
--             singingshell_octave3 = 0.1,
--             singingshell_octave4 = 0.1,
--             singingshell_octave5 = 0.1,
--             shell_cluster = 0.01,
--             oceanfishableflotsam = 0.1,
--             trap_starfish = 0.5,
--             dead_sea_bones = 0.5,
--             pond_algae = 0.5,
--             seaweedunderwater = 0.1,
--         },
--     },
-- })

-- AddRoom("Lunnarrocks", {
--     colour = { r = 0, g = 0, b = 0, a = 0 },
--     value = GROUND.PEBBLEBEACH,
--     tags = { "RoadPoison" },
--     contents = {
--         countprefabs = {
--             geothermal_vent = function() return (math.random(2)) end,
--         },

--         distributepercent = 0.3,
--         distributeprefabs = {
--             iron_boulder = 0.4,
--             squidunderwater = 0.002,
--             lava_stone = 0.005,
--             sponge = 0.001,
--             bubble_vent = 0.01,
--             shrimp = 0.1,
--             reeflight_small = 0.2,
--             reeflight_tiny = 0.2,
--             shell_cluster = 0.01,
--             oceanfishableflotsam = 0.1,
--             trap_starfish = 0.5,
--             dead_sea_bones = 0.5,
--             pond_algae = 0.5,
--             saltstack = 1,
--             seastack = 1,
--         },
--     },
-- })

-- AddRoom("Lunnarrocksgnar", {
--     colour = { r = 0, g = 0, b = 0, a = 0 },
--     value = GROUND.PEBBLEBEACH,
--     tags = { "RoadPoison" },
--     contents = {
--         countprefabs = {
--             geothermal_vent = 1,
--             gnarwailunderwater = 1,
--         },

--         distributepercent = 0.3,
--         distributeprefabs = {
--             iron_boulder = 0.4,
--             squidunderwater = 0.002,
--             lava_stone = 0.005,
--             sponge = 0.001,
--             bubble_vent = 0.01,
--             shrimp = 0.1,
--             reeflight_small = 0.2,
--             reeflight_tiny = 0.2,
--             shell_cluster = 0.01,
--             oceanfishableflotsam = 0.1,
--             trap_starfish = 0.5,
--             dead_sea_bones = 0.5,
--             pond_algae = 0.5,
--             saltstack = 1,
--             seastack = 1,
--         },
--     },
-- })

-- AddRoom("bg_LunnarBottom", {
--     colour = { r = 0, g = 0, b = 0, a = 0 },
--     value = GROUND.PEBBLEBEACH,
--     tags = { "RoadPoison" },
--     contents = {
--         distributepercent = 0.20,
--         distributeprefabs = {
--             squidunderwater = 0.002,
--             lava_stone = 0.005,
--             sponge = 0.001,
--             bubble_vent = 0.01,
--             shrimp = 0.1,
--             reeflight_small = 0.2,
--             reeflight_tiny = 0.2,
--             shell_cluster = 0.01,
--             oceanfishableflotsam = 0.1,
--             trap_starfish = 0.5,
--             dead_sea_bones = 0.4,
--             pond_algae = 0.5,
--             seaweedunderwater = 0.2,
--             seastack = 0.3,
--             uw_coral = 0.2,
--             uw_coral_blue = 0.2,
--             uw_coral_green = 0.2,
--         },
--     },
-- })
-- ------------------------------------------------------------------------------------------
