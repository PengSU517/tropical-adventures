--require "prefabutil"

local function ondeploy(inst, pt, deployer)
	if deployer and deployer.SoundEmitter then
		deployer.SoundEmitter:PlaySound("dontstarve/wilson/dig")
	end

	local map = TheWorld.Map
	local original_tile_type = map:GetTileAtPoint(pt:Get())
	local x, y = map:GetTileCoordsAtPoint(pt:Get())
	if x and y then
		map:SetTile(x,y, inst.data.tile)
		map:RebuildLayer( original_tile_type, x, y )
		map:RebuildLayer( inst.data.tile, x, y )
	end

	local minimap = TheWorld.minimap.MiniMap
	minimap:RebuildLayer(original_tile_type, x, y)
	minimap:RebuildLayer(inst.data.tile, x, y)

	inst.components.stackable:Get():Remove()
end

local prefabs =
{
	"gridplacer",
}

local function make_turf(data)
	assert(type(data) == "table")
	assert(type(data.name) == "string")
	if data.anim == nil then
		data.anim = data.name
	end
	assert(type(data.anim) == "string")
	if data.invname == nil then
		data.invname = data.name
	end
	assert(type(data.invname) == "string")
	assert(data.tile ~= nil)
	local GROUND_lookup = table.invert(GROUND)
	assert(GROUND_lookup[data.tile] ~= nil)

	local assets = {
--		Asset("ANIM", "anim/turf.zip"),
		Asset("ANIM", "anim/" .. data.anim .. ".zip"),
		Asset("IMAGE", "images/inventoryimages/" .. data.invname .. ".tex"),
		Asset("ATLAS", "images/inventoryimages/" .. data.invname .. ".xml"),
	}

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
	
		MakeInventoryPhysics(inst)
	
		inst:AddTag("groundtile")

		inst.AnimState:SetBank(data.anim)
		inst.AnimState:SetBuild(data.anim)
		--inst.AnimState:PlayAnimation(data.anim)
		inst.AnimState:PlayAnimation("idle")
		
		MakeInventoryFloatable(inst)			
	
		inst:AddTag("molebait")
		--MakeDragonflyBait(inst, 3)

		inst.entity:SetPristine()
	
		if not TheWorld.ismastersim then
			return inst
		end
	
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. data.invname .. ".xml"
		inst.components.inventoryitem.imagename = data.invname

		inst.data = data
	
		inst:AddComponent("bait")

		inst:AddComponent("fuel")
		inst.components.fuel.fuelvalue = TUNING.MED_FUEL
		MakeMediumBurnable(inst, TUNING.MED_BURNTIME)
		MakeSmallPropagator(inst)
		MakeHauntableLaunchAndIgnite(inst)

		inst:AddComponent("deployable")
		--inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
		inst.components.deployable.ondeploy = ondeploy
		inst.components.deployable:SetDeployMode(DEPLOYMODE.TURF)
		inst.components.deployable:SetUseGridPlacer(true)

		---------------------
		return inst
	end

	return Prefab("turf_" .. data.name, fn, assets, prefabs)
end

local turf = {
	{name = "windyturf",	tile = GROUND.WINDY},
}

local prefabs = {}
for k, v in ipairs(turf) do
    table.insert(prefabs, make_turf(v))
end

return unpack(prefabs)
