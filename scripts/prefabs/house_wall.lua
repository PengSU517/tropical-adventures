local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    --inst.Transform:SetEightFaced()

    inst:AddTag("blocker")
    local phys = inst.entity:AddPhysics()
    phys:SetMass(0)
    phys:SetCollisionGroup(COLLISION.WORLD)
    phys:ClearCollisionMask()
    for k, v in pairs(COLLISION) do
        if k ~= "SANITY" then
            phys:CollidesWith(v)
        end
    end
    phys:SetCapsule(0.5, 2)

    inst.Physics:SetDontRemoveOnSleep(true)

    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")
    inst:AddTag("birdblocker")
    inst:AddTag("wall")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetEightFaced()

    inst:AddTag("blocker")
    local phys = inst.entity:AddPhysics()
    phys:SetMass(0)
    phys:SetCollisionGroup(COLLISION.WORLD)
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.ITEMS)
    phys:CollidesWith(COLLISION.CHARACTERS)
    phys:CollidesWith(COLLISION.GIANTS)
    phys:CollidesWith(COLLISION.FLYERS)
    phys:SetCapsule(0.5, 2)

    -- inst.AnimState:SetBank("wall") ---没导入动画为啥能直接用啊
    -- inst.AnimState:SetBuild("wall_stone")
    -- inst.AnimState:PlayAnimation("half")

    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK") -------应该是这个的block
    inst:AddTag("birdblocker")
    inst:AddTag("wall")

    return inst
end

return Prefab("house_wall", fn),
    Prefab("house_wall2", fn2)
