--Green Framework. Please, don't copy any files or functions from this mod, because it can break other mods based on the GF.

local colors = {
    {42/255, 209/255, 235/255}, --light blue
    {124/255, 252/255, 0}, -- green
    {218/255, 165/255, 32/255}, -- yellow
    {147/255, 112/255, 219/255}, -- purple
    {1, 1, 1}, --white
    {205/255, 0, 0}, -- red
    {0.3, 0.3, 0.3}, --gray
    {0, 0, 0}, --black
}

local function FloorToFirstDecimal(val)
    return math.floor(val * 100) * 0.01
end

--call draw on client
local function OnLightningDirty(inst)
    --print("recieved", inst.components.gflightningdrawer._dolightning:value())
    local strArr = inst.components.gflightningdrawer._dolightning:value():split(';')
    local points = {}
    for k, po in pairs(strArr) do
        local splitted = po:split('&')
        --print("start, finish", splitted[1], splitted[2])
        local start, finish = splitted[1]:split(','), splitted[2]:split(',')

        table.insert(points,
            {
                start = { x = tonumber(start[1]), z = tonumber(start[2]) },
                finish = { x = tonumber(finish[1]), z = tonumber(finish[2]) }
            })
    end
    
    inst.components.gflightningdrawer:DrowLightning(points)
end

local GFLightningDrawer = Class(function(self, inst)
    self.inst = inst
    self.fxs = {}
    self._dolightning = net_string(inst.GUID, "GFLightningDrawer._dolightning", "dolightning")
    self._lightningType = net_tinybyte(inst.GUID, "GFLightningDrawer._lightningType")
    self._lightningYOffset = net_tinybyte(inst.GUID, "GFLightningDrawer._lightningYOffset")

    self._lightningType:set_local(0)
    self._lightningYOffset:set_local(0)

    if not TheWorld.ismastersim then
        inst:ListenForEvent("dolightning", OnLightningDirty)
    end
end)

function GFLightningDrawer:SetYOffset(offset)
    self._lightningYOffset:set(offset or 0)
end

function GFLightningDrawer:SetColour(type)
    self._lightningType:set(type or 0)
end

--call draw on server
function GFLightningDrawer:DoLightning(points)
    if TheWorld.ismastersim then
        self._dolightning:set_local("")
        --self._dolightning:set(string.format("%.2f;%.2f&%.2f;%.2f", start.x, start.z, finish.x, finish.z))
        local draw = {}

        for _, po in pairs(points) do
            table.insert(draw, string.format("%.2f,%.2f&%.2f,%.2f", po.start.x, po.start.z, po.finish.x, po.finish.z))
        end

        self._dolightning:set_local(table.concat(draw, ';'))
        self:DrowLightning(points)
    end
end

function GFLightningDrawer:DrowLightning(points)
    --print(string.format("Drowing lightning from (%.2f, %.2f) to (%.2f, %.2f)",
    --    start.x, start.z, finish.x, finish.z))

    --deidcated server doesn't need to draw lightnings
    if TheNet:IsDedicated() then return end

    --print("number of lightning:", #points)

    for _, lgtn in pairs(points) do
        local dx, dz = lgtn.finish.x - lgtn.start.x, lgtn.finish.z - lgtn.start.z
        local cx, cz = lgtn.finish.x + lgtn.start.x, lgtn.finish.z + lgtn.start.z
        local dist = math.ceil(math.sqrt(dx * dx + dz * dz))
        --print("dist", dist)
        --local sourceAngle = math.atan2(dx, dz) - 1.57

        local pointsToDraw = {{x = lgtn.start.x, z = lgtn.start.z}, {x = lgtn.finish.x, z = lgtn.finish.z}}
        local needPoints = dist * 1.5

        while #pointsToDraw <= needPoints do
            --print("--------------------------")
            --if  then break end
            local j = 1
            while j < #pointsToDraw do
                --print(string.format("j is %i, num of poinst is %i", j, #pointsToDraw))
                if pointsToDraw[j + 1] ~= nil then
                    local vstart = pointsToDraw[j]
                    local vend = pointsToDraw[j + 1]
                    --print(string.format("start %i (%.2f, %.2f), end %i (%.2f, %.2f)", j, pointsToDraw[j].x, pointsToDraw[j].z,
                        --j + 1, pointsToDraw[j + 1].x, pointsToDraw[j + 1].z))
                    local dx, dz = vend.x - vstart.x, vend.z - vstart.z
                    local angle = math.atan2(dx, dz) + (math.random(80) - 40) * DEGREES - 1.57
                    local lenght = math.sqrt(dx * dx + dz * dz) / 2
                    --print("angle, lenght", angle / DEGREES, lenght)
                    --print("inserting pt in pos", j + 1)
                    table.insert(pointsToDraw, j + 1, {x = vstart.x + math.cos(angle) * lenght, z = vstart.z - math.sin(angle) * lenght})
                else
                    --print(string.format("%i (%.2f, %.2f) is last element", j, pointsToDraw[j].x, pointsToDraw[j].z))
                end
                j = j + 2
            end
        end

        --print("Number of points:", #pointsToDraw)

        local type = self._lightningType:value()
        local offset = self._lightningYOffset:value()
        offset = offset ~= 0 and offset * 0.5 or 1.5

        for i = 1, #pointsToDraw - 1 do
            local dx, dz = pointsToDraw[i + 1].x - pointsToDraw[i].x, pointsToDraw[i + 1].z - pointsToDraw[i].z
            local angle = math.atan2(dx, dz) - 1.57
            local obj = SpawnPrefab("gf_lightningfx")
            obj.AnimState:SetMultColour(colors[type + 1][1], colors[type + 1][2], colors[type + 1][3], 0.5)
            obj:Hide()
            local scale = math.sqrt(dx * dx + dz * dz)--+ 0.45
            scale = FloorToFirstDecimal(scale *  (1.9 - scale))
            obj.Transform:SetScale(scale, obj.scaley, scale)
            obj.Transform:SetRotation(angle/DEGREES)
            obj.Transform:SetPosition(pointsToDraw[i].x, offset, pointsToDraw[i].z)
            table.insert(self.fxs, obj)
        end
    end

    self.inst:DoTaskInTime(0, function(inst) 
        for k, v in pairs(inst.components.gflightningdrawer.fxs) do
            v:Show()
        end
    end)

    self.inst:DoTaskInTime(0.3, function(inst) 
        for k, v in pairs(inst.components.gflightningdrawer.fxs) do
            v:Remove()
        end
        --inst:Remove()
    end)
end

return GFLightningDrawer