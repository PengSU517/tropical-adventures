local DATA = require "tools/tropicalconsoles"

local TROPICAL_USER_CMD_DATA = {}

TROPICAL_USER_CMD_DATA = {
    clearentity = {
        aliases = { "清理" },
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
