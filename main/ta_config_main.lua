GLOBAL.TA_CONFIG      = TA_CONFIG or {}
local leveldata       = ModGetLevelDataOverride() ----在生成世界的时候是没有的，只有重新加载世界时可以
local world_overrides = leveldata and leveldata.overrides or nil

if world_overrides then
    print("Re-update world settings in modmain")
    for i, v in pairs(world_overrides) do
        print((tostring(i) or "nil") .. ":        " .. (tostring(v) or "nil"))
    end
end

local addconfig = function(tbl, options)
    for i, v in ipairs(options) do
        tbl[v.name] = world_overrides and world_overrides[v.name] or
            tbl[v.name] or GetModConfigData(v.name) or v.default
        if tbl[v.name] == "disabled" then ----如果是禁用，则设置为false
            tbl[v.name] = false
        end
    end
end


----configurations-----------
TA_CONFIG.WORLDGEN = TA_CONFIG.WORLDGEN or {}
TA_CONFIG.CLIMATE = TA_CONFIG.CLIMATE or {}

addconfig(TA_CONFIG.WORLDGEN, worldgen_options)
addconfig(TA_CONFIG.CLIMATE, climate_options)

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
        print(i .. " is already defined in tuning or worldgenmain")
    end
    TUNING[i] = v
end

for _, module in pairs(TA_CONFIG) do
    for k, v in pairs(module) do
        addtuning(k, v)
    end
end
