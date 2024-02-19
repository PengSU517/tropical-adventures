AddRoom("OceanCoastal_lily", {
    colour = { r = .5, g = 0.6, b = .080, a = .10 },
    value = GROUND.OCEAN_COASTAL,
    contents = {
        countprefabs = { mermboat = 4, },
        distributepercent = 0.01,
        distributeprefabs =
        {
            driftwood_log = 1,
            bullkelp_plant = 2,
            messagebottle = 0.1,
            messagebottle1 = 0.1,
        },

        countstaticlayouts =
        {
            ["BullkelpFarmSmall"] = 6,
            ["BullkelpFarmMedium"] = 3,
            ["lilypadnovo"] = 2,
            ["lilypadnovograss"] = 1,
        },
    }
})
