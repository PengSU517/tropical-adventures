require "brains/citypigbrain"
require "brains/pigguardbrain"
require "brains/werepigbrain"
require "stategraphs/SGpig_city"
require "stategraphs/SGwerepig"

local total_day_time = 480
local seg_time = 30
local PIG_DAMAGE = 33
local PIG_HEALTH = 250
local PIG_ATTACK_PERIOD = 3
local PIG_TARGET_DIST = 16
local PIG_LOYALTY_MAXTIME = 2.5 * total_day_time
local PIG_LOYALTY_PER_HUNGER = total_day_time / 25
local PIG_MIN_POOP_PERIOD = seg_time * .5
local PIG_RUN_SPEED = 5
local PIG_WALK_SPEED = 3
local CITY_PIG_GUARD_TARGET_DIST = 20
local SPRING_COMBAT_MOD = 1.33

local assets =
{
    Asset("SOUND", "sound/pig.fsb"),
    Asset("ANIM", "anim/pig_usher.zip"),
    Asset("ANIM", "anim/pig_mayor.zip"),
    Asset("ANIM", "anim/pig_miner.zip"),
    Asset("ANIM", "anim/pig_queen.zip"),
    Asset("ANIM", "anim/pig_farmer.zip"),
    Asset("ANIM", "anim/pig_hunter.zip"),
    Asset("ANIM", "anim/pig_banker.zip"),
    Asset("ANIM", "anim/pig_florist.zip"),
    Asset("ANIM", "anim/pig_erudite.zip"),
    Asset("ANIM", "anim/pig_hatmaker.zip"),
    Asset("ANIM", "anim/pig_mechanic.zip"),
    Asset("ANIM", "anim/pig_professor.zip"),
    Asset("ANIM", "anim/pig_collector.zip"),
    Asset("ANIM", "anim/townspig_basic.zip"),
    Asset("ANIM", "anim/pig_beautician.zip"),
    Asset("ANIM", "anim/pig_royalguard.zip"),
    Asset("ANIM", "anim/pig_storeowner.zip"),
    Asset("ANIM", "anim/townspig_attacks.zip"),
    Asset("ANIM", "anim/townspig_actions.zip"),
    Asset("ANIM", "anim/pig_royalguard_2.zip"),
    Asset("ANIM", "anim/townspig_shop_wip.zip"),

    Asset("ANIM", "anim/pig_eskimo.zip"),
    Asset("ANIM", "anim/pig_royalguard_rich.zip"),
    Asset("ANIM", "anim/pig_royalguard_rich_2.zip"),
    Asset("ANIM", "anim/pig_royalguard_3.zip"),
    Asset("ANIM", "anim/pig_shopkeeper.zip"),
}

local prefabs =
{
    "meat",
    "poop",
    "tophat",
    "pigskin",
    "halberd",
    "strawhat",
    "monstermeat",
    --    "pigcrownhat",
    --    "pig_scepter",
    "pigman_shopkeeper_desk",
}

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30


local function getSpeechType(inst, speech)
    local line = speech.DEFAULT

    if inst.talkertype and speech[inst.talkertype] then
        line = speech[inst.talkertype] or line
    end

    if type(line) == "table" then
        line = line[math.random(#line)]
    end

    return line
end

local function OnTimerDone(inst, data)
    if data.name == "vaiembora" then
        local invader = GetClosestInstWithTag("player", inst, 25)
        if not invader then
            inst:Remove()
        else
            inst.components.timer:StartTimer("vaiembora", 10)
        end
    end
end

local function shopkeeper_speech(inst, speech)
    if inst:IsValid() and not inst:IsAsleep() and not inst.components.combat.target and not inst:IsInLimbo() then
        inst.sayline(inst, speech)
        --inst.components.talker:Say(speech, 1.5, nil, true)
    end
end

local function closeshop(inst)
    if inst:IsValid() and not inst:IsAsleep() and not inst.components.combat.target and not inst:IsInLimbo() then
        inst.sg:GoToState("idle")
        shopkeeper_speech(inst, STRINGS.CITY_PIG_SHOPKEEPER_CLOSING
            [math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_CLOSING)])
    end
end

local function spawndesk(inst, spawndesk)
    if spawndesk then
        local desklocation = Vector3(inst.Transform:GetWorldPosition())
        if inst.desklocation then
            desklocation = inst.desklocation
        end
        inst.desk = SpawnPrefab("pigman_shopkeeper_desk")
        inst.desk.Transform:SetPosition(desklocation.x, desklocation.y, desklocation.z)
        inst:AddComponent("homeseeker")
        inst.components.homeseeker:SetHome(inst.desk)
    else
        inst.desklocation = Vector3(inst.Transform:GetWorldPosition())
        if inst.desk then
            inst.desk:Remove()
            inst.desk = nil
        end
    end
end

local function separatedesk(inst, separatedesk)
    if separatedesk then
        inst:RemoveTag("atdesk")
        inst.AnimState:Hide("desk")
        spawndesk(inst, true)
        ChangeToCharacterPhysics(inst)
        inst.Physics:SetMass(50)
    else
        ChangeToObstaclePhysics(inst)
        if inst.desk then
            local x, y, z = inst.desk.Transform:GetWorldPosition()
            inst.Transform:SetPosition(x, y, z)
        end
        spawndesk(inst, false)
        inst:AddTag("atdesk")
        inst.AnimState:Show("desk")
    end
end

local function sayline(inst, line, mood)
    inst.components.talker:Say(line, 1.5, nil, true, mood)
end

local function ontalk(inst, script, mood)
    if inst:HasTag("guard") then
        if mood and mood == "alarmed" then
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/guard_alert")
        else
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd", "talk")
        end
    else
        if inst.female then
            if mood and mood == "alarmed" then
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/scream_female")
            else
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_female", "talk")
            end
        else
            if mood and mood == "alarmed" then
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/scream")
            else
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk", "talk")
            end
        end
    end
end

local function ontalkfinish(inst)
    inst.SoundEmitter:KillSound("talk")
end

local function SpringMod(amt)
    if TheWorld.state.isspring then
        return amt * SPRING_COMBAT_MOD
    else
        return amt
    end
end

local function CalcSanityAura(inst, observer)
    if inst.components.werebeast
        and inst.components.werebeast:IsInWereState() then
        return -TUNING.SANITYAURA_LARGE
    end

    if inst.components.follower and inst.components.follower.leader == observer then
        return TUNING.SANITYAURA_SMALL
    end

    return 0
end

local function ShouldAcceptItem(inst, item)
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        return false
    end

    if item.components.edible then
        if (item.components.edible.foodtype == "MEAT" or item.components.edible.foodtype == "HORRIBLE")
            and inst.components.follower.leader
            and inst.components.follower:GetLoyaltyPercent() > 0.9 then
            return false
        end

        if (item.components.edible.foodtype == "VEGGIE" or item.components.edible.foodtype == "RAW") then
            local last_eat_time = inst.components.eater:TimeSinceLastEating()
            if last_eat_time and last_eat_time < TUNING.PIG_MIN_POOP_PERIOD then
                return false
            end

            if inst.components.inventory:Has(item.prefab, 1) then
                return false
            end
        end
    end

    if item.prefab == "oinc" or item.prefab == "oinc10" or item.prefab == "oinc100" then --or trinket_giftshop
        return true
    end

    if not inst:HasTag("guard") or inst.prefab == "pig_eskimo" then
        local city = 1
        if inst:HasTag("city2") then
            city = 2
        end
        local econ = TheWorld.components.economy

        local econprefab = inst.prefab
        if inst.econprefab then
            econprefab = inst.econprefab
        end

        local wanteditems = econ:GetTradeItems(econprefab)


        local wantitem = false
        for i, wanted in ipairs(wanteditems) do
            if wanted == item.prefab then
                wantitem = true
                break
            end
        end

        if (item.prefab == "trinket_giftshop_1" or item.prefab == "trinket_giftshop_3") and inst:HasTag("city1") and not inst:HasTag("recieved_trinket") then
            wantitem = true
        end

        if (item.prefab == "relic_4" or item.prefab == "relic_5") and not inst:HasTag("pigqueen") then
            wantitem = false
        end

        if wantitem then
            if item.prefab == "trinket_giftshop_1" or item.prefab == "trinket_giftshop_3" then
                return true
            end

            local delay = econ:GetDelay(econprefab, city, inst)
            if inst:HasTag("troqueihoje") and not (inst.prefab == "pigman_storeowner" or inst.prefab == "pigman_banker" or inst.prefab == "pigman_mayor" or inst.prefab == "pigman_queen" or inst.prefab == "pigman_professor" or inst.prefab == "pigman_collector" or inst.prefab == "pigman_mechanic" or inst.prefab == "pigman_storeowner_shopkeep" or inst.prefab == "pigman_banker_shopkeep" or inst.prefab == "pigman_mayor_shopkeep" or inst.prefab == "pigman_professor_shopkeep" or inst.prefab == "pigman_collector_shopkeep" or inst.prefab == "pigman_mechanic_shopkeep") then
                if inst:HasTag("troqueihoje") then
                    inst.sayline(inst, getSpeechType(inst, STRINGS.CITY_PIG_TALK_REFUSE_GIFT_DELAY_TOMORROW))
                    --inst.components.talker:Say(  getSpeechType(inst,STRINGS.CITY_PIG_TALK_REFUSE_GIFT_DELAY_TOMORROW) )
                else
                    inst.sayline(inst,
                        string.format(getSpeechType(inst, STRINGS.CITY_PIG_TALK_REFUSE_GIFT_DELAY), tostring(delay)))
                    --inst.components.talker:Say( string.format( getSpeechType(inst,STRINGS.CITY_PIG_TALK_REFUSE_GIFT_DELAY), tostring(delay) ) )
                end
                return false
            else
                return true
            end
        else
            if item:HasTag("relic") then
                if item.prefab == "relic_4" or item.prefab == "relic_5" then
                    inst.sayline(inst, getSpeechType(inst, STRINGS.CITY_PIG_TALK_REFUSE_PRICELESS_GIFT))
                elseif (inst.prefab == "pigman_collector_shopkeep" or inst.prefab == "pigman_collector") then
                    return true
                else
                    inst.sayline(inst, getSpeechType(inst, STRINGS.CITY_PIG_TALK_RELIC_GIFT))
                    --inst.components.talker:Say( getSpeechType(inst,STRINGS.CITY_PIG_TALK_RELIC_GIFT) )
                end
            else
                if item.prefab == "trinket_giftshop_1" or item.prefab == "trinket_giftshop_3" and inst:HasTag("city1") then
                    inst.sayline(inst, getSpeechType(inst, STRINGS.CITY_PIG_TALK_REFUSE_TRINKET_GIFT))
                else
                    --HUGO
                    local itemname = GetRandomItem(wanteditems)
                    local desc = econ:GetTradeItemDesc(econprefab)
                    local costprefab, cost = econ:MakeTrade(econprefab, nil, nil, itemname)


                    inst.sayline(inst,
                        subfmt(getSpeechType(inst, STRINGS.CITY_PIG_TALK_REFUSE_GIFT),
                            {
                                item = STRINGS.NAMES[itemname:upper()] or itemname,
                                costprefab = costprefab and STRINGS.NAMES[costprefab:upper()],
                                cost = cost or 1,
                            }

                        ))
                end
            end
            return false
        end
    end

    if inst:HasTag("guard") then
        if item:HasTag("securitycontract") then
            return true
        end
    end

    return false
end

local function OnGetItemFromPlayer(inst, giver, item)
    if not inst:HasTag("guard") or inst.prefab == "pig_eskimo" then -- or inst:HasTag("pigqueen")
        local city = 1
        if inst:HasTag("city2") then
            city = 2
        end

        -- I wear hats (but should they? the art doesn't show)
        if inst:HasTag("pigqueen") and item.components.equippable then
            local behappy = false
            if item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
                local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
                if current then
                    inst.components.inventory:DropItem(current)
                end

                inst.components.inventory:Equip(item)
                inst.AnimState:Show("hat")
                behappy = true
            end

            if item.components.equippable.equipslot == EQUIPSLOTS.HANDS and item.prefab == "pig_scepter" then
                inst.components.inventory:Equip(item)
                behappy = true
            end

            if item.prefab == "relic_4" or item.prefab == "relic_5" then
                behappy = true
            end
            if behappy then
                inst:PushEvent("behappy")
            end
            if item.prefab ~= "pig_scepter" and item.prefab ~= "pigcrownhat" then
                item:Remove() -- why doesn't trader use a function for deleteitemonaccept...
            end
        end

        local econ = TheWorld.components.economy

        local econprefab = inst.prefab
        if inst.econprefab then
            econprefab = inst.econprefab
        end

        local wanteditems = econ:GetTradeItems(econprefab)
        local desc = econ:GetTradeItemDesc(econprefab)
        --local wantednum =   econ:GetNumberWanted(econprefab,city)

        local wantitem = false
        local trinket = false
        for i, wanted in ipairs(wanteditems) do
            if wanted == item.prefab then
                wantitem = true
                break
            end
        end

        if item.prefab == "trinket_giftshop_1" or item.prefab == "trinket_giftshop_3" and inst:HasTag("city1") then
            wantitem = true
            trinket = true
        end

        if wantitem then
            if trinket then
                if giver.components.inventory then
                    inst:AddTag("recieved_trinket")
                    inst.sayline(inst, getSpeechType(inst, STRINGS.CITY_PIG_TALK_GIVE_TRINKET_REWARD))

                    local reward = { "kabobs", "pumpkincookie", "taffy", "oinc", "butterflymuffin", "powcake" }
                    local rewarditem = SpawnPrefab(reward[math.random(1, #reward)])
                    giver.components.inventory:GiveItem(rewarditem, nil,
                        Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))

                    return true
                end
            end

            local reward, qty = econ:MakeTrade(econprefab, city, inst, item.prefab)
            if item.prefab ~= "pig_scepter" and item.prefab ~= "pigcrownhat" then
                item:Remove()
            end
            if reward then
                inst:AddTag("troqueihoje")
                if giver.components.inventory then
                    inst.sayline(inst,
                        string.format(getSpeechType(inst, STRINGS.CITY_PIG_TALK_GIVE_REWARD), tostring(1), desc))
                    --inst.components.talker:Say( string.format(getSpeechType(inst,STRINGS.CITY_PIG_TALK_GIVE_REWARD), tostring(1), desc ))--econ:GetNumberWanted(econprefab,city) ), desc ) )

                    for i = 1, qty do
                        local rewarditem = SpawnPrefab(reward)
                        giver.components.inventory:GiveItem(rewarditem, nil,
                            Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
                    end
                end
            else
                inst.sayline(inst, string.format(getSpeechType(inst, STRINGS.CITY_PIG_TALK_TAKE_GIFT), tostring(1), desc))
                --inst.components.talker:Say( string.format(getSpeechType(inst,STRINGS.CITY_PIG_TALK_TAKE_GIFT), tostring(1), desc ))--econ:GetNumberWanted(econprefab,city) ), desc ) )
            end
        end
        if item:HasTag("relic") and (inst.prefab == "pigman_collector_shopkeep" or inst.prefab == "pigman_collector") then
            if giver.components.inventory then
                inst.sayline(inst, getSpeechType(inst, STRINGS.CITY_PIG_TALK_GIVE_RELIC_REWARD))
                --inst.components.talker:Say( getSpeechType(inst,STRINGS.CITY_PIG_TALK_GIVE_RELIC_REWARD) )
                local rewarditem = SpawnPrefab("oinc10")
                giver.components.inventory:GiveItem(rewarditem, nil,
                    Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
            end
        end
    end

    if inst:HasTag("guard") and item:HasTag("securitycontract") then
        inst.SoundEmitter:PlaySound("dontstarve/common/makeFriend")
        giver.components.leader:AddFollower(inst)
        inst.components.follower:AddLoyaltyTime(TUNING.PIG_LOYALTY_MAXTIME)
        item:Remove()
    end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("refuse")
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function OnEat(inst, food)
    if food.components.edible
        and food.components.edible.foodtype == "MEAT"
        and inst.components.werebeast
        and not inst.components.werebeast:IsInWereState() then
        if food.components.edible:GetHealth() < 0 then
            inst.components.werebeast:TriggerDelta(1)
        end
    end

    if food.components.edible and (food.components.edible.foodtype == "VEGGIE") then --or food.components.edible.foodtype == "SEEDS") then
        local poop = SpawnPrefab("poop")
        poop:AddTag("podepegar")
        poop.Transform:SetPosition(inst.Transform:GetWorldPosition())

        --        poop.cityID = inst.components.citypossession.cityID
        --        TheWorld.components.periodicpoopmanager:OnPoop(poop.cityID, poop)
    end
end

local function OnAttackedByDecidRoot(inst, attacker)
    local fn = function(dude) return dude:HasTag("pig") and not dude:HasTag("werepig") and not dude:HasTag("guard") end

    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = nil
    if TheWorld.state.isspring then
        ents = TheSim:FindEntities(x, y, z, (SHARE_TARGET_DIST * SPRING_COMBAT_MOD) / 2)
    else
        ents = TheSim:FindEntities(x, y, z, SHARE_TARGET_DIST / 2)
    end

    if ents then
        local num_helpers = 0
        for k, v in pairs(ents) do
            if v ~= inst and v.components.combat and not (v.components.health and v.components.health:IsDead()) and fn(v) then
                if v:PushEvent("suggest_tree_target", { tree = attacker }) then
                    num_helpers = num_helpers + 1
                end
            end
            if num_helpers >= MAX_TARGET_SHARES then
                break
            end
        end
    end
end

local function callGuards(inst, attacker)
    local x, y, z = inst.Transform:GetWorldPosition()


    local eles = TheSim:FindEntities(x, y, z, 30, { "guard" })
    if #eles > 1 then return end

    local ents = TheSim:FindEntities(x, y, z, 30, { "guard_entrance" })
    if #ents > 0 then
        local guardprefab = "pigman_royalguard"
        local cityID = 1
        if inst:HasTag("city2") then
            guardprefab = "pigman_royalguard_2"
            cityID = 2
        end
        local spawnpt = Vector3(ents[math.random(#ents)].Transform:GetWorldPosition())
        local guard = SpawnPrefab(guardprefab)
        guard.components.citypossession:SetCity(cityID)
        guard.Transform:SetPosition(spawnpt.x, spawnpt.y, spawnpt.z)
        guard:PushEvent("attacked", { attacker = attacker, damage = 0, weapon = nil })

        guard:AddComponent("timer")
        guard:ListenForEvent("timerdone", OnTimerDone)
        guard.components.timer:StartTimer("vaiembora", 240)

        if attacker then
            attacker:AddTag("wanted_by_guards")
        end
    end
end

local function spawnguardtasks(inst, attacker)
    inst.task_guard1 = inst:DoTaskInTime(math.random(1) + 1, function() callGuards(inst, attacker) end)
    inst.task_guard2 = inst:DoTaskInTime(math.random(1) + 1.5, function() callGuards(inst, attacker) end)
end

local function OnAttacked(inst, data)
    --print(inst, "OnAttacked")
    local attacker = data.attacker
    inst:ClearBufferedAction()
    if not attacker then return end
    if attacker.prefab == "deciduous_root" and attacker.owner then
        OnAttackedByDecidRoot(inst, attacker.owner)
    elseif attacker.prefab ~= "deciduous_root" then
        inst.components.combat:SetTarget(attacker)

        if inst:HasTag("guard") then
            if attacker:HasTag("player") then
                inst:AddTag("angry_at_player")
            end
            inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST,
                function(dude) return dude:HasTag("pig") and (dude:HasTag("guard") or not attacker:HasTag("pig")) end,
                MAX_TARGET_SHARES)
        else
            if not (attacker:HasTag("pig") and attacker:HasTag("guard")) then
                inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST,
                    function(dude) return dude:HasTag("pig") end, MAX_TARGET_SHARES)
            end
        end
    end

    --    if not inst:HasTag("guards_called") then
    --        inst:AddTag("guards_called")
    if inst:HasTag("shopkeep") or inst:HasTag("pigqueen") then
        spawnguardtasks(inst, data.attacker)
    end
    --    end
end

local builds = { "pig_build", "pigspotted_build" }
local guardbuilds = { "pig_guard_build" }

local function NormalRetargetFn(inst)
    return FindEntity(inst, CITY_PIG_GUARD_TARGET_DIST,
        function(guy)
            if not guy.LightWatcher or guy.LightWatcher:IsInLight() then
                if guy:HasTag("player") and inst:HasTag("angry_at_player") and guy.components.health and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy) then
                    inst.sayline(inst, getSpeechType(inst, STRINGS.CITY_PIG_GUARD_TALK_ANGRY_PLAYER))
                    --inst.components.talker:Say( getSpeechType(inst,STRINGS.CITY_PIG_GUARD_TALK_ANGRY_PLAYER) )
                end

                return (guy:HasTag("monster") or guy:HasTag("merm") or (guy:HasTag("player") and inst:HasTag("angry_at_player"))) and
                    guy.components.health and not guy.components.health:IsDead() and
                    inst.components.combat:CanTarget(guy) and not
                    (inst.components.follower.leader ~= nil and guy:HasTag("abigail"))
            end
        end)
end

local function NormalKeepTargetFn(inst, target)
    --give up on dead guys, or guys in the dark, or werepigs
    return inst.components.combat:CanTarget(target)
        and (not target.LightWatcher or target.LightWatcher:IsInLight())
        and not (target.sg and target.sg:HasStateTag("transform"))
end

local function NormalShouldSleep(inst)
    if inst.components.follower and inst.components.follower.leader then
        local fire = FindEntity(inst, 6, function(ent)
            return ent.components.burnable
                and ent.components.burnable:IsBurning()
        end, { "campfire" })
        return DefaultSleepTest(inst) and fire and (not inst.LightWatcher or inst.LightWatcher:IsInLight())
    else
        return DefaultSleepTest(inst)
    end
end

local function SetNormalPig(inst, brain_id)
    inst:RemoveTag("werepig")
    inst:RemoveTag("guard")
    --	inst.AnimState:SetBuild(inst.build)

    --inst.components.werebeast:SetOnNormalFn(SetNormalPig)
    inst.components.sleeper:SetResistance(2)

    inst.components.combat:SetDefaultDamage(PIG_DAMAGE)
    inst.components.combat:SetAttackPeriod(PIG_ATTACK_PERIOD)
    inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)
    inst.components.locomotor.runspeed = PIG_RUN_SPEED
    inst.components.locomotor.walkspeed = PIG_WALK_SPEED

    inst.components.sleeper:SetSleepTest(NormalShouldSleep)
    inst.components.sleeper:SetWakeTest(DefaultWakeTest)

    inst.components.lootdropper:SetLoot({})
    inst.components.lootdropper:AddRandomLoot("meat", 3)
    inst.components.lootdropper:AddRandomLoot("pigskin", 1)
    inst.components.lootdropper.numrandomloot = 1

    if inst:HasTag("shopkeep") then
        inst.components.health:SetMaxHealth(20000)
    else
        inst.components.health:SetMaxHealth(PIG_HEALTH)
    end
    inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)
    inst.components.combat:SetTarget(nil)
    inst:ListenForEvent("suggest_tree_target", function(inst, data)
        if data and data.tree and inst:GetBufferedAction() ~= ACTIONS.CHOP then
            inst.tree_target = data.tree
        end
    end)

    inst:ListenForEvent("itemreceived",
        function(inst, data)
            if data.item.prefab == "oinc" or data.item.prefab == "oinc10" or data.item.prefab == "oinc100" then
                if inst:HasTag("angry_at_player") then
                    if not inst.bribe_count then
                        inst.bribe_count = 0
                    end

                    -- If the item is not an oinc it's obviously an oinc10, so we count the bribe accordingly
                    if data.item.prefab == "oinc" then
                        inst.bribe_count = inst.bribe_count + 1
                    elseif data.item.prefab == "oinc10" then
                        inst.bribe_count = inst.bribe_count + 10
                    elseif data.item.prefab == "oinc100" then
                        inst.bribe_count = inst.bribe_count + 100
                    end
                    inst.bribe_count = inst.bribe_count * data.item.components.stackable.stacksize

                    local bribe_threshold = inst:HasTag("guard") and 10 or 1
                    if inst.bribe_count >= bribe_threshold then
                        inst:RemoveTag("angry_at_player")

                        if inst.components.combat and inst.components.combat:IsTarget(GetPlayer()) then
                            inst.components.combat:GiveUp()
                        end

                        inst.bribe_count = 0
                        inst.sayline(inst, getSpeechType(inst, STRINGS.CITY_PIG_TALK_FORGIVE_PLAYER))
                        --inst.components.talker:Say(getSpeechType(inst, STRINGS.CITY_PIG_TALK_FORGIVE_PLAYER))
                    else
                        inst.sayline(inst, getSpeechType(inst, STRINGS.CITY_PIG_TALK_NOT_ENOUGH))
                    end
                end
            end
        end)

    inst.components.trader:Enable()
    inst.components.talker:StopIgnoringAll()

    local brain = require "brains/citypigbrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGpig_city")


    inst:WatchWorldState("isday", function()
        if inst:HasTag("shopkeep") then
            local bancada = GetClosestInstWithTag("moveporco", inst, 25)
            if bancada then
                local x, y, z = bancada.Transform:GetWorldPosition()
                inst.Transform:SetPosition(x, y, z)
            end
        end
    end)
end

local function normalizetorch(torch)
    print("normalizing torch")
    torch.components.fueled.unlimited_fuel = nil
end

local function normalizehalberd(halberd)
    print("normalizing halberd")
    halberd.components.finiteuses.unlimited_uses = nil
end

local function throwcrackers(inst)
    local cracker = SpawnPrefab("firecrackers")
    inst.components.inventory:GiveItem(cracker)
    local pos = Vector3(inst.Transform:GetWorldPosition())
    local start_angle = inst.Transform:GetRotation()
    local radius = 5
    local attempts = 12

    local test_fn = function(offset)
        local ents = TheSim:FindEntities(pos.x + offset.x, pos.y + offset.y, pos.z + offset.z, 2, nil, { "INLIMBO" })

        if #ents == 0 then
            return true
        end
    end
    local pt, new_angle = FindValidPositionByFan(start_angle, radius, attempts, test_fn)

    if new_angle then
        inst.Transform:SetRotation(new_angle / DEGREES)
    end

    local rot = inst.Transform:GetRotation() * DEGREES

    local tossdir = Vector3(0, 0, 0)
    tossdir.x = math.cos(rot)
    tossdir.z = -math.sin(rot)

    inst.components.inventory:DropItem(cracker, nil, nil, nil, nil, tossdir)
    --    cracker.components.fuse:StartFuse()
    cracker.components.burnable:Ignite()
end

local function makefn(name, build, fixer, guard_pig, shopkeeper, tags, sex, econprefab)
    local function make_common()
        local inst = CreateEntity()
        local trans = inst.entity:AddTransform()
        local anim = inst.entity:AddAnimState()
        local sound = inst.entity:AddSoundEmitter()
        local shadow = inst.entity:AddDynamicShadow()
        inst.entity:AddNetwork()

        shadow:SetSize(1.5, .75)

        inst.Transform:SetFourFaced()

        inst.entity:AddLightWatcher()

        inst:AddComponent("talker")
        inst.components.talker.ontalk = ontalk
        inst.components.talker.donetalkingfn = ontalkfinish
        inst.components.talker.fontsize = 35
        inst.components.talker.font = TALKINGFONT
        inst.components.talker.offset = Vector3(0, -600, 0)
        inst.talkertype = name

        inst.sayline = sayline

        --inst.components.talker.colour = Vector3(133/255, 140/255, 167/255)

        MakeCharacterPhysics(inst, 50, .5)

        --        MakePoisonableCharacter(inst)

        inst:AddTag("character")
        inst:AddTag("pig")
        inst:AddTag("civilized")
        inst:AddTag("scarytoprey")

        inst:AddTag("city_pig")



        if tags then
            for i, tag in ipairs(tags) do
                inst:AddTag(tag)
            end
        end

        anim:SetBank("townspig")
        anim:SetBuild(build)

        anim:PlayAnimation("idle_loop", true)
        anim:Hide("hat")
        anim:Hide("desk")
        anim:Hide("ARM_carry")
        inst.daily_gift = 0

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("locomotor")                       -- locomotor must be constructed before the stategraph
        inst.components.locomotor.runspeed = PIG_RUN_SPEED   --5
        inst.components.locomotor.walkspeed = PIG_WALK_SPEED --3	

        -- boat hopping setup
        inst.components.locomotor:SetAllowPlatformHopping(true)
        inst:AddComponent("embarker")

        ------------------------------------------
        inst:AddComponent("eater")
        inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
        inst.components.eater:SetCanEatHorrible()
        inst.components.eater:SetCanEatRaw()
        inst.components.eater.strongstomach = true -- can eat monster meat!
        inst.components.eater:SetOnEatFn(OnEat)

        ------------------------------------------
        inst:AddComponent("combat")
        inst.components.combat.hiteffectsymbol = "pig_torso"

        MakeMediumBurnableCharacter(inst, "pig_torso")

        inst:AddComponent("named")

        local names = {}
        if sex and sex == "QUEEN" then --Runar: 女王只随女王的名称列表,这个函数里面有很多重复代码不知道怎么删
            inst.female = true
            for i, name in ipairs(STRINGS.CITYPIGNAMES["QUEEN"]) do
                table.insert(names, name)
            end
        else
            for i, name in ipairs(STRINGS.CITYPIGNAMES["UNISEX"]) do
                table.insert(names, name)
            end

            if sex then
                inst.female = sex ~= "MALE"

                for i, name in ipairs(STRINGS.CITYPIGNAMES[sex]) do
                    table.insert(names, name)
                end
            end
        end

        inst.components.named.possiblenames = names
        inst.components.named:PickNewName()

        inst:AddComponent("follower")
        inst.components.follower.maxfollowtime = PIG_LOYALTY_MAXTIME

        ------------------------------------------
        inst:AddComponent("health")
        inst:AddComponent("sleeper")
        inst:AddComponent("inventory")
        inst.components.inventory:DisableDropOnDeath()
        inst:AddComponent("lootdropper")
        inst:AddComponent("knownlocations")
        inst:AddComponent("citypossession")
        --        inst:AddComponent("citypooper")
        ------------------------------------------

        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(ShouldAcceptItem)
        inst.components.trader.onaccept = OnGetItemFromPlayer
        inst.components.trader.onrefuse = OnRefuseItem

        ------------------------------------------

        inst:AddComponent("sanityaura")
        inst.components.sanityaura.aurafn = CalcSanityAura

        ------------------------------------------
        MakeMediumFreezableCharacter(inst, "pig_torso")
        --------------------------------------------

        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = function(inst)
            if inst:HasTag("guard") then
                return "GUARD"
            elseif inst.components.follower.leader ~= nil then
                return "FOLLOWER"
            end
        end

        if econprefab then
            inst.econprefab = econprefab
            inst.components.inspectable.nameoverride = econprefab
        end
        ------------------------------------------

        inst.special_action = function(act)
            if inst.daily_gifting then
                inst.sg:GoToState("daily_gift")
            elseif inst.poop_tip then
                inst.sg:GoToState("poop_tip")
            elseif inst:HasTag("paytax") then
                inst.sg:GoToState("pay_tax")
            end
        end

        ------------------------------------------
        inst.OnSave = function(inst, data)
            data.build = inst.build

            data.children = {}
            -- for the shopkeepers if they have spawned their desk
            if inst.desk then
                print("SAVING THE DESK")
                table.insert(data.children, inst.desk.GUID)
                data.desk = inst.desk.GUID
            end

            if inst.daily_gift then
                data.daily_gift = inst.daily_gift
            end

            if inst.torch then
                table.insert(data.children, inst.torch.GUID)
                data.torch = inst.torch.GUID
            end
            if inst.axe then
                table.insert(data.children, inst.axe.GUID)
                data.axe = inst.axe.GUID
            end

            if inst:HasTag("atdesk") then
                data.atdesk = true
            end
            if inst:HasTag("guards_called") then
                data.guards_called = true
            end
            if inst.task_guard1 or inst.task_guard2 then
                --print("SAVING GUARD TASKS")
                data.doSpawnGuardTask = true
            end
            -- end shopkeeper stuff

            if inst:HasTag("angry_at_player") then
                data.angryatplayer = true
            end

            if inst.equipped then
                data.equipped = true
            end

            if inst:HasTag("recieved_trinket") then
                data.recieved_trinket = true
            end

            if inst:HasTag("paytax") then
                data.paytax = true
            end

            if data.children and #data.children > 0 then
                return data.children
            end
        end

        inst.OnLoad = function(inst, data)
            if data then
                inst.build = data.build or builds[1]
                if data.atdesk then
                    inst.sg:GoToState("desk_pre")
                end

                if data.guards_called then
                    inst:AddTag("guards_called")
                end

                --                if data.doSpawnGuardTask then
                --                    spawnguardtasks(inst,ThePlayer)
                --                end

                if data.equipped then
                    inst.equipped = true
                    inst.equiptask:Cancel()
                    inst.equiptask = nil
                end

                if data.daily_gift then
                    inst.daily_gift = data.daily_gift
                end

                if data.angryatplayer then
                    inst:AddTag("angry_at_player")
                end
                if data.recieved_trinket then
                    inst:AddTag("recieved_trinket")
                end
                if data.paytax then
                    inst:AddTag("paytax")
                end
            end
        end

        inst.OnLoadPostPass = function(inst, ents, data)
            if data then
                if data.children then
                    for k, v in pairs(data.children) do
                        local item = ents[v]
                        if item then
                            if data.desk and data.desk == v then
                                inst.desk = item.entity
                                inst:AddComponent("homeseeker")
                                inst.components.homeseeker:SetHome(inst.desk)
                            end
                        end
                    end
                end
            end
        end

        inst:ListenForEvent("attacked", OnAttacked)

        inst.throwcrackers = throwcrackers
        SetNormalPig(inst)

        if fixer then
            inst:AddComponent("fixer")
        end

        inst:WatchWorldState("isday", function() if inst:HasTag("troqueihoje") then inst:RemoveTag("troqueihoje") end end)

        return inst
    end

    ----------------------------------------------------------------------------------------

    local function make_pig_guard()
        local inst = make_common()

        inst:AddTag("emote_nocurtsy")
        inst:AddTag("guard")
        inst:AddTag("extinguisher")

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.inventory:DisableDropOnDeath()




        inst.components.lootdropper:SetLoot({ "halberd" })


        inst:RemoveComponent("sleeper")
        inst.components.burnable:SetBurnTime(2)

        inst.equiptask = inst:DoTaskInTime(0, function()
            if not inst.equipped then
                inst.equipped = true

                --                local torch = SpawnPrefab("torch")
                --                inst.components.inventory:GiveItem(torch)
                --                torch.components.fueled.unlimited_fuel = true

                if inst.prefab == "pig_eskimo" then
                    local axe = SpawnPrefab("spear")
                    inst.components.inventory:GiveItem(axe)
                    inst.components.inventory:Equip(axe)

                    local hat = SpawnPrefab("beefalohat")
                    inst.components.inventory:GiveItem(hat)
                    inst.components.inventory:Equip(hat)
                else
                    local axe = SpawnPrefab("halberd")
                    inst.components.inventory:GiveItem(axe)
                    inst.components.inventory:Equip(axe)
                end


                local armour = SpawnPrefab("armorwood")
                if armour then
                    inst.components.inventory:GiveItem(armour)
                    inst.components.inventory:Equip(armour)
                end
            end
        end)
        inst:WatchWorldState("startday", function(inst)
            if inst.prefab == "pig_eskimo" then
                local axe = inst.components.inventory:FindItem(function(item)
                    if item.prefab == "spear" then return true end
                end)
                if not axe then axe = SpawnPrefab("spear") end
                if axe then inst.components.inventory:Equip(axe) end
            else
                local axe = inst.components.inventory:FindItem(
                    function(item)
                        if item.prefab == "halberd" then return true end
                    end)
                if not axe then axe = SpawnPrefab("halberd") end
                if axe then inst.components.inventory:Equip(axe) end
            end
        end)

        inst:WatchWorldState("isnight", function()
            local function getspeech()
                return STRINGS.CITY_PIG_GUARD_LIGHT_TORCH.DEFAULT
                    [math.random(#STRINGS.CITY_PIG_GUARD_LIGHT_TORCH.DEFAULT)]
            end
            inst.sayline(inst, getspeech())
            --inst.components.talker:Say(getspeech(), 1.5, nil, true)
            --local torch = inst.components.inventory:FindItem(function(item)
            --if item.prefab == "torch" then return true end end)
            --if not torch then torch = SpawnPrefab("torch") end
            --if torch then inst.components.inventory:Equip(torch) end
        end)

        local brain = require "brains/royalpigguardbrain"
        inst:SetBrain(brain)
        return inst
    end

    local function make_shopkeeper()
        local inst = CreateEntity()
        local trans = inst.entity:AddTransform()
        local anim = inst.entity:AddAnimState()
        local sound = inst.entity:AddSoundEmitter()
        local shadow = inst.entity:AddDynamicShadow()
        inst.entity:AddNetwork()

        shadow:SetSize(1.5, .75)

        inst.Transform:SetFourFaced()

        inst.entity:AddLightWatcher()

        inst:AddComponent("talker")
        inst.components.talker.ontalk = ontalk
        inst.components.talker.donetalkingfn = ontalkfinish
        inst.components.talker.fontsize = 35
        inst.components.talker.font = TALKINGFONT
        inst.components.talker.offset = Vector3(0, -600, 0)
        inst.talkertype = name

        inst.sayline = sayline

        --inst.components.talker.colour = Vector3(133/255, 140/255, 167/255)

        MakeCharacterPhysics(inst, 50, .5)

        --        MakePoisonableCharacter(inst)

        inst:AddTag("character")
        inst:AddTag("pig")
        inst:AddTag("civilized")
        inst:AddTag("scarytoprey")

        inst:AddTag("city_pig")

        inst.AnimState:AddOverrideBuild("townspig_shop_wip")
        inst:AddTag("shopkeep")
        inst.separatedesk = separatedesk
        inst.shopkeeper_speech = shopkeeper_speech

        if tags then
            for i, tag in ipairs(tags) do
                inst:AddTag(tag)
            end
        end

        anim:SetBank("townspig")
        anim:SetBuild(build)

        anim:PlayAnimation("idle_loop", true)
        anim:Hide("hat")
        anim:Hide("desk")
        anim:Hide("ARM_carry")
        inst.daily_gift = 0

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("locomotor")                       -- locomotor must be constructed before the stategraph
        inst.components.locomotor.runspeed = PIG_RUN_SPEED   --5
        inst.components.locomotor.walkspeed = PIG_WALK_SPEED --3		

        ------------------------------------------
        inst:AddComponent("eater")
        inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
        inst.components.eater:SetCanEatHorrible()
        inst.components.eater:SetCanEatRaw()
        inst.components.eater.strongstomach = true -- can eat monster meat!
        inst.components.eater:SetOnEatFn(OnEat)

        ------------------------------------------
        inst:AddComponent("combat")
        inst.components.combat.hiteffectsymbol = "pig_torso"

        MakeMediumBurnableCharacter(inst, "pig_torso")

        inst:AddComponent("named")

        local names = {}
        if sex and sex == "QUEEN" then
            inst.female = true
            for i, name in ipairs(STRINGS.CITYPIGNAMES["QUEEN"]) do
                table.insert(names, name)
            end
        else
            for i, name in ipairs(STRINGS.CITYPIGNAMES["UNISEX"]) do
                table.insert(names, name)
            end

            if sex then
                if sex == "MALE" then
                    inst.female = false
                else
                    inst.female = true
                end

                for i, name in ipairs(STRINGS.CITYPIGNAMES[sex]) do
                    table.insert(names, name)
                end
            end
        end

        inst.components.named.possiblenames = names
        inst.components.named:PickNewName()

        inst:AddComponent("follower")
        inst.components.follower.maxfollowtime = PIG_LOYALTY_MAXTIME

        ------------------------------------------
        inst:AddComponent("health")
        inst:AddComponent("sleeper")
        inst:AddComponent("inventory")
        inst:AddComponent("lootdropper")
        inst:AddComponent("knownlocations")
        inst:AddComponent("citypossession")
        --        inst:AddComponent("citypooper")
        ------------------------------------------

        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(ShouldAcceptItem)
        inst.components.trader.onaccept = OnGetItemFromPlayer
        inst.components.trader.onrefuse = OnRefuseItem

        ------------------------------------------

        inst:AddComponent("sanityaura")
        inst.components.sanityaura.aurafn = CalcSanityAura

        ------------------------------------------
        MakeMediumFreezableCharacter(inst, "pig_torso")
        --------------------------------------------

        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = function(inst)
            if inst:HasTag("guard") then
                return "GUARD"
            elseif inst.components.follower.leader ~= nil then
                return "FOLLOWER"
            end
        end

        if econprefab then
            inst.econprefab = econprefab
            inst.components.inspectable.nameoverride = econprefab
        end
        ------------------------------------------

        inst.special_action = function(act)
            if inst.daily_gifting then
                inst.sg:GoToState("daily_gift")
            elseif inst.poop_tip then
                inst.sg:GoToState("poop_tip")
            elseif inst:HasTag("paytax") then
                inst.sg:GoToState("pay_tax")
            end
        end

        ------------------------------------------
        inst.OnSave = function(inst, data)
            data.build = inst.build

            data.children = {}
            -- for the shopkeepers if they have spawned their desk
            if inst.desk then
                print("SAVING THE DESK")
                table.insert(data.children, inst.desk.GUID)
                data.desk = inst.desk.GUID
            end

            if inst.torch then
                table.insert(data.children, inst.torch.GUID)
                data.torch = inst.torch.GUID
            end
            if inst.axe then
                table.insert(data.children, inst.axe.GUID)
                data.axe = inst.axe.GUID
            end

            if inst.daily_gift then
                data.daily_gift = inst.daily_gift
            end

            if inst:HasTag("atdesk") then
                data.atdesk = true
            end
            if inst:HasTag("guards_called") then
                data.guards_called = true
            end
            if inst.task_guard1 or inst.task_guard2 then
                print("SAVING GUARD TASKS")
                data.doSpawnGuardTask = true
            end
            -- end shopkeeper stuff

            if inst:HasTag("angry_at_player") then
                data.angryatplayer = true
            end

            if inst.equipped then
                data.equipped = true
            end

            if inst:HasTag("recieved_trinket") then
                data.recieved_trinket = true
            end

            if inst:HasTag("paytax") then
                data.paytax = true
            end

            if data.children and #data.children > 0 then
                return data.children
            end
        end

        inst.OnLoad = function(inst, data)
            if data then
                inst.build = data.build or builds[1]
                if data.atdesk then
                    inst.sg:GoToState("desk_pre")
                end

                if data.guards_called then
                    inst:AddTag("guards_called")
                end

                --                if data.doSpawnGuardTask then
                --                    spawnguardtasks(inst,ThePlayer)
                --                end

                if data.equipped then
                    inst.equipped = true
                    inst.equiptask:Cancel()
                    inst.equiptask = nil
                end

                if data.daily_gift then
                    inst.daily_gift = data.daily_gift
                end

                if data.angryatplayer then
                    inst:AddTag("angry_at_player")
                end
                if data.recieved_trinket then
                    inst:AddTag("recieved_trinket")
                end
                if data.paytax then
                    inst:AddTag("paytax")
                end
            end
        end

        inst.OnLoadPostPass = function(inst, ents, data)
            if data then
                if data.children then
                    for k, v in pairs(data.children) do
                        local item = ents[v]
                        if item then
                            if data.desk and data.desk == v then
                                inst.desk = item.entity
                                inst:AddComponent("homeseeker")
                                inst.components.homeseeker:SetHome(inst.desk)
                            end
                        end
                    end
                end
            end
        end

        inst:ListenForEvent("attacked", OnAttacked)

        inst.throwcrackers = throwcrackers
        SetNormalPig(inst)

        if fixer then
            inst:AddComponent("fixer")
        end

        inst:DoTaskInTime(0, function() inst.desklocation = Vector3(inst.Transform:GetWorldPosition()) end)

        TheWorld:ListenForEvent("enterroom",
            function(data) shopkeeper_speech(inst, getSpeechType(inst, STRINGS.CITY_PIG_SHOPKEEPER_GREETING)) end) --  getSpeechType(inst,speech) -- [math.random(1,#STRINGS.CITY_PIG_SHOPKEEPER_GREETING)]
        inst:WatchWorldState("isnight", function() closeshop(inst) end)

        inst.special_action = function(act)
            inst.sg:GoToState("desk_pre")
        end

        return inst
    end

    local function make_mechanic()
        local inst = make_common()

        if not TheWorld.ismastersim then
            return inst
        end

        if not inst.components.inventory then
            inst:AddComponent("inventory")
        end

        if not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
            inst.components.inventory:Equip(SpawnPrefab("hammer"))
        end

        return inst
    end

    local function make_queen()
        local inst = make_common()
        MakeCharacterPhysics(inst, 50, 0.75)
        if not TheWorld.ismastersim then
            return inst
        end
        inst.components.trader.deleteitemonaccept = false
        inst.components.named.possiblenames = STRINGS.QUEENPIGNAMES
        inst.components.named:PickNewName()

        return inst
    end

    --------------------------------------------------------------------------

    if name == "pigman_queen" then
        return make_queen
    end

    if name == "pigman_mechanic" then
        return make_mechanic
    end

    if shopkeeper or name == "pigman_shopkeep" then
        return make_shopkeeper
    end

    if guard_pig then
        return make_pig_guard
    end

    return make_common
end

local function makepigman(name, build, fixer, guard_pig, shopkeeper, tags, sex, econprefab)
    return Prefab("common/objects/" .. name, makefn(name, build, fixer, guard_pig, shopkeeper, tags, sex, econprefab),
        assets, prefabs)
end

--                      name                        build         fixer  guard shop tags               sex
return
    makepigman("pigman_beautician", "pig_beautician", nil, nil, nil, nil, "FEMALE"),
    makepigman("pigman_florist", "pig_florist", nil, nil, nil, nil, "FEMALE"),
    makepigman("pigman_erudite", "pig_erudite", nil, nil, nil, { "emote_nohat" }, "FEMALE"),
    makepigman("pigman_hatmaker", "pig_hatmaker", nil, nil, nil, nil, "FEMALE"),
    makepigman("pigman_storeowner", "pig_storeowner", nil, nil, nil, { "emote_nohat" }, "FEMALE"),
    makepigman("pigman_banker", "pig_banker", nil, nil, nil, { "emote_nohat" }, "MALE"),
    makepigman("pigman_collector", "pig_collector", nil, nil, nil, nil, "MALE"),
    makepigman("pigman_hunter", "pig_hunter", nil, nil, nil, nil, "MALE"),
    makepigman("pigman_mayor", "pig_mayor", nil, nil, nil, nil, "MALE"),
    makepigman("pigman_mechanic", "pig_mechanic", true, nil, nil, nil, "MALE"),
    makepigman("pigman_professor", "pig_professor", nil, nil, nil, { "emote_nohat" }, "MALE"),
    makepigman("pigman_usher", "pig_usher", nil, nil, nil, { "emote_nohat" }, "MALE"),
    makepigman("pigman_royalguard", "pig_royalguard", nil, true, nil, nil, "MALE"),
    makepigman("pigman_royalguard_2", "pig_royalguard_2", nil, true, nil, nil, "MALE"),
    makepigman("pigman_farmer", "pig_farmer", nil, nil, nil, nil, "MALE"),
    makepigman("pigman_miner", "pig_miner", nil, nil, nil, nil, "MALE"),
    makepigman("pigman_queen", "pig_queen", nil, nil, nil, { "pigqueen", "emote_nohat" }, "QUEEN"),
    makepigman("pigman_beautician_shopkeep", "pig_beautician", nil, nil, true, nil, "FEMALE", "pigman_beautician"),
    makepigman("pigman_florist_shopkeep", "pig_florist", nil, nil, true, nil, "FEMALE", "pigman_florist"),
    makepigman("pigman_erudite_shopkeep", "pig_erudite", nil, nil, true, { "emote_nohat" }, "FEMALE", "pigman_erudite"),
    makepigman("pigman_hatmaker_shopkeep", "pig_hatmaker", nil, nil, true, nil, "FEMALE", "pigman_hatmaker"),
    makepigman("pigman_storeowner_shopkeep", "pig_storeowner", nil, nil, true, { "emote_nohat" }, "FEMALE",
        "pigman_storeowner"),
    makepigman("pigman_banker_shopkeep", "pig_banker", nil, nil, true, { "emote_nohat" }, "MALE", "pigman_banker"),
    makepigman("pigman_shopkeep", "pig_banker", nil, nil, true, nil, "MALE", "pigman_banker"), -- default
    makepigman("pigman_hunter_shopkeep", "pig_hunter", nil, nil, true, nil, "MALE", "pigman_hunter"),
    makepigman("pigman_mayor_shopkeep", "pig_mayor", nil, nil, true, nil, "MALE", "pigman_mayor"),
    makepigman("pigman_farmer_shopkeep", "pig_farmer", nil, nil, true, nil, "MALE", "pigman_farmer"),
    makepigman("pigman_miner_shopkeep", "pig_miner", nil, nil, true, nil, "MALE", "pigman_miner"),
    makepigman("pigman_collector_shopkeep", "pig_collector", nil, nil, true, nil, "MALE", "pigman_collector"),
    makepigman("pigman_professor_shopkeep", "pig_professor", nil, nil, true, { "emote_nohat" }, "MALE",
        "pigman_professor"),
    makepigman("pigman_mechanic_shopkeep", "pig_mechanic", nil, nil, true, nil, "MALE", "pigman_mechanic"),
    makepigman("pigman_eskimo_shopkeep", "pig_eskimo", nil, nil, true, nil, "MALE", "pig_eskimo"),
    makepigman("pig_shopkeeper", "pig_shopkeeper", nil, nil, nil, nil, "MALE"),
    makepigman("pig_royalguard_rich", "pig_royalguard_rich", nil, true, nil, nil, "MALE"),
    makepigman("pig_royalguard_rich_2", "pig_royalguard_rich_2", nil, true, nil, nil, "MALE"),
    makepigman("pigman_royalguard_3", "pig_royalguard_3", nil, true, nil, nil, "MALE"),
    makepigman("pig_eskimo", "pig_eskimo", nil, true, nil, nil, "MALE")
