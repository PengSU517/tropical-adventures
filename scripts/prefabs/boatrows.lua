require "prefabutil"

local assets = {
	Asset("ANIM", "anim/boat_hud_encrusted.zip"),
	Asset("ANIM", "anim/boat_hud_cargo.zip"),
	Asset("ANIM", "anim/boat_hud_row.zip"),
	Asset("ANIM", "anim/boat_inspect_encrusted.zip"),
	Asset("ANIM", "anim/boat_inspect_cargo.zip"),
	Asset("ANIM", "anim/boat_inspect_raft.zip"),
	Asset("ANIM", "anim/boat_inspect_row.zip"),
	Asset("ANIM", "anim/corkboat.zip"),
	Asset("ANIM", "anim/pirate_boat_build.zip"),
	Asset("ANIM", "anim/raft_basic.zip"),
	Asset("ANIM", "anim/raft_build.zip"),
	Asset("ANIM", "anim/raft_log_build.zip"),
	Asset("ANIM", "anim/raft_surfboard_build.zip"),
	Asset("ANIM", "anim/rowboat_armored_build.zip"),
	Asset("ANIM", "anim/rowboat_basic.zip"),
	Asset("ANIM", "anim/rowboat_build.zip"),
	Asset("ANIM", "anim/rowboat_cargo_build.zip"),
	Asset("ANIM", "anim/rowboat_encrusted_build.zip"),
	Asset("ANIM", "anim/swap_lantern_boat.zip"),
	Asset("ANIM", "anim/swap_sail.zip"),
}

local function OnSave(inst, data)

end

local function OnLoad(inst, data)
	inst:DoTaskInTime(0, function(inst)
		local owner = inst.components.inventoryitem.owner
		if owner ~= nil then
			owner.components.inventory:DropItem(inst)
			owner.components.driver:BoatJump(owner, inst)
		end
	end)
end

local function OnHammered(inst)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	SpawnAt("collapse_small", inst)
	for _, v in ipairs(inst.loottable or {}) do
		Launch(SpawnAt(v, inst), inst, 1)
	end
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst.components.container:DropEverything()
	inst:Remove()
end

local function OnItemGet(inst, data)
	local owner = inst.components.inventoryitem.owner
	local sailslot = inst.components.container:GetItemInSlot(1)
	local luzslot = inst.components.container:GetItemInSlot(2)

	local model = inst
	if owner and owner.boat_proxy then
		model = owner.boat_proxy
	end

	model.AnimState:ClearOverrideSymbol("swap_sail")
	model.AnimState:ClearOverrideSymbol("swap_propeller")
	model.AnimState:ClearOverrideSymbol("swap_lantern")
	model.AnimState:ClearOverrideSymbol("swap_trawlnet")

	if sailslot then
		model.AnimState:OverrideSymbol(sailslot.symboltooverride, sailslot.AnimState:GetBuild() or sailslot.build,
			sailslot.symbol)
	end

	if sailslot and sailslot:HasTag("sail") then
		inst:AddTag("sail")
		if owner then
			owner:AddTag("sail")
		end
	else
		inst:RemoveTag("sail")
		if owner then
			owner:RemoveTag("sail")
		end
	end

	if luzslot then
		model.AnimState:OverrideSymbol(luzslot.symboltooverride, luzslot.AnimState:GetBuild() or luzslot.build,
			luzslot.symbol)
	end

	if luzslot and luzslot:HasTag("boatlight") then luzslot:AddTag("nonavio") end
	if luzslot then luzslot.navio = inst end
	if sailslot then sailslot.navio = inst end
end

local function onequip(inst, owner)
	-- inst:AddTag("boat_occupied")
	if not TheWorld.ismastersim then return end
	inst.components.container:Close(owner)
	local proxy = SpawnAt(inst.prefab .. "_proxy" or "rowboat_proxy", owner)
	if proxy then
		proxy.entity:SetParent(owner.entity)
		owner.boat_proxy = proxy
		proxy.Transform:SetPosition(0, -0.1, 0)
		proxy.components.container_proxy:SetMaster(inst)
		proxy.components.container_proxy:Open(owner)
		proxy.Transform:SetRotation(inst.Transform:GetRotation())
		OnItemGet(inst)

		if inst:HasTag("surfboard") then
			owner:AddTag("surf")
		end
	end
end

local function onunequip(inst, owner)
	local proxy = owner.boat_proxy
	if proxy then
		inst.Transform:SetRotation(proxy.Transform:GetRotation())
		proxy.entity:SetParent(nil)
		owner.boat_proxy = nil
		proxy:Remove()
	end
	owner:RemoveTag("surf")
	OnItemGet(inst)
end

local function OnCollapsed(inst)
	local collapse = SpawnAt(inst.collapse, inst)
	SpawnAt("collapse_small", inst)
	if not inst.components.container or inst.components.container:IsEmpty() then
		inst:Remove()
		return
	end
	collapse:SetChest(inst)
end





local function makeBoatFn(config)
	return function()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.Transform:SetFourFaced()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		inst.AnimState:SetBank(config.bank or "rowboat")
		inst.banc = config.bank or "rowboat"
		inst.AnimState:SetBuild(config.build)
		inst.AnimState:PlayAnimation("run_loop", true)
		inst.overridebuild = config.build

		inst.entity:AddMiniMapEntity()
		inst.MiniMapEntity:SetIcon(config.icon)

		MakeWaterObstaclePhysics(inst, 0.5, 2, 1.25)

		inst:AddTag("boatsw")
		inst:AddTag("barcoapto")
		inst:AddTag("aquatic")
		inst:AddTag("ignorewalkableplatforms")
		inst:AddTag("outofreach")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then return inst end


		inst:AddComponent("interactions")


		-- Set uses and armor
		inst:AddComponent("finiteuses")
		inst:AddComponent("armor")
		inst.components.armor:SetKeepOnFinished(true)
		inst.components.finiteuses:SetOnFinished(function(inst) end)
		inst.components.finiteuses:SetMaxUses(config.maxuses)
		inst.components.finiteuses:SetUses(config.maxuses)
		inst.components.armor:InitCondition(config.maxuses, 0.99)

		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(3)
		inst.components.workable:SetOnFinishCallback(OnHammered)


		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.cangoincontainer = false
		inst.components.inventoryitem.canbepickedup = false
		inst:AddComponent("equippable")
		inst.components.equippable.equipslot = EQUIPSLOTS.BARCO
		inst.components.equippable:SetOnEquip(onequip)
		inst.components.equippable:SetOnUnequip(onunequip)

		-- Set container widget
		inst:AddComponent("container")
		inst.components.container:WidgetSetup(config.name or "rowboat")

		inst:ListenForEvent("itemget", OnItemGet)
		inst:ListenForEvent("itemlose", OnItemGet)


		inst.OnCollapse = OnCollapsed
		inst.OnHammer = OnHammered
		inst.OnLoad = OnLoad
		inst.OnSave = OnSave

		-- Optional: remove on finished
		if config.onfinished then
			inst.components.finiteuses:SetOnFinished(inst.Remove)
		end

		-- Collapse settings
		inst.collapse = config.collapse
		inst.loottable = config.loottable
		inst.useamount = config.useamount

		-- Add custom tags
		if config.tags then
			for _, tag in ipairs(config.tags) do
				inst:AddTag(tag)
			end
		end

		return inst
	end
end

local function makeFakeBoatFn(config)
	return function()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.Transform:SetFourFaced()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		inst.AnimState:SetBank(config.bank or "rowboat")
		inst.banc = config.bank or "rowboat"
		inst.AnimState:SetBuild(config.build)
		inst.AnimState:PlayAnimation("run_loop", true)
		inst.overridebuild = config.build
		-- inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
		inst.AnimState:SetSortOrder(0)

		inst:SetPrefabNameOverride(config.name)

		-- inst:AddTag("NOCLICK")
		inst:AddTag("boat_proxy")
		inst:AddComponent("container_proxy")
		inst.components.container_proxy:SetCanBeOpened(false)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then return inst end

		-- Set container widget
		inst:AddComponent("interactions")
		inst:AddComponent("inspectable")


		return inst
	end
end

local prefabs = {}

for _, boat in pairs(require("datadefs/boat_defs")) do
	table.insert(prefabs, Prefab(boat.name, makeBoatFn(boat), assets))
	table.insert(prefabs, Prefab(boat.name .. "_proxy", makeFakeBoatFn(boat), assets))
end

return unpack(prefabs)
