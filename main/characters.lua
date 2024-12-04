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
TUNING.WILBUR_HEALTH = 125
TUNING.WILBUR_SANITY = 150
TUNING.WILBUR_HUNGER = 175

--Woodlegs:
TUNING.WOODLEGS_HEALTH = 150
TUNING.WOODLEGS_SANITY = 120
TUNING.WOODLEGS_HUNGER = 150
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WOODLEGS = { "woodlegshat", "boatcannon", "boards", "boards", "boards", "boards",
    "dubloon", "dubloon", "dubloon", "dubloon" }
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["woodlegshat"] = { image = "woodlegshat.tex", }
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["boatcannon"] = { image = "boatcannon.tex", }
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["dubloon"] = { image = "dubloon.tex", }

--Walani
TUNING.WALANI_HEALTH = 120
TUNING.WALANI_SANITY = 200
TUNING.WALANI_HUNGER = 200

TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WALANI = { "surfboarditem" }
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["surfboarditem"] = { image = "surfboarditem.tex", }
