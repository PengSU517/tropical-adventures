require("stategraphs/commonstates")

local actionhandlers =
{

    -- ActionHandler(ACTIONS.GOHOME, "action"),
}

local events =
{
    EventHandler("fly", function(inst) inst.sg:GoToState("fly") end),
    EventHandler("land", function(inst) inst.sg:GoToState("land") end),
    EventHandler("liftoff", function(inst) inst.sg:GoToState("liftoff") end),
    EventHandler("takeoff", function(inst) inst.sg:GoToState("takeoff") end),

}


local states =
{
    State {
        name = "idle",
        tags = { "idle" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("ground_loop")
        end,

        events =
        {
            EventHandler("animover", function(inst, data)
                inst.sg:GoToState("idle")
            end),
        }
    },

    State {
        name = "land",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("ground_pre")
        end,


        timeline =
        {
            TimeEvent(30 * FRAMES, function(inst)
                inst.components.roccontroller:Spawnbodyparts()
            end),
            TimeEvent(5 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/roc/flap", "flaps")
                inst.SoundEmitter:SetParameter("flaps", "intensity", inst.sounddistance)
            end),
            TimeEvent(17 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/roc/flap", "flaps")
                inst.SoundEmitter:SetParameter("flaps", "intensity", inst.sounddistance)
            end),
        },

        events =
        {
            EventHandler("animover", function(inst, data)
                inst.sg:GoToState("idle")
            end),
        }
    },

    State {
        name = "liftoff",
        tags = {},

        onenter = function(inst)
            local controller = inst.components.roccontroller
            local head = controller.head
            if head then
                head:DoTaskInTime(1, function() head:PushEvent("taunt") end)
                head:ListenForEvent("animover", function()
                    if head.AnimState:IsCurrentAnimation("taunt") then
                        controller:doliftoff()
                    end
                end)
            end
        end,

        ontimeout = function(inst)
            -- inst.sg:GoToState("idle")
        end,
    },


    State {
        name = "takeoff",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
        end,

        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.AnimState:PlayAnimation("ground_pst")
            end),

            TimeEvent(15 * FRAMES, function(inst)
                inst.components.locomotor.runspeed = 5
                inst.components.locomotor:RunForward()
            end),

        },


        events =
        {
            EventHandler("animover", function(inst, data)
                if inst.AnimState:IsCurrentAnimation("ground_pst") then
                    inst.sg:GoToState("fly")
                    inst.components.roccontroller.stage = inst.components.roccontroller.stage + 1
                end
            end),
        }
    },


    State {
        name = "fly",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.sg:SetTimeout(1 + 2 * math.random())
            inst.AnimState:PlayAnimation("shadow")
        end,

        onupdate = function(inst)

        end,

        ontimeout = function(inst)
            inst.sg:GoToState("flap")
        end,
    },

    State {
        name = "flap",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("shadow_flap_loop")
        end,

        timeline =
        {
            TimeEvent(16 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/roc/flap", "flaps")
                inst.SoundEmitter:SetParameter("flaps", "intensity", inst.sounddistance)
            end),

            TimeEvent(1 * FRAMES, function(inst)
                if math.random() < 0.5 then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/roc/call", "calls")
                end
                inst.SoundEmitter:SetParameter("calls", "intensity", inst.sounddistance)
            end),
        },
        onupdate = function(inst)

        end,

        events =
        {
            EventHandler("animover", function(inst)
                if not inst.flap then
                    inst.sg:GoToState("flap")
                    inst.flap = true
                else
                    inst.sg:GoToState("fly")
                    inst.flap = nil
                end
            end),
        },
    },
}

return StateGraph("roc", states, events, "idle", actionhandlers)
