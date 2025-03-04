local assets =
{

}

local prefabs =
{
    "ox",
}

local VALID_TILES = table.invert(
    {
        GROUND.MARSH,
    })
local function SpawnOx(spawn_point)
    local plant = SpawnPrefab("ox")
    plant.Transform:SetPosition(spawn_point.x, spawn_point.y, spawn_point.z)
    return plant
end
local LAND_CHECK_RADIUS = 6
local function FindLandNextToWater(playerpos, waterpos)
    --print("FindWalkableOffset:")
    local radius = 12
    local ground = TheWorld

    local test = function(offset)
        local run_point = waterpos + offset

        -- TODO: Also test for suitability - trees or too many objects
        return TheWorld.Map:IsPassableAtPoint(run_point:Get())
    end

    -- FindValidPositionByFan(start_angle, radius, attempts, test_fn)
    -- returns offset, check_angle, deflected
    local loc, landAngle, deflected = FindValidPositionByFan(0, radius, 8, test)
    if loc then
        --print("Fan angle=",landAngle)
        return waterpos + loc, landAngle, deflected
    end
end

local function IsNotNextToLand(pt)
    local playerPos = pt

    local radius = LAND_CHECK_RADIUS
    local landPos
    local tmpAng
    local map = TheWorld.Map

    local test = function(offset)
        local run_point = playerPos + offset
        -- Above ground, this should be water
        local loc, ang, def = FindLandNextToWater(playerPos, run_point)
        if loc ~= nil then
            landPos = loc
            tmpAng = ang
            --print("true angle",ang,ang/DEGREES)
            return true
        end
        return false
    end

    local cang = (math.random() * 360) * DEGREES
    --print("cang:",cang)
    local loc, landAngle, deflected = FindValidPositionByFan(cang, radius, 7, test)
    if loc ~= nil then
        return landPos, tmpAng, deflected
    end
end
local function GetSpawnPoint(pt)
    local function TestSpawnPoint(offset)
        local spawnpoint = pt + offset
        local spawnpoint_x, spawnpoint_y, spawnpoint_z = (pt + offset):Get()
        return not TheWorld.Map:IsAboveGroundAtPoint(spawnpoint:Get())
            and not VALID_TILES[TheWorld.Map:GetTileAtPoint(spawnpoint:Get())] ~= nil and
            not TheWorld.Map:IsPassableAtPoint(spawnpoint:Get()) and IsNotNextToLand(spawnpoint)
    end

    local theta = math.random() * 2 * PI
    local radius = 48 + math.random(-1, 1) * 4
    local resultoffset = FindValidPositionByFan(theta, radius, 12, TestSpawnPoint)

    if resultoffset ~= nil then
        return pt + resultoffset
    end
end

local function SpawnOxPre(inst)
    local pt = inst:GetPosition()
    local spawn_point = GetSpawnPoint(pt)
    if spawn_point ~= nil then
        local plant = SpawnOx(spawn_point)
        inst:Remove()
    else
        inst.tentativas = inst.tentativas - 1
        if inst.tentativas and inst.tentativas > 1 then
            inst:DoTaskInTime(1, SpawnOxPre)
        end
        if inst.tentativas and inst.tentativas < 1 then inst:Remove() end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    --inst:AddTag("CLASSIFIED")
    inst.tentativas = 10

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    --inst:AddTag("CLASSIFIED")

    inst:DoTaskInTime(1, SpawnOxPre)

    return inst
end

return Prefab("oxwaterspawner", fn, assets, prefabs)
