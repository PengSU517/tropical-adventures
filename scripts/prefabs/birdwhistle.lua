local normalassets = {
    Asset("ANIM", "anim/antler.zip"),
    Asset("ANIM", "anim/swap_antler.zip"),
}

local corruptedassets = {
    Asset("ANIM", "anim/antler_corrupted.zip"),
    Asset("ANIM", "anim/swap_antler_corrupted.zip"),
}

TUNING.BIRDWHISLE_USES = 5

local function OnPlayedNormal(inst, musician)
    local rocmanager = TheWorld.components.rocmanager
    -- print("check111111111111")
    if rocmanager then
        -- print("check222222222222")
        rocmanager:Spawn(musician) --需要传入玩家
    end
    -- if musician then
    --     local a, b, c = musician.Transform:GetWorldPosition()
    --     local casa = GetClosestInstWithTag("interior_center", musician, 40) --判断室内，或者直接判断位置
    --     local nest = GetClosestInstWithTag("roc_nest", musician, 40)
    --     local roc_entity = TheSim:FindFirstEntityWithTag("roc")       ------------------如果想改成boss的话还得改
    --     if (not casa) and (not nest) and (not roc_entity) then
    --         inst:DoTaskInTime(3, function(...)
    --             local vento = SpawnPrefab("roc")
    --             if vento then
    --                 vento.Transform:SetPosition(a + math.random(-10, 10), 0, c + math.random(-10, 10))
    --             end
    --         end)
    --     end
    -- end
end

local function OnPlayedCorrupted(inst, musician)
    musician.SoundEmitter:PlaySound("ancientguardian_rework/tentacle_shadow/voice_appear")
    musician.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_2")

    local rocmanager = TheWorld.components.rocmanager
    if rocmanager then
        rocmanager:Disable()
    end

    inst:Remove()
end



local function NormalFn()
    local inst = CreateEntity()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()


    inst:AddTag("horn")
    inst:AddTag("antler")
    inst:AddTag("new_horn")

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    inst.AnimState:SetBank("antler")
    inst.AnimState:SetBuild("antler")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)
    -- inst.components.floater:UpdateAnimations("idle_water", "idle")
    -- MakeInventoryFloatable(inst, "med", 0.25)


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst:AddComponent("instrument")
    inst.components.instrument.range = 0
    inst.components.instrument:SetOnPlayedFn(OnPlayedNormal)

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.PLAY)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.BIRDWHISLE_USES)
    inst.components.finiteuses:SetUses(TUNING.BIRDWHISLE_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.PLAY, 1)

    MakeHauntableLaunch(inst)

    inst.hornbuild = "swap_antler"
    inst.hornsymbol = "swap_horn"
    inst.playsound = "dontstarve_DLC003/common/crafted/roc_flute"
    return inst
end

local function CorruptedFn()
    local inst = CreateEntity()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()


    inst:AddTag("horn")
    inst:AddTag("antler")
    inst:AddTag("new_horn")

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    inst.AnimState:SetBank("antler")
    inst.AnimState:SetBuild("antler_corrupted")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)
    -- MakeInventoryFloatable(inst, "med", 0.25)


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst.components.inventoryitem:ChangeImageName("antler") --物品栏贴图缺失，物品栏贴图名字

    inst:AddComponent("instrument")
    inst.components.instrument.range = 0
    inst.components.instrument:SetOnPlayedFn(OnPlayedCorrupted)

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.PLAY)


    MakeHauntableLaunch(inst)

    inst.hornbuild = "swap_antler_corrupted"
    inst.hornsymbol = "swap_antler_corrupted"
    inst.playsound = "dontstarve_DLC003/common/crafted/roc_flute"
    return inst
end

return Prefab("common/inventory/antler", NormalFn, normalassets),
    Prefab("common/inventory/antler_corrupted", CorruptedFn, corruptedassets)
