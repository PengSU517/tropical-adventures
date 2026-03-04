local WikiDesc = {
    -- Mechanics
    generation = {
        world = {
            name = "World Settings",
            intro = [[This mod only retains the [Shipwrecked] and [Hamlet] portions.
                    Players can experience vanilla DST content, Shipwrecked,
                    and Hamlet content simultaneously in the same world ([No world-hopping required]).
                    ----------------
                    The world's default starting area is [Hamlet].
                    Marble setpieces will spawn randomly across the entire map.
                    Other content, such as the Stagehand (Stageplay), Junkyard, and Balatro machine, will spawn in the starting location's area.
                    ----------------
                    When generating a world via the client, please adjust settings through the [Forest & Caves tab].
                    For dedicated servers, please [generate the world via the client] first, then upload the save to the server.]]
        },
        seasons = {
            name = "Seasons",
            intro =
            [[Seasons change according to the [Region]. The Reign of Giants region features Autumn, Winter, Spring, and Summer.
                    The Shipwrecked region features Mild, Hurricane, Monsoon, and Dry seasons.
                    The Hamlet region features Temperate, Humid, and Lush seasons.
                    ----------------
                    [Filters], [Music], and other effects will switch dynamically based on the region and season.]]
        },

        bundled_structure = {
            intro = [[Pack the [playerhouse_city] or other [Shops] with internal spaces
                    into a [bundled_structure] by [Hammering] them.
                    The [bundled_structure] will preserve all items inside the building.
                    ----------------
                    Simply place the [bundled_structure] back on the ground to restore the property, allowing for easy relocation.
                    Note: This action [cannot cross between different worlds].
            ]]
        },
        volcano = {
            name = "Volcano",
            intro = [[The Volcano currently exists as an [Independent Island] in the overworld.
                    The [Temperature] inside the Volcano is significantly higher than in other regions.
                    ----------------
                    The [Volcano Eruption] mechanic is not yet fully implemented and will not erupt naturally for now.]]
        },
        waves = {
            name = "Waves",
            intro = [[Waves will rock the [Ship], but better vessels and [Bumpers] will reduce the impact.
                    For specific wave-breaking efficiency of various boats and bumpers, see the [Boats (Multiplayer)] section.]]
        },

        floods = {
            name = "Flooding",
            intro = [[The flooding mechanic is currently being refined and has been temporarily removed.]]
        },
        ruins = {
            name = "Ruins",
            intro = [[The Ruins are no longer room-based mazes on the surface. Instead, they [Generate Underground]
                    as a maze system similar to the Ancient [Archive].
                    ----------------
                    The [CAVE_EXIT] near the Ruins leads to [Snake Island (also Poison Island)].
                    The underground Hamlet region connects to the [Green Mushroom Forest] of the DST caves.]]
        },

        anthill = {
            name = "Anthill",
            intro = [[The Anthill is no longer a surface-generated room maze, but an area within the caves.
                    ----------------
                    The [CAVE_EXIT] near the Anthill leads to the [Palace City].
                    It connects to the [Green Mushroom Forest] via the underground Hamlet region.]]
        },

        aporkalypse = {
            name = "Aporkalypse",
            intro = [[By default, the Aporkalypse begins when the world reaches Day 120.
                    During the Aporkalypse, the entire world turns blood-red.
                    [Underground], [ancient_herald] and [vampirebat] will spawn periodically; [Surface] will only spawn [vampirebat].
                    ----------------
                    The [aporkalypse_clock] is located deep within the [Hamlet Ruins Maze] in the caves.
                    Turn the [aporkalypse_clock] to stop the Aporkalypse.
                    ----------------
                    Please note that the Aporkalypse requires surface and underground synchronization and conflicts with [Standalone Long Road].]]
        },
    },

    -- Structures (Including all shops)
    structures = {
        pugalisk_fountain = {
            intro = [[During a [Full Moon], if no [pugalisk] is currently alive in the world,
                    moonlight will refill the [pugalisk_fountain].
                    Once a player takes the [waterdrop] from the [pugalisk_fountain], it will spawn a [pugalisk].
                    ----------------
                    [waterdrop] can be planted and provides Sanity restoration.
                    ----------------
                    Defeating the [pugalisk] will drop the crafting blueprint for the [pugalisk_fountain].
                    ----------------
                    Man-made [pugalisk_fountain] structures are more powerful, offering cooling,
                    lightning and rain protection, and Sanity restoration.]]
        },
        pig_palace = {
            intro = [[The [pigman_queen] in the main hall can trade for the [pedestal_key].
                    The [pedestal_key] can be used at display cases in the side halls to exchange for rare items.
                    Examples include [key_to_city], [city_hammer], and [TRINKET_GIFTSHOP_4].]]
        },
        pig_shop_cityhall = {
            intro =
            [[[pigman_mayor] acts as a trading NPC, accepting [goldnugget], [oinc], [dubloon], and other materials.
                    ----------------
                    Inside the City Hall, you can also exchange for items like [deed] and [securitycontract] via display cases.]]
        },
        playerhouse_city = {
            intro = [[Inside, you can craft items via [Interior Tech] to upgrade the house's decor and appearance.]]
        },
        pig_shop_deli = {
            intro = [[Sells high-end cuisine, including [ratatouille], [meatballs], and the expensive [dragonpie].
                    ----------------
                    An excellent place to stock up on cost-effective food.]]
        },
        pig_shop_general = {
            intro = [[Provides basic tools. Sells [axe], [pickaxe], [minerhat], and [umbrella].
                    ----------------
                    Also sells common household supplies like [fabric] and [flint].]]
        },
        pig_shop_hoofspa = {
            intro = [[The town pharmacy. Offers [healingsalve], [bandage], and [antivenom].
                    ----------------
                    If you have enough money, you can even buy a [lifeinjector].]]
        },
        pig_shop_produce = {
            intro = [[Sells fresh ingredients such as [meat], [eggplant], [pumpkin], and [watermelon].
                    ----------------
                    Perfect for taking back to camp to use in the Crock Pot.]]
        },
        pig_shop_florist = {
            intro = [[Sells plant seeds and vegetation, including [corn_seeds], [pumpkin_seeds], and [dug_berrybush].
                    ----------------
                    Also provides [flowerhat] and various decorative plants.]]
        },
        pig_shop_antiquities = {
            intro = [[The most precious shop in Hamlet. Sells [gears], [mandrake], and [deerclops_eyeball].
                    ----------------
                    You can even directly purchase boss drops like [dragon_scales].]]
        },
        pig_shop_academy = {
            intro = [[A place of learning. Sells [malbatross_feather], [trunk_summer], and [shark_fin].
                    ----------------
                    This is your source of materials for researching high-tier tech like the [townportaltalisman].]]
        },
        pig_shop_arcane = {
            intro = [[Sells magical items, including [icestaff], [firestaff], and [nightsword].
                    ----------------
                    Also provides [blueamulet] and the essential [livinglog].]]
        },
        pig_shop_weapons = {
            intro = [[Sells various armaments, including [halberd], [cutlass], and [blowdart_pipe].
                    ----------------
                    [coconade] and various [trap] items are also best-sellers here.]]
        },
        pig_shop_hatshop = {
            intro = [[The fashion center. Sells [tophat], [beefalohat], and the rare [walrushat].
                    ----------------
                    The [sewing_kit] is a must-have for any gentleman to maintain their dignity.]]
        },
        pig_shop_bank = {
            intro = [[The currency center. Responsible for currency exchange and selling some minerals.
                    ----------------
                    The [pigman_banker] oversees all the wealth.]]
        },
        pig_shop_tinker = {
            intro = [[The Blueprint Shop. Sells various rare blueprints.]]
        },
    },

    -- Mobs
    mobs = {
        firetwister = { intro = [[Spawns in the Volcano region. A fire-elemental variant of the [twister].]] },
        twister = { intro = [[A seasonal threat in the Hamlet and Shipwrecked regions.]] },
        slipstor = { intro = [[A peculiar creature found in the Jungle region.]] },
        wildboreking = { intro = [[Similar to the [pigking]; trades for gold but is aggressive.]] },
        ancient_herald = { intro = [[The avatar of the Aporkalypse. Drops the crafting recipe for the [ARMORVORTEXCLOAK].]] },
        pugalisk = {
            intro = [[During a Full Moon, it spawns from the [pugalisk_fountain].
                    ----------------
                    Defeating it drops the blueprint for the [pugalisk_fountain].]]
        },
        kraken = {
            intro = [[A deep-sea behemoth. The first [messagebottle_sw] you open can locate its nest.]]
        },

        pigman_mayor = {
            intro = [[The administrator. Purchases gold products like [goldnugget] and [goldenbar].]]
        },
        pigman_queen = {
            intro = [[The supreme ruler. Highly interested in the [pigcrownhat], [pig_scepter], and [relic_4].]]
        },
        pigman_beautician = {
            intro = [[Has an obsessive love for feathers. You can sell [peagawkfeather] and [feather_robin] to her.]]
        },
        pigman_florist = {
            intro = [[An environmentalist. Purchases [petals], [foliage], and [succulent_picked].]]
        },
        pigman_erudite = {
            intro = [[An occultist. Specializes in purchasing [nightmarefuel].]]
        },
        pigman_hatmaker = {
            intro = [[Needs large amounts of [silk] to craft various marvelous hats.]]
        },
        pigman_storeowner = {
            intro = [[Frugal and diligent. Will buy [clippings] obtained from trimming city greenery.]]
        },
        pigman_banker = {
            intro = [[High-end trader. Purchases various expensive gems like [redgem] and [bluegem].]]
        },
        pigman_collector = {
            intro = [[Enjoys collecting toys like [trinket_1], as well as [stinger] and [spidergland].]]
        },
        pigman_hunter = {
            intro = [[A brave hunter. Will buy [houndstooth] and [hippo_antler].]]
        },
        pigman_professor = {
            intro = [[Antiquities expert. You can bring him cultural relics like [relic_1] excavated from the Ruins.]]
        },
        pigman_usher = {
            intro = [[Loves sweets. Purchases [honey], [jammypreserves], and [waffles].]]
        },
        pigman_farmer = {
            intro = [[Collector of basic resources. Purchases [cutgrass] and [twigs].]]
        },
        pigman_miner = {
            intro = [[Ore enthusiast. Earn rewards by selling [rocks] to him.]]
        },
        pigman_mechanic = {
            intro = [[Master of engineering. Purchases processed [boards], [cutstone], and [rope].]]
        },
        pigman_royalguard = {
            intro = [[Guardian of order. Can be hired as a bodyguard using a [securitycontract].]]
        },
    },

    -- Items
    items = {
        ship = {
            name = "Ship (Single-player)",
            intro =
            [[Unlocked via the [SEAFARING_PROTOTYPER] instead of the [RESEARCHLAB2]. The core tool for solo navigation.]]
        },
        boat = {
            name = "Boat (Multiplayer)",
            intro = [[A vehicle for cooperative sailing. Can be equipped with [Bumpers] to resist wave impact.
                    ----------------
                    DST Boats: [boat], [boat_pirate], [boat_ancient], and [boatmetal] reduce wave impact by 30%, 30%, 40%, and 90% respectively.
                    ----------------
                    Bumpers: [BOAT_BUMPER_KELP], [BOAT_BUMPER_SHELL], [BOAT_BUMPER_YOTD], and [BOAT_BUMPER_CRABKING] reduce impact from the installed direction by 60%, 80%, 80%, and 100% respectively.]]
        },
        smelter = {
            name = "Smelter",
            intro = [[An advanced facility for smelting [iron], [goldnugget], or refining ores.
                    Smelting recipes can be viewed through the [Smart Cooking] mod.]]
        },
    },
}

local WikiTerms = {
    -- Terms
    type = "Type",
    recipe = "Recipe",
    unable_to_craft = "Unable to Craft",
    friendly = "Friendly",
    hostile = "Hostile",
    location = "Location",
    desc = "Description",
    attitude = "Faction",
    unknown = "Unknown",
    about = "Announcement",
    generation = "Mechanics",
    structures = "Structures",
    mobs = "Creatures",
    items = "Items",
    related = "Related Items",
    -----------
    mod_background = "Dev Background",
    mod_progress = "Update Log",
    mod_about = "Tropical Adventure | Ship of Theseus",
    mod_preview = "Foreword",
    mod_sponser = "Donate & Support US !!",
    mod_sponser_list = "Sponser List",

    --------
    click_to_read = "Click to view 'Tropical Adventure' Wiki",
    drag = "drag",
    reset = "reset",
    zoom = "zoom",
}

return {
    WikiDesc = WikiDesc,
    WikiTerms = WikiTerms,
}
