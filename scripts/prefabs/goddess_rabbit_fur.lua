local assets =
{
    Asset("ANIM", "anim/goddess_rabbit_fur.zip"),
	Asset("ATLAS", "images/inventoryimages/goddess_rabbit_fur.xml")
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	
	
	local s = 3
	inst.Transform:SetScale(s,s,s)

    inst.AnimState:SetBank("goddess_rabbit_fur")
    inst.AnimState:SetBuild("goddess_rabbit_fur")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddTag("goddess_rabbit_fur")
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/goddess_rabbit_fur.xml"

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("goddess_rabbit_fur", fn, assets)