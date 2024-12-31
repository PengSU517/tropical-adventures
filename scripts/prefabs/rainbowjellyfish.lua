local assets =
{
    Asset("ANIM", "anim/rainbowjellyfish.zip"),
    Asset("ANIM", "anim/meat_rack_food_tro.zip"),
    --Asset("INV_IMAGE", "rainbowJellyJerky"),
}

local prefabs =
{
    "rainbowjellyfish_planted",
}

local RAINBOWJELLYFISH_LIGHT_RADIUS = 3
local RAINBOWJELLYFISH_LIGHT_DURATION = 90

local function CalcNewSize()
	return math.random()
end

local function playDeadAnimation(inst)
    inst.AnimState:PlayAnimation("death_ground", true)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/jellyfish/death_murder")
    inst.AnimState:PushAnimation("idle_ground", true)
end

local function ondropped(inst)
    local map = TheWorld.Map
    local x, y, z = inst.Transform:GetWorldPosition()
    local ground = map:GetTile(map:GetTileCoordsAtPoint(x, y, z))

    if TileGroupManager:IsOceanTile(ground) then
        --if not inst.replica.inventoryitem:IsHeld() then
            local replacement = SpawnPrefab("rainbowjellyfish_planted")
            replacement.Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst:Remove()
        else
            local replacement = SpawnPrefab("rainbowjellyfish_dead")
            replacement.Transform:SetPosition(inst.Transform:GetWorldPosition())
            replacement.AnimState:PlayAnimation("stunned_loop", true)
            replacement:DoTaskInTime(2.5, playDeadAnimation)
            inst:Remove()
    end
end

local function create_light(eater, lightprefab)
    if eater.wormlight ~= nil then
        if eater.wormlight.prefab == lightprefab then
            eater.wormlight.components.spell.lifetime = 0
            eater.wormlight.components.spell:ResumeSpell()
            return
        else
            eater.wormlight.components.spell:OnFinish()
        end
    end

    local light = SpawnPrefab(lightprefab)
    light.components.spell:SetTarget(eater)
    if light:IsValid() then
        if light.components.spell.target == nil then
            light:Remove()
        else
            light.components.spell:StartSpell()
        end
    end
end

--[[ LIGHT EMITTING BENEFITS ]] --
local function item_oneaten(inst, eater)
    create_light(eater, "wormlight_light_lesser")
end

local function swapColor(inst, light)
    local timeleft = inst.components.spell.duration - inst.components.spell.lifetime
    local percent = timeleft / inst.components.spell.duration
    local var = inst.components.spell.variables
    if inst.ispink then
        inst.ispink = false
        inst.isgreen = true
        inst.components.lighttweener:StartTween(light, Lerp(0, var.radius, percent), nil, nil,
            { 0 / 255, 180 / 255, 255 /
            255 }, 4, swapColor)
    elseif inst.isgreen then
        inst.isgreen = false
        inst.components.lighttweener:StartTween(light, Lerp(0, var.radius, percent), nil, nil,
            { 240 / 255, 230 / 255, 100 / 255 }, 4, swapColor)
    else
        inst.ispink = true
        inst.components.lighttweener:StartTween(light, Lerp(0, var.radius, percent), nil, nil,
            { 251 / 255, 30 / 255, 30 /
            255 }, 4, swapColor)
    end
end

local function light_resume(inst, time)
    local percent = time / inst.components.spell.duration
    local var = inst.components.spell.variables
    if percent and time > 0 then
        --Snap light to value
        local spell = inst.components.spell
        inst.components.lighttweener:StartTween(inst.light, Lerp(0, var.radius, percent), 0.8, 0.5,
            { 251 / 255, 30 / 255, 30 / 255 }, 0)
        inst.ispink = true
        inst.components.lighttweener:StartTween(inst.light, nil, nil, nil, { 0 / 255, 180 / 255, 255 / 255 }, 4,
            swapColor)
    end
end

local function light_spellfn(inst, target, variables)
    if target then
        inst.Transform:SetPosition(target:GetPosition():Get())
    end
end

local function light_start(inst)
    local spell = inst.components.spell
    inst.components.lighttweener:StartTween(inst.light, spell.variables.radius, 0.8, 0.5,
        { 251 / 255, 30 / 255, 30 / 255 },
        0)
    inst.ispink = true
    inst.components.lighttweener:StartTween(inst.light, nil, nil, nil, { 0 / 255, 180 / 255, 255 / 255 }, 4, swapColor)
end

local function light_ontarget(inst, target)
    if not target then return end
    target.rainbowjellylight = inst
    target:AddTag(inst.components.spell.spellname)
    target.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
end

local function light_onfinish(inst)
    if not inst.components.spell.target then
        return
    end
    inst.components.spell.target.rainbowjellylight = nil
    inst.components.spell.target.AnimState:ClearBloomEffectHandle()
end

local function lightfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()

    inst:AddComponent("lighttweener")
    inst.light = inst.entity:AddLight()
    inst.light:Enable(true)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "rainbowjellylight"
    inst.components.spell:SetVariables({ radius = RAINBOWJELLYFISH_LIGHT_RADIUS })
    inst.components.spell.duration = RAINBOWJELLYFISH_LIGHT_DURATION
    inst.components.spell.ontargetfn = light_ontarget
    inst.components.spell.onstartfn = light_start
    inst.components.spell.onfinishfn = light_onfinish
    inst.components.spell.fn = light_spellfn
    inst.components.spell.resumefn = light_resume
    inst.components.spell.removeonfinish = true

    return inst
end

--[[ end of LIGHT EMITTING BENEFITS ]] --

local function defaultfn(sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.Transform:SetScale(0.8, 0.8, 0.8)

    inst.AnimState:SetRayTestOnBB(true);
    inst.AnimState:SetBank("rainbowjellyfish")
    inst.AnimState:SetBuild("rainbowjellyfish")
    inst.AnimState:PlayAnimation("idle_ground", true)

    --inst.AnimState:SetLayer(LAYER_BACKGROUND)
    --inst.AnimState:SetSortOrder(3)

    inst:AddTag("show_spoilage")
    inst:AddTag("jellyfish")
    inst:AddTag("fishmeat")
    inst:AddTag("aquatic")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)

	inst:AddComponent("edible")
    inst.components.edible.foodtype = nil

    inst:ListenForEvent("on_landed", ondropped)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY * 1.5)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "rainbowjellyfish_dead"

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
    --    inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD

    inst:AddComponent("cookable")
    inst.components.cookable.product = "rainbowjellyfish_cooked"

    inst:AddComponent("health")
    inst.components.health.murdersound = "dontstarve_DLC002/creatures/jellyfish/death_murder"

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "rainbowjellyfish_dead" })

	--[[inst:AddComponent("weighable")
	inst.components.weighable.type = TROPHYSCALE_TYPES.FISH
	inst.components.weighable:Initialize(TUNING.RAINBOWJELLYFISH_WEIGHTS.min, TUNING.RAINBOWJELLYFISH_WEIGHTS.max)
	inst.components.weighable:SetWeight(Lerp(TUNING.RAINBOWJELLYFISH_WEIGHTS.min, TUNING.RAINBOWJELLYFISH_WEIGHTS.max, CalcNewSize()))]]

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function deadfn(sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.Transform:SetScale(0.7, 0.7, 0.7)

    inst.AnimState:SetRayTestOnBB(true);
    inst.AnimState:SetBank("rainbowjellyfish")
    inst.AnimState:SetBuild("rainbowjellyfish")
    inst.AnimState:PlayAnimation("idle_ground", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
    --    inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible:SetOnEatenFn(item_oneaten)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("cookable")
    inst.components.cookable.product = "rainbowjellyfish_cooked"

    inst:AddComponent("dryable")
    inst.components.dryable:SetProduct("jellyjerky")
    inst.components.dryable:SetDryTime(TUNING.DRY_FAST)

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function cookedfn(sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.Transform:SetScale(0.8, 0.8, 0.8)

    inst.AnimState:SetRayTestOnBB(true);
    inst.AnimState:SetBank("rainbowjellyfish")
    inst.AnimState:SetBuild("rainbowjellyfish")
    inst.AnimState:PlayAnimation("cooked", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
    --    inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.foodstate = "COOKED"
    inst.components.edible.hungervalue = TUNING.CALORIES_MEDSMALL
    inst.components.edible.sanityvalue = 0

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("rainbowjellyfish", defaultfn, assets, prefabs),
    Prefab("rainbowjellyfish_dead", deadfn, assets),
    Prefab("rainbowjellyfish_cooked", cookedfn, assets),
    Prefab("rainbowjellylight", lightfn, assets)
