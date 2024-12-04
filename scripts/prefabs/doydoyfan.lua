local assets =
{
    Asset("ANIM", "anim/fan_tropical.zip"),
    Asset("ANIM", "anim/fan.zip"),
}

local function fn()
    local swap_data = {
        bank = "fan_tropical",
        sym_build = "fan_tropical",
        sym_name = "fan01",
    }
    local inst = Prefabs.featherfan.fn()
    inst:SetPrefabName("tropicalfan")

    inst.AnimState:SetBuild(swap_data.sym_build)
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:OverrideSymbol("swap_fan", swap_data.sym_build, swap_data.sym_name)

    inst.components.floater:SetBankSwapOnFloat(true, -15, swap_data)
    inst.components.floater:SetSize("large")
    inst.components.floater:SetVerticalOffset(0.15)
    inst.components.floater:SetScale({.55, .5, .55})

    if not TheWorld.ismastersim then return inst end

    inst.components.fan:SetOverrideSymbol(swap_data.sym_name)

    inst.components.finiteuses:SetMaxUses(TUNING.PERDFAN_USES)
    inst.components.finiteuses:SetUses(TUNING.PERDFAN_USES)

    return inst

end

return Prefab("tropicalfan", fn, assets)
