----海上漂浮物刷新

AddComponentPostInit("flotsamgenerator", function(self)
    local _SpawnGuaranteedFlotsam = Upvaluehelper.GetUpvalue(self.ScheduleGuaranteedSpawn, "SpawnGuaranteedFlotsam")
    local _ScheduleSpawn = Upvaluehelper.GetUpvalue(self.ToggleUpdate, "ScheduleSpawn")
    local _SpawnFlotsamForPlayer = Upvaluehelper.GetUpvalue(_SpawnGuaranteedFlotsam, "SpawnFlotsamForPlayer")
    local _scheduledtasks = Upvaluehelper.GetUpvalue(_SpawnFlotsamForPlayer, "_scheduledtasks")
    local _GetSpawnPoint = Upvaluehelper.GetUpvalue(_SpawnFlotsamForPlayer, "GetSpawnPoint")
    local flotsam_prefabs = Upvaluehelper.GetUpvalue(self.SpawnFlotsam, "flotsam_prefabs")
    local guaranteed_presets = Upvaluehelper.GetUpvalue(self.ToggleUpdate, "guaranteed_presets")

    if flotsam_prefabs then
        flotsam_prefabs["waterygrave"] = 0.1
        flotsam_prefabs["redbarrel"] = 0.1
        flotsam_prefabs["luggagechest_spawner"] = 0.1
    end

    if guaranteed_presets then
        guaranteed_presets["messagebottle_sw"] = {
            prefabs = { "messagebottle_sw" },
            rate = 1 * TUNING.TOTAL_DAY_TIME,
            variance = 1 * TUNING.TOTAL_DAY_TIME
        }
    end

    local function SpawnFlotsamForPlayer(player, reschedule, override_prefab, override_notrealflotsam, ...)
        if player:IsOnOcean(true) then
            local flotsam
            local pt = player:GetPosition()
            local spawnpoint = _GetSpawnPoint(pt)
            if spawnpoint ~= nil then
                flotsam = self:SpawnFlotsam(spawnpoint, override_prefab, override_notrealflotsam)
            end
            if reschedule ~= nil then
                _scheduledtasks[player] = nil
                reschedule(player)
            end

            return flotsam
        end
        return _SpawnFlotsamForPlayer(player, reschedule, override_prefab, override_notrealflotsam, ...)
    end

    Upvaluehelper.SetUpvalue(_ScheduleSpawn, SpawnFlotsamForPlayer, "SpawnFlotsamForPlayer")
    Upvaluehelper.SetUpvalue(_SpawnGuaranteedFlotsam, SpawnFlotsamForPlayer, "SpawnFlotsamForPlayer")

    -- local _ScheduleGuaranteedSpawn = self.ScheduleGuaranteedSpawn
    -- self.ScheduleGuaranteedSpawn = function(self, ...)
    --     print("ScheduleGuaranteedSpawn")
    --     _ScheduleGuaranteedSpawn(self, ...)
    -- end

    --reset
    self:ToggleUpdate()
end)
