local sea_assets =
{
	Asset("ANIM", "anim/trap_sea.zip"),
	Asset("SOUND", "sound/common.fsb"),
}

local seasounds =
{
	close = "dontstarve/common/trap_close",
	rustle = "dontstarve/common/trap_rustle",
}

local function ondropped(inst)
	local map = TheWorld.Map
	local x, y, z = inst.Transform:GetWorldPosition()
	local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
	if TileGroupManager:IsOceanTile(ground) then
		inst.components.trap:Set()
		inst.sg:GoToState("idle")
	else
		inst.sg:GoToState("idle_ground")--Disable trap	
	end
end

local function onfinished(inst)
	inst:Remove()
end

local function onharvested(inst)
	if inst.components.finiteuses then
		inst.components.finiteuses:Use(1)
	end
end

local function sea_onbaited(inst, bait)
	inst:PushEvent("baited")
	bait:Hide()
end

local function sea_onpickup(inst, doer)
	if inst.components.trap and inst.components.trap.bait and doer.components.inventory then
		inst.components.trap.bait:Show()
		doer.components.inventory:GiveItem(inst.components.trap.bait)
	end
end

local function seafn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon("seatrap.tex")

    MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("trap_sea")
	inst.AnimState:SetBuild("trap_sea")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("trap")
	inst:AddTag("lobstertrap")
	--	MakeInventoryFloatable(inst)
	--	inst:AddTag("ignorewalkableplatforms")	

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.sounds = seasounds

	inst:AddComponent("inspectable")

	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(10)
	inst.components.finiteuses:SetUses(10)
	inst.components.finiteuses:SetOnFinished(onfinished)

	inst:AddComponent("trap")
	inst.components.trap.targettag = "lobster"
	inst.components.trap:SetOnHarvestFn(onharvested)
	inst.components.trap.baitsortorder = 1

	inst.components.trap.water = true
	inst.components.trap.onbaited = sea_onbaited
	inst.components.trap.range = 2

	inst:AddComponent("inventoryitem")
	--	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem:SetOnPickupFn(sea_onpickup)
	inst.components.inventoryitem:SetOnDroppedFn(ondropped)

	inst.no_wet_prefix = true

	inst:SetStateGraph("SGseatrap")

	inst:DoTaskInTime(0, ondropped)

	return inst
end

return Prefab("seatrap", seafn, sea_assets)
