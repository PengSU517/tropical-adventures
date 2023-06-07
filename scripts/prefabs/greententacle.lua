local assets =
{
    Asset("ANIM", "anim/greentacle.zip"),
}

local prefabs =
{
    "monstermeat",
    "green_scale",
}

SetSharedLootTable( 'greententacle',
{
    {'monstermeat',   1.0},
    {'monstermeat',   1.0},
    {'snakeskin', 0.5},
    {'tentaclespots', 0.05},
})

local function retargetfn(inst)
    return FindEntity(
        inst,
        20,
        function(guy) 
            return guy.prefab ~= inst.prefab
                and guy.entity:IsVisible()
                and not guy.components.health:IsDead()
                and (guy.components.combat.target == inst or
                    guy:HasTag("character") or
                    guy:HasTag("monster") or
                    guy:HasTag("animal"))
        end,
        { "_combat", "_health" },
        { "prey" })
end

local function shouldKeepTarget(inst, target)
    return target ~= nil
        and target:IsValid()
        and target.entity:IsVisible()
        and target.components.health ~= nil
        and not target.components.health:IsDead()
        and target:IsNear(inst, 20)
end

local function OnAttacked(inst, data)
    if data.attacker == nil then
        return
    end

    local current_target = inst.components.combat.target

    if current_target == nil then
        --Don't want to handle initiating attacks here;
        --We only want to handle switching targets.
        return
    elseif current_target == data.attacker then
        --Already targeting our attacker, just update the time
        inst._last_attacker = current_target
        inst._last_attacked_time = GetTime()
        return
    end

    local time = GetTime()
    if inst._last_attacker == current_target and
        inst._last_attacked_time + TUNING.TENTACLE_ATTACK_AGGRO_TIMEOUT >= time then
        --Our target attacked us recently, stay on it!
        return
    end

    --Switch to new target
    inst.components.combat:SetTarget(data.attacker)
    inst._last_attacker = data.attacker
    inst._last_attacked_time = time
end

local function MakeWeapon(inst)
    if inst.components.inventory ~= nil then
        local weapon = CreateEntity()
        weapon.entity:AddTransform()
        MakeInventoryPhysics(weapon)
        weapon:AddComponent("weapon")
        weapon.components.weapon:SetDamage(40)
        weapon.components.weapon:SetRange(inst.distAttackRange, inst.distAttackRange + 4)
        weapon.components.weapon:SetProjectile("tentacle_attack_spike")
        weapon:AddComponent("inventoryitem")
        weapon.persists = false
        weapon.components.inventoryitem:SetOnDroppedFn(weapon.Remove)
        weapon:AddComponent("equippable")
        inst.weapon = weapon
        inst.components.inventory:Equip(inst.weapon)
        inst.components.inventory:Unequip(EQUIPSLOTS.HANDS)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddPhysics()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Physics:SetCylinder(0.25, 2)

    inst.AnimState:SetBank("tentacle")
    inst.AnimState:SetBuild("gretacle")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("monster")    
    inst:AddTag("hostile")
    inst:AddTag("wet")
    inst:AddTag("WORM_DANGER")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst._last_attacker = nil
    inst._last_attacked_time = nil

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(700)

    inst:AddComponent("combat")
    inst.components.combat:SetRange(4)
    inst.components.combat:SetDefaultDamage(37)
    inst.components.combat:SetAttackPeriod(1.8)
    inst.components.combat:SetRetargetFunction(GetRandomWithVariance(2, 0.5), retargetfn)
    inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)
    inst.distAttackRange = 20

    MakeLargeFreezableCharacter(inst)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('greententacle')

    inst:AddComponent("inventory")
    MakeWeapon(inst)

    inst:SetStateGraph("SGgreententacle")

    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

return Prefab("greententacle", fn, assets, prefabs)