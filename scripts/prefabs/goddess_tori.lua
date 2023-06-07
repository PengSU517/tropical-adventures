local assets =
{
    Asset("ANIM", "anim/goddess_gate.zip"),
	Asset("ATLAS", "images/inventoryimages/goddess_tori.xml"),
	Asset("IMAGE", "images/inventoryimages/goddess_tori.tex"),
}

local function ondeploy(inst, pt)
	local goddess_tori = SpawnPrefab("goddess_gate2") 
	if goddess_tori then 
		goddess_tori.Transform:SetPosition(pt.x, pt.y, pt.z) 
end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()

	local s = 0.5
	inst.Transform:SetScale(s,s,s)

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBank("goddess_gate")
    inst.AnimState:SetBuild("goddess_gate")
    inst.AnimState:PlayAnimation("idle")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/goddess_tori.xml"
	
	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = ondeploy

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("goddess_tori", fn, assets),
		MakePlacer( "common/goddess_tori_placer", "goddess_tori", "goddess_gate", "full")