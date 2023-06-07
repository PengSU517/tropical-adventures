local assets =
{
    Asset("ANIM", "anim/goddess_statue4.zip"),
    Asset("ANIM", "anim/goddess_statue_fire.zip"),	
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local s = 1.35
	inst.Transform:SetScale(s,s,s)
	
	MakeObstaclePhysics(inst, 0.7)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)

    inst.AnimState:SetBank("goddess_statue4")
    inst.AnimState:SetBuild("goddess_statue_fire")
    inst.AnimState:PlayAnimation("idle_off")
	

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddTag("windy8")
	
    inst:AddComponent("inspectable")

    return inst
end

return Prefab("goddess_statue4", fn, assets)