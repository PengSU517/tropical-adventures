local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

function GetWorldPosition(x, y, z)
    if z == nil then -- More efficent than checking the type -Half
        if y ~= nil then
            x, y, z = x, 0, z
        elseif x.x then
            x, y, z = x.x, x.y, x.z
        elseif x.Transform then
            x, y, z = x.Transform:GetWorldPosition()
        end
    end

    return x, y, z
end

-- Only for convenience, not efficent at all -Half
function CheckTileType(tile, check, ...)
    if type(tile) == "table" then
        local x, y, z = GetWorldPosition(tile)
        if type(check) == "function" then
            return check(x, y, z, ...)
        end
        tile = TheWorld.Map:GetTileAtPoint(x, y, z)
    end

    if type(check) == "function" then
        return check(tile, ...)
    elseif type(check) == "table" then
        -- return table.contains(check, tile)  -- ewww no, very inefficent
        return check[tile] ~= nil
    elseif type(check) == "string" then
        return WORLD_TILES[check] == tile
    end

    return tile == check
end

IAENV.modimport("scripts/tools/ocean_util")

function FlingItem(inst, loot, flingtargetpos, flingtargetvariance)
    if inst.components.lootdropper ~= nil then
        local _flingtargetpos = inst.components.lootdropper.flingtargetpos
        local _flingtargetvariance = inst.components.lootdropper.flingtargetvariance
        inst.components.lootdropper.flingtargetpos = flingtargetpos
        inst.components.lootdropper.flingtargetvariance = flingtargetvariance
        inst.components.lootdropper:FlingItem(loot)
        inst.components.lootdropper.flingtargetpos = _flingtargetpos
        inst.components.lootdropper.flingtargetvariance = _flingtargetvariance
    elseif loot ~= nil then
        local pt = inst:GetPosition()

        loot.Transform:SetPosition(pt:Get())

        local min_speed = 0
        local max_speed = 2
        local y_speed = 8
        local y_speed_variance = 4

        if loot.Physics ~= nil then
            local angle = flingtargetpos ~= nil and
            GetRandomWithVariance(inst:GetAngleToPoint(flingtargetpos), flingtargetvariance or 0) * DEGREES or
            math.random() * 2 * PI
            local speed = min_speed + math.random() * (max_speed - min_speed)
            if loot:IsAsleep() then
                local radius = .5 * speed +
                (inst.Physics ~= nil and loot:GetPhysicsRadius(1) + inst:GetPhysicsRadius(1) or 0)
                loot.Transform:SetPosition(
                    pt.x + math.cos(angle) * radius,
                    0,
                    pt.z - math.sin(angle) * radius
                )
            else
                local sinangle = math.sin(angle)
                local cosangle = math.cos(angle)
                loot.Physics:SetVel(speed * cosangle, GetRandomWithVariance(y_speed, y_speed_variance), speed * -
                sinangle)
                if inst.Physics ~= nil then
                    local radius = loot:GetPhysicsRadius(1) + inst:GetPhysicsRadius(1)
                    radius = radius * math.random()
                    loot.Transform:SetPosition(
                        pt.x + cosangle * radius,
                        pt.y + 0.5,
                        pt.z - sinangle * radius
                    )
                end
            end
        end
    end
end

function PickSomeWithProbs(items)
    local picked = {}
    for prefab, prob in pairs(items) do
        if prob >= 1.0 or math.random() < prob then
            table.insert(picked, prefab)
        end
    end
    return picked
end

function GetProperAngle(angle)
    if angle > 360 then
        return angle - 360
    else
        return angle
    end
end

function GetDistFromEdge(x, y, w, h)
    local distx = math.min(x, w - x)
    local disty = math.min(y, h - y)
    local dist = math.min(distx, disty)
    -- print(string.format("GetDistanceFromEdge (%d, %d), (%d, %d) = %d\n", x, y, w, h, dist))
    return dist
end

-- Checks if direction vector tar is between vec1 and vec2
local function isbetween(tar, vec1, vec2)
    return ((vec2.x - vec1.x) * (tar.z - vec1.z) - (vec2.z - vec1.z) * (tar.x - vec1.x)) > 0
end

function CheckLOSFromPoint(pos, target_pos)
    local dist = target_pos:Dist(pos)
    local vec = (target_pos - pos):GetNormalized()

    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, dist, { "blocker" })

    for _, ent in pairs(ents) do
        if ent.Physics and ent.Physics:IsActive() then
            local blocker_pos = ent:GetPosition()
            local blocker_vec = (blocker_pos - pos):GetNormalized()
            local blocker_perp = Vector3(-blocker_vec.z, 0, blocker_vec.x)
            local blocker_radius = ent.Physics:GetRadius()
            blocker_radius = math.max(0.75, blocker_radius)

            local blocker_edge1 = blocker_pos +
            Vector3(blocker_perp.x * blocker_radius, 0, blocker_perp.z * blocker_radius)
            local blocker_edge2 = blocker_pos -
            Vector3(blocker_perp.x * blocker_radius, 0, blocker_perp.z * blocker_radius)

            local blocker_vec1 = (blocker_edge1 - pos):GetNormalized()
            local blocker_vec2 = (blocker_edge2 - pos):GetNormalized()

            if isbetween(vec, blocker_vec1, blocker_vec2) then
                return false
            end
        end
    end

    return true
end

-- Climate Util

local function MakeTestFn(climate, countneutral)
    local climatetiles = CLIMATE_TURFS[string.upper(climate)]
    return function(tile)
        return (climatetiles and climatetiles[tile]) or (countneutral and CLIMATE_TURFS.NEUTRAL[tile])
    end
end

local function TestTurfs(pt, testfn)
    if pt then
        local num = 0
        local srcx, srcy = TheWorld.Map:GetTileCoordsAtPoint(pt:Get())
        for tilex = srcx - 2, srcx + 2, 2 do
            for tiley = srcy - 2, srcy + 2, 2 do
                local tile = TheWorld.Map:GetOriginalTile(tilex, tiley)
                if testfn(tile) then
                    num = num + 1     --no tile is pretty neutral to me
                    if tilex == 0 and tiley == 0 then
                        num = num + 1 --add extra weight to current tile -M
                    end
                end
            end
        end
        return num > 5 --more than half
    end
end

local function TestRoom(inst, pt, climate)
    if CLIMATE_ROOMS[string.upper(climate)] then
        if not TheWorld.Map:IsPassableAtPoint(pt.x, 0, pt.z, true) then
            return
        end
        -- print("TestRoom",inst)
        local roomid
        -- if inst and not inst.components.areaaware and (inst.components.locomotor or inst.components.inventoryitem or TheWorld.Map:GetPlatformAtPoint(pt.x, 0, pt.z) ~= nil)) then
        -- inst:AddComponent("areaaware") --make sure moving stuff updates more efficiently (then again, areaaware updates position every tick...)
        -- end
        if inst and inst.components.areaaware and inst.components.areaaware:GetCurrentArea() then
            roomid = inst.components.areaaware:GetCurrentArea().id
        else
            for i, node in ipairs(TheWorld.topology.nodes) do
                if TheSim:WorldPointInPoly(pt.x, pt.z, node.poly) then
                    roomid = TheWorld.topology.ids[i]
                    break
                end
            end
        end
        if roomid then
            -- if inst and inst:HasTag("player") then print("IN ROOM",roomid) end
            for _, v in pairs(CLIMATE_ROOMS[string.upper(climate)]) do
                if string.find(roomid, v) then
                    -- if inst and inst:HasTag("player") then print("ROOM IS",climate) end
                    return true
                end
            end
        end
    end
end

local function RoomHasTag(inst, pt, roomtag)
    if inst and inst.components.areaaware and inst.components.areaaware:GetCurrentArea() then
        return inst.components.areaaware:CurrentlyInTag(roomtag)
    end
    for i, node in ipairs(TheWorld.topology.nodes) do
        if TheSim:WorldPointInPoly(pt.x, pt.z, node.poly) then
            return table.contains(node.tags, roomtag)
        end
    end
end

function CalculateClimate(inst, pt, neutralclimate)
    if inst then
        if not inst:IsValid() then
            -- print(inst.prefab.." is not valid, IA climate can't be checked.")
        end
        pt = inst:GetPosition()
    end
    local validclimates = {}
    for i, v in ipairs(CLIMATES) do
        if TheWorld:HasTag(v) then
            validclimates[#validclimates + 1] = v
        end
    end

    if #validclimates == 1 then
        return CLIMATE_IDS[validclimates[1]]
    else
        local _climate
        for i = 2, #validclimates, 1 do
            local climate = validclimates[i]
            if (TheWorld.topology and TheWorld.topology.ia_worldgen_version)
                --hardcoding like yeah B^)  -M
                and ((climate == "island" and (IsOnOcean(inst or pt) or RoomHasTag(inst, pt, "islandclimate")))
                    or (climate == "volcano" and RoomHasTag(inst, pt, "volcanoclimate")))
                or not (TheWorld.topology and TheWorld.topology.ia_worldgen_version)
                --Should the MakeTestFn functions get cached? -M
                and (TestRoom(inst, pt, climate) or TestTurfs(pt, MakeTestFn(climate, neutralclimate and (climate == CLIMATES[neutralclimate])))) then
                -- print("CALC CLIMATE FOR ", inst or pt, climate)
                return CLIMATE_IDS[climate]
            end
        end
        -- print("CALC CLIMATE FAILED ", inst or pt)
        return CLIMATE_IDS[validclimates[1]]
    end

    --failed, just guess based on the world tags
    -- return TheWorld:HasTag("forest") and CLIMATE_IDS.forest or TheWorld:HasTag("cave") and CLIMATE_IDS.cave or CLIMATE_IDS.forest
end

function GetClimate(inst, forceupdate, neutralclimate)
    if not inst or type(inst) ~= "table" then
        print("Invalid use of GetClimate", inst)
        print(debugstack())
        return CLIMATE_IDS.forest
    end
    if TheWorld.ismastersim then
        if inst.is_a and inst:is_a(EntityScript) then
            if inst.prefab ~= nil then
                if not inst.components.climatetracker then
                    inst:AddComponent("climatetracker")
                end
                return inst.components.climatetracker:GetClimate(forceupdate)
            else
                return CalculateClimate(inst, nil, neutralclimate)
            end
        elseif inst.is_a and inst:is_a(Vector3) then
            return CalculateClimate(nil, inst, neutralclimate)
        end
    else
        if inst.player_classified then
            return inst.player_classified._climate:value()
        elseif inst.is_a and inst:is_a(EntityScript) then
            if not forceupdate then
                for i, v in ipairs(CLIMATES) do
                    if inst:HasTag("Climate_" .. v) then
                        return i
                    end
                end
            end
            --failed, probably has no climatetracker, resort to CalculateClimate
            return CalculateClimate(inst, nil, neutralclimate)
        elseif inst.is_a and inst:is_a(Vector3) then
            return CalculateClimate(nil, inst, neutralclimate)
        end
    end
end

--
-- Is Climate --

function IsSWClimate(climate)
    return climate == CLIMATE_IDS.island or climate == CLIMATE_IDS.volcano
end

function IsROGClimate(climate)
    return climate == CLIMATE_IDS.forest or climate == CLIMATE_IDS.cave
end

function IsIAClimate(climate)
    return climate == CLIMATE_IDS.island or climate == CLIMATE_IDS.volcano -- or climate == CLIMATE_IDS.porkland
end

function IsDSTClimate(climate)
    return not IsIAClimate(climate)
end

function IsClimate(climate, target_climate)
    return CLIMATES[climate] == target_climate
end

-- In Climate --
function IsInSWClimate(inst, forceupdate)
    local climate = GetClimate(inst, forceupdate)
    return IsSWClimate(climate)
end

function IsInROGClimate(inst, forceupdate)
    local climate = GetClimate(inst, forceupdate)
    return IsROGClimate(climate)
end

function IsInDSTClimate(inst, forceupdate)
    local climate = GetClimate(inst, forceupdate)
    return IsDSTClimate(climate)
end

function IsInIAClimate(inst, forceupdate)
    local climate = GetClimate(inst, forceupdate)
    return IsIAClimate(climate)
end

function IsInClimate(inst, climate, forceupdate, neutralclimate)
    return CLIMATES[GetClimate(inst, forceupdate, neutralclimate)] == climate
end

--End of Climate Util

function IsPositionValidForEnt(inst, radius_check)
    return function(pt)
        return inst:IsAmphibious()
            or (inst:IsAquatic() and not inst:GetIsCloseToLand(radius_check, pt))
            or (inst:IsTerrestrial() and not inst:GetIsCloseToWater(radius_check, pt))
    end
end

function IA_MODULE_ERROR(module)
    print("IA_STARTUP_ERROR:", module)
end

local IA_SCRAPBOOK_DEFS = require("prefabs/ia_scrapbook_defs")
local _GetScrapbookIconAtlas = GetScrapbookIconAtlas
function GetScrapbookIconAtlas(imagename, ...)
    if IA_SCRAPBOOK_DEFS.MOBS[string.sub(imagename, 1, -5)] then
        return "images/ia_scrapbook.xml"
    else
        return _GetScrapbookIconAtlas(imagename, ...)
    end
end
