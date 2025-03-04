local assets =
{
    Asset("ANIM", "anim/cave_exit.zip"),
    Asset("MINIMAP_IMAGE", "cave_open2"),
}

local function close(inst)
    inst.AnimState:PlayAnimation("no_access", true)
end

local function open(inst)
    inst.AnimState:PlayAnimation("open", true)
end

local function full(inst)
    inst.AnimState:PlayAnimation("over_capacity", true)
end

local function activate(inst)
    -- nothing
end

local function GetStatus(inst)
    if inst.components.worldmigrator:IsActive() then
        return "OPEN"
    elseif inst.components.worldmigrator:IsFull() then
        return "FULL"
    end
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 2)

    inst.MiniMapEntity:SetIcon("cave_open2.png")

    inst.AnimState:SetBank("cave_stairs")
    inst.AnimState:SetBuild("cave_exit")
    inst.AnimState:PlayAnimation("open")

    inst.scrapbook_anim = "open"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    if TheNet:GetServerIsClientHosted() and not (TheShard:IsMaster() or TheShard:IsSecondary()) then
        --On non-sharded servers we'll make these vanish for now, but still generate them
        --into the world so that they can magically appear in existing saves when sharded
        RemovePhysicsColliders(inst)
        inst.AnimState:SetScale(0, 0)
        inst.MiniMapEntity:SetEnabled(false)
        inst:AddTag("NOCLICK")
        inst:AddTag("CLASSIFIED")
    end

    inst:AddComponent("inspectable")

    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("worldmigrator")
    inst:ListenForEvent("migration_available", open)
    inst:ListenForEvent("migration_unavailable", close)
    inst:ListenForEvent("migration_full", full)
    inst:ListenForEvent("migration_activate", activate)

    -- if TUNING.tropicalshards == 5 or  TUNING.tropicalshards == 10 or  TUNING.tropicalshards == 20 then
    -- inst.components.worldmigrator.auto = false
    -- inst.components.worldmigrator.linkedWorld = "1"	
    -- end		

    -- if TUNING.tropicalshards == 30 then
    -- inst.components.worldmigrator.auto = false
    -- inst.components.worldmigrator.linkedWorld = "5"	
    -- end		

    return inst
end

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 2)

    inst.MiniMapEntity:SetIcon("cave_open2.png")

    inst.AnimState:SetBank("cave_stairs")
    inst.AnimState:SetBuild("cave_exit")
    inst.AnimState:PlayAnimation("open")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    if TheNet:GetServerIsClientHosted() and not (TheShard:IsMaster() or TheShard:IsSecondary()) then
        --On non-sharded servers we'll make these vanish for now, but still generate them
        --into the world so that they can magically appear in existing saves when sharded
        RemovePhysicsColliders(inst)
        inst.AnimState:SetScale(0, 0)
        inst.MiniMapEntity:SetEnabled(false)
        inst:AddTag("NOCLICK")
        inst:AddTag("CLASSIFIED")
    end

    inst:AddComponent("inspectable")

    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("worldmigrator")
    inst.components.worldmigrator.id = 1271
    inst.components.worldmigrator.receivedPortal = 1272

    inst:ListenForEvent("migration_available", open)
    inst:ListenForEvent("migration_unavailable", close)
    inst:ListenForEvent("migration_full", full)
    inst:ListenForEvent("migration_activate", activate)

    -- if TUNING.tropicalshards == 5 or TUNING.tropicalshards == 10 or TUNING.tropicalshards == 20 then
    --     inst.components.worldmigrator.auto = false
    --     inst.components.worldmigrator.linkedWorld = "4"
    -- end

    -- if TUNING.tropicalshards == 30 then
    --     inst.components.worldmigrator.auto = false
    --     inst.components.worldmigrator.linkedWorld = "5"
    -- end

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 2)

    inst.MiniMapEntity:SetIcon("cave_open2.png")

    inst.AnimState:SetBank("cave_stairs")
    inst.AnimState:SetBuild("cave_exit")
    inst.AnimState:PlayAnimation("open")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    if TheNet:GetServerIsClientHosted() and not (TheShard:IsMaster() or TheShard:IsSecondary()) then
        --On non-sharded servers we'll make these vanish for now, but still generate them
        --into the world so that they can magically appear in existing saves when sharded
        RemovePhysicsColliders(inst)
        inst.AnimState:SetScale(0, 0)
        inst.MiniMapEntity:SetEnabled(false)
        inst:AddTag("NOCLICK")
        inst:AddTag("CLASSIFIED")
    end

    inst:AddComponent("inspectable")

    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("worldmigrator")
    inst.components.worldmigrator.id = 1371
    inst.components.worldmigrator.receivedPortal = 1372

    inst:ListenForEvent("migration_available", open)
    inst:ListenForEvent("migration_unavailable", close)
    inst:ListenForEvent("migration_full", full)
    inst:ListenForEvent("migration_activate", activate)

    -- if TUNING.tropicalshards == 5 or TUNING.tropicalshards == 10 or TUNING.tropicalshards == 20 then
    --     inst.components.worldmigrator.auto = false
    --     inst.components.worldmigrator.linkedWorld = "4"
    -- end

    -- if TUNING.tropicalshards == 30 then
    --     inst.components.worldmigrator.auto = false
    --     inst.components.worldmigrator.linkedWorld = "5"
    -- end

    return inst
end

local function fn3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 2)

    inst.MiniMapEntity:SetIcon("cave_open2.png")

    inst.AnimState:SetBank("cave_stairs")
    inst.AnimState:SetBuild("cave_exit")
    inst.AnimState:PlayAnimation("open")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    if TheNet:GetServerIsClientHosted() and not (TheShard:IsMaster() or TheShard:IsSecondary()) then
        --On non-sharded servers we'll make these vanish for now, but still generate them
        --into the world so that they can magically appear in existing saves when sharded
        RemovePhysicsColliders(inst)
        inst.AnimState:SetScale(0, 0)
        inst.MiniMapEntity:SetEnabled(false)
        inst:AddTag("NOCLICK")
        inst:AddTag("CLASSIFIED")
    end

    inst:AddComponent("inspectable")

    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("worldmigrator")
    inst.components.worldmigrator.id = 1471
    inst.components.worldmigrator.receivedPortal = 1472

    inst:ListenForEvent("migration_available", open)
    inst:ListenForEvent("migration_unavailable", close)
    inst:ListenForEvent("migration_full", full)
    inst:ListenForEvent("migration_activate", activate)

    -- if TUNING.tropicalshards == 5 or TUNING.tropicalshards == 10 or TUNING.tropicalshards == 20 then
    --     inst.components.worldmigrator.auto = false
    --     inst.components.worldmigrator.linkedWorld = "4"
    -- end

    -- if TUNING.tropicalshards == 30 then
    --     inst.components.worldmigrator.auto = false
    --     inst.components.worldmigrator.linkedWorld = "5"
    -- end

    return inst
end


return --[[ Prefab("cave_exit", fn, assets), ]]
    Prefab("cave_exit_ham1", fn1, assets),
    Prefab("cave_exit_ham2", fn2, assets),
    Prefab("cave_exit_ham3", fn3, assets)
