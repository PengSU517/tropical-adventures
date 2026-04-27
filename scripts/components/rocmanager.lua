local SPAWNDIST = 40

local Rocmanager = Class(function(self, inst)
	self.disabled = false
	self.inst = inst
	-- self.inst:DoPeriodicTask(TESTTIME, function() self:ShouldSpawn() end) --
	self.roc = nil
	self.nexttime = self:GetNextSpawnTime()


	self._activeplayers = {}


	local function OnPlayerJoined(src, player)
		for i, v in ipairs(self._activeplayers) do
			if v == player then
				return
			end
		end
		table.insert(self._activeplayers, player)
	end

	local function OnPlayerLeft(src, player)
		for i, v in ipairs(self._activeplayers) do
			if v == player then
				table.remove(self._activeplayers, i)
				return
			end
		end
	end

	--------------------------------------------------------------------------
	--[[ Initialization ]]
	--------------------------------------------------------------------------

	--Initialize variables
	-- for i, v in ipairs(AllPlayers) do
	-- 	table.insert(self._activeplayers, v)
	-- end

	--Register events
	inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
	inst:ListenForEvent("ms_playerleft", OnPlayerLeft, TheWorld)

	self.inst:StartUpdatingComponent(self)
end)

function Rocmanager:OnSave()
	local refs = {}
	local data = {}
	data.disabled = self.disabled
	data.nexttime = self.nexttime

	if self.roc and self.roc:IsValid() then
		data.roc = self.roc.GUID
		table.insert(refs, self.roc.GUID)
	end

	return data, refs
end

function Rocmanager:OnLoad(data)
	if data.disabled then
		self.disabled = data.disabled
	end
	if data.nexttime then
		self.nexttime = data.nexttime
	end
end

function Rocmanager:LoadPostPass(newents, savedata) --最好检查一下
	if savedata.roc then
		local roc = newents[savedata.roc]
		if roc then
			self.roc = roc.entity
		end
	end
end

function Rocmanager:RemoveRoc(inst)
	if self.roc == inst then
		self.roc = nil
	end
end

function Rocmanager:Disable()
	self.disabled = true
end

function Rocmanager:GetNextSpawnTime()
	return (TUNING.TOTAL_DAY_TIME * 10) + (math.random() * TUNING.TOTAL_DAY_TIME * 10)
end

function Rocmanager:Spawn(summoner)
	if not self.roc then
		if summoner then
			local room = GetClosestInstWithTag("interior_center", summoner, 40) --判断室内，或者直接判断位置
			local nest = GetClosestInstWithTag("roc_nest", summoner, 40)
			if not (room or nest) then
				local pt = Vector3(summoner.Transform:GetWorldPosition())
				local angle = math.random() * 2 * PI
				local offset = Vector3(SPAWNDIST * math.cos(angle), 0, -SPAWNDIST * math.sin(angle))
				local roc = SpawnPrefab("roc")
				roc.Transform:SetPosition(pt.x + offset.x, 0, pt.z + offset.z)
				self.roc = roc
				self.nexttime = self:GetNextSpawnTime()
				return
			end
		else
			for i, v in ipairs(self._activeplayers) do
				if v ~= nil then
					-- local px, py, pz = v.Transform:GetWorldPosition()
					local room = GetClosestInstWithTag("interior_center", v, 40) --判断室内，或者直接判断位置
					local nest = GetClosestInstWithTag("roc_nest", v, 40)

					if not (room or nest) then
						local pt = Vector3(v.Transform:GetWorldPosition())
						local angle = math.random() * 2 * PI
						local offset = Vector3(SPAWNDIST * math.cos(angle), 0, -SPAWNDIST * math.sin(angle))
						local roc = SpawnPrefab("roc")
						roc.Transform:SetPosition(pt.x + offset.x, 0, pt.z + offset.z)
						self.roc = roc
						self.nexttime = self:GetNextSpawnTime()

						return
					end
				end
			end
		end
	end
end

function Rocmanager:ShouldSpawn(dt)
	if self.disabled then
		return
	end

	-- will only spawn before the first half of daylight.
	if not self.roc then --clock:GetNormTime() < (clock.daysegs / 16) /2 then
		-- do test stuff.
		if self.nexttime <= 0 and TheWorld.state.isday then
			self:Spawn()
		else
			self.nexttime = math.max(self.nexttime - dt, 0)
		end
	end
end

function Rocmanager:OnUpdate(dt)
	self:ShouldSpawn(dt)
end

Rocmanager.LongUpdate = Rocmanager.OnUpdate

return Rocmanager
