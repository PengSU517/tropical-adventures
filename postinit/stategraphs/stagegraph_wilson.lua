local AddStategraphActionHandler = AddStategraphActionHandler
local ActionHandler = ActionHandler


local AddStategraphState = AddStategraphState
local EventHandler = EventHandler
local State = State
local ACTIONS = ACTIONS







-- players stategraph
local player_overrides = {
    wathgrithr = "wathgrithr_sail",
    waxwell = "waxwell_sail",
    wendy = "wendy_sail",
    wickerbottom = "wickerbottom_sail",
    willow = "willow_sail",
    wilson = "wilson_sail",
    wes = "wes_sail",
    webber = "webber_sail",
    winona = "winona_sail",
    wolfgang = "wolfgang_sail",
    woodie = "woodie_sail",
    wx78 = "wx78_sail",
}

local state_jumponboatstart_pre =
    State {
        name = "jumponboatstart_pre",
        tags = { "doing", "busy", "nointerrupt" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
            local heavy = inst.replica.inventory:IsHeavyLifting()
            inst.AnimState:PlayAnimation(heavy and "heavy_jump_pre" or "jump_pre")
            inst.sg:SetTimeout(FRAMES * 18)
        end,
        events = {
            EventHandler(
                "animover",
                function(inst)
                    if TheWorld.ismastersim then
                        inst:PerformBufferedAction()
                    end
                    if not TheWorld.ismastersim then
                        inst:PerformPreviewBufferedAction()
                    end
                end
            )
        },
        onupdate = function(inst)
            if not TheWorld.ismastersim then
                if inst:HasTag("doing") then
                    if inst.entity:FlattenMovementPrediction() then
                        inst.sg:GoToState("idle", "noanim")
                    end
                elseif inst.bufferedaction == nil then
                    inst.sg:GoToState("idle", true)
                end
            end
        end,
        ontimeout = function(inst)
            if not TheWorld.ismastersim then -- client
                inst:ClearBufferedAction()
            end
            inst.sg:GoToState("idle")
        end,
        onexit = function(inst)
            if inst.bufferedaction == inst.sg.statemem.action then
                inst:ClearBufferedAction()
            end
            inst.sg.statemem.action = nil
        end
    }
AddStategraphState("wilson", state_jumponboatstart_pre)

local state_jumponboatstart_preclient =
    State {
        name = "jumponboatstart_pre",
        tags = { "doing", "busy", "nointerrupt" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
            local heavy = inst.replica.inventory:IsHeavyLifting()
            inst.AnimState:PlayAnimation(heavy and "heavy_jump_pre" or "jump_pre")
            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(TIMEOUT)
        end,

        onupdate = function(inst)
            if inst:HasTag("doing") then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
    }


AddStategraphState("wilson_client", state_jumponboatstart_preclient)


AddStategraphActionHandler(
    "wilson",
    ActionHandler(
        ACTIONS.LIGHT,
        function(inst)
            local equipped = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equipped and equipped:HasTag("magnifying_glass") then
                return "investigate_start"
            else
                return "give"
            end
        end
    )
)

AddStategraphActionHandler(
    "wilson_client",
    ActionHandler(
        ACTIONS.LIGHT,
        function(inst)
            local equipped = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equipped and equipped:HasTag("magnifying_glass") then
                return "investigate_start"
            else
                return "give"
            end
        end
    )
)

AddStategraphActionHandler(
    "wilson",
    ActionHandler(
        ACTIONS.PLAY,
        function(inst, action)
            if action.invobject ~= nil then
                return (action.invobject:HasTag("flute") and "play_flute")
                    or (action.invobject:HasTag("horn") and "play_horn")
                    or (action.invobject:HasTag("horn2") and "play_horn2")
                    or (action.invobject:HasTag("horn3") and "play_horn3")
                    or (action.invobject:HasTag("bell") and "play_bell")
                    or (action.invobject:HasTag("whistle") and "play_whistle")
                    or (action.invobject:HasTag("flutesw") and "play_flutesw")
                    or (action.invobject:HasTag("goddess_bell") and "play_goddess_bell")
                    or (action.invobject:HasTag("goddess_flute") and "play_goddess_flute")
                    or nil
            end
        end
    )
)

AddStategraphActionHandler(
    "wilson_client",
    ActionHandler(
        ACTIONS.PLAY,
        function(inst, action)
            if action.invobject ~= nil then
                return (action.invobject:HasTag("flute") and "play_flute")
                    or (action.invobject:HasTag("horn") and "play_horn")
                    or (action.invobject:HasTag("horn2") and "play_horn2")
                    or (action.invobject:HasTag("horn3") and "play_horn3")
                    or (action.invobject:HasTag("bell") and "play_bell")
                    or (action.invobject:HasTag("whistle") and "play_whistle")
                    or (action.invobject:HasTag("flutesw") and "play_flutesw")
                    or nil
            end
        end
    )
)


AddStategraphState(
    "wilson",
    State {
        name = "play_horn2",
        tags = { "doing", "playing" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("horn", false)
            inst.AnimState:OverrideSymbol("horn01", "swap_wind_conch", "swap_horn")
            --inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
            inst.components.inventory:ReturnActiveActionItem(inst.bufferedaction ~= nil and inst.bufferedaction
                .invobject or nil)
        end,

        timeline =
        {
            TimeEvent(21 * FRAMES, function(inst)
                if inst:PerformBufferedAction() then
                    inst.SoundEmitter:PlaySound("dontstarve/common/horn_beefalo")
                else
                    inst.AnimState:SetTime(48 * FRAMES)
                end
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                inst.AnimState:Show("ARM_carry")
                inst.AnimState:Hide("ARM_normal")
            end
        end,
    })

AddStategraphState(
    "wilson_client",
    State {
        name = "play_horn2",
        tags = { "doing", "busy", "playing" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("horn", false)
            inst.AnimState:OverrideSymbol("horn01", "swap_wind_conch", "swap_horn")
            inst.AnimState:Show("ARM_normal")
            inst:PerformPreviewBufferedAction()
        end,

        timeline =
        {
            TimeEvent(21 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/common/horn_beefalo", "horn2")
            end),

            TimeEvent(36 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),

        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                inst.AnimState:Show("ARM_carry")
                inst.AnimState:Hide("ARM_normal")
            end
        end,
















    })

AddStategraphState(
    "wilson",
    State {
        name = "play_horn3",
        tags = { "doing", "playing" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("horn", false)
            inst.AnimState:OverrideSymbol("horn01", "swap_antler", "swap_horn")
            --inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
            inst.components.inventory:ReturnActiveActionItem(inst.bufferedaction ~= nil and inst.bufferedaction
                .invobject or nil)
        end,

        timeline =
        {
            TimeEvent(21 * FRAMES, function(inst)
                if inst:PerformBufferedAction() then
                    inst.SoundEmitter:PlaySound("dontstarve/common/horn_beefalo")
                else
                    inst.AnimState:SetTime(48 * FRAMES)
                end
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                inst.AnimState:Show("ARM_carry")
                inst.AnimState:Hide("ARM_normal")
            end
        end,
    })

AddStategraphState(
    "wilson_client",
    State {
        name = "play_horn3",
        tags = { "doing", "busy", "playing" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("horn", false)
            inst.AnimState:OverrideSymbol("horn01", "swap_antler", "swap_horn")
            inst.AnimState:Show("ARM_normal")
            inst:PerformPreviewBufferedAction()
        end,

        timeline =
        {
            TimeEvent(21 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/common/horn_beefalo", "horn2")
            end),

            TimeEvent(36 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),

        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                inst.AnimState:Show("ARM_carry")
                inst.AnimState:Hide("ARM_normal")
            end
        end,
    })

AddStategraphState(
    "wilson",
    State {
        name = "play_flutesw",
        tags = { "doing", "busy", "playing" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("flute", false)

            local inv_obj = inst.bufferedaction ~= nil and inst.bufferedaction.invobject or nil
            inst.AnimState:OverrideSymbol("pan_flute01", "ox_flute", "ox_flute01")
            inst.components.inventory:ReturnActiveActionItem(inv_obj)
        end,

        timeline =
        {
            TimeEvent(30 * FRAMES, function(inst)
                if inst:PerformBufferedAction() then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/ox_flute", "flute")
                else
                    inst.sg.statemem.action_failed = true
                    inst.AnimState:SetFrame(94)
                end
            end),
            TimeEvent(36 * FRAMES, function(inst)
                if inst.sg.statemem.action_failed then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
            TimeEvent(52 * FRAMES, function(inst)
                if not inst.sg.statemem.action_failed then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
            TimeEvent(85 * FRAMES, function(inst)
                if not inst.sg.statemem.action_failed then
                    inst.SoundEmitter:KillSound("flute")
                end
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.SoundEmitter:KillSound("flute")
            inst.AnimState:ClearOverrideSymbol("pan_flute01")
        end,
    })

AddStategraphState(
    "wilson_client",
    State {
        name = "play_flutesw",
        tags = { "doing", "busy", "playing" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("flute", false)
            inst.AnimState:OverrideSymbol("pan_flute01", "ox_flute", "ox_flute01")
        end,

        timeline =
        {
            TimeEvent(30 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/ox_flute", "flute")
            end),

            TimeEvent(52 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
            TimeEvent(85 * FRAMES, function(inst)
                inst:PerformPreviewBufferedAction()
            end),

        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.SoundEmitter:KillSound("flute")
            inst.AnimState:ClearOverrideSymbol("pan_flute01")
        end,
    })

AddStategraphActionHandler(
    "wilson",
    ActionHandler(
        ACTIONS.BLINK,
        function(inst, action)
            --		if inst:HasTag("aquatic") and inst:HasTag("soulstealer") then return false end
            local interior = GetClosestInstWithTag("interior_center", inst, 30)
            if interior then return false end
            if TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_COASTAL and
                TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_COASTAL_SHORE and
                TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_SWELL and
                TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_ROUGH and
                TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_BRINEPOOL and
                TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_BRINEPOOL_SHORE and
                TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_WATERLOG and
                TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_HAZARDOUS then
                return action.invobject == nil and inst:HasTag("soulstealer") and "portal_jumpin_pre" or "quicktele"
            end
        end
    )
)


AddStategraphActionHandler(
    "wilson_client",
    ActionHandler(
        ACTIONS.BLINK,
        function(inst, action)
            --		if inst:HasTag("aquatic") and inst:HasTag("soulstealer") then return false end
            local interior = GetClosestInstWithTag("interior_center", inst, 30)
            if interior then return false end
            if TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_COASTAL and
                TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_COASTAL_SHORE and
                TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_SWELL and
                TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_ROUGH and
                TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_BRINEPOOL and
                TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_BRINEPOOL_SHORE and
                TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_WATERLOG and
                TheWorld.Map:GetTile(TheWorld.Map:GetTileCoordsAtPoint(action:GetActionPoint():Get())) ~= GROUND.OCEAN_HAZARDOUS then
                return action.invobject == nil and inst:HasTag("soulstealer") and "portal_jumpin_pre" or "quicktele"
            end
        end
    )
)

AddStategraphState(
    "wilson",
    State {
        name = "jumponboatstart",
        tags = { "doing", "nointerupt", "busy", "canrotate", "nomorph", "nopredict" },
        onenter = function(inst, target)
            inst.Physics:ClearCollisionMask()
            inst.Physics:CollidesWith(COLLISION.GROUND)
            inst.Physics:CollidesWith(COLLISION.GIANTS)

            inst.sg.statemem.heavy = inst.replica.inventory:IsHeavyLifting()
            inst.AnimState:PlayAnimation(inst.sg.statemem.heavy and "heavy_jumpout" or "jump")

            inst.sg.statemem.action = inst.bufferedaction
            inst.sg:SetTimeout(17 * FRAMES)
        end,
        timeline = {
            TimeEvent(
                15.2 * FRAMES,
                function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
                end
            ),
            TimeEvent(
                18 * FRAMES,
                function(inst)
                    inst.Physics:Stop()
                end
            )
        },

        events = {
            EventHandler(
                "animqueueover",
                function(inst)
                    if inst.AnimState:AnimDone() then
                        ChangeToCharacterPhysics(inst)
                        inst.sg:GoToState("idle")
                    end
                end
            )
        },

        ontimeout = function(inst)
            if not TheWorld.ismastersim then -- client
                inst:ClearBufferedAction()
            end
            ChangeToCharacterPhysics(inst)
            inst.sg:GoToState("idle")
        end,

        onexit = function(inst)
            ChangeToCharacterPhysics(inst)
            if inst.components.driver and inst.components.driver.mountdata then
                inst.components.driver:OnMount(inst.components.driver.mountdata)
            end
            if inst.bufferedaction == inst.sg.statemem.action then
                inst:ClearBufferedAction()
            end
            inst.sg.statemem.action = nil
        end
    }
)

AddStategraphState(
    "wilson",
    State {
        name = "jumponboatdismount",
        tags = { "doing", "nointerupt", "busy", "canrotate", "nomorph", "nopredict" },
        onenter = function(inst)
            inst.Physics:ClearCollisionMask()
            inst.Physics:CollidesWith(COLLISION.GROUND)
            inst.Physics:CollidesWith(COLLISION.GIANTS)

            inst.sg.statemem.heavy = inst.replica.inventory:IsHeavyLifting()
            inst.AnimState:PlayAnimation(inst.sg.statemem.heavy and "heavy_jumpout" or "jump")

            inst.sg.statemem.action = inst.bufferedaction
            inst.sg:SetTimeout(17 * FRAMES)
        end,
        timeline = {
            TimeEvent(
                15.2 * FRAMES,
                function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
                end
            ),
            TimeEvent(
                18 * FRAMES,
                function(inst)
                    inst.Physics:Stop()
                end
            )
        },
        events = {
            EventHandler(
                "animqueueover",
                function(inst)
                    --          local x,y,z = inst.Transform:GetWorldPosition()
                    if inst.AnimState:AnimDone() then
                        ChangeToCharacterPhysics(inst)
                        --              inst.Transform:SetPosition(inst.posx,0,inst.posz)
                        inst.sg:GoToState("idle")
                    end

                    if inst.components.interactions then
                        inst:RemoveComponent("interactions")
                    end
                end
            )
        },
        ontimeout = function(inst)
            if not TheWorld.ismastersim then -- client
                inst:ClearBufferedAction()
            end
            ChangeToCharacterPhysics(inst)
            --      local x,y,z = inst.Transform:GetWorldPosition()
            --      inst.Transform:SetPosition(inst.posx,0,inst.posz)
            inst.sg:GoToState("idle")
        end,
        onexit = function(inst)
            inst:RemoveTag("pulando")
            ChangeToCharacterPhysics(inst)
            --      local x,y,z = inst.Transform:GetWorldPosition()
            --      inst.Transform:SetPosition(inst.posx,0,inst.posz)
            if inst.bufferedaction == inst.sg.statemem.action then
                inst:ClearBufferedAction()
            end
            inst.sg.statemem.action = nil
        end
    }
)

-- Movement prediction client fix to see bell playing animation

AddStategraphState(
    "wilson",
    State {
        name = "play_bell",
        tags = { "doing", "playing" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("bell", false)
            inst.AnimState:OverrideSymbol("bell01", "bell", "bell01")
            inst.AnimState:Show("ARM_normal")
            inst.components.inventory:ReturnActiveActionItem(
                inst.bufferedaction ~= nil and inst.bufferedaction.invobject or nil
            )
        end,
        timeline = {
            TimeEvent(
                15 * FRAMES,
                function(inst)
                    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/glommer_bell")
                end
            ),
            TimeEvent(
                60 * FRAMES,
                function(inst)
                    inst:PerformBufferedAction()
                end
            )
        },
        events = {
            EventHandler(
                "animover",
                function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("idle")
                    end
                end
            )
        },
        onexit = function(inst)
            if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                inst.AnimState:Show("ARM_carry")
                inst.AnimState:Hide("ARM_normal")
            end
        end
    }
)

local crop_dust =
    State
    {
        name = "crop_dust",
        tags = { "doing", "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("cropdust_pre")
            inst.AnimState:PushAnimation("cropdust_loop")
            inst.AnimState:PushAnimation("cropdust_loop")
            inst.AnimState:PushAnimation("cropdust_loop")
            inst.AnimState:PushAnimation("cropdust_pst")
        end,

        timeline =
        {
            TimeEvent(10 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/items/bugrepellent")
            end),

            TimeEvent(4 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),

            TimeEvent(20 * FRAMES, function(inst)
                if TheWorld.ismastersim then
                    inst:PerformBufferedAction()
                end
                if not TheWorld.ismastersim then
                    inst:PerformPreviewBufferedAction()
                end
            end),
        },

        events = {
            EventHandler(
                "animover",
                function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("idle")
                    end
                end
            )
        },
    }

AddStategraphState("wilson_client", crop_dust)
AddStategraphState("wilson", crop_dust)


local surfando =
    State { name = "surfando",
        tags = { "canrotate" },

        onenter = function(inst)
            local action = inst:GetBufferedAction()
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("surf_loop")
        end,

        timeline =
        {

            TimeEvent(2 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),



        },

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("surfando") end),
        },
    }

AddStategraphState("wilson_client", surfando)
AddStategraphState("wilson", surfando)

--player actionhandler
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.ACTIVATESAIL, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.ACTIVATESAIL, "doshortaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.COMPACTPOOP, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.COMPACTPOOP, "doshortaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.DESACTIVATESAIL, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.DESACTIVATESAIL, "doshortaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.BOATMOUNT, "jumponboatstart_pre"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.BOATMOUNT, "jumponboatstart_pre"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.BOATREPAIR, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.BOATREPAIR, "dolongaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.OPENTUNA, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.OPENTUNA, "dolongaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.BOATCANNON, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.BOATCANNON, "doshortaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.RETRIEVE, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.RETRIEVE, "dolongaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SHOP, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SHOP, "doshortaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SMELT, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SMELT, "doshortaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.GIVE2, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.GIVE2, "give"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PAINT, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PAINT, "dolongaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.DISLODGE, "tap"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.DISLODGE, "tap"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.GAS, "crop_dust"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.GAS, "crop_dust"))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SURF, "surfando"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SURF, "surfando"))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.INVESTIGATEGLASS, "investigate_start"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.INVESTIGATEGLASS, "investigate_start"))

-- AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.FERTILIZECOFFEE, "doshortaction"))
-- AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.FERTILIZECOFFEE, "doshortaction"))

AddStategraphActionHandler(
    "wilson",
    ActionHandler(
        ACTIONS.BOATDISMOUNT,
        function(inst, action)
            local xm, ym, zm = action:GetActionPoint():Get()
            local passable = TheWorld.Map:IsPassableAtPoint(xm, ym, zm)
            if inst:HasTag("player") and passable == true then
                inst.posx = xm
                inst.posz = zm
                inst:ForceFacePoint(xm, ym, zm)
                return "jumponboatstart_pre"
            end
        end
    )
)

AddStategraphActionHandler(
    "wilson_client",
    ActionHandler(
        ACTIONS.BOATDISMOUNT,
        function(inst, action)
            local xm, ym, zm = action:GetActionPoint():Get()
            local passable = TheWorld.Map:IsPassableAtPoint(xm, ym, zm)
            if inst:HasTag("player") and passable == true then
                inst.posx = xm
                inst.posz = zm
                inst:ForceFacePoint(xm, ym, zm)
                return "jumponboatstart_pre"
            end
        end
    )
)

AddStategraphActionHandler(
    "wilson",
    ActionHandler(
        ACTIONS.HACK,
        function(inst)
            if inst:HasTag("beaver") then
                return not inst.sg:HasStateTag("gnawing") and "gnaw" or nil
            end

            local equipamento = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equipamento and equipamento.prefab == "shears" then
                if not inst.sg:HasStateTag("preshear") then
                    if inst.sg:HasStateTag("shearing") then
                        return "shear"
                    else
                        return "shear_start"
                    end
                end
            end


            return not inst.sg:HasStateTag("prechop") and (inst.sg:HasStateTag("chopping") and "chop" or "chop_start") or
                nil
        end
    )
)

AddStategraphActionHandler(
    "wilson_client",
    ActionHandler(
        ACTIONS.HACK,
        function(inst)
            if inst:HasTag("beaver") then
                return not inst.sg:HasStateTag("gnawing") and "gnaw" or nil
            end

            local equipamento = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            --        if equipamento and equipamento.prefab == "shears" then

            --		if not inst.sg:HasStateTag("preshear") then
            --        if inst.sg:HasStateTag("shearing") then
            --        return "shear"
            --        else
            --        return "shear_start"
            --        end
            --        end	
            --		end

            return not inst.sg:HasStateTag("prechop") and "chop_start" or nil
        end
    )
)

AddStategraphActionHandler(
    "wilson",
    ActionHandler(
        ACTIONS.PAN,
        function(inst)
            if not inst.sg:HasStateTag("panning") then
                return "pan_start"
            end
        end)
)

AddStategraphActionHandler(
    "wilson_client",
    ActionHandler(
        ACTIONS.PAN,
        function(inst)
            if not inst.sg:HasStateTag("panning") then
                return "pan_start"
            end
        end)
)

AddStategraphActionHandler(
    "wilson",
    ActionHandler(
        ACTIONS.HACK1,
        function(inst)
            if inst:HasTag("beaver") then
                return not inst.sg:HasStateTag("gnawing") and "gnaw" or nil
            end
            return not inst.sg:HasStateTag("prechop") and (inst.sg:HasStateTag("chopping") and "chop" or "chop_start") or
                nil
        end
    )
)

AddStategraphActionHandler(
    "wilson_client",
    ActionHandler(
        ACTIONS.HACK1,
        function(inst)
            if inst:HasTag("beaver") then
                return not inst.sg:HasStateTag("gnawing") and "gnaw" or nil
            end
            return not inst.sg:HasStateTag("prechop") and "chop_start" or nil
        end
    )
)

AddStategraphActionHandler(
    "wilson",
    ActionHandler(ACTIONS.ATTACK,
        function(inst, action)
            inst.sg.mem.localchainattack = not action.forced or nil
            local playercontroller = inst.components.playercontroller
            local attack_tag =
                playercontroller ~= nil and
                playercontroller.remote_authority and
                playercontroller.remote_predicting and
                "abouttoattack" or
                "attack"
            if not (inst.sg:HasStateTag(attack_tag) and action.target == inst.sg.statemem.attacktarget or inst.components.health:IsDead()) then
                local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
                --umcompromissing mode compatibility--	
                if weapon and weapon:HasTag("beegun") then
                    if inst.sg.laststate.name == "beegun" or inst.sg.laststate.name == "beegun_short" then
                        return
                        "beegun_short"
                    else
                        return "beegun"
                    end
                end
                if weapon and not ((weapon:HasTag("blowdart") or weapon:HasTag("thrown"))) and inst:HasTag("wathom") and not inst.sg:HasStateTag("attack") and (inst.components.rider ~= nil and not inst.components.rider:IsRiding()) then return ("wathomleap") end

                return (weapon == nil and "attack")
                    or (weapon:HasTag("blowdart") and "blowdart")
                    or (weapon:HasTag("slingshot") and "slingshot_shoot")
                    or (weapon:HasTag("thrown") and "throw")
                    or (weapon:HasTag("pillow") and "attack_pillow_pre")
                    or (weapon:HasTag("propweapon") and "attack_prop_pre")
                    or (weapon:HasTag("multithruster") and "multithrust_pre")
                    or (weapon:HasTag("helmsplitter") and "helmsplitter_pre")
                    or (weapon:HasTag("speargun") and "speargun")
                    or (weapon:HasTag("blunderbuss") and "speargun")
                    or "attack"
            end
        end
    )
)



AddStategraphActionHandler(
    "wilson_client",
    ActionHandler(ACTIONS.ATTACK,
        function(inst, action)
            if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.replica.health:IsDead()) then
                local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if equip == nil then
                    return "attack"
                end
                local inventoryitem = equip.replica.inventoryitem

                --umcompromissing mode compatibility--	
                if equip and equip:HasTag("beegun") then
                    if inst.sg.laststate.name == "beegun" or inst.sg.laststate.name == "beegun_short" then
                        return
                        "beegun_short"
                    else
                        return "beegun"
                    end
                end
                if equip and not ((equip:HasTag("blowdart") or equip:HasTag("thrown"))) and inst:HasTag("wathom") and not inst.sg:HasStateTag("attack") and (inst.components.rider ~= nil and not inst.components.rider:IsRiding()) then return ("wathomleap") end


                return (not (inventoryitem ~= nil and inventoryitem:IsWeapon()) and "attack")
                    or (equip:HasTag("blowdart") and "blowdart")
                    or (equip:HasTag("slingshot") and "slingshot_shoot")
                    or (equip:HasTag("thrown") and "throw")
                    or (equip:HasTag("pillow") and "attack_pillow_pre")
                    or (equip:HasTag("propweapon") and "attack_prop_pre")
                    or (equip:HasTag("speargun") and "speargun")
                    or (equip:HasTag("blunderbuss") and "speargun")
                    or "attack"
            end
        end
    )
)



local pan_start =
    State { name = "pan_start",
        tags = { "prepan", "panning", "working" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("pan_pre")
        end,

        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst) inst.sg:GoToState("pan") end),
        },
    }


local pan =
    State {
        name = "pan",
        tags = { "prepan", "panning", "working" },
        onenter = function(inst)
            inst.sg.statemem.action = inst:GetBufferedAction()
            inst.AnimState:PlayAnimation("pan_loop", true)
            inst.sg:SetTimeout(1 + math.random())
        end,

        timeline =
        {
            TimeEvent(6 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound(
                    "dontstarve_DLC003/common/harvested/pool/pan")
            end),
            TimeEvent(14 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound(
                    "dontstarve_DLC003/common/harvested/pool/pan")
            end),

            TimeEvent((6 + 15) * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound(
                    "dontstarve_DLC003/common/harvested/pool/pan")
            end),
            TimeEvent((14 + 15) * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound(
                    "dontstarve_DLC003/common/harvested/pool/pan")
            end),

            TimeEvent((6 + 30) * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound(
                    "dontstarve_DLC003/common/harvested/pool/pan")
            end),
            TimeEvent((14 + 30) * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound(
                    "dontstarve_DLC003/common/harvested/pool/pan")
            end),

            TimeEvent((6 + 45) * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound(
                    "dontstarve_DLC003/common/harvested/pool/pan")
            end),
            TimeEvent((14 + 45) * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound(
                    "dontstarve_DLC003/common/harvested/pool/pan")
            end),

            TimeEvent((6 + 60) * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound(
                    "dontstarve_DLC003/common/harvested/pool/pan")
            end),
            TimeEvent((14 + 60) * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound(
                    "dontstarve_DLC003/common/harvested/pool/pan")
            end),
        },


        ontimeout = function(inst)
            inst:PerformBufferedAction()
            inst.sg:GoToState("idle", "pan_pst")
        end,

        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle", "pan_pst") end),
            --EventHandler("animover", function(inst)
            --    inst.sg:GoToState("idle","pan_pst")
            --end ),
        },
    }

AddStategraphState("wilson_client", pan_start)
AddStategraphState("wilson", pan_start)
AddStategraphState("wilson_client", pan)
AddStategraphState("wilson", pan)


local investigate_start =
    State { name = "investigate_start",
        tags = { "preinvestigate", "investigating", "working" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.sg:GoToState("investigate")
            --inst.AnimState:PlayAnimation("chop_pre")
        end,

        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst) inst.sg:GoToState("investigate") end),
        },
    }

local investigate =
    State { name = "investigate",
        tags = { "preinvestigate", "investigating", "working" },
        onenter = function(inst)
            inst.sg.statemem.action = inst:GetBufferedAction()
            inst.AnimState:PlayAnimation("lens")
        end,

        timeline =
        {
            TimeEvent(9 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("preinvestigate")
            end),


            TimeEvent(16 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("investigating")
            end),

            TimeEvent(45 * FRAMES, function(inst)
                -- this covers both mystery and lighting now
                inst:PerformBufferedAction()
            end),
        },

        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst)
                inst.sg:GoToState("investigate_post")
            end),
        },
    }

local investigate_post =
    State { name = "investigate_post",
        tags = { "investigating", "working" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("lens_pst")
        end,

        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    }

AddStategraphState("wilson_client", investigate_start)
AddStategraphState("wilson", investigate_start)
AddStategraphState("wilson_client", investigate)
AddStategraphState("wilson", investigate)
AddStategraphState("wilson_client", investigate_post)
AddStategraphState("wilson", investigate_post)


local shearstart =
    State { name = "shear_start",
        tags = { "preshear", "shearing", "working" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("cut_pre")
        end,

        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst) inst.sg:GoToState("shear") end),
        },
    }

local shearshear =
    State {
        name = "shear",
        tags = { "preshear", "shearing", "working" },
        onenter = function(inst)
            inst.sg.statemem.action = inst:GetBufferedAction()
            inst.AnimState:PlayAnimation("cut_loop")
        end,

        timeline =
        {
            TimeEvent(4 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/grass_tall/shears")
                inst:PerformBufferedAction()
            end),


            TimeEvent(9 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("preshear")
            end),

            TimeEvent(14 * FRAMES, function(inst)
                if
                    inst.components.playercontroller ~= nil and
                    inst.components.playercontroller:IsAnyOfControlsPressed(
                        CONTROL_PRIMARY,
                        CONTROL_ACTION,
                        CONTROL_CONTROLLER_ACTION) and
                    inst.sg.statemem.action and
                    inst.sg.statemem.action:IsValid() and
                    inst.sg.statemem.action.target and
                    inst.sg.statemem.action.target:IsActionValid(inst.sg.statemem.action.action) and
                    inst.sg.statemem.action.target.components.shearable then
                    inst:ClearBufferedAction()
                    inst:PushBufferedAction(inst.sg.statemem.action)
                end
            end),

            TimeEvent(16 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("shearing")
            end),
        },

        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst)
                --inst.AnimState:PlayAnimation("chop_pst")
                inst.sg:GoToState("shear_end")
            end),
        },
    }

local shearend =
    State { name = "shear_end",
        tags = { "working" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("cut_pst")
        end,

        events =
        {
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

    }

AddStategraphState("wilson_client", shearstart)
AddStategraphState("wilson", shearstart)
AddStategraphState("wilson_client", shearshear)
AddStategraphState("wilson", shearshear)
AddStategraphState("wilson_client", shearend)
AddStategraphState("wilson", shearend)

--

AddStategraphEvent("wilson",
    EventHandler("sanity_stun",
        function(inst, data)
            --            if not inst.components.inventory:IsItemNameEquipped("earmuffshat") then
            inst.sanity_stunned = true
            inst.sg:GoToState("sanity_stun")
            inst.components.sanity:DoDelta(-TUNING.SANITY_LARGE)

            inst:DoTaskInTime(data.duration, function()
                if inst.sg.currentstate.name == "sanity_stun" then
                    inst.sg:GoToState("idle")
                    inst.sanity_stunned = false
                    inst:PushEvent("sanity_stun_over")
                end
            end)
            --          end
        end))

AddStategraphEvent("wilson_client",
    EventHandler("sanity_stun",
        function(inst, data)
            --            if not inst.components.inventory:IsItemNameEquipped("earmuffshat") then
            inst.sanity_stunned = true
            inst.sg:GoToState("sanity_stun")
            inst.components.sanity:DoDelta(-TUNING.SANITY_LARGE)

            inst:DoTaskInTime(data.duration, function()
                if inst.sg.currentstate.name == "sanity_stun" then
                    inst.sg:GoToState("idle")
                    inst.sanity_stunned = false
                    inst:PushEvent("sanity_stun_over")
                end
            end)
            --          end
        end))

AddStategraphState(
    "wilson",
    State {
        name = "sanity_stun",
        tags = { "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("idle_sanity_pre", false)
            inst.AnimState:PushAnimation("idle_sanity_loop", true)
        end,

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    })

AddStategraphState(
    "wilson_client",
    State {
        name = "sanity_stun",
        tags = { "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("idle_sanity_pre", false)
            inst.AnimState:PushAnimation("idle_sanity_loop", true)
        end,

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    })
--death boat--
AddStategraphState(
    "wilson",
    State {
        name = "death_boat",
        tags = { "busy", "nopredict", "nomorph", "drowning", "nointerrupt" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
            --   inst.AnimState:Hide("swap_arm_carry")
            --   inst.AnimState:PlayAnimation("sink")
            inst.AnimState:SetSortOrder(0)
            if inst.components.inventory ~= nil then
                inst.components.inventory:DropEverything(true)
            end



            if inst.components.driver then
                if inst.components.driver.vehicle then inst.components.driver.vehicle:Remove() end
                inst.AnimState:SetSortOrder(0)
                inst:RemoveTag("aquatic")
                inst:RemoveTag("sail")
                inst:RemoveTag("surf")
                inst:RemoveComponent("rowboatwakespawner")
                inst:RemoveComponent("driver")
                if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO) then
                    inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO):Remove()
                end
            end
            --			
        end,
        timeline = {
            TimeEvent(2 * FRAMES, function(inst) inst.DynamicShadow:Enable(false) end),
            TimeEvent(3 * FRAMES, function(inst) inst.sg:GoToState("idle") end)
        },
        events = {
            EventHandler(
                "animover",
                function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("idle")
                    end
                end
            )
        },
        onexit = function(inst)
            inst.DynamicShadow:Enable(true)
            --			inst.components.health:SetVal(0, "drowning")
        end
    }
)

AddStategraphState(
    "wilson_client",
    State {
        name = "death_boat",
        tags = { "busy", "nopredict", "nomorph", "drowning", "nointerrupt" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
            --   inst.AnimState:Hide("swap_arm_carry")
            --   inst.AnimState:PlayAnimation("sink")
            inst.AnimState:SetSortOrder(0)
            if inst.components.inventory ~= nil then
                inst.components.inventory:DropEverything(true)
            end



            if inst.components.driver then
                if inst.components.driver.vehicle then inst.components.driver.vehicle:Remove() end
                inst.AnimState:SetSortOrder(0)
                inst:RemoveTag("aquatic")
                inst:RemoveTag("sail")
                inst:RemoveTag("surf")
                inst:RemoveComponent("rowboatwakespawner")
                inst:RemoveComponent("driver")
                if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO) then
                    inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO):Remove()
                end
            end
            --			
        end,
        timeline = {
            TimeEvent(2 * FRAMES, function(inst) inst.DynamicShadow:Enable(false) end),
            TimeEvent(3 * FRAMES, function(inst) inst.sg:GoToState("idle") end)

        },
        events = {
            EventHandler(
                "animover",
                function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("idle")
                    end
                end
            )
        },
        onexit = function(inst)
            inst.DynamicShadow:Enable(true)
            --			inst.components.health:SetVal(0, "drowning")
        end
    }
)

---

local tapserver =
    State {
        name = "tap",
        tags = { "doing", "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make_preview")
            inst.AnimState:PlayAnimation("tamp_pre")
            inst.AnimState:PushAnimation("tamp_loop", true)

            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(TIMEOUT)
        end,

        timeline =
        {
            TimeEvent(4 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },

        onupdate = function(inst)
            if inst:HasTag("doing") then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.AnimState:PlayAnimation("tamp_pst")
                inst.sg:GoToState("idle", true)
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("tamp_pst")
            inst.sg:GoToState("idle", true)
        end,

        onexit = function(inst)
            inst.SoundEmitter:KillSound("make_preview")
        end,
    }


local tapstart =
    State {
        name = "tap",
        tags = { "doing", "busy" },

        timeline =
        {
            TimeEvent(4 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },

        onenter = function(inst, timeout)
            inst.sg:SetTimeout(timeout or 1)
            inst.components.locomotor:Stop()

            inst.AnimState:PlayAnimation("tamp_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("tap_loop") end),
        },
    }

local taploop =
    State {
        name = "tap_loop",
        tags = { "doing" },

        onenter = function(inst, timeout)
            local targ = inst:GetBufferedAction() and inst:GetBufferedAction().target or nil
            inst.sg:SetTimeout(timeout or 1)
            inst.components.locomotor:Stop()
            inst.AnimState:PushAnimation("tamp_loop", true)
        end,

        timeline =
        {
            TimeEvent(1 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/tamping_tool")
            end),
            TimeEvent(8 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/tamping_tool")
            end),
            TimeEvent(16 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/tamping_tool")
            end),
            TimeEvent(24 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/tamping_tool")
            end),
            TimeEvent(32 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/tamping_tool")
            end),
        },

        ontimeout = function(inst)
            inst:PerformBufferedAction()
            inst.AnimState:PlayAnimation("tamp_pst")
            inst.sg:GoToState("idle", false)
        end,
    }
AddStategraphState("wilson_client", tapserver)
AddStategraphState("wilson", tapstart)
AddStategraphState("wilson", taploop)

--
local function ConfigureRunState(inst)
    if inst.components.rider:IsRiding() then
        inst.sg.statemem.riding = true
        inst.sg.statemem.groggy = inst:HasTag("groggy")
        inst.sg.statemem.hamfog = inst:HasTag("hamfogspeed")
        inst.sg:AddStateTag("nodangle")
        inst.sg:AddStateTag("noslip")

        local mount = inst.components.rider:GetMount()
        inst.sg.statemem.ridingwoby = mount and mount:HasTag("woby")
    elseif inst.components.inventory:IsHeavyLifting() then
        inst.sg.statemem.heavy = true
        inst.sg.statemem.heavy_fast = inst.components.mightiness ~= nil and inst.components.mightiness:IsMighty()
        inst.sg:AddStateTag("noslip")
    elseif inst:IsChannelCasting() then
        inst.sg.statemem.channelcast = true
        inst.sg.statemem.channelcastitem = inst:IsChannelCastingItem()
    elseif inst:HasTag("wereplayer") then
        inst.sg.statemem.iswere = true
        inst.sg:AddStateTag("noslip")

        if inst:HasTag("weremoose") then
            if inst:HasTag("groggy") or inst:HasTag("hamfogspeed") then
                inst.sg.statemem.moosegroggy = true
            else
                inst.sg.statemem.moose = true
            end
        elseif inst:HasTag("weregoose") then
            if inst:HasTag("groggy") or inst:HasTag("hamfogspeed") then
                inst.sg.statemem.goosegroggy = true
            else
                inst.sg.statemem.goose = true
            end
        elseif inst:HasTag("groggy") then
            inst.sg.statemem.groggy = true
        elseif inst:HasTag("hamfogspeed") then
            inst.sg.statemem.hamfog = true
        else
            inst.sg.statemem.normal = true
        end
    elseif inst:IsInAnyStormOrCloud() and not inst.components.playervision:HasGoggleVision() then
        inst.sg.statemem.sandstorm = true
    elseif inst:HasTag("groggy") then
        inst.sg.statemem.groggy = true
    elseif inst:HasTag("hamfogspeed") then
        inst.sg.statemem.hamfog = true
    elseif inst:IsCarefulWalking() then
        inst.sg.statemem.careful = true
        inst.sg:AddStateTag("noslip")
    else
        inst.sg.statemem.normal = true
        inst.sg.statemem.normalwonkey = inst:HasTag("wonkey") and not inst:HasTag("wilbur") or nil
    end
end

local function GetRunStateAnim(inst)
    return ((inst.sg.statemem.heavy and inst.sg.statemem.heavy_fast) and "heavy_walk_fast")
        or (inst.sg.statemem.heavy and "heavy_walk")
        or (inst.sg.statemem.channelcastitem and "channelcast_walk")
        or (inst.sg.statemem.channelcast and "channelcast_oh_walk")
        or (inst.sg.statemem.sandstorm and "sand_walk")
        or
        ((inst.sg.statemem.groggy or inst.sg.statemem.hamfog or inst.sg.statemem.moosegroggy or inst.sg.statemem.goosegroggy) and "idle_walk")
        or (inst.sg.statemem.careful and "careful_walk")
        or (inst.sg.statemem.ridingwoby and "run_woby")
        or "run"
end

local function DoEquipmentFoleySounds(inst)
    for k, v in pairs(inst.components.inventory.equipslots) do
        if v.foleysound ~= nil then
            inst.SoundEmitter:PlaySound(v.foleysound, nil, nil, true)
        end
    end
end

local function DoFoleySounds(inst)
    DoEquipmentFoleySounds(inst)
    if inst.foleysound ~= nil then
        if not inst:HasTag("aquatic") then
            inst.SoundEmitter:PlaySound(inst.foleysound, nil, nil, true)
        end
        if inst:HasTag("aquatic") then
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/boat_paddle")
        end
    end
end

local function DoMountedFoleySounds(inst)
    DoEquipmentFoleySounds(inst)
    local saddle = inst.components.rider:GetSaddle()
    if saddle ~= nil and saddle.mounted_foleysound ~= nil then
        inst.SoundEmitter:PlaySound(saddle.mounted_foleysound, nil, nil, true)
    end
end

local DoRunSounds = function(inst)
    if inst:HasTag("aquatic") then
        inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/boat_paddle")
    end
    if inst.sg.mem.footsteps > 3 and not inst:HasTag("aquatic") then
        PlayFootstep(inst, .6, true)
    else
        inst.sg.mem.footsteps = inst.sg.mem.footsteps + 1
        if not inst:HasTag("aquatic") then
            PlayFootstep(inst, 1, true)
        end
        if inst:HasTag("aquatic") then
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/boat_paddle")
        end
    end
end

local function PlayMooseFootstep(inst, volume, ispredicted)
    --moose footstep always full volume
    inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/moose/footstep", nil, nil, ispredicted)
    PlayFootstep(inst, volume, ispredicted)
end

local function DoMooseRunSounds(inst)
    --moose footstep always full volume
    inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/moose/footstep", nil, nil, true)
    DoRunSounds(inst)
end

local function DoGooseStepFX(inst)
    if inst.components.drownable ~= nil and inst.components.drownable:IsOverWater() then
        SpawnPrefab("weregoose_splash_med" .. tostring(math.random(2))).entity:SetParent(inst.entity)
    end
end

local function DoGooseWalkFX(inst)
    if inst.components.drownable ~= nil and inst.components.drownable:IsOverWater() then
        SpawnPrefab("weregoose_splash_less" .. tostring(math.random(2))).entity:SetParent(inst.entity)
    end
end

local function DoGooseRunFX(inst)
    if inst.components.drownable ~= nil and inst.components.drownable:IsOverWater() then
        SpawnPrefab("weregoose_splash").entity:SetParent(inst.entity)
    else
        SpawnPrefab("weregoose_feathers" .. tostring(math.random(3))).entity:SetParent(inst.entity)
    end
end

local boatrunstart =
    State {
        name = "run_start",
        tags = { "moving", "running", "canrotate", "autopredict", "sailing" },
        onenter = function(inst)
            ConfigureRunState(inst)
            inst.components.locomotor:RunForward()
            if inst:HasTag("aquatic") then
                if inst.replica.inventory:IsHeavyLifting() then
                    inst.AnimState:PlayAnimation("heavy_idle")
                elseif inst:HasTag("surf") then
                    inst.AnimState:PlayAnimation("surf_pre")
                elseif inst:HasTag("sail") then
                    inst.AnimState:PlayAnimation("sail_pre")
                else
                    inst.AnimState:PlayAnimation("row_pre")
                end
            else
                if inst.sg.statemem.normalwonkey and inst.components.locomotor:GetTimeMoving() >= TUNING.WONKEY_TIME_TO_RUN then
                    inst.sg:GoToState("run_monkey") --resuming after brief stop from changing directions, or resuming prediction after running into obstacle
                    return
                end
                inst.AnimState:PlayAnimation(GetRunStateAnim(inst) .. "_pre")
            end
            --goose footsteps should always be light			
            inst.sg.mem.footsteps = (inst.sg.statemem.goose or inst.sg.statemem.goosegroggy) and 4 or 0
            if inst:HasTag("aquatic") then
                inst.AnimState:AddOverrideBuild("player_actions_paddle")
                --           if player_overrides[inst.prefab] then inst.AnimState:AddOverrideBuild(player_overrides[inst.prefab]) end
            end
        end,
        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,
        timeline = {
            --mounted
            TimeEvent(
                0,
                function(inst)
                    if inst.sg.statemem.riding then
                        DoMountedFoleySounds(inst)
                    end
                end
            ),
            --heavy lifting
            TimeEvent(
                1 * FRAMES,
                function(inst)
                    if inst.sg.statemem.heavy then
                        PlayFootstep(inst, nil, true)
                        DoFoleySounds(inst)
                    end
                end
            ),

            --moose
            TimeEvent(2 * FRAMES, function(inst)
                if inst.sg.statemem.moose then
                    PlayMooseFootstep(inst, nil, true)
                    DoFoleySounds(inst)
                end
            end),

            --unmounted
            TimeEvent(
                4 * FRAMES,
                function(inst)
                    if inst.sg.statemem.normal then
                        PlayFootstep(inst, nil, true)
                        DoFoleySounds(inst)
                    end
                end
            ),
            --mounted
            TimeEvent(
                5 * FRAMES,
                function(inst)
                    if inst.sg.statemem.riding then
                        PlayFootstep(inst, nil, true)
                    end
                end
            ),

            --moose groggy
            TimeEvent(7 * FRAMES, function(inst)
                if inst.sg.statemem.moosegroggy then
                    PlayMooseFootstep(inst, nil, true)
                    DoFoleySounds(inst)
                end
            end),


        },
        events = {
            EventHandler(
                "animover",
                function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("run")
                    end
                end
            )
        }
    }
AddStategraphState("wilson", boatrunstart)

local boatrun =
    State {
        name = "run",
        tags = { "moving", "running", "canrotate", "sailing" },
        onenter = function(inst)
            ConfigureRunState(inst)
            inst.components.locomotor:RunForward()

            if inst:HasTag("aquatic") and inst.components.rowboatwakespawner then
                inst.components.rowboatwakespawner:StartSpawning()

                local barco = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
                if barco and barco.replica.container and barco.replica.container:GetItemInSlot(1) and barco.replica.container:GetItemInSlot(1).prefab == "ironwind" then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/boatpropellor_lp", "sailmove")
                end
                if barco and barco.replica.container and barco.replica.container:GetItemInSlot(1) and barco.replica.container:GetItemInSlot(1).prefab == "sail" then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sail_LP_cloth", "sailmove")
                end
                if barco and barco.replica.container and barco.replica.container:GetItemInSlot(1) and barco.replica.container:GetItemInSlot(1).prefab == "clothsail" then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sail_LP_cloth", "sailmove")
                end
                if barco and barco.replica.container and barco.replica.container:GetItemInSlot(1) and barco.replica.container:GetItemInSlot(1).prefab == "snakeskinsail" then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sail_LP_snakeskin", "sailmove")
                end
                if barco and barco.replica.container and barco.replica.container:GetItemInSlot(1) and barco.replica.container:GetItemInSlot(1).prefab == "feathersail" then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sail_LP_feather", "sailmove")
                end
                if barco and barco.replica.container and barco.replica.container:GetItemInSlot(1) and barco.replica.container:GetItemInSlot(1).prefab == "woodlegssail" then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sail_LP_sealegs", "sailmove")
                end
                if barco and barco.replica.container and barco.replica.container:GetItemInSlot(1) and barco.replica.container:GetItemInSlot(1).prefab == "malbatrossail" then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sail_LP_sealegs", "sailmove")
                end
            end

            local anim = GetRunStateAnim(inst)

            if inst:HasTag("aquatic") then
                if inst.replica.inventory:IsHeavyLifting() then
                    anim = "heavy_idle"
                elseif inst:HasTag("surf") then
                    anim = "surf_loop"
                elseif inst:HasTag("sail") then
                    anim = "sail_loop"
                elseif inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).prefab == "oar_driftwood" then
                    anim = "row_medium"
                elseif inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).prefab == "oar" then
                    anim = "row_medium"
                else
                    anim = "row_loop"
                end
            elseif anim == "run" then
                if inst:HasTag("wilbur") and inst.timeinmotion and inst.timeinmotion > 75 and not inst.replica.rider:IsRiding() and not inst.replica.inventory:IsHeavyLifting() and not inst:IsCarefulWalking() and not inst.sg:HasStateTag("jumping") then
                    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED + 2.5
                    if inst.components.hunger then inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * 1.33) end
                    inst.Transform:SetSixFaced()
                    inst.AnimState:SetBank("wilbur_run")
                    inst.AnimState:SetBuild("wilbur_run")
                    if inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                        inst.AnimState:Show("TAIL_carry")
                        inst.AnimState:Hide("TAIL_normal")
                    end
                end

                anim = "run_loop"
            elseif anim == "run_woby" then
                anim = "run_woby_loop"
            end


            if not inst.AnimState:IsCurrentAnimation(anim) then
                inst.AnimState:PlayAnimation(anim, true)
            end

            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
        end,
        onupdate = function(inst)
            if inst.sg.statemem.normalwonkey and inst.components.locomotor:GetTimeMoving() >= TUNING.WONKEY_TIME_TO_RUN then
                inst.sg:GoToState("run_monkey_start")
                return
            end
            inst.components.locomotor:RunForward()
        end,

        timeline = {
            --unmounted
            TimeEvent(
                7 * FRAMES,
                function(inst)
                    if inst.sg.statemem.normal then
                        DoRunSounds(inst)
                        DoFoleySounds(inst)
                    end
                end
            ),
            TimeEvent(
                15 * FRAMES,
                function(inst)
                    if inst.sg.statemem.normal then
                        DoRunSounds(inst)
                        DoFoleySounds(inst)
                    end
                end
            ),
            --careful
            --Frame 11 shared with heavy lifting below
            --[[TimeEvent(11 * FRAMES, function(inst)
                if inst.sg.statemem.careful then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),]]
            TimeEvent(
                26 * FRAMES,
                function(inst)
                    if inst.sg.statemem.careful then
                        DoRunSounds(inst)
                        DoFoleySounds(inst)
                    end
                end
            ),
            --sandstorm
            --Frame 12 shared with groggy below
            --[[TimeEvent(12 * FRAMES, function(inst)
                if inst.sg.statemem.sandstorm then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),]]
            TimeEvent(
                23 * FRAMES,
                function(inst)
                    if inst.sg.statemem.sandstorm then
                        DoRunSounds(inst)
                        DoFoleySounds(inst)
                    end
                end
            ),
            --groggy	
            TimeEvent(1 * FRAMES, function(inst)
                if inst.sg.statemem.groggy or inst.sg.statemem.hamfog then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                elseif inst.sg.statemem.goose then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                    DoGooseRunFX(inst)
                end
            end),
            TimeEvent(12 * FRAMES, function(inst)
                if inst.sg.statemem.groggy or inst.sg.statemem.hamfog or
                    inst.sg.statemem.sandstorm then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            --heavy lifting
            TimeEvent(11 * FRAMES, function(inst)
                if inst.sg.statemem.heavy then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                    if inst.sg.mem.footsteps > 3 then
                        --normally stops at > 3, but heavy needs to keep count
                        inst.sg.mem.footsteps = inst.sg.mem.footsteps + 1
                    end
                elseif inst.sg.statemem.moose then
                    DoMooseRunSounds(inst)
                    DoFoleySounds(inst)
                elseif inst.sg.statemem.sandstorm
                    or inst.sg.statemem.careful then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),
            TimeEvent(36 * FRAMES, function(inst)
                if inst.sg.statemem.heavy then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                    if inst.sg.mem.footsteps > 12 then
                        inst.sg.mem.footsteps = math.random(4, 6)
                        inst:PushEvent("encumberedwalking")
                    elseif inst.sg.mem.footsteps > 3 then
                        --normally stops at > 3, but heavy needs to keep count
                        inst.sg.mem.footsteps = inst.sg.mem.footsteps + 1
                    end
                end
            end),
            --mounted
            TimeEvent(0 * FRAMES, function(inst)
                if inst.sg.statemem.riding then
                    DoMountedFoleySounds(inst)
                end
            end),
            TimeEvent(5 * FRAMES, function(inst)
                if inst.sg.statemem.riding then
                    DoRunSounds(inst)
                end
            end),

            --moose
            --Frame 11 shared with heavy lifting above
            --[[TimeEvent(11 * FRAMES, function(inst)
                if inst.sg.statemem.moose then
                    DoMooseRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),]]
            TimeEvent(24 * FRAMES, function(inst)
                if inst.sg.statemem.moose then
                    DoMooseRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            --moose groggy
            TimeEvent(14 * FRAMES, function(inst)
                if inst.sg.statemem.moosegroggy then
                    DoMooseRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),
            TimeEvent(30 * FRAMES, function(inst)
                if inst.sg.statemem.moosegroggy then
                    DoMooseRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            --goose
            --Frame 1 shared with groggy above
            --[[TimeEvent(1 * FRAMES, function(inst)
                if inst.sg.statemem.goose then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                    DoGooseRunFX(inst)
                end
            end),]]
            TimeEvent(9 * FRAMES, function(inst)
                if inst.sg.statemem.goose then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                    DoGooseRunFX(inst)
                end
            end),

            --goose groggy
            TimeEvent(4 * FRAMES, function(inst)
                if inst.sg.statemem.goosegroggy then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                    DoGooseWalkFX(inst)
                end
            end),
            TimeEvent(17 * FRAMES, function(inst)
                if inst.sg.statemem.goosegroggy then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                    DoGooseWalkFX(inst)
                end
            end),
        },
        events = {
            EventHandler("gogglevision", function(inst, data)
                if data.enabled then
                    if inst.sg.statemem.sandstorm then
                        inst.sg:GoToState("run")
                    end
                elseif not (inst.sg.statemem.riding or
                        inst.sg.statemem.heavy or
                        inst.sg.statemem.iswere or
                        inst.sg.statemem.sandstorm or
                        inst:GetStormLevel() < TUNING.SANDSTORM_FULL_LEVEL) then
                    inst.sg:GoToState("run")
                end
            end),
            EventHandler("sandstormlevel", function(inst, data)
                if data.level < TUNING.SANDSTORM_FULL_LEVEL then
                    if inst.sg.statemem.sandstorm then
                        inst.sg:GoToState("run")
                    end
                elseif not (inst.sg.statemem.riding or
                        inst.sg.statemem.heavy or
                        inst.sg.statemem.iswere or
                        inst.sg.statemem.sandstorm or
                        inst.components.playervision:HasGoggleVision()) then
                    inst.sg:GoToState("run")
                end
            end),
            EventHandler("carefulwalking", function(inst, data)
                if not data.careful then
                    if inst.sg.statemem.careful then
                        inst.sg:GoToState("run")
                    end
                elseif not (inst.sg.statemem.riding or
                        inst.sg.statemem.heavy or
                        inst.sg.statemem.sandstorm or
                        inst.sg.statemem.groggy or
                        inst.sg.statemem.hamfog or
                        inst.sg.statemem.careful or
                        inst.sg.statemem.iswere) then
                    inst.sg:GoToState("run")
                end
            end),
        },

        onexit = function(inst)
            if inst:HasTag("wilbur") and not inst.replica.rider:IsRiding() and not inst.replica.inventory:IsHeavyLifting() and not inst:IsCarefulWalking() then
                inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED - 0.5
                if inst.components.hunger then inst.components.hunger:SetRate(1 * TUNING.WILSON_HUNGER_RATE) end
                inst.AnimState:SetBank("wilson")
                inst.AnimState:SetBuild(inst.prefab)
                inst.Transform:SetFourFaced()
                inst.AnimState:Hide("TAIL_carry")
                inst.AnimState:Show("TAIL_normal")
            end
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("run")
        end

    }
AddStategraphState("wilson", boatrun)

local boatrunstop =
    State {
        name = "run_stop",
        tags = { "canrotate", "idle", "sailing" },
        onenter = function(inst)
            ConfigureRunState(inst)

            if inst:HasTag("aquatic") and inst.components.rowboatwakespawner then
                inst.components.rowboatwakespawner:StopSpawning()

                inst.SoundEmitter:KillSound("sailmove")
            end

            inst.components.locomotor:Stop()
            if inst:HasTag("aquatic") then
                if inst.replica.inventory:IsHeavyLifting() then
                    inst.AnimState:PlayAnimation("heavy_idle")
                elseif inst:HasTag("surf") then
                    inst.AnimState:PlayAnimation("surf_pst")
                elseif inst:HasTag("sail") then
                    inst.AnimState:PlayAnimation("sail_pst")
                else
                    inst.AnimState:PlayAnimation("row_pst")
                end
            else
                inst.AnimState:PlayAnimation(GetRunStateAnim(inst) .. "_pst")

                if inst.sg.statemem.moose or inst.sg.statemem.moosegroggy then
                    PlayMooseFootstep(inst, .6, true)
                    DoFoleySounds(inst)
                end
            end
        end,

        timeline =
        {
            TimeEvent(FRAMES, function(inst)
                if inst.sg.statemem.goose or inst.sg.statemem.goosegroggy then
                    PlayFootstep(inst, .5, true)
                    DoFoleySounds(inst)
                    if inst.sg.statemem.goosegroggy then
                        DoGooseWalkFX(inst)
                    else
                        DoGooseStepFX(inst)
                    end
                end
            end),
        },

        events = {
            EventHandler(
                "animover",
                function(inst)
                    if inst.AnimState:AnimDone() then
                        --              if inst:HasTag("aquatic") then
                        --              inst.sg:GoToState("brake")
                        --              else
                        inst.sg:GoToState("idle") --end
                    end

                    if inst:HasTag("aquatic") then
                        inst.AnimState:ClearOverrideBuild("player_actions_paddle")
                        --					if player_overrides[inst.prefab] then inst.AnimState:ClearOverrideBuild(player_overrides[inst.prefab]) end
                    end
                end
            )
        }
    }
AddStategraphState("wilson", boatrunstop)



--
AddStategraphActionHandler(
    "wilson",
    ActionHandler(ACTIONS.SLEEPIN,
        function(inst, action)
            if action.invobject ~= nil then
                if action.invobject.onuse ~= nil then
                    action.invobject:onuse(inst)
                end
                return "bedroll"
            elseif action.target:HasTag("cama") then
                local x, y, z = action.target.Transform:GetWorldPosition()
                action.doer.Transform:SetPosition(x + 0.02, y, z + 0.02)
                return "bedroll1"
            else
                return "tent"
            end
        end)
)

AddStategraphActionHandler(
    "wilson_client",
    ActionHandler(ACTIONS.SLEEPIN,
        function(inst, action)
            if action and action.target and action.target:HasTag("cama") then
                local x, y, z = action.target.Transform:GetWorldPosition()
                action.doer.Transform:SetPosition(x + 0.02, y, z + 0.02)
            end
            return action.invobject ~= nil and "bedroll" or action.target:HasTag("cama") and "bedroll1" or "tent"
        end)
)

local function SetSleeperSleepState(inst)
    if inst.components.grue ~= nil then
        inst.components.grue:AddImmunity("sleeping")
    end
    if inst.components.talker ~= nil then
        inst.components.talker:IgnoreAll("sleeping")
    end
    if inst.components.firebug ~= nil then
        inst.components.firebug:Disable()
    end
    if inst.components.playercontroller ~= nil then
        inst.components.playercontroller:EnableMapControls(false)
        inst.components.playercontroller:Enable(false)
    end
    inst:OnSleepIn()
    inst.components.inventory:Hide()
    inst:PushEvent("ms_closepopups")
    inst:ShowActions(false)
end

local function SetSleeperAwakeState(inst)
    if inst.components.grue ~= nil then
        inst.components.grue:RemoveImmunity("sleeping")
    end
    if inst.components.talker ~= nil then
        inst.components.talker:StopIgnoringAll("sleeping")
    end
    if inst.components.firebug ~= nil then
        inst.components.firebug:Enable()
    end
    if inst.components.playercontroller ~= nil then
        inst.components.playercontroller:EnableMapControls(true)
        inst.components.playercontroller:Enable(true)
    end
    inst:OnWakeUp()
    inst.components.inventory:Show()
    inst:ShowActions(true)
end

AddStategraphState(
    "wilson",
    State {
        name = "bedroll1",
        tags = { "bedroll", "busy", "nomorph" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.Transform:SetRotation(180)

            local failreason =
                (TheWorld.state.isday and
                    (TheWorld:HasTag("cave") and "ANNOUNCE_NODAYSLEEP_CAVE" or "ANNOUNCE_NODAYSLEEP")
                )
                -- you can still sleep if your hunger will bottom out, but not absolutely
                or (inst.components.hunger.current < TUNING.CALORIES_MED and "ANNOUNCE_NOHUNGERSLEEP")
                or nil

            if failreason ~= nil then
                inst:PushEvent("performaction", { action = inst.bufferedaction })
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle")
                if inst.components.talker ~= nil then
                    inst.components.talker:Say(GetString(inst, failreason))
                end
                return
            end
            inst.AnimState:PlayAnimation("bedroll_sleep_loop")

            SetSleeperSleepState(inst)
        end,

        timeline =
        {
            TimeEvent(20 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
            end),
        },

        events =
        {
            EventHandler("firedamage", function(inst)
                if inst.sg:HasStateTag("sleeping") then
                    inst.sg.statemem.iswaking = true
                    inst.sg:GoToState("wakeup")
                end
            end),
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    if TheWorld.state.isday or
                        (inst.components.health ~= nil and inst.components.health.takingfiredamage) or
                        (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
                        inst:PushEvent("performaction", { action = inst.bufferedaction })
                        inst:ClearBufferedAction()
                        inst.sg.statemem.iswaking = true
                        inst.sg:GoToState("wakeup")
                    elseif inst:GetBufferedAction() then
                        inst:PerformBufferedAction()
                        if inst.components.playercontroller ~= nil then
                            inst.components.playercontroller:Enable(true)
                        end
                        inst.sg:AddStateTag("sleeping")
                        inst.sg:AddStateTag("silentmorph")
                        inst.sg:RemoveStateTag("nomorph")
                        inst.sg:RemoveStateTag("busy")
                        inst.AnimState:PlayAnimation("bedroll_sleep_loop", true)
                    else
                        inst.sg.statemem.iswaking = true
                        inst.sg:GoToState("wakeup")
                    end
                end
            end),
        },

        onexit = function(inst)
            if inst.sleepingbag ~= nil then
                --Interrupted while we are "sleeping"
                inst.sleepingbag.components.sleepingbag:DoWakeUp(true)
                inst.sleepingbag = nil
                SetSleeperAwakeState(inst)
            elseif not inst.sg.statemem.iswaking then
                --Interrupted before we are "sleeping"
                SetSleeperAwakeState(inst)
            end
        end,
    })


AddStategraphState(
    "wilson_client",
    State
    {
        name = "bedroll1",
        tags = { "bedroll", "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.Transform:SetRotation(180)
            inst.AnimState:PlayAnimation("bedroll_sleep_loop")

            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(TIMEOUT)
        end,

        onupdate = function(inst)
            if inst:HasTag("busy") or inst:HasTag("sleeping") then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
    })
--

local function ClearStatusAilments(inst)
    if inst.components.freezable ~= nil and inst.components.freezable:IsFrozen() then
        inst.components.freezable:Unfreeze()
    end
    if inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck() then
        inst.components.pinnable:Unstick()
    end
end

local function ForceStopHeavyLifting(inst)
    if inst.components.inventory:IsHeavyLifting() then
        inst.components.inventory:DropItem(inst.components.inventory:Unequip(EQUIPSLOTS.BODY), true, true)
    end
end

local function DoMountSound(inst, mount, sound)
    if mount ~= nil and mount.sounds ~= nil then
        inst.SoundEmitter:PlaySound(mount.sounds[sound], nil, nil, true)
    end
end


AddStategraphState(
    "wilson",
    State {
        name = "death",
        tags = { "busy", "dead", "pausepredict", "nomorph" },

        onenter = function(inst)
            if inst:HasTag("aquatic") then
                if inst.components.inventory ~= nil then
                    inst.components.inventory:DropEverything(true)
                end

                if inst.components.driver then
                    if inst.components.driver.vehicle then inst.components.driver.vehicle:Remove() end
                    inst.AnimState:SetSortOrder(0)
                    inst:RemoveTag("aquatic")
                    inst:RemoveTag("sail")
                    inst:RemoveTag("surf")
                    inst:RemoveComponent("rowboatwakespawner")
                    inst:RemoveComponent("driver")
                    if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO) then
                        inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO):Remove()
                    end
                end
            end

            --            assert(inst.deathcause ~= nil, "Entered death state without cause.")

            ClearStatusAilments(inst)
            ForceStopHeavyLifting(inst)

            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
            inst:ClearBufferedAction()

            if inst.components.rider:IsRiding() then
                DoMountSound(inst, inst.components.rider:GetMount(), "yell")
                inst.AnimState:PlayAnimation("fall_off")
                inst.sg:AddStateTag("dismounting")
            else
                if not inst:HasTag("wereplayer") then
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/death")
                elseif inst:HasTag("beaver") then
                    inst.sg.statemem.beaver = true
                elseif inst:HasTag("weremoose") then
                    inst.sg.statemem.moose = true
                else --if inst:HasTag("weregoose") then
                    inst.sg.statemem.goose = true
                end

                if inst.deathsoundoverride ~= nil then
                    inst.SoundEmitter:PlaySound(inst.deathsoundoverride)
                elseif not inst:HasTag("mime") then
                    inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/") ..
                        (inst.soundsname or inst.prefab) .. "/death_voice")
                end

                if HUMAN_MEAT_ENABLED then
                    inst.components.inventory:GiveItem(SpawnPrefab("humanmeat")) -- Drop some player meat!
                end
                if inst.components.revivablecorpse ~= nil then
                    inst.AnimState:PlayAnimation("death2")
                else
                    inst.components.inventory:DropEverything(true)
                    inst.AnimState:PlayAnimation("death")
                end

                inst.AnimState:Hide("swap_arm_carry")
            end

            inst.components.burnable:Extinguish()

            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:RemotePausePrediction()
                inst.components.playercontroller:Enable(false)
            end

            --Don't process other queued events if we died this frame
            inst.sg:ClearBufferedEvents()
        end,

        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                if inst.sg.statemem.beaver then
                    inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
                elseif inst.sg.statemem.goose then
                    inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
                    DoGooseRunFX(inst)
                end
            end),
            TimeEvent(20 * FRAMES, function(inst)
                if inst.sg.statemem.moose then
                    inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
                end
            end),
        },

        onexit = function(inst)
            --You should never leave this state once you enter it!
            --            if inst.components.revivablecorpse == nil then
            --                assert(false, "Left death state.")
            --            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.sg:HasStateTag("dismounting") then
                        inst.sg:RemoveStateTag("dismounting")
                        inst.components.rider:ActualDismount()

                        inst.SoundEmitter:PlaySound("dontstarve/wilson/death")

                        if not inst:HasTag("mime") then
                            inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/") ..
                                (inst.soundsname or inst.prefab) .. "/death_voice")
                        end

                        if HUMAN_MEAT_ENABLED then
                            inst.components.inventory:GiveItem(SpawnPrefab("humanmeat")) -- Drop some player meat!
                        end
                        if inst.components.revivablecorpse ~= nil then
                            inst.AnimState:PlayAnimation("death2")
                        else
                            inst.components.inventory:DropEverything(true)
                            inst.AnimState:PlayAnimation("death")
                        end

                        inst.AnimState:Hide("swap_arm_carry")
                    elseif inst.components.revivablecorpse ~= nil then
                        inst.sg:GoToState("corpse")
                    else
                        inst:PushEvent(inst.ghostenabled and "makeplayerghost" or "playerdied",
                            { skeleton = TheWorld.Map:IsPassableAtPoint(inst.Transform:GetWorldPosition()) }) -- if we are not on valid ground then don't drop a skeleton
                    end
                end
            end),
        },
    })

--
AddStategraphState(
    "wilson",
    State {
        name = "reviver_rebirth",
        tags = { "busy", "reviver_rebirth", "pausepredict", "silentmorph", "ghostbuild" },

        onenter = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
                inst.components.playercontroller:RemotePausePrediction()
            end
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
            inst:ClearBufferedAction()

            SpawnPrefab("ghost_transform_overlay_fx").entity:SetParent(inst.entity)

            inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_get_bloodpump")
            if inst.CustomSetSkinMode ~= nil then
                inst:CustomSetSkinMode(inst.overrideghostskinmode or "ghost_skin")
            else
                inst.AnimState:SetBank("ghost")
                inst.components.skinner:SetSkinMode(inst.overrideghostskinmode or "ghost_skin")
            end
            inst.AnimState:PlayAnimation("shudder")
            inst.AnimState:PushAnimation("brace", false)
            inst.AnimState:PushAnimation("transform", false)
            inst.components.health:SetInvincible(true)
            inst:ShowHUD(false)
            --            inst:SetCameraDistance(14)

            inst:PushEvent("startghostbuildinstate")
        end,

        timeline =
        {
            TimeEvent(88 * FRAMES, function(inst)
                inst.DynamicShadow:Enable(true)
                if inst.CustomSetSkinMode ~= nil then
                    inst:CustomSetSkinMode(inst.overrideskinmode or "normal_skin")
                else
                    inst.AnimState:SetBank("wilson")
                    inst.components.skinner:SetSkinMode(inst.overrideskinmode or "normal_skin")
                end
                inst.AnimState:PlayAnimation("transform_end")
                inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_use_bloodpump")
                inst.sg:RemoveStateTag("ghostbuild")
                inst:PushEvent("stopghostbuildinstate")
            end),
            TimeEvent(89 * FRAMES, function(inst)
                if inst:HasTag("weregoose") then
                    DoGooseRunFX(inst)
                end
            end),
            TimeEvent(96 * FRAMES, function(inst)
                inst.components.bloomer:PopBloom("playerghostbloom")
                inst.AnimState:SetLightOverride(0)
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            --In case of interruptions
            inst.DynamicShadow:Enable(true)
            if inst.CustomSetSkinMode ~= nil then
                inst:CustomSetSkinMode(inst.overrideskinmode or "normal_skin")
            else
                inst.AnimState:SetBank("wilson")
                inst.components.skinner:SetSkinMode(inst.overrideskinmode or "normal_skin")
            end
            inst.components.bloomer:PopBloom("playerghostbloom")
            inst.AnimState:SetLightOverride(0)
            if inst.sg:HasStateTag("ghostbuild") then
                inst.sg:RemoveStateTag("ghostbuild")
                inst:PushEvent("stopghostbuildinstate")
            end
            --
            inst.components.health:SetInvincible(false)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end

            inst:ShowHUD(true)
            --            inst:SetCameraDistance()

            SerializeUserSession(inst)
        end,
    })


AddStategraphState(
    "wilson",
    State {
        name = "amulet_rebirth",
        tags = { "busy", "nopredict", "silentmorph" },

        onenter = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end
            inst.AnimState:PlayAnimation("amulet_rebirth")
            inst.AnimState:OverrideSymbol("FX", "player_amulet_resurrect", "FX")
            inst.components.health:SetInvincible(true)
            inst:ShowHUD(false)
            --            inst:SetCameraDistance(14)

            local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
            if item ~= nil and item.prefab == "amulet" then
                item = inst.components.inventory:RemoveItem(item)
                if item ~= nil then
                    item:Remove()
                    inst.sg.statemem.usedamulet = true
                end
            end
        end,

        timeline =
        {
            TimeEvent(0, function(inst)
                local stafflight = SpawnPrefab("staff_castinglight")
                stafflight.Transform:SetPosition(inst.Transform:GetWorldPosition())
                stafflight:SetUp({ 150 / 255, 46 / 255, 46 / 255 }, 1.7, 1)
                inst.SoundEmitter:PlaySound("dontstarve/common/rebirth_amulet_raise")
            end),
            TimeEvent(60 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/common/rebirth_amulet_poof")
            end),
            TimeEvent(80 * FRAMES, function(inst)
                local x, y, z = inst.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x, y, z, 10)
                for k, v in pairs(ents) do
                    if v ~= inst and v.components.sleeper ~= nil then
                        v.components.sleeper:GoToSleep(20)
                    end
                end
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.sg.statemem.usedamulet and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) == nil then
                inst.AnimState:ClearOverrideSymbol("swap_body")
            end
            inst:ShowHUD(true)
            --            inst:SetCameraDistance()
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
            inst.components.health:SetInvincible(false)
            inst.AnimState:ClearOverrideSymbol("FX")

            SerializeUserSession(inst)
        end,
    })


AddStategraphState(
    "wilson",
    State {
        name = "corpse_rebirth",
        tags = { "busy", "noattack", "nopredict", "nomorph" },

        onenter = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:RemotePausePrediction()
                inst.components.playercontroller:Enable(false)
            end
            inst.AnimState:PlayAnimation("death2_idle")

            inst.components.health:SetInvincible(true)
            inst:ShowActions(false)
            --            inst:SetCameraDistance(14)
        end,

        timeline =
        {
            TimeEvent(53 * FRAMES, function(inst)
                inst.components.bloomer:PushBloom("corpse_rebirth", "shaders/anim.ksh", -2)
                inst.sg.statemem.fadeintime = (86 - 53) * FRAMES
                inst.sg.statemem.fadetime = 0
            end),
            TimeEvent(86 * FRAMES, function(inst)
                inst.sg.statemem.physicsrestored = true
                inst.Physics:ClearCollisionMask()
                inst.Physics:CollidesWith(COLLISION.WORLD)
                inst.Physics:CollidesWith(COLLISION.OBSTACLES)
                inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
                inst.Physics:CollidesWith(COLLISION.CHARACTERS)
                inst.Physics:CollidesWith(COLLISION.GIANTS)

                inst.AnimState:PlayAnimation("corpse_revive")
                if inst.sg.statemem.fade ~= nil then
                    inst.sg.statemem.fadeouttime = 20 * FRAMES
                    inst.sg.statemem.fadetotal = inst.sg.statemem.fade
                end
                inst.sg.statemem.fadeintime = nil
            end),
            TimeEvent((86 + 20) * FRAMES, function(inst)
                inst.components.bloomer:PopBloom("corpse_rebirth")
            end),
        },

        onupdate = function(inst, dt)
            if inst.sg.statemem.fadeouttime ~= nil then
                inst.sg.statemem.fade = math.max(0,
                    inst.sg.statemem.fade - inst.sg.statemem.fadetotal * dt / inst.sg.statemem.fadeouttime)
                if inst.sg.statemem.fade > 0 then
                    inst.components.colouradder:PushColour("corpse_rebirth", inst.sg.statemem.fade, inst.sg.statemem
                        .fade, inst.sg.statemem.fade, 0)
                else
                    inst.components.colouradder:PopColour("corpse_rebirth")
                    inst.sg.statemem.fadeouttime = nil
                end
            elseif inst.sg.statemem.fadeintime ~= nil then
                local k = 1 - inst.sg.statemem.fadetime / inst.sg.statemem.fadeintime
                inst.sg.statemem.fade = .8 * (1 - k * k)
                inst.components.colouradder:PushColour("corpse_rebirth", inst.sg.statemem.fade, inst.sg.statemem.fade,
                    inst.sg.statemem.fade, 0)
                inst.sg.statemem.fadetime = inst.sg.statemem.fadetime + dt
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() and inst.AnimState:IsCurrentAnimation("corpse_revive") then
                    inst.components.talker:Say(GetString(inst, "ANNOUNCE_REVIVED_FROM_CORPSE"))
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst:ShowActions(true)
            --inst:SetCameraDistance()
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
            inst.components.health:SetInvincible(false)

            inst.components.bloomer:PopBloom("corpse_rebirth")
            inst.components.colouradder:PopColour("corpse_rebirth")

            if not inst.sg.statemem.physicsrestored then
                inst.Physics:ClearCollisionMask()
                inst.Physics:CollidesWith(COLLISION.WORLD)
                inst.Physics:CollidesWith(COLLISION.OBSTACLES)
                inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
                inst.Physics:CollidesWith(COLLISION.CHARACTERS)
                inst.Physics:CollidesWith(COLLISION.GIANTS)
            end

            SerializeUserSession(inst)
        end,
    })
--

local function DoEquipmentFoleySounds(inst)
    local inventory = inst.replica.inventory
    if inventory ~= nil then
        for k, v in pairs(inventory:GetEquips()) do
            if v.foleysound ~= nil then
                inst.SoundEmitter:PlaySound(v.foleysound, nil, nil, true)
            end
        end
    end
end

local function DoFoleySounds(inst)
    DoEquipmentFoleySounds(inst)
    if inst.foleysound ~= nil then
        inst.SoundEmitter:PlaySound(inst.foleysound, nil, nil, true)
    end
end

local function DoMountedFoleySounds(inst)
    DoEquipmentFoleySounds(inst)
    local rider = inst.replica.rider
    local saddle = rider ~= nil and rider:GetSaddle() or nil
    if saddle ~= nil and saddle.mounted_foleysound ~= nil then
        inst.SoundEmitter:PlaySound(saddle.mounted_foleysound, nil, nil, true)
    end
end

local function DoRunSounds(inst)
    if inst:HasTag("aquatic") then
        inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/boat_paddle")
    end
    if inst.sg.mem.footsteps > 3 and not inst:HasTag("aquatic") then
        PlayFootstep(inst, .6, true)
    else
        inst.sg.mem.footsteps = inst.sg.mem.footsteps + 1
        if not inst:HasTag("aquatic") then
            PlayFootstep(inst, 1, true)
            if inst:HasTag("aquatic") then
                inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/boat_paddle")
            end
        end
    end
end

local function PlayMooseFootstep(inst, volume, ispredicted)
    --moose footstep always full volume
    inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/moose/footstep", nil, nil, ispredicted)
    PlayFootstep(inst, volume, ispredicted)
end

local function DoMooseRunSounds(inst)
    --moose footstep always full volume
    inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/moose/footstep", nil, nil, true)
    DoRunSounds(inst)
end

local function DoMountSound(inst, mount, sound)
    if mount ~= nil and mount.sounds ~= nil then
        inst.SoundEmitter:PlaySound(mount.sounds[sound], nil, nil, true)
    end
end

local function ConfigureRunState(inst)
    if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
        inst.sg.statemem.riding = true
        inst.sg.statemem.groggy = inst:HasTag("groggy")
        inst.sg.statemem.hamfog = inst:HasTag("hamfogspeed")
    elseif inst.replica.inventory:IsHeavyLifting() then
        inst.sg.statemem.heavy = true
        inst.sg.statemem.heavy_fast = inst:HasTag("mightiness_mighty")
    elseif inst:HasTag("wereplayer") then
        inst.sg.statemem.iswere = true
        if inst:HasTag("weremoose") then
            if inst:HasTag("groggy") or inst:HasTag("hamfogspeed") then
                inst.sg.statemem.moosegroggy = true
            else
                inst.sg.statemem.moose = true
            end
        elseif inst:HasTag("weregoose") then
            if inst:HasTag("groggy") or inst:HasTag("hamfogspeed") then
                inst.sg.statemem.goosegroggy = true
            else
                inst.sg.statemem.goose = true
            end
        elseif inst:HasTag("groggy") then
            inst.sg.statemem.groggy = true
        elseif inst:HasTag("hamfogspeed") then
            inst.sg.statemem.hamfog = true
        else
            inst.sg.statemem.normal = true
        end
    elseif inst:GetStormLevel() >= TUNING.SANDSTORM_FULL_LEVEL and not inst.components.playervision:HasGoggleVision() then
        inst.sg.statemem.sandstorm = true
    elseif inst:HasTag("groggy") then
        inst.sg.statemem.groggy = true
    elseif inst:HasTag("hamfogspeed") then
        inst.sg.statemem.hamfog = true
    elseif inst:IsCarefulWalking() then
        inst.sg.statemem.careful = true
    else
        inst.sg.statemem.normal = true
        inst.sg.statemem.normalwonkey = inst:HasTag("wonkey") and not inst:HasTag("wilbur") or nil
    end
end

local function GetRunStateAnim(inst)
    return (inst.sg.statemem.heavy and "heavy_walk")
        or (inst.sg.statemem.sandstorm and "sand_walk")
        or
        ((inst.sg.statemem.groggy or inst.sg.statemem.hamfog or inst.sg.statemem.moosegroggy or inst.sg.statemem.goosegroggy) and "idle_walk")
        or (inst.sg.statemem.careful and "careful_walk")
        or (inst.sg.statemem.ridingwoby and "run_woby")
        or "run"
end

local boatrunstartcliente =
    State {
        name = "run_start",
        tags = { "moving", "running", "canrotate", "autopredict", "sailing" },
        onenter = function(inst)
            ConfigureRunState(inst)
            inst.components.locomotor:RunForward()
            if inst:HasTag("aquatic") then
                if inst:HasTag("surf") then
                    inst.AnimState:PlayAnimation("surf_pre")
                else
                    if inst:HasTag("sail") then
                        inst.AnimState:PlayAnimation("sail_pre")
                    else
                        inst.AnimState:PlayAnimation("row_pre")
                    end
                end
            else
                if inst.sg.statemem.normalwonkey and inst.components.locomotor:GetTimeMoving() >= TUNING.WONKEY_TIME_TO_RUN then
                    inst.sg:GoToState("run_monkey") --resuming after brief stop from changing directions
                    return
                end
                inst.AnimState:PlayAnimation(GetRunStateAnim(inst) .. "_pre")
            end
            inst.sg.mem.footsteps = (inst.sg.statemem.goose or inst.sg.statemem.goosegroggy) and 4 or 0
            if inst:HasTag("aquatic") then
                inst.AnimState:AddOverrideBuild("player_actions_paddle")
                --            if player_overrides[inst.prefab] then inst.AnimState:AddOverrideBuild(player_overrides[inst.prefab]) end
            end
        end,
        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,
        timeline = {
            --mounted
            TimeEvent(0, function(inst)
                if inst.sg.statemem.riding then
                    DoMountedFoleySounds(inst)
                end
            end),

            --heavy lifting
            TimeEvent(1 * FRAMES, function(inst)
                if inst.sg.statemem.heavy then
                    PlayFootstep(inst, nil, true)
                    DoFoleySounds(inst)
                end
            end),

            --moose
            TimeEvent(2 * FRAMES, function(inst)
                if inst.sg.statemem.moose then
                    PlayFootstep(inst, nil, true)
                    DoFoleySounds(inst)
                end
            end),

            --unmounted
            TimeEvent(4 * FRAMES, function(inst)
                if inst.sg.statemem.normal then
                    PlayFootstep(inst, nil, true)
                    DoFoleySounds(inst)
                end
            end),

            --mounted
            TimeEvent(5 * FRAMES, function(inst)
                if inst.sg.statemem.riding then
                    PlayFootstep(inst, nil, true)
                end
            end),

            --moose groggy
            TimeEvent(7 * FRAMES, function(inst)
                if inst.sg.statemem.moosegroggy then
                    PlayMooseFootstep(inst, nil, true)
                    DoFoleySounds(inst)
                end
            end),
        },
        events = {
            EventHandler(
                "animover",
                function(inst)
                    if inst.AnimState:AnimDone() then
                        inst.sg:GoToState("run")
                    end
                end
            )
        }
    }
AddStategraphState("wilson_client", boatrunstartcliente)

local boatruncliente =
    State {
        name = "run",
        tags = { "moving", "running", "canrotate", "sailing" },
        onenter = function(inst)
            ConfigureRunState(inst)
            inst.components.locomotor:RunForward()

            --if inst:HasTag("wilbur") then
            --inst.AnimState:SetBank("wilbur_run")
            --inst.AnimState:SetBuild("wilbur_run")
            --inst.Transform:SetSixFaced()
            --end

            if inst:HasTag("aquatic") and inst.components.rowboatwakespawner then
                inst.components.rowboatwakespawner:StartSpawning()

                local barco = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
                if barco and barco.replica.container and barco.replica.container:GetItemInSlot(1) and barco.replica.container:GetItemInSlot(1).prefab == "ironwind" then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/boatpropellor_lp", "sailmove")
                end
                if barco and barco.replica.container and barco.replica.container:GetItemInSlot(1) and barco.replica.container:GetItemInSlot(1).prefab == "sail" then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sail_LP_cloth", "sailmove")
                end
                if barco and barco.replica.container and barco.replica.container:GetItemInSlot(1) and barco.replica.container:GetItemInSlot(1).prefab == "clothsail" then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sail_LP_cloth", "sailmove")
                end
                if barco and barco.replica.container and barco.replica.container:GetItemInSlot(1) and barco.replica.container:GetItemInSlot(1).prefab == "snakeskinsail" then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sail_LP_snakeskin", "sailmove")
                end
                if barco and barco.replica.container and barco.replica.container:GetItemInSlot(1) and barco.replica.container:GetItemInSlot(1).prefab == "feathersail" then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sail_LP_feather", "sailmove")
                end
                if barco and barco.replica.container and barco.replica.container:GetItemInSlot(1) and barco.replica.container:GetItemInSlot(1).prefab == "woodlegssail" then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sail_LP_sealegs", "sailmove")
                end
                if barco and barco.replica.container and barco.replica.container:GetItemInSlot(1) and barco.replica.container:GetItemInSlot(1).prefab == "malbatrossail" then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sail_LP_sealegs", "sailmove")
                end
            end

            local anim = GetRunStateAnim(inst)
            if inst:HasTag("aquatic") then
                if inst.replica.inventory:IsHeavyLifting() then
                    anim = "heavy_idle"
                elseif inst:HasTag("surf") then
                    anim = "surf_loop"
                elseif inst:HasTag("sail") then
                    anim = "sail_loop"
                elseif inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).prefab == "oar_driftwood" then
                    anim = "row_medium"
                elseif inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).prefab == "oar" then
                    anim = "row_medium"
                else
                    anim = "row_loop"
                end
            elseif anim == "run" then
                if inst:HasTag("wilbur") and inst.timeinmotion and inst.timeinmotion > 75 and not inst.replica.rider:IsRiding() and not inst.replica.inventory:IsHeavyLifting() and not inst:IsCarefulWalking() then
                    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED + 2.5
                    if inst.components.hunger then inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * 1.33) end
                    inst.Transform:SetSixFaced()
                    inst.AnimState:SetBank("wilbur_run")
                    inst.AnimState:SetBuild("wilbur_run")
                    if inst.replica.inventory and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                        inst.AnimState:Show("TAIL_carry")
                        inst.AnimState:Hide("TAIL_normal")
                    end
                end

                anim = "run_loop"
            elseif anim == "run_woby" then
                anim = "run_woby_loop"
            end

            if not inst.AnimState:IsCurrentAnimation(anim) then
                inst.AnimState:PlayAnimation(anim, true)
            end

            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
        end,
        onupdate = function(inst)
            if inst.sg.statemem.normalwonkey and inst.components.locomotor:GetTimeMoving() >= TUNING.WONKEY_TIME_TO_RUN then
                inst.sg:GoToState("run_monkey_start")
                return
            end
            inst.components.locomotor:RunForward()
        end,

        timeline = {
            --unmounted
            TimeEvent(7 * FRAMES, function(inst)
                if inst.sg.statemem.normal then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),
            TimeEvent(15 * FRAMES, function(inst)
                if inst.sg.statemem.normal then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            --careful
            --Frame 11 shared with heavy lifting below
            --[[TimeEvent(11 * FRAMES, function(inst)
                if inst.sg.statemem.careful then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),]]
            TimeEvent(26 * FRAMES, function(inst)
                if inst.sg.statemem.careful then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            --sandstorm
            --Frame 12 shared with groggy below
            --[[TimeEvent(12 * FRAMES, function(inst)
                if inst.sg.statemem.sandstorm then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),]]
            TimeEvent(23 * FRAMES, function(inst)
                if inst.sg.statemem.sandstorm then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            --groggy
            TimeEvent(1 * FRAMES, function(inst)
                if inst.sg.statemem.groggy or inst.sg.statemem.hamfog or
                    inst.sg.statemem.goose then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),
            TimeEvent(12 * FRAMES, function(inst)
                if inst.sg.statemem.groggy or inst.sg.statemem.hamfog or
                    inst.sg.statemem.sandstorm then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            --heavy lifting
            TimeEvent(11 * FRAMES, function(inst)
                if inst.sg.statemem.heavy or
                    inst.sg.statemem.sandstorm or
                    inst.sg.statemem.careful then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                elseif inst.sg.statemem.moose then
                    DoMooseRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),
            TimeEvent(36 * FRAMES, function(inst)
                if inst.sg.statemem.heavy or
                    inst.sg.statemem.sandstorm or
                    inst.sg.statemem.careful then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            --mounted
            TimeEvent(0, function(inst)
                if inst.sg.statemem.riding then
                    DoMountedFoleySounds(inst)
                end
            end),
            TimeEvent(5 * FRAMES, function(inst)
                if inst.sg.statemem.riding then
                    DoRunSounds(inst)
                end
            end),

            --moose
            --Frame 11 shared with heavy lifting above
            --[[TimeEvent(11 * FRAMES, function(inst)
                if inst.sg.statemem.moose then
                    DoMooseRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),]]
            TimeEvent(24 * FRAMES, function(inst)
                if inst.sg.statemem.moose then
                    DoMooseRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            --moose groggy
            TimeEvent(14 * FRAMES, function(inst)
                if inst.sg.statemem.moosegroggy then
                    DoMooseRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),
            TimeEvent(30 * FRAMES, function(inst)
                if inst.sg.statemem.moosegroggy then
                    DoMooseRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            --goose
            --Frame 1 shared with groggy above
            --[[TimeEvent(1 * FRAMES, function(inst)
                if inst.sg.statemem.goose then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),]]
            TimeEvent(9 * FRAMES, function(inst)
                if inst.sg.statemem.goose then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),

            --goose groggy
            TimeEvent(4 * FRAMES, function(inst)
                if inst.sg.statemem.goosegroggy then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),
            TimeEvent(17 * FRAMES, function(inst)
                if inst.sg.statemem.goosegroggy then
                    DoRunSounds(inst)
                    DoFoleySounds(inst)
                end
            end),
        },
        events = {
            EventHandler("gogglevision", function(inst, data)
                if data.enabled then
                    if inst.sg.statemem.sandstorm then
                        inst.sg:GoToState("run")
                    end
                elseif not (inst.sg.statemem.riding or
                        inst.sg.statemem.heavy or
                        inst.sg.statemem.iswere or
                        inst.sg.statemem.sandstorm or
                        inst:GetStormLevel() < TUNING.SANDSTORM_FULL_LEVEL) then
                    inst.sg:GoToState("run")
                end
            end),
            EventHandler("sandstormlevel", function(inst, data)
                if data.level < TUNING.SANDSTORM_FULL_LEVEL then
                    if inst.sg.statemem.sandstorm then
                        inst.sg:GoToState("run")
                    end
                elseif not (inst.sg.statemem.riding or
                        inst.sg.statemem.heavy or
                        inst.sg.statemem.iswere or
                        inst.sg.statemem.sandstorm or
                        inst.components.playervision:HasGoggleVision()) then
                    inst.sg:GoToState("run")
                end
            end),
            EventHandler("carefulwalking", function(inst, data)
                if not data.careful then
                    if inst.sg.statemem.careful then
                        inst.sg:GoToState("run")
                    end
                elseif not (inst.sg.statemem.riding or
                        inst.sg.statemem.heavy or
                        inst.sg.statemem.sandstorm or
                        inst.sg.statemem.groggy or
                        inst.sg.statemem.hamfog or
                        inst.sg.statemem.careful or
                        inst.sg.statemem.iswere) then
                    inst.sg:GoToState("run")
                end
            end),
        },

        onexit = function(inst)
            if inst:HasTag("wilbur") and not inst.replica.rider:IsRiding() and not inst.replica.inventory:IsHeavyLifting() and not inst:IsCarefulWalking() then
                inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED - 0.5
                if inst.components.hunger then inst.components.hunger:SetRate(1 * TUNING.WILSON_HUNGER_RATE) end
                inst.AnimState:SetBank("wilson")
                inst.AnimState:SetBuild(inst.prefab)
                inst.Transform:SetFourFaced()
                inst.AnimState:Hide("TAIL_carry")
                inst.AnimState:Show("TAIL_normal")
            end
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("run")
        end
    }
AddStategraphState("wilson_client", boatruncliente)

local boatrunstopcliente =
    State {
        name = "run_stop",
        tags = { "canrotate", "idle", "sailing", "aparece" },
        onenter = function(inst)
            ConfigureRunState(inst)

            if inst:HasTag("aquatic") and inst.components.rowboatwakespawner then
                inst.components.rowboatwakespawner:StopSpawning()

                inst.SoundEmitter:KillSound("sailmove")
            end

            inst.components.locomotor:Stop()
            if inst:HasTag("aquatic") then
                if inst:HasTag("surf") then
                    inst.AnimState:PlayAnimation("surf_pst")
                else
                    if inst:HasTag("sail") then
                        inst.AnimState:PlayAnimation("sail_pst")
                    else
                        inst.AnimState:PlayAnimation("row_pst")
                    end
                end
            else
                inst.AnimState:PlayAnimation(GetRunStateAnim(inst) .. "_pst")

                if inst.sg.statemem.moose or inst.sg.statemem.moosegroggy then
                    PlayMooseFootstep(inst, .6, true)
                    DoFoleySounds(inst)
                end
            end
        end,

        timeline =
        {
            TimeEvent(FRAMES, function(inst)
                if inst.sg.statemem.goose or inst.sg.statemem.goosegroggy then
                    PlayFootstep(inst, .5, true)
                    DoFoleySounds(inst)
                end
            end),
        },

        events = {
            EventHandler(
                "animover",
                function(inst)
                    if inst.AnimState:AnimDone() then
                        --              if inst:HasTag("aquatic") then
                        --                  inst.sg:GoToState("brake")
                        --               else
                        inst.sg:GoToState("idle") --end
                    end

                    if inst:HasTag("aquatic") then
                        inst.AnimState:ClearOverrideBuild("player_actions_paddle")
                        --					if player_overrides[inst.prefab] then inst.AnimState:ClearOverrideBuild(player_overrides[inst.prefab]) end
                    end
                end
            )
        }
    }
AddStategraphState("wilson_client", boatrunstopcliente)

local boatbrake =
    State {
        name = "brake",
        tags = { "idle", "canrotate", "boating", "sailing", "aparece" },
        onenter = function(inst)
        end,

        onexit = function(inst)

        end,

        events = {
            EventHandler(
                "animover",
                function(inst)
                    if inst.AnimState:GetCurrentAnimationTime() > 3 then
                        inst.sg:GoToState("idle")
                    end
                end
            )
        }
    }

AddStategraphState("wilson_client", boatbrake)
AddStategraphState("wilson", boatbrake)

AddStategraphEvent("wilson",
    EventHandler("sneeze",
        function(inst, data)
            print("checkstage!!!!!!!!!")
            print(inst.sg:HasStateTag("busy"))
            print(inst.sg.currentstate.name ~= "emote")
            if not inst.components.health:IsDead() and not inst.components.health.invincible then
                if inst.sg:HasStateTag("busy") and inst.sg.currentstate.name ~= "emote" then
                    inst.wantstosneeze = true
                else
                    inst.sg:GoToState("sneeze")
                end
            end
        end))

local sneeze =
    State {
        name = "sneeze",
        tags = { "busy", "sneeze", "pausepredict" },

        onenter = function(inst)
            local usehit = inst.components.rider:IsRiding() or inst:HasTag("wereplayer")
            local stun_frames = usehit and 6 or 9
            inst.wantstosneeze = false
            inst:ClearBufferedAction()
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/hit", nil, .02)


            if inst.components.rider ~= nil and not inst.components.rider:IsRiding() then
                inst.AnimState:PlayAnimation("sneeze")
            end

            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:RemotePausePrediction(stun_frames <= 7 and stun_frames or nil)
            end


            if inst.prefab ~= "wes" then
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/sneeze")
                inst.components.talker:Say(STRINGS.CHARACTERS.GENERIC.ANNOUNCE_SNEEZE)
            end
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

        timeline =
        {
            TimeEvent(1 * FRAMES, function(inst)
                local itemstodrop = 0
                if math.random() < 0.6 then itemstodrop = itemstodrop + 1 end
                if math.random() < 0.3 then itemstodrop = itemstodrop + 1 end
                if math.random() < 0.2 then itemstodrop = itemstodrop + 1 end
                if math.random() < 0.1 then itemstodrop = itemstodrop + 1 end

                if itemstodrop > 0 then
                    for i = 1, itemstodrop do
                        if inst.components.inventory and inst.components.inventory.isopen then
                            local item = inst.components.inventory:FindItem(function(item)
                                return not item:HasTag(
                                    "nosteal")
                            end)
                            if item then
                                local direction = Vector3(inst.Transform:GetWorldPosition()) -
                                    Vector3(inst.Transform:GetWorldPosition())
                                inst.components.inventory:DropItem(item, false, direction:GetNormalized())
                            end
                        end
                    end
                end
            end),
            TimeEvent(10 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                if inst.components.sanity then inst.components.sanity:DoDelta(-3) end
            end),
        },

    }

AddStategraphState("wilson", sneeze)



local speargunstate =
    State {
        name = "speargun",
        tags = { "attack", "notalking", "abouttoattack", "autopredict" },

        onenter = function(inst)
            if inst.components.rider:IsRiding() then
                inst.Transform:SetFourFaced()
            end
            local buffaction = inst:GetBufferedAction()
            local target = buffaction ~= nil and buffaction.target or nil
            local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            inst.components.combat:SetTarget(target)
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("speargun")
            if inst.sg.prevstate == inst.sg.currentstate then
                inst.sg.statemem.chained = true
                inst.AnimState:SetTime(5 * FRAMES)
            end

            inst.sg:SetTimeout(math.max((inst.sg.statemem.chained and 14 or 18) * FRAMES,
                inst.components.combat.min_attack_period + .5 * FRAMES))

            if target ~= nil and target:IsValid() then
                inst:FacePoint(target.Transform:GetWorldPosition())
                inst.sg.statemem.attacktarget = target
            end

            if (equip ~= nil and equip.projectiledelay or 0) > 0 then
                --V2C: Projectiles don't show in the initial delayed FRAMES so that
                --     when they do appear, they're already in front of the player.
                --     Start the attack early to keep animation in sync.
                inst.sg.statemem.projectiledelay = (inst.sg.statemem.chained and 9 or 14) * FRAMES -
                    equip.projectiledelay
                if inst.sg.statemem.projectiledelay <= 0 then
                    inst.sg.statemem.projectiledelay = nil
                end
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

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst)
                if inst.sg.statemem.chained then
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_shoot", nil, nil, true)
                end
            end),
            TimeEvent(9 * FRAMES, function(inst)
                if inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                    inst:PerformBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),



            TimeEvent(15 * FRAMES, function(inst)
                if not inst.sg.statemem.chained then
                    if inst.components.combat:GetWeapon() and inst.components.combat:GetWeapon():HasTag("blunderbuss") then
                        inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/items/weapon/blunderbuss_shoot")
                        if inst.components.rider:IsRiding() then
                            local cloud = SpawnPrefab("cloudpuff")
                            local pt = Vector3(inst.Transform:GetWorldPosition())
                            cloud.Transform:SetPosition(pt.x, 4.5, pt.z)
                        else
                            local cloud = SpawnPrefab("cloudpuff")
                            local pt = Vector3(inst.Transform:GetWorldPosition())
                            cloud.Transform:SetPosition(pt.x, 2, pt.z)
                        end
                    else
                        inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/use_speargun")
                    end
                end
            end),

            TimeEvent(16 * FRAMES, function(inst)
                if not inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                    inst:PerformBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events =
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



local speargunstateclient =
    State
    {
        name = "speargun",
        tags = { "attack", "notalking", "abouttoattack" },

        onenter = function(inst)
            if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
                inst.Transform:SetFourFaced()
            end
            local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            inst.components.locomotor:Stop()

            inst.AnimState:PlayAnimation("speargun")
            if inst.sg.prevstate == inst.sg.currentstate then
                inst.sg.statemem.chained = true
                inst.AnimState:SetTime(5 * FRAMES)
            end

            if inst.replica.combat ~= nil then
                inst.replica.combat:StartAttack()
                inst.sg:SetTimeout(math.max((inst.sg.statemem.chained and 14 or 18) * FRAMES,
                    inst.replica.combat:MinAttackPeriod() + .5 * FRAMES))
            end

            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                inst:PerformPreviewBufferedAction()

                if buffaction.target ~= nil and buffaction.target:IsValid() then
                    inst:FacePoint(buffaction.target:GetPosition())
                    inst.sg.statemem.attacktarget = buffaction.target
                end
            end

            if (equip.projectiledelay or 0) > 0 then
                --V2C: Projectiles don't show in the initial delayed frames so that
                --     when they do appear, they're already in front of the player.
                --     Start the attack early to keep animation in sync.
                inst.sg.statemem.projectiledelay = (inst.sg.statemem.chained and 9 or 14) * FRAMES -
                    equip.projectiledelay
                if inst.sg.statemem.projectiledelay <= 0 then
                    inst.sg.statemem.projectiledelay = nil
                end
            end
        end,

        onupdate = function(inst, dt)
            if (inst.sg.statemem.projectiledelay or 0) > 0 then
                inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay - dt
                if inst.sg.statemem.projectiledelay <= 0 then
                    inst:ClearBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst)
                if inst.sg.statemem.chained then
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_shoot", nil, nil, true)
                end
            end),
            TimeEvent(9 * FRAMES, function(inst)
                if inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                    inst:ClearBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),



            TimeEvent(15 * FRAMES, function(inst)
                if not inst.sg.statemem.chained then
                    if inst.replica.combat:GetWeapon() and inst.replica.combat:GetWeapon():HasTag("blunderbuss") then
                        inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/items/weapon/blunderbuss_shoot")
                        if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
                            local cloud = SpawnPrefab("cloudpuff")
                            local pt = Vector3(inst.Transform:GetWorldPosition())
                            cloud.Transform:SetPosition(pt.x, 4.5, pt.z)
                        else
                            local cloud = SpawnPrefab("cloudpuff")
                            local pt = Vector3(inst.Transform:GetWorldPosition())
                            cloud.Transform:SetPosition(pt.x, 2, pt.z)
                        end
                    else
                        inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/use_speargun")
                    end
                end
            end),

            TimeEvent(16 * FRAMES, function(inst)
                if not inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                    inst:ClearBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
                inst.replica.combat:CancelAttack()
            end
            if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
                inst.Transform:SetSixFaced()
            end
        end,
    }

AddStategraphState("wilson_client", speargunstateclient)
AddStategraphState("wilson", speargunstate)

local vagnerintro = State({
    name = "sleep_dlc",

    onenter = function(inst)
        if inst.prefab == "walani" or inst.prefab == "warly" or inst.prefab == "wilbur" or inst.prefab == "woodlegs" then
            inst.AnimState:PlayAnimation("sleep", true)
        else
            inst.AnimState:PlayAnimation("sleep_loop", true)
        end
        inst.components.playercontroller:Enable(false)
        inst.components.health:SetInvincible(true)
    end,

    onexit = function(inst)
        inst.components.health:SetInvincible(false)
        inst.components.playercontroller:Enable(true)
    end,



})

local vagnerintro2 = State({
    name = "sleep_intro",
    onenter = function(inst)
        if inst.prefab == "walani" or inst.prefab == "warly" or inst.prefab == "wilbur" or inst.prefab == "woodlegs" then
            inst.AnimState:PlayAnimation("sleep", true)
        else
            inst.AnimState:PlayAnimation("sleep_loop", true)
        end
        inst.components.playercontroller:Enable(false)
        inst.components.health:SetInvincible(true)
    end,

    onexit = function(inst)
        inst.components.health:SetInvincible(false)
        inst.components.playercontroller:Enable(true)
    end,

})

AddStategraphState("wilson", vagnerintro)
AddStategraphState("wilson", vagnerintro2)
AddStategraphState("wilson_client", vagnerintro)
AddStategraphState("wilson_client", vagnerintro2)


local telescopio = State {
    name = "peertelescope",
    tags = { "doing", "busy", "canrotate" },

    onenter = function(inst, data)
        local act
        inst.sg.statemem.action = inst:GetBufferedAction()
        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil and buffaction.pos ~= nil then
            act = buffaction:GetActionPoint()
        end
        inst:ForceFacePoint(act.x, act.y, act.z)
        inst.components.playercontroller:Enable(false)
        inst.AnimState:PlayAnimation("telescope", false)
        inst.AnimState:PushAnimation("telescope_pst", false)

        inst.components.locomotor:Stop()
    end,

    timeline =
    {
        TimeEvent(20 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound(
                "dontstarve_DLC002/common/use_spyglass")
        end),
    },

    onexit = function(inst)
        inst.components.playercontroller:Enable(true)
    end,

    events = {
        EventHandler("animover", function(inst)
            inst:PerformBufferedAction()
        end),
        EventHandler("animqueueover", function(inst)
            --                local telescope = inst.sg.statemem.action.invobject or inst.sg.statemem.action.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            --                if telescope and telescope.components.finiteuses then
            -- this is here because the telescope still needs to exist while playing the put away animation
            --telescope.components.finiteuses:Use()
            --                end

            inst.sg:GoToState("idle")
        end),
    },
}

AddStategraphState("wilson", telescopio)
AddStategraphState("wilson_client", telescopio)

local magica = State {
    name = "quickcastspell",
    tags = { "doing", "busy", "canrotate" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        if inst.components.rider:IsRiding() then
            inst.AnimState:PlayAnimation("player_atk_pre")
            inst.AnimState:PushAnimation("player_atk", false)
        elseif inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("telescope") then
            inst.sg:GoToState("peertelescope")
        else
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
        end
        inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
    end,

    timeline =
    {
        TimeEvent(5 * FRAMES, function(inst)
            inst:PerformBufferedAction()
        end),
    },

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },
}

local TIMEOUT = 2

local magica_client = State
    {
        name = "quickcastspell",
        tags = { "doing", "busy", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
                inst.AnimState:PlayAnimation("player_atk_pre")
                inst.AnimState:PushAnimation("player_atk_lag", false)
            elseif inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS):HasTag("telescope") then
                inst.sg:GoToState("peertelescope")
            else
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk_lag", false)
            end

            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(TIMEOUT)
        end,

        onupdate = function(inst)
            if inst:HasTag("doing") then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
        end,

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
    }



AddStategraphState("wilson", magica)
AddStategraphState("wilson_client", magica_client)


local usefansw = State {
    name = "use_fan",
    tags = { "doing" },

    onenter = function(inst)
        local invobject = nil
        if inst.bufferedaction ~= nil then
            invobject = inst.bufferedaction.invobject
            if invobject ~= nil and invobject.components.fan ~= nil and invobject.components.fan:IsChanneling() then
                inst.sg.statemem.item = invobject
                inst.sg.statemem.target = inst.bufferedaction.target or inst.bufferedaction.doer
                inst.sg:AddStateTag("busy")
            end
        end
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("action_uniqueitem_pre")
        inst.AnimState:PushAnimation("fan", false)
        local skin_build = invobject:GetSkinBuild()
        local src_symbol = invobject ~= nil and invobject.components.fan ~= nil and
            invobject.components.fan.overridesymbol or "swap_fan"
        if skin_build ~= nil then
            inst.AnimState:OverrideItemSkinSymbol("fan01", skin_build, src_symbol, invobject.GUID, "fan")
        else
            inst.AnimState:OverrideSymbol("fan01", "fan", src_symbol)
        end


        if invobject and invobject.components.fan and invobject.components.fan.overridebuild then
            inst.AnimState:OverrideSymbol(
                "fan01",
                invobject.components.fan.overridebuild or "fan",
                invobject.components.fan.overridesymbol or "swap_fan"
            )
        end







        inst.components.inventory:ReturnActiveActionItem(invobject)
    end,

    timeline =
    {
        TimeEvent(30 * FRAMES, function(inst)
            if inst.sg.statemem.item ~= nil and
                inst.sg.statemem.item:IsValid() and
                inst.sg.statemem.item.components.fan ~= nil then
                inst.sg.statemem.item.components.fan:Channel(inst.sg.statemem.target ~= nil and
                    inst.sg.statemem.target:IsValid() and inst.sg.statemem.target or inst)
            end
        end),
        TimeEvent(50 * FRAMES, function(inst)
            if inst.sg.statemem.item ~= nil and
                inst.sg.statemem.item:IsValid() and
                inst.sg.statemem.item.components.fan ~= nil then
                inst.sg.statemem.item.components.fan:Channel(inst.sg.statemem.target ~= nil and
                    inst.sg.statemem.target:IsValid() and inst.sg.statemem.target or inst)
            end
        end),
        TimeEvent(70 * FRAMES, function(inst)
            if inst.sg.statemem.item ~= nil then
                inst.sg:RemoveStateTag("busy")
            end
            inst:PerformBufferedAction()
        end),
    },

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },
}



AddStategraphState("wilson", usefansw)






--[[
local macacorunstart = State{
        name = "run_monkey_start",
        tags = {"moving", "running", "canrotate", "monkey", "sailing"},

        onenter = function(inst)
            inst.Transform:SetSixFaced()
            inst.components.locomotor:RunForward()
            inst.AnimState:SetBank("wilbur_run")
            inst.AnimState:SetBuild("wilbur_run")
            inst.AnimState:PlayAnimation("run_pre")
            inst.SoundEmitter:PlaySound("dontstarve_DLC002/characters/wilbur/walktorun", "walktorun")
        end,

        onexit = function(inst)
            inst.AnimState:SetBank("wilson")
            inst.AnimState:SetBuild(inst.prefab)
            inst.Transform:SetFourFaced()
        end,

        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("run_monkey")
            end ),
        },
    }	

local macacorun = State{
        name = "run_monkey",
        tags = {"moving", "running", "canrotate", "monkey", "sailing"},

        onenter = function(inst)
		    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED + 2.5
if inst.components.hunger then inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * 1.33) end

            inst.Transform:SetSixFaced()
            inst.components.locomotor:RunForward()
            inst.AnimState:SetBank("wilbur_run")
            inst.AnimState:SetBuild("wilbur_run")
            inst.AnimState:PlayAnimation("run_loop")

 if inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                inst.AnimState:Show("TAIL_carry")
                inst.AnimState:Hide("TAIL_normal")
            end
        end,

        onexit = function(inst)
			inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED-0.5
if inst.components.hunger then inst.components.hunger:SetRate(1*TUNING.WILSON_HUNGER_RATE) end
            inst.AnimState:SetBank("wilson")
            inst.AnimState:SetBuild(inst.prefab)
            inst.Transform:SetFourFaced()
            inst.AnimState:Hide("TAIL_carry")
            inst.AnimState:Show("TAIL_normal")
        end,

        timeline =
        {
            TimeEvent(4*FRAMES, function(inst) PlayFootstep(inst, 0.5) end),
            TimeEvent(5*FRAMES, function(inst) PlayFootstep(inst, 0.5) DoFoleySounds(inst) end),
            TimeEvent(10*FRAMES, function(inst) PlayFootstep(inst, 0.5) end),
            TimeEvent(11*FRAMES, function(inst) PlayFootstep(inst, 0.5) end),
        },

        onupdate = function(inst)
            inst.components.locomotor:RunForward()
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("run_monkey") end),

            EventHandler("equip", function(inst)
                inst.AnimState:Show("TAIL_carry")
                inst.AnimState:Hide("TAIL_normal")
            end),

            EventHandler("unequip", function(inst)
                inst.AnimState:Hide("TAIL_carry")
                inst.AnimState:Show("TAIL_normal")
            end),
        },
    }

AddStategraphState("wilson", macacorunstart)
AddStategraphState("wilson", macacorun)
AddStategraphState("wilson_client", macacorunstart)
AddStategraphState("wilson_client", macacorun)
]]
local JUMPIN = Action({ priority = 10, ghost_valid = true, encumbered_valid = true, invalid_hold_action = true })
JUMPIN.str = (STRINGS.ACTIONS.JUMPIN)
JUMPIN.id = "JUMPIN"
JUMPIN.fn = function(act)
    if act.doer ~= nil and
        act.doer.sg ~= nil and
        act.doer.sg.currentstate.name == "jumpin_pre" then
        if act.target ~= nil and
            act.target.components.teleporter ~= nil and
            act.target.components.teleporter:IsActive() then
            if act.target:HasTag("hamletteleport") and not act.doer:HasTag("playerghost") then
                act.doer.sg:GoToState("hamletteleport", { teleporter = act.target })
            else
                act.doer.sg:GoToState("jumpin", { teleporter = act.target })
            end
            return true
        end
        act.doer.sg:GoToState("idle")
    end
end
AddAction(JUMPIN)

--进出房间动作--
local Oldstrfnjumpin = ACTIONS.JUMPIN.strfn
ACTIONS.JUMPIN.strfn = function(act)
    if act.target ~= nil and act.target:HasTag("hamletteleport") then
        return "HAMLET"
    end
    return Oldstrfnjumpin and Oldstrfnjumpin(act) or "GENERIC"
end



local function ToggleOffPhysics(inst)
    inst.sg.statemem.isphysicstoggle = true
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
end

local function ToggleOnPhysics(inst)
    inst.sg.statemem.isphysicstoggle = nil
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
end

local hamletteleport =
    State {
        name = "hamletteleport",
        tags = { "doing", "busy", "canrotate", "nopredict", "nomorph" },

        onenter = function(inst, data)
            ToggleOffPhysics(inst)
            inst.components.locomotor:Stop()

            inst.sg.statemem.target = data.teleporter
            inst.sg.statemem.heavy = inst.components.inventory:IsHeavyLifting()

            if data.teleporter ~= nil and data.teleporter.components.teleporter ~= nil then
                data.teleporter.components.teleporter:RegisterTeleportee(inst)
            end

            inst.AnimState:PlayAnimation("idle")

            local pos = data ~= nil and data.teleporter and data.teleporter:GetPosition() or nil

            local MAX_JUMPIN_DIST = 0
            local MAX_JUMPIN_DIST_SQ = MAX_JUMPIN_DIST * MAX_JUMPIN_DIST
            local MAX_JUMPIN_SPEED = 0

            local dist
            if pos ~= nil then
                inst:ForceFacePoint(pos:Get())
                local distsq = inst:GetDistanceSqToPoint(pos:Get())
                if distsq <= .25 * .25 then
                    dist = 0
                    inst.sg.statemem.speed = 0
                elseif distsq >= MAX_JUMPIN_DIST_SQ then
                    dist = MAX_JUMPIN_DIST
                    inst.sg.statemem.speed = MAX_JUMPIN_SPEED
                else
                    dist = math.sqrt(distsq)
                    inst.sg.statemem.speed = MAX_JUMPIN_SPEED * dist / MAX_JUMPIN_DIST
                end
            else
                inst.sg.statemem.speed = 0
                dist = 0
            end

            inst.Physics:SetMotorVel(inst.sg.statemem.speed * .5, 0, 0)

            inst.sg.statemem.teleportarrivestate = "idle"
        end,

        timeline =
        {
            TimeEvent(.5 * FRAMES, function(inst)
                inst.Physics:SetMotorVel(inst.sg.statemem.speed * (inst.sg.statemem.heavy and .55 or .75), 0, 0)
            end),
            TimeEvent(1 * FRAMES, function(inst)
                inst.Physics:SetMotorVel(
                    inst.sg.statemem.heavy and inst.sg.statemem.speed * .6 or inst.sg.statemem.speed, 0, 0)
            end),

            --Heavy lifting
            TimeEvent(12 * FRAMES, function(inst)
                if inst.sg.statemem.heavy then
                    inst.Physics:SetMotorVel(inst.sg.statemem.speed * .5, 0, 0)
                end
            end),
            TimeEvent(13 * FRAMES, function(inst)
                if inst.sg.statemem.heavy then
                    inst.Physics:SetMotorVel(inst.sg.statemem.speed * .4, 0, 0)
                end
            end),
            TimeEvent(14 * FRAMES, function(inst)
                if inst.sg.statemem.heavy then
                    inst.Physics:SetMotorVel(inst.sg.statemem.speed * .3, 0, 0)
                end
            end),

            --Normal
            TimeEvent(15 * FRAMES, function(inst)
                if not inst.sg.statemem.heavy then
                    inst.Physics:Stop()
                end

                -- this is just hacked in here to make the sound play BEFORE the player hits the wormhole
                if inst.sg.statemem.target ~= nil then
                    if inst.sg.statemem.target:IsValid() then
                        inst.sg.statemem.target:PushEvent("starttravelsound", inst)
                    else
                        inst.sg.statemem.target = nil
                    end
                end
            end),

            --Heavy lifting
            TimeEvent(20 * FRAMES, function(inst)
                if inst.sg.statemem.heavy then
                    inst.Physics:Stop()
                end
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.sg.statemem.target ~= nil and
                        inst.sg.statemem.target:IsValid() and
                        inst.sg.statemem.target.components.teleporter ~= nil then
                        --Unregister first before actually teleporting
                        inst.sg.statemem.target.components.teleporter:UnregisterTeleportee(inst)
                        if inst.sg.statemem.target.components.teleporter:Activate(inst) then
                            inst.sg.statemem.isteleporting = true
                            inst.components.health:SetInvincible(true)
                            if inst.components.playercontroller ~= nil then
                                inst.components.playercontroller:Enable(false)
                            end
                            inst:Hide()
                            inst.DynamicShadow:Enable(false)
                            return
                        end
                    end
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.sg.statemem.isphysicstoggle then
                ToggleOnPhysics(inst)
            end

            if inst.sg.statemem.isteleporting then
                inst.components.health:SetInvincible(false)
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
                inst:Show()
                inst.DynamicShadow:Enable(true)
            elseif inst.sg.statemem.target ~= nil
                and inst.sg.statemem.target:IsValid()
                and inst.sg.statemem.target.components.teleporter ~= nil then
                inst.sg.statemem.target.components.teleporter:UnregisterTeleportee(inst)
            end
        end,
    }

AddStategraphState("wilson_client", hamletteleport)
AddStategraphState("wilson", hamletteleport)
