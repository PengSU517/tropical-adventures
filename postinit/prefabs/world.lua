AddPrefabPostInit("forest", function(inst)
    if TheWorld.ismastersim then
        inst:AddComponent("climatespawner") -----这个东西很复杂--海浪在这里
        inst:AddComponent("economy")
        inst:AddComponent("contador")
        inst:AddComponent("bigfooter")
        inst:AddComponent("roottrunkinventory") ---------------这个是啥啊
        inst:AddComponent("creature_spawner")   ----不只有生物，还有旋涡，天光之类的内容
        -- inst:AddComponent("tropicalspawner")
        inst:AddComponent("whale_hunter")
        inst:AddComponent("rainbowjellymigration")
        inst:AddComponent("quaker_interior") ------------这是啥
        inst:AddComponent("glowflyspawner")


        if TUNING.sealnado then
            inst:AddComponent("twisterspawner")
        end


        if TUNING.hamlet then
            inst:AddComponent("banditmanager")

            if TUNING.roc then
                inst:AddComponent("rocmanager")
            end
        end
    end
end)


AddPrefabPostInit("cave", function(inst)
    if TheWorld.ismastersim then
        inst:AddComponent("roottrunkinventory")
        inst:AddComponent("quaker_interior")
        inst:AddComponent("economy")
        inst:AddComponent("contador")
    end
end)

AddPrefabPostInit("world", function(inst)
    if TUNING.aporkalypse and TheWorld.ismastersim then
        inst:AddComponent("aporkalypse")
        if KnownModIndex:IsModEnabled("workshop-2657513551") then
            inst:AddComponent("dsa_aporkalypse_proxy")
        end
    end
end)

--- world_network postinit
--- #1
--AddPrefabPostInitAny(function(inst)
--    if not TheWorld or TheWorld.net ~= inst then
--        return
--    end

--    if TUNING.aporkalypse then
--        -- print("add aporkalypse in world net")
--        inst:AddComponent("aporkalypse")
--    else
--        -- print("not add aporkalypse in world net")
--    end
--end)

--- #2
-- if TUNING.aporkalypse then
--     AddComponentPostInit("autosaver", function(self)
--         self.inst:AddComponent("aporkalypse")
--     end)
-- end

--- #3
-- if TUNING.aporkalypse then
--     print("add aporkalypse in world net  package load")
--     local worldnetworks = {}
--     local MakeWorldNetwork = require("prefabs/world_network")
--     local function WorldNetPostInit(inst)
--         inst:AddComponent("aporkalypse")
--     end
--     package.loaded["prefabs/world_network"] = function(name, ...)
--         if not worldnetworks[name] then
--             worldnetworks[name] = true
--             AddPrefabPostInit(name, WorldNetPostInit)
--         end
--         return MakeWorldNetwork(name, ...)
--     end
-- end
-------------------------
local PHASE_NAMES = { "fiesta", "calm", "near", "aporkalypse", }
local PHASES = table.invert(PHASE_NAMES)

local function NetAporkalypsePostInit(inst)
    if TUNING.aporkalypse then
        inst._aporkalypse_phase = net_tinybyte(inst.GUID, "aporkalypse.phase", "aporkalypse.phasedirty")
        inst._aporkalypse_phase:set_local(2)
        inst:ListenForEvent("aporkalypse.phasedirty", function()
            TheWorld:PushEvent("aporkalypsephasechanged", PHASE_NAMES[inst._aporkalypse_phase:value()])
        end)
        if TheWorld and TheWorld.ismastersim and TheWorld.components.aporkalypse then
            inst._aporkalypse_phase:set(TheWorld.components.aporkalypse._phase)
        end
    end
end

AddPrefabPostInit("forest_network", function(inst)
    NetAporkalypsePostInit(inst)
    inst:AddComponent("weatherham")
end)

AddPrefabPostInit("cave_network", NetAporkalypsePostInit)

AddPrefabPostInit("shard_network", function(inst)
    if TUNING.aporkalypse then
        inst._aporkalypse_begin_date = net_uint(inst.GUID, "aporkalypse.begin_date", "aporkalypse.begin_datedirty")
        inst._aporkalypse_begin_date:set_local(57600)
        inst:ListenForEvent("aporkalypse.begin_datedirty", function()
            if TheWorld.components.aporkalypse ~= nil then
                TheWorld.components.aporkalypse.begin_date = inst._aporkalypse_begin_date:value()
            end
        end)
        if TheWorld.ismastershard then
            Shard_SyncAporkalypseBeginDate()
        end
    end
end)
