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

local function shoot(attacker, target, targetpos)
     local x, y, z = attacker.Transform:GetWorldPosition()
     local angle = attacker.Transform:GetRotation() * GLOBAL.DEGREES
     local radius = 2 
     local offset_x = radius * math.cos(angle)
     local offset_z = radius * math.sin(angle)

     if attacker.fullcharge then
          local beam = SpawnPrefab("ancient_hulk_orb")
          local offset_y = 1.5
          local diff_x = targetpos.x - x 
          local diff_z = targetpos.z - z
          local distsq = diff_x * diff_x + diff_z * diff_z
          if distsq <= radius * radius then  -- too close
               local dist = math.sqrt(distsq)
               offset_x = dist * math.cos(angle)
               offset_z = dist * math.sin(angle)
               offset_y = 0.5
          end
          beam.Transform:SetPosition(x+offset_x, offset_y, z-offset_z)
          beam.components.complexprojectile:Launch(targetpos, attacker)
     else
          local beam = SpawnPrefab("ancient_hulk_orb_small")
          local offset_y = 0.5
          local pos = target and target:GetPosition() or targetpos
          local diff_x = pos.x - x 
          local diff_z = pos.z - z
          local distsq = diff_x * diff_x + diff_z * diff_z
          if distsq <= radius * radius then  -- too close
               targetpos = Vector3(x+offset_x, targetpos.y, z-offset_z)
               
               local dist = math.sqrt(distsq)
               offset_x = dist * math.cos(angle)
               offset_z = dist * math.sin(angle)
               if target then
                    beam.Transform:SetPosition(x+offset_x, offset_y, z-offset_z)
                    beam.components.projectile.attacker = attacker
                    beam.collide(beam, target)
               else
                    -- Temporarily ClearCollisionMask to prevent collide to attacker
                    local mask = beam.Physics:GetCollisionMask()
                    beam.Physics:ClearCollisionMask()
                    beam.Transform:SetPosition(x+offset_x, offset_y, z-offset_z)
                    beam.components.projectile:ArtifactThrow(target, targetpos, attacker)
                    beam:DoTaskInTime(0.1, function() beam.Physics:SetCollisionMask(mask) end)
               end
          else
               beam.Transform:SetPosition(x+offset_x, offset_y, z-offset_z)
               beam.components.projectile:ArtifactThrow(target, targetpos, attacker)
          end
     end
end

local IronLordStates = 
{
     State {
          name = "morph",
          tags = { "busy", "transform", "artifact_busy" },

          onenter = function(inst)
               inst.components.inventory:DropEquipped()
               inst.components.locomotor:StopMoving()
               inst.AnimState:AddOverrideBuild("player_living_suit_morph")
               inst.AnimState:PlayAnimation("morph_idle")
               inst.AnimState:PushAnimation("morph_complete",false)
               inst:PushEvent("ms_closepopups")
               inst:PerformBufferedAction()
               inst:SetCameraDistance(20)
          end,
          
          timeline=
          {
               TimeEvent(0*FRAMES, function(inst)
                    inst.artifact.ToggleLight(inst, true)
                    inst.SoundEmitter:PlaySound("dontstarve_DLC003/music/iron_lord") end),
               TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/iron_lord/morph") end),
               TimeEvent(105*FRAMES, function(inst) GLOBAL.ShakeAllCameras(GLOBAL.CAMERASHAKE.FULL, 0.7, 0.02, .5, inst, 40) end),
               TimeEvent(125*FRAMES, function(inst) 
                    inst.artifact.ToggleVisual(inst, true)
                    inst.artifact.SetNetVar("control", inst, true)
                    inst.artifact.components.fueled:StartConsuming()
                    inst:SetCameraDistance()
               end),
               TimeEvent(152*FRAMES, function(inst) inst.artifact.ToggleBGM(inst, true) end),
          },

          onexit = function(inst)
               if inst:HasTag("preparetodie") then
                    inst.artifact.components.ironmachine:TurnOff()
               end
          end,
  
          events=
          {
               EventHandler("animqueueover", function(inst) 
                    inst.sg:GoToState("idle") 
               end),
          }, 
     },

     State{
          name = "explode",
          tags = { "busy", "transform", "explode", "artifact_busy" },
          
          onenter = function(inst)
               inst.components.inventory:DropEquipped()
               inst.components.locomotor:Stop()
               inst.AnimState:PlayAnimation("suit_destruct") 
               inst:PerformBufferedAction()
               inst:SetCameraDistance(20)
          end,
          
          timeline=
          {
               TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySoundWithParams("dontstarve_DLC003/common/crafted/iron_lord/small_explosion", {intensity= .2}) end),
               TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySoundWithParams("dontstarve_DLC003/common/crafted/iron_lord/small_explosion", {intensity= .4}) end),
               TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySoundWithParams("dontstarve_DLC003/common/crafted/iron_lord/small_explosion", {intensity= .6}) end),
               TimeEvent(19*FRAMES, function(inst) inst.SoundEmitter:PlaySoundWithParams("dontstarve_DLC003/common/crafted/iron_lord/small_explosion", {intensity= 1}) end),
               TimeEvent(26*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/iron_lord/electro",nil,.5) end),
               TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/iron_lord/electro",nil,.5) end),
               TimeEvent(54*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/iron_lord/explosion") end),
               TimeEvent(35*FRAMES, function(inst) inst.artifact.ToggleBGM(inst, false) end), 
               
               TimeEvent(52*FRAMES, function(inst) 
                    local explosion = GLOBAL.SpawnPrefab("living_suit_explode_fx")
                    explosion.Transform:SetPosition(inst.Transform:GetWorldPosition()) 
               end),
          }, 
          
          onexit = function(inst)
               inst.artifact.ToggleVisual(inst, false)
               inst.artifact.SetNetVar("control", inst, false)
               inst.artifact.ToggleComponents(inst, false)

               local state = "bucked_post"
               if inst:HasTag("preparetodie") then
                    inst:RemoveTag("preparetodie")
                    state = "death"
               end

               inst:DoTaskInTime(0, function() inst.sg:GoToState(state) end)
               inst:SetCameraDistance()
          end,
  
          events=
          {
               EventHandler("animover", function(inst) 
                    inst.sg:GoToState("idle") 
               end),
          },             
     }, 

     State{
          name = "work",
          tags = { "working" },
          
          onenter = function(inst)
               inst.sg.statemem.action = inst:GetBufferedAction()
               inst.AnimState:PlayAnimation("power_punch")
          end,
          
          timeline=
          {
               TimeEvent(6*FRAMES, function(inst) inst:PerformBufferedAction() end),
               TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/iron_lord/punch",nil,.5) end),
               TimeEvent(14*FRAMES, function(inst) inst.sg:RemoveStateTag("working") end), 
               TimeEvent(15*FRAMES, function(inst)
                    if inst.components.playercontroller and
                         inst.components.playercontroller:IsAnyOfControlsPressed(
                              CONTROL_PRIMARY, 
                              CONTROL_ACTION, 
                              CONTROL_CONTROLLER_ACTION) and
                         inst.sg.statemem.action and 
                         inst.sg.statemem.action:IsValid() and
                         inst.sg.statemem.action.target and 
                         inst.sg.statemem.action.target.components.workable and
                         inst.sg.statemem.action.target.components.workable:CanBeWorked() and
                         inst.sg.statemem.action.target:IsActionValid(inst.sg.statemem.action.action, true) and
                         CanEntitySeeTarget(inst, inst.sg.statemem.action.target) then
                              --No fast-forward when repeat initiated on server
                         inst.sg.statemem.action.options.no_predict_fastforward = true
                         inst:ClearBufferedAction()
                         inst:PushBufferedAction(inst.sg.statemem.action)
                    end
               end),
          },

          events = 
          {
               EventHandler("animover", function(inst) 
                    inst.sg:GoToState("idle") 
               end),
          }
     },

     State{
          name = "punch",
          tags = { "attack", "notalking", "abouttoattack", "autopredict" },
  
          onenter = function(inst)
               inst.sg.statemem.action = inst:GetBufferedAction()
               local target = inst.sg.statemem.action.target
               if target and target:IsValid() then
                    inst.components.combat:BattleCry()
                    inst:FacePoint(target:GetPosition())
                    inst.sg.statemem.attacktarget = target
                    inst.sg.statemem.retarget = target
               end
               inst.components.locomotor:Stop()
               inst.components.combat:SetTarget(target)
               inst.components.combat:StartAttack()
               inst.AnimState:PlayAnimation("power_punch")
          end,

          timeline =
          {
               TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/iron_lord/punch_pre") end),
               TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/iron_lord/punch") end),
               TimeEvent(6*FRAMES, function(inst)
                    inst:PerformBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
               end),
               TimeEvent(7*FRAMES, function(inst)
                    inst.sg:RemoveStateTag("attack")
                    inst.sg:AddStateTag("idle")
               end),
               TimeEvent(12*FRAMES, function(inst)
                    if inst.components.playercontroller and
                         inst.components.playercontroller:IsAnyOfControlsPressed(
                              CONTROL_PRIMARY, 
                              CONTROL_ATTACK, 
                              CONTROL_FORCE_ATTACK, 
                              CONTROL_CONTROLLER_ATTACK) and
                         inst.sg.statemem.action and 
                         inst.sg.statemem.action:IsValid() and
                         inst.sg.statemem.action.target and 
                         inst.components.combat:CanAttack(inst.sg.statemem.action.target) then
                              --No fast-forward when repeat initiated on server
                         inst.sg.statemem.action.options.no_predict_fastforward = true
                         inst:ClearBufferedAction()
                         inst:PushBufferedAction(inst.sg.statemem.action)
                    end
               end),
          },
  
          events =
          {
               EventHandler("animover", function(inst) 
                    inst.sg:GoToState("idle") 
               end),
          },
  
          onexit = function(inst)
               inst.components.combat:SetTarget(nil)
               if inst.sg:HasStateTag("abouttoattack") then
                    inst.components.combat:CancelAttack()
               end
          end,
     },

     State{
          name = "charge",
          tags = { "busy", "doing", "nopredict" },

          onenter = function(inst)
               inst.components.locomotor:Stop()
               inst.AnimState:PlayAnimation("charge_pre")
               inst.AnimState:PushAnimation("charge_grow")
               inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/iron_lord/charge_up_LP", "chargedup")

               local buffaction = inst:GetBufferedAction()
               inst.target = buffaction and buffaction.target
               inst:ForceFacePoint(inst.target and inst.target:GetPosition() or inst.targetpos)
               inst:PerformBufferedAction()
          end,

          onexit = function(inst)
               inst:ClearBufferedAction()
               inst.rightbuttonup = nil
               inst.shoot = nil
               inst.readytoshoot = nil
               if not inst:HasTag("charged") then
                    inst.SoundEmitter:KillSound("chargedup")
               end
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
          
          onenter = function(inst)
               inst.components.locomotor:Stop()
               inst.AnimState:PlayAnimation("charge_super_pre")
               inst.AnimState:PushAnimation("charge_super_loop",true)
               inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/iron_lord/electro")
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
               inst.SoundEmitter:KillSound("chargedup")
          end,
  
          onupdate = function(inst)
               inst:ForceFacePoint(inst.targetpos)
               
               if inst.rightbuttonup then
                    inst.rightbuttonup = nil
                    inst.shoot = true 
               end
     
               if inst.shoot and inst.readytoshoot then
                    inst.shooting = true
                    inst.SoundEmitter:PlaySoundWithParams("dontstarve_DLC003/creatures/boss/hulk_metal_robot/laser",  {intensity = math.random(0.7, 1)})
                    inst.sg:GoToState("shoot")
               end
          end,

          timeline=
          {
               TimeEvent(5*FRAMES, function(inst) inst.readytoshoot = true end),
          },
     },

     State{
          name = "shoot",
          tags = { "busy", "transform", "attack" },
          
          onenter = function(inst) 
               inst.components.locomotor:Stop()
               if inst.fullcharge then
                    inst.AnimState:PlayAnimation("charge_super_pst")
               else
                    inst.AnimState:PlayAnimation("charge_pst")
               end
               inst.SoundEmitter:PlaySoundWithParams("dontstarve_DLC003/common/crafted/iron_lord/smallshot", {timeoffset=math.random()})
          end,
          
          timeline=
          {
               TimeEvent(1*FRAMES, function(inst) shoot(inst, inst.target, inst.targetpos) end),
               TimeEvent(5*FRAMES, function(inst) inst.sg:RemoveStateTag("busy") end),
          }, 
          
          onexit = function(inst)
               inst.fullcharge = nil   
          end,
  
          events=
          {
               EventHandler("animover", function(inst) 
                    inst.sg:GoToState("idle") 
               end),
          },
     },

     State{
          name = "magic_rebirth",
          tags = { "busy", "silentmorph", "nopredict" },

          onenter = function(inst)
               local x, y, z = inst.Transform:GetWorldPosition()
               for _,v in ipairs(TheSim:FindEntities(x, y, z, 1, {"FX"})) do
                    if v.prefab == "ghost_transform_overlay_fx" or v.prefab == "die_fx" then
                         v:Remove()
                    end
               end

               inst.SoundEmitter:SetMute(false)
               inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/flower_of_life/rebirth")

               inst.components.health:SetInvincible(true)
               if inst.components.playercontroller then
                    inst.components.playercontroller:Enable(false)
               end

               inst.AnimState:PlayAnimation("rebirth2")
               for _,v in pairs(plant_symbols) do
                    inst.AnimState:OverrideSymbol(v, "lifeplant", v)
               end

               inst:ShowHUD(false)
               inst:SetCameraDistance(16)
          end,

          onexit = function(inst)
               for k,v in pairs(statue_symbols) do
                    inst.AnimState:ClearOverrideSymbol(v)
               end

               inst.components.health:SetInvincible(false)
               if inst.components.playercontroller then
                    inst.components.playercontroller:Enable(true)
               end

               inst:ShowHUD(true)
               inst:SetCameraDistance()

               GLOBAL.SerializeUserSession(inst)
          end,

          events=
          {
               EventHandler("animover", function(inst) 
                    inst.sg:GoToState("idle") 
               end),
          },
     },
}

for _,state in pairs(IronLordStates) do
     AddStategraphState("wilson", state)
end