local assets =
{
	Asset("ANIM", "anim/octopus.zip"),
	Asset("MINIMAP_IMAGE", "octopus"),
}


local prefabs =
{
	"dubloon",
	"octopuschest",
	"seaweed",
	"seashell",
	"coral",
	"shark_fin",
	"blubber",
	"sail",
	"clothsail",
	"trawlnet",
	"seatrap",
	"telescope",
	"boat_lantern",
	"piratehat",
	"boatcannon",
}

local randomchestloot =
{
	"seaweed",
	"seaweed",
	"seaweed",
	"seaweed",
	"seaweed",
	"seashell",
	"seashell",
	"seashell",
	"coral",
	"coral",
	"coral",
	"shark_fin",
	"blubber",
}

local chestloot =
{
	californiaroll = "sail",
	seafoodgumbo = "clothsail",
	bisque = "trawlnet",
	jellyopop = "seatrap",
	ceviche = "telescope",
	surfnturf = "boat_lantern",
	lobsterbisque = "piratehat",
	lobsterdinner = "boatcannon",
}

-- only accept 1 trinket per day and pull up a chest that has multiple  dubloons + items (that we set per trinket)
-- only accept 1 seafood meal per day and pull up a chest with 1 dubloon + rando cheap items that come from a loot list
-- only accept 1 seafood crockpot meal per day and pull up a chest that has 1 dubloon + items (that we set per dish)

local function StartTrading(inst)
	if not inst.components.trader.enabled then
		inst.components.trader:Enable()
		inst.AnimState:PlayAnimation("sleep_pst")
		inst.AnimState:PushAnimation("idle", true)
	else
		inst.AnimState:PlayAnimation("idle", true)
	end
end

local function FinishedTrading(inst)
	if inst.components.trader.enabled then
		inst.components.trader:Disable()
		inst.AnimState:PlayAnimation("sleep_pre")
		inst.AnimState:PushAnimation("sleep_loop", true)
	else
		inst.AnimState:PushAnimation("sleep_loop", true)
	end
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/octopus_king/sleep")
end

local function OnIsNight(inst, isnight)
	if TheWorld.state.isday or TheWorld.state.isdusk then
		StartTrading(inst)
	end

	if TheWorld.state.isnight then
		FinishedTrading(inst)
	end
end



-- chest style
local function OnGetItemFromPlayer(inst, giver, item)
	local istrinket = item:HasTag("trinket") -- cache this, the item is destroyed by the time the reward is created.
	inst.components.trader:Disable()

	inst.AnimState:PlayAnimation("happy")
	inst.AnimState:PushAnimation("grabchest")
	inst.AnimState:PushAnimation("idle", true)
	inst:DoTaskInTime(13 * FRAMES,
		function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/octopus_king/happy") end)
	inst:DoTaskInTime(53 * FRAMES,
		function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/octopus_king/tenticle_out_water") end)
	inst:DoTaskInTime(71 * FRAMES,
		function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/octopus_king/tenticle_in_water") end)
	--	inst:DoTaskInTime(78*FRAMES, function(inst)	inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/seacreature_movement/splash_small") end)
	inst:DoTaskInTime(109 * FRAMES, function(inst)
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/octopus_king/tenticle_out_water")

		-- put things in a chest and throw that
		local down = TheCamera:GetDownVec()
		local spawnangle = math.atan2(down.z, down.x) + -50 * DEGREES
		local angle = math.atan2(down.z, down.x) + (math.random() * 60 - 30) * DEGREES
		local sp = math.random() * 3 + 2

		local chest = SpawnPrefab("octopuschest")
		local pt = Vector3(inst.Transform:GetWorldPosition()) +
			Vector3(2 * math.cos(spawnangle), 2, 2 * math.sin(spawnangle))
		chest.Transform:SetPosition(pt:Get())
		chest.Physics:SetVel(sp * math.cos(angle), math.random() * 2 + 9, sp * math.sin(angle))
		--		chest.components.inventoryitem:OnStartFalling()
		chest.AnimState:PlayAnimation("air_loop", true)
		--		chest.components.floatable:SetOnHitWaterFn(function()
		--			chest.AnimState:PlayAnimation("land")
		chest.AnimState:PushAnimation("closed", true)
		--		end)

		if not istrinket then
			local single = SpawnPrefab("dubloon")
			chest.components.container:GiveItem(single, nil, nil, true, false)

			if chestloot[item.prefab] then
				local goodreward = SpawnPrefab(chestloot[item.prefab])
				chest.components.container:GiveItem(goodreward, nil, nil, true, false)
			else
				local dubloonvalue = math.min(item.components.tradable.goldvalue, 2)
				for i = 1, dubloonvalue do
					local loot = SpawnPrefab(randomchestloot[math.random(1, #randomchestloot)])
					chest.components.container:GiveItem(loot, nil, nil, true, false)
				end
			end
		else
			-- trinkets give out dubloons only
			for i = 1, item.components.tradable.goldvalue do
				local loot = SpawnPrefab("dubloon")
				chest.components.container:GiveItem(loot, nil, nil, true, false)
			end
		end

		--Give Woodlegs Key 2 if player needs it!

		--		if not TheSim:FindFirstEntityWithTag("woodlegs_key2") and not Profile:IsCharacterUnlocked("woodlegs") then
		--			if math.random() < 0.1 then
		--	        	local loot = SpawnPrefab("woodlegs_key2")
		--	        	chest.components.container:GiveItem(loot, nil, nil, true, false)
		--	        end
		--        end
	end)

	inst.happy = true
	if inst.endhappytask then
		inst.endhappytask:Cancel()
	end
	inst.endhappytask = inst:DoTaskInTime(5, function(inst)
		inst.happy = false
		inst.endhappytask = nil

		FinishedTrading(inst)
	end)
end

local function OnRefuseItem(inst, giver, item)
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/octopus_king/reject")
	inst.AnimState:PlayAnimation("unimpressed")
	inst.AnimState:PushAnimation("idle", true)
	inst.happy = false
end

local function OnLoad(inst, data)
	if not inst.components.trader.enabled then
		FinishedTrading(inst)
	end
end

local function OnSave(inst, data)
	data.revelado = inst.revelado
end

local function OnLoad(inst, data)
	if data and data.revelado then
		inst.revelado = data.revelado
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddNetwork()

	inst.OnLoad = OnLoad

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetPriority(5)
	minimap:SetIcon("octopus.tex")
	minimap:SetPriority(1)

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.DynamicShadow:SetSize(10, 5)

	MakeWaterObstaclePhysics(inst, 2, 2, 1.25)

	inst:AddTag("king")
	inst:AddTag("reidomar")
	inst.AnimState:SetBank("octopus")
	inst.AnimState:SetBuild("octopus")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("trader")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("trader")

	inst.components.trader:SetAcceptTest(
		function(inst, item)
			return (item.components.tradable.goldvalue and item.components.tradable.goldvalue > 0) or
				chestloot[item.prefab] ~= nil
		end)

	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem

	inst:WatchWorldState("isday", OnIsNight)
	inst:WatchWorldState("isnight", OnIsNight)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	return inst
end

return Prefab("common/objects/octopusking", fn, assets, prefabs)
