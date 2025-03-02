GLOBAL.TA_CONFIG = {}

local world_overrides
if rawget(_G, "GEN_PARAMETERS") then
    require("json")
    local world_gen_data = json.decode(rawget(_G, "GEN_PARAMETERS"))
    world_overrides = deepcopy(world_gen_data.level_data.overrides)
end

if world_overrides then
    print("Re-update world settings in modworldgenmain")
    for i, v in pairs(world_overrides) do
        print((tostring(i) or "nil") .. ":        " .. (tostring(v) or "nil"))
    end
end

local addconfig = function(tbl, options)
    for i, v in ipairs(options) do
        tbl[v.name] = world_overrides and world_overrides[v.name] or GetModConfigData(v.name) or v.default
        if tbl[v.name] == "disabled" then ----如果是禁用，则设置为false
            tbl[v.name] = false
        end
    end
end


----configurations-----------
TA_CONFIG.WORLDGEN = {}
TA_CONFIG.CLIMATE = {}
TA_CONFIG.CLIENT = {}
TA_CONFIG.DEVELOP = {}

addconfig(TA_CONFIG.WORLDGEN, worldgen_options)
addconfig(TA_CONFIG.CLIMATE, climate_options)
addconfig(TA_CONFIG.CLIENT, client_options)
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
        print(i .. " is already defined in TUNING")
    else
        TUNING[i] = v
        print(i .. " is added to TUNING" .. ":" .. tostring(v))
    end
end

for _, module in pairs(TA_CONFIG) do
    for k, v in pairs(module) do
        addtuning(k, v)
    end
end
