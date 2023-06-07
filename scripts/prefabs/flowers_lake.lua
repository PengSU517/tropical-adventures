local assets =
{
    Asset("ANIM", "anim/flowers_lake.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

	inst:AddTag("goddess_flower")
	inst:AddTag("flower")
	
    inst.AnimState:SetBank("flowers_lake")
    inst.AnimState:SetBuild("flowers_lake")
    inst.AnimState:PlayAnimation("idle")
	
	local s = 0.4
	inst.Transform:SetScale(s,s,s)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("flowers_lake", fn, assets)