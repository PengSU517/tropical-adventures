require "prefabutil"

local Assets =
{
	Asset("ATLAS", "images/inventoryimages/gem_seeds.xml"),
	Asset("IMAGE", "images/inventoryimages/gem_seeds.tex"),
}

local function test_ground(inst, pt)
	if(TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(pt:Get())) == GROUND.WINDY) then return true end --adicionado por vagner
	return false
end

local function ondeploy(inst, pt)
	local gem_flower = SpawnPrefab("gem_flower") 
		if gem_flower then 
				gem_flower.Transform:SetPosition(pt.x, pt.y, pt.z) 
				inst.components.stackable:Get():Remove()
				gem_flower.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
		end 
end

local function fn(Sim)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()	

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
	
	inst.AnimState:SetBank("seeds")
	inst.AnimState:SetBuild("seeds")	
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end

	inst:AddTag("gem_flower")
	
	inst:AddComponent("edible")
	inst.components.edible.hungervalue = 0
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible.healthvalue = 0

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
	inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
	inst.components.deployable.CanDeploy = test_ground

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/gem_seeds.xml"
	
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("bait")

	return inst
end

return 	Prefab( "common/inventory/gem_seeds", fn, Assets),
	MakePlacer( "common/gem_seeds_placer", "plant_normal", "plant_gem", "picked")