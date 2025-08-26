local DATA = require "tools/tropicalconsoles"

local TROPICAL_USER_CMD_DATA = {}

local interval = 10

TROPICAL_USER_CMD_DATA = {
    countentity = {
        aliases = { "countent", "统计", "统计实体" },
        permission = COMMAND_PERMISSION.USER,
        params = { "top", "minnum" },
        paramsoptional = { true, true },
        localfn = function(params, caller)
        end,
        serverfn = function(params, caller)
            if TheWorld.components.timer:TimerExists("t_disablecount") then
                c_announce(string.format("统计间隔过快，%d秒后再试", interval))
                return
            end
            local top, min = type(params.top) == "number" and tonumber(math.floor(params.top)) or 10,
                type(params.minnum) == "number" and tonumber(math.floor(params.minnum)) or 5000
            t_arrange(top, min)
            TheWorld.components.timer:StartTimer("t_disablecount", interval)
        end,
    },
    clearentity = {
        aliases = { "clearent", "清理" },
        permission = COMMAND_PERMISSION.ADMIN,
        params = { "top", "minnum" },
        paramsoptional = { true, true },
        ---@param params { top:number|string|nil, minnum:number|nil }
        ---@param caller ent
        localfn = function(params, caller)
        end,
        ---@param params { top:number|string|nil, minnum:number|nil }
        ---@param caller ent
        serverfn = function(params, caller)
            c_save()
            StartThread(function()
                Sleep(5)
                local top, min = type(params.top) == "number" and tonumber(math.floor(params.top)) or 10,
                    type(params.minnum) == "number" and tonumber(math.floor(params.minnum)) or 5000
                t_arrange(top, min)
                for _, v in ipairs(DATA.list) do
                    c_removeall(v.prefab)
                end
                DATA.list = {}
            end)
        end,
    },
}

for name, data in pairs(TROPICAL_USER_CMD_DATA) do
    AddModUserCommand("tropical", name, data)
end
