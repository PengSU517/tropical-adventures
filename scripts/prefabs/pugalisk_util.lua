-- local function IsWater(tile)
--     return tile == GROUND.OCEAN_COASTAL or
--         tile == GROUND.OCEAN_COASTAL_SHORE or
--         tile == GROUND.OCEAN_SWELL or
--         tile == GROUND.OCEAN_ROUGH or
--         tile == GROUND.OCEAN_BRINEPOOL or
--         tile == GROUND.OCEAN_BRINEPOOL_SHORE or
--         tile == GROUND.OCEAN_WATERLOG or
--         tile == GROUND.OCEAN_HAZARDOUS
-- end

-- local function GetIsOnWater(target)
--     if target then
--         local map = TheWorld.Map
--         local x, y, z = target.Transform:GetWorldPosition()
--         local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))



--         if ground == GROUND.OCEAN_COASTAL or
--             ground == GROUND.OCEAN_COASTAL_SHORE or
--             ground == GROUND.OCEAN_SWELL or
--             ground == GROUND.OCEAN_ROUGH or
--             ground == GROUND.OCEAN_BRINEPOOL or
--             ground == GROUND.OCEAN_BRINEPOOL_SHORE or
--             ground == GROUND.OCEAN_WATERLOG or
--             ground == GROUND.OCEAN_HAZARDOUS then
--             return true
--         else
--             return false
--         end
--     end
-- end

local function FindCurrentTarget(inst)
    -- looks for a combat target, if none, sets target as home if range is too far

    --    print("FINDING TARGET FOR PUGALISK")

    local jogador = GetClosestInstWithTag("player", inst, 40)
    local home = GetClosestInstWithTag("pugalisk_trap_door", inst, 120)
    local target = inst

    local DIST = 100      -- 40
    local WANDERDIST = 60 -- 25

    if jogador and home and inst:GetDistanceSqToInst(home) < WANDERDIST * WANDERDIST and not jogador:HasTag("playerghost") then
        target = jogador
    end

    if jogador and not home and not jogador:HasTag("playerghost") then
        target = jogador
    end

    if jogador and home and jogador:HasTag("playerghost") then
        target = home
    end

    if home and inst:GetDistanceSqToInst(home) > WANDERDIST * WANDERDIST then
        --       print("-- no target, keep close to home")
        -- if no target but too far away from home, target home to get close to it.
        target = home
    end

    return target
end

function FindValidPositionByFan(start_angle, radius, attempts, test_fn)
    local theta = start_angle -- radians

    attempts = attempts or 8
    radius = radius or 1 --adicionei pra ve se nao da crash

    local attempt_angle = (2 * PI) / attempts
    local tmp_angles = {}
    for i = 0, attempts - 1 do
        local a = i * attempt_angle
        if a > PI then
            a = a - (2 * PI)
        end
        table.insert(tmp_angles, a)
    end

    -- Make the angles fan out from the original point
    local angles = {}
    for i = 1, math.ceil(attempts / 2) do
        table.insert(angles, tmp_angles[i])
        local other_end = #tmp_angles - (i - 1)
        if other_end > i then
            table.insert(angles, tmp_angles[other_end])
        end
    end

    for i, attempt in ipairs(angles) do
        local check_angle = theta + attempt
        if check_angle > 2 * PI then check_angle = check_angle - 2 * PI end

        local offset = Vector3(radius * math.cos(check_angle), 0, -radius * math.sin(check_angle))


        if test_fn(offset) then
            local deflected = i > 1

            return offset, check_angle, deflected
        end
    end
end

local function findMoveablePosition(position, start_angle, radius, attempts, check_los)
    local test = function(offset)
        local run_point = position + offset

        local ground = TheWorld
        local tile = ground.Map:GetTileAtPoint(run_point.x, run_point.y, run_point.z)

        if not IsLandTile(tile) then
            return false
        end

        -- if tile == GROUND.IMPASSABLE or tile >= GROUND.UNDERGROUND or IsWater(tile) then
        --     --           print("failed, unwalkable ground.")
        --     return false
        -- end

        local ents = TheSim:FindEntities(run_point.x, run_point.y, run_point.z, 2, nil, nil,
            { "pugalisk", "pugalisk_avoids" })
        if #ents > 0 then
            return false
        end

        local ents = TheSim:FindEntities(run_point.x, run_point.y, run_point.z, 6, { "pugalisk_avoids" })
        if #ents > 0 then
            return false
        end

        if check_los and not ground.Pathfinder:IsClear(position.x, position.y, position.z,
                run_point.x, run_point.y, run_point.z,
                { ignorecreep = true }) then
            return false
        end

        return true
    end

    return FindValidPositionByFan(start_angle, radius, attempts, test)
end

local function findDirectionToDive(inst, target)
    local pt = inst:GetPosition()
    local angle = math.random() * 2 * PI
    if target then
        angle = target:GetAngleToPoint(pt.x, pt.y, pt.z) * DEGREES - PI
        --        print("CALCING ANGLE",angle, target.prefab)
    else
        --        print("USING RANDOM ANGLE",angle)
    end

    local offset, endangle = findMoveablePosition(pt, angle, 6, 24, true)

    return endangle
end

local function findsafelocation(pt, angle)
    local finalpt = nil
    local offset = nil
    local range = 6
    while not offset do
        offset = findMoveablePosition(pt, angle * DEGREES, range, 24, true)
        range = range + 1
    end
    if offset then
        pt = pt + offset
        finalpt = pt
    end
    return finalpt
end

local function getNewBodyPosition(inst, bodies, target)
    local finalpt = nil
    local finalangle = nil

    -- get the new origin point
    if #bodies < 1 then
        -- this is the first body piece, start at the spawn point
        finalpt = inst:GetPosition()
    else
        -- this is a new body piece. try to put it out front of the last piece.
        finalpt = findsafelocation(bodies[#bodies].exitpt:GetPosition(), bodies[#bodies].Transform:GetRotation())
    end

    return finalpt
end

local function DetermineAction(inst)
    -- tested each frame when head to see if the head should start moving
    local target = FindCurrentTarget(inst)

    local wasgazing = inst.wantstogaze
    inst.wantstogaze = nil

    local pt = inst:GetPosition()
    local dist = nil

    local rando = math.random()
    if rando < 0.0001 then
        inst.wantstotaunt = true
    end

    if target then
        dist = inst:GetDistanceSqToInst(target)
    end

    if dist and target and target.components.freezable and not target.components.freezable:IsFrozen() and dist > 8 * 8 and dist < 20 * 20 then --and not head:HasTag("now_segmented")
        local gazechange = 0
        local health = inst.components.health:GetPercent()
        if health < 0.2 then
            gazechange = 0.75
        elseif health < 0.4 then
            gazechange = 0.5
        elseif health < 0.6 then
            gazechange = 0.3
        elseif health < 0.2 then
            gazechange = 0.1
        end

        if wasgazing or math.random() < gazechange then
            inst:PushEvent("stopmove")
            inst.wantstogaze = true
            if inst.sg:HasStateTag("underground") then
                inst:PushEvent("emerge")
            end
        end
    end

    if dist and dist < 6 * 6 and target and target ~= inst.home then
        if inst.sg:HasStateTag("underground") then
            inst:PushEvent("emerge")
        end
        inst:PushEvent("stopmove")
    elseif not inst.wantstogaze and not inst.wantstotaunt then
        local angle = nil
        inst.movecommited = true

        -- if no target, then direction is random.
        if target then
            angle = findDirectionToDive(inst, target)
            -- else
            --     angle = math.random()*2*PI
        end

        if angle then
            inst.Transform:SetRotation(angle / DEGREES)

            inst.angle = angle

            if inst.sg:HasStateTag("underground") then
                local pos = Vector3(inst.Transform:GetWorldPosition())
                inst.components.multibody:SpawnBody(inst.angle, 0, pos)
            else
                inst.wantstopremove = true
                --inst:PushEvent("premove")
            end
        else
            --            print("COULD NOT GET AN ANGLE FOR THE BODY SEGMENT, BACKING UP THE PUGAKISK UP")
            inst:PushEvent("backup")
        end

        --inst:PushEvent("startmove")
    end
end

local function recoverfrombadangle(inst)
    local finalpt = findsafelocation(inst:GetPosition(), inst.Transform:GetRotation())
    inst.Transform:SetPosition(finalpt.x, finalpt.y, finalpt.z)
end

--inst.components.multibody:SpawnBody(inst.angle,0,pos)

local pugalisk_util = {
    findMoveablePosition = findMoveablePosition,
    findDirectionToDive = findDirectionToDive,
    FindValidPositionByFan = FindValidPositionByFan,
    findsafelocation = findsafelocation,
    getNewBodyPosition = getNewBodyPosition,
    FindCurrentTarget = FindCurrentTarget,
    DetermineAction = DetermineAction,
    recoverfrombadangle = recoverfrombadangle,
}

return pugalisk_util
