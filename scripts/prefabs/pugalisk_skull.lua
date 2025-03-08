local assets =
{
    Asset("ANIM", "anim/snake_skull.zip"),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()


    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("snake_skull")
    inst.AnimState:SetBuild("snake_skull")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("pugalisk_skull")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")


    return inst
end

return Prefab("pugalisk_skull", fn, assets)
