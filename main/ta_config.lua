GLOBAL.TA_CONFIG = {}

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
end

-----相关内容迁移到了 "tools/configutil",因为需要复用
AddConfigAndTuning(TA_CONFIG, world_overrides)
