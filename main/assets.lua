Assets =
{
	--LOD SOUND FILE
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUNDPACKAGE", "sound/sw_character.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
	Asset("SOUND", "sound/sw_character.fsb"),
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),




	-------------------animation----------------
	Asset("ANIM", "anim/moon_aporkalypse_phases.zip"),
	Asset("ANIM", "anim/swap_land_fork.zip"),
	Asset("ANIM", "anim/player_actions_paddle.zip"),
	Asset("ANIM", "anim/player_actions_speargun.zip"),
	Asset("ANIM", "anim/player_actions_tap.zip"),
	Asset("ANIM", "anim/player_actions_panning.zip"),
	Asset("ANIM", "anim/player_actions_hand_lens.zip"),
	Asset("ANIM", "anim/player_mount_actions_speargun.zip"),
	Asset("ANIM", "anim/walani_paddle.zip"),
	Asset("ANIM", "anim/player_boat_death.zip"),
	Asset("ANIM", "anim/player_sneeze.zip"),
	Asset("ANIM", "anim/des_sail.zip"),
	Asset("ANIM", "anim/player_actions_trawl.zip"),
	Asset("ANIM", "anim/player_actions_machete.zip"),
	Asset("ANIM", "anim/player_actions_shear.zip"),
	Asset("ANIM", "anim/player_actions_cropdust.zip"),

	--bfb
	Asset("ANIM", "anim/player_actions_bucked.zip"),
	Asset("ANIM", "anim/player_teleport_bfb.zip"),
	Asset("ANIM", "anim/player_teleport_bfb2.zip"),

	Asset("ANIM", "anim/ripple_build.zip"),

	Asset("ANIM", "anim/boat_health.zip"),
	Asset("ANIM", "anim/player_actions_telescope.zip"),
	Asset("ANIM", "anim/pig_house_old.zip"),

	Asset("ANIM", "anim/parrot_pirate_intro.zip"),
	Asset("ANIM", "anim/parrot_pirate.zip"),


	Asset("ANIM", "anim/pig_house_sale.zip"),

	Asset("ANIM", "anim/coi.zip"),
	Asset("ANIM", "anim/ballphinocean.zip"),
	Asset("ANIM", "anim/dogfishocean.zip"),
	Asset("ANIM", "anim/goldfish.zip"),
	Asset("ANIM", "anim/salmon.zip"),
	Asset("ANIM", "anim/sharxocean.zip"),
	Asset("ANIM", "anim/swordfishjocean.zip"),
	Asset("ANIM", "anim/swordfishjocean2.zip"),
	Asset("ANIM", "anim/mecfish.zip"),
	Asset("ANIM", "anim/whaleblueocean.zip"),
	Asset("ANIM", "anim/kingfisher_build.zip"),
	Asset("ANIM", "anim/parrot_blue_build.zip"),
	Asset("ANIM", "anim/toucan_hamlet_build.zip"),
	Asset("ANIM", "anim/toucan_build.zip"),
	Asset("ANIM", "anim/parrot_build.zip"),
	Asset("ANIM", "anim/parrot_pirate_build.zip"),
	Asset("ANIM", "anim/cormorant_build.zip"),
	Asset("ANIM", "anim/seagull_build.zip"),
	Asset("ANIM", "anim/quagmire_pigeon_build.zip"),
	Asset("ANIM", "anim/skeletons.zip"),
	Asset("ANIM", "anim/vagner_over.zip"),
	Asset("ANIM", "anim/leaves_canopy2.zip"),

	Asset("ANIM", "anim/mushroom_tree_yelow.zip"),
	Asset("ANIM", "anim/speedicon.zip"),

	Asset("ANIM", "anim/ui_honeychest_7x.zip"), -- ## Hamlet Plus



	---------------minisign------------------
	Asset("ATLAS_BUILD", "images/inventoryimages/cookpotfoods_ham.xml", 256),
	Asset("ATLAS_BUILD", "images/inventoryimages/cookpotfoods_sw.xml", 256),
	Asset("ATLAS_BUILD", "images/inventoryimages/inventory_shipwrecked.xml", 256),
	Asset("ATLAS_BUILD", "images/inventoryimages/inventory_hamlet.xml", 256),
	Asset("ATLAS_BUILD", "images/inventoryimages/inventory_extension.xml", 256),



	---------inventory -------------------
	Asset("IMAGE", "images/inventoryimages/inventory_shipwrecked.tex"),
	Asset("ATLAS", "images/inventoryimages/inventory_shipwrecked.xml"),
	Asset("IMAGE", "images/inventoryimages/inventory_hamlet.tex"),
	Asset("ATLAS", "images/inventoryimages/inventory_hamlet.xml"),
	Asset("IMAGE", "images/inventoryimages/inventory_extension.tex"),
	Asset("ATLAS", "images/inventoryimages/inventory_extension.xml"),


	--新的食谱大图与物品栏贴图
	Asset("IMAGE", "images/cookbook/cookbook_sw.tex"),
	Asset("ATLAS", "images/cookbook/cookbook_sw.xml"),
	Asset("IMAGE", "images/cookbook/cookbook_ham.tex"),
	Asset("ATLAS", "images/cookbook/cookbook_ham.xml"),
	Asset("IMAGE", "images/inventoryimages/cookpotfoods_sw.tex"),
	Asset("ATLAS", "images/inventoryimages/cookpotfoods_sw.xml"),
	Asset("IMAGE", "images/inventoryimages/cookpotfoods_ham.tex"),
	Asset("ATLAS", "images/inventoryimages/cookpotfoods_ham.xml"),



	-----------character-------------------
	Asset("IMAGE", "images/names_wilbur.tex"),
	Asset("ATLAS", "images/names_wilbur.xml"),
	Asset("IMAGE", "images/names_woodlegs.tex"),
	Asset("ATLAS", "images/names_woodlegs.xml"),
	Asset("IMAGE", "images/names_walani.tex"),
	Asset("ATLAS", "images/names_walani.xml"),


	----------ui-------------------
	Asset("IMAGE", "images/ui/barco.tex"),
	Asset("ATLAS", "images/ui/barco.xml"),
	Asset("ATLAS", "images/ui/poison.xml"),
	Asset("IMAGE", "images/ui/poison.tex"),
	Asset("ATLAS", "images/ui/tabs.xml"),
	Asset("IMAGE", "images/ui/tabs.tex"),
	Asset("IMAGE", "images/ui/honeychest.tex"), -- ### Honey Chest UI
	Asset("ATLAS", "images/ui/honeychest.xml"),

	Asset("IMAGE", "images/fog_cloud.tex"), --云海
}


AddMinimapAtlas("images/inventoryimages/inventory_shipwrecked.xml")
AddMinimapAtlas("images/inventoryimages/inventory_hamlet.xml")
AddMinimapAtlas("images/inventoryimages/inventory_extension.xml")
