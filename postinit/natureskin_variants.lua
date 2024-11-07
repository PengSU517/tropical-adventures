local skinlist = require("datadefs/skin_nature_defs").skinlist

for name, prefabdata in pairs(skinlist) do
    AddPrefabPostInit(name, function(inst)
        if not TheWorld.ismastersim then return end

        if not inst.components.natureskin then
            inst:AddComponent("natureskin") --先加上组件执行onload
        end

        inst:DoTaskInTime(0, function(...)
            inst.components.natureskin:ReSkin()
        end)
    end)
end

--reskin tool
-- local old_can_cast_fn
-- local function new_can_cast_fn(doer, target, pos, ...)
--     return (old_can_cast_fn ~= nil and old_can_cast_fn(doer, target, pos, ...)) and
--         not PREFAB_SKINS_SHOULD_NOT_CHANGE[target.skinname]
-- end

-- AddPrefabPostInit("reskin_tool", function(inst)
--     if TheWorld.ismastersim and inst.components.spellcaster ~= nil then
--         if not old_can_cast_fn then
--             old_can_cast_fn = inst.components.spellcaster.can_cast_fn
--         end
--         inst.components.spellcaster:SetCanCastFn(new_can_cast_fn)
--     end
-- end)



--LootDropper
local LootDropper = require("components/lootdropper")
local _SpawnLootPrefab = LootDropper.SpawnLootPrefab
function LootDropper:SpawnLootPrefab(loot, pt, ...)
    local item = _SpawnLootPrefab(self, loot, pt, ...)
    if not item then return end
    if item.components.natureskin then
        item.components.natureskin:InheritFrom(self.inst)
    end
    return item
end

--pickable
-- local function picked(inst, data)
--     if data and data.loot then
--         if data.loot.components and data.loot.components.visualvariant then
--             data.loot.components.visualvariant:InheritFrom(data.plant or inst)
--         end
--     end
-- end

-- AddComponentPostInit("pickable", function(self)
--     self.inst:ListenForEvent("picked", picked)
-- end)


local pickable = require("components/pickable")
local old_pick = pickable.Pick

-- pickable.Pick = old_pick

function pickable:Pick(picker)
    local success, loots = old_pick(self, picker) --加入外源函数时必须把self作为参数显示加入
    if loots then
        for _, v in ipairs(loots) do
            if v.components.natureskin then
                v.components.natureskin:InheritFrom(self.inst)
            end
        end
    end
    return success, loots
    -- return old_pick(self, picker) --加入外源函数时必须把self作为参数显示加入
end

----inventory
-- local inventory = require("components/inventory")
-- local old_giveitem = inventory.GiveItem

-- function inventory:GiveItem(item, giver, source)
--     if item.components and item.components.natureskin then
--         self.inst:DoTaskInTime(0, function(inst)
--             old_giveitem(self, item, giver, source)
--         end)
--     else
--         old_giveitem(self, item, giver, source)
--     end
-- end

--stackable
local Stackable = require("components/stackable")
local old_Get = Stackable.Get
function Stackable:Get(num, ...)
    local rets = { old_Get(self, num, ...) }

    if rets[1] and rets[1].components.natureskin then
        rets[1].components.natureskin:InheritFrom(self.inst)
    end

    return unpack(rets)
end

--cookable
local Cookable = require("components/cookable")
local old_Cook = Cookable.Cook
function Cookable:Cook(...)
    local prod = old_Cook(self, ...)

    if prod.components.natureskin then
        prod.components.natureskin:InheritFrom(self.inst)
    end

    return prod
end
