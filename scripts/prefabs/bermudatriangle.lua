require "stategraphs/SGbermudatriangle"

local assets =
{
    Asset("ANIM", "anim/bermudatriangle.zip"),
    Asset("ANIM", "anim/teleporter_worm.zip"),
    Asset("ANIM", "anim/teleporter_worm_build.zip"),
    Asset("SOUND", "sound/common.fsb"),
}

local function GetStatus(inst)
    return inst.sg.currentstate.name ~= "idle" and "OPEN" or nil
end

local function OnDoneTeleporting(inst, obj)
    if inst.closetask ~= nil then
        inst.closetask:Cancel()
    end
    inst.closetask = inst:DoTaskInTime(1.5, function()
        if not (inst.components.teleporter:IsBusy() or
                inst.components.playerprox:IsPlayerClose()) then
            inst.sg:GoToState("closing")
        end
    end)

    if obj ~= nil and obj:HasTag("player") then
        obj:DoTaskInTime(1, obj.PushEvent, "bermudatriangleexit") -- for wisecracker
    end
end

local function OnActivate(inst, doer, target)
    if doer:HasTag("player") then
        ProfileStatsSet("wormhole_used", true)
        AwardPlayerAchievement("wormhole_used", doer)

        local other = inst.components.teleporter.targetTeleporter
        if other ~= nil then
            DeleteCloseEntsWithTag({ "WORM_DANGER" }, other, 15)
        end

        if doer.components.talker ~= nil then
            doer.components.talker:ShutUp()
        end
        if doer.components.sanity ~= nil and not doer:HasTag("nowormholesanityloss") and not inst.disable_sanity_drain then
            doer.components.sanity:DoDelta(-TUNING.SANITY_MED)
        end

        --Sounds are triggered in player's stategraph
    elseif inst.SoundEmitter ~= nil then
        inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/bermudatriangle_spark", "wormhole_swallow")
    end
end

local function OnActivateByOther(inst, source, doer)
    if not inst.sg:HasStateTag("open") then
        inst.sg:GoToState("opening")
    end
end

local function onnear(inst)
    if inst.components.teleporter:IsActive() and not inst.sg:HasStateTag("open") then
        inst.sg:GoToState("opening")
    end
end

local function onfar(inst)
    if not inst.components.teleporter:IsBusy() and inst.sg:HasStateTag("open") then
        inst.sg:GoToState("closing")
    end
end

local function onaccept(inst, giver, item)
    inst.components.inventory:DropItem(item)
    inst.components.teleporter:Activate(item)
end

local function StartTravelSound(inst, doer)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/bermudatriangle_spark", "wormhole_swallow")
    doer:PushEvent("wormholetravel", WORMHOLETYPE.OCEANWHIRLPORTAL) --Event for playing local travel sound
end

local function OnSave(inst, data)
    if inst.disable_sanity_drain then
        data.disable_sanity_drain = true
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.disable_sanity_drain then
        inst.disable_sanity_drain = true
    end
end

local CHECK_FOR_BOATS_PERIOD = 0.5

local BOAT_INTERACT_DISTANCE = 6.0
local BOAT_INTERACT_DISTANCE_LEAVE_SQ = (BOAT_INTERACT_DISTANCE + MAX_PHYSICS_RADIUS) *
(BOAT_INTERACT_DISTANCE + MAX_PHYSICS_RADIUS)

local BOAT_WAKE_COUNT = 3
local BOAT_WAKE_TIME_PER = 1.5
local BOAT_WAKE_SPEED_MIN_THRESHOLD = 3.5

local BOAT_MUST_TAGS = { "boat", }

local TELEPORTBOAT_ITEM_MUST_TAGS = { "_inventoryitem", }
local TELEPORTBOAT_ITEM_CANT_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO", }
local TELEPORTBOAT_BLOCKER_CANT_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO", "_inventoryitem", "bermudatriangle", }

local function DoBoatWake(boat, isfirst)
    if boat.components.boatphysics == nil then
        return
    end

    local speed = boat.components.boatphysics:GetVelocity()
    if speed < BOAT_WAKE_SPEED_MIN_THRESHOLD then
        return
    end

    local boatradius = boat:GetSafePhysicsRadius() +
    3                                                  -- Add a small offset so the wave does not hit the boat it came from.

    local x, y, z = boat.Transform:GetWorldPosition()
    local velx_n, velz_n = boat.components.boatphysics:GetNormalizedVelocities()
    local direction = VecUtil_GetAngleInRads(velx_n, velz_n)
    local dir1 = direction - 7.0 * DEGREES
    local dir2 = direction + 7.0 * DEGREES
    local pos1 = Vector3(x - boatradius * math.cos(dir1), 0, z - boatradius * math.sin(dir1))
    local pos2 = Vector3(x - boatradius * math.cos(dir2), 0, z - boatradius * math.sin(dir2))
    SpawnAttackWave(pos1, -direction * RADIANS - 65.0, BOAT_WAKE_SPEED_MIN_THRESHOLD, "wave_med", 0.5, true)
    SpawnAttackWave(pos2, -direction * RADIANS + 65.0, BOAT_WAKE_SPEED_MIN_THRESHOLD, "wave_med", 0.5, true)
    if isfirst then
        -- Make it emit one out the back too.
        boatradius = boatradius - 1.5
        local pos3 = Vector3(x - boatradius * math.cos(direction), 0, z - boatradius * math.sin(direction))
        SpawnAttackWave(pos3, -direction * RADIANS - 180.0, BOAT_WAKE_SPEED_MIN_THRESHOLD, "wave_med", 0.5, true)
    end
end

--[[local function SetExit(inst, exit)
    inst.components.entitytracker:TrackEntity("exit", exit)
end]]

local function ClearAvoid(boat)
    boat._avoid_whirlportals_hack = nil
end

local function CheckForBoatsTick(inst)
    -- Self check own blockers to clear.
    local selfblocker = inst.components.entitytracker:GetEntity("blocker")
    if selfblocker ~= nil then
        if inst:GetDistanceSqToInst(selfblocker) < BOAT_INTERACT_DISTANCE_LEAVE_SQ then
            return
        end
        inst.components.entitytracker:ForgetEntity("blocker")
    end

    -- Now do the normal teleport routine.
    local exit = inst.components.teleporter.targetTeleporter
    if exit == nil then
        return
    end

    if exit.components.entitytracker:GetEntity("blocker") ~= nil then
        return
    end

    local sx, sy, sz = inst.Transform:GetWorldPosition()
    local boat
    local boats = TheSim:FindEntities(sx, sy, sz, BOAT_INTERACT_DISTANCE, BOAT_MUST_TAGS)
    for _, testboat in ipairs(boats) do
        if not testboat._avoid_whirlportals_hack then
            boat = testboat
            break
        end
    end
    if boat == nil then
        return
    end

    local boatradius = boat:GetSafePhysicsRadius()

    local ex, ey, ez = exit.Transform:GetWorldPosition()

    local velx_n, velz_n = 0, 0
    if boat.components.boatphysics then
        velx_n, velz_n = boat.components.boatphysics:GetNormalizedVelocities()
    end
    local e_pt = Vector3(ex, ey, ez)
    if boat:IsBoatEdgeOverLand(e_pt) or TheSim:FindEntities(ex, ey, ez, boatradius + MAX_PHYSICS_RADIUS, nil, TELEPORTBOAT_BLOCKER_CANT_TAGS)[1] ~= nil then
        local function ValidOffset(pt)
            if TheWorld.Map:IsPointNearHole(pt) then
                return false
            end

            if boat:IsBoatEdgeOverLand(pt) then
                return false
            end

            if TheSim:FindEntities(pt.x, pt.y, pt.z, boatradius + MAX_PHYSICS_RADIUS, nil, TELEPORTBOAT_BLOCKER_CANT_TAGS)[1] ~= nil then
                return false
            end

            return true
        end
        local angle = VecUtil_GetAngleInRads(velx_n, velz_n)
        local offset
        for i = 1, math.ceil(BOAT_INTERACT_DISTANCE * 1.5) do
            offset = FindSwimmableOffset(e_pt, angle, i, 8, false, false, ValidOffset, false)
            if offset ~= nil then
                break
            end
        end
        if offset == nil then
            -- This exit is blocked.
            return
        end
        ex, ez = ex + offset.x, ez + offset.z
    end

    inst.components.entitytracker:TrackEntity("blocker", boat)
    exit.components.entitytracker:TrackEntity("blocker", boat)

    --SpawnPrefab("oceanwhirlportal_splash").Transform:SetPosition(sx, sy, sz)
    --SpawnPrefab("oceanwhirlportal_splash").Transform:SetPosition(ex, ey, ez)

    local item_ents = TheSim:FindEntities(ex, ey, ez, boatradius, TELEPORTBOAT_ITEM_MUST_TAGS,
        TELEPORTBOAT_ITEM_CANT_TAGS)
    boat.Physics:Teleport(ex, ey, ez)
    if boat.boat_item_collision then
        -- NOTES(JBK): This must also teleport or it will fling items off of it in a comical fashion from the physics constraint it has.
        boat.boat_item_collision.Physics:Teleport(ex, ey, ez)
    end
    if boat.components.boatphysics then
        boat.components.boatphysics:ApplyForce(velx_n, velz_n, TUNING.OCEANWHIRLPORTAL_BOAT_PUSH_FORCE)
        boat._avoid_whirlportals_hack = true -- HACK(JBK): Putting a boat into one into another it will cause a loop and the player can get stuck with it find a better way!
        --[[DoBoatWake(boat, true)
        for i = 1, BOAT_WAKE_COUNT - 1 do
            boat:DoTaskInTime(i * BOAT_WAKE_TIME_PER, DoBoatWake)
        end]]
        boat:DoTaskInTime(BOAT_WAKE_COUNT * BOAT_WAKE_TIME_PER, ClearAvoid)
    end
    for _, ent in ipairs(item_ents) do
        ent.components.inventoryitem:SetLanded(false, true)
    end
    --exit.components.wateryprotection:SpreadProtectionAtPoint(ex, ey, ez, MAX_PHYSICS_RADIUS * 2)

    local walkableplatform = boat.components.walkableplatform
    if walkableplatform ~= nil then
        local players = walkableplatform:GetPlayersOnPlatform()
        for player, _ in pairs(players) do
            player:PushEvent("wormholetravel", WORMHOLETYPE.OCEANWHIRLPORTAL) --Event for playing local travel sound
            if player.components.sanity ~= nil and not player:HasTag("nowormholesanityloss") and not inst.disable_sanity_drain then
                player.components.sanity:DoDelta(-TUNING.SANITY_MED)
            end
        end
        if inst:GetDistanceSqToInst(exit) > PLAYER_CAMERA_SHOULD_SNAP_DISTANCE_SQ then
            for player, _ in pairs(players) do
                player:SnapCamera()
                player:ScreenFade(false)
                player:ScreenFade(true, 1)
            end
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    --inst.entity:AddPhysics() -- no collision, this is just for buffered actions
    --inst.Physics:ClearCollisionMask()
    --inst.Physics:SetSphere(1)

    inst.MiniMapEntity:SetIcon("bermudatriangle.png")

    inst.AnimState:SetBank("bermudatriangle")
    inst.AnimState:SetBuild("bermudatriangle")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

    inst.Transform:SetScale(1.3, 1.3, 1.3)

    --trader, alltrader (from trader component) added to pristine state for optimization
    inst:AddTag("bermudatriangle")
    inst:AddTag("trader")
    inst:AddTag("alltrader")
    inst:AddTag("ignorewalkableplatforms")

    inst:AddTag("antlion_sinkhole_blocker")

    -- inst:AddTag("hamletteleport")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:SetStateGraph("SGbermudatriangle")

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    inst.components.inspectable:RecordViews()

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 5)
    inst.components.playerprox.onnear = onnear
    inst.components.playerprox.onfar = onfar

    inst:AddComponent("teleporter")
    inst.components.teleporter.onActivate = OnActivate
    inst.components.teleporter.onActivateByOther = OnActivateByOther
    inst.components.teleporter.offset = 0

    inst:ListenForEvent("starttravelsound", StartTravelSound) -- triggered by player stategraph
    inst:ListenForEvent("doneteleporting", OnDoneTeleporting)
    inst:AddComponent("entitytracker")
    inst._check_for_boats_task = inst:DoPeriodicTask(CHECK_FOR_BOATS_PERIOD, CheckForBoatsTick,
        CHECK_FOR_BOATS_PERIOD * math.random())

    inst:AddComponent("inventory")

    inst:AddComponent("trader")
    inst.components.trader.acceptnontradable = true
    inst.components.trader.onaccept = onaccept
    inst.components.trader.deleteitemonaccept = false

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("bermudatriangle", fn, assets)
