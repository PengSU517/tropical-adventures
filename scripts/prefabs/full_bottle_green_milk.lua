local assets =
{
    Asset("ANIM", "anim/bottle_green.zip"),
	Asset("IMAGE", "images/inventoryimages/full_bottle_green_milk.tex"),
	Asset("ATLAS", "images/inventoryimages/full_bottle_green_milk.xml"),
}

local assets1 = 
{
	Asset("ANIM", "anim/bottle_green.zip"),
	Asset("IMAGE", "images/inventoryimages/half_bottle_green_milk.tex"),
	Asset("ATLAS", "images/inventoryimages/half_bottle_green_milk.xml"),
}

local assets2 = 
{	
	Asset("ANIM", "anim/bottle_green.zip"),
	Asset("IMAGE", "images/inventoryimages/less_bottle_green_milk.tex"),
	Asset("ATLAS", "images/inventoryimages/less_bottle_green_milk.xml"),
}

local assets3 = 
{
	Asset("ANIM", "anim/bottle_green.zip"),
	Asset("IMAGE", "images/inventoryimages/bottle_green_youghurt.tex"),
	Asset("ATLAS", "images/inventoryimages/bottle_green_youghurt.xml"),
}

local function Full_EatFn(inst, eater)
	local x, y, z = inst.Transform:GetWorldPosition()
	local milk = SpawnPrefab("half_bottle_green_milk")
	local new_percent = inst.components.perishable:GetPercent()
	milk.Transform:SetPosition(x, y, z)
	milk.components.perishable:SetPercent(new_percent)
	if eater.components.inventory ~= nil then
		eater.components.inventory:GiveItem(milk)
	end
	if eater.components.talker ~= nil then
		eater.components.talker:Say("Two servings left.")
	end
end

local function Half_EatFn(inst, eater)
	local x, y, z = inst.Transform:GetWorldPosition()
	local milk = SpawnPrefab("less_bottle_green_milk")
	local new_percent = inst.components.perishable:GetPercent()
	milk.Transform:SetPosition(x, y, z)
	milk.components.perishable:SetPercent(new_percent)
	if eater.components.inventory ~= nil then
		eater.components.inventory:GiveItem(milk)
	end
	if eater.components.talker ~= nil then
		eater.components.talker:Say("One serving left.")
	end
end

local function Less_EatFn(inst, eater)
	local x, y, z = inst.Transform:GetWorldPosition()
	local milk = SpawnPrefab("empty_bottle_green")
	local a = math.random()
	if 	a >= 0.50 then
		milk.Transform:SetPosition(x, y, z)
		if eater.components.inventory ~= nil then
			eater.components.inventory:GiveItem(milk)
		end
		if eater.components.talker ~= nil then
			eater.components.talker:Say("All gone and I got the bottle back.")
		end
	else
		inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/glass_break")
		if eater.components.talker ~= nil then
			eater.components.talker:Say("All gone but the bottle broke.")
		end
	end
end

local function EatFn(inst, eater)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/glass_break")
	if eater.components.talker ~= nil then
		eater.components.talker:Say("The bottle broke.")
	end
end

local function full_milk()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    
    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBank("bottle_green")
    inst.AnimState:SetBuild("bottle_green")
    inst.AnimState:PlayAnimation("idle_milk_full")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeHauntableLaunch(inst)
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(480*4)
    inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "bottle_green_youghurt"
	
	inst:AddComponent("edible")
    inst.components.edible.hungervalue = 25
	inst.components.edible.healthvalue = 5
	inst.components.edible.sanityvalue = 15
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible:SetOnEatenFn(Full_EatFn)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/full_bottle_green_milk.xml"

    return inst
end

local function less_milk()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
    
    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBank("bottle_green")
    inst.AnimState:SetBuild("bottle_green")
    inst.AnimState:PlayAnimation("idle_milk_less")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeHauntableLaunch(inst)
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(480*4)
    inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "bottle_green_youghurt"
	
	inst:AddComponent("edible")
    inst.components.edible.hungervalue = 25
	inst.components.edible.healthvalue = 5
	inst.components.edible.sanityvalue = 15
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible:SetOnEatenFn(Less_EatFn)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/less_bottle_green_milk.xml"

    return inst
end

local function half_milk()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("bottle_green")
    inst.AnimState:SetBuild("bottle_green")
    inst.AnimState:PlayAnimation("idle_milk_half")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeHauntableLaunch(inst)
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(480*4)
    inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "bottle_green_youghurt"
	
	inst:AddComponent("edible")
    inst.components.edible.hungervalue = 25
	inst.components.edible.healthvalue = 5
	inst.components.edible.sanityvalue = 15
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible:SetOnEatenFn(Half_EatFn)

	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/half_bottle_green_milk.xml"

    return inst
end

local function youghurt()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
    
    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBank("bottle_green")
    inst.AnimState:SetBuild("bottle_green")
    inst.AnimState:PlayAnimation("idle_youghurt")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeHauntableLaunch(inst)
	
    inst:AddComponent("inspectable")
		
	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(480*6)
    inst.components.perishable:StartPerishing()
	
	inst:AddComponent("edible")
    inst.components.edible.hungervalue = 20
	inst.components.edible.healthvalue = 15
	inst.components.edible.sanityvalue = 15
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible:SetOnEatenFn(EatFn)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/bottle_green_youghurt.xml"

    return inst
end

return 	Prefab("full_bottle_green_milk", full_milk, assets),
		Prefab("half_bottle_green_milk", half_milk, assets1),
		Prefab("less_bottle_green_milk", less_milk, assets2),
		Prefab("bottle_green_youghurt", youghurt, assets3)