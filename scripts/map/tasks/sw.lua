AddTask("HomeIsland_start", {
    locks = { LOCKS.HARD },
    keys_given = { KEYS.HARD },
    region_id = "shipwrecked",
    room_choices = {
        ["JungleDenseMedHome"] = 2,
        ["BeachUnkept"] = 1,
        ["Shipwrecked start"] = 1,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "BeachSandHome",
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("HomeIsland", {
    locks = { LOCKS.HARD },
    keys_given = { KEYS.HARD },
    region_id = "shipwrecked",
    room_choices = {
        ["JungleDenseMedHome"] = 4,
        ["BeachUnkept"] = 2,
    },
    room_bg = GROUND.JUNGLE,
    background_room = "BeachSandHome",
    colour = { r = 1, g = 1, b = 0, a = 1 }
})

AddTask("Casino", {
    locks = {},
    keys_given = { KEYS.MUSHROOM, KEYS.RABBIT, KEYS.AREA, KEYS.CAVERN, KEYS.SINKHOLE, KEYS.PASSAGE },
    region_id = "shipwrecked",
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
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})


AddTask("RockyGold", {
    locks = { LOCKS.CAVE },
    keys_given = { KEYS.EASY },
    region_id = "shipwrecked",
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
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})


AddTask("BoreKing", {
    locks = { LOCKS.EASY },
    keys_given = { KEYS.EASY },
    region_id = "shipwrecked",
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

AddTask("RockyTallJungle", {
    locks = { LOCKS.EASY },
    keys_given = { KEYS.EASY },
    region_id = "shipwrecked",
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
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("BeachSkull", {
    locks = { LOCKS.INNERTIER },
    keys_given = { KEYS.MEDIUM },
    region_id = "shipwrecked",
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
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("MagmaJungle", {
    locks = { LOCKS.MEDIUM },
    keys_given = { KEYS.MEDIUM },
    region_id = "shipwrecked",
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


AddTask("Volcano ground", {
    locks = { LOCKS.MEDIUM },
    keys_given = { KEYS.MEDIUM },
    region_id = "shipwrecked",
    room_choices = {
        [salasvolcano[math.random(1, 5)]] = 1,
        [salasvolcano[math.random(1, 5)]] = 1,
        [salasvolcano[math.random(1, 5)]] = 1,
        ["VolcanoAsh"] = 1,
        ["Volcano"] = 1, ---------火山入口room
        ["VolcanoObsidian"] = 1,
        ["VolcanoNoise"] = 2,

    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.VOLCANO,
    background_room = "VolcanoNoise",
    crosslink_factor = 5,
    colour = { 1, .5, .5, .2 },
})

AddTask("Volcano entrance", {
    locks = { LOCKS.VOLCANO_ENTRANCE },
    keys_given = { KEYS.VOLCANO },
    -- region_id = "volcano",
    room_choices = {
        [salasvolcano[math.random(1, 5)]] = 1,
        [salasvolcano[math.random(1, 5)]] = 1,
        [salasvolcano[math.random(1, 5)]] = 1,
        ["VolcanoNoise"] = 2,

    },
    entrance_room = "VolcanoAsh",
    room_bg = GROUND.VOLCANO,
    background_room = "VolcanoNoise",
    crosslink_factor = 0,
    colour = { 1, .5, .5, .2 },
})

AddTask("Volcano", {
    locks = { LOCKS.VOLCANO },
    keys_given = { KEYS.VOLCANO_INNER },
    -- region_id = "volcano",
    room_choices = {
        ["VolcanoAsh"] = 1,
        ["VolcanoNoise"] = 2,
        ["VolcanoObsidian"] = 3,
        ["VolcanoRock"] = 2,
        ["VolcanoStart"] = 1, ------火山出口room
        ["VolcanoAltar"] = 1,
        ["VolcanoObsidianBench"] = 1,
    },
    entrance_room = "VolcanoAsh",
    room_bg = GROUND.VOLCANO,
    background_room = "VolcanoNoise",
    crosslink_factor = 5,
    colour = { 1, .5, .5, .2 },
})

AddTask("Volcano inner", {
    locks = { LOCKS.VOLCANO_INNER },
    room_choices = {
        [salasvolcano[math.random(1, 5)]] = 1,
        [salasvolcano[math.random(1, 5)]] = 1,
        [salasvolcano[math.random(1, 5)]] = 1,
        ["VolcanoRock"] = 2,
        ["VolcanoCage"] = 1,
    },
    entrance_room = "VolcanoAsh",
    room_bg = GROUND.VOLCANO,
    background_room = "VolcanoNoise",
    crosslink_factor = 5,
    colour = { 1, .5, .5, .2 },
})

AddTask("A_BLANK3", {
    locks = { LOCKS.AREA },
    keys_given = { KEYS.OUTERTIER },
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("JungleMarshy", {
    locks = { LOCKS.OUTERTIER },
    keys_given = { KEYS.HARD },
    region_id = "shipwrecked",
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
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("JungleBushy", {
    locks = { LOCKS.HARD },
    keys_given = { KEYS.HARD },
    region_id = "shipwrecked",
    room_choices = {
        [salasjungle[math.random(1, 24)]] = 1,
        [salasbeach[math.random(1, 24)]] = 1,

    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.JUNGLE,
    background_room = "BeachUnkept",
    colour = { 1, .5, .5, .2 },
})

AddTask("JungleBeachy", {
    locks = { LOCKS.HARD },
    keys_given = { KEYS.HARD },
    region_id = "shipwrecked",
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
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("JungleMonkey", {
    locks = { LOCKS.LIGHT },
    keys_given = { KEYS.BLUE },
    region_id = "shipwrecked",
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
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("BeachMarshy", {
    locks = { LOCKS.BLUE },
    keys_given = { KEYS.BLUE },
    region_id = "shipwrecked",
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

AddTask("MoonRocky", {
    locks = { LOCKS.BLUE },
    keys_given = { KEYS.BLUE },
    region_id = "shipwrecked",
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
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("TigerSharky", {
    locks = { LOCKS.FUNGUS },
    keys_given = { KEYS.RED },
    region_id = "shipwrecked",
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
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})


AddTask("Verdent", {
    locks = { LOCKS.RED },
    keys_given = { KEYS.RED },
    region_id = "shipwrecked",
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



AddTask("BeachBeachy", {
    locks = { LOCKS.RED },
    keys_given = { KEYS.RED },
    region_id = "shipwrecked",
    room_choices = {
        [salasbeach[math.random(1, 24)]] = 1,
        [salasbeach[math.random(1, 24)]] = 1, --CM was 5 +
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
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 2,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})


AddTask("BeachPiggy", {
    locks = { LOCKS.LABYRINTH },
    keys_given = { KEYS.GREEN },
    region_id = "shipwrecked",
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
    region_id = "shipwrecked",
    room_choices =
    {
        ["ForceDisconnectedRoom"] = 5,
    },
    entrance_room = "ForceDisconnectedRoom",
    room_bg = GROUND.IMPASSABLE,
    background_room = "ForceDisconnectedRoom",
    colour = { r = 0.6, g = 0.6, b = 0.0, a = 1 },
})

AddTask("DoyDoyM", {
    locks = { LOCKS.GREEN },
    keys_given = { KEYS.GREEN },
    region_id = "shipwrecked",
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

AddTask("DoyDoyF", {
    locks = { LOCKS.GREEN },
    keys_given = { KEYS.GREEN },
    region_id = "shipwrecked",
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
