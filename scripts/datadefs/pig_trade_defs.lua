local TRADER = {
    pigman_collector = {
        items = { "stinger", "silk", "mosquitosack", "chitin", "venus_stalk", "venomgland", "spidergland", "lotus_flower1", "bill_quill", "trinket_1", "trinket_2", "trinket_3", "trinket_4", "trinket_5", "trinket_6,trinket_7", "trinket_8", "trinket_9", "trinket_10", "trinket_11", "trinket_12", "trinket_13", "trinket_14", "trinket_15", "trinket_16", "trinket_17", "trinket_18", "trinket_19", "trinket_20", "trinket_21", "trinket_22", "trinket_23", "trinket_24", "trinket_25", "trinket_26", "trinket_27", "trinket_28", "trinket_29", "trinket_30", "trinket_31", "trinket_32", "trinket_33", "trinket_34", "trinket_35", "trinket_36", "trinket_37", "trinket_38", "trinket_39", "trinket_40", "trinket_41", "trinket_42", "trinket_43", "trinket_44", "trinket_45", "trinket_46" },
        delay = 0,
        reset = 0,
        current = 0,
        desc = STRINGS.CITY_PIG_COLLECTOR_TRADE,
        reward = "oinc",
        rewardqty = 3
    },
    pigman_banker = {
        items = { "redgem", "bluegem", "purplegem", "greengem", "orangegem", "yellowgem" },
        delay = 0,
        reset = 0,
        current = 0,
        desc = STRINGS.CITY_PIG_BANKER_TRADE,
        reward = "oinc10",
        rewardqty = 1
    },
    pigman_beautician = {
        items = { "feather_crow", "feather_robin", "feather_robin_winter", "peagawkfeather", "doydoyfeather", "feather_thunder", "feather_canary" },
        delay = 0,
        reset = 1,
        current = 0,
        desc = STRINGS.CITY_PIG_BEAUTICIAN_TRADE,
        reward = "oinc",
        rewardqty = 2
    },
    pig_eskimo = {
        items = { "fish2_alive", "fish3_alive", "fish4_alive", "fish5_alive", "fish6_alive", "fish7_alive", "coi_alive",
            "salmon_alive", "ballphinocean_alive", "swordfishjocean_alive", "swordfishjocean2_alive",
            "dogfishocean_alive", "whaleblueocean_alive", "sharxocean_alive",
            "oceanfish_small_1_inv", "oceanfish_small_2_inv", "oceanfish_small_3_inv", "oceanfish_small_4_inv",
            "oceanfish_small_5_inv", "oceanfish_small_6_inv", "oceanfish_small_7_inv", "oceanfish_small_8_inv",
            "oceanfish_small_9_inv",
            "oceanfish_medium_1_inv", "oceanfish_medium_2_inv", "oceanfish_medium_3_inv", "oceanfish_medium_4_inv",
            "oceanfish_medium_5_inv", "oceanfish_medium_6_inv", "oceanfish_medium_7_inv", "oceanfish_medium_8_inv" },
        delay = 0,
        reset = 1,
        current = 0,
        desc = STRINGS.CITY_PIG_ESKIMO_TRADE,
        reward = "oinc",
        rewardqty = 2
    },
    pigman_mechanic = {
        items = { "boards", "rope", "cutstone", "papyrus" },
        delay = 0,
        reset = 0,
        current = 0,
        desc = STRINGS.CITY_PIG_MECHANIC_TRADE,
        reward = "oinc",
        rewardqty = 2
    },
    pigman_professor = {
        items = { "relic_1", "relic_2", "relic_3" },
        delay = 0,
        reset = 0,
        current = 0,
        desc = STRINGS.CITY_PIG_PROFESSOR_TRADE,
        reward = "oinc10",
        rewardqty = 1
    },
    pigman_hunter = { items = { "houndstooth", "stinger", "hippo_antler" }, delay = 0, reset = 1, current = 0, desc = STRINGS.CITY_PIG_HUNTER_TRADE, reward = "oinc", rewardqty = 5 },
    pigman_mayor = {
        items = { "goldnugget", "goldenbar", "stonebar", "lucky_goldnugget", "dubloon", },
        delay = 0,
        reset = 0,
        current = 0,
        desc = STRINGS.CITY_PIG_MAYOR_TRADE,
        reward = "oinc",
        rewardqty = 5
    },
    pigman_florist = { items = { "petals", "petals_evil", "succulent_picked", "foliage" }, delay = 0, reset = 1, current = 0, desc = STRINGS.CITY_PIG_FLORIST_TRADE, reward = "oinc", rewardqty = 1 },
    pigman_storeowner = { items = { "clippings" }, delay = 0, reset = 0, current = 0, desc = STRINGS.CITY_PIG_STOREOWNER_TRADE, reward = "oinc", rewardqty = 1 },
    pigman_farmer = { items = { "cutgrass", "twigs" }, delay = 0, reset = 1, current = 0, desc = STRINGS.CITY_PIG_FARMER_TRADE, reward = "oinc", rewardqty = 1 },
    pigman_miner = { items = { "rocks" }, delay = 0, reset = 1, current = 0, desc = STRINGS.CITY_PIG_MINER_TRADE, reward = "oinc", rewardqty = 1 },
    pigman_erudite = { items = { "nightmarefuel" }, delay = 0, reset = 1, current = 0, desc = STRINGS.CITY_PIG_ERUDITE_TRADE, reward = "oinc", rewardqty = 5 },
    pigman_hatmaker = { items = { "silk" }, delay = 0, reset = 1, current = 0, desc = STRINGS.CITY_PIG_HATMAKER_TRADE, reward = "oinc", rewardqty = 5 },
    pigman_queen = {
        items = { "pigcrownhat", "pig_scepter", "relic_4", "relic_5", "opalpreciousgem", },
        delay = 0,
        reset = 0,
        current = 0,
        desc = STRINGS.CITY_PIG_QUEEN_TRADE,
        reward = "pedestal_key", --  "pedestal_key",
        rewardqty = 1
    },
    pigman_usher = {
        items = { "honey", "jammypreserves", "icecream", "pumpkincookie", "waffles", "berries", "berries_cooked", "berries_juicy", "berries_juicy_cooked" },
        delay = 0,
        reset = 1,
        current = 0,
        desc = STRINGS.CITY_PIG_USHER_TRADE,
        reward = "oinc",
        rewardqty = 4
    },

    pigman_royalguard = {
        items = { "spear", "spear_wathgrithr" },
        num = 3,
        current = 0,
        desc = STRINGS.CITY_PIG_GUARD_TRADE,
        reward = "oinc"
    },
    pigman_royalguard_2 = {
        items = { "spear", "spear_wathgrithr" },
        num = 3,
        current = 0,
        desc = STRINGS.CITY_PIG_GUARD_TRADE,
        reward = "oinc"
    },
    --	pigman_shopkeep = 		{items={},						num=5, current=0,	desc=STRINGS.CITY_PIG_SHOPKEEP_TRADE, 	reward = "oinc"},
}


local PRICE =
{
    goldenbar = 20,
    stonebar = 5,
    lucky_goldnugget = 5,
    dubloon = 2,
}

return { TRADER = TRADER, PRICE = PRICE }
