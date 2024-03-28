--@author: 绯世行
--欢迎其他开发者直接使用，但是强烈谴责搬用代码后对搬用代码加密的行为！
--使用案例及最新版：https://n77a3mjegs.feishu.cn/docx/K9bUdpb5Qo85j2xo8XkcOsU1nuh?from=from_copylink

local FN = {}

local _source = debug.getinfo(1, 'S').source
local KEY = "_" .. _source:match(".*scripts[/\\](.*)%.lua"):gsub("[/\\]", "_") .. "_" --_XXX_utils_shapes

local Utils = require(_source:match(".*scripts[/\\](.*[/\\])") .. "utils")

---重置计时器，因为timer没有这样的方法就自己写个简单的
function FN.ResetTimer(inst, name, ...)
    if inst.components.timer then
        if inst.components.timer:TimerExists(name) then
            inst.components.timer:StopTimer(name)
        end
        inst.components.timer:StartTimer(name, ...)
    end
end

function FN.ResetTimeTask(inst, taskName, ...)
    if inst[taskName] then
        inst[taskName]:Cancel()
    end
    inst[taskName] = inst:DoTaskInTime(...)
end

---用给定的时间间隔曲线周期性执行所给函数，与DoPeriodicTask不同，该函数可根据执行次数动态修改下一次执行的时间间隔，循环没有结束条件，只有当intervalFn返回nil或者inst被移除才结束
---@param inst Entity 启用线程的主体，虽然可以直接启用线程，但是没有个主体我觉得不好
---@param intervalFn function 时间间隔曲线函数，参数count为执行次数，从0开始，0表示初始延迟，返回值为第count执行后间隔秒数，返回值为nil时将结束线程
---@param actionFn function 每次执行的函数，count从1开始
---@return task Task 可通过KillThread(task) 来结束线程
function FN.PeriodicExecutor(inst, intervalFn, actionFn)
    return inst:StartThread(function()
        local count = 0

        while true do
            local interval = intervalFn(count)
            if interval == nil then return end
            count = count + 1
            Sleep(interval)
            actionFn(count)
        end
    end)
end

---用于一段时间内连续的效果，根据执行次数和超时时间来决定执行情况
---@param inst Entity 延时任务的启动者
---@param fn function 每次执行的任务，两个参数(index,inst)，第一个参数是任务索引，第二个是任务执行者inst
---@param count number 执行次数
---@param data table|nil
function FN.ScheduleRepeatingTasks(inst, fn, count, data)
    local minGap = Utils.GetVal(data, "minGap", 0.1)    -- 相邻任务之间的最小时间间隔
    local maxGap = Utils.GetVal(data, "minGap", 1)      -- 相邻任务之间的最大时间间隔
    local timeout = Utils.GetVal(data, "timeout")       -- 超时时间，如果任务时间到达或超出这个值将不再继续，直接执行onFinishFn
    local onFinishFn = Utils.GetVal(data, "onFinishFn") -- 当所有任务执行完毕后调用，两个参数(index,inst)，第一个参数是任务索引，第二个是任务执行者inst
    local initDelay = Utils.GetVal(data, "initDelay",
        math.random() * (maxGap - minGap) + minGap)     --第一次执行前的延迟，默认也是随机

    local lastTime = initDelay
    local i = 1
    while i <= count and (not timeout or lastTime < timeout) do
        inst:DoTaskInTime(lastTime, Utils.FnParameterExtend(fn, i))
        -- inst:DoTaskInTime(lastTime, fn)
        lastTime = lastTime + math.clamp(math.random(), minGap, maxGap)
        i = i + 1
    end

    if onFinishFn then
        inst:DoTaskInTime(timeout or lastTime, Utils.FnParameterExtend(onFinishFn, i))
    end
end

---一个简单的定时器，修改对象的属性值，并在指定时间后设置第二个值
---流程：obj[key] = firstVal，time秒后obj[key] = secondVal
---@param inst Entity 由该对象开启和存储定时任务，一般是obj的拥有者
---@param obj any table
---@param key string key
---@param time number
---@param firstVal any 初始值
---@param secondVal any time秒后的值
function FN.ValTimer(inst, obj, key, time, firstVal, secondVal)
    local taskKey = KEY .. "ValTimer"
    if inst[taskKey] then
        inst[taskKey]:Cancel()
    end

    obj[key] = firstVal
    inst[taskKey] = inst:DoTaskInTime(time, function()
        obj[key] = secondVal
        inst[taskKey] = nil
    end)
end

---针对sourcemodifierlist写了一个定时buff，初始调用SetModifier，一段时间后调用RemoveModifier
---@param inst Entity 由该对象开启和存储定时任务，一般是sourceModifier的拥有者
---@param sourceModifier SourceModifierList
---@param time number 多少秒后移除
---@param source any 一般是Entity
---@param val any
---@param key string|nil
function FN.SourceModifierTimer(inst, sourceModifier, time, source, val, key)
    key = KEY .. (key or "SourceModifierTimer")
    if inst[key] then
        inst[key]:Cancel()
    end

    sourceModifier:SetModifier(source, val, key)
    inst[key] = inst:DoTaskInTime(time, function()
        sourceModifier:RemoveModifier(source, key)
        inst[key] = nil
    end)
end

return FN
