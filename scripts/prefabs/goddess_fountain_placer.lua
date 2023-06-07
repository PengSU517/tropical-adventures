local assets =
{
    Asset("ANIM", "anim/goddess_fountain_gem.zip"),
	Asset("ATLAS", "images/inventoryimages/goddess_fountainette.xml"),
	Asset("IMAGE", "images/inventoryimages/goddess_fountainette.tex"),
}

local function ondeploy(inst, pt)
	local goddess_fountain = SpawnPrefab("goddess_fountain") 
	if goddess_fountain then 
		goddess_fountain.Transform:SetPosition(pt.x, pt.y, pt.z) 
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()

	local s = 0.4
	inst.Transform:SetScale(s,s,s)

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBank("goddess_fountain_gem")
    inst.AnimState:SetBuild("goddess_fountain_gem")
    inst.AnimState:PlayAnimation("idle")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/goddess_fountainette.xml"
	
	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = ondeploy

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("goddess_fountainette", fn, assets),
		MakePlacer("goddess_fountainette_placer", "goddess_fountain_gem", "goddess_fountain_gem", "idle")