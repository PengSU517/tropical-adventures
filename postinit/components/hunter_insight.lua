--- Retrieves all of a function's upvalues.
---@param func function
---@return table
local function getupvalues(func)
    local upvs = {}
    local i = 1
    while true do
        local n, v = debug.getupvalue(func, i)
        if not n then return upvs end
        table.insert(upvs, { name = n, value = v }) -- ISSUE:PERFORMANCE (TEST#12)
        i = i + 1
    end
    return upvs
end

local function recursive_getupvalue(func, name)
    if type(func) ~= "function" then
        -- errorf("[Insight]: recursive_getupvalue called with %s, expected 'function'", type(func))
        return
    end

    local checked = {}

    local function scan(fn)
        if checked[fn] then
            return nil
        end

        checked[fn] = true

        for _, upv in pairs(getupvalues(fn)) do
            if (type(name) == 'function' and name(upv.name, upv.value)) or upv.name == name then
                return upv.value
            elseif type(upv.value) == 'function' then
                local res = scan(upv.value)
                if res then
                    return res
                end
            end
        end
    end

    return scan(func)
end

--- Retrives and replaces the first upvalue that matches the arguments.
---@param func function
---@param name string Name of the upvalue to search for.
---@param replacement
---@return any
local function replaceupvalue(func, name, replacement)
    if type(name) ~= "string" then
        error("argument #2 expected string, got " .. type(name))
    end

    local i = 1
    while true do
        local n, v = debug.getupvalue(func, i)
        if not n then break end
        if n == name then
            debug.setupvalue(func, i, replacement)
            return v
        end
        i = i + 1
    end
    error(string.format("Unable to find upvalue '%s' for replacing.", name))
end

local huntersName = { "hunter", "whalehunter" }
local counter = 0
local active_hunts = {}
local hunters = {}

local hunter = nil --rawget(Insight.descriptors, "hunter")
local module = nil --recursive_getupvalue(hunter.OnServerInit, "module")

local function init()
    if module ~= nil then
        return
    end
    hunter = rawget(Insight.descriptors, "hunter")
    module = recursive_getupvalue(hunter.OnServerInit, "module")
end

local oldOnDirtInvestigateds = {}
local function HackInsight(self)
    local inst = self.inst
    inst:DoTaskInTime(0, function()
        for _, name in ipairs(huntersName) do
            local insightOnDirtInvestigated = hunters[name].OnDirtInvestigated
            hunters[name].OnDirtInvestigated = function(self, pt, doer, ...)
                module.active_hunts = active_hunts[name]
                module.oldOnDirtInvestigated = oldOnDirtInvestigateds[name]
                insightOnDirtInvestigated(self, pt, doer, ...)
            end
        end

        --GetHuntFromTrack
        local GetHuntDataFromTrack = recursive_getupvalue(hunter.DescribeTrack, "GetHuntDataFromTrack")
        --- Fetches the active hunt data from the dirt track.
        --- @param inst EntityScript The dirt track.
        --- @return table @The hunt data.
        local function GetHuntFromTrack(inst)
            for _, name in ipairs(huntersName) do
                for i = 1, #active_hunts[name] do
                    local hunt = active_hunts[name][i]

                    if hunt.lastdirt == inst then
                        return hunt
                    end
                end
            end
        end
        replaceupvalue(GetHuntDataFromTrack, "GetHuntFromTrack", GetHuntFromTrack)
    end)
end
local modeType = -1

for _, name in ipairs(huntersName) do
    AddComponentPostInit(name, function(self)
        if Insight then
            init()
            counter = counter + 1
            hunters[name] = self
            active_hunts[name] = recursive_getupvalue(self.OnDirtInvestigated, "_activehunts")
            if modeType < 0 then
                if module.oldOnDirtInvestigated then
                    modeType = 1
                else
                    modeType = 2
                end
            end
            if modeType == 1 then
                oldOnDirtInvestigateds[name] = module.oldOnDirtInvestigated
                module.oldOnDirtInvestigated = nil
            elseif modeType == 2 then
                oldOnDirtInvestigateds[name] = self.OnDirtInvestigated
            end
            if counter >= 2 then
                HackInsight(self)
            end
        end
    end)
end
