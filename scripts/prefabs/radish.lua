local assets =
{
	Asset("ANIM", "anim/radish.zip"),
	Asset("ANIM", "anim/farm_soil.zip"),
	Asset("ANIM", "anim/farm_plant_turnip.zip"),
}

local prefabs =
{
	"radish",
}

local function onpickedfn(inst)
	inst:Remove()
end


local function fn(Sim)
	--Radish you eat is defined in veggies.lua
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("radish")
	inst.AnimState:SetBuild("radish")
	inst.AnimState:PlayAnimation("planted")
	inst.AnimState:SetRayTestOnBB(true)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
	inst.components.pickable:SetUp("radish", 10)
	inst.components.pickable.onpickedfn = onpickedfn

	inst.components.pickable.quickpick = true

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end

local function fn2(Sim)
	--Radish you eat is defined in veggies.lua
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("farm_plant_carrot")
	inst.AnimState:SetBuild("farm_plant_turnip")
	inst.AnimState:PlayAnimation("crop_full")
	inst.AnimState:OverrideSymbol("soil01", "farm_soil", "soil01")
	inst.AnimState:SetRayTestOnBB(true)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
	inst.components.pickable:SetUp("turnip", 10)
	inst.components.pickable.onpickedfn = onpickedfn

	inst.components.pickable.quickpick = true

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end

return Prefab("common/inventory/radish_planted", fn, assets),
	Prefab("common/inventory/turnip_planted", fn2, assets)
