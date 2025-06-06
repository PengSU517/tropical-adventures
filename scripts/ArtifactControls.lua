local ARTIFACT_ACTIONS_STR = { "CHOP", "MINE", "DIG", "HAMMER", "ATTACK", "HACK" }

local function ArtifactActionString(inst, act)
    for _, v in ipairs(ARTIFACT_ACTIONS_STR) do
        if act.action == ACTIONS[v] then
            return STRINGS.ACTIONS.PUNCH
        end
    end
end

local ARTIFACT_ACTIONS = 
{
     { "CHOP_workable", "CHOP" }, 
     { "MINE_workable", "MINE" }, 
     { "DIG_workable", "DIG" }, 
     --{ "HAMMER_workable", "HAMMER" },  -- Too aggressive, skip at actionbutton
     { "HACK_workable", "HACK" },
     { "inactive", "ACTIVATE" },  -- Wood gate
    --  { "pickable", "PICK" } 
}

local function GetArtifactAction(inst, target)
    for _, v in ipairs(ARTIFACT_ACTIONS) do
        if target:HasTag(v[1]) then
            return ACTIONS[v[2]]
        end
    end

    if target.replica.container and target.replica.container:CanBeOpened() then
        return ACTIONS.RUMMAGE
    end

    --  if target.replica.inventoryitem and target.replica.inventoryitem:CanBePickedUp() then
    --       return ACTIONS.PICKUP
    --  end

    if target:HasTag("walkingplank") then
        if inst:HasTag("on_walkable_plank") then
            return ACTIONS.ABANDON_SHIP
        elseif target:HasTag("plank_extended") then
            return ACTIONS.MOUNT_PLANK
        else
            return ACTIONS.EXTEND_PLANK
        end
    end
end

local ARTIFACT_TARGET_EXCLUDE_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO", "catchable", "sign" }

local function ArtifactActionButton(inst, force_target) -- Space bar (by default)
    if not inst.components.playercontroller:IsDoingOrWorking() then
        if not force_target then
            local x, y, z = inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, inst.components.playercontroller.directwalking and 3 or 6, nil,
                ARTIFACT_TARGET_EXCLUDE_TAGS, nil)
            for i, v in ipairs(ents) do
                if v ~= inst and v.entity:IsVisible() and CanEntitySeeTarget(inst, v) then
                    local action = GetArtifactAction(inst, v)
                    if action then
                        return BufferedAction(inst, v, action)
                    end
                end
            end
        elseif inst:GetDistanceSqToInst(force_target) <= (inst.components.playercontroller.directwalking and 9 or 36) then
            local action = GetArtifactAction(inst, force_target)
            if action then
                return BufferedAction(inst, force_target, action)
            end
        end
    end
end

local function ArtifactLeftClickPicker(inst, target, pos)
    local item = inst.replica.inventory:GetActiveItem()

    if target and target ~= inst then
        if item and target:HasTag("trader") then
            return inst.components.playeractionpicker:SortActionList({ACTIONS.GIVE}, target, item)
        end

        if inst.replica.combat:CanTarget(target) or
            inst.components.playercontroller:IsControlPressed(CONTROL_FORCE_ATTACK) then
            return inst.components.playeractionpicker:SortActionList({ACTIONS.ATTACK}, target, nil)
        end

        if target:HasTag("HAMMER_workable") then -- Higher priority to override ACTIVATE
            return inst.components.playeractionpicker:SortActionList({ACTIONS.HAMMER}, target, nil)
        end

        for _, v in ipairs(ARTIFACT_ACTIONS) do
            if target:HasTag(v[1]) then
                return inst.components.playeractionpicker:SortActionList({ACTIONS[v[2]]}, target, nil)
            end
        end

        --   if target.replica.inventoryitem and target.replica.inventoryitem:CanBePickedUp() then
        --        return inst.components.playeractionpicker:SortActionList({ ACTIONS.PICKUP }, target, nil)
        --   end

        if target:HasTag("walkingplank") and target:HasTag("interactable") then
            if target:HasTag("plank_extended") then
                return inst.components.playeractionpicker:SortActionList({ACTIONS.MOUNT_PLANK}, target, nil)
            else
                return inst.components.playeractionpicker:SortActionList({ACTIONS.EXTEND_PLANK}, target, nil)
            end
        end

        if target:HasTag("migrator") then -- World shard
            return inst.components.playeractionpicker:SortActionList({ACTIONS.MIGRATE}, target, nil)
        end

        if target:HasTag("teleporter") and not target:HasTag("townportal") then -- Wormhole
            return inst.components.playeractionpicker:SortActionList({ACTIONS.JUMPIN}, target, nil)
        end
    end

    if pos and item then
        local actlist = inst.components.playeractionpicker:SortActionList({ACTIONS.DROP}, pos, item)
        if item.replica.stackable then
            actlist[1].options.wholestack = true
        end
        return actlist
    end
end

local function ArtifactRightClickPicker(inst, target, pos)
    if not TheWorld.ismastersim and inst.tryoverride then -- Verify success override
        SendModRPCToServer(GetModRPC("Living Artifact", "UpdateControls"))
    end

    if target and target ~= inst then
        if target:HasTag("walkingplank") then
            if inst:HasTag("on_walkable_plank") then
                return inst.components.playeractionpicker:SortActionList({ACTIONS.ABANDON_SHIP}, target, nil)
            elseif target:HasTag("plank_extended") then
                return inst.components.playeractionpicker:SortActionList({ACTIONS.RETRACT_PLANK}, target, nil)
            end
        end
    end

    local shoot_target = (target and target ~= inst) and target or pos
    if shoot_target then
        return inst.components.playeractionpicker:SortActionList({ACTIONS.CHARGE_UP}, shoot_target, nil)
    end

    -- TODO: plant/deploy?
end

local function ReticuleTargetFn(inst) return Vector3(inst.entity:LocalToWorldSpace(1.5, 0, 0)) end

local function ReticuleUpdatePositionFn(inst, pos, reticule, ease, smoothing, dt)
    local x, y, z = inst.Transform:GetWorldPosition()
    reticule.Transform:SetPosition(x, 0, z)
    local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
    if ease and dt then
        local rot0 = reticule.Transform:GetRotation()
        local drot = rot - rot0
        rot = Lerp((drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or rot0, rot, dt * smoothing)
    end
    reticule.Transform:SetRotation(rot)

    if inst.components.reticule then
        inst.components.reticule.ease = reticule.entity:IsVisible()
    end
end

local function EnableReticule(inst, enable)
    if enable then
        if not inst.components.reticule then
            inst:AddComponent("reticule")
            inst.components.reticule.reticuleprefab = "reticuleline2"
            inst.components.reticule.targetfn = ReticuleTargetFn
            inst.components.reticule.updatepositionfn = ReticuleUpdatePositionFn
            inst.components.reticule.ease = true
            if inst.components.playercontroller and inst == ThePlayer then
                inst.components.playercontroller:RefreshReticule()
            end
        end
    elseif inst.components.reticule then
        inst:RemoveComponent("reticule")
        if inst.components.playercontroller and inst == ThePlayer then
            inst.components.playercontroller:RefreshReticule()
        end
    end
end

local function toggle(player, on)
    if on then
        player.ActionStringOverride = ArtifactActionString
        if player.components.playercontroller then
            player.components.playercontroller.actionbuttonoverride = ArtifactActionButton
        end
        if player.components.playeractionpicker then
            player.components.playeractionpicker.leftclickoverride = ArtifactLeftClickPicker
            player.components.playeractionpicker.rightclickoverride = ArtifactRightClickPicker
        end
        EnableReticule(player, true) -- Not sure if this works, I don't use controllers...
    else
        player.ActionStringOverride = nil
        if player.components.playercontroller then
            player.components.playercontroller.actionbuttonoverride = nil
        end
        if player.components.playeractionpicker then
            player.components.playeractionpicker.leftclickoverride = nil
            player.components.playeractionpicker.rightclickoverride = nil
        end
        EnableReticule(player, false)
    end
end

return {toggle = toggle}