local assets =
{
    Asset("ANIM", "anim/fishingrod.zip"),
    Asset("ANIM", "anim/swap_fishingrod.zip"),
	Asset("ATLAS", "images/inventoryimages/goddess_fishingrod.xml"),
}

local function glow(inst)
	if inst.magic == nil then
		inst.magic = inst:SpawnChild("goddess_lantern_fire")
		inst.magic.Light:Enable(false)
		inst.magic.Transform:SetPosition(0, 0.5, 0)
		local s = 0.5
		inst.magic.Transform:SetScale(s,s,s)
	end
end

local function unglow(inst)
	if inst.magic ~= nil then
		inst.magic:Remove()
		inst.magic = nil
	end
end

local function onequip (inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_fishingrod", "swap_fishingrod")
    owner.AnimState:OverrideSymbol("fishingline", "swap_fishingrod", "fishingline")
    owner.AnimState:OverrideSymbol("FX_fishing", "swap_fishingrod", "FX_fishing")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	owner:AddTag("windy5")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("fishingline")
    owner.AnimState:ClearOverrideSymbol("FX_fishing")
	owner:RemoveTag("windy5")
end

local function onfished(inst)
    if inst.components.finiteuses then
        inst.components.finiteuses:Use(1)
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

    inst.AnimState:SetBank("fishingrod")
    inst.AnimState:SetBuild("fishingrod")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.FISHINGROD_DAMAGE)
    inst.components.weapon.attackwear = 4
    -----
    inst:AddComponent("fishingrod")
    inst.components.fishingrod:SetWaitTimes(4, 40)
    inst.components.fishingrod:SetStrainTimes(0, 5)
    -------
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.FISHINGROD_USES)
    inst.components.finiteuses:SetUses(TUNING.FISHINGROD_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst:ListenForEvent("fishingcollect", onfished)

    ---------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/goddess_fishingrod.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)
	
	inst:DoTaskInTime(0, glow)
	
	inst:ListenForEvent("ondropped", glow)
	inst:ListenForEvent("onputininventory", unglow)

    return inst
end

return Prefab("goddess_fishingrod", fn, assets)