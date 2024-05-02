--@author: 绯世行
--欢迎其他开发者直接使用，但是强烈谴责搬用代码后对搬用代码加密的行为！
--使用案例及最新版：https://n77a3mjegs.feishu.cn/docx/K9bUdpb5Qo85j2xo8XkcOsU1nuh?from=from_copylink

--初始化一些数据结构

local FN = {}
local _source = debug.getinfo(1, 'S').source
local KEY = "_" .. _source:match(".*scripts[/\\](.*)%.lua"):gsub("[/\\]", "_") .. "_"
local Utils = require(_source:match(".*scripts[/\\](.*[/\\])") .. "utils")

---虽然写了，但是感觉挺麻烦的，不如结合childspawner和entitytracker自定义个组件
---强化EntityTracker记录多对象的功能，后面追加索引的方式添加同类型对象，当前索引位置不存在对象时，从某位查找对象替代该位置
function FN.EnhanceEntitytrackerTrackEntity()
    local self = require("components/entitytracker")

    self[KEY .. "entList"] = {}

    self[KEY .. "TrackEntity"] = function(self, name, ent)
        local count = self[KEY .. "entList"][name]

        count = (count or 0) + 1
        self[KEY .. "entList"][name] = count

        self:TrackEntity(name .. tostring(count), ent)
    end

    self[KEY .. "ForeachEntity"] = function(self, name, fn)
        local count = self[KEY .. "entList"][name]
        if not count then return end
        local endIndex = count
        for i = 1, count do
            local ent = self:GetEntity(name .. tostring(count))
            if not ent then
                --交换位置
                while endIndex > i do
                    ent = self:GetEntity(name .. tostring(endIndex))
                    endIndex = endIndex - 1

                    if ent then
                        self:TrackEntity(name .. tostring(i), ent)
                        self:ForgetEntity(name .. tostring(endIndex + 1))
                        break
                    end
                end
            end

            if ent then
                fn(ent)
            else
                break
            end
        end

        self[KEY .. "entList"][name] = endIndex
    end
end

---允许玩家通过trader给予道具允许每次给予一组，在onaccept中不要忘了可能是一组道具
---@param checkFn function 校验函数，如果为true则表示可以给予一组
function FN.AllowTraderGiveAll(GLOBAL, checkFn)
    assert(checkFn)

    Utils.FnDecorator(GLOBAL.ACTIONS.GIVE, "fn", function(act)
        if act.target ~= nil
            and not (act.target:HasTag("playbill_lecturn") and act.invobject.components.playbill)
            and not (act.target.components.ghostlyelixirable ~= nil and act.invobject.components.ghostlyelixir ~= nil)
            and act.target.components.trader ~= nil then
            local able, reason = act.target.components.trader:AbleToAccept(act.invobject, act.doer)
            if not able then
                return { false, reason }, true
            end

            act.target.components.trader:AcceptGift(act.doer, act.invobject,
                checkFn(act) and GetStackSize(act.invobject) or nil)
            return { true }, true
        end
    end)
end

--- 修复Inventory的GetItemsWithTag方法bug，无法正确获取手上物品
function FN.RepairInventoryGetItemsWithTag()
    local Inventory = require("components/inventory")
    function Inventory:GetItemsWithTag(tag)
        local items = {}
        for k, v in pairs(self.itemslots) do
            if v and v:HasTag(tag) then
                table.insert(items, v)
            end
        end

        if self.activeitem and self.activeitem:HasTag(tag) then
            table.insert(items, self.activeitem) --修复这里
        end

        local overflow = self:GetOverflowContainer()
        if overflow ~= nil then
            local overflow_items = overflow:GetItemsWithTag(tag)
            for _, item in ipairs(overflow_items) do
                table.insert(items, item)
            end
        end

        return items
    end
end

return FN
