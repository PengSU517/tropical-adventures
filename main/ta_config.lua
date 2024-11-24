local source = debug.getinfo(1, "S").source
local istestmode = source:match("([^/]+)/[^/]*/[^/]*/[^/]*$") == "mods"
    and not (source:match("workshop-") or source:match("2986194136"))

GLOBAL.TA_CONFIG = {

    language          = GetModConfigData("language"),

    rog               = GetModConfigData("rog"),
    shipwrecked       = GetModConfigData("shipwrecked"),
    hamlet            = GetModConfigData("hamlet"),

    multiplayerportal = GetModConfigData("startlocation"),
    startlocation     = GetModConfigData("startlocation"),
    worldsize         = GetModConfigData("worldsize"),
    coastline         = GetModConfigData("coastline"),
    layout            = true, --  GetModConfigData("layout"),


    springflood      = false, ---GetModConfigData("flood"),
    wind             = GetModConfigData("wind"),
    waves            = GetModConfigData("waves"),
    hail             = GetModConfigData("hail"),
    volcaniceruption = false, ------GetModConfigData("volcaniceruption"),

    fog              = GetModConfigData("fog"),
    hayfever         = GetModConfigData("hayfever"),
    aporkalypse      = GetModConfigData("aporkalypse"),
    -- bramble           = false, ----GetModConfigData("bramble"), ----荆棘藤蔓，但似乎实现不怎么样   没用上
    roc              = GetModConfigData("roc"),      -----没用上
    sealnado         = GetModConfigData("sealnado"), --------------parrotspawner里很多东西很奇怪

    disembarkation   = false,                        -----GetModConfigData("automatic_disembarkation"),------------自动离开船
    bosslife         = 1,                            --------GetModConfigData("bosslife"),


    -- ocean = GetModConfigData("ocean"),
    ocean = "default",

    testmap = istestmode and GetModConfigData("test_map") or false,
    testmode = istestmode and GetModConfigData("test_mode") or false,

    ndnr = GLOBAL.KnownModIndex:IsModEnabled("workshop-2823458540"),

}

TA_CONFIG.sw_start = TA_CONFIG.shipwrecked and (TA_CONFIG.multiplayerportal == "shipwrecked")
TA_CONFIG.ham_start = TA_CONFIG.hamlet and (TA_CONFIG.multiplayerportal == "hamlet")
TA_CONFIG.together_not_mainland = (TA_CONFIG.sw_start or TA_CONFIG.ham_start)
TA_CONFIG.together = not ((not TA_CONFIG.rog) and TA_CONFIG.together_not_mainland)

TA_CONFIG.sealnado = TA_CONFIG.shipwrecked and TA_CONFIG.sealnado or false
TA_CONFIG.fog = TA_CONFIG.hamlet and TA_CONFIG.fog or false
TA_CONFIG.hayfever = TA_CONFIG.hamlet and TA_CONFIG.hayfever or false
TA_CONFIG.aporkalypse = TA_CONFIG.hamlet and TA_CONFIG.aporkalypse or false
TA_CONFIG.roc = TA_CONFIG.hamlet and TA_CONFIG.roc or false


GLOBAL.TUNING.tropical = GLOBAL.TA_CONFIG




GLOBAL.tro_pairedkey = {
    qe = { 113, 101 },
    du = { 274, 273 },
    lr = { 276, 275 },
    mp = { 45, 61 },
    pp = { 281, 280 },
    he = { 278, 279 }
}




GLOBAL.TA_CONFIG_CLIENT = {
    fov_keys = tro_pairedkey[GetModConfigData("roomview")],
    height_keys = tro_pairedkey[GetModConfigData("build_height")],
    rotation_keys = tro_pairedkey[GetModConfigData("build_rotation")],
}
