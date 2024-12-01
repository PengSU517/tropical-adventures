require("entityscript")

function EntityScript:IsInTropicalArea()
    return TheWorld.Map:IsTropicalAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:IsInShipwreckedArea()
    return TheWorld.Map:IsShipwreckedAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:IsInHamletArea()
    return TheWorld.Map:IsHamletAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:IsInVolcanoArea()
    return TheWorld.Map:IsVolcanoAreaAtPoint(self:GetPosition():Get())
end

function EntityScript:IsInWorld()
    local x, y, z = self.Transform:GetWorldPosition()
    return math.abs(x) <= 1350 and math.abs(z) <= 1350
    -- local width, height = TheWorld.Map:GetWorldSize()
    -- local x, y, z = self.Transform:GetWorldPosition()
    -- local tile_x, tile_y = TheWorld.Map:GetTileCoordsAtPoint(x, 0, z)

    -- return tile_x <= width and tile_y <= height

    -- local nx = (tile_x - width / 2) * TILE_SCALE
    -- local nz = (tile_y - height / 2) * TILE_SCALE
    -- local worldwidth, worldheight = TheWorld.Map:GetWorldSize()
    -- local x, y, z = self.Transform:GetWorldPosition()
    -- return math.abs(x) <= worldwidth and math.abs(z) <= worldheight
    -- return true
end

function EntityScript:IsOnLandTile()
    return TheWorld.Map:IsLandTileAtPoint(self.Transform:GetWorldPosition())
end

----area aware related--------------------
function EntityScript:AwareInTropicalArea() ----减少计算量
    return self.components.areaaware and
        (self.components.areaaware:CurrentlyInTag("tropical")
            or self.components.areaaware:CurrentlyInTag("ForceDisconnected")) and
        true or false
end

function EntityScript:AwareInShipwreckedArea()
    local aware = self.components.areaaware and self.components.areaaware:CurrentlyInTag("shipwrecked") and true
    return aware or false
end

function EntityScript:AwareInHamletArea()
    local aware = self.components.areaaware and self.components.areaaware:CurrentlyInTag("hamlet") and true
    return aware or false
end

function EntityScript:AwareInVolcanoArea()
    local aware = self.components.areaaware and self.components.areaaware:CurrentlyInTag("volcano") and true
    return aware or false
end

--实体是否在虚空的房间里面
function EntityScript:IsInHamRoom()
    return TheWorld.Map:IsHamRoomAtPoint(self:GetPosition():Get()) --------------------似乎不太对
end

--推入事件
local _PushEvent = EntityScript.PushEvent
function EntityScript:PushEvent(event, data)
    if not self.eventmuted or not self.eventmuted[event] then                    --没有静默
        _PushEvent(self, event, data)
        if self.eventlistening_shared and self.eventlistening_shared[event] then --是否分享
            local parent = self.entity:GetParent()
            if parent and parent:IsValid() then
                parent:PushEvent(event, data)
            end
        end
    end
end

--事件监听静默
function EntityScript:SetEventMute(event, muted)
    if self.eventmuted == nil then
        self.eventmuted = {}
    end
    -- print(event)
    self.eventmuted[event] = muted and true or nil
end

--事件监听共享--会同时分享给上一级
function EntityScript:SetEventShare(event, shared)
    if self.eventlistening_shared == nil then
        self.eventlistening_shared = {}
    end
    self.eventlistening_shared[event] = shared and true or nil
end

function EntityScript:StopWatchingOneOfWorldStates(var)
    if not self.worldstatewatching then return end
    if self.muted_worldstate == nil then self.muted_worldstate = {} end
    self.muted_worldstate[var] = self.worldstatewatching[var] or {}

    -- for i, fn in ipairs(self.worldstatewatching[var]) do
    --     fn(self, initval or false)
    -- end

    TheWorld.components.worldstate:RemoveWatcher(var, self)
    self.worldstatewatching[var] = nil
end

function EntityScript:ReWatchingOneOfWorldStates(var)
    if not self.muted_worldstate then return end
    if self.worldstatewatching == nil then
        self.worldstatewatching = {}
    end
    self.worldstatewatching[var] = self.muted_worldstate[var] or {}
    for i, fn in ipairs(self.worldstatewatching[var]) do
        TheWorld.components.worldstate:AddWatcher(var, self.inst, fn, self)
    end

    self.muted_worldstate[var] = nil
end

function EntityScript:GetEventCallbacks(event, source, source_file, test_fn)
    source = source or self

    if not self.event_listening[event] or not self.event_listening[event][source] then
        return
    end

    for _, fn in ipairs(self.event_listening[event][source]) do
        if source_file then
            local info = debug.getinfo(fn, "S")
            if info and (info.source == source_file) and (not test_fn or test_fn(fn)) then
                return fn
            end
        elseif (not test_fn or test_fn(fn)) then
            return fn
        end
    end
end

--------------------------------------------------------------------------------------------
----------------------------------[[ 相关物品hook ]]-----------------------------------------
--------------------------------------------------------------------------------------------
local old_CanEntitySeePoint = GLOBAL.CanEntitySeePoint
GLOBAL.CanEntitySeePoint = function(inst, ...)
    return old_CanEntitySeePoint(inst, ...) or inst:IsInHamRoom()
end

local old_CanEntitySeeInDark = GLOBAL.CanEntitySeeInDark
GLOBAL.CanEntitySeeInDark = function(inst)
    return old_CanEntitySeeInDark(inst) or inst:IsInHamRoom()
end



local _SetOceanBlendParams = AnimState.SetOceanBlendParams
function AnimState:SetOceanBlendParams(...)
    if TUNING.tropical.ocean == "tropical" then return end
    return _SetOceanBlendParams(self, ...)
end

local _SetLayer = AnimState.SetLayer
function AnimState:SetLayer(layer, ...)
    if true and layer <= LAYER_BELOW_GROUND then
        layer = LAYER_GROUND -- TODO: if sorting issues occur use ground and increase the sort
        self:SetSortOrder(5)
    end
    return _SetLayer(self, layer, ...)
end

local _OnCreep = GroundCreep.OnCreep
function GroundCreep:OnCreep(x, y, z, ...)
    return _OnCreep(self, x, y, z, ...) and not TheWorld.Map:IsHamRoomAtPoint(x, y, z)
end
