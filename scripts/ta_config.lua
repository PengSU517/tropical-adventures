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
    -- tropicalshards    = false, ----GetModConfigData("tropicalshards"),  ------------删掉所有用到的地方
    -- removedark        = false, ----GetModConfigData("removedark"),-----------只在underwater用到
    -- hamworld          = false, ----GetModConfigData("kindofworld"),  没用上
    -- bramble           = false, ----GetModConfigData("bramble"), ----荆棘藤蔓，但似乎实现不怎么样   没用上
    -- roc               = true, ----GetModConfigData("roc"),   没用上
    -- sealnado          = true, ----GetModConfigData("sealnado"),--------------parrotspawner里很多东西很奇怪
    -- greenmod                     = GLOBAL.KnownModIndex:IsModEnabled("workshop-1418878027"),


    -- kindofworld       = 15,    ------GetModConfigData("kindofworld"),
    -- forge             = false, ----GetModConfigData("forge"),
    disembarkation = false, -----GetModConfigData("automatic_disembarkation"),------------自动离开船
    bosslife       = 1,     --------GetModConfigData("bosslife"),


    -- ocean = GetModConfigData("ocean"),
    ocean = "default",


    testmode   = GetModConfigData("testmode"),
    prefabname = GetModConfigData("prefabname"),
    seafork    = GetModConfigData("seafork"),


    ndnr = GLOBAL.KnownModIndex:IsModEnabled("workshop-2823458540"),
}


TA_CONFIG.sw_start = TA_CONFIG.shipwrecked and (TA_CONFIG.multiplayerportal == "shipwrecked")
TA_CONFIG.ham_start = TA_CONFIG.hamlet and (TA_CONFIG.multiplayerportal == "hamlet")
TA_CONFIG.together_not_mainland = (TA_CONFIG.sw_start or TA_CONFIG.ham_start)
TA_CONFIG.together = not ((not TA_CONFIG.rog) and TA_CONFIG.together_not_mainland)


GLOBAL.TUNING.tropical = GLOBAL.TA_CONFIG
