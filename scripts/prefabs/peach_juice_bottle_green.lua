local assets =
{
    Asset("ANIM", "anim/peach_juice_bottle_green.zip"),
	Asset("IMAGE", "images/inventoryimages/peach_juice_bottle_green.tex"),
	Asset("ATLAS", "images/inventoryimages/peach_juice_bottle_green.xml"),
}

local assets1 = 
{
	Asset("ANIM", "anim/peach_juice_bottle_green.zip"),
	Asset("IMAGE", "images/inventoryimages/peach_juice_bottle_green_most.tex"),
	Asset("ATLAS", "images/inventoryimages/peach_juice_bottle_green_most.xml"),
}

local assets2 = 
{
	Asset("ANIM", "anim/peach_juice_bottle_green.zip"),
	Asset("IMAGE", "images/inventoryimages/peach_juice_bottle_green_half.tex"),
	Asset("ATLAS", "images/inventoryimages/peach_juice_bottle_green_half.xml"),
}

local assets3 = 
{
	Asset("ANIM", "anim/peach_juice_bottle_green.zip"),
	Asset("IMAGE", "images/inventoryimages/peach_juice_bottle_green_less.tex"),
	Asset("ATLAS", "images/inventoryimages/peach_juice_bottle_green_less.xml"),
}

local function Full_EatFn(inst, eater)
	local x, y, z = inst.Transform:GetWorldPosition()
	local peach = SpawnPrefab("peach_juice_bottle_green_most")
	peach.Transform:SetPosition(x, y, z)
	if eater.components.inventory ~= nil then
		eater.components.inventory:GiveItem(peach)
	end
	if eater.components.talker ~= nil then
		eater.components.talker:Say("Refreshingly peachy with three servings left.")
	end
end

local function Most_EatFn(inst, eater)
	local x, y, z = inst.Transform:GetWorldPosition()
	local peach = SpawnPrefab("peach_juice_bottle_green_half")
	peach.Transform:SetPosition(x, y, z)
	if eater.components.inventory ~= nil then
		eater.components.inventory:GiveItem(peach)
	end
	if eater.components.talker ~= nil then
		eater.components.talker:Say("Refreshingly peachy with two servings left.")
	end
end

local function Half_EatFn(inst, eater)
	local x, y, z = inst.Transform:GetWorldPosition()
	local peach = SpawnPrefab("peach_juice_bottle_green_less")
	peach.Transform:SetPosition(x, y, z)
	if eater.components.inventory ~= nil then
		eater.components.inventory:GiveItem(peach)
	end
	if eater.components.talker ~= nil then
		eater.components.talker:Say("Refreshingly peachy with one serving left.")
	end
end

local function Less_EatFn(inst, eater)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/glass_break")
	if eater.components.talker ~= nil then
		eater.components.talker:Say("Refreshingly peachy but the bottle broke.")
	end
end

local function full()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)		
	
	local s = 2
	inst.Transform:SetScale(s,s,s)

    inst.AnimState:SetBank("peach_juice_bottle_green")
    inst.AnimState:SetBuild("peach_juice_bottle_green")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeHauntableLaunch(inst)
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("edible")
    inst.components.edible.hungervalue = 35
	inst.components.edible.healthvalue = 15
	inst.components.edible.sanityvalue = 5
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible:SetOnEatenFn(Full_EatFn)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/peach_juice_bottle_green.xml"

    return inst
end

local function most()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)		

    inst.AnimState:SetBank("peach_juice_bottle_green")
    inst.AnimState:SetBuild("peach_juice_bottle_green")
    inst.AnimState:PlayAnimation("idle_most")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeHauntableLaunch(inst)
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("edible")
    inst.components.edible.hungervalue = 35
	inst.components.edible.healthvalue = 15
	inst.components.edible.sanityvalue = 5
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible:SetOnEatenFn(Most_EatFn)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/peach_juice_bottle_green_most.xml"

    return inst
end

local function half()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)		

    inst.AnimState:SetBank("peach_juice_bottle_green")
    inst.AnimState:SetBuild("peach_juice_bottle_green")
    inst.AnimState:PlayAnimation("idle_half")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeHauntableLaunch(inst)
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("edible")
    inst.components.edible.hungervalue = 35
	inst.components.edible.healthvalue = 15
	inst.components.edible.sanityvalue = 5
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible:SetOnEatenFn(Half_EatFn)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/peach_juice_bottle_green_half.xml"

    return inst
end

local function less()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("peach_juice_bottle_green")
    inst.AnimState:SetBuild("peach_juice_bottle_green")
    inst.AnimState:PlayAnimation("idle_less")
	
    MakeInventoryFloatable(inst)		

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddTag("peachy")
	
    MakeHauntableLaunch(inst)
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("edible")
    inst.components.edible.hungervalue = 35
	inst.components.edible.healthvalue = 15
	inst.components.edible.sanityvalue = 15
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible:SetOnEatenFn(Less_EatFn)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/peach_juice_bottle_green_less.xml"

    return inst
end

return	Prefab("peach_juice_bottle_green", full, assets),
		Prefab("peach_juice_bottle_green_most", most, assets1),
		Prefab("peach_juice_bottle_green_half", half, assets2),
		Prefab("peach_juice_bottle_green_less", less, assets3)