local Upvaluehelper = Upvaluehelper
local AddPrefabPostInit = AddPrefabPostInit

GLOBAL.setfenv(1, GLOBAL)
if not (rawget(_G, "EventTimer") and rawget(_G, "WarningEvents")) then return end

local TimeToString = EventTimer.env.TimeToString -- 格式化时间
local ReplacePrefabName = EventTimer.env.ReplacePrefabName -- 填充Prefab名字
local Extract_by_format = EventTimer.env.Extract_by_format -- 反向提取信息
local ModLanguage = EventTimer.env.ModLanguage -- 语言

local function zh_en(zh, en)
    return ModLanguage == "zh" and zh or en
end

-- 如果event_time > 0，在刚进入游戏的1~10秒内返回true
local function JustEntered(event_time)
    if not checknumber(event_time) then return end
    return GetTime() > 1 and GetTime() < 10 and event_time > 0
end

-- 将字符串打包为一个返回该字符串的函数
local function StringToFunction(str)
    return function()
        return str
    end
end

-- 当time在0~2秒时返回true
local function ready_attack(time)
    if not checknumber(time) then return end
    if time < 2 and time > 0 then
        return true
    end
    return false
end

-- 【全局事件计时器】模组外的字符串填在此处
local strings = {
    aporkalypse = { -- 大灾变
        attack = zh_en(
            "下一次<prefab=vampirebat>袭击: %s\n下一次<prefab=ancient_herald>袭击: %s",
            "Next <prefab=vampirebat> attack: %s\nNext <prefab=ancient_herald> attack: %s"
        ),
        announce_attack = zh_en(
            "下一次<prefab=vampirebat>袭击: %s    下一次<prefab=ancient_herald>袭击: %s",
            "Next <prefab=vampirebat>attack: %s    Next <prefab=ancient_herald> attack: %s"
        ),
        attacked = zh_en(
            "已袭击",
            "Has attacked"
        ),
    },
    banditmanager = { -- 蒙面猪人
        cooldown = zh_en(
            "<prefab=pigbandit>将于%s后尝试刷新。",
            "<prefab=pigbandit> will try to spawn in %s"
        ),
        ready = zh_en(
            "<prefab=pigbandit>正在出没。",
            "<prefab=pigbandit> is present."
        ),
        tips = zh_en(
            "警告：<prefab=pigbandit>正在出没！",
            "Warning: <prefab=pigbandit> is present!"
        ),
    },
    tigersharktorch = { -- 虎鲨
        tips = zh_en(
            "<prefab=tigershark>已刷新！",
            "<prefab=tigershark> has regenerate!"
        )
    },
    slipstor_spawner = { -- 大滑怪
        cooldown = zh_en(
            "<prefab=slipstor>会重生于%s后",
            "<prefab=slipstor> will respawn in %s"
        ),
    },
    firetwister_spawner = { -- 火豹卷
        cooldown = zh_en(
            "<prefab=firetwister>会重生于%s后",
            "<prefab=firetwister> will respawn in %s"
        ),
        tips = zh_en(
            "<prefab=firetwister>已重生！",
            "<prefab=firetwister> has respawned!"
        )
    },
    wildboreking_spawner = { -- 野猪王
        cooldown = zh_en(
            "<prefab=wildboreking>会重生于%s后",
            "<prefab=wildboreking> will respawn in %s"
        ),
        tips = zh_en(
            "<prefab=wildboreking>已重生！",
            "<prefab=wildboreking> has respawned!"
        )
    },
}

local function GetTimeTnSeconds()
    return (TheWorld.state.cycles + TheWorld.state.time) * TUNING.TOTAL_DAY_TIME
end

--------------------------------------------------------------------------------------------------------------

local TimerPrefabList = {
    "kraken_spawner", -- 海妖
    "tigersharktorch", -- 虎鲨
    "slipstor_spawner", -- 大滑怪
    "firetwister_spawner", -- 火豹卷
    "wildboreking_spawner", -- 野猪王
}

local timerprefabs = {}
for _, prefab in ipairs(TimerPrefabList) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        timerprefabs[prefab] = inst

        inst:ListenForEvent("onremove", function()
            timerprefabs[prefab] = nil
        end)
    end)
end

local function GetTimeLeft(name, prefab)
    return function()
        local ent = timerprefabs[prefab]
        if ent and ent.components.timer then
            if not ent.components.timer:IsPaused(name) then
                local time = ent.components.timer:GetTimeLeft(name)
                return time and time < 65535 and time
            end
        end
    end
end

-- 从worldsettingstimer或TimerPrefabs获取倒计时
local function GetWorldSettingsTimeLeft(name, prefab)
    return function()
        local ent = TheWorld
        if prefab then
            ent = rawget(_G, "TimerPrefabs") and TimerPrefabs[prefab]
        end
        if ent and ent.components.worldsettingstimer then
            if not ent.components.worldsettingstimer:IsPaused(name) then
                local time = ent.components.worldsettingstimer:GetTimeLeft(name)
                return time and time < 65535 and time
            end
        end
    end
end

--------------------------------------------------------------------------------------------------------------

local TropicalAdventuresEvents -- 提前定义以便调用自己 别手欠改了 不然会炸
TropicalAdventuresEvents = {

    ---------------------------------------- 猪镇 ---------------------------------------

    aporkalypse = { -- 大灾变倒计时
        gettimefn = function()
            return TheWorld.components.aporkalypse and (not TheWorld.components.aporkalypse:IsActive()) and TheWorld.components.aporkalypse.begin_date - GetTimeTnSeconds()
        end,
        gettextfn = function(time)
            if time and time > 0 then
                return string.format(STRINGS.eventtimer.aporkalypse.cooldown, TimeToString(time))
            end
        end,
        image = {
			atlas = "images/Aporkalypse_Clock.xml",
			tex = "Aporkalypse_Clock.tex",
            scale = 0.2
        },
        DisableShardRPC = true, -- 地上地下都有这个组件，同步会冲突
        announcefn = function()
            local time = ThePlayer.HUD.WarningEventTimeData.aporkalypse_time
            if time and time > 0 then
                return string.format(STRINGS.eventtimer.aporkalypse.cooldown, TimeToString(time))
            end
        end,
        tipsfn = function()
            local time = ThePlayer.HUD.WarningEventTimeData.aporkalypse_time

            if (JustEntered(time) and time < 2400) then
                return true, string.format(STRINGS.eventtimer.aporkalypse.cooldown, TimeToString(time)), 10, nil, 1
            elseif time == 480 then
                return true, string.format(STRINGS.eventtimer.aporkalypse.tips, TimeToString(time)), 10, nil, 2
            elseif time == 0 then -- 这个写法比较特殊..为了保证大灾变确实开始了
                return true, not (GetTime() > 1 and GetTime() < 10) and StringToFunction(STRINGS.eventtimer.aporkalypse.tips_ready), 5, 1, 3 -- 延迟1秒是因为大灾变在1秒后才真正开始
            end
            return false
        end
    },
    aporkalypse_attack = { -- 大灾变中的事件倒计时（蝙蝠袭击、远古先驱袭击）
        gettimefn = function()
            if TheWorld.components.aporkalypse and TheWorld.components.aporkalypse:IsActive() then
                if TheWorld:HasTag("cave") then
                    return TheWorld.components.aporkalypse:GetHeraldTimer() -- 先驱
                else
                    return TheWorld.components.aporkalypse:GetVampireTimer() -- 蝙蝠
                end
            end
        end,
        gettextfn = function(time)
            if time and time > 0 then
                if TheWorld:HasTag("cave") then
                    local VampireTimer = TheWorld.components.aporkalypse:GetVampireTimer()
                    return string.format(ReplacePrefabName(strings.aporkalypse.attack), VampireTimer == 0 and strings.aporkalypse.attacked or TimeToString(VampireTimer), TimeToString(time))
                else
                    return string.format(ReplacePrefabName(STRINGS.eventtimer.batted.cooldown), TimeToString(time))
                end
            end
        end,
        imagechangefn = function(self)
            if TheWorld:HasTag("cave") then
                self.image = self.caveimage
            else
                self.image = self.forestimage
            end
        end,
        forestimage = { -- 灾变日历的图片
			atlas = "images/Aporkalypse_Clock.xml",
			tex = "Aporkalypse_Clock.tex",
            scale = 0.2
        },
        caveimage = { -- 远古先驱的图片
			atlas = "images/Ancient_Herald.xml",
			tex = "Ancient_Herald.tex",
            scale = 0.2,
            offset = {
                x = 0,
                y = 7,
            }
        },
        announcefn = function()
            if TheWorld:HasTag("cave") then
                local text = ThePlayer.HUD.WarningEventTimeData.aporkalypse_attack_text
                local VampireTimer, HeraldTimer = Extract_by_format(text, ReplacePrefabName(strings.aporkalypse.attack))
                if not (VampireTimer and HeraldTimer) then return end
                return string.format(ReplacePrefabName(strings.aporkalypse.announce_attack), VampireTimer, HeraldTimer)
            else
                local time = ThePlayer.HUD.WarningEventTimeData.aporkalypse_attack_time
                if time and time > 0 then
                    return string.format(ReplacePrefabName(STRINGS.eventtimer.batted.cooldown), TimeToString(time))
                end
            end
        end,
        DisableShardRPC = true,
        tipsfn = nil,
    },
    rocmanager = { -- 友善的大鹏
        gettimefn = function()
            if TheWorld.components.rocmanager then
                return TheWorld.components.rocmanager.nexttime
            end
        end,
        gettextfn = function(time)
            local self = TheWorld.components.rocmanager
            if not self then return end
            local data = self:OnSave()
            if data.roc then
                return ReplacePrefabName(STRINGS.eventtimer.rocmanager.exists)
            end
            if time and time > 0 then
                return TimeToString(time)
            end
        end,
        image = {
			atlas = "images/Roc.xml",
			tex = "Roc.tex",
		},
        anim = {
            scale = 0.008,
            build = "roc_head_build",
            bank = "head",
            animation = "idle_loop",
            loop = true,
            offset = {
                x = 0,
                y = -15,
            },
        },
        announcefn = function()
            local time = ThePlayer.HUD.WarningEventTimeData.rocmanager_time
            local text = ThePlayer.HUD.WarningEventTimeData.rocmanager_text
            if text and string.find(text, ReplacePrefabName(STRINGS.eventtimer.rocmanager.exists)) then
                return ReplacePrefabName(STRINGS.eventtimer.rocmanager.exists)
            elseif time and time > 0 then
                return string.format(ReplacePrefabName(STRINGS.eventtimer.rocmanager.cooldown), TimeToString(time))
            end
        end,
        tipsfn = function()
            local time = ThePlayer.HUD.WarningEventTimeData.rocmanager_time
            local text = ThePlayer.HUD.WarningEventTimeData.rocmanager_text
            if time > TUNING.SEG_TIME / 2 and time <= 90 then
                return true, TropicalAdventuresEvents.rocmanager.announcefn, 10, nil, 2
            elseif JustEntered(time) and time < 960 then
                return true, TropicalAdventuresEvents.rocmanager.announcefn, 10, nil, 2
            elseif text == ReplacePrefabName(STRINGS.eventtimer.rocmanager.exists) then
                return true, StringToFunction(ReplacePrefabName(STRINGS.eventtimer.rocmanager.tips)), 10, nil, 3
            elseif JustEntered(time) then
                return true, TropicalAdventuresEvents.rocmanager.announcefn, 10, nil, 1
            end
            return false
        end
    },
    banditmanager = {
        gettimefn = GetWorldSettingsTimeLeft("pig_bandit_respawn"),
        gettextfn = function(time)
            local self = TheWorld.components.banditmanager
            if not self then return end
            local _bandit = Upvaluehelper.GetUpvalue(self.SpawnBanditOnPlayer, "_bandit")
            if _bandit then
                return ReplacePrefabName(strings.banditmanager.ready)
            else
                return TimeToString(time)
            end
        end,
        image = {
			atlas = "images/pig_bandit.xml",
			tex = "pig_bandit.tex",
            scale = 0.07,
        },
        anim = {
            scale = 0.07,
            build = "pig_bandit",
            bank = "townspig",
            animation = "idle_loop",
            loop = true,
            uioffset = {
                x = 0,
                y = -15,
            }
        },
        DisableShardRPC = true,
        announcefn = function()
            local time = ThePlayer.HUD.WarningEventTimeData.banditmanager_time
            if time and time > 0 then
                return string.format(ReplacePrefabName(strings.banditmanager.cooldown), TimeToString(time))
            end
        end,
        tipsfn = function()
            local text = ThePlayer.HUD.WarningEventTimeData.banditmanager_text
            local ready = text == ReplacePrefabName(strings.banditmanager.ready)
            if ready then
                return true, StringToFunction(ReplacePrefabName(strings.banditmanager.tips)), 5, nil, 3
            end
        end
    },

    ---------------------------------------- 海难 ---------------------------------------

    twisterspawner = { -- 豹卷风
        gettimefn = function()
            if TheWorld.components.twisterspawner then
                local data = TheWorld.components.twisterspawner:OnSave()
                return data.timetospawn
            end
        end,
        gettextfn = function(time)
            local self = TheWorld.components.twisterspawner
            if not self then return end
            local description
            local target = Upvaluehelper.GetUpvalue(self.OnUpdate, "_targetplayer")
            if time and target and target.name then
                description = string.format(STRINGS.eventtimer.twisterspawner.targeted, target.name, TimeToString(time))
            elseif time then
                description = string.format(ReplacePrefabName(STRINGS.eventtimer.twisterspawner.cooldown), TimeToString(time))
            end

            return description
        end,
        image = {
            atlas = "images/Twister.xml",
            tex = "Twister.tex",
            scale = 0.35,
        },
        anim = {
            scale = 0.03,
            bank = "twister",
            build = "twister_build",
            animation = "idle_loop",
            loop = true
        },
        announcefn = function()
            local time = ThePlayer.HUD.WarningEventTimeData.twisterspawner_time
            local text = ThePlayer.HUD.WarningEventTimeData.twisterspawner_text
            local target, _ = Extract_by_format(text, STRINGS.eventtimer.twisterspawner.targeted)
            if target and time then
                return string.format(ReplacePrefabName(STRINGS.eventtimer.twisterspawner.target), target, TimeToString(time))
            elseif time then
                return string.format(ReplacePrefabName(STRINGS.eventtimer.twisterspawner.cooldown), TimeToString(time))
            end
        end,
        tipsfn = function()
            local time = ThePlayer.HUD.WarningEventTimeData.twisterspawner_time
            if time > 2 and time <= 60 then
                return true, TropicalAdventuresEvents.twisterspawner.announcefn, time, nil, 2
            elseif time == 480 or JustEntered(time) then
                return true, TropicalAdventuresEvents.twisterspawner.announcefn, 10, nil, 2
            elseif ready_attack(time) then
                return true, StringToFunction(ReplacePrefabName(STRINGS.eventtimer.twisterspawner.attack)), 10, time, 3
            end
            return false
        end
    },
    kraken_spawner = { -- 海妖
        gettimefn = GetTimeLeft("spawndelay" ,"kraken_spawner"),
        anim = {
            scale = 0.027,
            bank = "quacken",
            build = "quacken",
            animation = "idle_loop",
            loop = true,
            uioffset = {
                x = 0,
                y = -6,
            },
        },
        announcefn = function()
            local time = ThePlayer.HUD.WarningEventTimeData.kraken_spawner_time
            if time and time > 0 then
                return string.format(ReplacePrefabName(STRINGS.eventtimer.krakener.cooldown), TimeToString(time))
            end
        end,
        tipsfn = function()
            local time = ThePlayer.HUD.WarningEventTimeData.kraken_spawner_time
            if ready_attack(time) then
                return true, StringToFunction(ReplacePrefabName(STRINGS.eventtimer.krakener.tips)), 10, time, 2
            end
            return false
        end
    },
    tigersharktorch = { -- 虎鲨
        gettimefn = GetTimeLeft("spawndelay" ,"tigersharktorch"),
        anim = {
            scale = 0.03,
            bank = "tigershark",
            build = "tigershark_ground_build",
            animation = "taunt",
            loop = true,
            uioffset = {
                x = -6,
                y = -6,
            },
        },
        announcefn = function()
            local time = ThePlayer.HUD.WarningEventTimeData.tigersharktorch_time
            if time and time > 0 then
                return string.format(ReplacePrefabName(STRINGS.eventtimer.tigersharker.cooldown), TimeToString(time))
            end
        end,
        tipsfn = function()
            local time = ThePlayer.HUD.WarningEventTimeData.tigersharktorch_time
            if ready_attack(time) then
                return true, StringToFunction(ReplacePrefabName(strings.tigersharktorch.tips)), 10, time, 2
            end
            return false
        end
    },
    slipstor_spawner = { -- 大滑怪
        gettimefn = GetTimeLeft("spawndelay" ,"slipstor_spawner"),
        anim = {
            scale = 0.07,
            bank = "slipstor",
            build = "slipstor_build",
            animation = "idle_loop",
            loop = true,
            uioffset = {
                x = -3,
                y = -6,
            },
        },
        announcefn = function()
            local time = ThePlayer.HUD.WarningEventTimeData.slipstor_spawner_time
            if time and time > 0 then
                return string.format(ReplacePrefabName(strings.slipstor_spawner.cooldown), TimeToString(time))
            end
        end
    },
    firetwister_spawner = { -- 火豹卷
        gettimefn = GetTimeLeft("spawndelay" ,"firetwister_spawner"),
        anim = {
            scale = 0.03,
            bank = "twister",
            build = "twister_build",
            animation = "idle_loop",
            multcolour = {255 / 255, 150 / 255, 0 / 255, 1},
            loop = true,
            uioffset = {
                x = 0,
                y = -5,
            },
            offset = {
                x = 0,
                y = -3,
            },
        },
        announcefn = function()
            local time = ThePlayer.HUD.WarningEventTimeData.firetwister_spawner_time
            if time and time > 0 then
                return string.format(ReplacePrefabName(strings.firetwister_spawner.cooldown), TimeToString(time))
            end
        end,
        tipsfn = function()
            local time = ThePlayer.HUD.WarningEventTimeData.firetwister_spawner_time
            if ready_attack(time) then
                return true, StringToFunction(ReplacePrefabName(strings.firetwister_spawner.tips)), 10, time, 2
            end
            return false
        end
    },
    wildboreking_spawner = { -- 野猪王
        gettimefn = GetTimeLeft("spawndelay" ,"wildboreking_spawner"),
        anim = {
            scale = 0.055,
            bank = "pigkingext",
            build = "pigkingext",
            animation = "lying",
            loop = true,
            uioffset = {
                x = -2,
                y = 1,
            },
            offset = {
                x = 0,
                y = 1,
            },
        },
        announcefn = function()
            local time = ThePlayer.HUD.WarningEventTimeData.wildboreking_spawner_time
            if time and time > 0 then
                return string.format(ReplacePrefabName(strings.wildboreking_spawner.cooldown), TimeToString(time))
            end
        end,
        tipsfn = function ()
            local time = ThePlayer.HUD.WarningEventTimeData.wildboreking_spawner_time
            if ready_attack(time) then
                return true, StringToFunction(ReplacePrefabName(strings.wildboreking_spawner.tips)), 10, time, 2
            end
            return false
        end
    }
}

for k, v in pairs(TropicalAdventuresEvents) do
    _G.WarningEvents[k] = v
end