local assets =
{
    Asset("ANIM", "anim/goddess_feather.zip"),
	Asset("ATLAS", "images/inventoryimages/goddess_feather.xml")
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBank("goddess_feather")
    inst.AnimState:SetBuild("goddess_feather")
    inst.AnimState:PlayAnimation("idle")

	local s = 2.4
	inst.Transform:SetScale(s,s,s)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/goddess_feather.xml"

	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("goddess_feather", fn, assets)