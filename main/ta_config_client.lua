GLOBAL.TA_CONFIG = {}

----前端
local world_overrides
if GLOBAL.TheWorld ~= nil then
    world_overrides = TheWorld.topology.overrides
    print("Update world settings in modworldgenmain with TheWorld.topology.overrides")
    for i, v in pairs(world_overrides) do
        print((tostring(i) or "nil") .. ":        " .. (tostring(v) or "nil"))
    end
end

-----相关内容迁移到了 "tools/configutil",因为需要复用
AddConfigAndTuning(TA_CONFIG, world_overrides)
