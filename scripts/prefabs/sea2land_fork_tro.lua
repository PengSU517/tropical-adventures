local assets = {
    Asset("ANIM", "anim/pitchfork.zip"),
    Asset("ANIM", "anim/swap_land_fork.zip")
}

local prefabs = {
    "sinkhole_spawn_fx_1",
    "sinkhole_spawn_fx_2",
    "sinkhole_spawn_fx_3",
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_land_fork", "swap_pitchfork")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if owner.components.drownable and owner.components.drownable.enabled ~= false then
        owner.components.drownable.enabled = false
    end
    owner.Physics:ClearCollisionMask()
    owner.Physics:CollidesWith(COLLISION.GROUND)
    owner.Physics:CollidesWith(COLLISION.OBSTACLES)
    owner.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    owner.Physics:CollidesWith(COLLISION.CHARACTERS)
    owner.Physics:CollidesWith(COLLISION.GIANTS)
    owner.Physics:Teleport(owner.Transform:GetWorldPosition())
    SendModRPCToClient(CLIENT_MOD_RPC['sea2land']["fork_equip_change"], owner.userid, inst, inst.turf, true)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if owner.components.drownable then
        owner.components.drownable.enabled = true
    end
    owner.Physics:ClearCollisionMask()
    owner.Physics:CollidesWith(COLLISION.WORLD)
    owner.Physics:CollidesWith(COLLISION.OBSTACLES)
    owner.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    owner.Physics:CollidesWith(COLLISION.CHARACTERS)
    owner.Physics:CollidesWith(COLLISION.GIANTS)
    owner.Physics:Teleport(inst.Transform:GetWorldPosition())
    SendModRPCToClient(CLIENT_MOD_RPC['sea2land']["fork_equip_change"], owner.userid, inst, inst.turf, false)
end

local function spellCB(tool, target, pos)
    target = tool.components.inventoryitem.owner
    if target.components and target.components.talker then
        if tool.state == nil then
            if tool.task1 then
                tool.task1:Cancel()
                tool.task1 = nil
            end
            target.components.talker:Say("应用填海造陆重新载入，\n请在3秒后5秒内再次应用确认！", 3)
            tool.task1 = target:DoTaskInTime(3, function(target1)
                tool.state = 1
                tool.task2 = target1.components.talker:Say("请在两2秒内再次应用确认！", 2)
                target1:DoTaskInTime(2, function(target2)
                    if tool.state == 1 then
                        tool.state = nil
                        target1.components.talker:Say("未应用！", 3)
                    end
                end)
            end)
        else
            if tool.state == 1 then
                tool.state = 2
                if tool.task2 then
                    tool.task2:Cancel()
                    tool.task2 = nil
                end
                target.components.talker:Say("已确认！", 3)
                c_save()
                c_announce("重新载入世界！应用填海造陆！")
                target:DoTaskInTime(5, function()
                    c_reset()
                end)
            end
        end
    end
end

local function can_cast_fn(doer, target, pos)
    return true
end

local function doCheckAdmin(inst, self)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner == nil or owner.components.inventory == nil then
        return
    end
    if not owner:HasTag('sea2land_admin') then
        owner.components.inventory:DropItem(self, true, true)
        if owner.components.talker then
            owner.components.talker:Say("只有管理员可以使用！", 2)
        end
    end
end

local function checkAdmin(inst, owner)
    if inst.checkownertask ~= nil then
        inst.checkownertask:Cancel()
        inst.checkownertask = nil
    end

    if owner == nil then
        return
    elseif owner.components.inventoryitem ~= nil then
        inst.oncontainerpickedup = function()
            if inst.checkownertask ~= nil then
                inst.checkownertask:Cancel()
            end
            inst.checkownertask = inst:DoTaskInTime(0, doCheckAdmin, inst)
        end
        inst:ListenForEvent("onputininventory", inst.oncontainerpickedup, owner)
    end
    inst.checkownertask = inst:DoTaskInTime(0, doCheckAdmin, inst)
end

local function normal()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("pitchfork")
    inst.AnimState:SetBuild("pitchfork")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetMultColour(1, 1, 0, 1)

    inst:AddTag("allow_action_on_impassable")

    MakeInventoryFloatable(inst, "med", 0.05, { 0.78, 0.4, 0.78 }, true, 7, { sym_build = "swap_land_fork" })

    inst.entity:SetPristine()

    inst.spelltype = "SEA2LAND"

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("spellcaster")
    inst.components.spellcaster.veryquickcast = true
    inst.components.spellcaster.canusefrominventory = true
    inst.components.spellcaster:SetSpellFn(spellCB)
    inst.components.spellcaster:SetCanCastFn(can_cast_fn)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "sea2land_fork"
    inst.components.inventoryitem.atlasname = "images/sea2land_fork.xml"

    inst:AddComponent("sea2land")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:ListenForEvent("onputininventory", checkAdmin)
    inst:ListenForEvent("ondropped", checkAdmin)

    MakeHauntableLaunch(inst)
    if TheWorld:HasTag("cave") then
        inst.turf = GROUND.IMPASSABLE
    else
        inst.turf = GROUND.OCEAN_COASTAL
    end

    inst.OnLoad = function(_inst, data)
        if data and data.turf then
            _inst.turf = data.turf
        end
    end

    inst.OnSave = function(_inst, data)
        data.turf = _inst.turf
    end

    return inst
end

return Prefab("sea2land_fork", normal, assets, prefabs)
