local assets =
{
    Asset("ANIM", "anim/greentacle_spike.zip"),
}

local prefabs =
{
    --"hephaestus_gift_lungefx"
}

local function OnThrown(inst)
    local owr = inst.components.projectile.owner
    if owr then
        local x, y, z = owr.Transform:GetWorldPosition()
        inst.Transform:SetPosition(x, 7, z)
    end
    inst:ListenForEvent("entitysleep", inst.Remove)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddPhysics()
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("tentacle_spike")
    inst.AnimState:SetBuild("greentacle_spike")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(40)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetHitDist(1.0)
    inst.components.projectile:SetOnHitFn(inst.Remove)
    inst.components.projectile:SetOnMissFn(inst.Remove)
    inst.components.projectile:SetOnThrownFn(OnThrown)
    inst.components.projectile:SetLaunchOffset(Vector3(0, 7, 0))

    inst:DoPeriodicTask(0, function()
        if not inst.yspeed then
            local distanceSq = inst:GetDistanceSqToInst(inst.components.projectile.target)
            inst.yspeed = 6 * 40 / math.sqrt(distanceSq)
        end
        local x, y, z = inst.Transform:GetWorldPosition()
        if y > 0.1 then
            inst.Physics:SetMotorVelOverride(40, - inst.yspeed, 0)
        end
    end)

    return inst
end

return Prefab("tentacle_attack_spike", fn, assets, prefabs)