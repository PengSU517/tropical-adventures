require "prefabutil"

local Assets =
{
	Asset("ANIM", "anim/peach_pit.zip"),
	Asset("ATLAS", "images/inventoryimages/peach_pit.xml"),
	Asset("IMAGE", "images/inventoryimages/peach_pit.tex"),
}

local prefabs =
{
	"peach",
} 

local function ondeploy(inst, pt)

	local peach_tree0 = SpawnPrefab("peach_tree0") 
	
	if peach_tree0 then 
		peach_tree0.Transform:SetPosition(pt.x, pt.y, pt.z) 
		inst.components.stackable:Get():Remove()
		peach_tree0.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
	end 
	
end

local function fn(Sim)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()	

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("peach_pit")
	inst.AnimState:SetBuild("peach_pit")
	
    MakeInventoryFloatable(inst)		
	
	local s = 2
	inst.Transform:SetScale(s,s,s)
	
    if not TheWorld.ismastersim then
    return inst
end

    inst.entity:SetPristine()
	
	inst:AddComponent("edible")
	inst.components.edible.hungervalue = 12.5
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible.healthvalue = -10

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
	inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/peach_pit.xml"
	
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("bait")
	
	inst:AddComponent("plantable")
    inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME
    inst.components.plantable.product = "peach"

	return inst
end

return 	Prefab( "common/inventory/peach_pit", fn, Assets),
	MakePlacer( "common/peach_pit_placer", "peach_pit", "peach", "picked")