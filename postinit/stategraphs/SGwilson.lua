local AddStategraphState = AddStategraphState
local AddStategraphEvent = AddStategraphEvent
local AddStategraphActionHandler = AddStategraphActionHandler
local AddStategraphPostInit = AddStategraphPostInit

local ActionHandler = GLOBAL.ActionHandler
local EventHandler = GLOBAL.EventHandler
local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent

local FRAMES = GLOBAL.FRAMES
local ACTIONS = GLOBAL.ACTIONS
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS



local actionhandlers = {

}

local eventhandlers = {

    EventHandler("cower", function(inst, data)
        if not (inst.components.health:IsDead() or inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("frozen")) then
            inst.sg:GoToState("cower", data)
        end
    end),

    EventHandler("grabbed", function(inst)
        if not (inst.components.health:IsDead() or inst.components.health:IsInvincible() or
            --[[inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("frozen") or]] inst.sg:HasStateTag("busy")) then
            inst.sg:GoToState("grabbed")
        end
    end),

    EventHandler("disgrabbed", function(inst)
        inst.sg:GoToState("disgrabbed")
    end),
}



local states = {


    State {
        name = "cower",
        tags = { "cower", "pausepredict" },

        onenter = function(inst, data)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("cower")
            inst.components.talker:Say("要被吃掉了!") --GetString(inst, "ANNOUNCE_QUAKE")
        end,

        timeline =
        {

        },

        events =
        {
            -- EventHandler("grabbed", function(inst)
            --     inst.sg:GoToState("grabbed")
            -- end),
        },

    },

    State {
        name = "grabbed",
        tags = { "busy", "pausepredict" },

        onenter = function(inst, data)
            if inst.components.playercontroller then
                inst.components.playercontroller:Enable(false)
            end
            if inst.player_classified and inst.player_classified.MapExplorer then
                inst.player_classified.MapExplorer:EnableUpdate(false)
            end
            -- inst.AnimState:SetFinalOffset(-10)
            inst.components.sanity:DoDelta(-TUNING.SANITY_MED)
            -- inst.components.health:SetInvincible(true)
            inst.AnimState:PlayAnimation("grab_loop")
            -- inst:ShakeCamera(CAMERASHAKE.FULL, 2, .06, .25) -- duration, speed, scale
        end,
        events =
        {
            EventHandler("animover", function(inst)
                inst:Hide()
                if inst.HUD then
                    inst.HUD:Hide()
                end

                if inst.DynamicShadow then
                    inst.DynamicShadow:Enable(false)
                end

                -- inst:SnapCamera(5)
                -- -- inst:ScreenFade(true, 2)
                -- inst:DoTaskInTime(5, function()
                --     local nest = TheSim:FindFirstEntityWithTag("roc_nest")
                --     local nest_pos = nest and Vector3(nest.Transform:GetWorldPosition()) or { 0, 0, 0 }
                --     inst.Transform:SetPosition(nest_pos:Get())
                --     inst:PushEvent("disgrabbed")
                -- end)
            end),
        },
    },

    State {
        name = "disgrabbed",
        tags = { "busy", "pausepredict", "nomorph", "nodangle", "doing" },

        onenter = function(inst)
            -- inst:ScreenFade(false, 2)

            inst:Show()


            if inst.DynamicShadow then
                inst.DynamicShadow:Enable(true)
            end


            inst.AnimState:PlayAnimation("bucked")
            -- inst.AnimState:PushAnimation("buck_pst", false)
            -- inst.AnimState:PushAnimation("idle", false)
        end,



        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
                -- inst.components.health:DoDelta(-TUNING.HEALING_MED) --血量
            end),

            TimeEvent(60 * FRAMES, function(inst)

            end),

            TimeEvent(30 * FRAMES, function(inst)
                inst.AnimState:PushAnimation("wakeup", false)
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:IsCurrentAnimation("wakeup") then
                    -- inst.components.health:SetInvincible(false)
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.HUD then
                inst.HUD:Show()
            end

            if inst.components.playercontroller then
                inst.components.playercontroller:Enable(true)
            end
            if inst.player_classified and inst.player_classified.MapExplorer then
                inst.player_classified.MapExplorer:EnableUpdate(true)
            end
            -- inst.components.playercontroller:Enable(true)
            -- inst.player_classified.MapExplorer:EnableUpdate(true)
        end,
    },
}

for _, actionhandler in ipairs(actionhandlers) do
    AddStategraphActionHandler("wilson", actionhandler)
end

for _, eventhandler in ipairs(eventhandlers) do
    AddStategraphEvent("wilson", eventhandler)
end

for _, state in ipairs(states) do
    AddStategraphState("wilson", state)
end

AddStategraphPostInit("wilson", function(sg)
    local _play_horn_onenter = sg.states["play_horn"].onenter
    sg.states["play_horn"].onenter = function(inst, ...)
        _play_horn_onenter(inst, ...)
        local act = inst:GetBufferedAction()
        if act and act.invobject and act.invobject.hornbuild then
            inst.AnimState:OverrideSymbol("horn01", act.invobject.hornbuild or "horn",
                act.invobject.hornsymbol or "horn01")
        end
    end
    local _play_horn_timeevent_1 = sg.states["play_horn"].timeline[1].fn
    sg.states["play_horn"].timeline[1].fn = function(inst, ...)
        local horn = inst.bufferedaction and inst.bufferedaction.invobject
        if horn:HasTag("new_horn") then
            if inst:PerformBufferedAction() then
                if horn.playsound then
                    inst.SoundEmitter:PlaySound(horn.playsound)
                end
            else
                inst.sg.statemem.action_failed = true
            end
        else
            _play_horn_timeevent_1(inst, ...)
        end
    end
end)

AddStategraphState("wilson", --激光眼镜
     State{
          name = "goggleattack",
          tags = {"attack", "notalking", "abouttoattack"},

          onenter = function(inst)
               if inst.components.rider:IsRiding() then
                    inst.Transform:SetFourFaced()
               end
               local buffaction = inst:GetBufferedAction()
               local target = buffaction ~= nil and buffaction.target or nil
               local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
               if (equip ~= nil and equip.projectiledelay or 0) > 0 then
                    inst.sg.statemem.projectiledelay = (inst.sg.statemem.chained and 9 or 14) * FRAMES - equip.projectiledelay
                    if inst.sg.statemem.projectiledelay <= 0 then
                        inst.sg.statemem.projectiledelay = nil
                    end
               end
               inst.components.combat:SetTarget(target)
               inst.components.combat:StartAttack()
               inst.components.locomotor:Stop()
               inst.AnimState:PlayAnimation("goggle_fast")
               if inst.sg.laststate == inst.sg.currentstate then
                    inst.sg.statemem.chained = true
                    inst.AnimState:SetFrame(5)
               end
               inst.AnimState:PushAnimation("goggle_fast_pst", false)

               inst.sg:SetTimeout(math.max((inst.sg.statemem.chained and 14 or 18) * FRAMES, inst.components.combat.min_attack_period))

               if target ~= nil and target:IsValid() then
                    inst:FacePoint(target.Transform:GetWorldPosition())
                    inst.sg.statemem.attacktarget = target
                    inst.sg.statemem.retarget = target
               end
          end,

          onupdate = function(inst, dt)
               if (inst.sg.statemem.projectiledelay or 0) > 0 then
                    inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay - dt
                    if inst.sg.statemem.projectiledelay <= 0 then
                         inst:PerformBufferedAction()
                         inst.sg:RemoveStateTag("abouttoattack")
                    end
               end
          end,

          timeline=
          {
               TimeEvent(9 * FRAMES, function(inst)
                    if inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                         inst:PerformBufferedAction()
                         inst.sg:RemoveStateTag("abouttoattack")
                    end
               end),
               TimeEvent(14 * FRAMES, function(inst)
                    if not inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                         inst:PerformBufferedAction()
                         inst.sg:RemoveStateTag("abouttoattack")
                         if inst.components.moisture and inst.components.moisture:GetMoisture() > 0 and not inst.components.inventory:IsInsulated() then
                              inst.components.health:DoDelta(-TUNING.HEALING_MEDSMALL, false, "Shockwhenwet", nil, true)
                              inst.sg:GoToState("electrocute")
                         end
                    end
               end),
          },

          ontimeout = function(inst)
               inst.sg:RemoveStateTag("attack")
               inst.sg:AddStateTag("idle")
          end,

          events=
          {
               EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
               EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
               EventHandler("animqueueover", function(inst)
                    if inst.AnimState:AnimDone() then
                         inst.sg:GoToState("idle")
                    end
               end),
          },

          onexit = function(inst)
               inst.components.combat:SetTarget(nil)
               if inst.sg:HasStateTag("abouttoattack") then
                    inst.components.combat:CancelAttack()
               end
               if inst.components.rider:IsRiding() then
                    inst.Transform:SetSixFaced()
               end
          end,
     }
)

AddStategraphPostInit("wilson", function(inst)
	local actionHandler_attack = inst.actionhandlers[ACTIONS.ATTACK].deststate
	inst.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action, ...)
		if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.components.health:IsDead()) then
               local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
               local hand = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if hand == nil and weapon and weapon.prefab == "gogglesshoothat" then
                    return "goggleattack"
               end
		end
		return actionHandler_attack(inst, action, ...)
	end
end)