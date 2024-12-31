local assets =
{
    Asset("ANIM", "anim/jellyfish.zip"),
    Asset("ANIM", "anim/meat_rack_food_tro.zip"),
    Asset("INV_IMAGE", "jellyJerky"),
}

local prefabs =
{
    "jellyfish_planted",
}

local JELLYFISH_DAMAGE = 0
local total_day_time = 480

PERISH_ONE_DAY = total_day_time

local function CalcNewSize()
	return math.random()
end

local function playshockanim(inst)
    if inst:HasTag("aquatic") then
        inst.AnimState:PlayAnimation("idle_water_shock")
        inst.AnimState:PushAnimation("idle_water", true)
        inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/jellyfish/electric_water")
    else
        inst.AnimState:PlayAnimation("idle_ground_shock")
        inst.AnimState:PushAnimation("idle_ground", true)
        inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/jellyfish/electric_land")
    end
    --[[local pclose = GetClosestInstWithTag("player", inst, 2)
    if pclose and pclose.components.health then
        pclose.components.health:DoDelta(-5)
        pclose.sg:GoToState("electrocute")
    end]]
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
            local replacement = SpawnPrefab("jellyfish_planted")
            replacement.Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst:Remove()
        else
            local replacement = SpawnPrefab("jellyfish_dead")
            replacement.Transform:SetPosition(inst.Transform:GetWorldPosition())
            replacement.AnimState:PlayAnimation("stunned_loop", true)
            replacement:DoTaskInTime(2.5, playDeadAnimation)
            replacement.shocktask = replacement:DoPeriodicTask(math.random() * 10 + 5, playshockanim)
            replacement:AddTag("stinger")
            inst:Remove()
    end
end

local function onpickup(inst, pickupguy)
    if inst:HasTag("stinger") and pickupguy.components.combat and pickupguy.components.inventory then
        if not pickupguy.components.inventory:IsInsulated() then
            pickupguy.components.health:DoDelta(-JELLYFISH_DAMAGE)
            if pickupguy:HasTag("player") then
                pickupguy.sg:GoToState("electrocute")
            end
        end
        inst:RemoveTag("stinger")
    end

    if inst.shocktask then
        inst.shocktask:Cancel()
        inst.shocktask = nil
    end
end

local function defaultfn(sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetRayTestOnBB(true);
    inst.AnimState:SetBank("jellyfish")
    inst.AnimState:SetBuild("jellyfish")
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
    inst.components.inventoryitem:SetOnPickupFn(onpickup)

	inst:AddComponent("edible")
    inst.components.edible.foodtype = nil

    inst:ListenForEvent("on_landed", ondropped)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(PERISH_ONE_DAY * 1.5)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "jellyfish_dead"

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
    --inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES.SEAFOOD

    inst:AddComponent("cookable")
    inst.components.cookable.product = "jellyfish_cooked"

    inst:AddComponent("health")
    inst.components.health.murdersound = "dontstarve_DLC002/creatures/jellyfish/death_murder"

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "jellyfish_dead" }) --Replace with dead jelly

	--[[inst:AddComponent("weighable")
	inst.components.weighable.type = TROPHYSCALE_TYPES.FISH
	inst.components.weighable:Initialize(TUNING.JELLYFISH_WEIGHTS.min, TUNING.JELLYFISH_WEIGHTS.max)
	inst.components.weighable:SetWeight(Lerp(TUNING.JELLYFISH_WEIGHTS.min, TUNING.JELLYFISH_WEIGHTS.max, CalcNewSize()))]]

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function deadfn(sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetRayTestOnBB(true);
    inst.AnimState:SetBank("jellyfish")
    inst.AnimState:SetBuild("jellyfish")
    inst.AnimState:PlayAnimation("idle_ground", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnPickupFn(onpickup)
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("tradable")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MEAT

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("cookable")
    inst.components.cookable.product = "jellyfish_cooked"

    inst:AddComponent("dryable")
    inst.components.dryable:SetProduct("jellyjerky")
    inst.components.dryable:SetDryTime(TUNING.DRY_FAST)

    MakeHauntableLaunchAndPerish(inst)

    return inst
end


local function cookedfn(sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetRayTestOnBB(true);
    inst.AnimState:SetBank("jellyfish")
    inst.AnimState:SetBuild("jellyfish")
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

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.foodstate = "COOKED"
    inst.components.edible.hungervalue = TUNING.CALORIES_MEDSMALL
    inst.components.edible.sanityvalue = 0 --TUNING.SANITY_SMALL

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function driedfn(sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetRayTestOnBB(true);
    inst.AnimState:SetBank("meat_rack_food")
    inst.AnimState:SetBuild("meat_rack_food_tro")
    inst.AnimState:PlayAnimation("idle_dried_jellyjerky", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("tradable")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.foodstate = "DRIED"
    inst.components.edible.hungervalue = TUNING.CALORIES_MED
    inst.components.edible.sanityvalue = TUNING.SANITY_MEDLARGE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("jellyfish", defaultfn, assets),
    Prefab("jellyfish_dead", deadfn, assets),
    Prefab("jellyfish_cooked", cookedfn, assets),
    Prefab("jellyjerky", driedfn, assets)
