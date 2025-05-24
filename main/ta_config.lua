GLOBAL.TA_CONFIG = {}

----这个函数在modmain和非世界生成阶段的modworldgenmain运行正常？，thesim只在modmain存在，还是说只在生成世界之后存在呢
local function ModGetLocalLevelDataOverride()
    print("TA Mod tends to Load Overrides")

    local filename = "../leveldataoverride.lua"
    local success, savedata

    local function onload(load_success, str)
        if load_success == true then
            success, savedata = RunInSandboxSafe(str)
            if success and string.len(str) > 0 then
                print("TA Mod Found a level data override file with these contents:")
                if savedata ~= nil then
                    print("TA Mod Loaded and applied level data override from " .. filename)
                    return
                end
            else
                print("ERROR: Failed to load " .. filename)
            end
        end
        print("Not applying level data overrides.")
    end

    print("TA Mod Loading overrides from here")
    TheSim:GetPersistentString(filename, onload)

    ----还存在的问题是，主客机一体时，生成世界时读取不正确
    -- TheSim:GetPersistentString(filename, onload)
    return savedata
end

local function AddConfigAndTuning(config, source)
    ----将overrides （source）添加到参数中
    local addconfig = function(tbl, source, options, local_config)
        for i, v in ipairs(options) do
            tbl[v.name] = source and source[v.name] or
                GetModConfigData(v.name, local_config) or v.default
            -----这里的优先级顺序一定要注意
            if tbl[v.name] == "disabled" then ----如果是禁用，则设置为false
                tbl[v.name] = false
            end
        end

        return tbl or {}
    end

    ----将参数加到tuning中---------
    local addtuning = function(i, v)
        if TUNING[i] ~= nil then
            print(i .. " is already defined in TUNING" .. ":" .. tostring(v))
            TUNING[i] = v
        else
            print(i .. " is added to TUNING" .. ":" .. tostring(v))
            TUNING[i] = v
        end
    end

    config.WORLDGEN = addconfig({}, source, worldgen_options)
    config.CLIMATE = addconfig({}, source, climate_options)
    config.PERSONAL = addconfig({}, {}, personal_options, true)                       ----这里读取客机配置
    config.DEVELOP = addconfig({}, {}, developer_options)
    config.DEPENDENCY = { ndnr = KnownModIndex:IsModEnabled("workshop-2823458540"), } ----富贵险中求

    ----configuration adjustments----------
    ------worldgen
    config.WORLDGEN.sw_start = config.WORLDGEN.shipwrecked and (config.WORLDGEN.multiplayerportal == "shipwrecked") and
        not config.DEVELOP.test_map
    config.WORLDGEN.ham_start = config.WORLDGEN.hamlet and (config.WORLDGEN.multiplayerportal == "hamlet") and
        not config.DEVELOP.test_map
    config.WORLDGEN.world_size_multi = config.DEVELOP.test_map and 0.25 or config.WORLDGEN.world_size_multi
    config.WORLDGEN.together_not_mainland = (config.WORLDGEN.sw_start or config.WORLDGEN.ham_start)
    config.WORLDGEN.together = not ((not config.WORLDGEN.rog) and config.WORLDGEN.together_not_mainland)

    ------climate
    config.CLIMATE.sealnado = config.WORLDGEN.shipwrecked and config.CLIMATE.sealnado or false
    config.CLIMATE.fog = config.WORLDGEN.hamlet and config.CLIMATE.fog or false
    config.CLIMATE.hayfever = config.WORLDGEN.hamlet and config.CLIMATE.hayfever or false
    config.CLIMATE.aporkalypse = (config.WORLDGEN.hamlet or config.WORLDGEN.ruins) and
        config.CLIMATE.aporkalypse or false
    config.CLIMATE.roc = config.WORLDGEN.hamlet and config.CLIMATE.roc or false
    config.CLIMATE.bosslife = 1

    for _, module in pairs(config) do
        for k, v in pairs(module) do
            addtuning(k, v)
        end
    end
end

local world_overrides
------生成世界时
if rawget(_G, "WorldSim") then
    if rawget(_G, "GEN_PARAMETERS") then
        require("json")
        local world_gen_data = json.decode(rawget(_G, "GEN_PARAMETERS"))
        world_overrides = deepcopy(world_gen_data.level_data.overrides)
    end
    if world_overrides then
        print("Update world settings in modworldgenmain with GEN_PARAMETERS")
        for i, v in pairs(world_overrides) do
            print((tostring(i) or "nil") .. ":        " .. (tostring(v) or "nil"))
        end
    end
end

-----加载世界时
if rawget(_G, "TheSim") then
    local leveldata = ModGetLocalLevelDataOverride() or nil ----在生成世界的时候是没有的，只有重新加载世界时可以
    world_overrides = leveldata and deepcopy(leveldata.overrides) or nil

    if world_overrides then
        print("Update world settings in modworldgenmain with overrides")
        for i, v in pairs(world_overrides) do
            print((tostring(i) or "nil") .. ":        " .. (tostring(v) or "nil"))
        end
    end

    ----客机加载配置
    -----有了这一部分主机会报错是为什么呢，因为生成世界时甚至取不到thenet
    if (not TheNet:IsDedicated()) and GLOBAL.TheWorld ~= nil then
        print("Update world settings in modworldgenmain with TheWorld.topology.overrides")
        world_overrides = TheWorld.topology and TheWorld.topology.overrides

        for i, v in pairs(world_overrides) do
            print((tostring(i) or "nil") .. ":        " .. (tostring(v) or "nil"))
        end
    end
end

-----相关内容迁移到了 "tools/configutil",因为需要复用
AddConfigAndTuning(TA_CONFIG, world_overrides)
