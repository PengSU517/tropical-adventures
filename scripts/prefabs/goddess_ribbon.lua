local assets =
{
    Asset("ANIM", "anim/goddess_ribbon.zip"),
	Asset("ATLAS", "images/inventoryimages/goddess_ribbon.xml")
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBank("goddess_ribbon")
    inst.AnimState:SetBuild("goddess_ribbon")
    inst.AnimState:PlayAnimation("idle")
	
	local s = 3
	inst.Transform:SetScale(s,s,s)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddTag("ribbon")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/goddess_ribbon.xml"
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("tradable")

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("goddess_ribbon", fn, assets)