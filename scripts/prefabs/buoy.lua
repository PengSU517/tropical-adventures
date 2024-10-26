local assets =
{
    Asset("ANIM", "anim/buoy.zip"),
    Asset("MINIMAP_IMAGE", "buoy"),
}

local prefabs =
{
    "collapse_small",
}

local HIT_SOUND = "terraria1/skins/hammush" -- TODO better sound for this maybe?

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:SpawnLootPrefab("porto_buoy")
    -- inst.components.lootdropper:SpawnLootPrefab("bamboo")
    -- inst.components.lootdropper:SpawnLootPrefab("messagebottleempty1")
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.sg:GoToState("hit")
    inst.SoundEmitter:PlaySound(HIT_SOUND)
    --if not inst:HasTag("burnt") then
    --inst.AnimState:PlayAnimation("hit")
    --inst.AnimState:PushAnimation("idle", true)
    --end
end

local function ShouldKeepTarget(_) return false end

local function OnHitByAttack(inst, attacker, damage, specialdamage)
    if inst.components.workable then
        local work_done = math.max(1, math.floor(damage / TUNING.BOATRACE_SEASTACK_DAMAGE_TO_WORK))
        inst.components.workable:WorkedBy(attacker, work_done)
    end
end

local function onsave(inst, data)
    --if inst:HasTag("burnt") or inst:HasTag("fire") then
    --    data.burnt = true
    --end
end

local function onload(inst, data)
    --if data and data.burnt then
    --    inst.components.burnable.onburnt(inst)
    --end
end

local function OnCollide(inst, data)
    inst.SoundEmitter:PlaySound(HIT_SOUND)
end

local function onbuilt(inst)
    inst.sg:GoToState("place")
    --inst.AnimState:PlayAnimation("place")
    --inst.AnimState:PushAnimation("idle", true)
end

local function OnPhysicsWake(inst)
    inst.components.boatphysics:StartUpdating()
end

local function OnPhysicsSleep(inst)
    inst.components.boatphysics:StopUpdating()
end

local function CLIENT_ResolveFloater(inst)
    inst.components.floater:OnLandedServer()
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("buoy.tex")

    local phys = inst.entity:AddPhysics()
    phys:SetMass(TUNING.BOAT.MASS)
    phys:SetFriction(0)
    phys:SetDamping(5)
    phys:SetCollisionGroup(COLLISION.OBSTACLES)
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.WORLD)
    phys:CollidesWith(COLLISION.OBSTACLES)
    phys:SetCylinder(0.70, 2)

    local waterphysics = inst:AddComponent("waterphysics")
    waterphysics.restitution = 1.0 + TUNING.BOATRACE_SEASTACK_EXTRA_RESTITUTION

    anim:SetBank("buoy")
    anim:SetBuild("buoy")
    anim:PlayAnimation("idle", true)

    inst.entity:AddLight()
    inst.Light:Enable(true)
    inst.Light:SetIntensity(.75)
    inst.Light:SetColour(223 / 255, 246 / 255, 255 / 255)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetRadius(2)

    inst:AddTag("blocker")
    inst:AddTag("ignorewalkableplatforms")
    inst:AddTag("noauradamage")
    inst:AddTag("seastack")

    local floater = MakeInventoryFloatable(inst, "med", 0.1, { 1.1, 0.9, 1.1 })
    floater.bob_percent = 0
    local float_delay_framecount = 1 + (POPULATING and 4 * math.random() or 0)
    inst:DoTaskInTime(float_delay_framecount * FRAMES, CLIENT_ResolveFloater)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.scrapbook_anim = "1_idle"

    --
    inst:AddComponent("boatphysics")

    --
    local combat = inst:AddComponent("combat")
    combat:SetKeepTargetFunction(ShouldKeepTarget)
    combat:SetOnHit(OnHitByAttack)

    --
    local health = inst:AddComponent("health")
    health:SetMaxHealth(1)
    health:SetAbsorptionAmount(1)
    health.fire_damage_scale = 0
    health.canheal = false
    health.nofadeout = true

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
    MakeSnowCovered(inst, .01)

    inst:AddTag("structure")
    --MakeSmallBurnable(inst, nil, nil, true)
    --MakeSmallPropagator(inst)
    inst.OnSave = onsave
    inst.OnLoad = onload

    inst:DoTaskInTime(0.2, function()
        local efeito = SpawnPrefab("float_fx_front")
        efeito.entity:SetParent(inst.entity)
        efeito.Transform:SetPosition(0, 0, 0)
        efeito.AnimState:PlayAnimation("idle_front_med", true)

        local efeito = SpawnPrefab("float_fx_back")
        efeito.entity:SetParent(inst.entity)
        efeito.Transform:SetPosition(0, 0, 0)
        efeito.AnimState:PlayAnimation("idle_back_med", true)
    end)

    inst:ListenForEvent("on_collide", OnCollide)
    inst:ListenForEvent("onbuilt", onbuilt)

    inst:SetStateGraph("SGbuoy")

    inst.OnPhysicsWake = OnPhysicsWake
    inst.OnPhysicsSleep = OnPhysicsSleep

    return inst
end

return Prefab("buoy", fn, assets, prefabs),
    MakePlacer("buoy_placer", "buoy", "buoy", "idle")
