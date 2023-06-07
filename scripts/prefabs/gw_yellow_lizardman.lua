local assets =
{
    Asset("ANIM", "anim/gw_yellow_lizard.zip"),
    Asset("ANIM", "anim/lizardman_anims.zip"),
}

SetSharedLootTable( "lizardman",
{
    {"meat", 1.0},
    {"meat", 1.0},
    {"snakeskin", 0.5},
})

local function Retarget(inst)
	local dist = 12
    local notags = {"FX", "NOCLICK", "INLIMBO", "lizardman"}
    local reqtags = nil
    if not inst.isFrenzy then
        reqtags = {"monster"}
        notags = {"FX", "NOCLICK", "INLIMBO", "shadow", "lizardman", "structure", "player"}
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

local function OnWeaponAttack(weapon, inst, target)
    local x, _, z = inst.Transform:GetWorldPosition()
    local xt, _, zt = target.Transform:GetWorldPosition()

    local fxdummy = SpawnPrefab("gf_lightning_dummy")
    fxdummy.components.gflightningdrawer:SetColour(2)
    fxdummy.Transform:SetPosition(x, 0, z)

    local lpos =
    {
        {
            start = {x = x, z = z}, 
            finish = {x = xt, z = zt}
        }
    }
    fxdummy.components.gflightningdrawer:DoLightning(lpos)

    local fx = SpawnPrefab("shock_fx")
    if fx ~= nil then fx.Transform:SetPosition(xt, _, zt) end
end

local function MakeWeapon(inst)
    if inst.components.inventory ~= nil then
        local weapon = CreateEntity()
        weapon.entity:AddTransform()
        MakeInventoryPhysics(weapon)
        weapon.persists = false

        weapon:AddComponent("weapon")
        weapon.components.weapon:SetDamage(25)
        weapon.components.weapon:SetRange(16, 16 + 4)
        weapon.components.weapon.stimuli = "electric"
        weapon.components.weapon:SetOnAttack(OnWeaponAttack)

        weapon:AddComponent("inventoryitem")
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
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
    inst.entity:AddPhysics()

    inst.DynamicShadow:SetSize(2, .75)
    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(1.2, 1.2, 1.2)

    MakeCharacterPhysics(inst, 100, .75)

    inst.AnimState:SetBank("snapper")
    inst.AnimState:SetBuild("gw_yellow_lizard")
    inst.AnimState:PlayAnimation("idle_loop")

    inst:AddTag("character")
    inst:AddTag("scarytoprey")
    inst:AddTag("lizardman")
    inst:AddTag("electricdamageimmune")

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -400, 0)
    inst.components.talker:MakeChatter()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = 6 * 0.9
	local sg = require "stategraphs/SGlizardman"
	inst:SetStateGraph("SGlizardman")

	local brain = require "brains/lizardmanbrain"
	inst:SetBrain(brain)

	inst:AddComponent("knownlocations")

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(680)

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(45)
	inst.components.combat:SetAttackPeriod(2.5 * 2)
	inst.components.combat:SetRetargetFunction(2, Retarget)
	inst.components.combat:SetRange(16)
	inst.components.combat.battlecryenabled = false

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("lizardman")

	inst:AddComponent("inspectable")
    inst:AddComponent("inventory")
    
    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODGROUP.LIZARDMAN }, { FOODGROUP.LIZARDMAN })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater:SetCanEatRaw()
    --inst.components.eater:SetOnEatFn(OnEat)
    inst.components.eater.strongstomach = true

    inst:AddComponent("sleeper")
    inst:AddComponent("colouradder")
    
    MakeMediumFreezableCharacter(inst, "body")
    MakeMediumBurnableCharacter(inst, "body")

    inst.isFrenzy = true

    inst:ListenForEvent("attacked", OnAttacked)
    MakeWeapon(inst)

    return inst
end


return Prefab("gw_yellow_lizardman", fn, assets, prefabs)
