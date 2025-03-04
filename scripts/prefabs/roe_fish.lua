require "tuning"

local COMMON = 3
local UNCOMMON = 1
local RARE = .5

ROE_FISH =
{

	fish2 = { -- purple grouper
		seedweight = COMMON,
		health = TUNING.HEALING_TINY,
		cooked_health = TUNING.HEALING_SMALL,
		hunger = TUNING.CALORIES_SMALL,
		cooked_hunger = TUNING.CALORIES_SMALL,
		perishtime = TUNING.PERISH_MED,
		cooked_perishtime = TUNING.PERISH_FAST,
		sanity = 0,
		cooked_sanity = 0,
		createPrefab = true,
		sign = "buoy_sign_2",

		anim = "fish2",
		build = "fish2",
		state = "idle",

		cooked_anim = "fish2",
		cooked_build = "fish2",
		cooked_state = "cooked",

		boost_surf = true,
	},


	fish3 = { -- purple grouper
		seedweight = UNCOMMON,
		health = TUNING.HEALING_TINY,
		cooked_health = TUNING.HEALING_SMALL,
		hunger = TUNING.CALORIES_SMALL,
		cooked_hunger = TUNING.CALORIES_SMALL,
		perishtime = TUNING.PERISH_MED,
		cooked_perishtime = TUNING.PERISH_FAST,
		sanity = 0,
		cooked_sanity = 0,
		createPrefab = true,
		sign = "buoy_sign_3",

		anim = "fish3",
		build = "fish3",
		state = "idle",

		cooked_anim = "fish3",
		cooked_build = "fish3",
		cooked_state = "cooked",

		boost_surf = true,
	},

	fish4 = { -- Pierrot fish
		seedweight = UNCOMMON,
		health = TUNING.HEALING_TINY,
		cooked_health = TUNING.HEALING_SMALL,
		hunger = TUNING.CALORIES_SMALL,
		cooked_hunger = TUNING.CALORIES_SMALL,
		perishtime = TUNING.PERISH_MED,
		cooked_perishtime = TUNING.PERISH_FAST,
		sanity = 0,
		cooked_sanity = 0,
		createPrefab = true,
		sign = "buoy_sign_4",

		anim = "fish4",
		build = "fish4",
		state = "idle",

		cooked_anim = "fish4",
		cooked_build = "fish4",
		cooked_state = "cooked",

		boost_dry = true,

	},

	fish5 = { -- Neon Quattro
		seedweight = UNCOMMON,
		health = TUNING.HEALING_TINY,
		cooked_health = TUNING.HEALING_SMALL,
		hunger = TUNING.CALORIES_SMALL,
		cooked_hunger = TUNING.CALORIES_SMALL,
		perishtime = TUNING.PERISH_MED,
		cooked_perishtime = TUNING.PERISH_FAST,
		sanity = 0,
		cooked_sanity = 0,
		createPrefab = true,
		sign = "buoy_sign_5",

		anim = "fish5",
		build = "fish5",
		state = "idle",

		cooked_anim = "fish5",
		cooked_build = "fish5",
		cooked_state = "cooked",

		boost_cool = true,
	},

	fish6 = { -- Neon Quattro
		seedweight = UNCOMMON,
		health = TUNING.HEALING_TINY,
		cooked_health = TUNING.HEALING_SMALL,
		hunger = TUNING.CALORIES_SMALL,
		cooked_hunger = TUNING.CALORIES_SMALL,
		perishtime = TUNING.PERISH_MED,
		cooked_perishtime = TUNING.PERISH_FAST,
		sanity = 0,
		cooked_sanity = 0,
		createPrefab = true,
		sign = "buoy_sign_5",

		anim = "fish6",
		build = "fish6",
		state = "idle",

		cooked_anim = "fish6",
		cooked_build = "fish6",
		cooked_state = "cooked",

	},

	fish7 = { -- Neon Quattro
		seedweight = UNCOMMON,
		health = TUNING.HEALING_TINY,
		cooked_health = TUNING.HEALING_SMALL,
		hunger = TUNING.CALORIES_SMALL,
		cooked_hunger = TUNING.CALORIES_SMALL,
		perishtime = TUNING.PERISH_MED,
		cooked_perishtime = TUNING.PERISH_FAST,
		sanity = 0,
		cooked_sanity = 0,
		createPrefab = true,
		sign = "buoy_sign_5",

		anim = "fish7",
		build = "fish7",
		state = "idle",

		cooked_anim = "fish7",
		cooked_build = "fish7",
		cooked_state = "cooked",

	},

	coi = { -- Neon Quattro
		seedweight = UNCOMMON,
		health = TUNING.HEALING_TINY,
		cooked_health = TUNING.HEALING_SMALL,
		hunger = TUNING.CALORIES_SMALL,
		cooked_hunger = TUNING.CALORIES_SMALL,
		perishtime = TUNING.PERISH_MED,
		cooked_perishtime = TUNING.PERISH_FAST,
		sanity = 0,
		cooked_sanity = 0,
		createPrefab = true,
		sign = "buoy_sign_5",

		anim = "coi",
		build = "coi",
		state = "idle",

		cooked_anim = "coi",
		cooked_build = "coi",
		cooked_state = "cooked",


	},

	salmon = { -- Neon Quattro
		seedweight = UNCOMMON,
		health = TUNING.HEALING_TINY,
		cooked_health = TUNING.HEALING_SMALL,
		hunger = TUNING.CALORIES_SMALL,
		cooked_hunger = TUNING.CALORIES_SMALL,
		perishtime = TUNING.PERISH_MED,
		cooked_perishtime = TUNING.PERISH_FAST,
		sanity = 0,
		cooked_sanity = 0,
		createPrefab = true,
		sign = "buoy_sign_5",

		anim = "salmon",
		build = "salmon",
		state = "idle",

		cooked_anim = "salmon",
		cooked_build = "salmon",
		cooked_state = "cooked",

	},

	-- ballphinocean = { -- Neon Quattro
	-- 	seedweight = UNCOMMON,
	-- 	health = TUNING.HEALING_TINY,
	-- 	cooked_health = TUNING.HEALING_SMALL,
	-- 	hunger = TUNING.CALORIES_SMALL,
	-- 	cooked_hunger = TUNING.CALORIES_SMALL,
	-- 	perishtime = TUNING.PERISH_MED,
	-- 	cooked_perishtime = TUNING.PERISH_FAST,
	-- 	sanity = 0,
	-- 	cooked_sanity = 0,
	-- 	createPrefab = false,
	-- 	sign = "buoy_sign_5",

	-- 	anim = "ballphinocean",
	-- 	build = "ballphinocean",
	-- 	state = "idle",

	-- 	cooked_anim = "ballphinocean",
	-- 	cooked_build = "ballphinocean",
	-- 	cooked_state = "cooked",

	-- },

	-- mecfish = { -- Neon Quattro
	-- 	seedweight = UNCOMMON,
	-- 	health = TUNING.HEALING_TINY,
	-- 	cooked_health = TUNING.HEALING_SMALL,
	-- 	hunger = TUNING.CALORIES_SMALL,
	-- 	cooked_hunger = TUNING.CALORIES_SMALL,
	-- 	perishtime = TUNING.PERISH_MED,
	-- 	cooked_perishtime = TUNING.PERISH_FAST,
	-- 	sanity = 0,
	-- 	cooked_sanity = 0,
	-- 	createPrefab = false,
	-- 	sign = "buoy_sign_5",

	-- 	anim = "mecfish",
	-- 	build = "mecfish",
	-- 	state = "idle",

	-- 	cooked_anim = "mecfish",
	-- 	cooked_build = "mecfish",
	-- 	cooked_state = "cooked",

	-- },

	-- goldfish = { -- Neon Quattro
	-- 	seedweight = UNCOMMON,
	-- 	health = TUNING.HEALING_TINY,
	-- 	cooked_health = TUNING.HEALING_SMALL,
	-- 	hunger = TUNING.CALORIES_SMALL,
	-- 	cooked_hunger = TUNING.CALORIES_SMALL,
	-- 	perishtime = TUNING.PERISH_MED,
	-- 	cooked_perishtime = TUNING.PERISH_FAST,
	-- 	sanity = 0,
	-- 	cooked_sanity = 0,
	-- 	createPrefab = false,
	-- 	sign = "buoy_sign_5",

	-- 	anim = "goldfish",
	-- 	build = "goldfish",
	-- 	state = "idle",

	-- 	cooked_anim = "goldfish",
	-- 	cooked_build = "goldfish",
	-- 	cooked_state = "cooked",

	-- },

	-- whaleblueocean = { -- Neon Quattro
	-- 	seedweight = UNCOMMON,
	-- 	health = TUNING.HEALING_TINY,
	-- 	cooked_health = TUNING.HEALING_SMALL,
	-- 	hunger = TUNING.CALORIES_SMALL,
	-- 	cooked_hunger = TUNING.CALORIES_SMALL,
	-- 	perishtime = TUNING.PERISH_MED,
	-- 	cooked_perishtime = TUNING.PERISH_FAST,
	-- 	sanity = 0,
	-- 	cooked_sanity = 0,
	-- 	createPrefab = false,
	-- 	sign = "buoy_sign_5",

	-- 	anim = "whaleblueocean",
	-- 	build = "whaleblueocean",
	-- 	state = "idle",

	-- 	cooked_anim = "whaleblueocean",
	-- 	cooked_build = "whaleblueocean",
	-- 	cooked_state = "cooked",

	-- },

	-- dogfishocean = { -- Neon Quattro
	-- 	seedweight = UNCOMMON,
	-- 	health = TUNING.HEALING_TINY,
	-- 	cooked_health = TUNING.HEALING_SMALL,
	-- 	hunger = TUNING.CALORIES_SMALL,
	-- 	cooked_hunger = TUNING.CALORIES_SMALL,
	-- 	perishtime = TUNING.PERISH_MED,
	-- 	cooked_perishtime = TUNING.PERISH_FAST,
	-- 	sanity = 0,
	-- 	cooked_sanity = 0,
	-- 	createPrefab = false,
	-- 	sign = "buoy_sign_5",

	-- 	anim = "dogfishocean",
	-- 	build = "dogfishocean",
	-- 	state = "idle",

	-- 	cooked_anim = "dogfishocean",
	-- 	cooked_build = "dogfishocean",
	-- 	cooked_state = "cooked",

	-- },

	-- swordfishjocean = { -- Neon Quattro
	-- 	seedweight = UNCOMMON,
	-- 	health = TUNING.HEALING_TINY,
	-- 	cooked_health = TUNING.HEALING_SMALL,
	-- 	hunger = TUNING.CALORIES_SMALL,
	-- 	cooked_hunger = TUNING.CALORIES_SMALL,
	-- 	perishtime = TUNING.PERISH_MED,
	-- 	cooked_perishtime = TUNING.PERISH_FAST,
	-- 	sanity = 0,
	-- 	cooked_sanity = 0,
	-- 	createPrefab = false,
	-- 	sign = "buoy_sign_5",

	-- 	anim = "swordfishjocean",
	-- 	build = "swordfishjocean",
	-- 	state = "idle",

	-- 	cooked_anim = "swordfishjocean",
	-- 	cooked_build = "swordfishjocean",
	-- 	cooked_state = "cooked",

	-- },

	-- swordfishjocean2 = { -- Neon Quattro
	-- 	seedweight = UNCOMMON,
	-- 	health = TUNING.HEALING_TINY,
	-- 	cooked_health = TUNING.HEALING_SMALL,
	-- 	hunger = TUNING.CALORIES_SMALL,
	-- 	cooked_hunger = TUNING.CALORIES_SMALL,
	-- 	perishtime = TUNING.PERISH_MED,
	-- 	cooked_perishtime = TUNING.PERISH_FAST,
	-- 	sanity = 0,
	-- 	cooked_sanity = 0,
	-- 	createPrefab = false,
	-- 	sign = "buoy_sign_5",

	-- 	anim = "swordfishjocean2",
	-- 	build = "swordfishjocean2",
	-- 	state = "idle",

	-- 	cooked_anim = "swordfishjocean2",
	-- 	cooked_build = "swordfishjocean2",
	-- 	cooked_state = "cooked",

	-- },

	-- sharxocean = { -- Neon Quattro
	-- 	seedweight = UNCOMMON,
	-- 	health = TUNING.HEALING_TINY,
	-- 	cooked_health = TUNING.HEALING_SMALL,
	-- 	hunger = TUNING.CALORIES_SMALL,
	-- 	cooked_hunger = TUNING.CALORIES_SMALL,
	-- 	perishtime = TUNING.PERISH_MED,
	-- 	cooked_perishtime = TUNING.PERISH_FAST,
	-- 	sanity = 0,
	-- 	cooked_sanity = 0,
	-- 	createPrefab = false,
	-- 	sign = "buoy_sign_5",

	-- 	anim = "sharxocean",
	-- 	build = "sharxocean",
	-- 	state = "idle",

	-- 	cooked_anim = "sharxocean",
	-- 	cooked_build = "sharxocean",
	-- 	cooked_state = "cooked",

	-- },

}

local function stopkicking(inst)
	if inst.floptask then
		inst.floptask:Cancel()
		inst.floptask = nil
	end
	inst.AnimState:PlayAnimation("dead")
end

local function flopsound(inst)
	inst.floptask = inst:DoTaskInTime(10 / 30, function()
		inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishland")
		if inst.floptask then
			inst.floptask:Cancel()
			inst.floptask = nil
		end
		inst.floptask = inst:DoTaskInTime(12 / 30, function()
			inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishland")
		end)
	end)
end

local function MakeFish(name, has_cooked, has_seeds)
	local assets =
	{
		Asset("ANIM", "anim/" .. name .. ".zip"),
	}
	local assets_cooked =
	{
		Asset("ANIM", "anim/" .. name .. ".zip"),
	}

	local assets_seeds =
	{
		Asset("ANIM", "anim/roe.zip"),
	}

	local prefabs =
	{
		name .. "_cooked",
		"spoiled_food",
	}

	if has_seeds then
		table.insert(prefabs, name .. "_seeds")
	end

	local function fn_seeds()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst)

		inst.AnimState:SetBank("seeds")
		inst.AnimState:SetBuild("seeds")
		inst.AnimState:SetRayTestOnBB(true)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("edible")
		inst.components.edible.foodtype = "SEEDS"

		inst:AddComponent("tradable")

		inst.AnimState:PlayAnimation("idle")
		inst.components.edible.healthvalue = TUNING.HEALING_TINY / 2
		inst.components.edible.hungervalue = TUNING.CALORIES_TINY

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		inst:AddComponent("cookable")
		inst.components.cookable.product = "seeds_cooked"

		inst:AddComponent("bait")
		inst:AddComponent("plantable")
		inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME
		inst.components.plantable.product = name

		MakeHauntableLaunchAndPerish(inst)

		return inst
	end

	local function OnEatenboost_dry(inst, eater)
		if eater ~= nil and eater:IsValid() and eater.components.locomotor ~= nil then
			if eater._tropicalbouillabaisse_speedmulttask ~= nil then
				eater._tropicalbouillabaisse_speedmulttask:Cancel()
			end
			local debuffkey = "tropicalbouillabaisse"
			eater._tropicalbouillabaisse_speedmulttask =

				eater:DoTaskInTime(60, function(i)
					i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey)
					i._tropicalbouillabaisse_speedmulttask = nil
				end)

			eater.components.locomotor:SetExternalSpeedMultiplier(eater, debuffkey, 1.165)
		end
	end

	local function OnEatenboost_surf(inst, eater)
		if eater ~= nil and eater:IsValid() and eater.components.locomotor ~= nil then
			if eater._tropicalbouillabaisse_speedmulttask ~= nil then
				eater._tropicalbouillabaisse_speedmulttask:Cancel()
			end
			local debuffkey = "tropicalbouillabaisse"
			eater._tropicalbouillabaisse_speedmulttask =

				eater:DoTaskInTime(60, function(i)
					i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey)
					i._tropicalbouillabaisse_speedmulttask = nil
				end)

			eater.components.locomotor:SetExternalSpeedMultiplier(eater, debuffkey, 1.33)
		end
	end

	local function OnEatenboost_cool(inst, eater)
		if eater and eater.components.temperature then
			local current_temp = eater.components.temperature:GetCurrent()
			local new_temp = math.max(current_temp - 8, TUNING.STARTING_TEMP)
			eater.components.temperature:SetTemperature(new_temp)
		end
	end

	local function fn(Sim)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		inst.entity:AddSoundEmitter()

		MakeInventoryPhysics(inst)
	    MakeInventoryFloatable(inst)
		inst.AnimState:SetBank(name)
		inst.AnimState:SetBuild(name)
		inst.AnimState:PlayAnimation("idle")
		-- inst.AnimState:PushAnimation("dead")


		-- inst.build = rodbuild --This is used within SGwilson, sent from an event in fishingrod.lua

		inst:AddTag("meat")
		inst:AddTag("fishmeat")
		inst:AddTag("fish")
		inst:AddTag("catfood")
		inst:AddTag("packimfood")
		inst:AddTag("cru")

		local dryablefish = name == "fish2" or "fish3" or "fish4" or "fish5" or "coi" or "salmon"

		if dryablefish then
			inst:AddTag("dryable")
		end

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = ROE_FISH[name].health
		inst.components.edible.hungervalue = ROE_FISH[name].hunger
		inst.components.edible.sanityvalue = ROE_FISH[name].sanity or 0
		inst.components.edible.ismeat = true
		inst.components.edible.foodtype = FOODTYPE.MEAT

		if ROE_FISH[name].boost_surf then
			inst.components.edible:SetOnEatenFn(OnEatenboost_surf)
		end

		if ROE_FISH[name].boost_dry then
			inst.components.edible:SetOnEatenFn(OnEatenboost_dry)
		end

		if ROE_FISH[name].boost_cool then
			inst.components.edible:SetOnEatenFn(OnEatenboost_cool)
		end

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(ROE_FISH[name].perishtime)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		inst:AddComponent("bait")

		inst:AddComponent("tradable")

		if dryablefish then
			inst:AddComponent("dryable")
			inst.components.dryable:SetProduct("smallmeat_dried")
			inst.components.dryable:SetDryTime(TUNING.DRY_FAST)
		end

		inst:AddComponent("cookable")
		inst.components.cookable.product = has_cooked and name .. "_cooked" or "fishmeat_cooked"

		inst:DoTaskInTime(5, stopkicking)
		inst.components.inventoryitem:SetOnPickupFn(stopkicking)
		inst.OnLoad = stopkicking

		inst:ListenForEvent("animover", function()
			if inst.AnimState:IsCurrentAnimation("idle") then
				flopsound(inst)
				inst.AnimState:PlayAnimation("idle")
			end
		end)
		flopsound(inst)
		MakeHauntableLaunchAndPerish(inst)

		return inst
	end

	local function fn_cooked(Sim)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst)

		inst.AnimState:SetBank(ROE_FISH[name].cooked_anim)
		inst.AnimState:SetBuild(ROE_FISH[name].cooked_build)
		inst.AnimState:PlayAnimation(ROE_FISH[name].cooked_state)

		inst:AddTag("meat")
		inst:AddTag("fishmeat")
		inst:AddTag("catfood")
		inst:AddTag("packimfood")

		inst:AddTag("cosido")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
		--inst.components.inventoryitem:ChangeImageName("fishtropical_cooked")

		inst:AddComponent("edible")
		inst.components.edible.ismeat = true
		inst.components.edible.foodtype = FOODTYPE.MEAT
		inst.components.edible.foodstate = "COOKED"
		inst.components.edible.healthvalue = ROE_FISH[name].cooked_health
		inst.components.edible.hungervalue = ROE_FISH[name].cooked_hunger
		inst.components.edible.sanityvalue = ROE_FISH[name].cooked_sanity or 0

		if ROE_FISH[name].boost_surf then
			inst.components.edible:SetOnEatenFn(OnEatenboost_surf)
		end

		if ROE_FISH[name].boost_dry then
			inst.components.edible:SetOnEatenFn(OnEatenboost_dry)
		end

		if ROE_FISH[name].boost_cool then
			inst.components.edible:SetOnEatenFn(OnEatenboost_cool)
		end

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(ROE_FISH[name].cooked_perishtime)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
		--inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD

		inst:AddComponent("bait")

        MakeHauntableLaunchAndPerish(inst)

		return inst
	end
	local base = Prefab("" .. name, fn, assets, prefabs)

	local cooked = has_cooked and Prefab("" .. name .. "_cooked", fn_cooked, assets_cooked) or nil
	local seeds = has_seeds and Prefab("" .. name .. "_seeds", fn_seeds, assets_seeds) or nil
	return base, cooked, seeds
end


local prefs = {}
for fishname, fishdata in pairs(ROE_FISH) do
	-- if fishdata.createPrefab == true then
	local fish, cooked, seeds = MakeFish(fishname, fishdata.createPrefab, false)
	table.insert(prefs, fish)
	table.insert(prefs, cooked)
	table.insert(prefs, seeds)
end

return unpack(prefs)
