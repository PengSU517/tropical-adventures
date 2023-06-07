local assets =
{
	Asset("ANIM", "anim/peach_kabobs.zip"),
	Asset("ATLAS", "images/inventoryimages/peach_kabobs.xml"),
	Asset("IMAGE", "images/inventoryimages/peach_kabobs.tex")
}

local prefabs = 
{
	"spoiled_food",
}



local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBuild("peach_kabobs")
		inst.AnimState:SetBank("peach_kabobs")
		inst.AnimState:PlayAnimation("idle", false)

		inst:AddTag("preparedfood")
		inst:AddTag("peachy")
		
	    MakeInventoryFloatable(inst)		

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = 3
		inst.components.edible.hungervalue = 75
		inst.components.edible.foodtype = FOODTYPE.MEAT
		inst.components.edible.sanityvalue = 5
		
		inst:AddComponent("inspectable")
		inst.wet_prefix = "soggy"
		
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/peach_kabobs.xml"

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)
		MakeHauntableLaunchAndPerish(inst)
		AddHauntableCustomReaction(inst, function(inst, haunter)
			--#HAUNTFIX
			--if math.random() <= TUNING.HAUNT_CHANCE_SUPERRARE then
				--if inst.components.burnable and not inst.components.burnable:IsBurning() then
					--inst.components.burnable:Ignite()
					--inst.components.hauntable.hauntvalue = TUNING.HAUNT_MEDIUM
					--inst.components.hauntable.cooldown_on_successful_haunt = false
					--return true
				--end
			--end
			return false
		end, true, false, true)
		---------------------        

		inst:AddComponent("bait")

		------------------------------------------------
		inst:AddComponent("tradable")
		
		------------------------------------------------  

		return inst
	end

return Prefab("peach_kabobs", fn, assets, prefabs) 
