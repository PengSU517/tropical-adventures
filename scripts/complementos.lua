GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
_G = GLOBAL


AddMinimapAtlas("map_icons/hamleticon.xml")
--configurar idioma

--Desabilitar personagens
-- if not GetModConfigData("disablecharacters") then

AddModCharacter("walani", "FEMALE")
AddModCharacter("wilbur", "NEUTRAL")
AddModCharacter("woodlegs", "MALE")

RemapSoundEvent("dontstarve/characters/walani/talk_LP", "dontstarve_DLC002/characters/walani/talk_LP")
RemapSoundEvent("dontstarve/characters/walani/ghost_LP", "dontstarve_DLC002/characters/walani/ghost_LP")
RemapSoundEvent("dontstarve/characters/walani/hurt", "dontstarve_DLC002/characters/walani/hurt")
RemapSoundEvent("dontstarve/characters/walani/death_voice", "dontstarve_DLC002/characters/walani/death_voice")
RemapSoundEvent("dontstarve/characters/walani/emote", "dontstarve_DLC002/characters/walani/emote")
RemapSoundEvent("dontstarve/characters/walani/yawn", "sw_character/characters/walani/yawn")
RemapSoundEvent("dontstarve/characters/walani/eye_rub_vo", "dontstarve_DLC002/characters/walani/eye_rub_vo")
RemapSoundEvent("dontstarve/characters/walani/pose", "dontstarve_DLC002/characters/walani/pose")
RemapSoundEvent("dontstarve/characters/walani/carol", "sw_character/characters/walani/carol")
RemapSoundEvent("dontstarve/characters/walani/sleepy", "sw_character/characters/walani/sleepy")

RemapSoundEvent("dontstarve/characters/wilbur/talk_LP", "dontstarve_DLC002/characters/wilbur/talk_LP")
RemapSoundEvent("dontstarve/characters/wilbur/ghost_LP", "dontstarve_DLC002/characters/wilbur/ghost_LP")
RemapSoundEvent("dontstarve/characters/wilbur/hurt", "dontstarve_DLC002/characters/wilbur/hurt")
RemapSoundEvent("dontstarve/characters/wilbur/death_voice", "dontstarve_DLC002/characters/wilbur/death_voice")
RemapSoundEvent("dontstarve/characters/wilbur/emote", "dontstarve_DLC002/characters/wilbur/emote")
RemapSoundEvent("dontstarve/characters/wilbur/yawn", "sw_character/characters/wilbur/yawn")
RemapSoundEvent("dontstarve/characters/wilbur/eye_rub_vo", "dontstarve_DLC002/characters/wilbur/eye_rub_vo")
RemapSoundEvent("dontstarve/characters/wilbur/pose", "dontstarve_DLC002/characters/wilbur/pose")
RemapSoundEvent("dontstarve/characters/wilbur/carol", "sw_character/characters/wilbur/carol")
RemapSoundEvent("dontstarve/characters/wilbur/sleepy", "sw_character/characters/wilbur/sleepy")

RemapSoundEvent("dontstarve/characters/woodlegs/talk_LP", "dontstarve_DLC002/characters/woodlegs/talk_LP")
RemapSoundEvent("dontstarve/characters/woodlegs/ghost_LP", "dontstarve_DLC002/characters/woodlegs/ghost_LP")
RemapSoundEvent("dontstarve/characters/woodlegs/hurt", "dontstarve_DLC002/characters/woodlegs/hurt")
RemapSoundEvent("dontstarve/characters/woodlegs/death_voice", "dontstarve_DLC002/characters/woodlegs/death_voice")
RemapSoundEvent("dontstarve/characters/woodlegs/emote", "dontstarve_DLC002/characters/woodlegs/emote")
RemapSoundEvent("dontstarve/characters/woodlegs/yawn", "sw_character/characters/woodlegs/yawn")
RemapSoundEvent("dontstarve/characters/woodlegs/eye_rub_vo", "dontstarve_DLC002/characters/woodlegs/eye_rub_vo")
RemapSoundEvent("dontstarve/characters/woodlegs/pose", "dontstarve_DLC002/characters/woodlegs/pose")
RemapSoundEvent("dontstarve/characters/woodlegs/carol", "sw_character/characters/woodlegs/carol")
RemapSoundEvent("dontstarve/characters/woodlegs/sleepy", "sw_character/characters/woodlegs/sleepy")

--Wilbur
GLOBAL.STRINGS.CHARACTER_TITLES.wilbur = "The Monkey King"
GLOBAL.STRINGS.CHARACTER_NAMES.wilbur = "Wilbur"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.wilbur = "*Can't talk\n*Slow as biped, but fast as quadruped\n*Is a monkey"
GLOBAL.STRINGS.CHARACTER_QUOTES.wilbur = "\"Ooo ooa oah ah!\""
GLOBAL.STRINGS.NAMES.WILBUR = "Wilbur"
GLOBAL.STRINGS.CHARACTER_ABOUTME.wilbur = "Can't talk Slow as biped, fast as quadruped Is a monkey"
GLOBAL.STRINGS.CHARACTER_SURVIVABILITY.wilbur = "Slim"
TUNING.WILBUR_HEALTH = 125
TUNING.WILBUR_SANITY = 150
TUNING.WILBUR_HUNGER = 175

--Woodlegs:
GLOBAL.STRINGS.CHARACTER_TITLES.woodlegs = "The Pirate Captain"
GLOBAL.STRINGS.CHARACTER_NAMES.woodlegs = "Woodlegs"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.woodlegs = "*Has his lucky hat\n*Has his lucky cutlass\n*Pirate"
GLOBAL.STRINGS.CHARACTER_QUOTES.woodlegs = "\"Don't ye mind th'scurvy. Yarr-harr-harr!\""
GLOBAL.STRINGS.CHARACTERS.WOODLEGS = require "speech_woodlegs"
GLOBAL.STRINGS.NAMES.WOODLEGS = "Woodlegs"
GLOBAL.STRINGS.CHARACTER_ABOUTME.woodlegs = "Don't ye mind th'scurvy. Yarr-harr-harr!"
GLOBAL.STRINGS.CHARACTER_SURVIVABILITY.woodlegs = "Grim"
TUNING.WOODLEGS_HEALTH = 150
TUNING.WOODLEGS_SANITY = 120
TUNING.WOODLEGS_HUNGER = 150
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WOODLEGS = { "luckyhat", "boatcannon", "boards", "boards", "boards", "boards",
    "dubloon", "dubloon", "dubloon", "dubloon" }
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["luckyhat"] = {
    atlas = "images/inventoryimages/volcanoinventory.xml",
    image = "luckyhat.tex",
}
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["boatcannon"] = {
    atlas = "images/inventoryimages/volcanoinventory.xml",
    image = "boatcannon.tex",
}
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["dubloon"] = {
    atlas = "images/inventoryimages/volcanoinventory.xml",
    image = "dubloon.tex",
}

--Walani
GLOBAL.STRINGS.CHARACTER_TITLES.walani = "The Unperturbable"
GLOBAL.STRINGS.CHARACTER_NAMES.walani = "Walani"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.walani = "*Loves surfing\n*Dries off quickly\n*Is a pretty chill gal"
GLOBAL.STRINGS.CHARACTER_QUOTES.walani = "\"Forgive me if I don't get up. I don't want to.\""
GLOBAL.STRINGS.CHARACTERS.WALANI = require "speech_walani"
GLOBAL.STRINGS.NAMES.WALANI = "Walani"
GLOBAL.STRINGS.CHARACTER_ABOUTME.walani = "Forgive me if I don't get up. I don't want to."
GLOBAL.STRINGS.CHARACTER_SURVIVABILITY.walani = "Slim"
TUNING.WALANI_HEALTH = 120
TUNING.WALANI_SANITY = 200
TUNING.WALANI_HUNGER = 200

TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WALANI = { "surfboarditem" }
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["surfboarditem"] = {
    atlas = "images/inventoryimages/volcanoinventory.xml",
    image = "surfboarditem.tex",
}


-- end



--if GetModConfigData("musica") == true then
--RemapSoundEvent( "dontstarve/music/music_work", "tropical/music/music_work")
--RemapSoundEvent( "dontstarve/music/music_work_winter", "tropical/music/music_work_winter")
--RemapSoundEvent( "dontstarve_DLC001/music/music_work_spring", "tropical/music/music_work_spring")
--RemapSoundEvent( "dontstarve_DLC001/music/music_work_summer", "tropical/music/music_work_summer")
--RemapSoundEvent( "dontstarve/music/music_epicfight", "tropical/music/music_epicfight")
--RemapSoundEvent( "dontstarve/music/music_epicfight_winter",  "tropical/music/music_epicfight_winter")
--RemapSoundEvent( "dontstarve_DLC001/music/music_epicfight_spring", "tropical/music/music_epicfight_spring")
--RemapSoundEvent( "dontstarve_DLC001/music/music_epicfight_summer", "tropical/music/music_epicfight_summer")
--RemapSoundEvent( "dontstarve/music/music_danger", "tropical/music/music_danger")
--RemapSoundEvent( "dontstarve/music/music_danger_winter", "tropical/music/music_danger_winter")
--RemapSoundEvent( "dontstarve_DLC001/music/music_danger_spring", "tropical/music/music_danger_spring")
--RemapSoundEvent( "dontstarve_DLC001/music/music_danger_summer", "tropical/music/music_danger_summer")
--end


AddModRPCHandler("volcanomod", "quest1", function(inst)
    local portalinvoca1 = GLOBAL.SpawnPrefab("log")
    local a, b, c = inst.Transform:GetWorldPosition()
    portalinvoca1.Transform:SetPosition(a + 4, b, c - 4)

    GLOBAL.TheFrontEnd:PopScreen()
    GLOBAL.SetPause(false)
    --inst:Remove()
end)
AddModRPCHandler("volcanomod", "quest2", function(inst)
    GLOBAL.TheFrontEnd:PopScreen()
    GLOBAL.SetPause(false)
    --inst:Remove()
end)

GLOBAL.CHERRY = false
if GLOBAL.KnownModIndex:IsModEnabled("workshop-1289779251") then GLOBAL.CHERRY = true end

--------------store---------

modimport("scripts/MagicStore.lua")
modimport("scripts/DataProvider.lua")
--------------------------------------
