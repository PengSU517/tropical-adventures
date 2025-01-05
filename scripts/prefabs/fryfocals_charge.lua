local assets=
{
	Asset("ANIM", "anim/bishop_projectile_yellow.zip"),
	Asset("SOUND", "sound/chess.fsb"),
}

local function OnHit(inst, owner, target)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/bishop/shotexplo")
    inst.AnimState:PlayAnimation("impact")
    inst.Physics:Stop()
    inst.persists = false
	inst:ListenForEvent("animover", inst.Remove)
	inst:ListenForEvent("entitysleep", inst.Remove)
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("bishop_projectile_yellow")
    inst.AnimState:SetBuild("bishop_projectile_yellow")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("projectile")

    inst.persists = false

    inst.entity:SetPristine()

	if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(30)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetHitDist(2)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(OnHit)
    inst.components.projectile:SetLaunchOffset({x=1,y=1,z=0})

    return inst
end

return Prefab( "fryfocals_charge", fn, assets)
