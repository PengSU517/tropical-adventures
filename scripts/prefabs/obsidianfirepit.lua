require "prefabutil"
--itens valem 3x mais seu valor de combustao e capacidade dobrada de armazenamento
local assets =
{
    Asset("ANIM", "anim/firepit.zip"),
    Asset("ANIM", "anim/firepit_obsidian.zip"),
}

local prefabs =
{
    "campfirefire",
    "collapse_small",
    "ash",
}

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local x, y, z = inst.Transform:GetWorldPosition()
    SpawnPrefab("ash").Transform:SetPosition(x, y, z)
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(x, y, z)
    fx:SetMaterial("stone")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")
end

local function onextinguish(inst)
    if inst.components.fueled ~= nil then
        inst.components.fueled:InitializeFuelLevel(0)
    end
end

local function ontakefuel(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
    local alagado = GetClosestInstWithTag("mare", inst, 10)
    if alagado then
        inst.components.burnable:Extinguish()
    end
end

local function updatefuelrate(inst)
    inst.components.fueled.rate = TheWorld.state.israining and
        1 + TUNING.FIREPIT_RAIN_RATE * TheWorld.state.precipitationrate or 1
end

local function onupdatefueled(inst)
    if inst.components.burnable ~= nil and inst.components.fueled ~= nil then
        updatefuelrate(inst)
        inst.components.burnable:SetFXLevel(inst.components.fueled:GetCurrentSection(),
            inst.components.fueled:GetSectionPercent())
    end
end

local function onfuelchange(newsection, oldsection, inst)
    if newsection <= 0 then
        inst.components.burnable:Extinguish()
    else
        if not inst.components.burnable:IsBurning() then
            updatefuelrate(inst)
            inst.components.burnable:Ignite()
        end
        inst.components.burnable:SetFXLevel(newsection, inst.components.fueled:GetSectionPercent())
    end
end

local SECTION_STATUS =
{
    [0] = "OUT",
    [1] = "EMBERS",
    [2] = "LOW",
    [3] = "NORMAL",
    [4] = "HIGH",
}
local function getstatus(inst)
    return SECTION_STATUS[inst.components.fueled:GetCurrentSection()]
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
    local alagado = GetClosestInstWithTag("mare", inst, 10)
    if alagado then
        inst.components.burnable:Extinguish()
    end
end

local function OnHaunt(inst, haunter)
    if math.random() <= TUNING.HAUNT_CHANCE_RARE and
        inst.components.fueled ~= nil and
        not inst.components.fueled:IsEmpty() then
        inst.components.fueled:DoDelta(TUNING.MED_FUEL)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
        return true
        --#HAUNTFIX
        --elseif math.random() <= TUNING.HAUNT_CHANCE_HALF and
        --inst.components.workable ~= nil and
        --inst.components.workable:CanBeWorked() then
        --inst.components.workable:WorkedBy(haunter, 1)
        --inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
        --return true
    end
    return false
end

local function OnInit(inst)
    if inst.components.burnable ~= nil then
        inst.components.burnable:FixFX()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .3)

    inst.MiniMapEntity:SetIcon("firepit.tex")
    inst.MiniMapEntity:SetPriority(1)

    inst.AnimState:SetBank("firepit_obsidian")
    inst.AnimState:SetBuild("firepit_obsidian")
    inst.AnimState:PlayAnimation("idle", false)

    inst:AddTag("campfire")
    inst:AddTag("structure")
    inst:AddTag("wildfireprotected")

    --cooker (from cooker component) added to pristine state for optimization
    inst:AddTag("cooker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -----------------------
    inst:AddComponent("burnable")
    --    inst.components.burnable:SetFXLevel(2)
    inst.components.burnable:AddBurnFX("obsidianfirefire", Vector3(0, 0.55, 0))
    inst:ListenForEvent("onextinguish", onextinguish)

    -------------------------
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    -------------------------
    inst:AddComponent("cooker")
    -------------------------
    inst:AddComponent("fueled")
    inst.components.fueled.maxfuel = TUNING.FIREPIT_FUEL_MAX * 2
    inst.components.fueled.accepting = true

    inst.components.fueled:SetSections(4)
    inst.components.fueled.bonusmult = TUNING.FIREPIT_BONUS_MULT * 3
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
    inst.components.fueled:SetUpdateFn(onupdatefueled)
    inst.components.fueled:SetSectionCallback(onfuelchange)
    inst.components.fueled:InitializeFuelLevel(TUNING.FIREPIT_FUEL_START)

    -----------------------------

    inst:AddComponent("hauntable")
    inst.components.hauntable.cooldown = TUNING.HAUNT_COOLDOWN_HUGE
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    -----------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:ListenForEvent("onbuilt", onbuilt)

    inst:DoTaskInTime(0, OnInit)

    return inst
end

return Prefab("obsidianfirepit", fn, assets, prefabs),
    MakePlacer("obsidianfirepit_placer", "firepit", "firepit", "preview")
