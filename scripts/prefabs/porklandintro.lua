local assets =
{
    Asset("ANIM", "anim/balloon_wreckage.zip"),
}

local prefabs = {

}

local function disolve(inst, mult)
    if not mult then
        mult = 1
    end
    local time_to_erode = 4 * mult

    local tick_time = TheSim:GetTickTime()
    inst:StartThread(function()
        local ticks = 0
        while ticks * tick_time < time_to_erode do
            local erode_amount = ticks * tick_time / time_to_erode
            inst.AnimState:SetErosionParams(erode_amount, 0.1, 1.0)
            ticks = ticks + 1
            Yield()
        end
        inst:Remove()
    end)
end


local function Disappear(inst, mult)
    if not mult then
        mult = 1
    end

    inst.AnimState:SetMultColour(1, 0.5, 0.5, 1)
    inst.AnimState:PlayAnimation("disappear")

    local layer1 = SpawnPrefab("porkland_intro_chameleon_child")
    inst:AddChild(layer1)
    layer1.AnimState:SetFinalOffset(-1)
    layer1.Transform:SetPosition(0, 0, 0)
    layer1.AnimState:PlayAnimation("disappear")
    inst.layer1 = layer1

    local layer2 = SpawnPrefab("porkland_intro_chameleon_child")
    inst:AddChild(layer2)
    layer2.AnimState:SetFinalOffset(-2)
    layer2.AnimState:SetMultColour(0.5, 0.5, 1, 1)
    layer2.Transform:SetPosition(0, 0, 0)
    layer2.AnimState:PlayAnimation("disappear")
    inst.layer2 = layer2

    local layer3 = SpawnPrefab("porkland_intro_chameleon_child")
    inst:AddChild(layer3)
    layer3.AnimState:SetFinalOffset(-3)
    layer3.AnimState:SetMultColour(0.5, 1, 0.5, 1)
    layer3.Transform:SetPosition(0, 0, 0)
    layer3.AnimState:PlayAnimation("disappear")
    inst.layer3 = layer3

    inst:DoTaskInTime(0 * mult, function() disolve(layer1, mult) end)
    inst:DoTaskInTime(0.5 * mult, function() disolve(layer2, mult) end)
    inst:DoTaskInTime(1 * mult, function() disolve(layer3, mult) end)
    inst:DoTaskInTime(1.5 * mult, function() disolve(inst, mult) end)

    --[[
    inst.AnimState:PlayAnimation("sway")

    inst.animoverfn = function()
        inst:Remove()
    end

    inst:ListenForEvent("animover", inst.animoverfn)
  ]]
end


local SPEECH =
{
    NULL_SPEECH =
    {
        voice = "dontstarve/maxwell/talk_LP",
        appearanim = "idle",
        idleanim = "idle",
        --dialogpreanim = "dialog_pre",
        dialoganim = "dialogue",
        --dialogpostanim = "dialog_pst",
        disappearanim = Disappear,
        disableplayer = true,
        skippable = true,
        {
            string = "There is no speech number.", --The string maxwell will say
            wait = 2,                              --The time this segment will last for
            anim = nil,                            --If there's a different animation, the animation maxwell will play
            sound = nil,                           --if there's an extra sound, the sound that will play
        },
        {
            string = nil,
            wait = 0.5,
            anim = "smoke",
            sound = "dontstarve/common/destroy_metal",
        },
        {
            string = "Go set one.",
            wait = 2,
            anim = nil,
            sound = nil,
        },
        {
            string = "Goodbye",
            wait = 1,
            anim = nil,
            sound = "dontstarve/common/destroy_metal",
        },

    },

    PORKLAND_1 =
    {
        voice = "dontstarve_DLC003/creatures/cameleon/talk",
        idleanim = "idle",
        dialoganim = "dialogue",
        disappearanim = Disappear,
        disableplayer = true,
        skippable = true,
        {
            string = nil,
            wait = 2,
            anim = "idle",
            pushanim = true,
            sound = "dontstarve_DLC003/creatures/cameleon/talk",
        },
        {
            string = STRINGS.PORKLAND_SANDBOXINTROS.ONE,
            dialoganim = "dialogue",
            wait = 2,
            anim = nil,
            sound = "dontstarve_DLC003/creatures/cameleon/talk",
        },
        {
            string = STRINGS.PORKLAND_SANDBOXINTROS.TWO,
            dialoganim = "dialogue_2",
            wait = 1,
            anim = nil,
            sound = "dontstarve_DLC003/creatures/cameleon/talk",
        },
    },
}

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function onworked(inst, hitanim, anim)
    inst.AnimState:PlayAnimation(hitanim)
    inst.AnimState:PushAnimation(anim)
end

local function introfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.Transform:SetTwoFaced()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("cham")
    inst.AnimState:SetBuild("chameleon")
    inst.AnimState:PlayAnimation("idle")

    inst.Transform:SetScale(0.85, 0.85, 0.85)

    inst:AddTag("notarget")
    inst:AddTag("porklandintro")

    inst:AddComponent("inspectable")

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 40
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -550, 0)

    inst:AddComponent("maxwelltalker")
    inst.components.maxwelltalker.setdist = 6
    inst.components.maxwelltalker.speeches = SPEECH
    inst.components.maxwelltalker.cleartrees = true

    return inst
end

local function fn(anim, loot, onground, minimapicon, talker, collision)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    --inst.Transform:SetTwoFaced()
    inst.entity:AddNetwork()

    if collision then
        MakeObstaclePhysics(inst, 0.75)
    end

    inst.AnimState:SetBank("balloon_wreckage")
    inst.AnimState:SetBuild("balloon_wreckage")
    inst.AnimState:PlayAnimation(anim)


    if minimapicon then
        local minimap = inst.entity:AddMiniMapEntity()
        minimap:SetIcon(minimapicon .. ".tex")
    end
    -- at the momnent only the ground thing isn't workable.. this might change tho..
    if onground then
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(3)
        if not loot then
            inst:AddTag("NOCLICK")
        end
        --   inst.Transform:SetRotation(math.random(360))
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    if loot then
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(onhammered)
    end
    if talker then
        inst:AddComponent("maxwelltalker")
        inst.components.maxwelltalker.speeches = SPEECH
        inst.components.maxwelltalker.cleartrees = true
    end

    inst:AddTag("notarget")
    inst:AddTag("porklandintro")

    inst:AddComponent("lootdropper")

    if loot then
        inst.components.lootdropper:SetLoot(loot)
    end

    return inst
end

return Prefab("porkland_intro", function() return introfn() end, assets, prefabs),
    Prefab("porkland_intro_basket", function() return fn("basket", { "boards" }, nil, "balloon_wreckage", nil, true) end,
        assets, prefabs),
    Prefab("porkland_intro_balloon", function() return fn("balloon", { "fabric" }, nil, nil, nil, true) end, assets,
        prefabs),
    Prefab("porkland_intro_trunk", function() return fn("trunk", { "trinket_8" }, nil, nil, nil, true) end, assets,
        prefabs),
    Prefab("porkland_intro_suitcase", function() return fn("suitcase", { "razor" }, nil, nil, nil, true) end, assets,
        prefabs),
    Prefab("porkland_intro_flags", function() return fn("flags", { "rope" }, true) end, assets, prefabs),
    Prefab("porkland_intro_sandbag", function() return fn("sandbag", { "sand" }) end, assets, prefabs),
    Prefab("porkland_intro_scrape", function() return fn("ground_scrape_decal", nil, true) end, assets, prefabs)
