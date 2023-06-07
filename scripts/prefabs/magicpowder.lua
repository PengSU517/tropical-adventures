local assets =
{
    Asset("ANIM", "anim/magicpowder.zip"),
	Asset("ATLAS", "images/inventoryimages/magicpowder.xml")
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBank("ashes")
    inst.AnimState:SetBuild("magicpowder")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("magicpowder")	

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/magicpowder.xml"

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("magicpowder", fn, assets)