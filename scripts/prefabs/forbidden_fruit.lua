local assets =
{
	Asset("IMAGE", "images/inventoryimages/forbidden_fruit.tex"),
	Asset("ATLAS", "images/inventoryimages/forbidden_fruit.xml"),
	Asset("ANIM", "anim/forbidden_fruit.zip"),
}

local prefabs =
{
    "spoiled_food",
}

	local fruit = {"forbidden_fruit"}
	AddIngredientValues(fruit, {fruit=1}, true)

	local function IsCookingIngredient(forbidden_fruit)
	local name = "forbidden_fruit"
	if ingredients[name] then
		return true
	end

end

local function EatFn (inst, eater)
	local rnd = math.random() * 100
	if eater.components.sanity then
	
	if rnd <= 20 then
		eater.components.sanity:DoDelta(15)
		eater.components.health:DoDelta(10)
		eater.components.hunger:DoDelta(20)
	elseif rnd <= 50 then
		eater.components.sanity:DoDelta(5)
		eater.components.health:DoDelta(5)
		eater.components.hunger:DoDelta(5)
	elseif rnd <= 60 then
		eater.components.sanity:DoDelta(35)
		eater.components.health:DoDelta(35)
		eater.components.hunger:DoDelta(35)
	elseif rnd <= 80 then
		eater.components.sanity:DoDelta(100)
		eater.components.health:DoDelta(100)
		eater.components.hunger:DoDelta(200)
	else
		eater.components.sanity:DoDelta(-15)
		eater.components.health:DoDelta(-10)
		eater.components.hunger:DoDelta(-20)
	end 
	end
end

local function onmatured(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/farm_harvestable")
   	inst.AnimState:OverrideSymbol("swap_grown", "forbidden_fruit", "forbidden_fruit01")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBuild("forbidden_fruit")
    inst.AnimState:SetBank("forbidden_fruit")
    inst.AnimState:PlayAnimation("idle", false)

	local s = 0.85
	inst.Transform:SetScale(s,s,s)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.hungervalue = 0
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible.healthvalue = 0
	inst.components.edible:SetOnEatenFn(EatFn)

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "grilled_forbidden_fruit"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "forbidden_fruit_pit"

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/forbidden_fruit.xml"
	
    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("forbidden_fruit", fn, assets, prefabs)