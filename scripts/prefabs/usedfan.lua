local assets =
{
    Asset("ANIM", "anim/usedfan.zip"),
	Asset("ATLAS", "images/inventoryimages/usedfan.xml")
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ruins_bat")
    inst.AnimState:SetBuild("usedfan")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)		
	
	local s = 1.25
	inst.Transform:SetScale(s,s,s)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/usedfan.xml"

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("usedfan", fn, assets)