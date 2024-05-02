--@author: 绯世行
--欢迎其他开发者直接使用，但是强烈谴责搬用代码后对搬用代码加密的行为！
--使用案例及最新版：https://n77a3mjegs.feishu.cn/docx/K9bUdpb5Qo85j2xo8XkcOsU1nuh?from=from_copylink

local FN = {}

local _source = debug.getinfo(1, 'S').source
local KEY = "_" .. _source:match(".*scripts[/\\](.*)%.lua"):gsub("[/\\]", "_") .. "_"

local Utils = require(_source:match(".*scripts[/\\](.*[/\\])") .. "utils")
local Shapes = require(_source:match(".*scripts[/\\](.*[/\\])") .. "shapes")
local Timer = require(_source:match(".*scripts[/\\](.*[/\\])") .. "timer")

local DEBUG_MODE = BRANCH == "dev"

---隐藏，停止一切活动，来自inventoryitem
function FN.Hide(inst)
    inst:RemoveFromScene()
    if inst.Transform then
        inst.Transform:SetPosition(0, 0, 0)
    end
    if inst.components.brain then
        BrainManager:Hibernate(inst)
    end
    if inst.SoundEmitter then
        inst.SoundEmitter:KillAllSounds()
    end
end

---显示，来自inventoryitem，与Hide配套使用
function FN.Show(inst)
    inst:ReturnToScene()
    if inst.components.brain then
        BrainManager:Wake(self.inst)
    end
end

--- 查找leader，如果leader不存在则查找物品的持有者
---@param inst Entity
---@param isFindInventory boolean|nil 如果为true，则继续查找该物品的持有者，当leader是一个物品时有效
function FN.GetLeader(inst, isFindInventory)
    local leader = inst.components.follower and inst.components.follower.leader or
        inst.components.inventoryitem and inst.components.inventoryitem:GetGrandOwner()

    if isFindInventory then
        leader = leader and leader.components.inventoryitem and leader.components.inventoryitem:GetGrandOwner()
    end
    return leader
end

--- 获取equipslot，支持主机客机
function FN.GetEquipslot(inst)
    return inst.components.equippable and inst.components.equippable.equipslot
        or inst.replica.equippable and inst.replica.equippable:EquipSlot()
end

---卸下装备的重物
function FN.ForceStopHeavyLifting(inst)
    if inst.components.inventory and inst.components.inventory:IsHeavyLifting() then
        inst.components.inventory:DropItem(inst.components.inventory:Unequip(EQUIPSLOTS.BODY), true, true)
    end
end

---添加特效
---@param data table{scale, offset, shatterfx}
---@param data table|nil
function FN.AddFx(inst, fxName, data)
    local fx = SpawnPrefab(fxName)
    if fx ~= nil then
        --fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        if data then
            if data.scale then
                fx.Transform:SetScale(unpack(data.scale))
            end

            if data.offset then
                data.offset = ToVector3(data.offset) or Vector3(0, 0, 0)
                fx.Transform:SetPosition(data.offset:Get())
            end

            if data.shatterfx ~= nil and fx.components.shatterfx ~= nil then
                fx.components.shatterfx:SetLevel(data.shatterfx)
            end
        end
        inst:AddChild(fx)
    end
    return fx
end

---生成预制体，不过如果需求不多，可以用科雷自带的SpawnAt(prefab, loc, scale, offset)
---@param data table {pos, scale, rotation, addColour, multColour}
function FN.GetPrefab(name, data)
    local inst = SpawnPrefab(name)
    if data then
        if inst.Transform then
            if data.pos then
                inst.Transform:SetPosition(data.pos.x, data.pos.y, data.pos.z)
            end
            if data.scale then
                inst.Transform:SetScale(unpack(data.scale))
            end
            if data.rotation then
                inst.Transform:SetRotation(data.rotation)
            end
        end
        if inst.AnimState then
            if data.addColour then
                inst.AnimState:SetAddColour(unpack(data.addColour))
            end
            if data.multColour then
                inst.AnimState:SetMultColour(unpack(data.multColour)) --4元素数组，rgba
            end
        end
    end

    return inst
end

---自定义爆炸对象，改编自explosive.lua
---@param data table|nil {attacker, explosiveDamage, planarDamage, workDamage, range, MUST_TAGS, CANT_TAGS,findFn,containDock,skipCameraFlash,lightOnExplode}
---{攻击者，爆炸伤害，位面伤害，工作伤害，爆炸范围，MUST_TAGS，CANT_TAGS，校验函数，是否影响甲板，是否跳过画面闪烁，是否点燃对象}
function FN.GetBombExplode(pos, data)
    local world = TheWorld
    local x, y, z = pos.x, pos.y, pos.z
    local attacker = Utils.GetVal(data, "attacker", TheWorld)        --攻击者
    local totaldamage = Utils.GetVal(data, "explosiveDamage", 200)   --爆炸伤害
    local spdmg = { planar = Utils.GetVal(data, "planarDamage", 0) } --位面伤害
    local workDamage = Utils.GetVal(data, "workDamage", 10)          --工作伤害
    local range = Utils.GetVal(data, "range", 3)                     --爆炸范围
    local MUST_TAGS = Utils.GetVal(data, "MUST_TAGS")                --MUST_TAGS
    local CANT_TAGS = Utils.GetVal(data, "CANT_TAGS", { "INLIMBO" }) --CANT_TAGS
    local findFn = Utils.GetVal(data, "findFn")                      --校验函数
    local containDock = Utils.GetVal(data, "containDock")            --是否影响甲板
    local cameraFlash = Utils.GetVal(data, "cameraFlash")            --画面闪烁，一般爆炸效果有的
    local lightOnExplode = Utils.GetVal(data, "lightOnExplode")      --是否点燃对象
    local onAttackOther = Utils.GetVal(data, "onAttackOther")        --攻击后回调

    --画面闪烁
    if cameraFlash then
        for i, v in ipairs(AllPlayers) do
            local distSq = attacker ~= TheWorld and v:GetDistanceSqToInst(attacker) or 0
            local k = math.max(0, math.min(1, distSq / 400))
            local intensity = k * 0.75 * (k - 2) + 0.75 --easing.outQuad(k, 1, -1, 1)
            if intensity > 0 then
                v:ScreenFlash(intensity)
                v:ShakeCamera(CAMERASHAKE.FULL, .7, .02, intensity / 2)
            end
        end
    end

    if containDock then
        if world.components.dockmanager ~= nil then
            world.components.dockmanager:DamageDockAtPoint(x, y, z, totaldamage)
        end
    end

    local ents = TheSim:FindEntities(x, y, z, range, MUST_TAGS, CANT_TAGS)
    for i, v in ipairs(ents) do
        if not v:IsInLimbo() and v:IsValid() and (not findFn or findFn(v)) then
            --工作
            if workDamage > 0 and v.components.workable ~= nil and v.components.workable:CanBeWorked() then
                v.components.workable:WorkedBy(attacker, workDamage)
            end

            --Recheck valid after work
            if not v:IsInLimbo() and v:IsValid() then
                --点燃
                if lightOnExplode and
                    v.components.fueled == nil and
                    v.components.burnable ~= nil and
                    not v.components.burnable:IsBurning() and
                    not v:HasTag("burnt") then
                    v.components.burnable:Ignite()
                end

                if v.components.combat ~= nil and not (v.components.health ~= nil and v.components.health:IsDead()) then
                    local dmg = totaldamage
                    if v.components.explosiveresist ~= nil then
                        dmg = dmg * (1 - v.components.explosiveresist:GetResistance())
                        v.components.explosiveresist:OnExplosiveDamage(dmg, attacker)
                    end

                    --V2C: still passing self.inst instead of attacker here, so we don't
                    --     use attacker for calculating damage mods.
                    v.components.combat:GetAttacked(attacker, dmg, nil, nil, spdmg) -- NOTES(JBK): The component combat might remove itself in the GetAttacked callback!
                    if onAttackOther then
                        onAttackOther(attacker, v)
                    end

                    if attacker ~= world and v.components.combat ~= nil and not (v.components.health ~= nil and v.components.health:IsDead()) and v:IsValid() then
                        if attacker:IsValid() then
                            v.components.combat:SuggestTarget(attacker)
                        else
                            attacker = nil
                        end
                    end
                end

                v:PushEvent("explosion", { explosive = world })
            end
        end
    end

    world:PushEvent("explosion", { damage = totaldamage })
end

---单位是否可以被恐惧
function FN.CanPanic(target)
    if target.components.hauntable ~= nil and target.components.hauntable.panicable or target.has_nightmare_state then
        return true
    end
end

-- TODO boss的专属恐惧组件epicscare，也许可以研究一下，不过可能没法恐惧boss
---恐惧逻辑代码，来自panic.lua，这里是专门针对没有hauntable组件的单位让其强行逃窜，在onfinish中已经重新启动brain，因此在Cancel任务后不需要手动再调用brain:Start
---@param data {time}
---@return table 返回结束恐惧的Periodic对象
function FN.ForcePanicCreature(inst, data)
    if not (inst and inst.components.locomotor) then return end
    local time = Utils.GetVal(data, "time", 12)

    if inst.brain then
        inst.brain:Stop()
    end

    local t = inst:DoTaskInTime(time, function(ins, task)
        task:Cancel()
    end, inst:DoPeriodicTask(.25 + math.random() * .25, function()
        inst.components.locomotor:RunInDirection(math.random() * 360)
    end, 0))
    t.onfinish = function(task, success, arg)
        -- cancel了也要恢复
        if inst.brain then
            inst.brain:Start()
        end
    end

    return t
end

---恐惧周围单位，来自暗影秘典，默认只有有hauntable组件的生物会被恐惧
---@param targets table 要排除的对象表，键为对象
---@param data {radius, MUST_TAGS, NO_TAGS, ONE_OF_TAGS, panicTime,speedMulKey, speedMul,noPanicTargetFn}
---{半径，必须标签，禁止标签，任意之一标签，恐惧时间，恐惧移速倍率影响的key，被恐惧后的移速倍率，对不能被恐惧对象的处理 返回true就记录targets表中}
function FN.TryTrapTarget(inst, targets, data)
    local TARGET_RADIUS = Utils.GetVal(data, "radius", 6)
    local MUST_TAGS = Utils.GetVal(data, "MUST_TAGS")
    local NO_TAGS = Utils.GetVal(data, "NO_TAGS",
        { "epic", "notraptrigger", "ghost", "player", "INLIMBO", "flight", "invisible", "notarget" })
    local ONE_OF_TAGS = Utils.GetVal(data, "ONE_OF_TAGS", { "monster", "character", "animal", "smallcreature" })
    local panicTime = Utils.GetVal(data, "panicTime", 12)
    local speedMul = Utils.GetVal(data, "speedMul", 2 / 3)
    local noPanicTargetFn = Utils.GetVal(data, "noPanicTargetFn")

    local x, y, z = inst.Transform:GetWorldPosition()
    for i, v in ipairs(TheSim:FindEntities(x, 0, z, TARGET_RADIUS, MUST_TAGS, NO_TAGS, ONE_OF_TAGS)) do
        if not (targets and targets[v]) and not (v.components.health ~= nil and v.components.health:IsDead()) and v.entity:IsVisible() then
            if FN.CanPanic(v) then
                local speedMulKey = inst.prefab .. v.prefab
                if data then
                    speedMulKey = data.speedMulKey or speedMulKey
                end

                if targets then
                    targets[v] = true
                end

                local x1, y1, z1 = v.Transform:GetWorldPosition()
                local fx = SpawnPrefab("shadow_despawn")
                local platform = v:GetCurrentPlatform()
                if platform ~= nil then
                    fx.entity:SetParent(platform.entity)
                    fx.Transform:SetPosition(platform.entity:WorldToLocalSpace(x1, y1, z1))
                    fx:ListenForEvent("onremove", function()
                        fx.Transform:SetPosition(fx.Transform:GetWorldPosition())
                        fx.entity:SetParent(nil)
                    end, platform)
                else
                    fx.Transform:SetPosition(x1, y1, z1)
                end
                if v.has_nightmare_state then
                    v:PushEvent("ms_forcenightmarestate",
                        { duration = TUNING.SHADOW_TRAP_NIGHTMARE_TIME + math.random() })
                end
                if not (v.sg ~= nil and v.sg:HasStateTag("noattack")) then
                    v:PushEvent("attacked", { attacker = nil, damage = 0 })
                end
                if not v.has_nightmare_state and v.components.hauntable ~= nil and v.components.hauntable.panicable then
                    v.components.hauntable:Panic(panicTime)
                    if v.components.locomotor ~= nil then
                        if v._shadow_trap_task ~= nil then
                            v._shadow_trap_task:Cancel()
                        else
                            v._shadow_trap_fx = SpawnPrefab("shadow_trap_debuff_fx")
                            v._shadow_trap_fx.entity:SetParent(v.entity)
                            v._shadow_trap_fx:OnSetTarget(v)
                        end
                        v._shadow_trap_task = v:DoTaskInTime(panicTime, function(target)
                            target._shadow_trap_task = nil
                            target._shadow_trap_fx:KillFX()
                            target._shadow_trap_fx = nil
                            if target.components.locomotor ~= nil then
                                target.components.locomotor:RemoveExternalSpeedMultiplier(target, speedMulKey)
                            end
                        end)
                        v.components.locomotor:SetExternalSpeedMultiplier(v, speedMulKey, speedMul)
                    end
                end
            else
                --不能被恐惧的
                if noPanicTargetFn and data.noPanicTargetFn(v) then
                    if targets then
                        targets[v] = true
                    end
                end
            end
        end
    end
end

function FN.ResetPeriodicTask(inst, taskName, ...)
    if inst[taskName] then
        inst[taskName]:Cancel()
        inst:DoPeriodicTask(...)
    end
end

local function UpdateRepel(inst, x, z, creatures, radius)
    local REPEL_RADIUS_SQ = radius * radius
    for i = #creatures, 1, -1 do
        local v = creatures[i]
        if not (v.inst:IsValid() and v.inst.entity:IsVisible()) then
            table.remove(creatures, i)
        elseif v.speed == nil then
            local distsq = v.inst:GetDistanceSqToPoint(x, 0, z)
            if distsq < REPEL_RADIUS_SQ then
                if distsq > 0 then
                    v.inst:ForceFacePoint(x, 0, z)
                end
                local k = .5 * distsq / REPEL_RADIUS_SQ - 1
                v.speed = 25 * k
                v.dspeed = 2
                v.inst.Physics:SetMotorVelOverride(v.speed, 0, 0)
            end
        else
            v.speed = v.speed + v.dspeed
            if v.speed < 0 then
                local x1, y1, z1 = v.inst.Transform:GetWorldPosition()
                if x1 ~= x or z1 ~= z then
                    v.inst:ForceFacePoint(x, 0, z)
                end
                v.dspeed = v.dspeed + .25
                v.inst.Physics:SetMotorVelOverride(v.speed, 0, 0)
            else
                v.inst.Physics:ClearMotorVelOverride()
                v.inst.Physics:Stop()
                table.remove(creatures, i)
            end
        end
    end
end

local function TimeoutRepel(inst, creatures, task)
    if task then
        task:Cancel()
    end
    for i, v in ipairs(creatures) do
        if v.speed ~= nil then
            v.inst.Physics:ClearMotorVelOverride()
            v.inst.Physics:Stop()
        end
    end
end

---击退其他单位，来自暗影编织者的护盾特效stalker_shield.lua
---@param data{pos, radius, MUST_TAGS, CANT_TAGS, damage}
function FN.StartRepel(inst, data)
    local pos = Utils.GetVal(data, "pos", inst:GetPosition())
    local radius = Utils.GetVal(data, "radius", 3)
    local MUST_TAGS = Utils.GetVal(data, "MUST_TAGS", { "locomotor" })
    local CANT_TAGS = Utils.GetVal(data, "CANT_TAGS", { "fossil", "shadow", "playerghost", "INLIMBO" })
    local damage = Utils.GetVal(data, "damage", 10)

    local creatures = {}
    for i, v in ipairs(TheSim:FindEntities(pos.x, pos.y, pos.z, radius, MUST_TAGS, CANT_TAGS)) do
        if v:IsValid() and v.entity:IsVisible() and not (v.components.health ~= nil and v.components.health:IsDead()) then
            if v:HasTag("player") then
                v:PushEvent("repelled", { repeller = inst, radius = radius })
            elseif v.components.combat ~= nil then
                v.components.combat:GetAttacked(inst, damage)
                if v.Physics ~= nil then
                    table.insert(creatures, { inst = v })
                end
            end
        end
    end

    if #creatures > 0 then
        --先开启定时任务，直接把返回值作为参数传入，很简洁的写法
        inst:DoTaskInTime(10 * FRAMES, TimeoutRepel, creatures,
            inst:DoPeriodicTask(0, UpdateRepel, nil, pos.x, pos.z, creatures, radius))
    end
end

---判断是否可以嘲讽对象，来自变大的伯尼bernie_big.lua，默认会嘲讽暗影生物和攻击玩家和玩家盟友的单位
---@param data table {isContainAll, isContainShadowCreature, isContainCompanion}
function FN.IsTauntable(inst, target, data)
    if not (target.components.health ~= nil and target.components.health:IsDead())
        and target.components.combat ~= nil
        and not target.components.combat:TargetIs(inst)
        and target.components.combat:CanTarget(inst) then
        local isContainAll = Utils.GetVal(data, "isContainAll", false)
        local isContainShadowCreature = Utils.GetVal(data, "isContainShadowCreature", true)
        local isContainCompanion = Utils.GetVal(data, "isContainCompanion", true)

        return isContainAll
            or (isContainShadowCreature and target:HasTag("shadowcreature"))
            or (isContainCompanion and target.components.combat:HasTarget() and (target.components.combat.target:HasTag("player") or
                (target.components.combat.target:HasTag("companion") and target.components.combat.target.prefab ~= inst.prefab)))
    end

    return false
end

---嘲讽周围敌人，来自变大的伯尼bernie_big.lua，因此默认会嘲讽暗影生物和攻击玩家和玩家盟友的单位
---@param data table {radius, MUST_TAGS, CANT_TAGS, isTauntable}
function FN.TauntCreatures(inst, data)
    if not inst.components.health:IsDead() then
        local radius = Utils.GetVal(data, "radius", 16)
        local MUST_TAGS = Utils.GetVal(data, "MUST_TAGS", { "_combat", "locomotor" })
        local CANT_TAGS = Utils.GetVal(data, "CANT_TAGS", { "INLIMBO", "player", "companion", "epic", "notaunt" })
        local isTauntable = Utils.GetVal(data, "isTauntable", FN.IsTauntable)

        local x, y, z = inst.Transform:GetWorldPosition()
        for i, v in ipairs(TheSim:FindEntities(x, y, z, radius, MUST_TAGS, CANT_TAGS)) do
            if isTauntable(inst, v) then
                v.components.combat:SetTarget(inst)
            end
        end
    end
end

---是否是玩家的盟友
function FN.IsCompanion(target)
    local l = target.components.follower and target.components.follower.leader
    local lo = l and l.components.inventoryitem and l.components.inventoryitem:GetGrandOwner()
    local o = target.components.inventoryitem and target.components.inventoryitem:GetGrandOwner()
    return target and (
        target:HasTag("player")         --是玩家
        or (l and l:HasTag("player"))   --主人是玩家
        or (lo and lo:HasTag("player")) --主人是一个物品，但物品持有者是玩家
        or (o and o:HasTag("player"))   --是物品，但物品持有者是玩家
    )
end

---攻击对象检测，会攻击monster标签生物和当前仇恨对象，不会误伤其他单位
---攻击示例代码：
---inst.components.combat:DoAreaAttack(inst, 3, nil, function(ent, ins)
---    return Utils.TargetTest(ins, ent) and (not data.target or data.target ~= ent)
---end, nil, { "noauradamage", "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" })
---要求data.target ~= ent是因为这段代码一般写在onattackother监听事件中的
---@param isFindInstOwner boolean|nil 当inst的leader是一个物品时，需要该值为true继续查找物品的持有者作为leader
---@return boolean
function FN.TargetTest(inst, target, isFindInstOwner)
    -- print(inst and inst.prefab, target and target.prefab)
    if not target or target == inst or
        not target:IsValid()
        or target:IsInLimbo() --比如乌龟缩壳
        or (target.components.health and target.components.health:IsDead()) then
        return false
    end

    if target.components.minigame_participator ~= nil then
        return false
    end

    if (target:HasTag("player") and not TheNet:GetPVPEnabled()) or target:HasTag("noauradamage") then
        return false
    end

    local l = inst.components.follower and inst.components.follower.leader
    if isFindInstOwner then
        l = l and l.components.inventoryitem and l.components.inventoryitem:GetGrandOwner()
    end
    local t = inst.components.combat and inst.components.combat.target
    local lt = l and l.components.combat and l.components.combat.target
    local tt = target.components.combat and target.components.combat.target
    -- local tl = target.components.follower and target.components.follower.leader --我允许内乱

    if t == target              --你打对方
        or lt == target         --主人打对方
        or tt == inst           --对方打你
        or (l and tt == l) then --对方打你主人
        return true
    end

    local ismonster = target:HasTag("monster")
    if ismonster and not TheNet:GetPVPEnabled() and
        ((target.components.follower and target.components.follower.leader ~= nil and
            target.components.follower.leader:HasTag("player")) or target.bedazzled) then
        return false
    end

    if target:HasTag("companion") then
        return false
    end

    -- return ismonster or target:HasTag("prey") --不打兔子
    return ismonster
end

---攻击对象检测，非PVP下除了玩家和玩家随从（必须有follower.leader）不攻击外都攻击
function FN.ForceTargetTest(inst, target)
    if not target or target == inst or
        not target:IsValid() or target:IsInLimbo()
        or (target.components.health and target.components.health:IsDead()) then
        return false
    end

    if target.components.minigame_participator ~= nil then
        return false
    end

    if (target:HasTag("player") and not TheNet:GetPVPEnabled()) or target:HasTag("noauradamage") then
        return false
    end

    local l = target.components.follower and target.components.follower.leader
    local lo = l and l.components.inventoryitem and l.components.inventoryitem:GetGrandOwner()
    return not l or not l:HasTag("player") or (TheNet:GetPVPEnabled() and l ~= inst)
        or not lo or not lo:HasTag("player") or (TheNet:GetPVPEnabled() and lo ~= inst)
end

function FN.ForceTargetTest2(target, inst)
    return FN.ForceTargetTest(inst, target)
end

---攻击对象检测，这个是用于所有单位的通用检测，对于特殊对象无法处理
function FN.TargetTestForAll(inst, target)
    if not target or target == inst or
        not target:IsValid() or target:IsInLimbo()
        or (target.components.health and target.components.health:IsDead()) then
        return false
    end

    local ll = inst.components.follower and inst.components.follower.leader
    local tt = target.components.combat and target.components.combat.target
    local tl = target.components.follower and target.components.follower.leader

    return
        ll ~= target and tl ~= inst                                --非主仆
        and (tt == inst                                            --有仇恨
            or inst:HasTag("monster") ~= target:HasTag("monster")) --类别不同
end

---织影者骨刺禁锢，来自stalker.lua
---@param data table {attacker, target, num, radius, getPrefabFn} 攻击者，目标，预制体数量，半径，获取预制体函数  如果填写了target后radius
---可以不填，会根据目标的大小设置半径；getPrefabFn默认使用织影者的fossilspike预制体（会对玩家造成伤害）
---@return boolean 是否生成了骨刺
function FN.SpawnCage(x, z, data)
    --这几个变量是骨刺fossilspike用来决定骨刺播放动画的
    local vars = { 1, 2, 3, 4, 5, 6, 7 }
    local used = {}
    local queued = {}

    local delaytoggle = 0
    local attacker = Utils.GetVal(data, "attacker", TheWorld)
    local target = Utils.GetVal(data, "target")
    local num = Utils.GetVal(data, "num", target and target:HasTag("largecreature") and 12 or 6)
    local r = Utils.GetVal(data, "radius",
        target and (target:GetPhysicsRadius(0) + (target:HasTag("largecreature") and 1.5 or .5)) or 2)
    local getPrefabFn = Utils.GetVal(data, "getPrefabFn", function()
        local spike = SpawnPrefab("fossilspike") --织影者骨刺

        local delay = delaytoggle == 0 and 0 or .2 + delaytoggle * math.random() * .2
        delaytoggle = delaytoggle == 1 and -1 or 1

        local duration = GetRandomWithVariance(TUNING.STALKER_SNARE_TIME, TUNING.STALKER_SNARE_TIME_VARIANCE)

        local variation = table.remove(vars, math.random(#vars))
        table.insert(used, variation)
        if #used > 3 then
            table.insert(queued, table.remove(used, 1))
        end
        if #vars <= 0 then
            local swap = vars
            vars = queued
            queued = swap
        end
        spike:RestartSpike(delay, duration, variation)
    end)
    local count = 0
    local dtheta = PI * 2 / num
    local map = TheWorld.Map

    for theta = math.random() * dtheta, PI * 2, dtheta do
        --遍历一圈
        local x1 = x + r * math.cos(theta)
        local z1 = z + r * math.sin(theta)
        if map:IsPassableAtPoint(x1, 0, z1) and not map:IsPointNearHole(Vector3(x1, 0, z1)) then
            local spike = getPrefabFn()
            spike.Transform:SetPosition(x1, 0, z1)

            count = count + 1
        end
    end
    if count <= 0 then
        return false
    elseif target and target:IsValid() then
        target:PushEvent("snared", { attacker = attacker })
    end
    return true
end

---扇形攻击，来自熊大SGbearger.lua
---@param data {dist, radius, heavymult, mult, forcelanded, targets, arc, MUST_TAGS, CANT_TAGS, MAX_SIDE_TOSS_STR}
function FN.DoArcAttack(inst, data)
    local dist = Utils.GetVal(data, "dist", 0) --最短攻击距离，小于这个值的敌人打不到
    local radius = Utils.GetVal(data, "radius", 6)
    local heavymult = Utils.GetVal(data, "heavymult", 1)
    local mult = Utils.GetVal(data, "mult", 1)
    local forcelanded = Utils.GetVal(data, "forcelanded")
    local targets = Utils.GetVal(data, "targets")
    local ARC = Utils.GetVal(data, "arc", 90) * DEGREES --degrees to each side
    local MUST_TAGS = Utils.GetVal(data, "MUST_TAGS", { "_combat" })
    local CANT_TAGS = Utils.GetVal(data, "CANT_TAGS", { "INLIMBO", "flight", "invisible", "notarget", "noattack" })
    local MAX_SIDE_TOSS_STR = Utils.GetVal(data, "MAX_SIDE_TOSS_STR", 0.8)
    local validfn = Utils.GetVal(data, "validfn")
    local AOE_RANGE_PADDING = 3

    if inst.components.combat then
        inst.components.combat.ignorehitrange = true
    end
    local x, y, z = inst.Transform:GetWorldPosition()
    local rot = inst:GetRotation() * DEGREES
    local x0, z0
    if dist ~= 0 then
        if dist > 0 and ((mult ~= nil and mult > 1) or (heavymult ~= nil and heavymult > 1)) then
            x0, z0 = x, z
        end
        x = x + dist * math.cos(rot)
        z = z - dist * math.sin(rot)
    end
    for i, v in ipairs(TheSim:FindEntities(x, y, z, radius + AOE_RANGE_PADDING, MUST_TAGS, CANT_TAGS)) do
        if v ~= inst and not (targets ~= nil and targets[v]) and v:IsValid() and not v:IsInLimbo()
            and not (v.components.health ~= nil and v.components.health:IsDead())
            and (not validfn or validfn(inst, v)) then
            local range = radius + v:GetPhysicsRadius(0)
            local x1, y1, z1 = v.Transform:GetWorldPosition()
            local dx = x1 - x
            local dz = z1 - z
            local distsq = dx * dx + dz * dz
            if distsq > 0 and distsq < range * range and DiffAngleRad(rot, math.atan2(-dz, dx)) < ARC and inst.components.combat:CanTarget(v) then
                inst.components.combat:DoAttack(v)
                if mult ~= nil then
                    local strengthmult = (v.components.inventory ~= nil and v.components.inventory:ArmorHasTag("heavyarmor") or v:HasTag("heavybody")) and
                        heavymult or mult
                    if strengthmult > MAX_SIDE_TOSS_STR and x0 ~= nil then
                        --Don't toss as far to the side for frontal attacks
                        dx = x1 - x0
                        dz = z1 - z0
                        if dx ~= 0 or dz ~= 0 then
                            local rot1 = math.atan2(-dz, dx) + PI
                            local k = math.max(0, math.cos(math.min(PI, DiffAngleRad(rot1, rot) * 2)))
                            strengthmult = MAX_SIDE_TOSS_STR + (strengthmult - MAX_SIDE_TOSS_STR) * k * k
                        end
                    end
                    v:PushEvent("knockback",
                        { knocker = inst, radius = radius + dist, strengthmult = strengthmult, forcelanded = forcelanded })
                end
                if targets ~= nil then
                    targets[v] = true
                end
            end
        end
    end
    if inst.components.combat then
        inst.components.combat.ignorehitrange = false
    end
end

---一个简单的aoe攻击，来自combat的DoAreaAttack，可以攻击指定区域的敌人，而不是玩家所在位置，伤害受武器和伤害倍率影响
---@param inst Entity 攻击对象，需要有combat组件
---@param pos Vector3 攻击位置，必填，如果不需要指定位置可以调用combat的DoAreaAttack
---@param data table|nil 配置项
---@return integer number 被攻击到的单位数量
function FN.DoAOEAttack(inst, pos, data)
    local range = Utils.GetVal(data, "range", 4)
    local MUST_TAGS = Utils.GetVal(data, "MUST_TAGS", { "_combat" })
    local CANT_TAGS = Utils.GetVal(data, "CANT_TAGS",
        { "INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" })
    local ONE_OF_TAGS = Utils.GetVal(data, "ONE_OF_TAGS")
    local validfn = Utils.GetVal(data, "validfn")
    local stimuli = Utils.GetVal(data, "stimuli")
    local weapon = Utils.GetVal(data, "weapon")

    if weapon == nil then
        weapon = inst.components.combat:GetWeapon()
    end
    if stimuli == nil then
        if weapon ~= nil and weapon.components.weapon ~= nil and weapon.components.weapon.overridestimulifn ~= nil then
            stimuli = weapon.components.weapon.overridestimulifn(weapon, self.inst, targ)
        end
        if stimuli == nil and inst.components.electricattacks ~= nil then
            stimuli = "electric"
        end
    end

    local hitcount = 0
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, range, MUST_TAGS, CANT_TAGS, ONE_OF_TAGS)
    for _, ent in ipairs(ents) do
        if ent ~= inst and inst.components.combat:IsValidTarget(ent) and
            (validfn == nil or validfn(ent, inst)) then
            inst:PushEvent("onareaattackother", { target = ent, weapon = weapon, stimuli = stimuli })
            local dmg, spdmg = inst.components.combat:CalcDamage(ent, weapon)
            ent.components.combat:GetAttacked(inst, dmg, weapon, stimuli, spdmg)
            hitcount = hitcount + 1
        end
    end
    return hitcount
end

local COLLAPSIBLE_WORK_ACTIONS =
{
    CHOP = true,
    HAMMER = true,
    MINE = true,
}
local COLLAPSIBLE_TAGS = { "NPC_workable" }
for k, v in pairs(COLLAPSIBLE_WORK_ACTIONS) do
    table.insert(COLLAPSIBLE_TAGS, k .. "_workable")
end

local COLLAPSIBLE_WORK_AND_DIG_ACTIONS = shallowcopy(COLLAPSIBLE_WORK_ACTIONS)
local COLLAPSIBLE_DIG_TAGS = shallowcopy(COLLAPSIBLE_TAGS)
COLLAPSIBLE_WORK_AND_DIG_ACTIONS["DIG"] = true
table.insert(COLLAPSIBLE_DIG_TAGS, "pickable")
table.insert(COLLAPSIBLE_DIG_TAGS, "DIG_workable")
local NON_COLLAPSIBLE_TAGS = { "FX", --[["NOCLICK",]] "DECOR", "INLIMBO" }

---范围工作，来自大霜鲨SGsharkboi.lua
---@param inst Entity
---@param dig boolean 是否执行挖掘操作
---@param dist number 与inst位置的距离，用于确定效果区域的中心。
---@param radius number 效果区域的半径。
---@param arc number 效果区域的角度范围，用于确定一个扇形区域。
---@param targets table 一个表，用于记录已经处理过的目标。
function FN.DoAOEWork(inst, dig, dist, radius, arc, targets)
    local actions = dig and COLLAPSIBLE_WORK_AND_DIG_ACTIONS or COLLAPSIBLE_WORK_ACTIONS
    local x, y, z = inst.Transform:GetWorldPosition()
    local arcx, cos_theta, sin_theta
    if dist ~= 0 then
        local theta = inst.Transform:GetRotation() * DEGREES
        cos_theta = math.cos(theta)
        sin_theta = math.sin(theta)
        x = x + dist * cos_theta
        z = z - dist * sin_theta
    end
    if arc then
        if cos_theta == nil then
            local theta = inst.Transform:GetRotation() * DEGREES
            cos_theta = math.cos(theta)
            sin_theta = math.sin(theta)
        end
        --min-x for testing points converted to local space
        arcx = x + math.cos(arc / 2 * DEGREES) * radius
    end
    for i, v in ipairs(TheSim:FindEntities(x, y, z, radius + 0.5, nil, NON_COLLAPSIBLE_TAGS, dig and COLLAPSIBLE_DIG_TAGS or COLLAPSIBLE_TAGS)) do
        if not (targets and targets[v]) and v:IsValid() and not v:IsInLimbo() then
            local inrange = true
            if arcx then
                --convert to local space x, and test against arcx
                local x1, y1, z1 = v.Transform:GetWorldPosition()
                inrange = x + cos_theta * (x1 - x) - sin_theta * (z1 - z) > arcx
            end
            if inrange then
                local isworkable = false
                if v.components.workable then
                    local work_action = v.components.workable:GetWorkAction()
                    --V2C: nil action for NPC_workable (e.g. campfires)
                    --     allow digging spawners (e.g. rabbithole)
                    isworkable = (
                        (work_action == nil and v:HasTag("NPC_workable")) or
                        (v.components.workable:CanBeWorked() and work_action and actions[work_action.id])
                    )
                end
                if isworkable then
                    v.components.workable:Destroy(inst)
                    if dig and v:IsValid() and v:HasTag("stump") then
                        v:Remove()
                    end
                    if targets then
                        targets[v] = true
                    end
                elseif dig and v.components.pickable and v.components.pickable:CanBePicked() and not v:HasTag("intense") then
                    local num = v.components.pickable.numtoharvest or 1
                    local product = v.components.pickable.product
                    local x1, y1, z1 = v.Transform:GetWorldPosition()
                    v.components.pickable:Pick(inst) -- only calling this to trigger callbacks on the object
                    if product ~= nil and num > 0 then
                        for i = 1, num do
                            SpawnPrefab(product).Transform:SetPosition(x1, 0, z1)
                        end
                    end
                    if targets then
                        targets[v] = true
                    end
                end
            end
        end
    end
end

---单位缩放动画，Transform缩放
function FN.AnimateScale(inst, total_time, start_scale, end_scale, refresh)
    local task
    local start_time = GetTime()
    task = inst:DoPeriodicTask(refresh ~= nil and refresh or 0.05, function()
        local percent = (GetTime() - start_time) / total_time
        if percent > 1 then
            inst.Transform:SetScale(end_scale, end_scale, end_scale)
            task:Cancel()
            return
        end
        local scale = (1 - percent) * start_scale + percent * end_scale
        inst.Transform:SetScale(scale, scale, scale)
    end)
end

---不同ErodeCB，这个是反转腐蚀的过程，就是一个动画渐出的过程，生成的物体可以先调用inst.AnimState:SetErosionParams(1, 0.1, 1.0)让其隐身，然后调用该函数慢慢浮现
function FN.AntiErodeCB(inst, time, cb)
    local time_to_erode = time or 1
    local tick_time = TheSim:GetTickTime()

    inst:StartThread(function()
        local ticks = 0
        while ticks * tick_time < time_to_erode do
            local erode_amount = ticks * tick_time / time_to_erode
            inst.AnimState:SetErosionParams(1 - erode_amount, 0.1, 1.0)
            ticks = ticks + 1
            Yield()
        end
        inst.AnimState:SetErosionParams(0, 0, 0)
        if cb ~= nil then
            cb(inst)
        end
    end)
end

---FindTarget 查找攻击对象，该函数确保同类型单位不会攻击同一个目标，如果最后找不到不同的会随机找一个目标，需要注意，该方法会产生一个冗余属性inst[key]，建议在完成攻击后移除
---@param key string 为inst赋值的键，值为选中的目标，只用于该方法查找
---@return table Entity|nil
function FN.FindTarget(inst, key, radius, checkFn, MUST_TAGS, CANT_TAGS, ONE_OF_TAGS)
    inst[key] = nil
    local pos = inst:GetPosition()

    --查找其他同类型单位的攻击目标,确保不会攻击同一个目标
    local targets = {}
    local flameents = TheSim:FindEntities(pos.x, pos.y, pos.z, radius)
    for i, flame in ipairs(flameents) do
        if flame.prefab == inst.prefab and flame[key] then
            targets[flame[key]] = true
        end
    end

    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, radius, MUST_TAGS, CANT_TAGS, ONE_OF_TAGS)
    local ents2 = {}
    local target
    for i, v in ipairs(ents) do
        if checkFn == nil or checkFn(v) then
            table.insert(ents2, v)
            if not targets[v] then
                target = v
                break
            end
        end
    end

    if not target and #ents2 > 0 then
        target = ents2[math.random(1, #ents2)]
    end

    inst[key] = target
    return target
end

---查找附近对inst有仇恨的对象
function FN.FindHostileEntity(inst, data)
    local range = Utils.GetVal(data, "range", 12)
    local checkFn = Utils.GetVal(data, "checkFn")

    local x, y, z = inst.Transform:GetWorldPosition()
    for _, v in pairs(TheSim:FindEntities(x, y, z, range)) do
        if v.components.combat and v.components.combat.target == inst and (not checkFn or checkFn(v)) then
            return v
        end
    end
end

---查找攻击目标，用于随从的combat的SetRetargetFunction，跟随时丢弃目标距离为18，查找敌人范围为16
function FN.FollowerRetargetFunction(inst)
    local leader = inst.components.follower and inst.components.follower.leader
    if leader and inst:GetDistanceSqToPoint(leader:GetPosition()) >= 324 then --18 * 18
        return nil
    else
        if inst.components.combat.target then
            return inst.components.combat.target
        end
        return GetPrefab.FindTarget(inst, KEY .. inst.prefab, 16,
            function(guy) return GetPrefab.TargetTest(inst, guy) end,
            { "_health" }, { "INLIMBO", "flight", "invisible", "notarget", "noattack", "player" })
    end
end

---让对象以一定速度和角度追踪单位，来自火女的黑色火焰技能willow_flame_fx.lua，不能用于Y轴的角度偏转
---@param source Entity 攻击源，没有攻击目标时，对象会围绕目标源旋转，并且攻击时将用 source.components.combat 进行攻击
---@param getPrefabFn function(boolean) 获取对象，可以是同一个对象，也可以是不断生成的对象，参数表示是否是第一次调用，第一次调用记得设置方向和位置，后续就不用设置了，设置了也会覆盖掉
---@param data table {life, periodTime, target, maxDeflect,filterTargetFn,MUST_TAGS,CANT_TAGS,attackCount,attackDis,getExplodeFxFn,onAttackOther,onLifeEndFn,getAngleOnNoTarget}
function FN.SetTrackingAttack(source, getPrefabFn, data)
    local targetKey = KEY .. "SetTrackingAttack_target" --对象当前的攻击目标
    --local deflectionKey = KEY .. "SetTrackingAttack_currentDeflection" --无目标时的默认偏转方向，现在不随机偏转，所以用不到了

    local life = Utils.GetVal(data, "life", 12)                 --存活时间，秒
    local periodTime = Utils.GetVal(data, "periodTime", 0.1)    --相当于速度，值越小速度越快
    local target = Utils.GetVal(data, "target")                 --初始攻击目标
    local attackTime = Utils.GetVal(data, "attackTime", 0.5)    --攻击间隔
    local maxDeflect = Utils.GetVal(data, "maxDeflect", 30)     --每次最大偏转角度
    local filterTargetFn = Utils.GetVal(data, "filterTargetFn") --过滤目标函数
    local MUST_TAGS = Utils.GetVal(data, "MUST_TAGS", { "_health" })
    local CANT_TAGS = Utils.GetVal(data, "CANT_TAGS", { "player" })
    local attackCount = Utils.GetVal(data, "attackCount", 1)            --攻击几次后消失
    local attackDis = Utils.GetVal(data, "attackDis", 1)                --攻击距离
    local getExplodeFxFn = Utils.GetVal(data, "getExplodeFxFn")         --攻击特效
    local onAttackOther = Utils.GetVal(data, "onAttackOther")           --当攻击了之后
    local onLifeEndFn = Utils.GetVal(data, "onLifeEndFn")               --当攻击次数最大或者存活时间结束之后
    local getAngleOnNoTarget = Utils.GetVal(data, "getAngleOnNoTarget") --当找不到目标时的偏转角度，如果返回nil将会静止在原地，返回的值也会进行角度约束

    local inst = getPrefabFn(true)

    local task
    local lastAttack = 0
    local noTargetDis = 2 --无目标时对象离发射源的最远距离，就算加了这个对象也会越跑越远，螺旋式，不过我暂时不知道怎么让距离保持不变
    local radius = 1      --每次移动的距离
    local angle           --下一次角度
    --由于 inst 可能是临时生成的，坚持不到periodTime就移除了，所以任务要挂在source上面
    task = source:DoPeriodicTask(periodTime, function()
        if GetTime() - lastAttack <= attackTime then
            return
        end

        if not target or not target:IsValid() or target.components.health:IsDead() then
            noTargetDis = math.max(noTargetDis, math.sqrt(inst:GetDistanceSqToInst(source)))

            --需要寻找新的目标
            target = FN.FindTarget(inst, targetKey, 20, filterTargetFn or function(guy)
                return (guy:HasTag("hostile") or (guy.components.combat and guy.components.combat.target and guy.components.combat.target == source))
                    and (not guy.components.follower or not guy.components.follower.leader or guy.components.follower.leader ~= source)
                    and guy.components.health and not guy.components.health:IsDead()
            end, MUST_TAGS, CANT_TAGS)
        else
            noTargetDis = math.sqrt(inst:GetDistanceSqToInst(source))
        end

        if target then
            local dist = inst:GetDistanceSqToInst(target)

            if dist < attackDis * attackDis then
                if getExplodeFxFn then
                    local blast = getExplodeFxFn()
                    blast.Transform:SetPosition(target.Transform:GetWorldPosition())
                end

                local weapon = inst
                source.components.combat.ignorehitrange = true
                source.components.combat.ignoredamagereflect = true
                source.components.combat:DoAttack(target, weapon.components.weapon and weapon or nil)
                source.components.combat.ignorehitrange = false
                source.components.combat.ignoredamagereflect = false
                angle = nil
                lastAttack = GetTime()

                if onAttackOther then
                    onAttackOther(inst, source, target)
                end

                attackCount = attackCount - 1
                if attackCount <= 0 then
                    inst[targetKey] = nil
                    if onLifeEndFn then
                        onLifeEndFn(inst, source)
                    else
                        inst:Remove()
                    end
                    task:Cancel()
                    return
                end
            else
                angle = inst:GetAngleToPoint(target.Transform:GetWorldPosition())
            end
        else
            if getAngleOnNoTarget then
                angle = getAngleOnNoTarget(inst, source)
            else
                --if not inst[deflectionKey] then
                --    inst[deflectionKey] = { time = math.random(1, 10), deflection = maxDeflect * ((math.random() * 2) - 1) }
                --end
                --inst[deflectionKey].time = inst[deflectionKey].time - 1
                --if inst[deflectionKey].time then
                --    inst[deflectionKey] = { time = math.random(1, 10), deflection = maxDeflect * ((math.random() * 2) - 1) }
                --end
                --theta = (inst:GetRotation() + inst[deflectionKey].deflection) * DEGREES

                --默认围绕角色转圈
                local x1, y1, z1 = inst.Transform:GetWorldPosition()
                local x2, y2, z2 = source.Transform:GetWorldPosition()
                local dis = math.max(VecUtil_Dist(x1, z1, x2, z2), 1)
                local l = noTargetDis / dis
                x1 = (x1 - x2) * l + x2
                z1 = (z1 - z2) * l + z2

                local x3, z3 = VecUtil_RotateAroundPoint(x2, z2, x1, z1, PI / 2 / (noTargetDis * noTargetDis)) --旋转弧度根据距离（半径）计算
                angle = inst:GetAngleToPoint(x3, y2, z3)
            end
        end

        if angle then
            local anglediff = angle - inst:GetRotation()
            anglediff = ReduceAngle(anglediff) --[-180,180]
            --约束偏转角度
            if math.abs(anglediff) > maxDeflect then
                anglediff = math.clamp(anglediff, -maxDeflect, maxDeflect)
            end
            local theta = (inst:GetRotation() + anglediff) * DEGREES

            local offset = Vector3(radius * math.cos(theta), 0, -radius * math.sin(theta))
            local newpos = inst:GetPosition() + offset
            local newangle = inst:GetAngleToPoint(newpos.x, newpos.y, newpos.z)

            inst = getPrefabFn(false)
            inst.Transform:SetRotation(newangle)
            inst.Transform:SetPosition(newpos.x, newpos.y, newpos.z)
        end
    end, periodTime)

    source:DoTaskInTime(life, function(ins, t)
        if t:NextTime() ~= nil then
            t:Cancel()
            if onLifeEndFn then
                onLifeEndFn(inst, source)
            elseif inst then
                inst:Remove()
            end
        end
    end, task)
end

---让对象笔直前进，并在移动中进行攻击，攻击函数不提供持续攻击，类似aura组件，但是aura不提供移动代码，也可以配合aura使用
---该函数使用定时任务来检测攻击目标，其实也可以使用碰撞后回调来检查inst.Physics:SetCollisionCallback(oncollide)
---@param data table|nil {time, speed, attackFn, attackPeriod, onFinishFn}
function FN.SetFlightAttack(inst, data)
    local time = Utils.GetVal(data, "time", 4)                   --移动时间，单位为秒
    local speed = Utils.GetVal(data, "speed", 4)                 --每秒距离，默认一个地皮
    local attackFn = Utils.GetVal(data, "attackFn")
    local attackPeriod = Utils.GetVal(data, "attackPeriod", 0.2) --攻击间隔，肯定不能默认每帧都攻击啊
    local onFinishFn = Utils.GetVal(data, "onFinishFn")          --完成后的行为，默认remove

    local startTick = TheSim:GetTick()
    local allTicks = time / GetTickTime()
    local endTicks = allTicks + startTick
    local allDis = time * speed
    attackPeriod = attackPeriod / GetTickTime()
    local lastAttack = startTick - attackPeriod
    inst:StartThread(function()
        while true do
            local cur = TheSim:GetTick()
            --这里不进行延迟，没有动画的物体能明显感觉到卡顿
            local new_pos = Utils.GetPositionForward(inst, (cur - startTick) / allTicks * allDis)
            if inst.Physics ~= nil then
                inst.Physics:Teleport(new_pos:Get())
            else
                inst.Transform:SetPosition(new_pos:Get())
            end

            if attackFn and cur - lastAttack >= attackPeriod then
                attackFn(inst)
                lastAttack = cur
            end

            if cur >= endTicks then
                if onFinishFn then
                    onFinishFn(inst)
                else
                    inst:Remove()
                end
                return
            end
            Yield()
        end
    end)
end

--TODO 现在还无法识别地图等其他界面的点击行为，还需要添加施法所需最短距离，我还不知道TheCamera影响的是不是所有玩家的屏幕
---创建指示器，来自reticule.lua，可以鼠标指向，也可角色朝向决定，由鼠标点击触发，目标位置鼠标点击位置
---@param data table {reticulePrefab, pingPrefab, mouseEnabled, reticuleFollowMouse, isRight, mouseTargetFn, targetFn, spellMinDis}
---@return function 结束函数
function FN.CreateAoeTargeting(inst, executeFn, data)
    --虽然我很想用已有组件，但是指示器显示条件诸多，代码也复杂，aoetargeting就要求是被玩家持有的装备才行
    --r:AddComponent("aoetargeting")

    local reticulePrefab = Utils.GetVal(data, "reticulePrefab", "reticule")      --跟随鼠标移动的指示器
    local pingPrefab = Utils.GetVal(data, "pingPrefab")                          --鼠标点击后指示器动画
    local mouseEnabled = Utils.GetVal(data, "mouseEnabled", false)
    local reticuleFollowMouse = Utils.GetVal(data, "reticuleFollowMouse", false) --指示器是否跟随鼠标移动
    local reticuleRotate = Utils.GetVal(data, "reticuleRotate", true)            --指示器是否旋转
    local isRight = Utils.GetVal(data, "isRight")                                --是否右键触发
    local mouseTargetFn = Utils.GetVal(data, "mouseTargetFn")                    --根据鼠标位置决定目标位置
    local targetFn = Utils.GetVal(data, "targetFn")                              --非鼠标时返回目标位置
    local spellMinDisSq = Utils.GetVal(data, "spellMinDis")                      --施法所需最短距离
    if spellMinDisSq ~= nil then
        spellMinDisSq = spellMinDisSq * spellMinDisSq
    else
        spellMinDisSq = math.huge
    end

    local targetpos
    local r = SpawnPrefab(reticulePrefab)

    local function UpdateRotate()
        if reticuleRotate then
            r:ForceFacePoint(targetpos:Get())
        end
    end
    local UpdatePosition = function(dt)
        if reticuleFollowMouse then
            r.Transform:SetPosition(targetpos:Get())
        else
            r.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
    end
    local endFn = function()
        if r.followhandler ~= nil then
            r.followhandler:Remove()
            r.followhandler = nil
        end
        if r.mouseButtonHandler ~= nil then
            r.mouseButtonHandler:Remove()
            r.mouseButtonHandler = nil
        end
        TheCamera:RemoveListener(r, UpdatePosition)
        r:Remove()
    end

    local function clickFn(button, down, x, y)
        if (isRight and button == MOUSEBUTTON_RIGHT or button == MOUSEBUTTON_LEFT) and down then
            -- 检测距离是否足够
            local disSq = inst:GetDistanceSqToPoint(targetpos:Get())
            if disSq >= spellMinDisSq then
                local pos = inst:GetPosition()
                local dx, dz = targetpos.x - pos.x, targetpos.z - pos.z
                local dis, minDis = math.sqrt(disSq), math.sqrt(spellMinDisSq)
                local posOff = Vector3(dx / dis * minDis, 0, dz / dis * minDis)
                -- TOODO 让角色一直走到施法位置再施法，这个方法不行，走走停停的，参考源码
                inst.components.locomotor:GoToPoint(pos + posOff, nil, true)
                -- inst.components.locomotor:RunInDirection(inst:GetRotation()) --这个会一直跑
            else
                if pingPrefab then
                    FN.GetPrefab(pingPrefab, { pos = r:GetPosition(), rotation = r.Transform:GetRotation() })
                end
                executeFn(targetpos)
            end
        end
        endFn()
    end

    if mouseEnabled and not TheInput:ControllerAttached() then
        r.followhandler = TheInput:AddMoveHandler(function(x, y)
            local x1, y1, z1 = TheSim:ProjectScreenPos(x, y)
            local pos = x1 ~= nil and y1 ~= nil and z1 ~= nil and Vector3(x1, y1, z1) or nil
            if mouseTargetFn ~= nil then
                targetpos = mouseTargetFn(self.inst, pos)
            else
                targetpos = pos
            end
            UpdateRotate()
        end)
        local pos = TheInput:GetWorldPosition()
        if mouseTargetFn ~= nil then
            targetpos = mouseTargetFn(self.inst, pos)
        else
            targetpos = pos
        end
    else
        if targetFn ~= nil then
            targetpos = targetFn(self.inst)
        end
    end
    UpdatePosition()
    UpdateRotate()
    --DoPeriodicTask都没这个平滑
    TheCamera:AddListener(r, UpdatePosition)
    r.mouseButtonHandler = TheInput:AddMouseButtonHandler(clickFn);

    return endFn
end

---屏幕调色和摄像头抖动，来自天体的特效moonpulse.lua
--local function StartMoonPulsePostFX()
--    PostProcessor:EnablePostProcessEffect(PostProcessorEffects.MoonPulse, true);
--    PostProcessor:EnablePostProcessEffect(PostProcessorEffects.MoonPulseGrading, true);
--    PostProcessor:SetMoonPulseParams(0, 0, 0, 0);
--    PostProcessor:SetMoonPulseGradingParams(0, 0, 0, 0);
--    local cur = GetTimeReal();
--    ThePlayer:DoTaskInTime(4, function(inst, task)
--        task:Cancel();
--        PostProcessor:EnablePostProcessEffect(PostProcessorEffects.MoonPulse, false);
--        PostProcessor:EnablePostProcessEffect(PostProcessorEffects.MoonPulseGrading, false);
--    end, ThePlayer:DoPeriodicTask(0.1, function(inst)
--        local r = (GetTimeReal() - cur) / 1000 / 4;
--        PostProcessor:SetMoonPulseParams(0, 0, r, r);
--        PostProcessor:SetMoonPulseGradingParams(0, 0, r, r);
--    end));
--end

local CharacterCloneAttackFn = {
    lunge = function(attacker, target, weapon, startPos, endPos)
        attacker.AnimState:PlayAnimation("lunge_lag");
        attacker.sg:GoToState("combat_lunge", {
            targetpos = endPos,
            weapon = weapon
        })
    end
}

---角色分身攻击，有多种动作可选，攻击完消失
---type可选：lunge
---@param data {attacker, startPos, endPos, weapon, preFn, delay, fn, posFn, attackerInitFn}
---@return table 生成的对象，可以手动销毁或者在posFn中销毁，或者循环利用，需要注意attacker可能被打死，或者weapon耐久会为，所以循环利用应该重写方法
function FN.CharacterCloneAttack(inst, target, type, data)
    local attacker = Utils.GetVal(data, "attacker")             --如果已经有就不创建了，如果不希望是inst对象，这里就应该给出攻击对象
    local attackerInitFn = Utils.GetVal(data, "attackerInitFn") --方便重写组件方法的，比如让角色无敌
    if not attacker then
        attacker = SpawnPrefab(inst.prefab)
    end
    if attackerInitFn then
        attackerInitFn(attacker)
    end
    local startPos = Utils.GetVal(data, "startPos", inst:GetPosition()) --开始位置，默认attacker位置
    local endPos = Utils.GetVal(data, "endPos")                         --攻击结束后位置，有些类型不需要填写
    local weapon = Utils.GetVal(data, "weapon")                         --攻击需要的武器
    local preFn = Utils.GetVal(data, "preFn")                           --攻击前置操作，不受delay影响
    local delay = Utils.GetVal(data, "delay", 0)                        --攻击延迟，attacker的初始位置和角度不计算在内
    local posFn = Utils.GetVal(data, "posFn")                           --攻击后置操作
    local fn = Utils.GetVal(data, "fn", CharacterCloneAttackFn[type])   --应该不会有人把fn也替换了吧o(￣ヘ￣o＃).

    local tarPos = target:GetPosition()
    attacker.Transform:SetPosition(startPos:Get())
    attacker.Transform:SetRotation(target:GetRotation())

    if type == "lunge" then
        --冲刺
        if not endPos then
            --对称
            --local l = math.sqrt(attacker:GetDistanceSqToInst(target))
            local dx, dz = tarPos.x - startPos.x, tarPos.z - startPos.z
            local rot = math.atan2(dz, dx) * RADIANS
            endPos = tarPos + Vector3(dx * math.cos(rot), 0, dz * math.sin(rot))
        end
        if not weapon then
            weapon = SpawnPrefab("spear_wathgrithr_lightning")
        end

        if preFn then
            preFn(attacker, target, weapon, startPos, endPos)
        end
        if delay then
            attacker:DoTaskInTime(delay, function()
                fn(attacker, target, weapon, startPos, endPos)
                if posFn then
                    posFn(attacker, target, weapon, startPos, endPos)
                end
            end)
        else
            fn(attacker, target, weapon, startPos, endPos)
            if posFn then
                posFn(attacker, target, weapon, startPos, endPos)
            end
        end
    end

    --不要浪费，生成的对象通通返回
    return {
        attacker = attacker,
        weapon = weapon
    }
end

------------------------------------------------------------------------------------------------------

---蛤蟆的孢子毒雾
---@param auraExcludeTagsInc table|nil 新增的攻击排除对象标签表，这是在原有表中追加新的标签
---@param data table|nil
function FN.GetSporeCloud(auraExcludeTagsInc, data)
    local damage = Utils.GetVal(data, "damage") --毒物伤害
    local time = Utils.GetVal(data, "time")     --持续时间，默认60秒，也可以调用自带方法FadeInImmediately或FadeOutImmediately立即停止

    local cloud = SpawnPrefab("sporecloud")

    if auraExcludeTagsInc then
        ConcatArrays(cloud.components.aura.auraexcludetags, auraExcludeTagsInc) --追加
    end
    if damage then
        cloud.components.combat:SetDefaultDamage(damage)
    end
    if time then
        Timer.ResetTimer(cloud, "disperse", time)
    end

    return cloud
end

---创建光源预制体heatrocklight
---@param data table|nil {radius, falloff, intensity, colour, enable}
function FN.GetHeatRockLight(data)
    local fx = SpawnPrefab("heatrocklight")
    if data then
        if data.radius then
            fx.Light:SetRadius(data.radius)
        end
        if data.falloff then
            fx.Light:SetFalloff(data.falloff)
        end
        if data.intensity then
            fx.Light:SetIntensity(data.intensity)
        end
        if data.colour then
            fx.Light:SetColour(unpack(data.colour))
        end
        if data.enable then
            fx.Light:Enable(data.enable)
        end
    end

    return fx
end

---在附近随机位置生成随从
---@param prefab string
---@param data table {count, minDis, maxDis, loyaltyTime, delaySpawn,spawnFxFn, onSpawnFn}
---{最小距离、最大距离，忠诚时间、随从生成的延迟时间，特效生成函数，随从生成时回调函数}
function FN.SpawnFollowerInNearby(leader, prefab, data)
    local pos = leader:GetPosition()
    local count = Utils.GetVal(data, "count", 1)
    local minDis = Utils.GetVal(data, "minDis", 1)
    local maxDis = Utils.GetVal(data, "maxDis", 3)
    local loyaltyTime = Utils.GetVal(data, "loyaltyTime")
    local onSpawnFn = Utils.GetVal(data, "onSpawnFn")
    local delaySpawn = Utils.GetVal(data, "delaySpawn")
    local spawnFxFn = Utils.GetVal(data, "spawnFxFn")

    local spawnFollowerFn = function(newPos)
        local follower = SpawnPrefab(prefab)
        leader:PushEvent("makefriend")
        leader.components.leader:AddFollower(follower)
        if loyaltyTime then
            follower.components.follower:AddLoyaltyTime(loyaltyTime)
        end
        follower.Transform:SetPosition(newPos.x, newPos.y, newPos.z)

        if onSpawnFn then
            onSpawnFn(follower)
        end
    end

    for i = 1, count do
        local newPos = Shapes.GetRandomLocation(pos, minDis, maxDis)
        if spawnFxFn then
            spawnFxFn(newPos)
        end

        if delaySpawn then
            leader:DoTaskInTime(delaySpawn, function()
                spawnFollowerFn(newPos)
            end)
        else
            spawnFollowerFn(newPos)
        end
    end
end

-- shadow_pillar的禁锢时长计算
local function CalcTargetDuration(target)
    return target ~= nil and (
        (target:HasTag("epic") and TUNING.SHADOW_PILLAR_DURATION_BOSS) or
        (target:HasTag("player") and TUNING.SHADOW_PILLAR_DURATION_PLAYER)
    ) or TUNING.SHADOW_PILLAR_DURATION
end

---禁锢敌人（没有特效），来自暗影秘典的禁锢技能shadow_pillar.lua，困住 24 秒无法移动。其中Boss生物只会被困 12 秒，（开启pvp下的）玩家被困 6 秒
---@param data table|nil {time}
---@return duration number 单位的实际禁锢时长
function FN.ImprisonTarget(target, data)
    local time = Utils.GetVal(data, "time") --延长禁锢时间

    local padding = (target:HasTag("epic") and 1) or (target:HasTag("smallcreature") and 0) or .75
    local radius = math.max(1, target:GetPhysicsRadius(0) + padding) --这个只是用来让屏幕抖动的
    local platform = target:GetCurrentPlatform()
    local x, y, z = target.Transform:GetWorldPosition()
    if time == nil then
        local circ = PI2 * radius
        local num = math.floor(circ / 1.4 + .5) --原本是计算柱子的数量，这里用不到
        local period = 1 / num
        time = (num - 1) * period
    end

    local ent = SpawnPrefab("shadow_pillar_target") --不可见实体，但是有禁锢效果
    ent.Transform:SetPosition(x, 0, z)
    ent:SetDelay(time)                              --this just extends lifetime, spell still takes effect right away
    ent:SetTarget(target, radius, platform ~= nil)
    return CalcTargetDuration(target)
end

---单位潮湿函数，具有灭火、降温、添加潮湿功能，来自wateryprotection.lua
---@param target Entity
---@param data table|nil {witherprotectiontime, extinguishheatpercent, addcoldness, temperaturereduction, addwetness}
function FN.MakeExtinguishAndCool(target, data)
    local witherprotectiontime = Utils.GetVal(data, "witherprotectiontime", 0)   --植物枯萎
    local extinguishheatpercent = Utils.GetVal(data, "extinguishheatpercent", 0) --灭火
    local addcoldness = Utils.GetVal(data, "addcoldness", 0)                     --冻结
    local temperaturereduction = Utils.GetVal(data, "temperaturereduction", 0)   --降温
    local addwetness = Utils.GetVal(data, "addwetness", 0)                       --潮湿度
    local applywetnesstoitems = Utils.GetVal(data, "applywetnesstoitems")        --是否允许物品潮湿

    if target.components.burnable ~= nil then
        if witherprotectiontime > 0 and target.components.witherable ~= nil then
            target.components.witherable:Protect(witherprotectiontime)
        end
        if extinguishheatpercent then
            if target.components.burnable:IsBurning() or target.components.burnable:IsSmoldering() then
                target.components.burnable:Extinguish(true, extinguishheatpercent)
            end
        end
    end
    if addcoldness > 0 and target.components.freezable ~= nil then
        target.components.freezable:AddColdness(addcoldness)
    end
    if temperaturereduction > 0 and target.components.temperature ~= nil then
        target.components.temperature:SetTemperature(target.components.temperature:GetCurrent() - temperaturereduction)
    end
    if addwetness > 0 then
        if target.components.moisture ~= nil then
            local waterproofness = target.components.moisture:GetWaterproofness()
            target.components.moisture:DoDelta(addwetness * (1 - waterproofness))
        elseif applywetnesstoitems and target.components.inventoryitem ~= nil then
            target.components.inventoryitem:AddMoisture(addwetness)
        end
    end
end

---潮湿函数，具有灭火、降温、添加潮湿、农田浇水功能，来自wateryprotection.lua
---@param pos Vector3
---@param data table|nil {range, MUST_TAGS, CANT_TAGS, witherprotectiontime, extinguishheatpercent, addcoldness, temperaturereduction, addwetness, onspreadprotectionfn}
function FN.ExtinguishAndCoolEntities(pos, data)
    local range = Utils.GetVal(data, "range", 4)
    local MUST_TAGS = Utils.GetVal(data, "MUST_TAGS")
    local CANT_TAGS = Utils.GetVal(data, "CANT_TAGS", { "FX", "DECOR", "INLIMBO", "burnt" })
    local addwetness = Utils.GetVal(data, "addwetness", 0)
    local onspreadprotectionfn = Utils.GetVal(data, "onspreadprotectionfn")

    for _, v in ipairs(TheSim:FindEntities(pos.x, pos.y, pos.z, range, MUST_TAGS, CANT_TAGS)) do
        FN.MakeExtinguishAndCool(v, data)

        if onspreadprotectionfn then
            onspreadprotectionfn(v)
        end
    end

    if addwetness and TheWorld.components.farming_manager ~= nil then
        TheWorld.components.farming_manager:AddSoilMoistureAtPoint(pos.x, pos.y, pos.z, addwetness)
    end
end

---向目标发射物品或是直接给予目标物品，基于LaunchAt
---@param prefab Entity|string 要发射的对象或预制体名
---@param launcher Entity 发射源
---@param data table|nil
function FN.ReturnMaterial(prefab, launcher, data)
    local count = Utils.GetVal(data, "count", 1)                      --数量
    local isStack = Utils.GetVal(data, "isStack")                     --是否堆叠成一个物品发射
    local target = Utils.GetVal(data, "target")                       --目标
    local isGiveTarget = Utils.GetVal(data, "isGiveTarget")           --是否取消发射，直接给予目标
    local speedmult = Utils.GetVal(data, "speedmult")                 --速度
    local startheight = Utils.GetVal(data, "startheight")             --初始高度
    local startradius = Utils.GetVal(data, "startradius")             --初始半径
    local randomangleoffset = Utils.GetVal(data, "randomangleoffset") --发射角

    local name, drop
    if type(prefab) == "string" then
        name = prefab
        drop = SpawnPrefab(name)
    else
        name = prefab.prefab --不做检验
        drop = prefab
    end

    assert(name and drop, "Make sure the prefab is entity or prefab name")

    local inventory = target and target.components.inventory
    isGiveTarget = isGiveTarget and inventory ~= nil
    local drops = {}
    table.insert(drops, drop)
    if (isStack or isGiveTarget) and drop.components.stackable then
        local maxsize = drop.components.stackable.maxsize
        drop.components.stackable:SetStackSize(math.min(count, maxsize))
        count = count - maxsize

        while count > 0 do
            drop = SpawnPrefab(name)
            drop.components.stackable:SetStackSize(math.min(count, maxsize))
            table.insert(drops, drop)
            count = count - maxsize
        end
    else
        for i = 1, count - 1 do
            table.insert(drops, SpawnPrefab(name))
        end
    end

    for _, v in ipairs(drops) do
        if isGiveTarget and target then
            target.components.inventory:GiveItem(v)
        else
            LaunchAt(v, launcher, target, speedmult, startheight, startradius, randomangleoffset)
        end
    end
end

---向四周以一个多边形的向外扩散的方式生成浪花，来自ocean_util.lua，原方法中不允许在陆地生成，我取消这个限制并且对原函数进行一些增强
---不过如果想在陆地使用并且使用默认wave_med预制体的话，还需要在生成后调用CancelAllPendingTasks来移除所有监听任务，不然在陆地生成立刻就会移除
---@param position Vector3 波的生成起始位置
---@param data table|nil
function FN.SpawnAttackWaves(position, data)
    local startAngle = Utils.GetVal(data, "rotation", math.random(-180, 180))               -- 波的生成旋转角度
    local total_rad = Utils.GetVal(data, "spawn_radius", 0) + 1.5                           -- 波生成的半径
    local numWaves = Utils.GetVal(data, "numWaves", 1)                                      -- 要生成的波的数量
    local totalAngle = (numWaves == 1 and 0) or Utils.GetVal(data, "totalAngle", 360) % 361 --波扩散的角度总和
    local waveSpeed = Utils.GetVal(data, "waveSpeed", 6)                                    --波的速度，可以是number或table
    local spawnPrefabFn = Utils.GetVal(data, "spawnPrefabFn", function()
        return SpawnPrefab("wave_med")
    end)                                                      --生成预制体函数，方便对生成的预制体初始化

    local idleTime = Utils.GetVal(data, "idleTime", 5)        --波生成后的静止时间
    local instantActive = Utils.GetVal(data, "instantActive") --波是否应立即激活

    local anglePerWave = (totalAngle == 0 and 0) or (totalAngle == 360 and totalAngle / numWaves) or
        totalAngle / (numWaves - 1)

    for i = 0, numWaves - 1 do
        local angle = (startAngle - (totalAngle / 2)) + (i * anglePerWave)
        local offset_direction = Vector3(math.cos(angle * DEGREES), 0, -math.sin(angle * DEGREES)):Normalize()
        local wavepos = position + (offset_direction * total_rad)

        local wave = spawnPrefabFn()
        wave.Transform:SetPosition(wavepos:Get())
        wave.Transform:SetRotation(angle)
        if type(waveSpeed) == "table" then
            wave.Physics:SetMotorVel(waveSpeed[1], waveSpeed[2], waveSpeed[3])
        else
            wave.Physics:SetMotorVel(waveSpeed, 0, 0)
        end
        wave.idle_time = idleTime

        if instantActive then
            wave.sg:GoToState((idleTime > 0 and "instant_rise") or "lower")
        end
    end
end

local SLOWDOWN_MUST_TAGS = { "locomotor" }
local SLOWDOWN_CANT_TAGS = { "player", "flying", "playerghost", "INLIMBO" }
local function SlowDownOnUpdate(inst, x, y, z, radius, speedPenalty)
    for i, v in ipairs(TheSim:FindEntities(x, y, z, radius, SLOWDOWN_MUST_TAGS, SLOWDOWN_CANT_TAGS)) do
        local is_follower = v.components.follower ~= nil and v.components.follower.leader ~= nil and
            v.components.follower.leader:HasTag("player")
        if v.components.locomotor ~= nil and not is_follower then
            v.components.locomotor:PushTempGroundSpeedMultiplier(speedPenalty, WORLD_TILES.MUD)
        end
    end
end

---减速周围单位，来自克服蛛形纲恐惧症book_web_ground，逻辑也可用于加速
---@param inst Entity 任务执行者
---@param data  table|nil
---@return task Task
function FN.SlowDownEntities(inst, data)
    local pos = Utils.GetVal(data, "pos", inst:GetPosition()) --减速位置
    local radius = Utils.GetVal(data, "radius", 6)            --半径
    local time = Utils.GetVal(data, "time")                   --持续时间，默认为nil，即一直进行
    local speedPenalty = Utils.GetVal(data, "speedPenalty", 0.25)

    local task = inst:DoPeriodicTask(0, SlowDownOnUpdate, nil, pos.x, pos.y, pos.z, radius, speedPenalty)
    SlowDownOnUpdate(inst, pos.x, pos.y, pos.z, radius)
    if time then
        inst:DoTaskInTime(time, function() task:Cancel() end)
    end

    return task
end

---荆棘护甲的反伤特效
function FN.SpawnBrambleFx(owner, data)
    local damage = Utils.GetVal(data, "damage")               --伤害，默认22.6
    local range = Utils.GetVal(data, "range")                 --攻击范围，默认.75
    local ignore = Utils.GetVal(data, "ignore")               --攻击忽视对象，要求为一个对象组成的表，owner默认加入该表
    local canhitplayers = Utils.GetVal(data, "canhitplayers") --是否可以攻击玩家，默认攻击玩家，如果owner是玩家并且是非PVP模式下则不攻击玩家

    local ar = SpawnPrefab("bramblefx_armor")
    ar:SetFXOwner(owner)

    ar.damage = damage or ar.damage
    ar.range = range or ar.range
    if canhitplayers ~= nil then ar.canhitplayers = canhitplayers end

    if ignore then
        for _, v in ipairs(ignore) do
            ar.ignore[v] = true
        end
    end
    return ar
end

---装备耐久为0不消失，使装备可用材料填充耐久，来自standardcomponents.lua，不过我不想添加forgerepairable组件，顺便兼容perishable
function FN.MakeForgeRepairable(inst, material, onbroken, onrepaired)
    local function _onbroken(inst)
        if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
            local owner = inst.components.inventoryitem.owner
            if owner ~= nil and owner.components.inventory ~= nil then
                local item = owner.components.inventory:Unequip(inst.components.equippable.equipslot)
                if item ~= nil then
                    owner.components.inventory:GiveItem(item, nil, owner:GetPosition())
                end
            end
        end

        -- 腐烂后这个剩余时间可能是一个负数
        if inst.components.perishable then
            inst.components.perishable.perishremainingtime = 0
        end

        if onbroken ~= nil then
            onbroken(inst)
        end
    end

    --V2C: asserts to prevent overwriting callbacks already setup by the prefab

    if inst.components.armor ~= nil then
        assert(not (DEBUG_MODE and inst.components.armor.onfinished ~= nil))
        inst.components.armor:SetKeepOnFinished(true)
        inst.components.armor:SetOnFinished(_onbroken)
    elseif inst.components.finiteuses ~= nil then
        assert(not (DEBUG_MODE and inst.components.finiteuses.onfinished ~= nil))
        inst.components.finiteuses:SetOnFinished(_onbroken)
    elseif inst.components.fueled ~= nil then
        assert(not (DEBUG_MODE and inst.components.fueled.depleted ~= nil))
        inst.components.fueled:SetDepletedFn(_onbroken)
    elseif inst.components.perishable ~= nil then
        inst.components.perishable.onperishreplacement = nil --不会生成腐烂物
        inst.components.perishable:SetOnPerishFn(_onbroken)
    end

    if material then
        inst:AddComponent("forgerepairable")
        inst.components.forgerepairable:SetRepairMaterial(material)
        inst.components.forgerepairable:SetOnRepaired(onrepaired)
    end
end

---设置无掉落物
function FN.SetNoLoot(inst)
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetLoot(nil)
        inst.components.lootdropper:SetChanceLootTable(nil)
    end
end

local function RemoveListener(t, event, inst, fn)
    if t then
        local listeners = t[event]
        if listeners then
            local listener_fns = listeners[inst]
            if listener_fns then
                if type(fn) == "function" then -- 执行原方法
                    RemoveByValue(listener_fns, fn)
                    if next(listener_fns) == nil then
                        listeners[inst] = nil
                    end
                else
                    listeners[inst] = nil --移除对该事件的所有监听回调
                end
            end
            if next(listeners) == nil then
                t[event] = nil
            end
        end
    end
end

---在原RemoveEventCallback基础上做一些加强：
---1. 如果不指定fn，则移除对监听源的该事件的所有监听回调
function FN.RemoveEventCallback(inst, event, fn, source)
    source = source or inst

    RemoveListener(source.event_listeners, event, inst, fn)
    RemoveListener(inst.event_listening, event, source, fn)
end

--- 获取指定对象的指定事件的所有回调函数
function FN.GetAllCallbackByName(inst, name)
    local callbacks = {}

    if inst.event_listeners then
        for ins, fns in pairs(inst.event_listeners[name]) do
            ConcatArrays(callbacks, fns)
        end
    end

    return callbacks
end

--- 修改指定对象的指定事件的所有监听回调函数
function FN.UpdateAllCallbackByName(inst, name, getCallbackFn)
    local cbs = inst.event_listeners and inst.event_listeners[name]
    for ins, fns in pairs(cbs or {}) do
        cbs[ins] = getCallbackFn(ins, fns)
    end
end

local function DefaultCheckFn(v)
    return not (v.components.locomotor or (v.components.inventoryitem and not v:HasTag("heavy")))
end

local TITLE_CHECK_CANT_TAGS = { "FX" }
local function CheckPlacePos(spawnPos, entRadius, checkFn)
    if TheWorld.Map:IsAboveGroundAtPoint(spawnPos:Get()) then
        for _, v in ipairs(TheSim:FindEntities(spawnPos.x, spawnPos.y, spawnPos.z, entRadius, nil, TITLE_CHECK_CANT_TAGS)) do
            if not checkFn(v) then
                return false
            end
        end
        return true
    end
    return false
end


---查找给定位置附近可放置的位置，首先以给定点为圆心查找firstCount次，如果找到就返回，如果找不到就矩形范围从上往下、从左往右查找
---@param pos Vector3 查找中心
---@param minDis number 圆的最小半径或矩形的最小半长
---@param maxDis number 圆的最大半径或矩形的最大半长
---@param entRadius number|nil 预制体需要的半径，一般是物理半径，默认0.5
---@param firstCount number|nil 绕圆心查找的次数，默认5次
---@param checkFn function|nil 校验函数，如果新位置有其他对象，对其进行检验，如果为false则表示该点不行，默认是禁止存在没有移动组件或重物品
function FN.FindPlaceablePos(pos, minDis, maxDis, entRadius, firstCount, checkFn)
    assert(maxDis > 0 and (not entRadius or entRadius > 0), "maxDis > 0 and (not entRadius or entRadius > 0)")

    entRadius = entRadius or 0.5
    firstCount = firstCount or 5
    checkFn = checkFn or DefaultCheckFn

    local spawnPos
    -- 先随机
    for _ = 1, firstCount do
        spawnPos = Shapes.GetRandomLocation(pos, minDis, maxDis)
        if CheckPlacePos(spawnPos, entRadius, checkFn) then
            return spawnPos
        end
    end

    -- 矩形搜索，比较简单的方式，从左上角开始查找，就不判断障碍物的最大X和Z了

    local minX, minZ = pos.x - maxDis, pos.z - maxDis
    local maxX, maxZ = pos.x + maxDis, pos.z + maxDis
    local curX, curZ = minX, minZ
    while true do
        spawnPos = Vector3(curX, 0, curZ) + pos
        if CheckPlacePos(spawnPos, entRadius, checkFn) then
            return spawnPos
        end

        curX = curX + entRadius * 2
        if curX > maxX then
            curX = minX
            curZ = curZ + entRadius * 2
        end
        if curZ > maxZ then
            return
        end
    end
end

---切斯特眼骨在附近生成切斯特的逻辑代码，使用了FindWalkableOffset
function FN.GetSpawnPoint(pos, radius, attempts)
    radius = radius or 30
    attempts = attempts and attempts / 2 or 6 --对半分

    local theta = math.random() * 2 * PI
    local offset = FindWalkableOffset(pos, theta, radius, attempts, true)
    if not offset then
        --每次失败后取对角会好点
        offset = FindWalkableOffset(pos, ReduceAngleRad(theta + PI), radius, attempts, true)
    end

    return offset ~= nil and (pos + offset) or nil
end

---尝试移除inventory或container物品，如果足够就移除并返回true，否则就返回false，注意该函数会修改prefabs表
---@param self Component inventory|container
---@param prefabs table 预制体列表，例如{log = 2,glod = 4}
function FN.TryRemoveInventoryItem(self, prefabs)
    local items = self:FindItems(function(ent)
        return prefabs[ent.prefab] ~= nil
    end)
    local ps = shallowcopy(prefabs)

    for _, item in ipairs(items) do
        ps[item.prefab] = ps[item.prefab] - GetStackSize(item)
    end

    for _, count in pairs(ps) do
        if count > 0 then
            return false
        end
    end

    for _, item in ipairs(items) do
        local need = prefabs[item.prefab]
        if need > 0 then
            local count = GetStackSize(item)
            if count > need then
                item.components.stackable:SetStackSize(count - need)
                prefabs[item.prefab] = 0
            else
                item:Remove()
                prefabs[item.prefab] = need - count
            end
        end
    end
    return true
end

---以所给位置所在地皮为圆心，更换一片圆形区域的地皮
---@param pos Vector3 作为圆心的位置，不需要是地皮中心
---@param radius number 半径，以地皮为单位
---@param tile number 要更换的地皮
---@param isContainOcean boolean|nil 是否把海洋也换成指定地皮
---@param edgeRandom number|nil 边缘随机性，在边缘位置多换一块的概率，这里只会多换，不会少换
function FN.SpawnRoundTile(pos, radius, tile, isContainOcean, edgeRandom)
    edgeRandom = edgeRandom or 0

    local x, z = TheWorld.Map:GetTileCoordsAtPoint(pos:Get())
    local baseX = x - radius - 1
    local baseZ = z - radius - 1

    local disSq = radius * radius
    local disSq2 = (radius + 1) * (radius + 1)
    local len = radius * 2 + 1
    for i = 1, len do
        local newX = baseX + i
        for j = 1, len do
            local newZ = baseZ + j
            if isContainOcean or TileGroupManager:IsLandTile(TheWorld.Map:GetTile(newX, newZ)) then
                local sq = VecUtil_DistSq(newX, newZ, x, z)
                if sq <= disSq or (edgeRandom ~= 0 and sq <= disSq2 and math.random() < edgeRandom) then
                    TheWorld.Map:SetTile(newX, newZ, tile)
                end
            end
        end
    end
end

----------------------------------------------------------------------------------------------------
---遗忘entitytracker记录的所有实体
function FN.EntityTrackerForgetAllEntity(self)
    for name, _ in pairs(self.entities) do
        self:ForgetEntity(name)
    end
end

--- 获取指定位置耕地地皮的湿度
local _overlaygrid, _moisturegrid
function FN.FarmingManagerGetMoisture(x, y, z)
    if not TheWorld.components.farming_manager then
        return 0
    end
    if not _overlaygrid then
        _overlaygrid = Utils.ChainFindUpvalue(TheWorld.components.farming_manager.GetDebugString, "_overlaygrid")
        _moisturegrid = Utils.ChainFindUpvalue(TheWorld.components.farming_manager.GetDebugString, "_moisturegrid")
    end
    -- 这里我不会判断是否读取到了，如果失败说明该更新代码了

    local index = _overlaygrid:GetIndex(TheWorld.Map:GetTileCoordsAtPoint(x, y, z))
    local nutrients_overlay = _overlaygrid:GetDataAtIndex(index) --if the tile is not used for farming then there is no need to track the moisture

    return nutrients_overlay and _moisturegrid:GetDataAtIndex(index) or nil
end

--- 获取指定位置耕地地皮的营养值
function FN.FarmingManagerGetNutrients(x, y, z)
    if not TheWorld.components.farming_manager then
        return 0, 0, 0
    end

    local tile_x, tile_z = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
    return TheWorld.components.farming_manager:GetTileNutrients(tile_x, tile_z)
end

--- 获取两个对象之间默认的行动距离
---@param doer Entity
---@param target Entity|nil
function FN.GetActionRadius(doer, target)
    return .5 + (doer and doer:GetPhysicsRadius(0) or 0) + (target and target:GetPhysicsRadius(0) or 0)
end

----------------------------------------------------------------------------------------------------
local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

---模拟父单位生成子的单位，设置子单位的坐标，来自猪人房生成猪人的逻辑
function FN.ReleaseChild(child, parent, data)
    local overridespawnlocation = Utils.GetVal(data, "overridespawnlocation")
    local spawnInWater = Utils.GetVal(data, "spawnInWater", false)
    local spawnOnBoats = Utils.GetVal(data, "spawnOnBoats", false)

    local x, y, z = parent.Transform:GetWorldPosition()
    y = 0

    if overridespawnlocation then
        x, y, z = overridespawnlocation(parent)
    else
        local rad = .5 + parent:GetPhysicsRadius(0) + child:GetPhysicsRadius(0)
        local start_angle = math.random() * 2 * PI

        local offset = FindWalkableOffset(Vector3(x, 0, z), start_angle, rad, 8, false, true, NoHoles, spawnInWater,
            spawnOnBoats)
        if offset == nil then
            -- well it's gotta go somewhere!
            x = x + rad * math.cos(start_angle)
            z = z - rad * math.sin(start_angle)
        else
            x = x + offset.x
            z = z + offset.z
        end
    end
    if child.Physics ~= nil then
        child.Physics:Teleport(x, y, z)
    else
        child.Transform:SetPosition(x, y, z)
    end
end

---杀死该单位
function FN.DefaultKill(inst, isContainFollower)
    if not inst:IsValid()
        or (inst.components.health or inst.components.health:IsDead()) then
        return
    end

    if isContainFollower and inst.components.leader then
        for k, _ in pairs(self.followers) do
            FN.Kill(k)
        end
    end

    if inst.entity:IsVisible() then
        if inst.components.health then
            inst.components.health:Kill()
        else
            SpawnPrefab("small_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst:Remove()
        end
    else
        inst:Remove()
    end
end

function FN.SetPosition(inst, x, y, z)
    if inst.Physics ~= nil then
        inst.Physics:Teleport(x, y, z)
    else
        inst.Transform:SetPosition(x, y, z)
    end
end

local function FollowerSort(a, b)
    -- Better than bubble!
    local ap = a.components.follower:GetLoyaltyPercent()
    local bp = b.components.follower:GetLoyaltyPercent()
    if ap == bp then
        return a.GUID < b.GUID
    end
    return ap < bp
end

---根据优先级获取周围其他生物，用于一个道具同时雇佣多个生物，参考沃特雇佣鱼人逻辑
---@param inst Entity
---@param data data|nil {radius,maxcount,MUST_TAGS,CANT_TAGS,ONE_OF_TAGS,checkFN}
function FN.GetOtherEnts(inst, data)
    local radius = Utils.GetVal(data, "radius", 16)        --雇佣范围
    local maxcount = Utils.GetVal(data, "maxcount", 6) - 1 --雇佣的最多数量，不用考虑已经inst，函数中会减一
    local MUST_TAGS = Utils.GetVal(data, "MUST_TAGS")
    local CANT_TAGS = Utils.GetVal(data, "CANT_TAGS")
    local ONE_OF_TAGS = Utils.GetVal(data, "ONE_OF_TAGS")
    local checkFn = Utils.GetVal(data, "checkFn")

    local ents_highpriority = {}
    local ents_lowpriority = {}
    local x, y, z = inst.Transform:GetWorldPosition()
    for _, ent in ipairs(TheSim:FindEntities(x, y, z, radius, MUST_TAGS, CANT_TAGS, ONE_OF_TAGS)) do
        if ent ~= inst and not ent.components.health:IsDead() and (not checkFn or checkFn(inst, ent)) then
            local follower = ent.components.follower
            if follower then
                -- No leader or about to lose loyalty is high priority.
                if follower.leader == nil or follower:GetLoyaltyPercent() < TUNING.MERM_LOW_LOYALTY_WARNING_PERCENT then
                    table.insert(ents_highpriority, ent)
                else
                    table.insert(ents_lowpriority, ent)
                end
            end
        end
    end

    table.sort(ents_highpriority, FollowerSort)
    table.sort(ents_lowpriority, FollowerSort)

    local ents_valid = {}
    local ents_count = 0
    for _, hound in ipairs(ents_highpriority) do
        if ents_count >= maxcount then
            break
        end
        ents_count = ents_count + 1
        table.insert(ents_valid, hound)
    end
    if ents_count < maxcount then
        for _, hound in ipairs(ents_lowpriority) do
            if ents_count >= maxcount then
                break
            end
            ents_count = ents_count + 1
            table.insert(ents_valid, hound)
        end
    end

    return ents_valid
end

----------------------------------------------------------------------------------------------------
local function IsDefenceEquip(inst)
    return inst.components.equippable
        and (inst.components.armor or inst.components.planardefense)
end

local CHECK_ITEM_FN = {}

-- 手持
CHECK_ITEM_FN.hands = function(inst)
    return inst.components.equippable and inst.components.equippable.equipslot == EQUIPSLOTS.HANDS
end
-- 头部
CHECK_ITEM_FN.head = function(inst)
    return inst.components.equippable and inst.components.equippable.equipslot == EQUIPSLOTS.HEAD
end
-- 武器
CHECK_ITEM_FN.weapon = function(inst)
    return inst.components.weapon
end
-- 护甲
CHECK_ITEM_FN.armor = function(inst)
    return IsDefenceEquip(inst) and inst.components.equippable.equipslot == EQUIPSLOTS.BODY
end
-- 头盔
CHECK_ITEM_FN.helmet = function(inst)
    return IsDefenceEquip(inst) and inst.components.equippable.equipslot == EQUIPSLOTS.HEAD
end
-- 可食用
CHECK_ITEM_FN.canEat = function(inst, doer)
    return doer.components.eater and doer.components.eater:CanEat(inst)
end
CHECK_ITEM_FN.canEatNotHealth = function(inst, doer)
    return CHECK_ITEM_FN.canEat(inst, doer) and inst.components.edible:GetHealth(doer) <= 0
end
-- healer回血组件
CHECK_ITEM_FN.healer = function(inst)
    return inst.components.healer
end
-- 可回血，包含回血组件和料理
CHECK_ITEM_FN.heal = function(inst, doer)
    return CHECK_ITEM_FN.healer(inst) or
        (CHECK_ITEM_FN.canEat(inst, doer) and inst.components.edible:GetHealth(doer) > 0)
end


---获取容器中指定类型的物品
---@param inst Entity 容器
---@param type string 物品类型
---@param isRemove boolean|nil 是否从容器中取出物品
---@return Entity|nil item 物品
---@return integer|nil index 物品所在容器的槽
function FN.GetContainerFirstItemByType(inst, type, isRemove, wholestack)
    local self = inst.components.container
    local checkFn = CHECK_ITEM_FN[type]
    if not self or not checkFn then return end

    for i = 1, self.numslots do
        local item = self.slots[i]
        if item ~= nil and checkFn(item, inst) then
            if isRemove then
                if not item.components.stackable or wholestack then
                    return self:RemoveItemBySlot(i)
                else
                    return self:RemoveItem(item, false)
                end
            else
                return item, i
            end
        end
    end
end

function FN.GetAllContainerItem(inst, type, isRemove)
    local items = {}
    local self = inst.components.container
    local checkFn = CHECK_ITEM_FN[type]
    if not self or not checkFn then return end

    for i = 1, self.numslots do
        local item = self.slots[i]
        if item ~= nil and item:IsValid() and checkFn(item, inst) then
            if isRemove then
                table.insert(items, self:RemoveItemBySlot(i))
            else
                table.insert(items, { item, i })
            end
        end
    end
    return items
end

--- 提高血量上限，血量百分比不变
function FN.SetMaxHealth(inst, maxHealth)
    local health = inst.components.health
    local per = health:GetPercent()
    health.maxhealth = maxHealth
    if health.currenthealth > 0 then --玩家有可能死亡
        health.currenthealth = per * maxHealth
    end
    health:ForceUpdateHUD(true) --handles capping health at max with penalty
end

function FN.GetOne(inst)
    return inst.components.stackable and inst.components.stackable:Get() or inst
end

---spawner组件刚开始不会主动生成child，需要手动生成一下
function FN.SpawnerInitSpawnChild(inst)
    if inst.components.spawner.child == nil
        and not inst.components.spawner:IsSpawnPending() then
        local child = SpawnPrefab(inst.components.spawner.childname)
        if child ~= nil then
            inst.components.spawner:TakeOwnership(child)
            inst.components.spawner:GoHome(child)
            inst.components.spawner:ReleaseChild()
        end
    end
end

---spawner组件生成的子单位离开加载范围时直接回家，建议放在entitysleep监听回调中处理
---@param inst any
---@param maxDis any
---@param checkFn any
function FN.EntitySleepGoHome(inst, maxDis, checkFn)
    maxDis = maxDis or 20
    local disSq = maxDis * maxDis

    local home = inst.components.homeseeker and inst.components.homeseeker:GetHome()
    if not home                                                           --必须有家
        or home.components.spawner:IsOccupied()
        or (inst.components.follower and inst.components.follower.leader) --必须没有leader
        or inst:GetDistanceSqToInst(home) <= disSq                        --必须在允许范围外
        or (checkFn and not checkFn(inst, home))
    then
        return
    end

    home.components.spawner:GoHome(inst)
    home.components.spawner:ReleaseChild()
end

function FN.FxAndRemove(inst, material)
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial(material or "wood")
    inst:Remove()
end

--- 获取容器中从前往后的第一个物品
function FN.GetContainerFirstItem(self)
    for i = 1, self.numslots do
        if self.slots[i] then
            return self.slots[i]
        end
    end
end

local function CheckSpawnedLoot(loot)
    if loot.components.inventoryitem ~= nil then
        loot.components.inventoryitem:TryToSink()
    else
        local lootx, looty, lootz = loot.Transform:GetWorldPosition()
        if ShouldEntitySink(loot, true) or TheWorld.Map:IsPointNearHole(Vector3(lootx, 0, lootz)) then
            SinkEntity(loot)
        end
    end
end

--- 分解法杖生成分解物逻辑
function FN.SpawnLootPrefab(inst, lootprefab)
    if lootprefab == nil then return end

    local loot = SpawnPrefab(lootprefab)
    if loot == nil then return end

    local x, y, z = inst.Transform:GetWorldPosition()

    if loot.Physics ~= nil then
        local angle = math.random() * 2 * PI
        loot.Physics:SetVel(2 * math.cos(angle), 10, 2 * math.sin(angle))

        if inst.Physics ~= nil then
            local len = loot:GetPhysicsRadius(0) + inst:GetPhysicsRadius(0)
            x = x + math.cos(angle) * len
            z = z + math.sin(angle) * len
        end

        loot:DoTaskInTime(1, CheckSpawnedLoot)
    end

    loot.Transform:SetPosition(x, y, z)
    loot:PushEvent("on_loot_dropped", { dropper = inst })

    return loot
end

--- 卸下一个对象的所有东西，来自分解魔杖
function FN.DischargePrefab(target)
    if target.components.inventory ~= nil then
        target.components.inventory:DropEverything()
    end

    if target.components.container ~= nil then
        target.components.container:DropEverything()
    end

    if target.components.spawner ~= nil and target.components.spawner:IsOccupied() then
        target.components.spawner:ReleaseChild()
    end

    if target.components.occupiable ~= nil and target.components.occupiable:IsOccupied() then
        local item = target.components.occupiable:Harvest()
        if item ~= nil then
            item.Transform:SetPosition(target.Transform:GetWorldPosition())
            item.components.inventoryitem:OnDropped()
        end
    end

    if target.components.trap ~= nil then
        target.components.trap:Harvest()
    end

    if target.components.dryer ~= nil then
        target.components.dryer:DropItem()
    end

    if target.components.harvestable ~= nil then
        target.components.harvestable:Harvest()
    end

    if target.components.stewer ~= nil then
        target.components.stewer:Harvest()
    end

    if target.components.constructionsite ~= nil then
        target.components.constructionsite:DropAllMaterials()
    end

    if target.components.inventoryitemholder ~= nil then
        target.components.inventoryitemholder:TakeItem()
    end
end

return FN
