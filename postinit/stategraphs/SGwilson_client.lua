local AddStategraphState = AddStategraphState
local AddStategraphEvent = AddStategraphEvent
local AddStategraphPostInit = AddStategraphPostInit
local AddStategraphActionHandler = AddStategraphActionHandler
local AddStategraphPostInit = AddStategraphPostInit

local ActionHandler = GLOBAL.ActionHandler
local EventHandler = GLOBAL.EventHandler
local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent

local FRAMES = GLOBAL.FRAMES
local ACTIONS = GLOBAL.ACTIONS
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS

local TIMEOUT = 2
local DoFoleySounds = nil

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



local actionhandlers = {
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
    ),
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
    ),
    ActionHandler(ACTIONS.ACTIVATESAIL, "doshortaction"),
    ActionHandler(ACTIONS.COMPACTPOOP, "doshortaction"),
    ActionHandler(ACTIONS.DESACTIVATESAIL, "doshortaction"),
    ActionHandler(ACTIONS.BOATMOUNT, "jumponboatstart_pre"),
    ActionHandler(ACTIONS.BOATREPAIR, "dolongaction"),
    ActionHandler(ACTIONS.OPENTUNA, "dolongaction"),
    ActionHandler(ACTIONS.BOATCANNON, "doshortaction"),
    ActionHandler(ACTIONS.RETRIEVE, "dolongaction"),
    ActionHandler(ACTIONS.SHOP, "doshortaction"),
    ActionHandler(ACTIONS.SMELT, "doshortaction"),
    ActionHandler(ACTIONS.GIVE2, "give"),
    ActionHandler(ACTIONS.PAINT, "dolongaction"),
    ActionHandler(ACTIONS.DISLODGE, "tap"),
    ActionHandler(ACTIONS.GAS, "crop_dust"),
    ActionHandler(ACTIONS.SURF, "surfando"),
    ActionHandler(ACTIONS.INVESTIGATEGLASS, "investigate_start"),
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
    ),
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
    ),

    ActionHandler(
        ACTIONS.PAN,
        function(inst)
            if not inst.sg:HasStateTag("panning") then
                return "pan_start"
            end
        end
    ),
    ActionHandler(
        ACTIONS.HACK1,
        function(inst)
            if inst:HasTag("beaver") then
                return not inst.sg:HasStateTag("gnawing") and "gnaw" or nil
            end
            return not inst.sg:HasStateTag("prechop") and "chop_start" or nil
        end
    ),
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
    ),

    ActionHandler(ACTIONS.SLEEPIN,
        function(inst, action)
            if action and action.target and action.target:HasTag("cama") then
                local x, y, z = action.target.Transform:GetWorldPosition()
                action.doer.Transform:SetPosition(x + 0.02, y, z + 0.02)
            end
            return action.invobject ~= nil and "bedroll" or action.target:HasTag("cama") and "bedroll1" or "tent"
        end
    ),
}

local eventhandlers = {
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
        end)
}

local states = {


    State { name = "cower",
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

    State { name = "grabbed",
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

    State { name = "disgrabbed",
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

    State { name = "jumponboatstart_pre",
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
    },



    State { name = "pan_start", ----完全一致
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
    },

    State { name = "pan",
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
    },


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
    },


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
    },


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
    },

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
    },


    State { name = "shear",
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
    },


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

    },

    State { name = "sanity_stun",
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
    },

    State { name = "death_boat",
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
    },

    State { name = "tap",
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
    },

    State { name = "tap",
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
    },

    State { name = "tap_loop",
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
    },

    State { name = "run_start",
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
    },

    State { name = "run",
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
    },

    State { name = "run_stop",
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
    ,
    State { name = "brake",
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
    },

    State { name = "bedroll1",
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
    },

    State { name = "speargun",
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
    },

    State { name = "peertelescope",
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
    },

    State { name = "quickcastspell",
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
    },

    State { name = "hamletteleport",
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

AddStategraphState("wilson_client",
    State {
        name = "goggleattack", --激光眼镜
        tags = { "attack", "notalking", "abouttoattack" },

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                inst:PerformPreviewBufferedAction()
                if buffaction.target ~= nil and buffaction.target:IsValid() then
                    inst:FacePoint(buffaction.target:GetPosition())
                    inst.sg.statemem.attacktarget = buffaction.target
                    inst.sg.statemem.retarget = buffaction.target
                end
            end
            local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            if (equip ~= nil and equip.projectiledelay or 0) > 0 then
                inst.sg.statemem.projectiledelay = (inst.sg.statemem.chained and 9 or 14) * FRAMES -
                    equip.projectiledelay
                if inst.sg.statemem.projectiledelay <= 0 then
                    inst.sg.statemem.projectiledelay = nil
                end
            end
            inst.replica.combat:StartAttack()
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("goggle_fast")
            if inst.sg.laststate == inst.sg.currentstate then
                inst.sg.statemem.chained = true
                inst.AnimState:SetFrame(5)
            end
            inst.AnimState:PushAnimation("goggle_fast_pst", false)

            inst.sg:SetTimeout(math.max((inst.sg.statemem.chained and 14 or 18) * FRAMES,
                inst.replica.combat:MinAttackPeriod()))
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
            TimeEvent(9 * FRAMES, function(inst)
                if inst.sg.statemem.chained and inst.sg.statemem.projectiledelay == nil then
                    inst:ClearBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),
            TimeEvent(14 * FRAMES, function(inst)
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
            if inst.sg:HasStateTag("abouttoattack") then
                inst.replica.combat:CancelAttack()
            end
        end,
    }
)

AddStategraphPostInit("wilson_client", function(inst)
    local actionHandler_attack = inst.actionhandlers[ACTIONS.ATTACK].deststate
    inst.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action, ...)
        if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.replica.health:IsDead()) then
            local weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            local hand = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if hand == nil and weapon and weapon.prefab == "gogglesshoothat" then
                return "goggleattack"
            end
        end
        return actionHandler_attack(inst, action, ...)
    end
end)
