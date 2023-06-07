local assets = {
    Asset("ANIM", "anim/pig_figure.zip"),
}

local prefabs = {}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("pig_figure_mini.tex")
    inst.MiniMapEntity:SetPriority(15)
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("pig_figure")
    inst.AnimState:SetBuild("pig_figure")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("irreplaceable")
    inst:AddTag("nonpotatable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/pig_figure.xml"
	inst.caminho = "images/inventoryimages/pig_figure.xml"

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("pig_figure", fn, assets)
