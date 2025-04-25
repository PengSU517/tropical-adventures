
---这个函数在modmain运行正常，thesim只在modmain存在
-- function ModGetLevelDataOverride()
--     print("TA Mod Loading world overrides")


--     local filename = "../leveldataoverride.lua"
--     local success, savedata

--     local shardGameIndex = ShardGameIndex
--     if not shardGameIndex then
--         require("shardindex")
--         shardGameIndex = ShardIndex()
--         shardGameIndex:Load()
--     end

--     local function onload(load_success, str)
--         if load_success == true then
--             success, savedata = RunInSandboxSafe(str)
--             if success and string.len(str) > 0 then
--                 print("TA Mod Found a level data override file with these contents:")
--                 if savedata ~= nil then
--                     print("TA Mod Loaded and applied level data override from " .. filename)
--                     return
--                 end
--             else
--                 print("ERROR: Failed to load " .. filename)
--             end
--         end
--         print("Not applying level data overrides.")
--     end

--     local slot = shardGameIndex:GetSlot()
--     local shard = shardGameIndex:GetShard()
--     local session_id = shardGameIndex:GetSession()

--     print("slot is " .. (slot or "nil"))
--     print("shard is " .. (shard or "nil"))
--     print("session_id is " .. (session_id or "nil"))
--     -----sessionid在生成世界时没有，重新加载世界时存在（即使世界刚刚生成还没有保存过 而且只在主机有，客机没有
--     if not TheNet:IsDedicated() then
--         print("TA Mod Loading level data override from cluster slot")
--         TheSim:GetPersistentStringInClusterSlot(shardGameIndex:GetSlot(), "Master", filename, onload)
--     else
--         TheSim:GetPersistentString(filename, onload)
--     end

--     -- if session_id ~= nil then ---只有服务器需要这个
--     --     TheSim:GetPersistentStringInClusterSlot(slot, shard, filename, onload)
--     -- else
--     --     TheSim:GetPersistentString(filename, onload)
--     -- end

--     return savedata
-- end

-- local rst = ModGetLevelDataOverride()

-- local rst = TheNet:GetServerListing()
-- print("TA Mod Loading server listing")
-- for i, v in pairs(rst) do
--     print(i .. "11111111111111")
--     print(v)
-- end

if not TheNet:IsDedicated() then
    print("TA Mod Loading server listing")
    -- local a, b = RunInSandboxSafe(TheNet:GetServerListing().world_gen_data)
    -- local c, d = DecodeAndunzipString(b.str)
    rst = {}
    GetProfilerSave(rst)
end

if not TheNet:IsDedicated() then
    print("TA Mod Loading server listing")

    -----可以拿到服务器的所有信息，但是怎么确定当前连接的shard是个问题
    local a, b = RunInSandboxSafeCatchInfiniteLoops(TheNet:GetServerListing().world_gen_data)
    ------TheNet:GetServerListingFromActualIndex
    local d = DecodeAndUnzipString(b.str)
    for i, v in pairs(d) do
        print(i, v)
        for ii, vv in pairs(v) do
            print(ii, vv)
            if type(vv) == "table" and ii == "overrides" then
                print("overrides---------------------------------------------------------------------------")
                for iii, vvv in pairs(vv) do
                    print(iii, vvv)
                end
            end
        end
    end

    AddSimPostInit(function()
        print("TA Mod in sim")
        GetProfilerSave({}) ----这个函数只能只在api里

        -- local shardGameIndex = ShardGameIndex
        -- if not shardGameIndex then
        --     require("shardindex")
        --     shardGameIndex = ShardIndex()
        --     shardGameIndex:Load()
        -- end

        -- local slot = shardGameIndex:GetSlot()
        -- local shard = shardGameIndex:GetShard()
        -- local session_id = shardGameIndex:GetSession()

        -- print("slot is " .. (slot or "nil"))
        -- print("shard is " .. (shard or "nil"))
        -- print("session_id is " .. (session_id or "nil"))
    end)
end

local id = TheShard:GetShardId()
print("shard id is " .. id) ----关键是在客户端获取不到啊

local server_name = TheNet:GetServerName()
print("server_name is " .. (server_name or "nil"))