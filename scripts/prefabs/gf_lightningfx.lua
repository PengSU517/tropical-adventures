local assets =
{
    Asset("ANIM", "anim/gflightningfx.zip"),
}

local prefabs = {}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst.entity:SetCanSleep(false)

    inst.AnimState:SetBank("gflightningfx")
    inst.AnimState:SetBuild("gflightningfx")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

    inst.scaley = math.random(6, 8) * 0.1
    inst.Transform:SetScale(1, inst.scaley, 1)
    
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst:AddComponent("bloomer")
    inst.components.bloomer:PushBloom("fx", "shaders/anim.ksh", -2)
    inst.persists = false

    return inst
end

return  Prefab("gf_lightningfx", fn, assets, prefabs)
