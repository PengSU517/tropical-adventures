local assets = {
    Asset("ANIM", "anim/bonestaff.zip"),
    Asset("ANIM", "anim/swap_bonestaff.zip"),
}

local assets_proj = {
    Asset("ANIM", "anim/gooball_fx.zip"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_bonestaff", "swap_firestaff")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if inst.components.sctargeting then
        inst.components.sctargeting:StopTargeting()
    end
end

local function OnAttack(inst, attacker, target)
    if attacker.components.sanity then
        attacker.components.sanity:DoDelta(-5)
    end
    if attacker.components.health then
        attacker.components.health:DoDelta(-1)
    end
end

local function AnimatePigStatue(target)
    local x, y, z = target.Transform:GetWorldPosition()
    local notags = {"player", "playerghost", "INLIMBO", "NOCLICK", "FX" }
    local ents = TheSim:FindEntities(x, 0, z, 40, nil, notags)
    for k, v in pairs(ents) do
        if v.components.burnable ~= nil 
            and not v.components.burnable:IsBurning() 
            and v.components.fueled == nil 
        then
            v.components.burnable:Ignite(true)
        end   
    end

    local obj = SpawnPrefab("bossboar")
--    obj:Hide()
--    TemporarilyRemovePhysics(obj, 15)
if obj then
    obj.Transform:SetPosition(x, y, z)
end
	target:Remove()
end

local zombies = {
    grass = {"grassgekko"},
	greengrass = {"grassgekko"},
    dug_grass = {"grassgekko"},
    pigskin = {"pigman"},
    manrabbit_tail = {"bunnyman"},
    snakeskin = {"snake"},
    venomgland = {"snake"},	
    flower = {"butterfly"},
    butterflywings = {"butterfly"},
    petals = {"butterfly"},
    spidergland = {"spider"},
    silk = {"spider"},
    tentaclespots = {"tentacle"},
    molehat = {"mole"},
    wormlight = {"worm"},
    coontail = {"catcoon"},
    catcoonhat = {"catcoon"},
    gears = {"knight"},
    batwing = {"bat"},
    monstermeat = {"hound"},
    houndstooth = {"hound"},
    rope = {"snake"},
    livinglog = {"leif"},
    flower_evil = {"butterfly"},
    slurtlehat = {"slurtle"},
    froglegs = {"frog"},
    lightninggoathorn = {"lightninggoat"},
    trunk_summer = {"koalefant_summer"},
    trunk_winter = {"koalefant_winter"},
    fish = {"merm"},
    earmuffshat = {"rabbit"},
    stinger = {"bee"},
    walrus_tusk = {"walrus"},
    pig_figure = AnimatePigStatue,
	rocks = {"rock1"},
	flint = {"rock1"},
	goldnugget = {"rock2"},
	obsidian = {"rock_obsidian"},	
	beaverskin = {"wildbeaver"},
	nitre = {"rock1"},
	spoiled_food = {"meat"},
	meat = {"hound"},
	cutgrass = {"grass"},
	smallmeat = {"rabbit"},
	twigs = {"sapling"},
	mosquitosack = {"mosquito"},
	honey = {"bee"},
	pandaskin = {"panda"},
	chitin = {"scorpion"},
	vine = {"mean_flytrap"},
	weevole_carapace = {"weevole"},
	
}

local function createpower(staff, target, pos)
	local doer = staff.components.inventoryitem.owner
	if target then
    local x, y, z = target.Transform:GetWorldPosition()
	pos = Vector3(x, y, z)
	end
	
    for k, ent in pairs(TheSim:FindEntities(pos.x, pos.y, pos.z, 4, nil, { "playerghost", "INLIMBO", "NOCLICK", "FX" })) do
        local zmb = zombies[ent.prefab]
        if ent:HasTag("playerghost") then
            ent:PushEvent("respawnfromghost", { source = staff, user = doer })
            if doer.components.sanity ~= nil then
                doer.components.sanity:DoDelta(-50)
            end
        end
        if zmb ~= nil then
            if type(zmb) == "function" then
                zmb(ent)
            else
                local newCreature 
                if #zmb > 1 then
                    newCreature = SpawnPrefab(zmb[1])
                else
                    newCreature = SpawnPrefab(zmb[math.random(#zmb)])
                end
                if newCreature then
                    local x, y, z = ent.Transform:GetWorldPosition()
                    SpawnPrefab("spawn_fx_medium").Transform:SetPosition(x, y, z)
                    newCreature.Transform:SetPosition(x, y, z)
                    if doer.components.sanity ~= nil then
                        doer.components.sanity:DoDelta(-25)
                    end
                    ent:Remove()
                end
            end
        elseif ent.components.hauntable then
            ent.components.hauntable:DoHaunt(doer)
        end
    end
	
    if staff.components.finiteuses ~= nil then
        staff.components.finiteuses:Use(1)
    end	

    return true	
end


local function cancreatepower(doer, target, pos)
return true
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("bonestaff")
    inst.AnimState:SetBuild("bonestaff")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(35)
    inst.components.weapon:SetRange(8, 10)
    inst.components.weapon:SetProjectile("gw_bonestaff_proj")
    inst.components.weapon:SetOnAttack(OnAttack)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/gw_bonestaff.xml"
	inst.caminho = "images/inventoryimages/gw_bonestaff.xml"

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(30)
    inst.components.finiteuses:SetUses(30)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	
    inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canuseontargets = true	
    inst.components.spellcaster.canuseonpoint_water = true	
    inst.components.spellcaster:SetSpellFn(createpower)
    inst.components.spellcaster:SetCanCastFn(cancreatepower)	


    MakeHauntableLaunch(inst)

    return inst
end

local function StopTail(inst)
    if inst._ttask ~= nil then
        inst._ttask:Cancel()
        inst._ttask = nil
    end
end

local function OnHitTarget(inst)
    inst:Show()
    inst._killtail:push()
    inst.AnimState:PlayAnimation("smallblast")
    inst:ListenForEvent("animover", inst.Remove)
end

local function OnMissTarget(inst)
    inst:Show()
    inst._killtail:push()
    inst.AnimState:PlayAnimation("disappear")
    inst:ListenForEvent("animover", inst.Remove)
end

local function CreateTail()
    local tail = CreateEntity()

    tail:AddTag("FX")
    tail:AddTag("NOCLICK")
    tail.entity:SetCanSleep(false)
    tail.persists = false

    tail.entity:AddTransform()
    tail.entity:AddAnimState()

    --tail.Transform:SetScale(0.5, 0.5, 0.5)

    MakeInventoryPhysics(tail)
    tail.Physics:ClearCollisionMask()

    tail.AnimState:SetBank("gooball_fx")
    tail.AnimState:SetBuild("gooball_fx")
    tail.AnimState:SetMultColour(0.1, 0.1, 0.1, 0.5)
    tail.AnimState:PlayAnimation("disappear")

    tail.AnimState:SetFinalOffset(-1)

    tail:ListenForEvent("animover", tail.Remove)

    return tail
end

local function UpdateTail(inst)
    local rnd = math.random(5)
    if rnd <= 3 then return end
    local tail = CreateTail()
    if tail then
        local x, y, z = inst.Transform:GetWorldPosition()
        local rot = inst.Transform:GetRotation()
        tail.Transform:SetRotation(rot)
        rot = rot * DEGREES
        local offsangle = math.random() * 2 * PI
        local offsradius = math.random() * .2 --+ .2
        local hoffset = math.cos(offsangle) * offsradius
        tail.Transform:SetPosition(x + math.sin(rot) * hoffset, y, z + math.cos(rot) * hoffset)
        tail.Physics:SetMotorVel(10, 0, 0)

        tail:ListenForEvent("staff_proj.killtail", function() tail:Remove() end, inst)
    end
end

local function proj_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("gooball_fx")
    inst.AnimState:SetBuild("gooball_fx")
    inst.AnimState:SetMultColour(0.1, 0.1, 0.1, 0.5)
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetFinalOffset(-1)

    inst.Transform:SetScale(0.5, 0.5, 0.5)
    inst:Hide()

    inst:AddTag("FX")
    inst:AddTag("projectile")

    inst._killtail = net_event(inst.GUID, "staff_proj.killtail") 
    inst:ListenForEvent("staff_proj.killtail", StopTail)

    if not TheNet:IsDedicated() then
        inst._ttask = inst:DoPeriodicTask(0, UpdateTail)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(25)
    inst.components.projectile:SetOnHitFn(OnHitTarget)
    inst.components.projectile:SetOnMissFn(OnMissTarget)

    return inst
end

return Prefab("gw_bonestaff", fn, assets),
    Prefab("gw_bonestaff_proj", proj_fn, assets_proj)
