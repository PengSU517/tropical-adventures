GLOBAL.TA_CONFIG = {}



---这个函数在modmain和非世界生成阶段的modworldgenmain运行正常？，thesim只在modmain存在，还是说只在生成世界之后存在呢
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


    local shardGameIndex = ShardGameIndex -----难道说在客机提取主机配置的时候才需要这个？
    if shardGameIndex then
        print("there is a shardgameindex")
    else
        print("there is no shardgameindex")
        require("shardindex")
        shardGameIndex = ShardIndex()
        shardGameIndex:Load()
    end

    local slot = shardGameIndex:GetSlot()
    local shard = shardGameIndex:GetShard()
    local session_id = shardGameIndex:GetSession()

    print("slot is " .. (slot or "nil"))
    print("shard is " .. (shard or "nil"))
    print("session is " .. (session_id or "nil"))


    if session_id ~= nil and not TheNet:IsDedicated() then ---只有服务器需要这个
        print("TA Mod Loading overrides from shard")
        TheSim:GetPersistentStringInClusterSlot(slot, shard, filename, onload)
    else
        print("TA Mod Loading overrides from here")
        TheSim:GetPersistentString(filename, onload)
    end

    ----还存在的问题是，主客机一体时，生成世界时读取不正确
    -- TheSim:GetPersistentString(filename, onload)
    return savedata
end



local world_overrides
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
else
    local leveldata = ModGetLocalLevelDataOverride() or nil ----在生成世界的时候是没有的，只有重新加载世界时可以
    world_overrides = leveldata and deepcopy(leveldata.overrides) or nil

    if world_overrides then
        print("Update world settings in modworldgenmain with overrides")
    else
        print("Update world settings in modworldgenmain with nothing")
    end
end

local addconfig = function(tbl, options)
    for i, v in ipairs(options) do
        tbl[v.name] = world_overrides and world_overrides[v.name] or tbl[v.name] or
            GetModConfigData(v.name) or v.default

        -- if v.name == "ocean_style" then
        --     print("checck ocean style in worldgen")
        --     print(v.name)
        --     if world_overrides and world_overrides[v.name] then
        --         print("worldoverrides is " .. world_overrides[v.name])
        --     else
        --         print("no worldoverrides here")
        --     end

        --     print("value is " .. tostring(tbl[v.name]))
        -- end


        if tbl[v.name] == "disabled" then ----如果是禁用，则设置为false
            tbl[v.name] = false
        end
    end
end


----configurations-----------
TA_CONFIG.WORLDGEN = {}
TA_CONFIG.CLIMATE = {}
TA_CONFIG.PERSONAL = {}
TA_CONFIG.DEVELOP = {}

addconfig(TA_CONFIG.WORLDGEN, worldgen_options)
addconfig(TA_CONFIG.CLIMATE, climate_options)
addconfig(TA_CONFIG.PERSONAL, personal_options)
addconfig(TA_CONFIG.DEVELOP, developer_options)


TA_CONFIG.DEPENDENCY = {
    ndnr = GLOBAL.KnownModIndex:IsModEnabled("workshop-2823458540"),
}



----configuration adjustments----------
TA_CONFIG.WORLDGEN.sw_start = TA_CONFIG.WORLDGEN.shipwrecked and (TA_CONFIG.WORLDGEN.multiplayerportal == "shipwrecked")
TA_CONFIG.WORLDGEN.ham_start = TA_CONFIG.WORLDGEN.hamlet and (TA_CONFIG.WORLDGEN.multiplayerportal == "hamlet")
TA_CONFIG.WORLDGEN.together_not_mainland = (TA_CONFIG.WORLDGEN.sw_start or TA_CONFIG.WORLDGEN.ham_start)
TA_CONFIG.WORLDGEN.together = not ((not TA_CONFIG.WORLDGEN.rog) and TA_CONFIG.WORLDGEN.together_not_mainland)

TA_CONFIG.CLIMATE.sealnado = TA_CONFIG.CLIMATE.shipwrecked and TA_CONFIG.CLIMATE.sealnado or false
TA_CONFIG.CLIMATE.fog = TA_CONFIG.CLIMATE.hamlet and TA_CONFIG.CLIMATE.fog or false
TA_CONFIG.CLIMATE.hayfever = TA_CONFIG.CLIMATE.hamlet and TA_CONFIG.CLIMATE.hayfever or false
TA_CONFIG.CLIMATE.aporkalypse = TA_CONFIG.CLIMATE.hamlet and TA_CONFIG.CLIMATE.aporkalypse or false
TA_CONFIG.CLIMATE.roc = TA_CONFIG.CLIMATE.hamlet and TA_CONFIG.CLIMATE.roc or false
TA_CONFIG.CLIMATE.bosslife = 1


----将参数加到tuning中---------
local addtuning = function(i, v)
    if TUNING[i] ~= nil then
        -- print(i .. " is already defined in TUNING")
    else
        TUNING[i] = v
        -- print(i .. " is added to TUNING" .. ":" .. tostring(v))
    end
end

for _, module in pairs(TA_CONFIG) do
    for k, v in pairs(module) do
        addtuning(k, v)
    end
end
