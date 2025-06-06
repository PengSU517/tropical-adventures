local TIMEOUT = 2

local plant_symbols = 
{
     "waterpuddle",
     "sparkle",
     "puddle",
     "plant",
     "lunar_mote3",
     "lunar_mote",
     "glow",
     "blink"
}

local statue_symbols = 
{
     "ww_head",
     "ww_limb",
     "ww_meathand",
     "ww_shadow",
     "ww_torso",
     "frame",
     "rope_joints",
     "swap_grown"
}

local IronLordStates = 
{     
     State {
          name = "morph",
          tags = { "busy", "transform", "artifact_busy" },
          server_states = { "morph" },
  
          onenter = function(inst)
               inst.components.locomotor:StopMoving()
               inst.AnimState:PlayAnimation("morph_idle")
               inst.AnimState:PushAnimation("morph_complete",false)
               inst:PerformPreviewBufferedAction()

               inst.sg:SetTimeout(TIMEOUT)
          end,

          ontimeout = function(inst)
               inst:ClearBufferedAction()
               inst.sg:GoToState("idle", true)
          end,
  
          events=
          {
               EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
          },
     },

     State{
          name = "explode",
          tags = { "busy", "transform", "explode", "artifact_busy" },
          server_states = { "explode" },
          
          onenter = function(inst) 
               inst.components.locomotor:Stop()
               inst.AnimState:PlayAnimation("suit_destruct")
               inst:PerformPreviewBufferedAction()

               inst.sg:SetTimeout(TIMEOUT)
          end,

          ontimeout = function(inst)
               inst:ClearBufferedAction()
               inst.sg:GoToState("idle", true)
          end,
  
          events=
          {
               EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
          },
     },

     State{
          name = "work",
          tags = { "working" },
          server_states = { "work" },
          
          onenter = function(inst)
               inst.AnimState:PlayAnimation("power_punch")
               inst:PerformPreviewBufferedAction()

               inst.sg:SetTimeout(TIMEOUT)
          end,

          ontimeout = function(inst)
               inst:ClearBufferedAction()
               inst.sg:GoToState("idle", true)
          end,

          onupdate = function(inst)
			if not inst.bufferedaction then
                    inst.sg:GoToState("idle", true)
               end
          end,

          events = 
          {
               EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
          },
     },

     State{
          name = "punch",
          tags = { "attack", "notalking", "abouttoattack", "autopredict" },
          server_states = { "punch" },
  
          onenter = function(inst)
               inst.sg.statemem.action = inst:GetBufferedAction()
               local target = inst.sg.statemem.action.target
               if target and target:IsValid() then
                    inst:FacePoint(target:GetPosition())
                    inst.sg.statemem.attacktarget = target
                    inst.sg.statemem.retarget = target
               end
               inst.components.locomotor:Stop()
               inst.replica.combat:StartAttack()
               inst.AnimState:PlayAnimation("power_punch")
               inst:PerformPreviewBufferedAction()

               inst.sg:SetTimeout(TIMEOUT)
          end,

          ontimeout = function(inst)
               inst:ClearBufferedAction()
               inst.sg:GoToState("idle", true)
          end,

          timeline =
          {
               TimeEvent(6*FRAMES, function(inst) 
                    inst.sg:RemoveStateTag("abouttoattack") 
               end),
               TimeEvent(7*FRAMES, function(inst)
                    inst.sg:RemoveStateTag("attack")
                    inst.sg:AddStateTag("idle")
               end),
          },
  
          events =
          {
               EventHandler("animover", function(inst) 
                    inst.sg:GoToState("idle") 
               end),
          },
  
          onexit = function(inst)
               if inst.sg:HasStateTag("abouttoattack") then
                    inst.replica.combat:CancelAttack()
               end
          end,
     },

     State{
          name = "charge",
          tags = { "busy", "doing", "nopredict" },
          server_states = { "charge" },

          onenter = function(inst)
               inst.components.locomotor:Stop()
               inst.AnimState:PlayAnimation("charge_pre")
               inst.AnimState:PushAnimation("charge_grow")

               local buffaction = inst:GetBufferedAction()
               inst.target = buffaction and buffaction.target
               inst:ForceFacePoint(inst.target and inst.target:GetPosition() or inst.targetpos)
               inst:PerformPreviewBufferedAction()

               inst.sg:SetTimeout(TIMEOUT)
          end,

          ontimeout = function(inst)
               inst:ClearBufferedAction()
               inst.sg:GoToState("idle", true)
          end,

          onexit = function(inst)
               inst:ClearBufferedAction()
               inst.rightbuttonup = nil
               inst.shoot = nil
               inst.readytoshoot = nil
          end,

          onupdate = function(inst)
               if inst.rightbuttonup then
                    inst.rightbuttonup = nil
                    inst.shoot = true
               end

               if inst.shoot and inst.readytoshoot then
                    inst.sg:GoToState("shoot")
               end
          end,

          timeline=
          {
               TimeEvent(15*FRAMES, function(inst) inst.readytoshoot = true end),
               TimeEvent(20*FRAMES, function(inst) 
                    inst:AddTag("charged")
                    inst.sg:GoToState("chargefull") 
               end),
          },
     },

     State{
          name = "chargefull",
          tags = { "busy", "doing", "transform", "nopredict" },
          server_states = { "chargefull" },
          
          onenter = function(inst)
               inst.components.locomotor:Stop()
               inst.AnimState:PlayAnimation("charge_super_pre")
               inst.AnimState:PushAnimation("charge_super_loop",true)
               inst.rightbuttonup = nil
               inst.fullcharge = true
          end,
  
          onexit = function(inst)
               inst:ClearBufferedAction()
               inst.rightbuttonup = nil
               if not inst.shooting then
                    inst.fullcharge = nil
               end
               inst.shoot = nil
               inst.shooting = nil
               inst:RemoveTag("charged")
          end,
  
          onupdate = function(inst)
               if inst.rightbuttonup then
                    inst.rightbuttonup = nil
                    inst.shoot = true 
               end
     
               if inst.shoot and inst.readytoshoot then
                    inst.shooting = true
                    inst.sg:GoToState("shoot")
               end
     
               inst:ForceFacePoint(inst.targetpos)
          end,

          timeline=
          {
               TimeEvent(5*FRAMES, function(inst) inst.readytoshoot = true end),
          },
     },

     State{
          name = "shoot",
          tags = { "busy", "transform", "attack" },
          server_states = { "shoot" },
          
          onenter = function(inst) 
               inst.components.locomotor:Stop()
               if inst.fullcharge then
                    inst.AnimState:PlayAnimation("charge_super_pst")
               else
                    inst.AnimState:PlayAnimation("charge_pst")
               end

               inst.sg:SetTimeout(TIMEOUT)
          end,

          ontimeout = function(inst)
               inst:ClearBufferedAction()
               inst.sg:GoToState("idle", true)
          end,
          
          timeline=
          {
               TimeEvent(5*FRAMES, function(inst) inst.sg:RemoveStateTag("busy") end),
          }, 
          
          onexit = function(inst)
               inst.fullcharge = nil   
          end,
  
          events=
          {
               EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
          },             
     },

     State{
          name = "magic_rebirth",
          tags = { "busy", "silentmorph", "nopredict" },
          server_states = { "magic_rebirth" },

          onenter = function(inst)
               inst.AnimState:PlayAnimation("rebirth2")
               for _,v in pairs(plant_symbols) do
                    inst.AnimState:OverrideSymbol(v, "lifeplant", v)
               end

               inst.sg:SetTimeout(TIMEOUT)
          end,

          ontimeout = function(inst)
               inst.sg:GoToState("idle", true)
          end,

          onexit = function(inst)
               for k,v in pairs(statue_symbols) do
                    inst.AnimState:ClearOverrideSymbol(v)
               end
          end,

          events=
          {
               EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
          },
     },
}

for _,state in pairs(IronLordStates) do
     AddStategraphState("wilson_client", state)
end