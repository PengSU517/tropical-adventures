--@author: 绯世行
--欢迎其他开发者直接使用，但是强烈谴责搬用代码后对搬用代码加密的行为！
--使用案例及最新版：https://n77a3mjegs.feishu.cn/docx/K9bUdpb5Qo85j2xo8XkcOsU1nuh?from=from_copylink

--控制台测试使用

local FN = {}
local _source = debug.getinfo(1, 'S').source
local KEY = "_" .. _source:match(".*scripts/(.*)%.lua"):gsub("/", "_") .. "_"

---打印鼠标位置附近的对象
---@param radius number|nil 查找范围，默认4
---@param fn function|nil 执行函数
function FN.PE(radius, fn)
    local x, y, z = ConsoleWorldPosition():Get()
    for i, v in pairs(TheSim:FindEntities(x, y, z, radius or 4)) do
        print("索引" .. i .. ": ", v)
        if fn then
            fn(v)
        end
    end
end

local function GetRepeatString(string, count)
    local t = {}
    for i = 1, count do
        t[i] = str
    end
    return table.concat(t)
end

---打印table
---@param count number|nil 递归层数，如果表的层级较高，控制这个数值来决定打印的层级，默认1
---@param current nil 不用填，递归需要
function FN.PT(tab, count, current)
    count = count or 1
    current = current or 1
    if current == 1 then
        print("{")
    end

    for k, v in pairs(tab) do
        if current == 1 then
            io.write("  ")
        end

        if type(k) == "table" and current < count then
            io.write("{")
            FN.PT(k, count, current + 1)
            io.write("}")
        else
            if type(k) == "number" then
                io.write("[" .. tostring(k) .. "]")
            else
                io.write(tostring(k))
            end
        end
        io.write(" = ")

        if type(v) == "table" and current < count then
            io.write("{")
            FN.PT(v, count, current + 1)
            io.write("}")
        else
            io.write(tostring(v))
        end

        io.write(", ")
        if current == 1 then
            io.write("\n")
        end
    end
    if current == 1 then
        print("}")
    end
end

--- 在地图上打印已有地皮信息，从鼠标位置开始生成所有地皮
function FN.PrintTileMap()
    local world_tile_map = GetWorldTileMap()
    local time, row, col = 0, 1, 1
    local perCol = math.floor(math.sqrt(GetTableSize(world_tile_map)))
    local excIds = { 33, 34 } --会报错的地皮编号
    local initPos = ConsoleWorldPosition()
    for name, id in pairs(world_tile_map) do
        ThePlayer:DoTaskInTime(time, function()
            if not table.contains(excIds, id) then
                print(name, id)
                local pos = Vector3((col - 1) * 8, 0, (row - 1) * 8) + initPos
                d_ground(id, pos)

                local labeler = SpawnAt("razor", pos)
                labeler.persists = false
                labeler.AnimState:SetScale(0, 0)
                local label = labeler.entity:AddLabel()
                label:SetFontSize(24)
                label:SetFont(BODYTEXTFONT)
                label:SetWorldOffset(0, 0, 0)
                label:SetText("命名：" .. name .. "，编号：" .. id)
                label:SetColour(1, 1, 1)
                label:Enable(true)
                pos.x = pos.x + 8

                col = col + 1
                if col > perCol then
                    row = row + 1
                    col = 1
                end
            end
        end)
        time = time + 0.5
    end
end

function FN.Clear(range)
    range = range or 20
    local x, y, z = ConsoleWorldPosition():Get()
    for _, v in ipairs(TheSim:FindEntities(x, y, z, range)) do
        if not v.userid                                                                  --玩家
            and v.prefab ~= "raindrop"                                                   --雨水特效
            and not (v.components.inventoryitem and v.components.inventoryitem:IsHeld()) --被装入物品栏的物品
        then
            v:Remove()
        end
    end
end

return FN
