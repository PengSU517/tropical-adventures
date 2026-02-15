local WikiDesc = {
    -- Mechanics
    generation = {
        world = {
            name = "World Settings",
            intro = [[This mod only retains the [Shipwrecked] and [Hamlet] portions.
                    Players can experience the original DST content along with
                    Shipwrecked and Hamlet content in the same world ([no world-hopping required]).
                    ----------------
                    When generating a world via the client, please adjust settings through the [Forest and Caves customization screens].
                    For dedicated servers, as there are no direct settings, please generate the world via the [client] first and then upload it to the server.]]
        },
        seasons = {
            name = "Seasons",
            intro =
            [[Seasons change according to the [region]: the Forest region features Autumn, Winter, Spring, and Summer;
                    the Shipwrecked region features Mild, Hurricane, Monsoon, and Dry seasons;
                    the Hamlet region features Temperate, Humid, and Lush seasons.
                    ----------------
                    [Color filters], [Music], and other environmental effects will switch based on the region and season.]]
        },

        bundled_structure = {
            intro = [[Pack the [playerhouse_city] or other [shops] with internal spaces
                    into a [bundled_structure] by [hammering] them.
                    The [bundled_structure] will preserve all items contained within the building.
                    ----------------
                    Deploying the [bundled_structure] back onto the ground restores your previous property, allowing for house relocation.
                    Note!!! This operation [cannot cross worlds].]]
        },
        volcano = {
            name = "Volcano",
            intro =
            [[The Volcano currently exists as an [independent island] in the overworld. The [temperature] at the Volcano is significantly higher than in other regions.
                    ----------------
                    The [Volcano Eruption] mechanics are not yet fully implemented and will not occur naturally at this time.]]
        },
        waves = {
            name = "Waves",
            intro = [[Waves will impact [boats], but better vessels and [bumpers] will reduce the influence of waves.
                    For details on the wave-breaking efficiency of various boats and bumpers, please refer to the [Boats (DST)] section.]]
        },

        floods = {
            name = "Flooding",
            intro = [[The flooding mechanics are still being refined and have been temporarily removed.]]
        },
        ruins = {
            name = "Ruins",
            intro =
            [[Ruins are no longer generated as surface mazes; they are [generated underground] using a maze system similar to the Ancient [Archive].
                    ----------------
                    The [CAVE_EXIT] near the ruins leads to [Snake Island (also Poison Island)]. It connects to the [Green Mushroom Forest] of the DST Caves through the underground Hamlet region.]]
        },

        anthill = {
            name = "Anthill",
            intro = [[Anthills are no longer surface mazes but rather a specific area within the caves.
                    ----------------
                    The [CAVE_EXIT] near the Anthill leads to the [Palace City]. It connects to the [Green Mushroom Forest] of the DST Caves through the underground Hamlet region.]]
        },

        aporkalypse = {
            name = "Aporkalypse",
            intro = [[By default, the Aporkalypse begins when the world reaches day 120.
                    The entire world turns blood-red during the event.
                    [ancient_herald] and [vampirebat] will spawn [underground] periodically, while only [vampirebat] will spawn [on the surface].
                    ----------------
                    The [aporkalypse_clock] is located deep within the [Hamlet Ruins Maze] in the caves. Rotate the [aporkalypse_clock] to stop the Aporkalypse.
                    ----------------
                    Please note that the Aporkalypse requires synchronization between the surface and caves and conflicts with the "Don't Starve Alone" mod.]]
        },
    },

    -- Structures (Including all Shops)
    structures = {
        pugalisk_fountain = {
            intro =
            [[During a [Full Moon], if no [pugalisk] is alive in the world, moonlight will refill the [pugalisk_fountain].
                    Once a player takes the [waterdrop] from the [pugalisk_fountain], a [pugalisk] will spawn.
                    ----------------
                    [waterdrop] can be planted and provides a sanity restoration effect.
                    ----------------
                    Defeating the [pugalisk] will drop the blueprint for the [pugalisk_fountain].
                    ----------------
                    Crafted [pugalisk_fountain] structures possess greater power, providing cooling, lightning/rain protection, and sanity restoration.]]
        },
        pig_palace = {
            intro = [[The [pigman_queen] in the main hall can be traded with for the [pedestal_key].
                    Use the [pedestal_key] in the side hall's display cases to obtain rare items
                    such as the [key_to_city], [city_hammer], and [TRINKET_GIFTSHOP_4].]]
        },
        pig_shop_cityhall = {
            intro =
            [[[pigman_mayor] acts as a trading NPC, accepting [goldnugget], [oinc], [dubloon], and other materials.
                    ----------------
                    Inside City Hall, you can also exchange for the [deed] and [securitycontract] via display cases.]]
        },
        playerhouse_city = {
            intro =
            [[Interiors allow for item crafting via [Interior Tech], enabling upgrades to the home's decor and appearance.]]
        },
        pig_shop_deli = {
            intro = [[Sells high-tier dishes, including [ratatouille], [meatballs], and the expensive [dragonpie].
                    ----------------
                    An excellent place to stock up on high-value food items.]]
        },
        pig_shop_general = {
            intro = [[Provides basic tools. Sells the [axe], [pickaxe], [minerhat], and [umbrella].
                    ----------------
                    Also sells [fabric], [flint], and other common survival supplies.]]
        },
        pig_shop_hoofspa = {
            intro = [[The town pharmacy. Provides [healingsalve], [bandage], and [antivenom].
                    ----------------
                    If you have enough funds, you can even purchase a [lifeinjector].]]
        },
        pig_shop_produce = {
            intro = [[Sells fresh ingredients such as [meat], [eggplant], [pumpkin], and [watermelon].
                    ----------------
                    Perfect for taking back to camp to use with a Crock Pot.]]
        },
        pig_shop_florist = {
            intro = [[Sells plant seeds and flora, including [corn_seeds], [pumpkin_seeds], and [dug_berrybush].
                    ----------------
                    Also offers [flowerhat] and various decorative plants.]]
        },
        pig_shop_antiquities = {
            intro = [[The most valuable shop in Hamlet. Sells [gears], [mandrake], and [deerclops_eyeball].
                    ----------------
                    You can even directly purchase BOSS drops like [dragon_scales].]]
        },
        pig_shop_academy = {
            intro = [[A center for academic research. Sells [malbatross_feather], [trunk_summer], and [shark_fin].
                    ----------------
                    The source of materials for researching high-tier technologies like the [townportaltalisman].]]
        },
        pig_shop_arcane = {
            intro = [[Sells magical items, including the [icestaff], [firestaff], and [nightsword].
                    ----------------
                    Also provides the [blueamulet] and the essential [livinglog].]]
        },
        pig_shop_weapons = {
            intro = [[Sells various armaments, including the [halberd], [cutlass], and [blowdart_pipe].
                    ----------------
                    [coconade] and various [trap] items are also bestsellers here.]]
        },
        pig_shop_hatshop = {
            intro = [[The fashion center. Sells the [tophat], [beefalohat], and the rare [walrushat].
                    ----------------
                    The [sewing_kit] is an essential item for every gentleman to maintain their appearance.]]
        },
        pig_shop_bank = {
            intro = [[The currency center. Responsible for money exchange and also sells some minerals.
                    ----------------
                    The [pigman_banker] is in charge of guarding all the wealth.]]
        },
        pig_shop_tinker = {
            intro = [[The blueprint shop. Sells various rare blueprints.]]
        },
    },

    -- Creatures
    mobs = {
        firetwister = { intro = [[Spawns in the Volcano region. A fire-attribute variant of the [twister].]] },
        twister = { intro = [[A seasonal threat in both the Hamlet and Shipwrecked regions.]] },
        slipstor = { intro = [[A peculiar creature of the Jungle regions.]] },
        wildboreking = { intro = [[Similar to the [pigking], can be traded for gold but is aggressive.]] },
        ancient_herald = { intro = [[The herald of the Aporkalypse. Drops the [vortex_cloak] crafting blueprint upon death.]] },
        kraken = { intro = [[A beast of the deep sea. The first [messagebottle_sw] you open can locate its nest.]] },

        pigman_mayor = {
            intro = [[The Administrator. Purchases [goldnugget], [goldenbar], and other gold products.]]
        },
        pigman_queen = {
            intro = [[The Supreme Ruler. Highly interested in the [pigcrownhat], [pig_scepter], and [relic_4].]]
        },
        pigman_beautician = {
            intro = [[Obsessed with feathers. You can sell [peagawkfeather] and [feather_robin] to her.]]
        },
        pigman_florist = {
            intro = [[An environmentalist. Purchases [petals], [foliage], and [succulent_picked].]]
        },
        pigman_erudite = {
            intro = [[An occult scholar. Specializes in purchasing [nightmarefuel].]]
        },
        pigman_hatmaker = {
            intro = [[Requires large amounts of [silk] to craft various marvelous hats.]]
        },
        pigman_storeowner = {
            intro = [[Thrifty and hardworking. Will purchase the [clippings] you obtain from trimming the city hedges.]]
        },
        pigman_banker = {
            intro = [[A high-end trader. Responsible for purchasing [redgem], [bluegem], and other expensive gems.]]
        },
        pigman_collector = {
            intro = [[Loves collecting toys like [trinket_1], as well as [stinger] and [spidergland].]]
        },
        pigman_hunter = {
            intro = [[A brave hunter. Purchases [houndstooth] and [hippo_antler].]]
        },
        pigman_professor = {
            intro = [[An expert on antiquities. You can hand over [relic_1] and other relics found in ruins to him.]]
        },
        pigman_usher = {
            intro = [[Loves sweets. Purchases [honey], [jammypreserves], and [waffles].]]
        },
        pigman_farmer = {
            intro = [[A gatherer of basic resources. Purchases [cutgrass] and [twigs].]]
        },
        pigman_miner = {
            intro = [[A mineral enthusiast. Earn rewards by selling [rocks] to him.]]
        },
        pigman_mechanic = {
            intro = [[A master of engineering. Purchases refined [boards], [cutstone], and [rope].]]
        },
        pigman_royalguard = {
            intro = [[A guardian of order. Can be hired as a bodyguard using a [securitycontract].]]
        },
    },

    -- Items
    items = {
        ship = {
            name = "Boats (Single-player)",
            intro =
            [[Unlocked via the [SEAFARING_PROTOTYPER], no longer through [RESEARCHLAB2]. The core tool for single-player navigation.]]
        },
        boat = {
            name = "Boats (Multiplayer)",
            intro = [[Vessels for cooperative sailing. Can be equipped with [bumpers] to resist wave impacts.
                    ----------------
                    DST Boats: [boat]/[boat_pirate]/[boat_ancient]/[boatmetal] reduce wave impact by 30%/30%/40%/90% respectively;
                    ----------------
                    Bumpers: [BOAT_BUMPER_KELP]/[BOAT_BUMPER_SHELL]/[BOAT_BUMPER_YOTD]/[BOAT_BUMPER_CRABKING] reduce impact by 60%/80%/80%/100% respectively in the direction of installation.]]
        },
        smelter = {
            name = "Smelter",
            intro = [[An advanced facility for smelting [iron], [goldnugget], or refining minerals.
                    Alchemy recipes can be viewed through the [Smart Pot] mod.]]
        },
    },
}

local WikiTerms = {
    type = "Type",
    recipe = "Recipe",
    unable_to_craft = "Unable to Craft",
    friendly = "Friendly",
    hostile = "Hostile",
    location = "Location",
    desc = "Description",
    attitude = "Attitude",
    unknown = "Unknown",
    about = "Announcement",
    generation = "Mechanics",
    structures = "Structures",
    mobs = "Creatures",
    items = "Items",
    related = "Related Items",
    -----------
    mod_background = "Development Background",
    mod_progress = "Update Log",
    mod_about = "Tropical Adventures | Ship of Theseus",
    mod_preview = "Introduction",
    mod_sponser = "Sponsorship",
    click_to_read = "Click to read \"Tropical Adventures\"WikiBook",
}

return {
    WikiDesc = WikiDesc,
    WikiTerms = WikiTerms,
}
