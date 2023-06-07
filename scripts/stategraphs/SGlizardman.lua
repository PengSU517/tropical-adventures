require("stategraphs/commonstates")

local actionhandlers =
{
	ActionHandler(ACTIONS.EAT, "eat"),
	ActionHandler(ACTIONS.GOHOME, "gohome"),
}

if rawget(_G, "GF") ~= nil then
    table.insert(actionhandlers, 
        ActionHandler(ACTIONS.GFCASTSPELL, function(inst)
            local act = inst:GetBufferedAction()
            return act.spell ~= nil and "cast" or "idle"
        end))
end


local events =
{
	EventHandler("attacked", function(inst) if not inst.components.health:IsDead() and (inst.sg:HasStateTag("attack") or math.random() <= 0.2) then inst.sg:GoToState("hit") end end),
	EventHandler("death", function(inst) inst.sg:GoToState("death") end),
	EventHandler("doattack", function(inst, data) 
		if not inst.components.health:IsDead() 
			and (inst.sg:HasStateTag("hit") 
			or not inst.sg:HasStateTag("busy")) 
		then 
			if inst:IsNear(data.target, 3) then
				inst.sg:GoToState("attack", data.target) 
			else
				inst.sg:GoToState("spit_attack", data.target) 
			end
		end 
	end),
	CommonHandlers.OnSleep(),
	CommonHandlers.OnLocomote(true, false),
	CommonHandlers.OnFreeze(),
}

local states=
{

	State{
		name = "gohome",
		tags = {"busy"},
		onenter = function(inst)
			inst.AnimState:PlayAnimation("run_pst")
		end,

		events=
		{
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("idle") 
				inst:PerformBufferedAction()
			end),
		},
	},

	State{
		name = "idle",
		tags = {"idle", "canrotate"},
		onenter = function(inst, playanim)
			--inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/snake/idle")
			inst.Physics:Stop()
			if playanim then
				inst.AnimState:PlayAnimation(playanim)
				inst.AnimState:PushAnimation("idle_loop", true)
			else
				inst.AnimState:PlayAnimation("idle_loop", true)
			end
			inst.sg:SetTimeout(2*math.random()+.5)
		end,

	},

	State{
		name = "attack",
		tags = {"attack", "busy"},

		onenter = function(inst, target)
			inst.sg.statemem.target = target
			inst.Physics:Stop()
			inst.components.combat:StartAttack()
			inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/snapper/attack")
			inst.AnimState:PlayAnimation("attack", false)
		end,

		timeline=
		{
			TimeEvent(8*FRAMES, function(inst) 
				if inst.sg.statemem.target and inst.sg.statemem.target:IsValid() then 
					inst:ForceFacePoint(inst.sg.statemem.target:GetPosition()) 
				end 
			end),
			TimeEvent(18*FRAMES, function(inst) 
				inst.components.combat:DoAttack(inst.sg.statemem.target)
			end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "cast",
		tags = {"attack", "busy"},

		onenter = function(inst, target)
			inst.Physics:Stop()
			inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/snapper/attack")
			inst.AnimState:PlayAnimation("spit", false)
		end,

		timeline=
		{
			TimeEvent(18 * FRAMES, function(inst) 
				inst:PerformBufferedAction()
			end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "spit_attack",
		tags = {"attack", "busy"},

		onenter = function(inst, target)
			inst.sg.statemem.target = target
			inst.Physics:Stop()
			if inst.weapon and inst.components.inventory then
				inst.components.inventory:Equip(inst.weapon)
			end
			inst.components.combat:StartAttack()
			inst.AnimState:PlayAnimation("spit", false)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/snapper/spit")  
		end,

		onexit = function(inst)
            if inst.components.inventory then
                inst.components.inventory:Unequip(EQUIPSLOTS.HANDS)
            end
        end,

		timeline=
		{
			TimeEvent(15*FRAMES, function(inst)
				if inst.sg.statemem.target and inst.sg.statemem.target:IsValid() then 
					inst:ForceFacePoint(inst.sg.statemem.target:GetPosition())
				end
				if inst.weapon and inst.weapon.components.weapon.stimuli == "electric" then
					inst.components.combat:DoAttack(inst.sg.statemem.target, nil, nil, "electric")
				else
					inst.components.combat:DoAttack(inst.sg.statemem.target)
				end
			end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "eat",
		tags = {"busy"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("attack")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/snapper/attack") 
		end,

		timeline=
		{
			--TimeEvent(14*FRAMES, function(inst) end), --inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/snake/attack") end),
			TimeEvent(15*FRAMES, function(inst) 
				if inst:PerformBufferedAction() then
					inst.components.combat:SetTarget(nil) 
					inst.starvationLevel = 0
				end 
			end),
		},

		events=
		{
			EventHandler("animover", function(inst)  inst.sg:GoToState("idle")  end),
		},
	},

	State{
		name = "hit",
		tags = {"busy", "hit"},

		onenter = function(inst, cb)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("hit")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/snapper/hit")
			--inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/snake/hurt")
		end,

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "taunt",
		tags = {"busy"},

		onenter = function(inst, cb)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("taunt")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/snapper/taunt") 
		end,

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
		},
	},

	State{
		name = "death",
		tags = {"busy"},

		onenter = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/snapper/death") 
			inst.AnimState:PlayAnimation("death")
			inst.Physics:Stop()
			RemovePhysicsColliders(inst)            
			inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
		end,

	},
}

CommonStates.AddSleepStates(states,
{
	sleeptimeline = {
		TimeEvent(30*FRAMES, function(inst) 
			inst.SoundEmitter:PlaySound("dontstarve/creatures/lava_arena/snapper/sleep") 
		end),
	},
})


CommonStates.AddRunStates(states,
{
	runtimeline = {
		TimeEvent(0, function(inst) end), -- inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/snake/move") end),
		TimeEvent(4, function(inst) end), --inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/snake/move") end),
	},
})
CommonStates.AddFrozenStates(states)


return StateGraph("lizardman", states, events, "taunt", actionhandlers)
