local assets =
{
    Asset("ANIM", "anim/bottle_green.zip"),
	Asset("IMAGE", "images/inventoryimages/empty_bottle_green.tex"),
	Asset("ATLAS", "images/inventoryimages/empty_bottle_green.xml")
}

local function bottle(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local watersource = TheSim:FindClosestEntityInRange(x, y, z, 3, "watersource")
	if watersource:HasTag("goddess_fountain") and watersource:HasTag("watersource") then
		inst.componwatersource.fillable.filledprefab = "full_bottle_green"
	elseif not watersource:HasTag("goddess_fountain") and watersource:HasTag("watersource") then
		inst.components.fillable.filledprefab = "full_bottle_green_dirty"
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    
    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBank("bottle_green")
    inst.AnimState:SetBuild("bottle_green")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddTag("glassbottle")
	
    MakeHauntableLaunch(inst)
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/empty_bottle_green.xml"
	
    inst:AddComponent("stackable")
	
	inst:AddComponent("milker")
	inst.components.milker.milkprefab = "full_bottle_green_milk"
	
	inst:AddComponent("fillable")
	inst.components.fillable.filledprefab = "full_bottle_green_dirty"
	
	inst:AddComponent("extrafillable")
	inst.components.extrafillable.extrafilledprefab = "full_bottle_green"

    return inst
end

return Prefab("empty_bottle_green", fn, assets)