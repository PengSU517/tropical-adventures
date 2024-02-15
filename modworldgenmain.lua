----------------------海洋之椅，火山祭坛

-------------洞穴的掉落物会落入水中
------------漂流瓶显示宝藏没有标记
-----------雨林的小地图贴图不对
-----------relic太少了
----------------栽种房子的时候有bug------------已解决
-------------不要把东西给房子--------------已解决
---------------浮木舟不掉耐久
----------------大鸟地区不该加Hamlet标签 roc的SG也没写好
-------------waffles_plate缺少贴图







GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
local require = GLOBAL.require


GLOBAL.TUNING.tropical = {

    language = GetModConfigData("language"),


    together          = GetModConfigData("together"),
    shipwrecked       = GetModConfigData("shipwrecked"),
    hamlet            = GetModConfigData("hamlet"),

    multiplayerportal = GetModConfigData("startlocation"),
    startlocation     = GetModConfigData("startlocation"),

    coastline         = GetModConfigData("coastline"),
    layout            = GetModConfigData("layout"),
    testmode          = GetModConfigData("testmode"),

    springflood       = false, ---GetModConfigData("flood"),
    wind              = GetModConfigData("wind"),
    hail              = GetModConfigData("hail"),
    volcaniceruption  = false, ------GetModConfigData("volcaniceruption"),

    fog               = false, ----GetModConfigData("fog"),
    hayfever          = false, ----GetModConfigData("hayfever"),
    aporkalypse       = false, ----GetModConfigData("aporkalypse"),
    -- tropicalshards    = false, ----GetModConfigData("tropicalshards"),  ------------删掉所有用到的地方
    -- removedark        = false, ----GetModConfigData("removedark"),-----------只在underwater用到
    -- hamworld          = false, ----GetModConfigData("kindofworld"),  没用上
    -- bramble           = false, ----GetModConfigData("bramble"), ----荆棘藤蔓，但似乎实现不怎么样   没用上
    -- roc               = true, ----GetModConfigData("roc"),   没用上
    -- sealnado          = true, ----GetModConfigData("sealnado"),--------------parrotspawner里很多东西很奇怪
    -- greenmod                     = GLOBAL.KnownModIndex:IsModEnabled("workshop-1418878027"),

    waves             = true, ----GetModConfigData("Waves"),
    -- kindofworld       = 15,    ------GetModConfigData("kindofworld"),
    -- forge             = false, ----GetModConfigData("forge"),
    disembarkation    = false, -----GetModConfigData("automatic_disembarkation"),------------自动离开船
    bosslife          = 1,     --------GetModConfigData("bosslife"),
    prefabname        = GetModConfigData("prefabname"),
}

local troadv = GLOBAL.TUNING.tropical





-- require("globalfuncs")
require("constants")
require("map/rooms")
require("map/tasks")
require("map/tro_lockandkey")
require("map/ocean_gen_new") ----防止新的水面地皮被覆盖


modimport("main/tiledefs") ------------缺少行走的声音
modimport("main/node")
-- modimport("main/forest_map_postinit") ----防止世界生成难产，但可能会缺失重要地形

----------新内容
modimport("scripts/init_static_layouts") --add new static layouts
modimport("scripts/map/rooms/ham")
modimport("scripts/map/rooms/sw")
modimport("scripts/map/rooms/ocean")
modimport("scripts/map/rooms/unknown")
modimport("scripts/map/tasks/ham")
modimport("scripts/map/tasks/sw")
modimport("scripts/map/newstartlocation")

-------------修改之前内容
modimport("postinit/map/storygen")
modimport("postinit/map/rooms")
modimport("postinit/map/tasks")



-------------------------调整地图大小和海岸线--------------------------
-- local size = 400
local size = 400 + (troadv.shipwrecked and 100 or 0) + (troadv.hamlet and 100 or 0) +
    (troadv.together == "default" and 50 or 0)
--450是默认边长 --地图太小可能生成不了世界

if troadv.testmode then size = 150 end

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

    if troadv.coastline then
        idx.SeparateIslands = function(self) print("不分离土地") end
    end
end



---------------------联机大陆调整--------------------------

if (troadv.together == "no_random") or (troadv.together == "bee_and_walrus") then
    AddLevelPreInitAny(function(level)
        if level.location == "cave" then
            -- level.overrides.keep_disconnected_tiles = true
            level.numoptionaltasks = 0
            level.optionaltasks = {}
            ------------caveexit也要减少
        end

        if level.location == "forest" then
            level.numoptionaltasks = 0
            level.optionaltasks = {}

            if troadv.together == "bee_and_walrus" then
                table.insert(level.tasks, "Killer bees!")
                table.insert(level.tasks, "The hunters")

                level.set_pieces["CaveEntrance"] = {
                    count = 10,
                    tasks = { "Make a pick",
                        "Dig that rock",
                        "Great Plains",
                        "Squeltch",
                        "Beeeees!",
                        "Speak to the king",
                        "Forest hunters",
                        "Badlands",
                        "For a nice walk",
                        "Lightning Bluff",
                        "Killer bees!",
                        "The hunters" }
                }
            end
        end
    end)
end


------------------------海难----------------------------
if troadv.shipwrecked then
    AddLevelPreInitAny(function(level)
        if level.location == "forest" then
            table.insert(level.tasks, "RockyGold")       --火山矿区  ["MagmaGold"] = 2,  ["MagmaGoldBoon"] = 1,
            table.insert(level.tasks, "BoreKing")        --野猪王  ["PigVillagesw"] = 1,      ["JungleDenseBerries"] = 1,  ["BeachShark"] = 1,
            table.insert(level.tasks, "RockyTallJungle") --火山矿  ["MagmaTallBird"] = 1,  ["MagmaGoldBoon"] = 1,
            table.insert(level.tasks, "BeachSkull")      --骷髅岛 ["JungleRockSkull"] = 1, random
            table.insert(level.tasks, "MagmaJungle")     -- 猴子 ["MagmaForest"] = 1, -- MR went from 1-3    ["JungleDense"] = 1,    ["JunglePigs"] = 1,没有猪
            table.insert(level.tasks, "Volcano")         --火山  ["VolcanoAsh"] = 1,       ["Volcano"] = 1,    ["VolcanoObsidian"] = 1,
            table.insert(level.tasks, "JungleMarshy")    --热带沼泽和沙滩
            table.insert(level.tasks, "JungleBushy")     --沙滩和丛林，纯随机
            table.insert(level.tasks, "JungleBeachy")    --热带丛林+纯随机
            table.insert(level.tasks, "JungleMonkey")    --猴子  ["JungleMonkeyHell"] = 2,
            table.insert(level.tasks, "BeachMarshy")     --纯随机 沙滩和沼泽
            table.insert(level.tasks, "MoonRocky")       --月石矿
            table.insert(level.tasks, "TigerSharky")     --虎鲨+沼泽+丛林   required_prefabs = { "tigersharkpool" },好奇怪
            table.insert(level.tasks, "Verdent")         --绿草地  ["Beaverkinghome"] = 1,    ["Beaverkingcity"] = 1, beaver是什么东西
            table.insert(level.tasks, "Casino")          --["BeachPalmCasino"] = 1, 抽奖机
            table.insert(level.tasks, "BeachBeachy")     --随机  [salasbeach[math.random(1, 24)]] = 1,  ["BeachShark"] = 1,又是啥玩意
            table.insert(level.tasks, "BeachPiggy")      --猪人沙滩
            table.insert(level.tasks, "DoyDoyM")         ---doydoyM
            table.insert(level.tasks, "DoyDoyF")         ---doydoyF

            table.insert(level.tasks, "A_BLANK1")
            table.insert(level.tasks, "A_BLANK2")
            table.insert(level.tasks, "A_BLANK3")
            table.insert(level.tasks, "A_BLANK4")
            table.insert(level.tasks, "A_BLANK5")
            table.insert(level.tasks, "A_BLANK6")
            table.insert(level.tasks, "A_BLANK7")
            table.insert(level.tasks, "A_BLANK8")
            table.insert(level.tasks, "A_BLANK9")
            table.insert(level.tasks, "A_BLANK10")
            table.insert(level.tasks, "A_BLANK11")
            table.insert(level.tasks, "A_BLANK12")

            level.ocean_prefill_setpieces["coralpool1"] = 3
            level.ocean_prefill_setpieces["coralpool2"] = 3
            level.ocean_prefill_setpieces["coralpool3"] = 2
            level.ocean_prefill_setpieces["octopuskinghome"] = 1
            level.ocean_prefill_setpieces["mangrove1"] = 2
            level.ocean_prefill_setpieces["mangrove2"] = 1
            level.ocean_prefill_setpieces["wreck"] = 1
            level.ocean_prefill_setpieces["wreck2"] = 1
            level.ocean_prefill_setpieces["kraken"] = 1
        end
    end)
end

-----------------哈姆雷特-------------------------------------
if troadv.hamlet then
    AddLevelPreInitAny(function(level)
        if level.location == "cave" then
            table.insert(level.tasks, "HamMudWorld")   ---地下版的出生地，但是爪树 "HamLightPlantFieldexit"--exit1 "HamArchiveMaze"
            table.insert(level.tasks, "HamRockyLand")  --"HamBatsAndRocky"有蚁后
            table.insert(level.tasks, "HamMudCave")    --同质化严重  "HamMudWithRabbitexit" 有exit2
            table.insert(level.tasks, "HamBigBatCave") ----exit3
            table.insert(level.tasks, "HamArchiveMaze")
        end

        if level.location == "forest" then
            table.insert(level.tasks, "Plains")               --island3 高草地形，类似牛场
            table.insert(level.tasks, "Rainforest_ruins")
            table.insert(level.tasks, "Painted_sands")        --废铁机器人和铁矿区, 有cave_entrance_roc，但是太大了
            table.insert(level.tasks, "Deep_rainforest")      ----有蚁穴

            table.insert(level.tasks, "Edge_of_civilization") --城郊地区
            table.insert(level.tasks, "Pigcity")

            table.insert(level.tasks, "Pigcity2")
            table.insert(level.tasks, "Deep_rainforest_2")   ----有荨麻，遗迹入口  entrance_5  --并入曼达拉

            table.insert(level.tasks, "Edge_of_the_unknown") --pugalisk_fountain 蛇岛 ---大鸟岛入口？vampirebatcave_entrance_roc
            table.insert(level.tasks, "Deep_rainforest_3")
            table.insert(level.tasks, "Deep_lost_ruins_gas") --毒气森林 有entrance_6

            table.insert(level.tasks, "Pincale")

            level.set_pieces["cave_entranceham1"] = { count = 1, tasks = { "Deep_rainforest" } }
            level.set_pieces["cave_entranceham2"] = { count = 1, tasks = { "Deep_rainforest_2" } }
            level.set_pieces["cave_entranceham3"] = { count = 1, tasks = { "Deep_lost_ruins_gas" } }
        end
    end)
end

-----------------------出生地调整-----------------------------
if troadv.startlocation == "shipwrecked" and troadv.shipwrecked then
    AddLevelPreInitAny(function(level)
        if level.location == "forest" then
            table.insert(level.tasks, "HomeIsland_start")
            level.overrides.start_location = "NewStart"
        end
    end)
elseif troadv.startlocation == "hamlet" and troadv.hamlet then
    AddLevelPreInitAny(function(level)
        if level.location == "forest" then
            table.insert(level.tasks, "Plains_start")
            level.overrides.start_location = "NewStart"
        end
    end)
end


--------------------layout生成调整--------------------------------

if troadv.layout then
    -----调整三基佬位置，只刷新在主大陆
    AddLevelPreInitAny(function(level)
        if level.location == "forest" then
            level.required_setpieces = {} ------------"Sculptures_1" "Maxwell5" 是通过这个实现的 雕像零件也是
            -----------------雕像零件似乎是生成好世界之后再生成的

            local taskrog = { "Squeltch", "Speak to the king", "Forest hunters", "Badlands", "For a nice walk" }
            level.set_pieces["Sculptures_1"] = { count = 1, tasks = taskrog }
            level.set_pieces["Maxwell5"] = { count = 1, tasks = taskrog }

            -- level.set_pieces["MonkeyIsland"] = { count = 1, tasks = { "A_BLANK12" } }
            level.random_set_pieces = {}
            level.ordered_story_setpieces = {}
            level.numrandom_set_pieces = 0
            -- level.overrides.terrariumchest = "never" ----------泰拉瑞亚
            -- level.overrides.stageplays = "never"     ---------舞台剧
        end
    end)

    -- AddRoomPreInit("OceanRough", function(room)
    --     room.required_prefabs = {}
    --     room.contents.countstaticlayouts = {} ---delete  ["HermitcrabIsland"] = 1, 	["MonkeyIsland"] = 1,
    -- end)

    -- AddRoomPreInit("OceanSwell", function(room)
    --     room.required_prefabs = {}
    --     room.contents.countstaticlayouts = {} ---- delete ["CrabKing"] = 1
    -- end)
end



if troadv.testmode then
    AddLevelPreInitAny(function(level)
        if level.location == "cave" then
            level.overrides.keep_disconnected_tiles = true

            level.tasks = { "MudWorld", "CaveExitTask1" }
            level.numoptionaltasks = 0
            level.optionaltasks = {}

            level.set_pieces = {}
        end


        if level.location == "forest" then
            level.tasks = { "Make a NewPick" }
            table.insert(level.tasks, "Pincale")
            table.insert(level.tasks, "Verdent")
            level.numoptionaltasks = 0

            level.set_pieces = {} --用新的地形但不执行这一行就会报错，因为这是要在特定地形插入彩蛋
            level.set_pieces["CaveEntrance"] = { count = 1, tasks = { "Make a NewPick" } }
            level.overrides = {}
            level.overrides.layout_mode = "LinkNodesByKeys"
            level.required_setpieces = {}

            level.random_set_pieces = {}
            level.ordered_story_setpieces = {}
            level.numrandom_set_pieces = 0

            level.ocean_population = nil       --海洋生态 礁石 海带之类的 还有奶奶岛,帝王蟹和猴岛
            level.ocean_prefill_setpieces = {} -- 巨树和盐矿的layout

            level.overrides.keep_disconnected_tiles = true
            level.overrides.roads = "never"
            level.overrides.birds = "never"  --没鸟
            level.overrides.has_ocean = true --没海  ----如果设置了有海的话会清除所有非地面地皮然后根据规则重新生成
            level.required_prefabs = {}      -----这个是为了检测是否有必要的prefabs
        end
    end)
end
