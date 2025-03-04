local assets =
{
    Asset("ANIM", "anim/ro_bin_gem.zip"),

}

local SPAWN_DIST = 30

local function RebuildTile(inst)
    if inst.components.inventoryitem:IsHeld() then
        local owner = inst.components.inventoryitem.owner
        inst.components.inventoryitem:RemoveFromOwner(true)
        if owner.components.container then
            owner.components.container:GiveItem(inst)
        elseif owner.components.inventory then
            owner.components.inventory:GiveItem(inst)
        end
    end
end

local function GetSpawnPoint(pt)
    local theta = math.random() * 2 * PI
    local radius = SPAWN_DIST

    local offset = FindWalkableOffset(pt, theta, radius, 12, true)
    if offset then
        return pt + offset
    end
end

local function SpawnRoBin(inst, spawn_pt, spawnevent)
    -- print("ro_bin_gizzard_stone - SpawnRoBin")

    local pt = Vector3(inst.Transform:GetWorldPosition())
    -- print("    near", pt)
    if not spawn_pt then
        spawn_pt = GetSpawnPoint(pt)
    end
    if spawn_pt then
        -- print("    at", spawn_pt)
        local ro_bin = SpawnPrefab("ro_bin")
        if ro_bin then
            ro_bin.Physics:Teleport(spawn_pt:Get())
            ro_bin:FacePoint(pt.x, pt.y, pt.z)

            if spawnevent then
                ro_bin:PushEvent("spawnin")
            end

            return ro_bin
        end
    else
        -- this is not fatal, they can try again in a new location by picking up the bone again
        -- print("ro_bin_gizzard_stone - SpawnRoBin: Couldn't find a suitable spawn point for ro_bin")
    end
end


local function StopRespawn(inst)
    -- print("ro_bin_gizzard_stone - StopRespawn")
    if inst.respawntask then
        inst.respawntask:Cancel()
        inst.respawntask = nil
        inst.respawntime = nil
    end
end

local function RebindRoBin(inst, ro_bin)
    ro_bin = ro_bin or TheSim:FindFirstEntityWithTag("ro_bin")
    if ro_bin then
        inst.AnimState:PlayAnimation("idle_loop", true)
        inst.components.inventoryitem:ChangeImageName(inst.openEye)
        inst:ListenForEvent("death", function() inst:OnRoBinDeath() end, ro_bin)

        if ro_bin.components.follower.leader ~= inst then
            ro_bin.components.follower:SetLeader(inst)
        end
        return true
    end
end

local function RespawnRoBin(inst)
    -- print("ro_bin_gizzard_stone - RespawnRoBin")

    StopRespawn(inst)

    local ro_bin = TheSim:FindFirstEntityWithTag("ro_bin")
    if not ro_bin then
        ro_bin = SpawnRoBin(inst)
    end
    RebindRoBin(inst, ro_bin)
end

local function StartRespawn(inst, time)
    StopRespawn(inst)

    local respawntime = time or 0
    if respawntime then
        inst.respawntask = inst:DoTaskInTime(respawntime, function() RespawnRoBin(inst) end)
        inst.respawntime = GetTime() + respawntime
        inst.AnimState:PlayAnimation("dead", true)
        inst.components.inventoryitem:ChangeImageName(inst.closedEye)
    end
end

local function OnRoBinDeath(inst)
    StartRespawn(inst, TUNING.CHESTER_RESPAWN_TIME)
end

local function FixRoBin(inst)
    inst.fixtask = nil
    --take an existing ro_bin if there is one
    if not RebindRoBin(inst) then
        inst.AnimState:PlayAnimation("dead", true)
        inst.components.inventoryitem:ChangeImageName(inst.closedEye)

        if inst.components.inventoryitem.owner then
            local time_remaining = 0
            local time = GetTime()
            if inst.respawntime and inst.respawntime > time then
                time_remaining = inst.respawntime - time
            end
            StartRespawn(inst, time_remaining)
        end
    end
end

local function OnPutInInventory(inst)
    if not inst.fixtask then
        inst.fixtask = inst:DoTaskInTime(1, function() FixRoBin(inst) end)
    end
end

local function OnSave(inst, data)
    -- print("ro_bin_eyebone - OnSave")
    local time = GetTime()
    if inst.respawntime and inst.respawntime > time then
        data.respawntimeremaining = inst.respawntime - time
    end
    if inst.robinspawned then
        data.robinspawned = true
    end
end


local function OnLoad(inst, data)
    if data and data.respawntimeremaining then
        inst.respawntime = data.respawntimeremaining + GetTime()
    end
    if data and data.robinspawned then
        inst.robinspawned = data.robinspawned
    end
end

local function GetStatus(inst)
    -- print("smallbird - GetStatus")
    if inst.respawntask then
        return "WAITING"
    end
end


local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    --so I can find the thing while testing
    --local minimap = inst.entity:AddMiniMapEntity()
    --minimap:SetIcon( "treasure.tex" )

    --inst:AddTag("ro_bin_eyebone")
    -- inst:AddTag("chester_eyebone") --This tag is used in save code and stuff, that's why I didn't change it
    inst:AddTag("ro_bin_gizzard_stone")

    inst:AddTag("irreplaceable")
    -- inst:AddTag("dropontravel")
    inst:AddTag("nonpotatable")
    inst:AddTag("follower_leash")

    MakeInventoryPhysics(inst)
    -- MakeInventoryFloatable(inst)
    MakeInventoryFloatable(inst, "med", 0.15) --没有水面动画
    -- inst.components.floater:UpdateAnimations("idle_water", "idle_loop")

    inst.AnimState:SetBank("ro_bin_gem")
    inst.AnimState:SetBuild("ro_bin_gem")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")

    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)

    inst.openEye = "ro_bin_gem"
    inst.closedEye = "ro_bin_gem_closed"

    inst.components.inventoryitem:ChangeImageName(inst.openEye)
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    inst.components.inspectable:RecordViews()

    inst:AddComponent("leader")

    inst.OnLoad = OnLoad
    inst.OnSave = OnSave
    inst.OnRoBinDeath = OnRoBinDeath

    inst.fixtask = inst:DoTaskInTime(0, function()
        if not inst.robinspawned then
            inst.robinspawned = true
            local pt = Vector3(inst.Transform:GetWorldPosition())
            SpawnRoBin(inst, pt, true)
        end
    end)

    inst.fixtask = inst:DoTaskInTime(1, function() FixRoBin(inst) end)

    return inst
end

return Prefab("common/inventory/ro_bin_gizzard_stone", fn, assets)
