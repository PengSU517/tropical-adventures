require("stategraphs/commonstates")

local TWISTER_CALM_WALK_SPEED = 5
local TWISTER_ANGRY_WALK_SPEED = 8
local TWISTER_RUN_SPEED = 13
local TWISTER_HEALTH = 3000
local TWISTER_DAMAGE = 150
local TWISTER_VACUUM_DAMAGE = 500
local TWISTER_VACUUM_SANITY_HIT = -33
local TWISTER_VACUUM_DISTANCE = 15
local TWISTER_PLAYER_VACUUM_DISTANCE = 30
local TWISTER_ATTACK_PERIOD = 3
local TWISTER_MELEE_RANGE = 6
local TWISTER_ATTACK_RANGE = 6
local TWISTER_VACUUM_COOLDOWN = 20
local TWISTER_CHARGE_COOLDOWN = 10
local TWISTER_VACUUM_ANTIC_TIME = 5
local TWISTER_VACUUM_TIME = 5

local TWISTER_WAVES_ANTIC_TIME = 7
local TWISTER_WAVES_TIME = 5

local TWISTER_SEAL_HEALTH = 10

local function onattackedfn(inst, data)
    if inst.components.health and not inst.components.health:IsDead()
        and (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("frozen")) then
        inst.sg:GoToState("hit")
    end
end


local function onattackfn(inst)
    if inst.components.health and not inst.components.health:IsDead()
        and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
        if not inst.CanCharge and not inst.components.timer:TimerExists("Charge") then
            inst.components.timer:StartTimer("Charge", TWISTER_CHARGE_COOLDOWN)
        end

        inst.sg:GoToState("attack")
    end
end

local actionhandlers = {}

local events =
{
    CommonHandlers.OnLocomote(true, true),
    CommonHandlers.OnDeath(),
    EventHandler("doattack", onattackfn),
    EventHandler("attacked", onattackedfn),
}

local states =
{

    State {
        name = "idle",
        tags = { "idle" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_loop")
            inst.components.vacuum:SpitItem()

            local map = TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

            if TileGroupManager:IsOceanTile(ground) --[[ground == GROUND.OCEAN_COASTAL or
                ground == GROUND.OCEAN_COASTAL_SHORE or
                ground == GROUND.OCEAN_SWELL or
                ground == GROUND.OCEAN_ROUGH or
                ground == GROUND.OCEAN_BRINEPOOL or
                ground == GROUND.OCEAN_WATERLOG or
                ground == GROUND.OCEAN_BRINEPOOL_SHORE or
                ground == GROUND.OCEAN_HAZARDOUS]] then
                inst.AnimState:Show("twister_water_fx")
            else
                inst.AnimState:Hide("twister_water_fx")
            end
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    ----------------------COMBAT------------------------

    State {
        name = "hit",
        tags = { "hit", "busy" },

        onenter = function(inst, cb)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("hit")
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/hit")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "attack",
        tags = { "attack", "busy", "canrotate" },

        onenter = function(inst)
            inst.SoundEmitter:SetParameter("wind_loop", "intensity", 1)

            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end

            if math.random(1, 2) == 1 then
                inst.components.combat:StartAttack()
                inst.AnimState:PlayAnimation("atk")
            else
                inst:DoTaskInTime(10 * FRAMES, function(inst)
                    inst.AnimState:PlayAnimation("atk")
                    local target = inst.components.combat.target
                    if target ~= nil then
                        local tornado = SpawnPrefab("twister_tornado")
                        tornado.WINDSTAFF_CASTER = inst
                        tornado.WINDSTAFF_CASTER_ISPLAYER = false
                        tornado.Transform:SetPosition(inst:GetPosition():Get())
                        tornado.components.knownlocations:RememberLocation("target", target:GetPosition())
                    end
                end)
            end
        end,

        onexit = function(inst)
            inst.SoundEmitter:SetParameter("wind_loop", "intensity", 0)
        end,

        timeline =
        {
            TimeEvent(4 * FRAMES, function(inst)
                --                inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/attack_pre")
            end),

            TimeEvent(31 * FRAMES, function(inst)
                --                inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/attack_swipe")
            end),

            TimeEvent(33 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/attack_hit")
                inst.components.combat:DoAttack()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.CanVacuum then
                    local map = TheWorld.Map
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

                    if TileGroupManager:IsOceanTile(ground) --[[ground == GROUND.OCEAN_COASTAL or
                        ground == GROUND.OCEAN_COASTAL_SHORE or
                        ground == GROUND.OCEAN_SWELL or
                        ground == GROUND.OCEAN_ROUGH or
                        ground == GROUND.OCEAN_BRINEPOOL or
                        ground == GROUND.OCEAN_BRINEPOOL_SHORE or
                        ground == GROUND.OCEAN_WATERLOG or
                        ground == GROUND.OCEAN_HAZARDOUS]] then
                        inst.sg:GoToState("waves_antic_pre")
                    else
                        inst.sg:GoToState("vacuum_antic_pre")
                    end
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State {
        name = "vacuum_antic_pre",
        tags = { "attack", "busy", "vacuo" },

        onenter = function(inst)
            local vento = SpawnPrefab("ventania")
            vento.Transform:SetPosition(inst:GetPosition():Get())
            TheMixer:PushMix("twister")
            inst.SoundEmitter:SetParameter("wind_loop", "intensity", 1)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("vacuum_antic_pre")
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/vacuum_antic_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("vacuum_antic_loop") end),
        },
    },

    State {
        name = "vacuum_antic_loop",
        tags = { "attack", "busy", "vacuo" },

        onenter = function(inst)
            local vento = SpawnPrefab("ventania")
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("vacuum_antic_loop", true)

            inst.sg:SetTimeout(TWISTER_VACUUM_ANTIC_TIME)

            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/vacuum_antic_LP", "vacuum_antic_loop")
        end,

        onexit = function(inst)
            inst.SoundEmitter:KillSound("vacuum_antic_loop")
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("vacuum_pre")
        end,
    },

    State {
        name = "vacuum_pre",
        tags = { "attack", "busy", "vacuo" },

        onenter = function(inst)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("vacuum_pre")
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/vacuum_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("vacuum_loop") end),
        },
    },

    State {
        name = "vacuum_loop",
        tags = { "attack", "busy", "vacuo" },

        onenter = function(inst)
            local vento = SpawnPrefab("ventania")
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end

            inst.CanVacuum = false
            inst.AnimState:PlayAnimation("vacuum_loop", true)


            inst.components.vacuum.vacuumradius = TWISTER_PLAYER_VACUUM_DISTANCE
            inst.components.vacuum.ignoreplayer = false
            inst.sg:SetTimeout(TWISTER_VACUUM_TIME)

            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/vacuum_hit")
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/vacuum_LP", "vacuum_loop")
        end,

        onexit = function(inst)
            if not inst.components.timer:TimerExists("Vacuum") then
                inst.components.timer:StartTimer("Vacuum", TWISTER_VACUUM_COOLDOWN)
            end

            inst.components.vacuum.spitplayer = true
            inst.components.vacuum.vacuumradius = TWISTER_VACUUM_DISTANCE
            inst.components.vacuum.ignoreplayer = true

            inst.SoundEmitter:KillSound("vacuum_loop")
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("vacuum_pst")
        end,
    },

    State {
        name = "vacuum_pst",
        tags = { "attack", "busy", "vacuo" },

        onenter = function(inst)
            local vento = SpawnPrefab("ventania")
            TheMixer:PopMix("twister")

            inst.SoundEmitter:SetParameter("wind_loop", "intensity", 0)

            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("vacuum_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "waves_antic_pre",
        tags = { "attack", "busy", "vacuo" },

        onenter = function(inst)
            TheMixer:PushMix("twister")
            inst.SoundEmitter:SetParameter("wind_loop", "intensity", 1)

            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("vacuum_antic_pre")
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/vacuum_antic_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("waves_antic_loop") end),
        },
    },

    State {
        name = "waves_antic_loop",
        tags = { "attack", "busy", "vacuo" },

        onenter = function(inst)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("vacuum_antic_loop", true)
            inst.sg:SetTimeout(TWISTER_WAVES_ANTIC_TIME)

            inst.sg.statemem.maxwaves = 4
            inst.sg.statemem.waves = 1
            inst.sg.statemem.wavetime = FRAMES * 30
            inst.sg.statemem.wavetimer = FRAMES * 30

            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/vacuum_antic_LP", "vacuum_antic_loop")
        end,

        onupdate = function(inst, dt)
            inst.sg.statemem.wavetimer = inst.sg.statemem.wavetimer + dt
            if inst.sg.statemem.wavetimer >= inst.sg.statemem.wavetime and inst.sg.statemem.waves <= inst.sg.statemem.maxwaves then
                SpawnWavesSW(inst, math.random(10, 15), 360, 6, nil, nil, 2, true, true)
                inst.sg.statemem.waves = inst.sg.statemem.waves + 1
                inst.sg.statemem.wavetimer = 0
            end
        end,

        onexit = function(inst)
            inst.SoundEmitter:KillSound("vacuum_antic_loop")
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("waves_pre")
        end,
    },

    State {
        name = "waves_pre",
        tags = { "attack", "busy", "vacuo" },

        onenter = function(inst)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("vacuum_pre")
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/vacuum_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("waves_loop") end),
        },
    },

    State {
        name = "waves_loop",
        tags = { "attack", "busy", "vacuo" },

        onenter = function(inst)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end

            inst.AnimState:PlayAnimation("vacuum_loop", true)

            inst.CanVacuum = false

            inst.sg.statemem.wavetime = FRAMES * 24
            inst.sg.statemem.wavetimer = FRAMES * 24

            inst.sg:SetTimeout(TWISTER_WAVES_TIME)


            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/vacuum_hit")
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/vacuum_LP", "vacuum_loop")
        end,

        onexit = function(inst)
            if not inst.components.timer:TimerExists("Vacuum") then
                inst.components.timer:StartTimer("Vacuum", TWISTER_VACUUM_COOLDOWN)
            end

            inst.SoundEmitter:KillSound("vacuum_loop")
        end,

        onupdate = function(inst, dt)
            inst.sg.statemem.wavetimer = inst.sg.statemem.wavetimer + dt
            if inst.sg.statemem.wavetimer >= inst.sg.statemem.wavetime then
                SpawnWavesSW(inst, math.random(11, 12), 360, 12, nil, nil, 3, true, true)
                inst.sg.statemem.wavetimer = 0
            end
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("waves_pst")
        end,
    },

    State {
        name = "waves_pst",
        tags = { "attack", "busy", "vacuo" },

        onenter = function(inst)
            TheMixer:PopMix("twister")

            inst.SoundEmitter:SetParameter("wind_loop", "intensity", 0)

            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("vacuum_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            TheMixer:PopMix("twister")
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
                inst.components.vacuum:TurnOff()
            end
            local map = TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))
            if TileGroupManager:IsOceanTile(ground) --[[ground == GROUND.OCEAN_COASTAL or
                ground == GROUND.OCEAN_COASTAL_SHORE or
                ground == GROUND.OCEAN_SWELL or
                ground == GROUND.OCEAN_ROUGH or
                ground == GROUND.OCEAN_BRINEPOOL or
                ground == GROUND.OCEAN_BRINEPOOL_SHORE or
                ground == GROUND.OCEAN_WATERLOG or
                ground == GROUND.OCEAN_HAZARDOUS]] then
                inst.AnimState:PlayAnimation("death_water")
            else
                inst.AnimState:PlayAnimation("death")
            end

            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/death")
        end,

        timeline =
        {
            TimeEvent(4 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/seal_fly")
            end),

            TimeEvent(40 * FRAMES, function(inst)
                inst.components.inventory:DropEverything(true, true)
                inst.components.lootdropper:DropLoot()
                inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/seal_groundhit")
            end),

            TimeEvent(25 * FRAMES, function(inst)
            end),

            TimeEvent(50 * FRAMES, function(inst)
                local seal = SpawnPrefab("twister_seal")
                seal.Transform:SetPosition(inst:GetPosition():Get())
                seal.sg:GoToState("dizzy")
                inst:Remove()
            end),
        },
    },

    ----------------WALKING---------------

    State {
        name = "walk_start",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("walk_pre")


            local map = TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

            if TileGroupManager:IsOceanTile(ground) --[[ground == GROUND.OCEAN_COASTAL or
                ground == GROUND.OCEAN_COASTAL_SHORE or
                ground == GROUND.OCEAN_SWELL or
                ground == GROUND.OCEAN_ROUGH or
                ground == GROUND.OCEAN_BRINEPOOL or
                ground == GROUND.OCEAN_BRINEPOOL_SHORE or
                ground == GROUND.OCEAN_WATERLOG or
                ground == GROUND.OCEAN_HAZARDOUS]] then
                inst.AnimState:Show("twister_water_fx")
            else
                inst.AnimState:Hide("twister_water_fx")
            end
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("walk") end),
        },
    },

    State {
        name = "walk",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("walk_loop")
            inst.components.locomotor:WalkForward()
            inst.components.vacuum:SpitItem()


            local map = TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

            if TileGroupManager:IsOceanTile(ground) --[[ground == GROUND.OCEAN_COASTAL or
                ground == GROUND.OCEAN_COASTAL_SHORE or
                ground == GROUND.OCEAN_SWELL or
                ground == GROUND.OCEAN_ROUGH or
                ground == GROUND.OCEAN_BRINEPOOL or
                ground == GROUND.OCEAN_BRINEPOOL_SHORE or
                ground == GROUND.OCEAN_WATERLOG or
                ground == GROUND.OCEAN_HAZARDOUS]] then
                inst.AnimState:Show("twister_water_fx")
            else
                inst.AnimState:Hide("twister_water_fx")
            end
        end,

        timeline =
        {
            TimeEvent(24 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/walk") end)
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("walk") end),
        },
    },

    State {
        name = "walk_stop",
        tags = { "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("walk_pst")


            local map = TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

            if TileGroupManager:IsOceanTile(ground) --[[ground == GROUND.OCEAN_COASTAL or
                ground == GROUND.OCEAN_COASTAL_SHORE or
                ground == GROUND.OCEAN_SWELL or
                ground == GROUND.OCEAN_ROUGH or
                ground == GROUND.OCEAN_BRINEPOOL or
                ground == GROUND.OCEAN_BRINEPOOL_SHORE or
                ground == GROUND.OCEAN_WATERLOG or
                ground == GROUND.OCEAN_HAZARDOUS]] then
                inst.AnimState:Show("twister_water_fx")
            else
                inst.AnimState:Hide("twister_water_fx")
            end
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "run_start",
        tags = { "moving", "running", "atk_pre", "canrotate" },

        onenter = function(inst)
            inst.SoundEmitter:SetParameter("wind_loop", "intensity", 1)

            inst.CanCharge = false
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("charge_pre")
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/charge_roar")
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/run_charge_up")


            local map = TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

            if TileGroupManager:IsOceanTile(ground) --[[ground == GROUND.OCEAN_COASTAL or
                ground == GROUND.OCEAN_COASTAL_SHORE or
                ground == GROUND.OCEAN_SWELL or
                ground == GROUND.OCEAN_ROUGH or
                ground == GROUND.OCEAN_BRINEPOOL or
                ground == GROUND.OCEAN_BRINEPOOL_SHORE or
                ground == GROUND.OCEAN_WATERLOG or
                ground == GROUND.OCEAN_HAZARDOUS]] then
                inst.AnimState:Show("twister_water_fx")
            else
                inst.AnimState:Hide("twister_water_fx")
            end
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("run") end),
        },
    },

    State {
        name = "run",
        tags = { "moving", "running" },

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("charge_roar_loop")
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/run_charge_up")
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/twister/charge_roar")

            local map = TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

            if TileGroupManager:IsOceanTile(ground) --[[ground == GROUND.OCEAN_COASTAL or
                ground == GROUND.OCEAN_COASTAL_SHORE or
                ground == GROUND.OCEAN_SWELL or
                ground == GROUND.OCEAN_ROUGH or
                ground == GROUND.OCEAN_BRINEPOOL or
                ground == GROUND.OCEAN_BRINEPOOL_SHORE or
                ground == GROUND.OCEAN_WATERLOG or
                ground == GROUND.OCEAN_HAZARDOUS]] then
                inst.AnimState:Show("twister_water_fx")
            else
                inst.AnimState:Hide("twister_water_fx")
            end
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("run_stop") end),
        },
    },

    State {
        name = "run_stop",
        tags = { "canrotate" },

        onenter = function(inst)
            inst.SoundEmitter:SetParameter("wind_loop", "intensity", 0)

            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("charge_pst")


            local map = TheWorld.Map
            local x, y, z = inst.Transform:GetWorldPosition()
            local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

            if TileGroupManager:IsOceanTile(ground) --[[ground == GROUND.OCEAN_COASTAL or
                ground == GROUND.OCEAN_COASTAL_SHORE or
                ground == GROUND.OCEAN_SWELL or
                ground == GROUND.OCEAN_ROUGH or
                ground == GROUND.OCEAN_BRINEPOOL or
                ground == GROUND.OCEAN_BRINEPOOL_SHORE or
                ground == GROUND.OCEAN_WATERLOG or
                ground == GROUND.OCEAN_HAZARDOUS]] then
                inst.AnimState:Show("twister_water_fx")
            else
                inst.AnimState:Hide("twister_water_fx")
            end
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
}

return StateGraph("twister", states, events, "idle", actionhandlers)
