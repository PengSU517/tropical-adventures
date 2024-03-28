--@author: 绯世行
--欢迎其他开发者直接使用，但是强烈谴责搬用代码后对搬用代码加密的行为！
--使用案例及最新版：https://n77a3mjegs.feishu.cn/docx/K9bUdpb5Qo85j2xo8XkcOsU1nuh?from=from_copylink

local FN = {}

---属性前缀，格式为_XXX_utils_utils_，防止和已有的属性（其他mod）重复，最好和mod名保持一致，键的形式可能是KEY+函数名+属性名，
local KEY = "_" .. debug.getinfo(1, 'S').source:match(".*scripts[/\\](.*)%.lua"):gsub("[/\\]", "_") .. "_"

---排除浮点数比较的误差
FN.EPSILON = 1e-10

--不用给周期任务赋值还能定时取消的写法（不过也可以提前定义一个局部变量）
--inst:DoTaskInTime(10 * FRAMES, TimeoutRepel, inst:DoPeriodicTask(0, UpdateRepel)) --在TimeoutRepel方法中直接取消DoPeriodicTask的执行

--用比较傻的方法，把所有boss技能CD name都写在这里
--不使用timer组件计时的技能没法阻止
FN.TIMER_BOSS_SKILL = {
    bearger = { "GroundPound", "Yawn", },
    mutatedbearger = { "GroundPound", "Yawn", },
    stalker_atrium = { "snare_cd", "spikes_cd", "channelers_cd", "minions_cd", "mindcontrol_cd", },
    antlion = { "wall_cd" }, --蚁狮用的是worldsettingstimer计时
    beequeen = { "spawnguards_cd", "focustarget_cd", },
    crabking = { "spell_cooldown", "heal_cooldown", "claw_regen_timer", "clawsummon_cooldown", },
    dragonfly = { "groundpound_cd", },
    klaus = { "command_cd", "chomp_cd", },
    malbatross = { "satiated", "sleeping_relocate", "divetask", "disengage", "splashdelay", },
    toadstool = { "sporebomb_cd", "mushroomsprout_cd", "pound_cd", "channel", },
    moose = { "DisarmCooldown", },
    alterguardian_phase1 = { "hitsound_cd", "summon_cooldown", "roll_cooldown", },
    alterguardian_phase2 = { "spin_cd", "summon_cd", "spike_cd", },
    alterguardian_phase3 = { "summon_cd", "runaway_blocker", "traps_cd", },
    eyeofterror = { "spawneyes_cd", "charge_cd", "focustarget_cd", "leash_cd", "repair", },
    twinofterror1 = { "spawneyes_cd", "charge_cd", "focustarget_cd", "leash_cd", "repair", },
    twinofterror2 = { "spawneyes_cd", "charge_cd", "focustarget_cd", "leash_cd", "repair", },
    daywalker = { "stalk_cd", "roar_cd", "despawn", },
    deerclops = { "laserbeam_cd", },
    mutateddeerclops = { "laserbeam_cd", },
    mutatedwarg = { "flamethrower_cd", },
}

---获取配置用的
function FN.GetVal(tab, k, default, getDefaultFn)
    if not tab or tab[k] == nil then
        return getDefaultFn and getDefaultFn() or default
    end
    return tab[k]
end

---获取配置用的
function FN.IfHasVal(tab, k, fn)
    if tab and tab[k] ~= nil then
        fn(tab[k])
    end
end

---创建一个含有指定个数指定值的数组
function FN.CreateRepeatingArray(value, count)
    local ret = {}
    for i = 1, count do
        table.insert(ret, value)
    end
    return ret
end

---检验table的值是不是都是同一个值
---@param tab table
---@param val any|nil 如果给定值则判断是否都为该值，如果不同则判断所有值是不是都一致
---@return boolean
function FN.IsTableValEqual(tab, val)
    for k, v in pairs(tab) do
        if val == nil then
            val = v
        end
        if val ~= v then
            return false
        end
    end
    return true
end

----------------------------------------------------------------------------------------------------

function FN.EmptyFn()
end

function FN.TrueFn()
    return true
end

function FN.FalseFn()
    return false
end

---返回函数的返回值无论何时都返回固定的值
function FN.ConstantFn(...)
    local args = { ... }
    return function() return unpack(args) end
end

---RateClamp 约束倍率该变量范围
---例如伤害为num，想把伤害变为num * newRate，又希望在范围在[num + minChange,num + maxChange]范围，可以调用RateClamp(num, newRate, minChange, maxChange)
---@param num number 原始值
---@param newRate number 新倍率
---@param minChange number 最小改变量，用于钳制
---@param maxChange number 最大该变量，用于钳制
function FN.RateClamp(num, newRate, minChange, maxChange)
    return math.clamp(num * newRate, num + minChange, num + maxChange)
end

---根据当前朝向和前进距离计算最终落点
function FN.GetPositionForward(inst, distance)
    if inst == nil then
        return nil
    end

    local rot = inst:GetRotation() * DEGREES
    local pos = inst:GetPosition()
    return pos + Vector3(distance * math.cos(rot), 0, -distance * math.sin(rot)) --z轴需要反过来
end

function FN.IsHUDScreen()
    return TheFrontEnd:GetActiveScreen() and type(TheFrontEnd:GetActiveScreen().name) == "string" and
        TheFrontEnd:GetActiveScreen().name == "HUD"
end

---玩家是否可以做其他事，当前是否处于游戏界面非幽灵非打字
function FN.IsDefaultScreen()
    return FN.IsHUDScreen()
        -- 非幽灵
        and ThePlayer and not ThePlayer:HasTag("playerghost")
        -- 非打字
        and not ThePlayer.HUD:IsChatInputScreenOpen() and not ThePlayer.HUD.writeablescreen
        -- 非制作栏搜索
        and not ThePlayer.HUD:HasInputFocus()
    --非骑行
    --and not (ThePlayer.replica.rider and ThePlayer.replica.rider:IsRiding())
end

---函数装饰器，增强原有函数的时候可以使用
---@param beforeFn function|nil 先于fn执行，参数为fn参数，返回三个值：新返回值表、是否跳过旧函数执行，旧函数执行参数（要求是表，会用unpack解开）
---@param afterFn function|nil 晚于fn执行，第一个参数为前面执行后的返回值表，后续为fn的参数，返回值作为最终返回值（要求是表或nil，会用unpack解开）
---@param isUseBeforeReturn boolean|nil 在没有afterFn却有beforeFn的时候，是否采用beforeFn的返回值作为最终返回值，默认以原函数的返回值作为最终返回值
function FN.FnDecorator(obj, key, beforeFn, afterFn, isUseBeforeReturn)
    assert(type(obj) == "table")
    assert(beforeFn == nil or type(beforeFn) == "function", "beforeFn must be nil or a function")
    assert(afterFn == nil or type(afterFn) == "function", "afterFn must be nil or a function")

    local oldVal = obj[key]

    obj[key] = function(...)
        local retTab, isSkipOld, newParam, r
        if beforeFn then
            retTab, isSkipOld, newParam = beforeFn(...)
        end

        if type(oldVal) == "function" and not isSkipOld then
            if newParam ~= nil then
                r = { oldVal(unpack(newParam)) }
            else
                r = { oldVal(...) }
            end
            if not isUseBeforeReturn then
                retTab = r
            end
        end

        if afterFn then
            retTab = afterFn(retTab, ...)
        end

        if retTab == nil then
            return nil
        end
        return unpack(retTab)
    end
end

--- 函数扩展参数，可以理解为在原函数前加自己想要的参数
--- 我一般用来让一个函数适配不同对象的同一函数用的，比如不同对象都要初始化SetSpellFn，我只需要在每个对象的SetSpellFn中初始化好param就能在fn中知道是哪个对象的函数了
function FN.FnParameterExtend(fn, param)
    return function(...)
        return fn(param, ...)
    end
end

---合并任意的函数，返回合并的后的函数，执行时按照参数顺序执行
---@param ... function|nil 要合并的函数，支持中间含有nil（也就是说可以不用判断传入函数是否为nil）
---@return function
function FN.MergeFn(...)
    local fns = { ... }
    return function(...)
        for _, v in pairs(fns) do
            v(...)
        end
    end
end

local enablemods
--- 检测是否开启指定MOD，来自风铃草
function FN.IsModEnable(name)
    if not enablemods then
        enablemods = {}
        local moddir = KnownModIndex:GetModsToLoad(true)
        for k, dir in pairs(moddir) do
            local info = KnownModIndex:GetModInfo(dir)
            local name = info and info.name or "unknow"
            enablemods[dir] = name
        end
    end

    for k, v in pairs(enablemods) do
        if v and (k:match(name) or v:match(name)) then return true end
    end
    return false
end

---在StateGraph中根据timline的time获取timeline对应的索引，通过time来查找自己要替换的TimeEvent比直接翻源码查索引要好一点儿，因为别的mod可能会中间插入其他的TimeEvent
---@param timeline table sg的timeline表
---@param time number TimeEvent的time，一般是 数字*FRAMES
---@return integer|nil
function FN.GetStateTimelineIndex(timeline, time)
    for i, timeEvent in ipairs(timeline) do
        if timeEvent.time - time < FN.EPSILON then
            return i
        end
    end
end

local function Chronological(a, b)
    return a.time < b.time
end

---- 为已有的timeline添加新的timeline并排序
function FN.AddStateTimeline(timeline, data)
    for _, tl in ipairs(data) do
        table.insert(timeline, tl)
        table.sort(timeline, Chronological)
    end
end

-- TODO easing.lua文件已经提供了类似的
---基于指数次幂的缓动公式，支持缓入、缓出、缓入缓出三种，将[0,1]的数映射为[0,1]
---@param val number
---@param mode number 模式，1为缓入，2为缓出，3为缓入缓出
---@param k number|nil 系数k，表示函数变化的程度，默认2
function FN.EasingQuad(val, mode, k)
    k = k or 2
    assert(type(val) == "number" and val >= 0 and val <= 1,
        "val == " .. val .. ", The val argument must be numeric and range from 0 to 1")
    assert(mode == 1 or mode == 2 or mode == 3, "The mode parameter must be 1,2 or 3") --防止忘写了

    if mode == 1 then
        return val ^ k
    elseif mode == 2 then
        return 1 - (1 - val) ^ 2
    elseif mode == 3 then
        return val < 0.5 and (2 * val ^ k) or (1 - (-2 * val + 2) ^ k / 2)
    end
end

---查找并返回给定函数中指定名称的upvalue，建议只在初始化时调用
---经常用于获取Prefabs[XXX].fn中想用又大段的local函数，比如三叉戟的技能函数
---需要注意的是有拿不到的风险，其他mod有可能覆盖或包装需要查询的函数，这样就会导致获取不到想要的值，因此需要从多个函数中尝试获取，多次判断
---@param fn function 闭包函数，你希望从中查找upvalue。
---@param upvalueName string 你想要查找的upvalue的名称
---@return any val 查找到的值
---@return integer index 上值的索引，如果这个值为nil则表示没有找到指定的上值
function FN.FindUpvalue(fn, upvalueName)
    local i = 1
    while true do
        local name, value = debug.getupvalue(fn, i)
        if not name then break end -- 没有更多的upvalue了
        if name == upvalueName then
            return value, i
        end
        i = i + 1
    end
end

---链式查询上值，找不到就返回nil，应该比上面那个更常用，因为这个是链式的
function FN.ChainFindUpvalue(fn, ...)
    local val = fn
    local i
    for _, name in ipairs({ ... }) do
        val, i = FN.FindUpvalue(val, name)
        if i == nil then
            return nil
        end
    end
    return val
end

----------------------------------------------------------------------------------------------------

---属性更改监听器，监听表的属性赋值操作，因为元方法__newindex无法监听已有属性的赋值操作，因此实现了该函数，兼容原有的__newindex元方法。
---需要注意的是，一个key对应一个监听函数，对相同key调用多次的话后面的会覆盖前面的，并且如果元表中存在 __metatable键值则该函数会失败
---@param tab table 要监听的表
---@param key string 要监听的属性，可以是尚未赋值的属性
---@param getNewVal function(table,newVal,oldVal):value 属性赋值时调用的函数，反正值为最后的赋值结果，如果不想改变的话别忘了返回newVal
function FN.ListenForTableVal(tab, key, getNewVal)
    assert(type(getNewVal) == "function")

    local originalMetatable = getmetatable(tab) or {}
    local proxyTable = originalMetatable[KEY .. "ProxyTable"] --存储实际数据的表
    if not proxyTable then
        proxyTable = {}
        originalMetatable[KEY .. "ProxyTable"] = proxyTable
    end

    if proxyTable[key] then
        proxyTable[key].fn = getNewVal
        return
    end

    proxyTable[key] = { val = tab[key], fn = getNewVal }
    tab[key] = nil --需要让该值永远保持一个nil的状态才会让赋值操作一直调用__newindex

    local oldIndex = originalMetatable.__index
    originalMetatable.__index = function(table, k)
        if k ~= nil and proxyTable[k] and proxyTable[k].val ~= nil then
            return proxyTable[k].val
        else
            return oldIndex and oldIndex(table, k) or nil
        end
    end

    local oldNewIndex = originalMetatable.__newindex
    originalMetatable.__newindex = function(table, k, v)
        local pt = proxyTable[k] --如果存在则表示该key被监听
        local oldVal = pt and pt.val
        if pt then
            pt.val = pt.fn(table, v, pt.val)
        end

        if oldVal == nil then
            if oldNewIndex then
                oldNewIndex(table, k, v)  --不管有没有监听，只要旧值不存在都调用
                if pt then
                    rawset(table, k, nil) --防止__newindex里面把监听的键赋值了
                end
            else
                if not pt then
                    rawset(table, k, v) --__newindex不存在并且没有监听该数据才会进行赋值
                end
            end
        end
    end

    setmetatable(tab, originalMetatable)
end

---移除表中属性的监听
---@param tab table
---@param key string
function FN.RemoveTableValCallback(tab, key)
    local originalMetatable = getmetatable(tab)
    if not originalMetatable then return end
    local proxyTable = originalMetatable[KEY .. "ProxyTable"]
    if not proxyTable then return end
    proxyTable[key] = nil
end

---移除表中所有属性的监听
---@param tab table
function FN.RemoveAllTableValCallback(tab)
    local originalMetatable = getmetatable(tab)
    if not originalMetatable then return end
    local proxyTable = originalMetatable[KEY .. "ProxyTable"]
    if not proxyTable then return end
    for k, v in pairs(proxyTable) do
        proxyTable[k] = nil
    end
end

---顺时针旋转一个二维表，返回一个新表
---@param tab table 数值表
---@param angle number 旋转角度，0,90,180,270
function FN.RotateTable(tab, angle)
    if angle == 0 then return tab end

    assert(angle == 90 or angle == 180 or angle == 270)
    local res = {}

    local r = #tab
    local c = #tab[1]

    if angle == 90 then
        for i = 1, c do
            local row = {}
            for j = 1, r do
                table.insert(row, tab[r - j + 1][i])
            end
            table.insert(res, row)
        end
    elseif angle == 180 then
        for i = 1, r do
            local row = {}
            for j = 1, c do
                table.insert(row, tab[r - i + 1][c - j + 1])
            end
            table.insert(res, row)
        end
    elseif angle == 270 then
        for i = 1, c do
            local row = {}
            for j = 1, r do
                table.insert(row, tab[j][c - i + 1])
            end
            table.insert(res, row)
        end
    end

    return res
end

--- 创建一维或二维空表
function FN.CreateEmptyTable(row, col, getValFn)
    assert((row > 0 and row < 10000000000) and (not col or col > 0 and col < 10000000000), --限制上限，防止写的时候出现bug开辟空间过大直接导致电脑卡死
        "data exception, row = " .. tostring(row) .. ", col = " .. tostring(col)
        .. ", (row > 0 and row < 10000000000) and (not col or col > 0 and col < 10000000000)")
    local tab = {}
    for _ = 1, row do
        local t = col and {} or getValFn and getValFn() or {}
        if col then
            for _ = 1, col do
                table.insert(t, getValFn and getValFn() or {})
            end
        end
        table.insert(tab, t)
    end
    return tab
end

---设置数组表的值
function FN.ArrayTableFill(arr, val)
    for i = 1, #arr do
        arr[i] = val
    end
end

---将矩形顺时针旋转指定角度后，求矩形中点的新位置，旋转前后均以左上角为原点
---@param xLen number x方向长度
---@param yLen number y方向长度
---@param x number 旋转前x点坐标
---@param y number 旋转前y点坐标
---@param angle number 旋转角度，取值范围有90,180,270
function FN.RotateRectanglePos(xLen, yLen, x, y, angle)
    assert(angle == 0 or angle == 90 or angle == 180 or angle == 270)
    local newX, newY = x, y
    if angle == 90 then
        newX = y
        newY = xLen - x
    elseif angle == 180 then
        newX = xLen - x
        newY = yLen - y
    elseif angle == 270 then
        newX = yLen - y
        newY = x
    end

    return newX, newY
end

----------------------------------------------------------------------------------------------------
--- 读取JSON文件并解析，返回值同pcall，空文件也会返回false
---@param filename string 相对路径，饥荒默认Don't Starve Together\data目录下查找
---@return boolean
---@return table|string
function FN.ReadJsonFile(filename)
    local file = io.open(filename, "r");
    if not file then
        return false, "文件 " .. filename .. " 读取失败，请检查该文件是否存在"
    end

    local json_str = file:read('*a')
    file:close()

    if string.len(json_str) <= 0 then
        return false, "文件 " .. filename .. " 为空文件"
    end

    local status, result = pcall(json.decode, json_str)

    if not status then
        return false, "文件 " .. filename .. " 解析失败，请检查格式是否正确。" .. result
    end

    return true, result
end

local function Append(res, v)
    res.index = (res.index + 1) % (res.maxlen + 1)
    if res.index == 0 then
        res.index = 1
    else
        res.count = math.min(res.count + 1, res.maxlen)
    end

    res.list[res.index] = {
        val = v,
        time = GetTime()
    }
end

local function GetAddTime(res, v)
    for i = 1, #res.maxlen do
        local t = res.list[i]
        if t and t.val == v then
            return t.time
        end
    end
end

---简单改装的缓存队列
---@param maxlen number|nil 队列长度，默认10
function FN.GetCacheList(maxlen)
    if type(maxlen) ~= "number" or maxlen < 1 then
        maxlen = 10
    end

    local res = {}
    res.index = 0
    res.count = 0
    res.maxlen = maxlen
    res.list = {}

    res.Append = Append
    res.GetAddTime = GetAddTime

    return res
end

---把秒数换算成分秒，例如 121 -> 2:01
---@param seconds number
---@return string
function FN.FormatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    return string.format("%d:%02d", minutes, remainingSeconds)
end

---源码对象函数伪造，伪造一个对象的所有函数
---@param obj string|table
function FN.FakeFn(obj)
    if type(obj) == "string" then
        obj = require(obj)
    end

    local res = {}
    for k, v in pairs(obj) do
        if type(v) == "function" then
            res[k] = FN.EmptyFn
        end
    end

    return res
end

local function DefaultServerComponent(name)
    return function(inst, ismastersim)
        if ismastersim then
            inst.components[name] = inst.components[name] or FN.FakeFn(require("components/" .. name))
        end
    end
end
local FAKE_COMPONENTS = {
    sanity = function(inst, ismastersim)
        if ismastersim then
            inst.components.sanity = inst.components.sanity or FN.FakeFn(require("components/sanity"))
        else
            inst.replica.sanity = inst.replica.sanity or FN.FakeFn(require("components/sanity_replica"))
        end
    end,
    timer = DefaultServerComponent("timer"),
    skilltreeupdater = function(inst, ismastersim)
        inst.components.skilltreeupdater = inst.components.skilltreeupdater
            or FN.FakeFn(require("components/skilltreeupdater"))
    end,
    hunger = function(inst, ismastersim)
        if ismastersim then
            inst.components.hunger = inst.components.hunger or FN.FakeFn(require("components/hunger"))
        else
            inst.replica.hunger = inst.replica.hunger or FN.FakeFn(require("components/hunger_replica"))
        end
    end,
    damagetyperesist = DefaultServerComponent("damagetyperesist"),
    damagetypebonus = DefaultServerComponent("damagetypebonus"),
    planardamage = DefaultServerComponent("planardamage"),
    planardefense = DefaultServerComponent("planardefense"),
    temperature = DefaultServerComponent("temperature"),
    moisture = DefaultServerComponent("moisture")
}
--- 伪造组件，也许这个函数是多余的，可以创建组件，不需要伪造
--- 伪造组件只能阻止一般情况的报错，只适合在某个函数里临时使用一下，因为就算源码不报错，insight这类的mod也会报错
function FN.FakeComponent(inst, name, ismastersim)
    local fn = FAKE_COMPONENTS[name]
    if fn then
        fn(inst, ismastersim)
    end
end

----------------------------------------------------------------------------------------------------
---从一个键为对象的键值表中获取指定名字的对象
function FN.GetEntFromKeyByPrefab(ents, prefab)
    if ents then
        for k, _ in pairs(ents) do
            if k.prefab == prefab then
                return k
            end
        end
    end
end

function FN.GetEntsFromKeyByPrefab(ents, prefab)
    local res = {}
    if ents then
        for k, _ in pairs(ents) do
            if k.prefab == prefab then
                table.insert(res, k)
            end
        end
    end
    return res
end

---从一个键为对象的键值表中获取指定对象
function FN.GetEntFromKeyByTags(ents, mustTags, cantTags, oneOfTags)
    if ents then
        for k, _ in pairs(ents) do
            if (not mustTags or k:HasTags(mustTags))
                and (not cantTags or not k:HasOneOfTags(cantTags))
                and (not oneOfTags or k:HasOneOfTags(oneOfTags))
            then
                return k
            end
        end
    end
end

---从一个键为对象的键值表中获取指定对象
function FN.GetEntsFromKeyByTags(ents, mustTags, cantTags, oneOfTags)
    local res = {}
    if ents then
        for k, _ in pairs(ents) do
            if (not mustTags or k:HasTags(mustTags))
                and (not cantTags or not k:HasOneOfTags(cantTags))
                and (not oneOfTags or k:HasOneOfTags(oneOfTags))
            then
                table.insert(res, k)
            end
        end
    end
    return res
end

local function simpleHash(str)
    local hash = 0
    local prime = 4294967311 -- 使用一个较大的质数作为模数
    for i = 1, #str do
        hash = (hash * 31 + str:byte(i)) % prime
    end
    return hash
end

local function toBase26(num)
    local t = {}
    repeat
        local remainder = num % 26
        if remainder == 0 then remainder = 26 end       -- 避免0的情况，因为0没有对应的字母
        table.insert(t, 1, string.char(64 + remainder)) -- A = 65
        num = (num - remainder) / 26
    until num == 0
    return table.concat(t)
end

---使用哈希算法将中文名转字母并拼接
---@param chineName string 中文名
---@param prefix string|nil 前缀
---@return string
function FN.ChineseToVariable(chineName, prefix)
    local hash = simpleHash(chineName)
    return (prefix or "") .. string.lower(toBase26(hash))
end

return FN
