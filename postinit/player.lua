local TAENV = env
GLOBAL.setfenv(1, GLOBAL)

local unpack = unpack

local function OnLoad(inst, data)
	--If this character is being loaded then it isn't a new spawn
	inst.OnNewSpawn = nil
	inst._OnNewSpawn = nil
	inst.starting_inventory = nil
	if data ~= nil then
		if data.is_ghost then
			if data.death_posx ~= nil and data.death_posy ~= nil and data.death_posz ~= nil then
				inst.last_death_position = Vector3(data.death_posx, data.death_posy, data.death_posz)
				inst.last_death_shardid = data.death_shardid
			end

			ex_fns.OnMakePlayerGhost(inst, { loading = true })
		end

		--V2C: Sleeping hacks from snapshots or c_saves while sleeping
		if data.sleepinghandsitem ~= nil then
			local item = SpawnSaveRecord(data.sleepinghandsitem)
			if item ~= nil then
				inst.components.inventory.silentfull = true
				inst.components.inventory:Equip(item)
				inst.components.inventory.silentfull = false
			end
		end
		if data.sleepingactiveitem ~= nil then
			local item = SpawnSaveRecord(data.sleepingactiveitem)
			if item ~= nil then
				inst.components.inventory.silentfull = true
				inst.components.inventory:GiveItem(item)
				inst.components.inventory.silentfull = false
			end
		end
		--

		--Special case entities, since save references do not apply to networked players
		if data.wormlight ~= nil and inst.wormlight == nil then
			local wormlight = SpawnSaveRecord(data.wormlight)
			if wormlight ~= nil and wormlight.components.spell ~= nil then
				wormlight.components.spell:SetTarget(inst)
				if wormlight:IsValid() then
					if wormlight.components.spell.target == nil then
						wormlight:Remove()
					else
						wormlight.components.spell:ResumeSpell()
					end
				end
			end
		end

		if data.yotb_skins_sets and IsSpecialEventActive(SPECIAL_EVENTS.YOTB) then
			inst.yotb_skins_sets:set(data.yotb_skins_sets)
		end
	end

	if IsConsole() then
		TheGameService:NotifyProgress("dayssaved", inst.components.age:GetDisplayAgeInDays(), inst.userid)
	end

	if inst._OnLoad ~= nil then
		inst:_OnLoad(data)
	end

	inst:DoTaskInTime(0, function()
		--V2C: HACK! enabled false instead of nil means it was overriden by weregoose on load.
		--     Please refactor drownable and this block to use POST LOAD timing instead.
		if inst.components.drownable ~= nil and inst.components.drownable.enabled ~= false then
			local my_x, my_y, my_z = inst.Transform:GetWorldPosition()


			if not TheWorld.Map:IsPassableAtPoint(my_x, my_y, my_z) then
				local ship = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
				if not ship then
					for k, v in pairs(Ents) do
						if v:IsValid() and v:HasTag("multiplayer_portal") then
							inst.Transform:SetPosition(v.Transform:GetWorldPosition())
							inst:SnapCamera()
							return
						end
					end
				end
			end
		end
	end)
end


TAENV.AddPlayerPostInit(function(inst)
	if TheWorld.ismastersim then
		inst.OnLoad = OnLoad
		inst._OnLoad = inst.OnLoad
	end
end)

--[[----------------------------------------------------------------------------------------
local function removebuffs(inst, data)
	if inst.components.locomotor then
		inst.components.locomotor:RemoveExternalSpeedAdder(inst, "CAFFEINE")
		inst.components.locomotor:RemoveExternalSpeedAdder(inst, "SURF")
		inst.components.locomotor:RemoveExternalSpeedAdder(inst, "AUTODRY")
	end
end

local function blockPoison(inst, data)
	if inst.components.poisonable then
		inst.components.poisonable:SetBlockAll(true)
	end
end
local function unblockPoison(inst, data)
	if inst.components.poisonable and not inst:HasTag("wereplayer") then
		inst.components.poisonable:SetBlockAll(false)
	end
end

----------------------------------------------------------------------------------------

local function newstate(inst, data)
	--data.statename
	if inst:HasTag("idle") then
		if inst._embarkingboat and inst._embarkingboat:IsValid() then
			inst.components.sailor:Embark(inst._embarkingboat)
			inst._embarkingboat = nil
		end
		inst:RemoveEventCallback("newstate", newstate)
	end
end

local function stop(inst)
	if inst.Physics then
		inst.Physics:Stop()
	end
end

local function GiveRaft(inst)
	if IA_CONFIG.newplayerboats and inst.components.builder and IsRecipeValid("boat_lograft") then
		inst.components.builder:UnlockRecipe("boat_lograft")
		inst.components.builder.buffered_builds["boat_lograft"] = 0
		inst.replica.builder:SetIsBuildBuffered("boat_lograft", true)
	end
end

local function ms_respawnedfromghost(inst, data)
    local x, y, z = inst.Transform:GetWorldPosition()
	if not inst:CanOnWater(true) and TheWorld.Map:IsOceanAtPoint(x, y, z) and inst.components.sailor then
		local boat = GetClosestBoatInRange(x, y, z, TUNING.AUTOEMBARK_BOATRANGE.REVIVE)
		if boat then
			boat.components.sailable.isembarking = true
			inst._embarkingboat = boat
			--Move there!
			inst:ForceFacePoint(boat:GetPosition():Get())
			local dist = inst:GetPosition():Dist(boat:GetPosition())
			inst.Physics:SetMotorVelOverride(dist / .8, 0, 0)
			inst:DoTaskInTime(.8, stop)
			inst:ListenForEvent("newstate", newstate)
		end
	end
	if IsInIAClimate(inst) then
		GiveRaft(inst)
	end
end

----------------------------------------------------------------------------------------

local _OnGotNewItem
local function OnGotNewItem(inst, data, ...)
	if (data.slot ~= nil or data.eslot ~= nil)
	  and TheFocalPoint --just a small failsafe
	  and IsInIAClimate(inst) and not inst:IsOnPassablePoint() then
		SetSoundAlias("dontstarve/HUD/collect_resource", "ia/common/water_collect_resource")
	end
	local rets = {_OnGotNewItem(inst, data, ...)}
	SetSoundAlias("dontstarve/HUD/collect_resource", nil)
	return unpack(rets)
end

----------------------------------------------------------------------------------------

local function OnLoad(inst, data, ...)
	if data ~= nil then
		if data.is_ghost then
			blockPoison(inst)
		end
	end
    -- Well this really sucks, thanks for making my life hell klei :) (I blame Zarklord specifically because funi)
    local _DoTaskInTime = inst.DoTaskInTime
    function inst:DoTaskInTime(time, fn, ...)
        return _DoTaskInTime(self, time, fn ~= nil and function(...)
            local _enabled = nil
            local _drownable = inst:CanOnWater(true) and inst.components.drownable or nil
            if _drownable then
                _enabled = _drownable.enabled
                _drownable.enabled = false
            end
            local _rets = {fn(...)}
            if _drownable then
                _drownable.enabled = _enabled
            end
            return unpack(_rets)
        end or nil, ...)
    end
	local rets = {inst.IA_OnLoad(inst, data, ...)}
    inst.DoTaskInTime = _DoTaskInTime
    inst:DoTaskInTime(0, function()
        -- If Klei changes this to use POST LOAD time then refacter this code -Half
        if inst.components.drydrownable ~= nil and inst.components.drydrownable.enabled ~= false and not inst:CanOnLand(true) then
            local my_x, my_y, my_z = inst.Transform:GetWorldPosition()

            if TheWorld.Map:IsPassableAtPoint(my_x, my_y, my_z) then
                for k,v in pairs(Ents) do
                    if v:IsValid() and v:HasTag("multiplayer_portal") then
                        local x, y, z = FindRandomPointOnOceanFromShore(v.Transform:GetWorldPosition())
                        if x ~= nil then
                            inst.Transform:SetPosition(x, y, z)
                            inst:SnapCamera()
                        end
                    end
                end
            end
        end
    end)
    return unpack(rets)
end

local function OnNewSpawn(inst, ...)
	local Starting_Items
	if IsInIAClimate(inst) then
		GiveRaft(inst)
		Starting_Items = deepcopy(TUNING.SEASONAL_STARTING_ITEMS)
		TUNING.SEASONAL_STARTING_ITEMS = TUNING.ISLAND_SEASONAL_STARTING_ITEMS
	end
	inst.IA_OnNewSpawn(inst, ...)
	if Starting_Items ~= nil then
		TUNING.SEASONAL_STARTING_ITEMS = Starting_Items
	end
end

local function OnDespawn(inst, migrationdata, ...)
    local sailor = inst.components.sailor
    if migrationdata ~= nil and sailor and sailor:GetBoat() ~= nil then
        local portal = nil
        if migrationdata.worldid ~= nil and migrationdata.portalid ~= nil then
            for i, v in ipairs(ShardPortals) do
                local worldmigrator = v.components.worldmigrator
                if worldmigrator ~= nil and worldmigrator.id == migrationdata.portalid then
                    portal = v
                    break
                end
            end
        end

        if portal ~= nil and portal.components.migratorboatstorage ~= nil then
            portal.components.migratorboatstorage:DockPlayerBoat(inst)
        end
    end
    inst.IA_OnDespawn(inst, migrationdata, ...)
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddPlayerPostInit(function(inst)

	if TheWorld.ismastersim then
		if not inst.components.climatetracker then
			inst:AddComponent("climatetracker")
		end
		inst.components.climatetracker.period = 2
        inst:AddComponent("eroder")
		inst:AddComponent("sailor") -- TODO: Only add if TheWorld.has_ocean
		inst:AddComponent("ballphinfriend")

		if TheWorld:HasTag("island") then
			inst:AddComponent("mapwrapper")
        else
            inst:RemoveComponent("mapwrapper")
	    end

        if TheWorld.has_ocean then
	        inst:AddComponent("drydrownable")
		end

		inst:ListenForEvent("death", removebuffs)
		inst:ListenForEvent("death", blockPoison)
		inst:ListenForEvent("respawnfromghost", unblockPoison)
		inst:ListenForEvent("ms_respawnedfromghost", ms_respawnedfromghost)

		if inst.OnLoad then
			inst.IA_OnLoad = inst.OnLoad
			inst.OnLoad = OnLoad
		end
		if inst.OnNewSpawn then
			inst.IA_OnNewSpawn = inst.OnNewSpawn
			inst.OnNewSpawn = OnNewSpawn
		end
        if inst.OnDespawn then
            inst.IA_OnDespawn = inst.OnDespawn
            inst.OnDespawn = OnDespawn
        end
	end

	if not TheNet:IsDedicated() then
		-- player_common prefers to only set callbacks like this in "SetOwner", as the character owner can theoretically change
		if not _OnGotNewItem then
			for i, v in ipairs(inst.event_listening["setowner"][inst]) do
				if UpvalueHacker.GetUpvalue(v, "RegisterActivePlayerEventListeners") then
					_OnGotNewItem = UpvalueHacker.GetUpvalue(v, "RegisterActivePlayerEventListeners", "OnGotNewItem")
					UpvalueHacker.SetUpvalue(v, OnGotNewItem, "RegisterActivePlayerEventListeners", "OnGotNewItem")
					break
				end
			end
		end

		inst:DoTaskInTime(0, function()
			if inst == ThePlayer then --only do this for the local player character
				inst:AddComponent("windvisuals")
			end
		end)
	end
end)
]]
