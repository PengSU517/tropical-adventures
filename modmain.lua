GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })




modimport("scripts/tuning")
modimport("main/assets") -----材质包， prefabs



modimport("scripts/languages/language_setting.lua")
modimport("scripts/actions.lua")
-- modimport "tileadder.lua" -------添加小地图
modimport("scripts/ham_fx.lua")
-- AddMinimap()

modimport("scripts/tools/waffles1") ------------------volcano-------------------
modimport("scripts/recipe_tabs")
modimport("scripts/recipes")        --ALL RECIPES--
-- new cookrecipes
-- modimport("scripts/cook_recipes")
-- modimport("scripts/foodingredient")--Runar: 这是分离的食物属性
-- modimport("scripts/preparedfoods_tropical") --Runar: 这是DST格式重写的食谱
modimport("scripts/cooking_tropical")



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
modimport("postinit/prefabs/blueprints")

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





modimport("postinit/player_darkness")
modimport("postinit/widgets/uiclock_bloodmoon")
modimport("postinit/widgets/statusdisplays_speed")
modimport("postinit/farm")               -----种植相关  ---通过veggies改变随机种子权重
modimport("postinit/components/healthtrigger")
modimport("scripts/complementos.lua")    -------------这似乎是个大杂烩，需要整理

modimport("postinit/components/builder") ----------试试看这个有没有问题
modimport("postinit/components/inventoryitem")
modimport("postinit/components/playercontroller")
modimport("postinit/components/embarker")
modimport("postinit/wx78_module")
modimport("postinit/sim_ham") ---------ham cloud


-- modimport("postinit/components/map")
modimport("main/ham_room")                      -----------------新的room
modimport("main/tropical_ocean")                ----------------新的海洋属性
modimport("main/tropical_boat")                 ----------------单人船相关修改

modimport("scripts/widgets/seasonsdisplay.lua") --------------雾和花粉症,还有树荫

modimport("postinit/prefabs/player_hayfever")


modimport("postinit/entityscript") ----修改entity相关
-- modimport("postinit/player")       --------player 出生/进入/退出世界相关


------------------修正暴力覆盖的components
modimport "main/postinit"
-- modimport("postinit/components/playerspawner")
-- modimport("postinit/components/wavemanager")
modimport("postinit/components/aoespell")
modimport("postinit/components/armor")




-----------------debug相关--------------
modimport("postinit/widgets/hoverer_info") ---- show name and anim, for debugging
modimport("main/seafork")






------------------测试内容------------------
-- require "components/map"

-- local old_IsPassableAtPoint = Map.IsPassableAtPoint

-- function Map:IsPassableAtPoint(x, y, z, allow_water, exclude_boats)
--     local valid_tile, is_overhang = self:IsPassableAtPointWithPlatformRadiusBias(x, y, z, allow_water, exclude_boats, 0)

--     -- if is_overhang == nil then
--     --     if not allow_water and not valid_tile then
--     --         if not exclude_boats then
--     --             if TheSim:FindEntities(x, y, z, 0.1, { "boatsw" }) then
--     --                 return true
--     --             end
--     --         end
--     --         return false
--     --     end
--     -- end
--     return valid_tile, is_overhang
-- end
