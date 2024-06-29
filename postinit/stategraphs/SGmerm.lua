local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

local states =
{
    State{
        name = "fishing_pre",
        tags = {"canrotate", "prefish", "fishing"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("fish_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst:PerformBufferedAction()
                inst.sg:GoToState("fishing")
            end),
        },
    },

    State{
        name = "fishing",
        tags = {"canrotate", "fishing"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("fish_loop", true)
            inst.components.fishingrod:WaitForFish()
        end,

        events =
        {
            EventHandler("fishingnibble", function(inst) inst.sg:GoToState("fishing_nibble") end ),
            EventHandler("fishingloserod", function(inst) inst.sg:GoToState("loserod") end),
        },
    },

    State{
        name = "fishing_pst",
        tags = {"canrotate", "fishing"},
        onenter = function(inst)
            -- inst.AnimState:PushAnimation("fish_loop", true)
            inst.AnimState:PlayAnimation("fish_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "fishing_nibble",
        tags = {"canrotate", "fishing", "nibble"},
        onenter = function(inst)
            inst.AnimState:PushAnimation("fish_loop", true)
            if inst.components.fishingrod.target.components.fishable.fishleft > 0 then
                inst.components.fishingrod:Hook()
            else
                inst.sg:GoToState("fishing_pst")
            end
        end,

        events =
        {
            EventHandler("fishingstrain", function(inst) inst.sg:GoToState("fishing_strain") end),
        },
    },

    State{
        name = "fishing_strain",
        tags = {"canrotate", "fishing"},
        onenter = function(inst)
            inst.components.fishingrod:Reel()
        end,

        events =
        {
            EventHandler("fishingcatch", function(inst, data)
                inst.sg:GoToState("catchfish", data.build)
            end),

            EventHandler("fishingloserod", function(inst)
                -- inst.sg:GoToState("loserod")
                inst.sg:GoToState("fishing_pst")
            end),
        },
    },

    State{
        name = "catchfish",
        tags = {"canrotate", "fishing", "catchfish"},
        onenter = function(inst, build)
            inst.AnimState:PlayAnimation("fishcatch")
            inst.AnimState:OverrideSymbol("fish01", build, "fish01")
        end,

        timeline =
        {
            TimeEvent(10*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("ia/creatures/Merm/whoosh_throw")
            end),
            TimeEvent(14*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("ia/creatures/Merm/spear_water")
            end),
            TimeEvent(34*FRAMES, function(inst)
                inst.components.fishingrod:Collect()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:RemoveStateTag("fishing")
                inst.sg:GoToState("idle")
            end),
        },

        onexit = function(inst)
            inst.AnimState:ClearOverrideSymbol("fish01")
        end,
    },
}

local actionhandlers = {
    ActionHandler(ACTIONS.FISH, "fishing_pre"),
    ActionHandler(ACTIONS.HACK, "chop")
}

for _, state in ipairs(states) do
    IAENV.AddStategraphState("merm", state)
end

for _, actionhandler in ipairs(actionhandlers) do
    IAENV.AddStategraphActionHandler("merm", actionhandler)
end
