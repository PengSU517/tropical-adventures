local assets =
{ 
    Asset("ANIM", "anim/goddess_goggles.zip"),

    Asset("ATLAS", "images/inventoryimages/goddess_goggles.xml"),
    Asset("IMAGE", "images/inventoryimages/goddess_goggles.tex"),
}

local function OnEquip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_hat", "goddess_goggles", "swap_hat")
	
    owner.AnimState:Show("HAT")
    owner.AnimState:Hide("HAT_HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")	
    end
	if inst.components.fueled ~= nil then
       inst.components.fueled:StartConsuming()
    end
	
	owner:AddTag("windy1")
end

local function OnUnequip(inst, owner) 

    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
		
    end
	if inst.components.fueled ~= nil then
       inst.components.fueled:StopConsuming()
    end
	
	owner:RemoveTag("windy1")
end

local function ShouldAcceptItem(inst, item)
    return item:HasTag("magicpowder")
end

local function OnGetItem(inst, giver, item)
	local uses =  inst.components.fueled:GetPercent()
	inst.components.fueled:SetPercent(uses + 0.1)
	if uses >= 1 then
	inst.components.armor:SetPercent(1)
	end
end

local function fn()

    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	
	inst.entity:AddSoundEmitter()
	
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBank("hat_goggles")
    inst.AnimState:SetBuild("goddess_goggles")
    inst.AnimState:PushAnimation("anim")

    inst:AddTag("hat")
	inst:AddTag("waterproofer")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/goddess_goggles.xml"
	
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE
	inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT*1.12
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItem
	
	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)
	
	inst:AddComponent("insulator")
	inst.components.insulator:SetSummer()
    inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
	inst.components.equippable.insulated = true
	
	inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(480*5)
    inst.components.fueled:SetDepletedFn(inst.Remove)

    MakeHauntableLaunch(inst)

    return inst
end

return  Prefab("common/inventory/goddess_goggles", fn, assets, prefabs)