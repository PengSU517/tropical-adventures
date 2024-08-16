local AddStategraphState = AddStategraphState
local AddStategraphEvent = AddStategraphEvent
local AddStategraphPostInit = AddStategraphPostInit
local AddStategraphActionHandler = AddStategraphActionHandler
local AddStategraphPostInit = AddStategraphPostInit
GLOBAL.setfenv(1, GLOBAL)

local TIMEOUT = 2
local DoFoleySounds = nil

local actionhandlers = {

}

local eventhandlers = {

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
    AddStategraphActionHandler("wilson_client", actionhandler)
end

for _, eventhandler in ipairs(eventhandlers) do
    AddStategraphEvent("wilson_client", eventhandler)
end

for _, state in ipairs(states) do
    AddStategraphState("wilson_client", state)
end
