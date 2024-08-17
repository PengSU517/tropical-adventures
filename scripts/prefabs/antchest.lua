local assets = { Asset("ANIM", "anim/ant_chest.zip") }

local prefabs = { "collapse_small", "lavaarena_creature_teleport_small_fx" }

local loot = { "chitin", "chitin", "chitin", "beeswax", "honey", "honey", "rocks" -- "flint",
}

local function UpdateNameFn(inst) -- 升级后更新显示名
    if inst.components.upgradeable.upgradetype == nil then
        return subfmt(STRINGS.NAMES.UPDATEDCHEST, { container = STRINGS.NAMES[inst.prefab:upper()] })
    end
end

local function onopen(inst)
    inst.AnimState:PushAnimation("open", false)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/honey_chest/open")
end

local function onclose(inst)
    inst.AnimState:PlayAnimation("close", true)
    inst.AnimState:PushAnimation("closed", true)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/honey_chest/close")
end

local function onhammered(inst, worker) -- 常规破坏后
    inst.components.lootdropper:DropLoot()
    if inst.components.container then
        inst.components.container:DropEverything()
    end
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function onhit(inst, worker) -- 常规受击
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("closed", true)
    inst.SoundEmitter:PlaySound("waterlogged1/common/use_figjam")
    if inst.components.container then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
end

local function converttocollapsed(inst, droploot) -- 升级后转化废墟
    local x, y, z = inst.Transform:GetWorldPosition()
    if droploot then
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(x, y, z)
        fx:SetMaterial("wood")
        inst.components.lootdropper.min_speed = 2.25
        inst.components.lootdropper.max_speed = 2.75
        inst.components.lootdropper:DropLoot()
        inst.components.lootdropper.min_speed = nil
        inst.components.lootdropper.max_speed = nil
    end

    inst.components.container:Close()
    inst.components.workable:SetWorkLeft(2)

    local pile = SpawnPrefab("collapsed_honeychest")
    pile.Transform:SetPosition(x, y, z)
end

local function Upgrade_onhit(inst, worker) -- 升级后受击
    if inst.components.container then
        inst.components.container:DropEverything(nil, true)
        inst.components.container:Close()
    end
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("closed", false)
end

local function shouldcollapse(inst) -- 可转化为废墟
    if inst.components.container and inst.components.container.infinitestacksize then
        --NOTE: should already have called DropEverything(nil, true) (worked or burnt or deconstructed)
        --      so everything remaining counts as an "overstack"
        local overstacks = 0
        for k, v in pairs(inst.components.container.slots) do
            local stackable = v.components.stackable
            if stackable then
                overstacks = overstacks +
                    math.ceil(stackable:StackSize() / (stackable.originalmaxsize or stackable.maxsize))
                if overstacks >= TUNING.COLLAPSED_CHEST_EXCESS_STACKS_THRESHOLD then
                    return true
                end
            end
        end
    end
    return false
end

local function Upgrade_onhammered(inst, worker) -- 升级后被破坏
    if shouldcollapse(inst) then
        if TheWorld.Map:IsPassableAtPoint(inst.Transform:GetWorldPosition()) then
            inst.components.container:DropEverythingUpToMaxStacks(TUNING.COLLAPSED_CHEST_MAX_EXCESS_STACKS_DROPS)
            if not inst.components.container:IsEmpty() then
                converttocollapsed(inst, true, false)
                return
            end
        else
            --sunk, drops more, but will lose the remainder
            inst.components.lootdropper:DropLoot()
            inst.components.container:DropEverythingUpToMaxStacks(TUNING.COLLAPSED_CHEST_EXCESS_STACKS_THRESHOLD)
            local fx = SpawnPrefab("collapse_small")
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
            fx:SetMaterial("wood")
            inst:Remove()
            return
        end
    end
    onhammered(inst, worker)
end

local function Upgrade_onrestoredfromcollapsed(inst) -- 从废墟中修复
    -- inst.AnimState:PlayAnimation("rebuild")
    inst.AnimState:PushAnimation("closed", false)
    -- if inst.skin_place_sound then
    -- 	inst.SoundEmitter:PlaySound(inst.skin_place_sound)
    -- else
    -- 	inst.SoundEmitter:PlaySound(inst.sounds.built)
    -- end
end

local function OnUpgrade(inst, performer, upgraded_from_item)
    local numupgrades = inst.components.upgradeable.numupgrades
    if numupgrades == 1 then
        if inst.components.container ~= nil then
            inst.components.container:Close()
            inst.components.container:EnableInfiniteStackSize(true)
        end
        -- if upgraded_from_item then
        -- end
    end
    inst.components.upgradeable.upgradetype = nil
    inst.displaynamefn = UpdateNameFn
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetLoot({ "alterguardianhatshard" })
    end
    inst.components.workable:SetOnWorkCallback(Upgrade_onhit)
    inst.components.workable:SetOnFinishCallback(Upgrade_onhammered)
    inst:ListenForEvent("restoredfromcollapsed", Upgrade_onrestoredfromcollapsed)
end

local function onsave(inst, data)
    if inst.IsNatural then
        data.IsNatural = inst.IsNatural
    end
end

local function onload(inst, data)
    if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
        OnUpgrade(inst)
    end
    if data and data.IsNatural then
        inst.IsNatural = data.IsNatural
    end
    inst.components.container:WidgetSetup(inst.IsNatural == false and "honeychest" or "antchest")
end

local function funcLoadHoneyFirstTime(inst) -- 野生初次加载时生成蜂蜜
    if inst.IsNatural == nil then
        if inst.components.container then
            for i = 1, 9 do
                inst.components.container:GiveItem(SpawnPrefab("honey"), i)
            end
        end
    end
    inst.IsNatural = true
end

local function NaturalPostInit(inst) -- 野生后装配
    if inst.IsNatural == nil or inst.IsNatural == true then
        inst.components.container:WidgetSetup("antchest")
        inst:DoTaskInTime(0, funcLoadHoneyFirstTime)
    end
end

local function ChangeAntChestSymbol(inst) -- 切换通道
    local container = inst.components.container
    local buildIdx = 0
    local itemPrefab = { "nectar_pod", "pollen_item", "honey", "royal_jelly" } -- Priority: Low -> High
    for _, item in ipairs(container:GetAllItems()) do
        for idx, prf in ipairs(itemPrefab) do
            if item.prefab == prf then
                buildIdx = buildIdx > idx and buildIdx or idx
                break
            end
        end
    end
    if buildIdx > 0 then -- 只需要更换通道symbol
        inst.AnimState:OverrideSymbol("box01", "ant_chest", "box_" .. itemPrefab[buildIdx])
    else
        inst.AnimState:ClearOverrideSymbol("box01")
    end
    -- inst.MiniMapEntity:SetIcon(prefix .. (buildIdx > 0 and "_" .. buildName[buildIdx] or "") .. ".png") -- "antchest_honey.png" etc.
end

local function stopConvert(inst, owner)
    if owner == nil or owner.prefab ~= "antchest" or owner.prefab ~= "honeychest" then
        if inst._convertTask_tro then
            inst._convertTask_tro:Cancel()
        end
        inst:RemoveEventCallback("onputininventory", stopConvert)
        inst:RemoveEventCallback("ondropped", stopConvert)
    end
end

local function itemget(inst, data) -- 转化花粉花蜜
    ChangeAntChestSymbol(inst)
    local convertInfo = { nectar_pod = { time = 48, prod = "honey" }, pollen_item = { time = 48 * 3, prod = "royal_jelly" } }
    if convertInfo[data.item.prefab] then
        data.item:ListenForEvent("onputininventory", stopConvert)
        data.item:ListenForEvent("ondropped", stopConvert)
        if data.item._convertTask_tro then
            data.item._convertTask_tro:Cancel()
        end
        data.item._convertTask_tro = data.item:DoTaskInTime(convertInfo[data.item.prefab].time, function()
            if data.item.components.inventoryitem:GetGrandOwner() == inst then
                local size = data.item.components.stackable and data.item.components.stackable:StackSize() or 1
                data.item:Remove()
                local prod = SpawnPrefab(convertInfo[data.item.prefab].prod)
                prod.components.stackable:SetStackSize(size)
                inst.components.container:GiveItem(prod)
                inst.AnimState:PlayAnimation("close")
            end
        end)
    end
end

local function hide_ground(inst) -- 隐藏建造的岩石通道
    inst.AnimState:HideSymbol("ground01")
end

local function ArtificialPostInit(inst) -- 建造后装配
    if inst.IsNatural == nil or inst.IsNatural == false then
        inst.IsNatural = false
        inst.AnimState:PlayAnimation("close")
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/cork_chest/place")

        inst.components.container:WidgetSetup("honeychest")

        hide_ground(inst)

        inst:AddComponent("upgradeable")
        inst.components.upgradeable.upgradetype = UPGRADETYPES.CHEST
        inst.components.upgradeable:SetOnUpgradeFn(OnUpgrade)
    end
end

local function Common(name)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon(name .. ".png")

    inst.AnimState:SetBank("ant_chest")
    inst.AnimState:SetBuild("ant_chest")
    inst.AnimState:PlayAnimation("closed", true)

    inst:AddTag("structure")
    inst:AddTag("chest")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("container")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(0)

    MakeSnowCovered(inst, .01)

    MakeSmallPropagator(inst)

    inst:ListenForEvent("itemget", itemget)
    inst:ListenForEvent("itemlose", ChangeAntChestSymbol)
    inst:ListenForEvent("onbuilt", ArtificialPostInit)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

local function fn()
    local inst = Common("ant_chest")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lootdropper:SetLoot(loot)
    NaturalPostInit(inst)

    return inst
end

local function fn1()
    local inst = Common("honey_chest")

    if not TheWorld.ismastersim then
        return inst
    end

    ArtificialPostInit(inst)

    return inst
end

return Prefab("antchest", fn, assets), Prefab("honeychest", fn1, assets),
    MakePlacer("common/honeychest_placer", "ant_chest", "ant_chest", "closed", nil, nil, nil, nil, nil, nil, hide_ground)
