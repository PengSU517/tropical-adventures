local assets =
{
    Asset("ANIM", "anim/mixed_gem.zip"),
	Asset("ATLAS", "images/inventoryimages/mixed_gem.xml"),
	Asset("IMAGE", "images/inventoryimages/mixed_gem.tex"),
	
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBank("mixed_gem")
    inst.AnimState:SetBuild("mixed_gem")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle")

    inst:AddTag("cattoy")
	inst:AddTag("mixed_gem")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/mixed_gem.xml"
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")

    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

return Prefab("mixed_gem", fn, assets)
