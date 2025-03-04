local assets =
{
    Asset("ANIM", "anim/grass_inwater.zip"),
    Asset("ANIM", "anim/grassgreen_build.zip"),
}

local prefabs =
{
    "cutgrass",
    "dug_grass",
    "spoiled_food",
    "grassgekko",
    "grasspartfx",
}

local function canmorph(inst)
    return inst.AnimState:IsCurrentAnimation("idle")
end

local TRIGGERMORPH_MUST_TAGS = { "renewable" }
local TRIGGERMORPH_CANT_TAGS = { "INLIMBO" }
local function triggernearbymorph(inst, quick, range)
    range = range or 1

    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, range, TRIGGERMORPH_MUST_TAGS, TRIGGERMORPH_CANT_TAGS)
    local count = 0

    for i, v in ipairs(ents) do
        if v ~= inst and
            v.prefab == "grass" and
            v.components.worldsettingstimer ~= nil and
            not (v.components.worldsettingstimer:ActiveTimerExists("morphdelay") or
                v.components.worldsettingstimer:ActiveTimerExists("morphing") or
                v.components.worldsettingstimer:ActiveTimerExists("morphrelay")) then
            count = count + 1

            if canmorph(v) and math.random() < .75 then
                v.components.worldsettingstimer:StartTimer(
                    "morphing",
                    ((not quick or count > 3) and .75 + math.random() * 1.5) or
                    (.2 + math.random() * .2) * count
                )
            else
                v.components.worldsettingstimer:StartTimer("morphrelay", count * FRAMES)
            end
        end
    end

    if count <= 0 and range < 4 then
        triggernearbymorph(inst, quick, range * 2)
    end
end

local function dig_up(inst, worker)
    if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
        if not TheWorld.state.iswinter
            and worker ~= nil
            and worker:HasTag("player")
            and math.random() < TUNING.GRASSGEKKO_MORPH_CHANCE then
            triggernearbymorph(inst, true)
        end

        if inst.components.pickable:CanBePicked() then
            inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
        end

        inst.components.lootdropper:SpawnLootPrefab("cutgrass" or "dug_grass")
    end
    inst:Remove()
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle", true)
end

local function makeemptyfn(inst)
    inst.AnimState:PushAnimation("picked", true)
end

local function makebarrenfn(inst, wasempty)

end

local function onpickedfn(inst, picker)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    inst.AnimState:PlayAnimation("picking")

    if not TheWorld.state.iswinter
        and picker ~= nil
        and picker:HasTag("player")
        and math.random() < TUNING.GRASSGEKKO_MORPH_CHANCE then
        triggernearbymorph(inst, true)
    end

    if inst.components.pickable:IsBarren() then
        inst.AnimState:PushAnimation("empty_to_dead")
        inst.AnimState:PushAnimation("idle_dead", false)
    else
        inst.AnimState:PushAnimation("picked", false)
        if inst.prefab == "grasswater" then inst.AnimState:PushAnimation("picked", true) end
    end
end

local FINDGRASSGEKKO_MUST_TAGS = { "grassgekko" }
local function onmorphtimer(inst, data)
    local morphing = data.name == "morphing"
    if morphing or data.name == "morphrelay" then
        if morphing and canmorph(inst) then
            local x, y, z = inst.Transform:GetWorldPosition()
            if #TheSim:FindEntities(x, y, z, TUNING.GRASSGEKKO_DENSITY_RANGE, FINDGRASSGEKKO_MUST_TAGS) < TUNING.GRASSGEKKO_MAX_DENSITY then
                local gekko = SpawnPrefab("grassgekko")
                gekko.Transform:SetPosition(x, y, z)
                gekko.sg:GoToState("emerge")

                local partfx = SpawnPrefab("grasspartfx")
                partfx.Transform:SetPosition(x, y, z)
                partfx.Transform:SetRotation(inst.Transform:GetRotation())
                partfx.AnimState:SetMultColour(inst.AnimState:GetMultColour())

                triggernearbymorph(inst, false)
                inst:Remove()
                return
            end
        end
        inst.components.worldsettingstimer:StartTimer("morphdelay",
            GetRandomWithVariance(TUNING.GRASSGEKKO_MORPH_DELAY, TUNING.GRASSGEKKO_MORPH_DELAY_VARIANCE))
        triggernearbymorph(inst, false)
    end
end

local function makemorphable(inst)
    if inst.components.worldsettingstimer == nil then
        inst:AddComponent("worldsettingstimer")
        inst.components.worldsettingstimer:AddTimer("morphdelay", TUNING.GRASSGEKKO_MORPH_DELAY,
            TUNING.GRASSGEKKO_MORPH_ENABLED)
        inst.components.worldsettingstimer:AddTimer("morphing", 1, TUNING.GRASSGEKKO_MORPH_ENABLED)
        inst.components.worldsettingstimer:AddTimer("morphrelay", FRAMES, TUNING.GRASSGEKKO_MORPH_ENABLED)
        inst:ListenForEvent("timerdone", onmorphtimer)
    end
end

local function ontransplantfn(inst)
    inst.components.pickable:MakeBarren()
    makemorphable(inst)
    inst.components.worldsettingstimer:StartTimer("morphdelay",
        GetRandomWithVariance(TUNING.GRASSGEKKO_MORPH_DELAY, TUNING.GRASSGEKKO_MORPH_DELAY_VARIANCE))
end

local function OnPreLoad(inst, data)
    WorldSettings_Timer_PreLoad(inst, data, "morphdelay",
        TUNING.GRASSGEKKO_MORPH_DELAY + TUNING.GRASSGEKKO_MORPH_DELAY_VARIANCE)
    WorldSettings_Timer_PreLoad_Fix(inst, data, "morphdelay", 1)
    WorldSettings_Timer_PreLoad(inst, data, "morphing")
    WorldSettings_Timer_PreLoad_Fix(inst, data, "morphing", 1)
    WorldSettings_Timer_PreLoad(inst, data, "morphrelay")
    WorldSettings_Timer_PreLoad_Fix(inst, data, "morphrelay", 1)
    if data ~= nil then
        if data.pickable ~= nil and data.pickable.transplanted then
            makemorphable(inst)
        else
            if data.worldsettingstimer ~= nil then
                makemorphable(inst)
            end
        end
    end
end

local function grass(name, stage)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        inst.MiniMapEntity:SetIcon("grassGreen.tex")

        inst.AnimState:SetBank("grass_inwater")
        inst.AnimState:SetBuild("grass_inwater")
        inst.AnimState:PlayAnimation("idle", true)

        inst:AddTag("plant")
        inst:AddTag("renewable")
        inst:AddTag("silviculture") -- for silviculture book
        inst:AddTag("grasss")
        inst:AddTag("mudacamada")
        MakeInventoryPhysics(inst, nil, 0.7)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.AnimState:SetTime(math.random() * 2)
        local color = 0.75 + math.random() * 0.25
        inst.AnimState:SetMultColour(color, color, color, 1)

        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"

        inst.components.pickable:SetUp("cutgrass", TUNING.GRASS_REGROW_TIME)
        inst.components.pickable.onregenfn = onregenfn
        inst.components.pickable.onpickedfn = onpickedfn
        inst.components.pickable.makeemptyfn = makeemptyfn
        inst.components.pickable.makebarrenfn = makebarrenfn
        inst.components.pickable.max_cycles = 20
        inst.components.pickable.cycles_left = 20
        inst.components.pickable.ontransplantfn = ontransplantfn

        inst:AddComponent("lootdropper")
        inst:AddComponent("inspectable")

        ---------------------

        MakeMediumBurnable(inst)
        MakeSmallPropagator(inst)
        MakeNoGrowInWinter(inst)
        MakeHauntableIgnite(inst)
        ---------------------

        inst.OnPreLoad = OnPreLoad

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return grass("grasswater", 0)
