local assets =
{
    Asset("ANIM", "anim/lightrays.zip"),
}

local function OnEntityWake(inst)
    inst.Transform:SetRotation(45)
    --inst.SoundEmitter:PlaySound("dontstarve/cave/forestAMB_spot", "loop")
end

local function OnEntitySleep(inst)
    --inst.SoundEmitter:KillSound("loop")
end

local function turnoff(inst, light)
    if light then
        light:Enable(false)
    end
    inst:Hide()
end

local phasefunctions =
{
    day = function(inst, instant)
        inst.Light:Enable(true)
        inst:Show()
        local time = 2
        if instant then
            time = 0
        end
        inst.components.lighttweener:StartTween(nil, 4, .8, .7, { 180 / 255, 195 / 255, 150 / 255 }, time)
    end,

    dusk = function(inst, instant)
        inst.Light:Enable(true)
        local time = 2
        if instant then
            time = 0
        end
        -- inst.components.lighttweener:StartTween(nil, 3, .6, .6, {91/255, 164/255, 255/255}, 4)
        inst.components.lighttweener:StartTween(nil, 4, .8, .7, { 100 / 255, 100 / 255, 100 / 255 }, time)
    end,

    night = function(inst, instant)
        if TheWorld.state.moonphase == "full" then
            local time = 4
            if instant then
                time = 0
            end
            inst.components.lighttweener:StartTween(nil, 5, .6, .6, { 91 / 255, 164 / 255, 255 / 255 }, time)
        else
            local time = 6
            if instant then
                time = 0
            end
            inst.components.lighttweener:StartTween(nil, 0, 0, 1, { 0, 0, 0 }, time, turnoff)
        end
    end,
}

local function timechange(inst, instant)
    if TheWorld.state.isaporkalypse then
        inst:Hide()
        inst.Light:Enable(false)
        return
    end
    if TheWorld.state.isday then
        inst.Light:Enable(true)
        inst:Show()
        local time = 2
        inst.components.lighttweener:StartTween(nil, 4, .8, .7, { 180 / 255, 195 / 255, 150 / 255 }, time)
    end



    if TheWorld.state.isdusk then
        inst.Light:Enable(true)
        inst:Show()
        local time = 2
        inst.components.lighttweener:StartTween(nil, 4, .8, .7, { 100 / 255, 100 / 255, 100 / 255 }, time)
    end

    if TheWorld.state.isnight then
        if TheWorld.state.moonphase == "full" then
            inst.Light:Enable(true)
            inst:Show()
            local time = 2
            inst.components.lighttweener:StartTween(nil, 5, .6, .6, { 91 / 255, 164 / 255, 255 / 255 }, time)
        else
            inst.Light:Enable(true)
            inst:Show()
            local time = 2
            inst.components.lighttweener:StartTween(nil, 0, 0, 1, { 0, 0, 0 }, time, turnoff)
        end
    end
end

local function filterspawn(inst)
    if not inst:HasTag("filtered") then
        inst:AddTag("filtered")
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 12, { "lightrays" })

        for i, ent in ipairs(ents) do
            if ent == inst then
                table.remove(ents, i)
                break
            end
        end
        if #ents > 0 then
            inst:Remove()
        end
    end
end

local function UpdateIsInInterior(inst)
    timechange(inst, true)
end

local function distancefadeextra(inst, dt)
    local time = 1

    local X = dt / time

    if inst:HasTag("under_leaf_canopy") or inst:HasTag("no_fade_by_zone") then
        if inst.extradistancefade_current < 1 then
            inst.extradistancefade_current = math.min(1, inst.extradistancefade_current + X)
        end
    else
        if inst.extradistancefade_current > 0 then
            inst.extradistancefade_current = math.max(0, inst.extradistancefade_current - X)
        end
    end

    return inst.extradistancefade_current
end

local function updatevis(inst)
    local player = GetClosestInstWithTag("player", inst, 20)
    if player then
        local ground = TheWorld
        local x, y, z = player.Transform:GetWorldPosition()
        local tile_type = ground.Map:GetTileAtPoint(x, y, z)
        if tile_type == GROUND.DEEPRAINFOREST or tile_type == GROUND.GASRAINFOREST or tile_type == GROUND.PIGRUINS then
            inst:AddTag("under_leaf_canopy")
        else
            inst:RemoveTag("under_leaf_canopy")
        end
    end
end

local function makefn(fadeout)
    local function fn(Sim)
        local inst = CreateEntity()
        local trans = inst.entity:AddTransform()
        local anim = inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        trans:SetEightFaced()

        inst.OnEntitySleep = OnEntitySleep
        inst.OnEntityWake = OnEntityWake

        anim:SetBank("lightrays")
        anim:SetBuild("lightrays")
        anim:PlayAnimation("idle_loop", true)
        inst:AddTag("lightrays")
        inst:AddTag("exposure")

        inst.Transform:SetRotation(45)

        inst.UpdateIsInInterior = UpdateIsInInterior

        inst:AddTag("NOCLICK")

        inst:WatchWorldState("isday", timechange)
        inst:WatchWorldState("isdusk", timechange)
        inst:WatchWorldState("isnight", timechange)

        --        inst:AddComponent("distancefade")
        --        inst.components.distancefade:Setup(15,15)
        --        inst.components.distancefade:SetExtraFn(distancefadeextra)

        inst:AddComponent("lighttweener")
        inst.components.lighttweener:StartTween(inst.entity:AddLight(), 4, .8, .7, { 180 / 255, 195 / 255, 150 / 255 }, 0)

        inst.color = { 255 / 255, 177 / 255, 32 / 255 }

        inst.AnimState:SetMultColour(255 / 255, 177 / 255, 32 / 255, 0)

        --inst:DoTaskInTime(0,function()  filterspawn(inst)  end)

        local rays = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }
        for i = 1, #rays, 1 do
            inst.AnimState:Hide("lightray" .. i)
        end

        for i = 1, math.random(4, 6), 1 do
            local selection = math.random(1, #rays)
            inst.AnimState:Show("lightray" .. rays[selection])
            table.remove(rays, selection)
        end

        inst.extradistancefade_current = 1
        if fadeout then
            inst:ListenForEvent("onchangecanopyzone", function()
                updatevis(inst)
            end, TheWorld)
            inst.extradistancefade_current = 0
        else
            inst:AddTag("no_fade_by_zone")
        end

        updatevis(inst)

        inst:DoTaskInTime(0,
            function(inst)
                if TheWorld.state.isaporkalypse then
                    inst:Hide()
                    inst.Light:Enable(false)
                end
            end)

        return inst
    end
    return fn
end


local function rays(name, fadeout)
    return Prefab(name, makefn(fadeout), assets, prefabs)
end

return rays("lightrays_jungle"),
    rays("lightrays")

--return Prefab( "common/lightrays", fn, assets)
