local daytime = TUNING.TOTAL_DAY_TIME
local PHASE_NAMES = { "fiesta", "calm", "near", "aporkalypse", }
local PHASES = table.invert(PHASE_NAMES)
local _world = TheWorld
local _ismastersim = _world.ismastersim


local function GetTimeTnSeconds()
	return (TheWorld.state.cycles + TheWorld.state.time) * daytime
end

local Aporkalypse = Class(function(self, inst)
	self.inst = inst

	self.first_time = true
	self.near_days = 7 * daytime
	self.aporkalypse_duration = 20 * daytime
	self.should_fiesta_duration = 3 * daytime
	self.fiesta_duration = 7 * daytime
	self.periodtime = 120 * daytime


	self.begin_date = self.periodtime
	self.real_start_date = nil
	self.fiesta_begin_date = nil

	local _phasedirty = true
	self._phase = net_tinybyte(inst.GUID, "aporkalypse._phase", "aporkalypsephasedirty")
	self._phase:set(PHASES.calm)

	if _ismastersim then
		local stagefunc = function(inst, data)
			-- print("aporkalypsephase:", self._phase:value())
			-- print("aporkalypsebegindate:", self.begin_date / daytime)
			-- print("aporkalypsenowadays:", GetTimeTnSeconds() / daytime)
			-- print("fiestadate:", self.fiesta_begin_date / daytime)

			if self._phase:value() <= PHASES.calm then
				if GetTimeTnSeconds() >= (self.begin_date - self.near_days) then
					self._phase:set(PHASES.near)
				end
			end

			if self._phase:value() <= PHASES.near then
				if GetTimeTnSeconds() >= self.begin_date then
					self._phase:set(PHASES.aporkalypse)
					self.real_start_date = GetTimeTnSeconds()
					self:ScheduleAporkalypseTasks()
				end
			elseif self._phase:value() == PHASES.aporkalypse then
				if GetTimeTnSeconds() > self.begin_date then
					if (GetTimeTnSeconds() - self.real_start_date) >= self.aporkalypse_duration then
						self._phase:set(PHASES.fiesta)
						self.fiesta_begin_date = GetTimeTnSeconds()
						self:ScheduleAporkalypse()
						self.first_time = false
					end
				else
					if (GetTimeTnSeconds() - self.real_start_date) >= self.should_fiesta_duration then
						self._phase:set(PHASES.fiesta)
						self.fiesta_begin_date = GetTimeTnSeconds()
						self.first_time = false
					else
						self._phase:set(PHASES.calm)
						self.first_time = false
					end
				end
			end

			if self._phase:value() == PHASES.fiesta then
				local fiesta_elapsed = GetTimeTnSeconds() - self.fiesta_begin_date
				if self.fiesta_duration - fiesta_elapsed < 0 then
					self._phase:set(PHASES.calm)
				end
			end
		end

		inst:ListenForEvent("clocktick", stagefunc, TheWorld)
	end

	inst:ListenForEvent("aporkalypsephasedirty", function() _phasedirty = true end)

	inst:StartUpdatingComponent(self)


	self.OnUpdate = function(dt)
		-- print("try update aporkalypse")
		if _phasedirty then
			print("aporkalypse phase changed:", PHASE_NAMES[self._phase:value()])
			_world:PushEvent("aporkalypsephasechanged", PHASE_NAMES[self._phase:value()])
			_phasedirty = false
		end
		if _ismastersim then end
	end

	inst:StartUpdatingComponent(self)
end)

Aporkalypse.OnSave = _ismastersim and function(self)
	return
	{
		phase = self._phase:value(),
		begin_date = self.begin_date,
		real_start_date = self.real_start_date,
		fiesta_begin_date = self.fiesta_begin_date,
		first_time = self.first_time,
	}
end

Aporkalypse.OnLoad = _ismastersim and function(self, data)
	if data then
		self._phase:set(data.phase or PHASES.calm) --这里也会推送事件，所以不用手动推送了
		self.fiesta_begin_date = data.fiesta_begin_date
		self.first_time = data.first_time
		self.real_start_date = data.real_start_date
		self.begin_date = data.begin_date or (GetTimeTnSeconds() + (120 * daytime))
	end
end

Aporkalypse.ScheduleAporkalypse = _ismastersim and function(self, date)
	local currentTime = GetTimeTnSeconds()
	local delta = date and (date - GetTimeTnSeconds()) or self.periodtime
	while delta > self.periodtime do
		delta = delta % self.periodtime
	end

	while delta < 0 do
		delta = delta + self.periodtime
	end

	self.begin_date = currentTime + delta

	for id in pairs(Shard_GetConnectedShards()) do
		SendModRPCToShard(SHARD_MOD_RPC["Tropical adventures"]["aporkalypse begin date"], id, self.begin_date)
	end
end

Aporkalypse.ScheduleAporkalypseTasks = _ismastersim and function(self)
	if TheWorld:HasTag("cave") then
		self:ScheduleHeraldCheck()
	end
	self:ScheduleVampireBatCheck()
end

Aporkalypse.ScheduleHeraldCheck = _ismastersim and function(self)
	self.herald_check_task = self.inst:StartThread(function()
		Sleep(math.random(TUNING.SEG_TIME / 2, TUNING.SEG_TIME))
		while self:IsActive() do
			for _, player in ipairs(AllPlayers) do ----isinworld好像不太对
				if player and player:IsInWorld() and player:IsValid() and player.components.health and not player.components.health:IsDead() then
					local herald = GetClosestInstWithTag("ancient", player, 30)
					if not herald then
						local valid_position = FindNearbyLand(player:GetPosition())
						if valid_position then herald = SpawnAt("ancient_herald", valid_position) end
					end
					if herald and herald.components.combat then
						herald.components.combat:SuggestTarget(player)
					end
				end
			end
			Sleep(math.random(TUNING.SEG_TIME / 2, TUNING.SEG_TIME))
		end
	end)
end

Aporkalypse.ScheduleVampireBatCheck = _ismastersim and function(self)
	self.vampire_check_task = self.inst:StartThread(function()
		Sleep(math.random(TUNING.SEG_TIME / 8, TUNING.SEG_TIME / 4))
		if self:IsActive() then
			for _, player in ipairs(AllPlayers) do
				if player and player:IsInWorld() and player:IsValid() and player.components.health and not player.components.health:IsDead() then
					for i = 1, 24 do
						local x, y, z = player.Transform:GetWorldPosition()
						local theta = math.random() * TWOPI
						local r = 4 + math.random() * 16
						x = x + r * math.sin(theta)
						z = z + r * math.cos(theta)
						local vampirebat = SpawnAt("circlingbat", Vector3(x, 0, z))
						if vampirebat and vampirebat.components.combat then
							vampirebat.components.combat:SuggestTarget(player)
						end
					end
				end
			end
		end
	end)
end

function Aporkalypse:IsNear()
	return self._phase:value() == PHASES.near
end

function Aporkalypse:GetBeginDate()
	return self.begin_date
end

function Aporkalypse:IsActive()
	return self._phase:value() == PHASES.aporkalypse
end

function Aporkalypse:GetFiestaActive()
	return self._phase:value() == PHASES.fiesta
end

Aporkalypse.LongUpdate = Aporkalypse.OnUpdate

return Aporkalypse
