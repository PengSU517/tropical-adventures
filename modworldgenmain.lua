GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
local require = GLOBAL.require
require("tools/table") ----一些表相关的工具函数


GLOBAL.TA_CONFIG = {

    language = GetModConfigData("language"),


    rog         = GetModConfigData("rog"),
    shipwrecked = GetModConfigData("shipwrecked"),
    hamlet      = GetModConfigData("hamlet"),


    ocean             = GetModConfigData("ocean"),
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


    testmode   = GetModConfigData("testmode"),
    prefabname = GetModConfigData("prefabname"),
    seafork    = GetModConfigData("seafork"),
}

TA_CONFIG.sw_start = TA_CONFIG.shipwrecked and (TA_CONFIG.multiplayerportal == "shipwrecked")
TA_CONFIG.ham_start = TA_CONFIG.hamlet and (TA_CONFIG.multiplayerportal == "hamlet")
TA_CONFIG.together_not_mainland = (TA_CONFIG.sw_start or TA_CONFIG.ham_start)
TA_CONFIG.together = not ((not TA_CONFIG.rog) and TA_CONFIG.together_not_mainland)


GLOBAL.TUNING.tropical = GLOBAL.TA_CONFIG -------------复制一份方便调用--------------


modimport("main/tiledefs") ------------缺少行走的声音

require("constants")
require("map/rooms")
require("map/tasks")
require("map/tro_lockandkey")
require("map/ocean_gen_new") ----防止新的水面地皮被覆盖



-- modimport("scripts/tools/util") --------很多参数还没调整
modimport("scripts/tools/spawnutil")


modimport("main/node")                ------------防止清空水上内容
modimport("main/forest_map_postinit") ----防止世界生成难产，但可能会缺失重要地形

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



local troadj = TA_CONFIG
-------------------------调整地图大小和海岸线-------但是用的方法有些暴力-------------------

if GLOBAL.rawget(GLOBAL, "WorldSim") then
    local idx = GLOBAL.getmetatable(GLOBAL.WorldSim).__index

    if (troadj.worldsize ~= "default") or troadj.testmode then
        local size = (troadj.worldsize == "huge" and 450) or (troadj.worldsize == "large" and 400) or 350
        --450是默认边长 --地图太小可能生成不了世界
        local multi = (troadj.together and 1 or 0) + (troadj.shipwrecked and 0.5 or 0) + (troadj.hamlet and 0.5 or 0)
        size = math.max(math.ceil(math.sqrt((size ^ 2) * multi)), 400)
        if troadj.testmode then size = 250 end

        TUNING.WORLD_SIZE_ADJ = size

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

    if troadj.coastline then
        idx.SeparateIslands = function(self) print("不分离土地") end
    end
end



---------------------联机大陆调整--------------------------
if troadj.together == false then
    AddLevelPreInitAny(function(level)
        if level.location == "cave" then
            level.overrides.keep_disconnected_tiles = true

            level.tasks = {}
            level.numoptionaltasks = 0
            level.optionaltasks = {}
            level.set_pieces = {}
        end


        if level.location == "forest" then
            level.tasks = {}
            level.numoptionaltasks = 0
            level.set_pieces = {} --用新的地形但不执行这一行就会报错，因为这是要在特定地形插入彩蛋
            level.overrides = {}
            level.overrides.layout_mode = "LinkNodesByKeys"
            level.required_setpieces = {}

            level.random_set_pieces = {}
            level.ordered_story_setpieces = {}
            level.numrandom_set_pieces = 0

            -- level.ocean_population = nil       --海洋生态 礁石 海带之类的 还有奶奶岛,帝王蟹和猴岛
            -- level.ocean_prefill_setpieces = {} -- 巨树和盐矿的layout

            level.overrides.keep_disconnected_tiles = true
            -- level.overrides.roads = "never"
            -- level.overrides.birds = "never"  --没鸟
            level.overrides.has_ocean = true --没海  ----如果设置了有海的话会清除所有非地面地皮然后根据规则重新生成
            level.required_prefabs = {}      -----这个是为了检测是否有必要的prefabs
        end
    end)
end


if (troadj.together == true) and (troadj.rog == "fixed") then
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

            if troadj.rog == "fixed" then
                table.insert(level.tasks, "Killer bees!")
                table.insert(level.tasks, "The hunters")
                table.insert(level.tasks, "Befriend the pigs")
                table.insert(level.tasks, "Frogs and bugs")
                table.insert(level.tasks, "Kill the spiders")

                -- "Befriend the pigs",
                -- "Kill the spiders",---蜘蛛矿区
                -- "Killer bees!",
                -- "Make a Beehat", ---蜜蜂矿场？
                -- "The hunters",
                -- "Magic meadow", ----有池塘
                -- "Frogs and bugs", --青蛙和蜜蜂？
                -- "Mole Colony Deciduous",---第二桦树林
                -- "Mole Colony Rocks",---大矿区
                -- "MooseBreedingTask",

                -- level.set_pieces["CaveEntrance"] = {
                --     count = 10,
                --     tasks = { "Make a pick",
                --         "Dig that rock",
                --         "Great Plains",
                --         "Squeltch",
                --         "Beeeees!",
                --         "Speak to the king",
                --         "Forest hunters",
                --         "Badlands",
                --         "For a nice walk",
                --         "Lightning Bluff",
                --         "Killer bees!",
                --         "The hunters" }
                -- }
            end
        end
    end)
end


------------------------海难----------------------------
if troadj.shipwrecked then
    AddLevelPreInitAny(function(level)
        if level.location == "forest" then
            table.insert(level.tasks, "HomeIsland")
            table.insert(level.tasks, "RockyGold")       --火山矿区  ["MagmaGold"] = 2,  ["MagmaGoldBoon"] = 1,
            table.insert(level.tasks, "BoreKing")        --野猪王  ["PigVillagesw"] = 1,      ["JungleDenseBerries"] = 1,  ["BeachShark"] = 1,
            table.insert(level.tasks, "RockyTallJungle") --火山矿  ["MagmaTallBird"] = 1,  ["MagmaGoldBoon"] = 1,
            table.insert(level.tasks, "BeachSkull")      --骷髅岛 ["JungleRockSkull"] = 1, random
            table.insert(level.tasks, "MagmaJungle")     -- 猴子 ["MagmaForest"] = 1, -- MR went from 1-3    ["JungleDense"] = 1,    ["JunglePigs"] = 1,没有猪

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
            table.insert(level.tasks, "Volcano ground")  --火山  ["VolcanoAsh"] = 1,       ["Volcano"] = 1,    ["VolcanoObsidian"] = 1,

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

            table.insert(level.ocean_population, "OceanBrinepool")

            -- if not level.ocean_prefill_setpieces then
            --     level.ocean_prefill_setpieces = {}
            -- end

            -- level.ocean_prefill_setpieces["coralpool1"] = 3
            -- level.ocean_prefill_setpieces["coralpool2"] = 3
            -- level.ocean_prefill_setpieces["coralpool3"] = 2
            -- level.ocean_prefill_setpieces["octopuskinghome"] = 1
            -- level.ocean_prefill_setpieces["mangrove1"] = 2
            -- level.ocean_prefill_setpieces["mangrove2"] = 1
            -- level.ocean_prefill_setpieces["wreck"] = 1
            -- level.ocean_prefill_setpieces["wreck2"] = 1
            -- level.ocean_prefill_setpieces["kraken"] = 1
        elseif level.location == "cave" then
            table.insert(level.tasks, "Volcano entrance")
            table.insert(level.tasks, "Volcano")
            table.insert(level.tasks, "Volcano inner")
        end
    end)
end

-----------------哈姆雷特-------------------------------------
if troadj.hamlet then
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

-- -----------------------出生地调整-----------------------------
-- if troadj.multiplayerportal == "shipwrecked" and troadj.shipwrecked then
--     AddLevelPreInitAny(function(level)
--         if level.location == "forest" then
--             table.insert(level.tasks, "HomeIsland_start")
--             level.overrides.start_location = "NewStart"
--         end
--     end)
-- elseif troadj.multiplayerportal == "hamlet" and troadj.hamlet then
--     AddLevelPreInitAny(function(level)
--         if level.location == "forest" then
--             table.insert(level.tasks, "Plains_start")
--             level.overrides.start_location = "NewStart"
--         end
--     end)
-- end

-----------------------出生地调整-----------------------------
if troadj.multiplayerportal == "shipwrecked" and troadj.shipwrecked then
    AddLevelPreInitAny(function(level)
        if level.location == "forest" then
            -- table.insert(level.tasks, "HomeIsland_start")
            level.overrides.start_location = "SWStart"
            level.valid_start_tasks = { "HomeIsland" }
        elseif level.location == "cave" and (not troadj.together) then
            -- table.insert(level.tasks, "Plains_start")
            -- level.overrides.start_location = "HamStart"
            level.valid_start_tasks = { "Volcano entrance" }
        end
    end)
elseif troadj.multiplayerportal == "hamlet" and troadj.hamlet then
    AddLevelPreInitAny(function(level)
        if level.location == "forest" then
            -- table.insert(level.tasks, "Plains_start")
            level.overrides.start_location = "HamStart"
            level.valid_start_tasks = { "Plains" }
        elseif level.location == "cave" and (not troadj.together) then
            -- table.insert(level.tasks, "Plains_start")
            -- level.overrides.start_location = "HamStart"
            level.valid_start_tasks = { "HamMudWorld" }
        end
    end)
end


--------------------layout生成调整--------------------------------

if troadj.together then
    AddLevelPreInitAny(function(level)
        if level.location == "forest" then
            local taskrog = { "Squeltch", "Speak to the king", "Forest hunters", "Badlands", "For a nice walk",
                "Dig that rock", "Great Plains" }
            -----调整三基佬位置，只刷新在主大陆
            ------------"Sculptures_1" "Maxwell5" 是通过这个实现的 -----------------雕像零件似乎是生成好世界之后再生成的
            level.required_setpieces = {}
            level.set_pieces["Sculptures_1"] = { count = 1, tasks = taskrog }
            level.set_pieces["Sculptures_" .. math.random(2, 5)] = { count = 1, tasks = taskrog }
            level.set_pieces["Maxwell5"] = { count = 1, tasks = taskrog }
            level.set_pieces["Maxwell" .. math.random(1, 4)] = { count = 1, tasks = taskrog }



            level.random_set_pieces = {}
            level.ordered_story_setpieces = {}
            level.numrandom_set_pieces = 0

            ----------泰拉瑞亚
            level.overrides.terrariumchest = "never"
            local terra = {
                [1] = "Terrarium_Forest_Spiders",
                [2] = "Terrarium_Forest_Pigs",
                [3] = "Terrarium_Forest_Fire"
            }
            level.set_pieces[terra[math.random(1, 3)]] = { count = 1, tasks = taskrog }

            ---------舞台剧
            level.overrides.stageplays = "never"
            level.set_pieces["Charlie1"] = { count = 1, tasks = taskrog }
            level.set_pieces["Charlie2"] = { count = 1, tasks = taskrog }
        end
    end)
end

-----------海上布景---------------会显著加快地形生成
if true then
    AddLevelPreInitAny(function(level)
        if level.location == "forest" then
            if not level.ocean_prefill_setpieces then
                level.ocean_prefill_setpieces = {}
            end

            level.ocean_prefill_setpieces["MonkeyIsland"] = 1
            level.ocean_prefill_setpieces["HermitcrabIsland"] = 1
            level.ocean_prefill_setpieces["CrabKing"] = 1
        end
    end)

    AddRoomPreInit("OceanRough", function(room)
        room.required_prefabs = {}
        room.contents.countstaticlayouts = {} ---delete  ["HermitcrabIsland"] = 1, 	["MonkeyIsland"] = 1,
    end)

    AddRoomPreInit("OceanSwell", function(room)
        room.required_prefabs = {}
        room.contents.countstaticlayouts = {} ---- delete ["CrabKing"] = 1
    end)
end


------------------------热带海域----------------------------
if troadj.ocean == "tropical" then
    require("map/ocean_gen_tropical")
    AddLevelPreInitAny(function(level)
        if level.location == "forest" then
            TABLE.insert(level.ocean_population, {
                "WaterShallowShore",
                "WaterShallow",
                "WaterMedium",
                "WaterDeep",
                "WaterCoral",
                "WaterShipGraveyard",
            })

            TABLE.remove(level.ocean_population, {
                "OceanCoastalShore",
                "OceanCoastal",
                "OceanSwell",
                "OceanRough",
                "OceanHazardous",
            })
        end
    end)
elseif troadj.ocean == "default" then
    AddLevelPreInitAny(function(level)
        if level.location == "forest" then
            TABLE.insert(level.ocean_population, {
                "OceanBrinepool",
            })
        end
    end)
end

---------------------测试模式------------
if troadj.testmode then
    AddLevelPreInitAny(function(level)
        if level.location == "cave" then
            level.overrides.keep_disconnected_tiles = true

            level.tasks = { "MudWorld", "CaveExitTask1" }
            table.insert(level.tasks, "HamArchiveMaze")
            level.numoptionaltasks = 0
            level.optionaltasks = {}

            level.set_pieces = {}
        end


        if level.location == "forest" then
            level.tasks = { "Make a NewPick" }
            -- table.insert(level.tasks, "Kill the spiders")
            table.insert(level.tasks, "Pincale")
            -- table.insert(level.tasks, "Verdent")
            -- table.insert(level.tasks, "Plains_start")
            table.insert(level.tasks, "Plains") --island3 高草地形，类似牛场
            -- table.insert(level.tasks, "Rainforest_ruins")
            -- table.insert(level.tasks, "Deep_rainforest") ----有蚁穴
            -- table.insert(level.tasks, "Edge_of_the_unknown")
            table.insert(level.tasks, "Pigcity2")
            -- table.insert(level.tasks, "HamArchiveMaze")
            level.numoptionaltasks = 0

            --[[optionaltasks = {
                "Befriend the pigs",
                "Kill the spiders",---蜘蛛矿区
                "Killer bees!",
                "Make a Beehat", ---蜜蜂矿场？
                "The hunters",
                "Magic meadow", ----有池塘
                "Frogs and bugs", --青蛙和蜜蜂？
                "Mole Colony Deciduous",---第二桦树林
                "Mole Colony Rocks",---大矿区
                "MooseBreedingTask",
            }]]



            level.set_pieces = {} --用新的地形但不执行这一行就会报错，因为这是要在特定地形插入彩蛋
            level.set_pieces["CaveEntrance"] = { count = 1, tasks = { "Make a NewPick" } }
            level.overrides = {}
            level.overrides.layout_mode = "LinkNodesByKeys"
            level.required_setpieces = {}

            level.random_set_pieces = {}
            level.ordered_story_setpieces = {}
            level.numrandom_set_pieces = 0

            -- level.ocean_population = nil       --海洋生态 礁石 海带之类的 还有奶奶岛,帝王蟹和猴岛
            -- level.ocean_prefill_setpieces = {} -- 巨树和盐矿的layout

            level.overrides.keep_disconnected_tiles = true
            level.overrides.roads = "never"
            level.overrides.birds = "never"  --没鸟
            level.overrides.has_ocean = true --没海  ----如果设置了有海的话会清除所有非地面地皮然后根据规则重新生成
            level.required_prefabs = {}      -----这个是为了检测是否有必要的prefabs
        end
    end)
end
