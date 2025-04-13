local CHECK_RADIUS = 40
local SCREEN_DIST  = 50
local creaturedef  = require("datadefs/creature_spawn_defs")

return Class(function(self, inst)
	assert(TheWorld.ismastersim, "SchoolSpawner should not exist on client")

	--------------------------------------------------------------------------
	--[[ Member variables ]]
	--------------------------------------------------------------------------

	--Public
	self.inst = inst

	--Private
	local _scheduledtasks = {}
	local _world = TheWorld
	local _map = _world.Map

	--------------------------------------------------------------------------
	--[[ Private member functions ]]
	--------------------------------------------------------------------------
	local TEMPOMINIMO = 5
	local TEMPOMAXIMO = 10

	local function SpawnSchoolForPlayer(player, reschedule)
		--print("SpawnSchoolForPlayer")
		local spawninfo = self:GetSpawnPointInfo(player:GetPosition())
		if spawninfo ~= nil then
			self:SpawnSchool(spawninfo)
		end

		_scheduledtasks[player] = nil
		reschedule(player)
	end

	local function ScheduleSpawn(player)
		if _scheduledtasks[player] == nil then
			_scheduledtasks[player] = player:DoTaskInTime(GetRandomMinMax(TEMPOMINIMO, TEMPOMAXIMO), SpawnSchoolForPlayer,
				ScheduleSpawn)
		end
	end

	local function CancelSpawn(player)
		if _scheduledtasks[player] ~= nil then
			_scheduledtasks[player]:Cancel()
			_scheduledtasks[player] = nil
		end
	end



	--------------------------------------------------------------------------
	--[[ Private event handlers ]]
	--------------------------------------------------------------------------

	local function OnPlayerJoined(src, player)
		--print("player joined")
		ScheduleSpawn(player)
	end

	local function OnPlayerLeft(src, player)
		CancelSpawn(player)
	end

	--------------------------------------------------------------------------
	--[[ Initialization ]]
	--------------------------------------------------------------------------

	--Register events
	inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
	inst:ListenForEvent("ms_playerleft", OnPlayerLeft, TheWorld)

	--------------------------------------------------------------------------
	--[[ Public member functions ]]
	--------------------------------------------------------------------------

	local function PickSchool(tile)
		-- --print("PickSchool")
		local school_choices = creaturedef.tiles[tile]
		local schooltype = school_choices and weighted_random_choice(school_choices) or nil
		return schooltype ~= nil and creaturedef.creatures[schooltype] or nil
	end

	function self:GetSpawnPointInfo(pt) -----------要保证玩家有一段距离
		--print("GetSpawnPointInfo")

		local spt, tile, schooldata
		local function TestSpawnPoint(offset)
			spt = pt + offset
			tile = _map:GetTileAtPoint(spt:Get())
			schooldata = PickSchool(tile)
			if schooldata and #TheSim:FindEntities(spt.x, spt.y, spt.z, CHECK_RADIUS, { "tropicalspawnblocker" }) <= 0
				and #TheSim:FindEntities(spt.x, spt.y, spt.z, SCREEN_DIST, { "player" }) <= 0 then
				return true
			end
		end

		local theta = math.random() * 2 * PI
		local resultoffset = FindValidPositionByFan(theta, SCREEN_DIST, 40, TestSpawnPoint) or nil
		------这个函数也要改
		if resultoffset ~= nil then
			return { spawnpoint = spt, tile = tile, schooldata = schooldata }
		end
	end

	local function DoSpawnCreature(prefab, pos, rot, herd)
		--print("DoSpawnCreature")
		local creature = SpawnPrefab(prefab)
		if creature then
			creature.Transform:SetPosition(pos:Get())
			-- creature:AddTag("spawned_" .. prefab)
			--print("Spawn creature " .. prefab)
		end
	end

	function self:SpawnSchool(spawninfo)
		local schooldata = spawninfo.schooldata
		local spawnpoint = spawninfo.spawnpoint
		local tile = spawninfo.tile

		--print("SpawnSchool")
		local prefab = schooldata.prefab
		local checkname = schooldata.checkname or schooldata.prefab
		local num_creature = #TheSim:FindEntities(spawnpoint.x, spawnpoint.y, spawnpoint.z, CHECK_RADIUS,
			{ "spawned_" .. checkname })

		if schooldata.schoolmin < num_creature then
			return
		end
		local schoolsize = math.random(schooldata.schoolmin, schooldata.schoolmax)
		local rotation = math.random() * 360


		local spawnsize = 0
		while spawnsize + num_creature < schoolsize do
			local radius = math.sqrt(math.random()) * schooldata.schoolrange
			local angle = math.random() * 360

			local offset
			if IsLandTile(tile) then
				offset = FindWalkableOffset(spawnpoint, angle, radius, 12)
			elseif IsOceanTile(tile) then
				offset = FindSwimmableOffset(spawnpoint, angle, radius, 12)
			end
			if offset then
				DoSpawnCreature(prefab, spawnpoint + offset, rotation)
				spawnsize = spawnsize + 1
			end
		end
		SpawnPrefab("tropicalspawnblocker").Transform:SetPosition(spawnpoint:Get())
	end

	--------------------------------------------------------------------------
	--[[ End ]]
	--------------------------------------------------------------------------
end)
