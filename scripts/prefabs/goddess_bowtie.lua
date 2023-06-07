local assets =
{
    Asset("ANIM", "anim/goddess_bowtie.zip"),
	Asset("ANIM", "anim/torso_bowtie.zip"),
	Asset("ATLAS", "images/inventoryimages/goddess_bowtie.xml")
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "torso_bowtie", "redamulet")
	if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
	end
	owner:AddTag("windy2")
end

local function onunequip(inst, owner)
	owner.AnimState:ClearOverrideSymbol("swap_body")
	if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
	owner:RemoveTag("windy2")
end
    
local function ShouldAcceptItem(inst, item)
    return item:HasTag("magicpowder")
end

local function OnGetItem(inst, giver, item)
	local uses =  inst.components.armor:GetPercent()
	inst.components.armor:SetPercent(uses + 0.2)
	if uses >= 1 then
	inst.components.armor:SetPercent(1)
	end
end

local function ReflectDamage(inst, attacker)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBank("amulets")
    inst.AnimState:SetBuild("goddess_bowtie")
    inst.AnimState:PlayAnimation("redamulet")

	local s = 0.9
	inst.Transform:SetScale(s,s,s)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(888, 0.88)

    inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("damagereflect")
	inst.components.damagereflect:SetDefaultDamage(88)
	--inst.components.damagereflect:SetReflectDamageFn(ReflectDamage)
	
	--inst:AddComponent("trader")
	--inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    --inst.components.trader.onaccept = OnGetItem

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/goddess_bowtie.xml"

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("goddess_bowtie", fn, assets)