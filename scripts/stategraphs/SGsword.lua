require("stategraphs/commonstates")

local actionhandlers = 
{
}

local events=
{
	CommonHandlers.OnSleep(),	
	CommonHandlers.OnLocomote(false,true),
	CommonHandlers.OnAttack(),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
}

local states=
{
	--This handles the idle state.
    State{

        name = "idle",
        tags = {"idle", "canrotate"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle", true)
		end,

    },
	
	State{
        name = "walk_start",
        tags = {"moving", "canrotate"},

        onenter = function(inst) 
			inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk")
        end,

        events =
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("walk") end ),        
        },
    },
        
    State{            
        name = "walk",
        tags = {"moving"},
        
        onenter = function(inst) 
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk")
        end,

        events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("walk_start") end ),        
        },
    },      
    
    State{            
        name = "walk_stop",
        tags = {"canrotate"},
        
        onenter = function(inst) 
        inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("walk_pst", false)
        end,

        events=
        {   
            
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),        
        },
    },
	
    State{
        name = "attack",
        tags = {"attack", "busy"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk")
            inst.sg.statemem.target = target
        end,
        
        timeline=
        {
            TimeEvent(10*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
    State{
        name = "hit",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()            
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },
	
	State{
			name = "sleep",
			tags = {"busy", "sleeping"},

			onenter = function(inst)
				inst.components.locomotor:StopMoving()
					inst.AnimState:PushAnimation("sleep_pre", false)

			end,

			events=
			{
				EventHandler("animqueueover", function(inst) inst.sg:GoToState("sleeping") end ),
				EventHandler("onwakeup", function(inst) inst.sg:GoToState("wake") end),
			},

		},

		State{

			name = "sleeping",
			tags = {"busy", "sleeping"},

			onenter = function(inst)
				inst.Physics:Stop()
				inst.AnimState:PlayAnimation("sleep")
			end,

			events=
			{
				EventHandler("animover", function(inst) inst.sg:GoToState("sleeping") end ),
				EventHandler("onwakeup", function(inst) inst.sg:GoToState("wake") end),
			},
		},

		State{

			name = "wake",
			tags = {"busy", "waking"},

			onenter = function(inst)
				inst.components.locomotor:StopMoving()
				inst.AnimState:PlayAnimation("wake")
				if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
					inst.components.sleeper:WakeUp()
				end
			end,

			events=
			{
				EventHandler("animover", function(inst)  inst.sg:GoToState("idle") end ),
			},

			timeline=
			{
			},
		},
	
	State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)                    
        end,
    },   
}

return StateGraph("sword", states, events, "idle", actionhandlers)