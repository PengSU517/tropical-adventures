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

local size = 200 --450是默认边长

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

AddStartLocation("MyNewStart", {
	name = STRINGS.UI.SANDBOXMENU.DEFAULTSTART,
	location = "forest",
	start_setpeice = "newstartlocation", --生成的static layout  --layout太大的话需要设置大小
	start_node = "Clearing",          --"Blank",  --生成位置, 并在包含改room的task新生成一个相同room  blank就是生成在海上
})


-- AddTaskPreInit("Make a pick", function(task)  --将对应的room加入task中，出现这个task时就肯定有这个room出现
-- 	task.room_choices["MAINcity_base_1_set"] = 1 --玫瑰花丛区域会出现在猪王村附近
-- end)


--这里很奇怪，没升级传送门的时候会在原处出生，升级了之后会在默认的出生点出生，太奇怪了
----------------------------------------------------------------------------------

----如何设置地图大小呢


local function LevelPreInit(level)
	if level.location == "cave" then
		level.overrides.keep_disconnected_tiles = true

		-- --if GetModConfigData("hamlet_caves") == 1 then
		-- table.insert(level.tasks, "separahamcave")
		-- table.insert(level.tasks, "HamMudWorld")
		-- table.insert(level.tasks, "HamMudCave")
		-- table.insert(level.tasks, "HamMudLights")
		-- table.insert(level.tasks, "HamMudPit")

		-- table.insert(level.tasks, "HamBigBatCave")
		-- table.insert(level.tasks, "HamRockyLand")
		-- table.insert(level.tasks, "HamRedForest")
		-- table.insert(level.tasks, "HamGreenForest")
		-- table.insert(level.tasks, "HamBlueForest")
		-- table.insert(level.tasks, "HamSpillagmiteCaverns")
		-- table.insert(level.tasks, "HamSpillagmiteCaverns1")
		-- table.insert(level.tasks, "caveruinsexit")
		-- table.insert(level.tasks, "caveruinsexit2")

		-- table.insert(level.tasks, "HamMoonCaveForest")
		-- table.insert(level.tasks, "HamArchiveMaze")
		-- --end

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
		-- level.tasks = { "Make a pick", "MoonIsland_Beach" }
		level.ocean_population = {}  --海洋生态 礁石 海带之类的 只执行这一行的时候只会出现盐矿和巨树, 也就是说删除了奶奶岛 和猴岛？ 这代码逻辑太奇怪了
		level.ocean_prefill_setpieces = {} --海洋奇遇 特指奶奶岛之类的  执行这一行时有礁石，奶奶岛和猴岛
		-- level.ocean_prefill_setpieces["newstartlocation2"] = 1 --额外添加一个奶奶岛  在不执行前一行的时候时可运行的
		level.tasks = { "Make a pick", "Dig that rock" }
		-- table.insert(level.tasks, "Speak to the newking")
		--不能加make a new pick 因为也是lock.none， 但是为什么加新的月岛task也报错
		--设置地形后就会报错，好奇怪啊

		level.numoptionaltasks = 0
		level.optionaltasks = {}
		-- level.valid_start_tasks = "Speak to the newking" --nil  --可以通过修改start taks修改出生门位置 设置了这一条override就没用了吧
		-- 指定了猪王地区也没用，出生地只会设置在lock.none的task
		level.set_pieces = {} --用新的地形但不执行这一行就会报错，因为这是要在特定地形插入彩蛋
		-- level.set_pieces["newstartlocation2"] = { count = 1, tasks = { "Dig that rock" } }
		--即使加上这一行也会刷新泰拉瑞亚
		level.random_set_pieces = {}
		level.ordered_story_setpieces = {}
		level.numrandom_set_pieces = 0
		--如果执行了以上四行和AddTaskSetPreInit那就生成不了世界



		level.overrides.start_location = "MyNewStart"
		-- --似乎出生点只能设置在 LOCKS.NONE的区域
		-- --也可以通过插入一个 start location 确定出生门位置 似乎只是在出生地位置加入一个想要的地形，而不是搜寻相应的地形加入一个出生大门
		level.overrides.keep_disconnected_tiles = true
		level.overrides.roads = "never"
		level.overrides.birds = "never" --没鸟
		level.overrides.has_ocean = true --false	--没海
		level.required_prefabs = {} --温蒂更新后的修复

		--if GetModConfigData("Hamlet") == 10 then
		-- table.insert(level.tasks, "Deep_rainforest_2") --hamlet6
		-- table.insert(level.tasks, "Mplains") --island3
		-- table.insert(level.tasks, "Mplains_ruins") --island3
		-- -- table.insert(level.tasks, "MDeep_rainforest") --
		-- table.insert(level.tasks, "Mpainted_sands")
		-- table.insert(level.tasks, "MEdge_of_civilization")
		-- table.insert(level.tasks, "MDeep_rainforest_mandrake")
		-- table.insert(level.tasks, "Mrainforest_ruins")
		-- -- table.insert(level.tasks, "MDeep_lost_ruins_gas") --
		-- table.insert(level.tasks, "MEdge_of_the_unknown_2")
		-- table.insert(level.tasks, "MDeep_rainforest_2")

		-- table.insert(level.tasks, "M_BLANK2")
		-- table.insert(level.tasks, "Edge_of_the_unknownC") --pugalisk_fountain 蛇岛
		-- -- --end
		-- -- level.set_pieces["newstartlocation2"] = { count = 1, tasks = { "Mplains" } }
		level.set_pieces["cidade1"] = { count = 1, tasks = { "Make a pick" } }
		-- --layout的地皮配置有问题
		-- -- ------------continent----------------------
		-- -- --if GetModConfigData("pigcity1") == 15 then
		-- table.insert(level.tasks, "MPigcity") --猪镇的地皮生成有问题
		-- table.insert(level.tasks, "MPigcityside1")
		-- table.insert(level.tasks, "MPigcityside2")
		-- table.insert(level.tasks, "MPigcityside3")
		-- table.insert(level.tasks, "MPigcityside4")
		-- -- --end

		-- -- ------------continent----------------------
		-- -- --if GetModConfigData("pigcity2") == 15 then
		-- -- table.insert(level.tasks, "M_BLANK1")
		-- -- -- table.insert(level.tasks, "MDeep_rainforestC")--这里面有个pigcity
		-- table.insert(level.tasks, "MPigcity2")
		-- table.insert(level.tasks, "MPigcity2side1")
		-- table.insert(level.tasks, "MPigcity2side2")
		-- table.insert(level.tasks, "MPigcity2side3")
		-- table.insert(level.tasks, "MPigcity2side4")
		-- table.insert(level.tasks, "MDeep_rainforest_3")
		-- --end

		-- --if GetModConfigData("pinacle") == 1 then
		-- table.insert(level.tasks, "pincale")
		--end

		-- --if GetModConfigData("Shipwrecked") == 25 then
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

		-- level.set_pieces["coralpool1"] = { count = 1, tasks = { "Dig that rock" } }
		--需要找到合适的地形插入这些
		-- --end

		-- --if GetModConfigData("Together") == 20 then
		-- table.insert(level.tasks, "Dig that rock")
		-- table.insert(level.tasks, "Great Plains")
		-- table.insert(level.tasks, "Squeltch")
		-- table.insert(level.tasks, "Beeeees!")
		-- table.insert(level.tasks, "Speak to the king")
		-- table.insert(level.tasks, "Forest hunters")
		-- table.insert(level.tasks, "Badlands")
		-- table.insert(level.tasks, "For a nice walk")
		-- table.insert(level.tasks, "Lightning Bluff")
		-- -- --end

		-- -- -------------------------

		-- -- --if GetModConfigData("Moon") == 10 then
		-- table.insert(level.tasks, "MoonIsland_IslandShards")
		-- table.insert(level.tasks, "MoonIsland_Beach")
		-- table.insert(level.tasks, "MoonIsland_Forest")
		-- table.insert(level.tasks, "MoonIsland_Baths")
		-- table.insert(level.tasks, "MoonIsland_Mine")
		-- --加了月岛会生成不了地形 不太清楚是为什么
		-- --end
		-- -----------------------------------------------a partir daqui modo de jogo 3 ilhas------------------------------------------------------------------------------

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
