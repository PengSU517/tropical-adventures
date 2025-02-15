local buffattr = {
    speedup = {
        coffee                = { priority = 5, mult = TUNING.COFFEE_SPEED_INCREASE + 1, duration = TUNING.BUFF_COFFEE_DURATION, name = "buff_speedup_tro_4", },
        coffeebean            = { priority = 4, mult = TUNING.COFFEE_SPEED_INCREASE + 1, duration = TUNING.BUFF_COFFEE_DURATION / 8, name = "buff_speedup_tro_4", },
        tropicalbouillabaisse = { priority = 3, mult = TUNING.BOUILLABAISSE_SPEED_MODIFIER, duration = TUNING.BUFF_BOUILLABAISSE_DURATION, name = "buff_speedup_tro_3", },
        tea                   = { priority = 2, mult = TUNING.COFFEE_SPEED_INCREASE / 2 + 1, duration = TUNING.BUFF_COFFEE_DURATION / 2, name = "buff_speedup_tro_2", },
        icedtea               = { priority = 1, mult = TUNING.COFFEE_SPEED_INCREASE / 3 + 1, duration = TUNING.BUFF_COFFEE_DURATION / 3, name = "buff_speedup_tro_1", },
    },
    poisoned = {
        poisoned  = {name = "buff_poisoned_tro"},
        antitoxin = {name = "buff_antitoxin_tro"},
    }
}

local function NameOverrideFns(name)
    return function(target, buff_info)
        for k, v in pairs(buff_info) do
            if v.buffname == "buff_" .. name .. "_tro" then
                table.remove(buff_info, k)
                break
            end
        end
        for _, v in pairs(target.components.debuffable.debuffs) do
            if v.inst and v.inst._debuffkey_tro then
                local buffdata = {
                    buffname = buffattr[name][v.inst._debuffkey_tro].name,
                    bufftime = math.floor(target.components.medal_showbufftime:getBuffTime(v.inst)),
                }
                table.insert(buff_info, buffdata)
                break
            end
        end
    end
end

local fns = {
    speedup = {},
    poisoned = {},
    antitoxin = {},
}

fns.speedup.attach = function(inst, target, followsymbol, followoffset, data)
    if data then
        inst._debuffkey_tro = data.debuffkey
        inst.components.timer:StopTimer("buffover")
        inst.components.timer:StartTimer("buffover", buffattr.speedup[data.debuffkey].duration)
    end
    if target.components.locomotor then
        target.components.locomotor:SetExternalSpeedMultiplier(inst, "speedup_tro", data and data.debuffkey and
            buffattr.speedup[data.debuffkey].mult or inst._debuffkey_tro and buffattr.speedup[inst._debuffkey_tro].mult or 1) -- 进入世界时
        if target.components.medal_showbufftime then
            target.components.medal_showbufftime:SetGetBuffInfoFn(NameOverrideFns("speedup"))
        end
    end
end

fns.speedup.extend = function(inst, target, followsymbol, followoffset, data)
    if not inst._debuffkey_tro then
        fns.speedup.attach(inst, target, followsymbol, followoffset, data)
    end
    if not data then
        return
    end
    if buffattr.speedup[data.debuffkey].priority > buffattr.speedup[inst._debuffkey_tro].priority then
        inst.components.timer:StopTimer("buffover")
        inst.components.timer:StartTimer("buffover", buffattr.speedup[data.debuffkey].duration)
        if target.components.locomotor then
            target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "speedup_tro")
            target.components.locomotor:SetExternalSpeedMultiplier(inst, "speedup_tro", buffattr.speedup[data.debuffkey].mult)
            if target.components.medal_showbufftime then
                target.components.medal_showbufftime:SetGetBuffInfoFn(NameOverrideFns("speedup"))
            end
        end
        inst._debuffkey_tro = data.debuffkey
    elseif data.debuffkey == inst._debuffkey_tro then
        inst.components.timer:StopTimer("buffover")
        inst.components.timer:StartTimer("buffover", buffattr.speedup[data.debuffkey].duration)
    end
end

fns.speedup.detach = function(inst, target)
    if target.components.locomotor then
        target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "speedup_tro")
    end
    inst._debuffkey_tro = nil
end

fns.poisoned.attach = function(inst, target, followsymbol, followoffset, data)
    if not data or not target.components.medal_showbufftime then return end
    inst.components.timer:StopTimer("buffover")
    inst.components.timer:StartTimer("buffover", data.duration)
    inst._debuffkey_tro = data.debuffkey
    if target.components.medal_showbufftime then
        target.components.medal_showbufftime:SetGetBuffInfoFn(NameOverrideFns("poisoned"))
    end
end

fns.poisoned.extend = fns.poisoned.attach

local function OnTimerDone(inst, data)
    if data.name == "buffover" then
        inst.components.debuff:Stop()
    end
end

local function onsave(inst, data)
    if inst._debuffkey_tro then
        data._debuffkey_tro = inst._debuffkey_tro
    end
end

local function onload(inst, data)
    if data._debuffkey_tro then
        inst._debuffkey_tro = data._debuffkey_tro
    end
end

local function MakeBuff(name, duration, priority, prefabs)
    local ATTACH_BUFF_DATA = {
        -- buff = "ANNOUNCE_ATTACH_BUFF_"..string.upper(name),
        priority = priority
    }
    local DETACH_BUFF_DATA = {
        -- buff = "ANNOUNCE_DETACH_BUFF_"..string.upper(name),
        priority = priority
    }

    local function OnAttached(inst, target, ...)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)

        target:PushEvent("foodbuffattached", ATTACH_BUFF_DATA)
        if fns[name].attach ~= nil then
            fns[name].attach(inst, target, ...)
        end
    end

    local function OnExtended(inst, target, ...)
        if duration and duration > 0 then
            inst.components.timer:StopTimer("buffover")
            inst.components.timer:StartTimer("buffover", duration)
        end

        target:PushEvent("foodbuffattached", ATTACH_BUFF_DATA)
        if fns[name].extend ~= nil then
            fns[name].extend(inst, target, ...)
        end
    end

    local function OnDetached(inst, target, ...)
        if fns[name].detach ~= nil then
            fns[name].detach(inst, target, ...)
        end

        target:PushEvent("foodbuffdetached", DETACH_BUFF_DATA)
        inst:Remove()
    end

    local function fn()
        local inst = CreateEntity()

        if not TheWorld.ismastersim then
            --Not meant for client!
            inst:DoTaskInTime(0, inst.Remove)
            return inst
        end

        inst.entity:AddTransform()

        --[[Non-networked entity]]
        --inst.entity:SetCanSleep(false)
        inst.entity:Hide()
        inst.persists = false

        inst:AddTag("CLASSIFIED")

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(OnAttached)
        inst.components.debuff:SetDetachedFn(OnDetached)
        inst.components.debuff:SetExtendedFn(OnExtended)
        inst.components.debuff.keepondespawn = true

        inst:AddComponent("timer")
        inst.components.timer:StartTimer("buffover", duration)
        inst:ListenForEvent("timerdone", OnTimerDone)

        if TUNING.FUNCTIONAL_MEDAL_IS_OPEN then
        end

        if duration == 0 then
            inst.OnSave = onsave
            inst.OnLoad = onload
        end

        return inst
    end

    return Prefab("buff_" .. name .. "_tro", fn, nil, prefabs)
end

-- Make dynamic buffs
return MakeBuff("speedup", 0, 2),
    MakeBuff("poisoned", 0, 1)
    -- MakeBuff("antitoxin", 0, 1)

-- Runar: These are here to make this file findable.
-- buff_speedup_tro
-- buff_speedup_tro_1
-- buff_speedup_tro_2
-- buff_speedup_tro_3
-- buff_speedup_tro_4
-- buff_poisoned_tro
-- buff_antitoxin_tro