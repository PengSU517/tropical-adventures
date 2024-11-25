local assets = {Asset("ANIM", "anim/swap_parasol_palmleaf.zip"), Asset("ANIM", "anim/parasol_palmleaf.zip")}

local function onequip_palmleaf(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_parasol_palmleaf", "swap_parasol_palmleaf")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    owner.DynamicShadow:SetSize(1.7, 1)
end

return Prefab("palmleaf_umbrella", function()
    local inst = Prefabs.grass_umbrella.fn()
    inst.AnimState:SetBuild("parasol_palmleaf")
    inst:SetPrefabName("palmleaf_umbrella")

    if not TheWorld.ismastersim then return inst end

    inst.components.equippable:SetOnEquip(onequip_palmleaf)
    inst.components.floater.swap_data.sym_build = "swap_parasol_palmleaf"

    return inst
end, assets)
