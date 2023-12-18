GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
local require = GLOBAL.require

-- GLOBAL.SIZE_VARIATION = 1


require("constants")
require("map/rooms")
require("map/tasks")
require("map/terrain")
require("map/level")
require("map/room_functions")
require("map/tro_lockandkey")


-- modimport "scripts/map/tro_lockandkey.lua"  --add new keys
modimport 'tileadder.lua'                   --add new terrain AddTile()
AddTiles()                                  --addtiles加在这里就能在小地图上正确显示地皮,但是为啥啊，这又不是小地图的事

modimport "scripts/init_static_layouts.lua" --add new static layouts
-- modimport "scripts/map/map_tuning.lua"      --彩蛋和parameter, 放在了rooms/sw中
modimport "scripts/map/rooms/ham.lua"
modimport "scripts/map/rooms/sw.lua"
modimport "scripts/map/rooms/unknown.lua"
modimport "scripts/map/tasks/ham.lua"
modimport "scripts/map/tasks/sw.lua"
-- modimport("postinit/map/forest_map") --设置地图大小



local MapTags = { "frost", "hamlet", "tropical", "underwater", "folha" }

AddGlobalClassPostConstruct("map/storygen", "Story", function(self)
	for k, v in pairs(MapTags) do
		self.map_tags.Tag[v] = function(tagdata) return "TAG", v end
	end
end)

local size = 450 --450是默认边长

if GLOBAL.rawget(GLOBAL, "WorldSim") then
	local idx = GLOBAL.getmetatable(GLOBAL.WorldSim).__index

	local OldSetWorldSize = idx.SetWorldSize

	idx.SetWorldSize = function(self, width, height)
		print("[Giant Size] Setting world size to " .. (size or width))
		OldSetWorldSize(self, size or width, size or height)
	end

	local OldConvertToTileMap = idx.ConvertToTileMap
	idx.ConvertToTileMap = function(self, length)
		OldConvertToTileMap(self, size or length)
	end

	idx.SeparateIslands = function(self) print("不分离土地") end
end

-- local Layouts = require("map/layouts").Layouts
-- local StaticLayout = require("map/static_layout")
-- local blockersets = require("map/blockersets")
-- local GROUND = GLOBAL.GROUND
-- local LEVELTYPE = GLOBAL.LEVELTYPE
--之前究竟是为什么彩蛋的地皮加载不正常呢，好奇怪啊

-- WorldSim:SetWorldSize(700, 700)
--地图设置时每个graph链接四个其他graph时比较合理的
--storygen之后再处理，不太懂

-- AddStartLocation("NewStart", {
-- 	name = STRINGS.UI.SANDBOXMENU.DEFAULTSTART,
-- 	location = "forest",
-- 	start_setpeice = "newstart", --生成的static layout  --layout太大的话需要设置大小
-- 	start_node = "Clearing",  --"Blank",  --生成位置, 并在包含该room的task新生成一个相同room  blank就是生成在海上
-- })



local function LevelPreInit(level)
	if level.location == "cave" then
		-- level.overrides.keep_disconnected_tiles = true

		-- table.insert(level.tasks, "HamMudWorld") ---地下版的出生地，但是爪树 "HamLightPlantFieldexit"--exit1
		-- --有刷新哈奇的标签 我不理解  有 有exit2
		-- -- level.set_pieces["newstartlocation2"] = { count = 1, tasks = { "HamMudWorld" } }
		-- -- table.insert(level.tasks, "separahamcave")
		-- table.insert(level.tasks, "HamMudCave") --同质化严重  "HamMudWithRabbitexit" 有exit2
		-- -- table.insert(level.tasks, "HamMudLights")--同质化严重
		-- -- table.insert(level.tasks, "HamMudPit")--有石笋区域

		-- table.insert(level.tasks, "HamBigBatCave") --石笋和湖泊区域 --"HamFernyBatCaveexit"exit3
		-- table.insert(level.tasks, "HamRockyLand") --"HamBatsAndRocky"有蚁后
		-- -- table.insert(level.tasks, "HamRedForest") ---exo这里是黄蘑菇啊
		-- -- table.insert(level.tasks, "HamGreenForest") ---绿蘑菇雨林，没有草树枝？？？有猩猩蜘蛛 嗨哟个地下遗迹
		-- -- table.insert(level.tasks, "HamBlueForest") ---蓝蘑菇 茶树草树枝
		-- -- table.insert(level.tasks, "HamSpillagmiteCaverns") ---这才是红蘑菇林，搞笑
		-- -- table.insert(level.tasks, "HamSpillagmiteCaverns1")--石笋红蘑菇蝙蝠cave区
		-- table.insert(level.tasks, "caveruinsexit") --似乎是蛇岛出口
		-- table.insert(level.tasks, "caveruinsexit2") --女王岛出口

		-- table.insert(level.tasks, "HamMoonCaveForest") ---坟墓区
		-- table.insert(level.tasks, "HamArchiveMaze") ---迷宫区域

		-- --if GetModConfigData("Volcano") == true then
		-- table.insert(level.tasks, "separavulcao")
		-- table.insert(level.tasks, "vulcaonacaverna")
		-- table.insert(level.tasks, "vulcaonacaverna1")
		-- table.insert(level.tasks, "vulcaonacaverna2")
		-- table.insert(level.tasks, "vulcaonacaverna3")
		-- table.insert(level.tasks, "vulcaonacaverna4")
		--end
	end

	if level.location == "forest" then
		level.tasks = { "Make a pick", "Dig that rock" } ---
		-- level.overrides.start_location = "NewStart"
		-- level.valid_start_tasks = { "Speak to the king" }




		-- level.numoptionaltasks = 0
		-- level.optionaltasks = {}
		-- level.random_set_pieces = {}
		-- level.numrandom_set_pieces = 0

		-- level.ocean_population = {}
		-- level.ocean_prefill_setpieces = {}

		-- level.overrides.keep_disconnected_tiles = true
		-- level.overrides.roads = "never"
		-- level.overrides.birds = "never"
		-- level.overrides.has_ocean = false
		-- level.required_prefabs = {}
		-- level.set_pieces = {}
		-- level.ordered_story_setpieces = {}
		---------------即使加上这两也会刷新泰拉瑞亚
		---------------而且不设置task把pieces置空的话会导致世界无法生成，似乎是某个task需要特定的pieces
		-- level.set_pieces["CaveEntrance"] = { count = 1, tasks={"Make a pick"} },




		-- level.set_pieces["cidade1"] = { count = 1, tasks = { "Make a pick" } }
		-- level.set_pieces["shipwrecked_start"] = { count = 1, tasks = { "Dig that rock" } }





		-- table.insert(level.tasks, "Mrainforest_ruins") --这才应该是出门位置
		-- level.set_pieces["start_ham"] = { count = 1, tasks = { "Mrainforest_ruins" } }
		-- level.set_pieces["cave_entranceham1"] = { count = 1, tasks = { "Mrainforest_ruins" } }
		-- level.set_pieces["cave_entranceham2"] = { count = 1, tasks = { "Mrainforest_ruins" } }
		-- level.set_pieces["cave_entranceham3"] = { count = 1, tasks = { "Mrainforest_ruins" } }
		-- level.set_pieces["pig_ruins_entrance_1"] = { count = 1, tasks = { "Mrainforest_ruins" } } ---砖块地皮是57

		-- table.insert(level.tasks, "Mplains") --island3 高草地形，类似牛场
		-- -- table.insert(level.tasks, "Mplains_ruins") --island3 --这个和plains过度相似
		-- -- level.valid_start_tasks = { "Mplains" }
		-- -- -- table.insert(level.tasks, "MDeep_rainforest") --

		-- table.insert(level.tasks, "Mpainted_sands")  --废铁机器人和铁矿区, 有cave_entrance_roc，但是太大了
		-- table.insert(level.tasks, "MEdge_of_civilization") --城郊地区
		-- table.insert(level.tasks, "MDeep_rainforest_mandrake")
		-- table.insert(level.tasks, "MDeep_lost_ruins_gas") --毒气森林 有entrance_6
		-- -- -- table.insert(level.tasks, "MEdge_of_the_unknown_2") --这个的地形和其他地形高度重复
		-- table.insert(level.tasks, "MDeep_rainforest_2") ----有荨麻，遗迹入口  entrance_5

		-- -- -- table.insert(level.tasks, "M_BLANK2")       --这是个空的
		-- table.insert(level.tasks, "Edge_of_the_unknownC") --pugalisk_fountain 蛇岛

		-- table.insert(level.tasks, "MPigcity")
		-- table.insert(level.tasks, "MPigcityside1")
		-- table.insert(level.tasks, "MPigcityside2")
		-- table.insert(level.tasks, "MPigcityside3")
		-- table.insert(level.tasks, "MPigcityside4")

		-- table.insert(level.tasks, "M_BLANK1")
		-- table.insert(level.tasks, "MPigcity2")
		-- table.insert(level.tasks, "MPigcity2side1")
		-- table.insert(level.tasks, "MPigcity2side2")
		-- table.insert(level.tasks, "MPigcity2side3")
		-- table.insert(level.tasks, "MPigcity2side4")
		-- table.insert(level.tasks, "MDeep_rainforest_3")

		-- table.insert(level.tasks, "pincale")




		-- table.insert(level.tasks, "A_MISTO6") --火山矿区
		-- table.insert(level.tasks, "A_MISTO7") --野猪王
		-- table.insert(level.tasks, "A_MISTO8") --火山矿
		-- table.insert(level.tasks, "A_MISTO9") --骷髅岛
		-- table.insert(level.tasks, "A_MISTO11")
		-- table.insert(level.tasks, "A_MISTO14")
		-- table.insert(level.tasks, "A_MISTO15")
		-- table.insert(level.tasks, "A_MISTO16")
		-- table.insert(level.tasks, "A_MISTO17")
		-- table.insert(level.tasks, "A_MISTO20")
		-- table.insert(level.tasks, "A_MISTO26")
		-- table.insert(level.tasks, "A_MISTO27")
		-- table.insert(level.tasks, "A_MISTO28")
		-- table.insert(level.tasks, "A_MISTO38")
		-- table.insert(level.tasks, "A_MISTO39")
		-- table.insert(level.tasks, "A_MISTO43")
		-- table.insert(level.tasks, "A_MISTO45")
		-- table.insert(level.tasks, "A_MISTO50")
		-- table.insert(level.tasks, "A_MISTO51")
		-- table.insert(level.tasks, "A_BLANK1")
		-- table.insert(level.tasks, "A_BLANK2")
		-- table.insert(level.tasks, "A_BLANK3")
		-- table.insert(level.tasks, "A_BLANK4")
		-- table.insert(level.tasks, "A_BLANK5")
		-- table.insert(level.tasks, "A_BLANK6")
		-- table.insert(level.tasks, "A_BLANK7")
		-- table.insert(level.tasks, "A_BLANK8")
		-- table.insert(level.tasks, "A_BLANK9")
		-- table.insert(level.tasks, "A_BLANK10")
		-- table.insert(level.tasks, "A_BLANK11")
		-- table.insert(level.tasks, "A_BLANK12")


		-- table.insert(level.tasks, "Dig that rock")
		-- table.insert(level.tasks, "Great Plains")
		-- table.insert(level.tasks, "Squeltch")
		-- table.insert(level.tasks, "Beeeees!")
		-- table.insert(level.tasks, "Speak to the king")
		-- table.insert(level.tasks, "Forest hunters")
		-- table.insert(level.tasks, "Badlands")
		-- table.insert(level.tasks, "For a nice walk")
		-- table.insert(level.tasks, "Lightning Bluff")

		-- table.insert(level.tasks, "MoonIsland_IslandShards")
		-- table.insert(level.tasks, "MoonIsland_Beach")
		-- table.insert(level.tasks, "MoonIsland_Forest")
		-- table.insert(level.tasks, "MoonIsland_Baths")
		-- table.insert(level.tasks, "MoonIsland_Mine")

		-- level.ocean_prefill_setpieces["coralpool1"] = { count = 3 }
		-- level.ocean_prefill_setpieces["coralpool2"] = { count = 3 }
		-- level.ocean_prefill_setpieces["coralpool3"] = { count = 2 }
		-- level.ocean_prefill_setpieces["octopuskinghome"] = { count = 1 }
		-- level.ocean_prefill_setpieces["mangrove1"] = { count = 2 }
		-- level.ocean_prefill_setpieces["mangrove2"] = { count = 1 }
		-- level.ocean_prefill_setpieces["wreck"] = { count = 1 }
		-- level.ocean_prefill_setpieces["wreck2"] = { count = 1 }
		-- level.ocean_prefill_setpieces["kraken"] = { count = 1 }
		-- level.ocean_prefill_setpieces["quagmire_kitchen"] = { count = 1}	
	end
end

AddLevelPreInitAny(LevelPreInit)
