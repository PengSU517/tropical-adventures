require("stategraphs/commonstates")

local actionhandlers =
{
    -- ActionHandler(ACTIONS.GOHOME, "action"),
}

SHAKE_DIST = 40

local function ShakeIfClose(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, 1, inst, 40)
end

local function ShakeIfClose_Pound(inst)
    ShakeAllCameras(CAMERASHAKE.VERTICAL, .7, .025, 1.25, inst, 40)
end

local function ShakeIfClose_Footstep(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .35, .02, 1, inst, 40)
end

local events =
{
    EventHandler("enter", function(inst) inst.sg:GoToState("enter") end),
    EventHandler("exit", function(inst) inst.sg:GoToState("exit") end),
    EventHandler("bash", function(inst) inst.sg:GoToState("bash") end),
    EventHandler("eat", function(inst) inst.sg:GoToState("eat") end), --添加吃食物的单独event
    EventHandler("gobble", function(inst) inst.sg:GoToState("grab") end),
    EventHandler("taunt", function(inst) inst.sg:GoToState("taunt") end),
}


local states =
{
    State {
        name = "idle",
        tags = { "idle" },

        onenter = function(inst, pushanim)
            if pushanim then
                inst.AnimState:PlayAnimation(pushanim)
                inst.AnimState:PushAnimation("idle_loop")
            else
                inst.AnimState:PlayAnimation("idle_loop")
            end
        end,

        events =
        {
            EventHandler("animover", function(inst, data)
                inst.sg:GoToState("idle")
            end),
        }
    },

    State {
        name = "bash",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("bash_pre")
            inst.AnimState:PushAnimation("bash_loop", false)
            inst.AnimState:PushAnimation("bash_pst", false)
        end,


        timeline =
        {
            TimeEvent(37 * FRAMES, function(inst)
                inst.components.groundpounder:GroundPound()
                ShakeIfClose_Pound(inst)

                -- local player = GetClosestInstWithTag("player", inst, SHAKE_DIST)
                -- if player then
                --     --					player:ShakeCamera(CAMERASHAKE.SIDE, 2, .06, .25)
                --     --player.components.playercontroller:ShakeCamera(inst, "VERTICAL", 0.5, 0.03, 2, SHAKE_DIST)
                -- end
            end)
        },

        events =
        {
            EventHandler("animqueueover", function(inst, data)
                inst.sg:GoToState("idle")
            end),
        }
    },

    State {
        name = "eat",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("grab_pre")
            inst.AnimState:PushAnimation("grab_loop", false)
            inst.AnimState:PushAnimation("grab_pst", false)
        end,

        timeline =
        {
            TimeEvent(14 * FRAMES,
                function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/roc/attack_3") end),
            TimeEvent(25 * FRAMES,
                function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/roc/attack_2") end),
            TimeEvent(29 * FRAMES,
                function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/roc/attack_1") end),
            TimeEvent(31 * FRAMES, function(inst)
                inst.controller:DoGrab_food()
                -- DoGrab(inst)
            end)
        },

        events =
        {
            EventHandler("animqueueover", function(inst, data)
                inst.sg:GoToState("idle") ----------------------更改为exit但现在有bug
            end),
        }
    },


    State {
        name = "grab",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("grab_pre")
            inst.AnimState:PushAnimation("grab_loop", false)
            inst.AnimState:PushAnimation("grab_pst", false)
        end,

        timeline =
        {
            TimeEvent(14 * FRAMES,
                function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/roc/attack_3") end),
            TimeEvent(25 * FRAMES,
                function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/roc/attack_2") end),
            TimeEvent(29 * FRAMES,
                function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/roc/attack_1") end),
            TimeEvent(31 * FRAMES, function(inst)
                inst.controller:DoGrab_player()
                -- DoGrab(inst)
            end)
        },

        onexit = function(inst)
            if inst.triggerliftoff then
                inst.triggerliftoff = nil
                inst.body:PushEvent("liftoff")
            end
            --            if inst:HasTag("HasPlayer") then
            --                inst.controller:UnchildPlayer(inst)
            --            end
        end,

        events =
        {
            EventHandler("animqueueover", function(inst, data)
                inst.sg:GoToState("idle") ----------------------更改为exit但现在有bug
            end),
        }
    },

    State {
        name = "enter",
        tags = { "idle", "canrotate", "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst, data)
                inst.sg:GoToState("taunt")
            end),
        }
    },

    State {
        name = "taunt",
        tags = { "idle", "canrotate", "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("taunt")
        end,

        timeline =
        {
            TimeEvent(14 * FRAMES,
                function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/roc/attack_3") end),
            TimeEvent(20 * FRAMES,
                function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/roc/attack_2") end),
            TimeEvent(24 * FRAMES,
                function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/roc/attack_1") end),
        },

        events =
        {
            EventHandler("animover", function(inst, data)
                inst.sg:GoToState("idle")
            end),
        }
    },

    State {
        name = "exit",
        tags = { "idle", "canrotate" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst, data)
                -- print("REMOVING ROCK HEAD")
                inst:Remove()
            end),
        }
    },
}

return StateGraph("roc_head", states, events, "idle", actionhandlers)
