local assets =
{
	Asset("ANIM", "anim/messagebottle.zip"),
	Asset("MINIMAP_IMAGE", "messageBottle"),
}

local function onunwrapped(inst, pos, doer)
	local davez = nil
	local x, y, z
	for k, v in pairs(Ents) do
		if v.prefab == "kraken" and v.revelado == nil then
			v.revelado = true
			davez = v
		end
	end
	if davez and davez.prefab == "kraken" then
		x, y, z = davez.Transform:GetWorldPosition()
		x = math.floor(x)
		z = math.floor(z)
		doer:DoTaskInTime(0, function()
			doer.player_classified.MapExplorer:RevealArea(x, 0, z)
			doer.components.inventory:GiveItem(SpawnPrefab("messagebottleempty_sw"))
		end)

		if doer.player_classified.revealtreasure then
			local val = (x + 16384) * 65536 + (z + 16384)
			doer.player_classified.revealtreasure:set_local(val)
			doer.player_classified.revealtreasure:set(val)
		end
		print(davez)
		print(x)
		print(z)
		inst:Remove()
		return
	end

	for k, v in pairs(Ents) do
		if v.prefab == "octopusking" and v.revelado == nil then
			v.revelado = true
			davez = v
		end
	end
	if davez and davez.prefab == "octopusking" then
		x, y, z = davez.Transform:GetWorldPosition()
		x = math.floor(x)
		z = math.floor(z)

		doer:DoTaskInTime(0, function()
			doer.player_classified.MapExplorer:RevealArea(x, 0, z)
			doer.components.inventory:GiveItem(SpawnPrefab("messagebottleempty_sw"))
		end)

		if doer.player_classified.revealtreasure then
			local val = (x + 16384) * 65536 + (z + 16384)
			doer.player_classified.revealtreasure:set_local(val)
			doer.player_classified.revealtreasure:set(val)
		end
		print(davez)
		print(x)
		print(z)
		inst:Remove()
		return
	end


	local map = TheWorld.Map
	local x, y
	local sx, sy = map:GetSize()

	repeat
		x = math.random(-sx, sx)
		y = math.random(-sy, sy)
		local tile = map:GetTileAtPoint(x, 0, y)
	until
		tile ~= GROUND.IMPASSABLE and
		tile ~= GROUND.OCEAN_COASTAL and
		tile ~= GROUND.OCEAN_COASTAL_SHORE and
		tile ~= GROUND.OCEAN_SWELL and
		tile ~= GROUND.OCEAN_ROUGH and
		tile ~= GROUND.OCEAN_BRINEPOOL and
		tile ~= GROUND.OCEAN_BRINEPOOL_SHORE and
		tile ~= GROUND.OCEAN_WATERLOG and
		tile ~= GROUND.OCEAN_HAZARDOUS

	SpawnPrefab("buriedtreasure").Transform:SetPosition(x, 0, y)

	doer:DoTaskInTime(0, function()
		doer.player_classified.MapExplorer:RevealArea(x, 0, y)
		doer.components.inventory:GiveItem(SpawnPrefab("messagebottleempty_sw"))
	end)

	if doer.player_classified.revealtreasure then
		local val = (x + 16384) * 65536 + (y + 16384)
		doer.player_classified.revealtreasure:set_local(val)
		doer.player_classified.revealtreasure:set(val)
		print(x)
		print(y)
	end

	inst:Remove()
end

local function OnBottle(inst, target, doer)
	if target.prefab == "gelblob_small_fx" then
		local targetpos = target:GetPosition()
		local x, y, z = inst.Transform:GetWorldPosition()
		inst.components.stackable:Get():Remove()
		target:Remove()

		local bottledinst = SpawnPrefab("gelblob_bottle")
		if doer and doer.components.inventory then
			doer.components.inventory:GiveItem(bottledinst, nil, targetpos)
		else
			bottledinst.Transform:SetPosition(x, y, z)
		end
		return true
	end
	return false
end

--------------------------------------------------------------------------
local function messagebottlefn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	anim:SetBank("messagebottle")
	anim:SetBuild("messagebottle")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("aquatic")
	inst:AddTag("messagebottle")
	inst:AddTag("nosteal")
	inst:AddTag("unwrappable")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")



	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(0)

	inst.no_wet_prefix = true
	--local minimap = inst.entity:AddMiniMapEntity() --temp

	--minimap:SetIcon("messageBottle.tex")

	inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(onunwrapped)

	return inst
end

local function emptybottlefn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	anim:SetBank("messagebottle")
	anim:SetBuild("messagebottle")
	inst.AnimState:PlayAnimation("idle_empty", true)
	inst:AddTag("aquatic")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")

	inst:AddComponent("bottler")
	inst.components.bottler:SetOnBottleFn(OnBottle)

	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(0)

	inst.no_wet_prefix = true

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	return inst
end

return Prefab("shipwrecked/objects/messagebottle_sw", messagebottlefn, assets),
	Prefab("shipwrecked/objects/messagebottleempty_sw", emptybottlefn, assets)
