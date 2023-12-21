GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
_G = GLOBAL


-------------------placer需要同名


modimport("scripts/tuning") -- Usados no portal the forge: lavaarena_spawner, quagmire_key, lavarenainside   and fueltype, tool action
GLOBAL.TUNING.tropical = {
	wind              = GetModConfigData("wind"),
	hail              = GetModConfigData("hail"),
	hamworld          = GetModConfigData("kindofworld"),
	bramble           = GetModConfigData("bramble"), ----荆棘藤蔓，但似乎实现不怎么样
	roc               = GetModConfigData("roc"),
	-- megarandomCompatibilityWater = GetModConfigData("megarandomCompatibilityWater"),
	-- disableWater      = GetModConfigData("Disable_Water"),
	springflood       = GetModConfigData("flood"),
	sealnado          = GetModConfigData("sealnado"),
	waves             = GetModConfigData("Waves"),
	hamlet            = GetModConfigData("Hamlet"),
	shipwrecked       = GetModConfigData("Shipwrecked"),
	tropicalshards    = GetModConfigData("tropicalshards"),
	removedark        = GetModConfigData("removedark"),
	aporkalypse       = GetModConfigData("aporkalypse"),
	multiplayerportal = GetModConfigData("startlocation"),
	-- greenmod                     = GLOBAL.KnownModIndex:IsModEnabled("workshop-1418878027"),
	kindofworld       = GetModConfigData("kindofworld"),
	-- volcaniceruption  = GetModConfigData("volcaniceruption"), -------没用到？
	forge             = GetModConfigData("forge"),
	fog               = GetModConfigData("fog"),
	hayfever          = GetModConfigData("hayfever"),
	disembarkation    = GetModConfigData("automatic_disembarkation"),
	bosslife          = GetModConfigData("bosslife"),
}




modimport("main/assets") -----材质包， prefabs


------------------修正暴力覆盖的components
modimport("postinit/components/aoespell") ----------怎么利用原函数
modimport("postinit/components/armor")





modimport("scripts/languages/language_setting.lua")
modimport("scripts/actions.lua")
-- modimport "tileadder.lua" -------添加小地图
modimport("scripts/ham_fx.lua")
-- AddMinimap()

modimport("scripts/tools/waffles1")        ------------------volcano-------------------
modimport("scripts/recipe_tabs")
modimport("scripts/recipes")               --ALL RECIPES--
modimport("scripts/cook_recipes")
modimport("postinit/postinit_poisonables") ----------------------posonables----and loot dropper-----------------
modimport("postinit/prefabs/world")
modimport("postinit/prefabs/forest")
modimport("postinit/prefabs/cave")

-----------------------------------------------------------------------
modimport("postinit/widgets/crafttabs")
modimport("main/entity") ------------entity script and onload?
modimport("postinit/widgets/healthbadge")
modimport("postinit/components/inventory_prevent_pick")
modimport("postinit/prefabs/player_classified")
modimport("postinit/prefabs/floatable_items")
modimport("postinit/components/locomoter")
modimport("postinit/widgets/container_widget_boat")
modimport("main/containers")             ---new containers

modimport("postinit/components/weather") ---- disable snow effeccts
modimport("postinit/container_woodleg_boat")
modimport("postinit/container_boat")     ---- boat container sizing tweak by EvenMr


-------------------------------------------------------------------------
--AddPlayerPostInit(function(inst)
--	inst.AnimState:AddOverrideBuild("player_portal_shipwrecked")
--end)

-- --------------------mapwrapper by EvenMr--------------------------
-- if GetModConfigData("kindofworld") == 10 then
-- 	AddPlayerPostInit(function(inst)
-- 		inst:AddComponent("mapwrapper")
-- 	end)
-- end


modimport("postinit/prefabs/lots_of_things")
modimport("postinit/prefabs/player")       ----shopper, drownable, infestable
modimport("postinit/camera")
modimport("postinit/components/sheltered") ----????干啥的  不是用的api

modimport("postinit/sim_rain_effect")





---------------------没看懂---------------
-- GLOBAL.STRINGS.ACTIONS.JUMPIN = {
-- 	HAMLET = "Enter",
-- 	GENERIC = "Jump In",
-- }

-- local Oldstrfnjumpin = ACTIONS.JUMPIN.strfn
-- GLOBAL.ACTIONS.JUMPIN.strfn = function(act)
-- 	if act.target ~= nil and act.target:HasTag("hamletteleport") then
-- 		return "HAMLET"
-- 	end
-- 	return Oldstrfnjumpin(act)
-- end

modimport("postinit/player_darkness")
modimport("postinit/widgets/uiclock_bloodmoon")
modimport("postinit/widgets/statusdisplays_speed")
modimport("postinit/farm")            -----种植相关  ---通过veggies改变随机种子权重
modimport("postinit/components/healthtrigger")
modimport("scripts/complementos.lua") -------------这似乎是个大杂烩，需要整理

-- 	modimport("scripts/windy.lua")-- if GetModConfigData("windyplains") then
-- 	modimport("scripts/creeps.lua")-- if GetModConfigData("underwater") then
-- 	modimport("scripts/greenworld.lua")-- if GetModConfigData("greenworld") then

modimport("postinit/components/builder")
modimport("postinit/components/inventoryitem")
modimport("postinit/components/playercontroller")
modimport("postinit/components/embarker")
modimport("postinit/wx78_module")
modimport("postinit/sim_ham")              ---------ham cloud
modimport("postinit/widgets/hoverer_info") ---- show name and anim, for debugging
modimport("postinit/components/playerspawner")
modimport("postinit/components/wavemanager")
