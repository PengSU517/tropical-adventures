local assets =
{
    Asset("ANIM", "anim/portal_hamlet.zip"),
    Asset("ANIM", "anim/portal_hamlet_build.zip"),
    Asset("ANIM", "anim/portal_shipwrecked.zip"),
    Asset("ANIM", "anim/portal_shipwrecked_build.zip"),
    Asset("ANIM", "anim/portal_stone.zip"),
}

local function OnDoneTeleporting(inst, obj)
    if inst.closetask ~= nil then
        inst.closetask:Cancel()
    end

    if obj ~= nil and obj:HasTag("player") then
        obj:DoTaskInTime(1, obj.PushEvent, "wormholespit") -- for wisecracker
    end
end

local function OnActivate(inst, doer)
    if doer:HasTag("player") then
        ProfileStatsSet("wormhole_used", true)

        local other = inst.components.teleporter.targetTeleporter
        if other ~= nil then
            DeleteCloseEntsWithTag("WORM_DANGER", other, 15)
        end

        if doer.components.talker ~= nil then
            doer.components.talker:ShutUp()
        end
        if doer.components.sanity ~= nil then
            doer.components.sanity:DoDelta(-TUNING.SANITY_MED)
        end

        --Sounds are triggered in player's stategraph
    elseif inst.SoundEmitter ~= nil then
        inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/swallow")
    end
end

local function OnActivateByOther(inst, source, doer)
    --    if not inst.sg:HasStateTag("open") then
    --        inst.sg:GoToState("opening")
    --    end
end

local function onaccept(inst, giver, item)
    inst.components.inventory:DropItem(item)
    inst.components.teleporter:Activate(item)
end

local function StartTravelSound(inst, doer)
    inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/swallow")
    doer:PushEvent("wormholetravel", WORMHOLETYPE.WORM) --Event for playing local travel sound
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()

    inst.MiniMapEntity:SetIcon("shipwrecked_exit.png")

    inst.AnimState:SetBank("boatportal")
    inst.AnimState:SetBuild("portal_shipwrecked_build")
    inst.AnimState:PlayAnimation("idle_on")

    --trader, alltrader (from trader component) added to pristine state for optimization
    inst:AddTag("trader")
    inst:AddTag("alltrader")

    inst:AddTag("antlion_sinkhole_blocker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("teleporter")
    inst.components.teleporter.onActivate = OnActivate
    inst.components.teleporter.onActivateByOther = OnActivateByOther
    inst.components.teleporter.offset = 0
    inst:ListenForEvent("starttravelsound", StartTravelSound) -- triggered by player stategraph
    inst:ListenForEvent("doneteleporting", OnDoneTeleporting)

    inst:AddComponent("inventory")

    inst:AddComponent("trader")
    inst.components.trader.acceptnontradable = true
    inst.components.trader.onaccept = onaccept
    inst.components.trader.deleteitemonaccept = false

    inst:DoTaskInTime(1, function(inst)
        for k, v in pairs(Ents) do
            if v ~= inst and v.prefab == "ligamundosw" then
                inst.components.teleporter.targetTeleporter = v
                v.components.teleporter.targetTeleporter = inst
            end
        end
    end)

    inst:DoTaskInTime(3, function(inst)
        if inst.components.teleporter.targetTeleporter == nil then
            inst:Remove()
        end
    end)


    return inst
end

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()

    inst.MiniMapEntity:SetIcon("portal_ham.png")

    inst.AnimState:SetBank("hamportal")
    inst.AnimState:SetBuild("portal_hamlet_build")
    inst.AnimState:PlayAnimation("idle_on")

    --trader, alltrader (from trader component) added to pristine state for optimization
    inst:AddTag("trader")
    inst:AddTag("alltrader")

    inst:AddTag("antlion_sinkhole_blocker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("teleporter")
    inst.components.teleporter.onActivate = OnActivate
    inst.components.teleporter.onActivateByOther = OnActivateByOther
    inst.components.teleporter.offset = 0
    inst:ListenForEvent("starttravelsound", StartTravelSound) -- triggered by player stategraph
    inst:ListenForEvent("doneteleporting", OnDoneTeleporting)

    inst:AddComponent("inventory")

    inst:AddComponent("trader")
    inst.components.trader.acceptnontradable = true
    inst.components.trader.onaccept = onaccept
    inst.components.trader.deleteitemonaccept = false

    inst:DoTaskInTime(1, function(inst)
        for k, v in pairs(Ents) do
            if v ~= inst and v.prefab == "ligamundoham" then
                inst.components.teleporter.targetTeleporter = v
                v.components.teleporter.targetTeleporter = inst
            end
        end
    end)

    inst:DoTaskInTime(3, function(inst)
        if inst.components.teleporter.targetTeleporter == nil then
            inst:Remove()
        end
    end)

    return inst
end

return Prefab("ligamundosw", fn, assets),
    Prefab("ligamundoham", fn1, assets)
