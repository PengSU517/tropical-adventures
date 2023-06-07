local assets =
{
	Asset("ANIM", "anim/caramel_peach.zip"),
	Asset("ATLAS", "images/inventoryimages/caramel_peach.xml")
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
		MakeInventoryFloatable(inst)	

		inst.AnimState:SetBuild("caramel_peach")
		inst.AnimState:SetBank("caramel_peach")
		inst.AnimState:PlayAnimation("idle", false)

		inst:AddTag("preparedfood")
		inst:AddTag("peachy")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = 40
		inst.components.edible.hungervalue = 45
		inst.components.edible.foodtype = FOODTYPE.VEGGIE
		inst.components.edible.sanityvalue = 5

		local name = "caramel_peach"
		
		inst:AddComponent("inspectable")
		inst.wet_prefix = "soggy"
		
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/caramel_peach.xml"

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
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

return Prefab("caramel_peach", fn, assets, prefabs) 
