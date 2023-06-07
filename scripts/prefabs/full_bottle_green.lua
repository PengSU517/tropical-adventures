local assets =
{
    Asset("ANIM", "anim/bottle_green.zip"),
	Asset("IMAGE", "images/inventoryimages/full_bottle_green.tex"),
	Asset("ATLAS", "images/inventoryimages/full_bottle_green.xml")
}

local assets1 = 
{
	Asset("ANIM", "anim/bottle_green.zip"),
	Asset("IMAGE", "images/inventoryimages/full_bottle_green_dirty.tex"),
	Asset("ATLAS", "images/inventoryimages/full_bottle_green_dirty.xml")
}

local function EatFn(inst, eater)
local x, y, z = inst.Transform:GetWorldPosition()
	local bottle = SpawnPrefab("empty_bottle_green")
	local a = math.random()
	if 	a >= 0.85 then
		inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/glass_break")
		if eater.components.talker ~= nil then
			eater.components.talker:Say("Refreshing but the bottle broke.")
		end
	else
		bottle.Transform:SetPosition(x, y, z)
		if eater.components.inventory ~= nil then
			eater.components.inventory:GiveItem(bottle)
		end
		if eater.components.talker ~= nil then
			eater.components.talker:Say("Refreshing and I got the bottle back.")
		end
	end
end

local function Dirty_EatFn(inst, eater)
	local x, y, z = inst.Transform:GetWorldPosition()
	local bottle = SpawnPrefab("empty_bottle_green")
		local a = math.random()
	if 	a >= 0.75 then
		inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/glass_break")
		if eater.components.talker ~= nil then
			eater.components.talker:Say("Gross... and the bottle broke.")
		end
	else
		bottle.Transform:SetPosition(x, y, z)
		if eater.components.inventory ~= nil then
			eater.components.inventory:GiveItem(bottle)
		end
		if eater.components.talker ~= nil then
			eater.components.talker:Say("Should not have drunk that but at least I got the bottle.")
		end
	end
end

local function OnRemove(inst)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/glass_break")
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
    
    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	
	
	inst:AddTag("frozen")

    inst.AnimState:SetBank("bottle_green")
    inst.AnimState:SetBuild("bottle_green")
    inst.AnimState:PlayAnimation("idle_full")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeHauntableLaunch(inst)
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("smotherer")
	
	inst:AddComponent("fertilizer")
    inst.components.fertilizer.fertilizervalue = TUNING.GUANO_FERTILIZE * 2
    inst.components.fertilizer.soil_cycles = TUNING.GUANO_SOILCYCLES * 2
    inst.components.fertilizer.withered_cycles = TUNING.GUANO_WITHEREDCYCLES * 2
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(5)
    inst.components.finiteuses:SetUses(5)
    inst.components.finiteuses:SetOnFinished(OnRemove)
	
	inst:AddComponent("edible")
    inst.components.edible.hungervalue = 4.7
	inst.components.edible.healthvalue = 15
	inst.components.edible.sanityvalue = 15
	inst.components.edible.foodtype = FOODTYPE.GENERIC
	inst.components.edible:SetOnEatenFn(EatFn)
	inst.components.edible.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
	inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_AVERAGE * 2

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/full_bottle_green.xml"

    return inst
end

local function fnn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
    
    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	
	
	inst:AddTag("frozen")

    inst.AnimState:SetBank("bottle_green")
    inst.AnimState:SetBuild("bottle_green")
    inst.AnimState:PlayAnimation("idle_full_dirty")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeHauntableLaunch(inst)
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("smotherer")
	
	inst:AddComponent("fertilizer")
    inst.components.fertilizer.fertilizervalue = TUNING.GUANO_FERTILIZE * 2
    inst.components.fertilizer.soil_cycles = TUNING.GUANO_SOILCYCLES * 2
    inst.components.fertilizer.withered_cycles = TUNING.GUANO_WITHEREDCYCLES * 2
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(5)
    inst.components.finiteuses:SetUses(5)
    inst.components.finiteuses:SetOnFinished(OnRemove)
	
	inst:AddComponent("edible")
    inst.components.edible.hungervalue = 4.7
	inst.components.edible.healthvalue = 3
	inst.components.edible.sanityvalue = -15
	inst.components.edible.foodtype = FOODTYPE.GENERIC
	inst.components.edible:SetOnEatenFn(Dirty_EatFn)
	inst.components.edible.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
	inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_AVERAGE

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/full_bottle_green_dirty.xml"

    return inst
end


return Prefab("full_bottle_green", fn, assets),
	Prefab("full_bottle_green_dirty", fnn, assets1)