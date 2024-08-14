local birdvstile = {
    [WORLD_TILES.OCEAN_COASTAL] = { "puffin", "cormorant" },
    [WORLD_TILES.OCEAN_COASTAL_SHORE] = { "puffin", "cormorant" },
    [WORLD_TILES.OCEAN_SWELL] = { "puffin", "cormorant", "seagullwater" },
    [WORLD_TILES.OCEAN_ROUGH] = { "puffin", "seagullwater", "cormorant" },
    [WORLD_TILES.OCEAN_BRINEPOOL] = { "puffin", "seagullwater" },
    [WORLD_TILES.OCEAN_BRINEPOOL_SHORE] = { "puffin" },
    [WORLD_TILES.OCEAN_HAZARDOUS] = { "puffin", "seagullwater" },

    [WORLD_TILES.LILYPOND] = { "cormorant", "seagullwater" }, -------------------新添加----------------
    [WORLD_TILES.MANGROVE] = { "puffin", "seagullwater" },
    [WORLD_TILES.RAINFOREST] = { "toucan_hamlet", "kingfisher", "parrot_blue" },
    [WORLD_TILES.DEEPRAINFOREST] = { "toucan_hamlet", "parrot_blue", "kingfisher" },
    [WORLD_TILES.GASJUNGLE] = { "parrot_blue" },
    [WORLD_TILES.FOUNDATION] = { "canary", "quagmire_pigeon" },
    [WORLD_TILES.FIELDS] = { "crow", "quagmire_pigeon" },
    [WORLD_TILES.SUBURB] = { "crow", "quagmire_pigeon" },
    [WORLD_TILES.PAINTED] = { "kingfisher", "crow" },
    [WORLD_TILES.PLAINS] = { "toucan_hamlet", "kingfisher", "parrot_blue" },
    [WORLD_TILES.CHECKEREDLAWN] = { "canary", "quagmire_pigeon" },
    [WORLD_TILES.COBBLEROAD] = { "canary", "quagmire_pigeon" },
    [WORLD_TILES.TIDALMARSH] = { "toucan" },
    [WORLD_TILES.MAGMAFIELD] = { "toucan" },
    [WORLD_TILES.MEADOW] = { "parrot", "toucan" },
    [WORLD_TILES.BEACH] = { "toucan" },
    [WORLD_TILES.JUNGLE] = { "parrot" },
}

local SCARYTOPREY_TAGS = { "scarytoprey" }
local function IsDangerNearby(x, y, z)
    local ents = TheSim:FindEntities(x, y, z, 8, SCARYTOPREY_TAGS)
    return next(ents) ~= nil
end

local function RelevantSpawnBird(self, bird_prefab, spawnpoint, ignorebait)
    if not bird_prefab then
        return
    end

    local bird = SpawnPrefab(bird_prefab)

    if not bird then
        return
    end

    if math.random() < .5 then
        bird.Transform:SetRotation(180)
    end
    if bird:HasTag("bird") then
        spawnpoint.y = 15
    end

    if bird.components.eater and not ignorebait then
        local bait = TheSim:FindEntities(spawnpoint.x, 0, spawnpoint.z, 15)
        local _map = TheWorld.Map
        for k, v in pairs(bait) do
            local x, y, z = v.Transform:GetWorldPosition()

            -- if IsOnFlood(x, y, z) then -- birds can't spawn at flood
            --     break
            -- end

            if bird_prefab == "seagull" and v.components.pickable and v.components.pickable.product == "limpets" and v.components.pickable.canbepicked then
                local target_pos = Vector3(x, y, z)
                local angle = math.random(0, 360)
                local offset = FindWalkableOffset(target_pos, angle * DEGREES, math.random() + 0.5, 4, false, false)
                if not offset then return end
                local prefab_at_target = self:PickBird(target_pos + offset)
                if bird_prefab == prefab_at_target then
                    spawnpoint = Vector3(target_pos.x, spawnpoint.y, target_pos.z) + offset
                    bird.bufferedaction = BufferedAction(bird, v, ACTIONS.PICK)
                end
                break
            elseif bird.components.eater:CanEat(v) and not v:IsInLimbo() and v.components.bait and
                not (v.components.inventoryitem and v.components.inventoryitem:IsHeld()) and not IsDangerNearby(x, y, z) and
                (bird.components.floater ~= nil or _map:IsPassableAtPoint(x, y, z)) then
                spawnpoint.x, spawnpoint.z = x, z
                bird.bufferedaction = BufferedAction(bird, v, ACTIONS.EAT)
                break
            elseif v.components.trap and v.components.trap.isset and
                (not v.components.trap.targettag or bird:HasTag(v.components.trap.targettag)) and
                not v.components.trap.issprung and math.random() < TUNING.BIRD_TRAP_CHANCE and
                not IsDangerNearby(x, y, z) and (bird.components.floater ~= nil or _map:IsPassableAtPoint(x, y, z)) then
                spawnpoint.x, spawnpoint.z = x, z
                break
            end
        end
    end

    bird.Physics:Teleport(spawnpoint:Get())

    return bird
end

AddComponentPostInit("birdspawner", function(self)
    local _SpawnBird = self.SpawnBird
    function self:SpawnBird(spawnpoint, ignorebait)
        -- if IsOnFlood(spawnpoint:Get()) then -- birds can't spawn at flood
        --     return
        -- end

        local bird_prefab = nil
        local tile = TheWorld.Map:GetTileAtPoint(spawnpoint:Get())
        local istropicalclimate = TheWorld.Map:IsTropicalAreaAtPoint(spawnpoint:Get())
        local isocean = IsOceanTile(tile)

        if birdvstile[tile] ~= nil then
            if type(birdvstile[tile]) == "table" then
                bird_prefab = GetRandomItem(birdvstile[tile])
            else
                bird_prefab = birdvstile[tile]
            end

            if bird_prefab == "parrot" and math.random() < 0.1 --[[ TUNING.PARROT_PIRATE_CHANCE ]] then
                bird_prefab = "parrot_pirate"
            end

            if TheWorld.state.iswinter and not istropicalclimate and not isocean then
                bird_prefab = nil
            end

            return RelevantSpawnBird(self, bird_prefab, spawnpoint, ignorebait)
        else
            return _SpawnBird(self, spawnpoint, ignorebait)
        end
    end
end)
