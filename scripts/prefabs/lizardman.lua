local assets =
{
    Asset("ANIM", "anim/lizardman.zip"),
    Asset("ANIM", "anim/lizardman_anims.zip"),
}

local assets_fx =
{
    Asset("ANIM", "anim/gooball_fx.zip"),
}

local prefabs =
{
    "green_scale"
}

SetSharedLootTable( "lizardman",
{
    {"meat", 1.0},
    {"meat", 1.0},
    {"snakeskin", 0.5},

})

local frenzyDuration = 15

local function OnNewTarget(inst, data)
	if inst.components.sleeper:IsAsleep() then
		inst.components.sleeper:WakeUp()
	end
end

local function Retarget(inst)
	local dist = 12
    local notags = {"FX", "NOCLICK", "INLIMBO", "lizardman"}
    local reqtags = nil
    if not inst.isFrenzy then
        reqtags = {"monster"}
        notags = {"FX", "NOCLICK", "INLIMBO", "lizardman", "structure", "player"}
    --else
        --notags = {"FX", "NOCLICK", "INLIMBO", "lizardman"}
    end
	return FindEntity(inst, dist, function(guy)
        return inst.components.combat:CanTarget(guy)
	end, reqtags, notags)
end

local function KeepTarget(inst, target)
	return inst.components.combat:CanTarget(target) and inst:GetDistanceSqToInst(target) <= (20 * 20)
end

local function OnAttacked(inst, data)
    local function IsArmored()
        return data.attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) 
            and data.attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) 
    end

    if data.attacker == nil 
        or data.attacker:HasTag("lizardman") 
        or data.attacker.components.combat == nil 
        or data.attacker.components.health == nil 
    then 
        return 
    end

    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 20, 
        function(dude) 
            return dude:HasTag("lizardman") 
                and not dude.components.health:IsDead() 
        end, 5)

    if data.attacker:IsNear(inst, 3) then
        local dmg = 5
        if data.attacker.components.inventory == nil then
            data.attacker.components.health:DoDelta(-dmg, false, nil, false, inst, false)
            data.attacker:PushEvent("thorns")
        elseif not IsArmored() then
            data.attacker.components.health:DoDelta(-dmg, false, nil, false, inst, false)
            data.attacker:PushEvent("thorns")
        end
    end
end

local function OnAttackOther(inst, data)
    if not inst.isFrenzy then
        inst.components.combat:ShareTarget(data.target, 
            20, 
            function(dude) 
                return dude:HasTag("lizardman") 
                    and not dude.components.health:IsDead() 
            end, 5)
     end
end

--don't want to enrage lizardmans after wake instantly
local function OnEntityWake(inst)
    if GetTime() - inst.lastFrenzyTime > 30 then
        inst.lastFrenzyTime = GetTime() + math.random(30)
    end
end

local function OnEat(inst, food)
    if food.components.edible ~= nil then
        if food:HasTag("monstermeat") then
            inst:PushEvent("forcefrenzy")
        end
    end
end

local function GoFrenzy(inst)
    inst.sg:GoToState("taunt")
    inst.Transform:SetScale(1.1, 1.1, 1.1)
    inst.components.colouradder:PushColour("frenzy", 0.1, 0, 0, 0)
    inst.isFrenzy = true
    Retarget(inst)

    if inst._ftast then
        inst._ftast:Cancel()
        inst._ftast = nil
    end
    inst._ftast = inst:DoTaskInTime(frenzyDuration, function(inst) inst:PushEvent("gonormal") end)
end

local function StopFrenzy(inst)
    --print("become normal")
    if inst._ftast then
        inst._ftast:Cancel()
        inst._ftast = nil
    end
    inst.isFrenzy = false
    inst.lastFrenzyTime = GetTime()
    inst.components.colouradder:PopColour("frenzy")
    inst.Transform:SetScale(1, 1, 1)
end

local function TryFrenzy(inst)
    --if math.random() < 0.2 then
    inst.lastFrenzyTime = GetTime()
    if not inst.components.health:IsDead() and math.random() < 0.3 then
        --print("become frenzy")
        GoFrenzy(inst)
    end
end

local function MakeWeapon(inst)
    if inst.components.inventory ~= nil then
        local weapon = CreateEntity()
        weapon.entity:AddTransform()
        MakeInventoryPhysics(weapon)
        weapon:AddComponent("weapon")
        weapon.components.weapon:SetDamage(25)
        weapon.components.weapon:SetRange(16, 16 + 4)
        weapon.components.weapon:SetProjectile("lizardman_spit")
        weapon:AddComponent("inventoryitem")
        weapon.persists = false
        weapon.components.inventoryitem:SetOnDroppedFn(weapon.Remove)
        weapon:AddComponent("equippable")
        inst.weapon = weapon
        inst.components.inventory:Equip(inst.weapon)
        inst.components.inventory:Unequip(EQUIPSLOTS.HANDS)
    end
end

local function ShouldAcceptItem(inst, item)
    return false--item.components.equippable ~= nil
end

local function OnGetItemFromPlayer(inst, giver, item)
    if item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if current ~= nil then
            inst.components.inventory:DropItem(current)
        end
        inst.components.inventory:Equip(item)
        inst.AnimState:Show("swap_hat")
    end
end

local function GetDebugString(inst)
    return string.format("is frenzy: %s, try frenzy in %i", tostring(inst.isFrenzy), math.max(0, 30 - (GetTime() - inst.lastFrenzyTime)))
end

local function OnSave(inst, data)

end

local function OnLoad(inst, data)

end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
    inst.entity:AddPhysics()

    inst.DynamicShadow:SetSize(2, .75)
    inst.Transform:SetFourFaced()

    MakeCharacterPhysics(inst, 100, .75)

    inst.AnimState:SetBank("snapper")
    inst.AnimState:SetBuild("lizardman_snapper_basic")
    inst.AnimState:PlayAnimation("idle_loop")

    --inst.AnimState:AddOverrideBuild("fossilized")

    inst:AddTag("character")
    inst:AddTag("scarytoprey")
    --inst:AddTag("hostile")
    inst:AddTag("lizardman")

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    --inst.components.talker.colour = Vector3(133/255, 140/255, 167/255)
    inst.components.talker.offset = Vector3(0, -400, 0)
    inst.components.talker:MakeChatter()

    --fossilizable (from fossilizable component) added to pristine state for optimization
    --inst:AddTag("fossilizable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = 6
	local sg = require "stategraphs/SGlizardman"
	inst:SetStateGraph("SGlizardman")

	local brain = require "brains/lizardmanbrain"
	inst:SetBrain(brain)

	inst:AddComponent("knownlocations")

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(680)

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(45)
	inst.components.combat:SetAttackPeriod(2.5)
	inst.components.combat:SetRetargetFunction(2, Retarget)
	inst.components.combat:SetRange(3)
	inst.components.combat.battlecryenabled = false

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("lizardman")

	inst:AddComponent("inspectable")
    --inst:AddComponent("sanityaura")
    inst:AddComponent("inventory")

    --inst:AddComponent("trader")
    --inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    --inst.components.trader.onaccept = OnGetItemFromPlayer
    --inst.components.trader.deleteitemonaccept = true
    
    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODGROUP.LIZARDMAN }, { FOODGROUP.LIZARDMAN })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater:SetCanEatRaw()
    inst.components.eater:SetOnEatFn(OnEat)
    inst.components.eater.strongstomach = true

    inst:AddComponent("sleeper")
    inst:AddComponent("colouradder")
    
    MakeMediumFreezableCharacter(inst, "body")
    MakeMediumBurnableCharacter(inst, "body")

    inst.starvationLevel = 0
    inst.isFrenzy = false
    inst.lastFrenzyTime = GetTime() + math.random(30) * 0.5

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("gofrenzy", TryFrenzy)
    inst:ListenForEvent("forcefrenzy", GoFrenzy)
    inst:ListenForEvent("gonormal", StopFrenzy)

    inst.OnEntityWake = OnEntityWake

    MakeWeapon(inst)

    inst.debugstringfn = GetDebugString

    return inst
end

--range attack--------------------------
----------------------------------------
local function OnThrown(inst) 
    inst:Show() 
    inst.AnimState:PlayAnimation("idle_loop")
end

local function OnHit(inst) 
    inst.AnimState:PlayAnimation("blast")
    inst:ListenForEvent("animover", function(inst) inst:Remove() end)
end

local function OnMiss(inst) 
    inst.AnimState:PlayAnimation("disappear")
    inst:ListenForEvent("animover", function(inst) inst:Remove() end)
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddPhysics()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("gooball_fx")
    inst.AnimState:SetBuild("gooball_fx")
    inst.AnimState:PlayAnimation("idle_loop")
    inst.AnimState:SetMultColour(0.4, 1, 0.2, 1)
    inst.Transform:SetScale(0.6, 0.6, 0.6)
    inst.AnimState:SetFinalOffset(-1)

    inst.Transform:SetTwoFaced()

    --inst:Hide()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(40)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetHitDist(1.0)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(OnMiss)
    inst.components.projectile:SetOnThrownFn(OnThrown)
    inst.components.projectile:SetLaunchOffset(Vector3(2, 0.7, 2))

    return inst
end

return Prefab("lizardman", fn, assets, prefabs),
    Prefab("lizardman_spit", fxfn, assets_fx)
