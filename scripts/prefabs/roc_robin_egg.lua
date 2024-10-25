local assets =
{
    Asset("ANIM", "anim/roc_egg.zip"),
}

TUNING.ROBIN_HATCH_TIME = TUNING.TOTAL_DAY_TIME * 1

local prefabs =
{

}

local loot_hot =
{
    "cookedsmallmeat",
}

local loot_cold =
{
    "wetgoop",
}

local function Hatch(inst)
    if not TheWorld.Map:IsLandTileAtPoint(inst.Transform:GetWorldPosition()) then
        return
    end

    if inst.already_hatched == true then --保证函数只执行一次
        return
    end

    inst.already_hatched = true

    inst.components.inventoryitem.canbepickedup = false
    inst.AnimState:PlayAnimation("hatch")

    -- inst:ListenForEvent("animover", inst.Remove)
    -- inst:ListenForEvent("entitysleep", inst.Remove)

    inst:DoTaskInTime(50 / 30, function()
        local stone = SpawnPrefab("ro_bin_gizzard_stone")
        local pt = Point(inst.Transform:GetWorldPosition())
        stone.Transform:SetPosition(pt.x, pt.y, pt.z)

        local down = TheCamera:GetDownVec() --需要更改
        local angle = math.atan2(down.z, down.x) + (math.random() * 60 - 30) * DEGREES
        local speed = 3
        stone.Physics:SetVel(speed * math.cos(angle), GetRandomWithVariance(8, 4), speed * math.sin(angle))

        inst:Remove()
    end)
end

local function CheckHatch(inst)
    if inst.playernear and
        inst.components.hatchable.state == "hatch" and
        not inst:HasTag("INLIMBO")
    --[[and not inst:HasTag("falling")]] --没有throwable组件似乎也不需要这个东西
    then
        Hatch(inst)
    else
        inst.components.hatchable:StartUpdating()
    end
end

local function PlayUncomfySound(inst)
    inst.SoundEmitter:KillSound("uncomfy")
    if inst.components.hatchable.toohot then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hot_steam_LP", "uncomfy")
    elseif inst.components.hatchable.toocold then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_cold_shiver_LP", "uncomfy")
    end
end

local function OnNear(inst)
    inst.playernear = true
    CheckHatch(inst)
end

local function OnFar(inst)
    inst.playernear = false
end

local function OnPutInInventory(inst)
    -- inst.components.hatchable:StopUpdating()--在身上会回退孵化进度
    inst.SoundEmitter:KillSound("uncomfy")

    if inst.components.hatchable.state == "unhatched" then
        inst.components.hatchable:OnState("uncomfy")
    end
end

local function GetStatus(inst)
    if inst.components.hatchable then
        local state = inst.components.hatchable.state
        if state == "uncomfy" then
            if inst.components.hatchable.toohot then
                return "HOT"
            elseif inst.components.hatchable.toocold then
                return "COLD"
            end
        end
    end
end

local function OnHatchState(inst, state)
    --print("tallbirdegg - OnHatchState", state)

    inst.SoundEmitter:KillSound("uncomfy")

    if state == "uncomfy" then
        if inst.components.hatchable.toohot then
            inst.components.inventoryitem:ChangeImageName("roc_egg_hot")
            inst.AnimState:PlayAnimation("idle_hot_smoulder", true)
            -- inst.components.floater:UpdateAnimations("idle_water", "idle_hot_smoulder")
        elseif inst.components.hatchable.toocold then
            inst.AnimState:PlayAnimation("idle_cold_frost", true)
            inst.components.inventoryitem:ChangeImageName("roc_egg_cold")
            -- inst.components.floater:UpdateAnimations("idle_water", "idle_cold_frost")
        end
        PlayUncomfySound(inst)
    elseif state == "comfy" then
        inst.AnimState:PlayAnimation("idle", true)
        inst.components.inventoryitem:ChangeImageName("roc_egg")
        -- inst.components.floater:UpdateAnimations("idle_water", "idle")
    elseif state == "hatch" then
        inst.components.inventoryitem:ChangeImageName("roc_egg")
        CheckHatch(inst)
    end
end

local function OnDropped(inst)
    -- inst.components.hatchable:StartUpdating()
    CheckHatch(inst)
    if inst.components.hatchable.state ~= "unhatched" then
        PlayUncomfySound(inst)
    end
    -- CheckHatch(inst)
    -- PlayUncomfySound(inst)
    OnHatchState(inst, inst.components.hatchable.state)
end




local function OnLoadPostPass(inst)
    --V2C: in case of load order of hatchable and inventoryitem components
    if inst.components.inventoryitem:IsHeld() then
        OnPutInInventory(inst)
    end
end

local function OnUpdateFn(inst, dt)
    local self = inst.components.hatchable

    if self.state == "dead" then --一个必要的调整
        self.discomfort = self.hatchfailtime
        self:StartUpdating()
        self:OnState("uncomfy")
    end

    if inst.components.inventoryitem:IsHeld() then --这个就看情况吧
        self:OnState("uncomfy")
    end

    if self.state == "uncomfy" then
        self.progress = math.max(self.progress - (3 * dt), 0)
    else
        self.discomfort = 0
    end
    local percent = self.progress / self.hatchtime




    local scale = 1 + (1.5 * percent)
    inst.Transform:SetScale(scale, scale, scale)
end

local function commonfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("roc_egg")
    inst.AnimState:SetBank("roc_egg")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("ro_bin_egg")
    -- inst:AddTag("aquatic")


    MakeInventoryFloatable(inst, "small", 0.15)
    -- AddDefaultRippleSymbols(inst, true, false) --怎么隐藏water_shadow动画呢
    --    MakeInventoryFloatable(inst, "idle_water", "idle")
    -- inst.components.floater:UpdateAnimations("idle_water", "idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("roc_egg")
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)

    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)

    -- inst:AddTag("nonpotatable")
    inst:AddTag("irreplaceable")
    -- inst:AddTag("dropontravel")



    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 6)
    inst.components.playerprox:SetOnPlayerNear(OnNear)
    inst.components.playerprox:SetOnPlayerFar(OnFar)

    inst:AddComponent("hatchable")
    inst.components.hatchable:SetOnState(OnHatchState)
    inst.components.hatchable:SetUpdateFn(OnUpdateFn)
    inst.components.hatchable:SetCrackTime(10)
    inst.components.hatchable:SetHatchTime(TUNING.ROBIN_HATCH_TIME)
    inst.components.hatchable:SetHatchFailTime(60)
    inst.components.hatchable:SetHeaterPrefs(false, nil, true)
    inst.components.hatchable:StartUpdating()

    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)

    inst.components.inspectable.getstatus = GetStatus


    inst.hatch = Hatch
    inst.OnLoadPostPass = OnLoadPostPass

    inst.playernear = false
    -- inst.components.floater:SetVerticalOffset(0.1)
    -- inst.components.floater:SetScale(0.75)

    return inst
end

return Prefab("common/inventory/roc_robin_egg", commonfn, assets, prefabs)
