--@author: 绯世行
--欢迎其他开发者直接使用，但是强烈谴责搬用代码后对搬用代码加密的行为！
--使用案例及最新版：https://n77a3mjegs.feishu.cn/docx/K9bUdpb5Qo85j2xo8XkcOsU1nuh?from=from_copylink

local FN = {}
local _source = debug.getinfo(1, 'S').source
local KEY = "_" .. _source:match(".*scripts[/\\](.*)%.lua"):gsub("[/\\]", "_") .. "_" --_XXX_utils_shapes

local Utils = require(_source:match(".*scripts[/\\](.*[/\\])") .. "utils")


-- 粒子特效位置生成函数
-- 参考emitters.lua中的函数，这里定义一些有规律的

---根据参数计算x,y,z，以指定点为球心，向外扩散或向内聚集，每次移动距离为dis，最终距离为radius
---@param minDis number
---@param maxDis number --离球心最远位置（或粒子初始距离）
---@param dis number --每次移动距离
---@param isEntad boolean --为true则从球面向内，否则就是从球心向球面
function FN.CreateExplodeEmitter(minDis, maxDis, dis, isEntad)
    local rand = math.random
    local sin = math.sin
    local cos = math.cos
    local minDistSq = minDis and minDis * minDis or 0
    local maxDisSq = maxDis * maxDis

    --cur得开发者自己保存维护
    return function(cur, newIsEntad)
        if newIsEntad ~= nil and newIsEntad ~= isEntad then
            isEntad = newIsEntad
        end

        if not cur then                         -- 如果当前点为nil，则初始化
            local phi = PI2 * rand()            -- 随机方向的角度,[0, 2π]
            local theta = math.acos(UnitRand()) -- 余弦值在[-1, 1]，角度在[0, π]
            -- 球坐标系转换为笛卡尔坐标系
            local nor = Vector3(sin(theta) * cos(phi), sin(theta) * sin(phi), cos(theta))
            return nor * (isEntad and maxDis or minDis or dis)
        else
            -- 计算当前点到球心的距离
            if (not isEntad and cur:LengthSq() >= maxDisSq) or (isEntad and cur:LengthSq() <= minDistSq + Utils.EPSILON) then
                return nil -- 如果当前位置已经满足，返回nil
            else
                -- 沿原来方向前进dis距离，单位化方向向量，Normalize方法竟然会修改对象本身，好坑啊
                local nor = Vector3(cur:Get()):Normalize()
                local off = nor * dis
                -- 前进dis距离
                local newPos = cur + (isEntad and -off or off)
                local newDis = newPos:Length()
                -- 如果新位置超过最远距离，则将其设置在边界上
                if not isEntad then
                    if newDis >= maxDisSq then
                        newPos = nor * maxDis
                    end
                else
                    if dis >= minDis * 2 or newDis < minDis then
                        newPos = nor * -minDis
                    end
                end
                return newPos
            end
        end
    end
end

---阿基米德螺线
---@param maxDis number 最远距离
---@param sector number 把圆切分几部分，螺旋线的个数
---@param w number 角速度
---@param v number 线速度
---@param isEntad boolean 是否由外向内
function FN.CreateSpiralEmitter(maxDis, sector, w, v, isEntad)
    local rand = math.random
    local sin = math.sin
    local cos = math.cos
    local per = PI2 / sector
    local phi = PI2 * rand() --随机角度开始
    local allOrbit = -1      --轨道

    --t为该点运动时间，每次加1后返回，orbit为该点所在轨道，第一次调用后分配
    return function(t, orbit, newIsEntad)
        if newIsEntad ~= nil and newIsEntad ~= isEntad then
            isEntad = newIsEntad
        end
        local r       --距圆心距离
        if not t then -- 如果当前点为nil，则初始化
            allOrbit = (allOrbit + 1) % sector
            orbit = allOrbit
            t = 1
        else
            t = t + 1
        end
        r = isEntad and (maxDis - v * t) or v * t

        local endRad = phi + orbit * per + w * t
        local x = r * sin(endRad)
        local z = r * cos(endRad)
        if (isEntad and r < 0) or (not isEntad and r > maxDis) then
            return
        end
        return { x = x, z = z, t = t, orbit = orbit }
    end
end

---变速直线运动，使用游戏时间计时
---调用时最好还是计算一下多久能到达极限，以免还没走完粒子存活时间就结束了
function FN.CreateFallEmitter(radius, maxHeight, getLengthFn, isUp)
    getLengthFn = getLengthFn or function(t)
        local a = 9.8
        return a * t * t / 2
    end

    local posGeneratorFn = CreateCircleEmitter(radius) --完全随机也许也不好

    return function(x, z, startTime)
        if not startTime then
            startTime = GetTime()
            x, z = posGeneratorFn()
        end
        local t = GetTime() - startTime
        local y = isUp and getLengthFn(t) or (maxHeight - getLengthFn(t))

        if (isUp and y > maxHeight) or (not isUp and y < 0) then
            return nil
        end
        return { x = x, y = y, z = z, startTime = startTime }
    end
end

---围绕球心进行环绕运动，使用四元数实现
---@param radius number
---@param angleInc number 角度增量
---@param angleThreshold number 角度阈值，当新旋转角度大于等于这个值，将直接返回nil
function FN.CreateEncircleEmitter(radius, angleInc, angleThreshold)
    local function quaternion_multiply(q1, q2)
        local w = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z
        local x = q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y
        local y = q1.w * q2.y - q1.x * q2.z + q1.y * q2.w + q1.z * q2.x
        local z = q1.w * q2.z + q1.x * q2.y - q1.y * q2.x + q1.z * q2.w
        return { w = w, x = x, y = y, z = z }
    end

    local function quaternion_conjugate(q)
        return { w = q.w, x = -q.x, y = -q.y, z = -q.z }
    end

    local posGeneratorfn = CreateSphereEmitter(radius)
    -- local axisGeneratorfn = CreateSphereEmitter(1)

    ---旋转期间，pos和axis都保持不变，改变的只有angle
    ---@param pos Vector3 旋转开始的起点
    ---@param axis Vector3 旋转轴，必须是规格化的
    ---@param angle number 旋转角度
    return function(pos, axis, angle)
        local theta
        if not pos then
            pos = Vector3(posGeneratorfn())

            -- axis = Vector3(axisGeneratorfn()) --虽然绕随机轴旋转也不错，但是我更希望能绕球心旋转
            axis = Vector3(math.random(), math.random(), math.random()):Cross(pos)
            if axis:LengthSq() == 0 then
                -- 这是非常不可能的情况，但如果发生了，我们重试
                axis = Vector3(math.random(), math.random(), math.random()):Cross(pos)
            end
            axis = axis:Normalize()

            angle = 0
            theta = 0
        else
            angle = angle + angleInc

            if angleThreshold ~= nil and angle >= angleThreshold then
                return
            end

            theta = math.rad(angle)
        end

        -- Normalize the axis，抠门一点儿，这里不再每次规格化axis，所以axis传入时必须是规格化的
        -- local axis = axis:Normalize()

        -- Create the rotation quaternion
        local sin_half_theta = math.sin(theta / 2.0)
        local rotation_quaternion = {
            w = math.cos(theta / 2.0),
            x = axis.x * sin_half_theta,
            y = axis.y * sin_half_theta,
            z = axis.z * sin_half_theta
        }

        -- Create the conjugate of the rotation quaternion
        local rotation_conjugate = quaternion_conjugate(rotation_quaternion)

        -- Convert the point to a quaternion
        local point_quaternion = { w = 0, x = pos.x, y = pos.y, z = pos.z }

        -- Perform the rotation
        local temp_result = quaternion_multiply(rotation_quaternion, point_quaternion)
        local rotated_point = quaternion_multiply(temp_result, rotation_conjugate)

        return {
            pos = pos,
            axis = axis,
            angle = angle,
            newPos = Vector3(rotated_point.x, rotated_point.y, rotated_point.z)
        }
    end
end

---让对象围绕target旋转，来自球状光虫wormwood_lightflier.lua，使用updatelooper组件更新，需要注意的是，退出游戏后再加载不会继续旋转，需要在load中重新调用该函数
---inst[KEY .. "MakeCircle_target"]获取target
---target[KEY .. "MakeCircle_pattern"]获取跟随的对象数据
---inst[KEY .. "MakeCircle_remove"]()来停止旋转
---@param data table {radius}
---@return function inst[KEY .. "MakeCircle_remove"] 停止函数
function FN.MakeCircle(inst, target, data)
    inst[KEY .. "MakeCircle_target"] = target
    if target[KEY .. "MakeCircle_pattern"] and not target[KEY .. "MakeCircle_pattern"].pets[inst] then
        target[KEY .. "MakeCircle_pattern"].maxpets = target[KEY .. "MakeCircle_pattern"].maxpets + 1
    else
        target[KEY .. "MakeCircle_pattern"] = { maxpets = 1, pets = {} } --pets是键值对，值为索引，旋转时决定角度用
    end
    target[KEY .. "MakeCircle_pattern"].pets[inst] = target[KEY .. "MakeCircle_pattern"].maxpets

    inst:ListenForEvent("onremove", function()
        if target[KEY .. "MakeCircle_pattern"] then
            target[KEY .. "MakeCircle_pattern"].pets[inst] = nil
            target[KEY .. "MakeCircle_pattern"].maxpets = target[KEY .. "MakeCircle_pattern"].maxpets - 1
            --重新调整索引
            local index = 1
            local pets = {}
            for k, v in pairs(target[KEY .. "MakeCircle_pattern"].pets) do
                pets[k] = index
                index = index + 1
            end
            target[KEY .. "MakeCircle_pattern"].pets = pets
        end
    end)
    inst:ListenForEvent("onremove", function()
        inst[KEY .. "MakeCircle_remove"]()
    end, target)

    local FORMATION_MAX_SPEED = 10.5
    local radius = Utils.GetVal(data, "radius", 5.5)
    local FORMATION_ROTATION_SPEED = 0.5

    local function OnUpdateFn(inst, dt)
        local target = inst[KEY .. "MakeCircle_target"] or nil
        if target and inst.brain and not inst.brain.stopped then
            local index = (target[KEY .. "MakeCircle_pattern"].pets[inst] or 1) - 1
            local maxpets = target[KEY .. "MakeCircle_pattern"].maxpets

            local theta = (index / maxpets) * PI2 + GetTime() * FORMATION_ROTATION_SPEED
            local lx, ly, lz = target.Transform:GetWorldPosition()

            lx, lz = lx + radius * math.cos(theta), lz + radius * math.sin(theta)

            local px, py, pz = inst.Transform:GetWorldPosition()
            local dx, dz = px - lx, pz - lz
            local dist = math.sqrt(dx * dx + dz * dz)

            inst.components.locomotor.walkspeed = math.min(dist * 8, FORMATION_MAX_SPEED)
            inst:FacePoint(lx, 0, lz)
            if inst.updatecomponents[inst.components.locomotor] == nil then
                inst.components.locomotor:WalkForward(true)
            end
        end
    end

    if not inst.components.updatelooper then
        inst:AddComponent("updatelooper")
    end
    inst.components.updatelooper:AddOnUpdateFn(OnUpdateFn)
    inst[KEY .. "MakeCircle_remove"] = function()
        inst.components.updatelooper:RemoveOnUpdateFn(OnUpdateFn)
        inst[KEY .. "MakeCircle_target"] = nil
        target[KEY .. "MakeCircle_pattern"] = nil
    end
    return inst[KEY .. "MakeCircle_remove"]
end

---在指定点附近随机取一点(y值不变)，范围是一个圆环
---@param pos table{x,y,z}
function FN.GetRandomLocation(pos, minDis, maxDis)
    -- 随机生成极坐标中的距离和角度
    local distance = math.random(minDis, maxDis)
    local angle = math.rad(math.random(0, 360))

    -- 将极坐标转换为直角坐标
    local offsetX = distance * math.cos(angle)
    local offsetY = distance * math.sin(angle)

    return Vector3(pos.x + offsetX, pos.y, pos.z + offsetY)
end

---在指定的矩形区域内生成分布均匀的随机点集，泊松盘算法，本来希望生成范围是一个圆的，但考虑到实现麻烦，计算更昂贵就算了
---@param pos Vector3 查找起点，采用x和z的值
---@param width number 矩形宽度
---@param height number 矩形高度
---@param minDis number 随机点最小距离
---@param count number 查找点数量，默认最大数量
---@param k number 点的采样次数，默认30
---@param isSatisfy boolean 当指定区域生成的点数不满足时是否允许插入几个随机点凑数，默认false
---@return table{} 二维数组，{{x,z},{x,z},{x,z},...}
function FN.GetRandomLocations(pos, width, height, minDis, count, k, isSatisfy)
    k = k or 30

    local startPos = { x = pos.x - width / 2, z = pos.z - height / 2 }
    local d = minDis / math.sqrt(2)
    local nx = math.floor(width / d) + 1
    local ny = math.floor(height / d) + 1
    local pi2 = math.pi * 2
    local occupied = {}       --网格占用标记
    local occupied_coord = {} --网格占用坐标记录
    for i = 1, ny do
        occupied[i] = {}
        occupied_coord[i] = {}
        for j = 1, nx do
            occupied[i][j] = 0
            occupied_coord[i][j] = { 0, 0 }
        end
    end

    local active_list = {} --查找队列，类似bfs
    local sampled = {}     --最终结果

    -- Define helper functions
    local function randomPoint()
        return math.random() * width, math.random() * height
    end

    local function isValidCoords(x, y)
        return x <= width and y <= height
    end

    -- This helper function replaces the 'relative' functionality by iterating over the neighborhood.
    local function checkNeighbours(idx_x, idx_y, _x, _y)
        local relative_coords = {
            { -1, 2 }, { 0, 2 }, { 1, 2 },
            { -2, 1 }, { -1, 1 }, { 0, 1 }, { 1, 1 }, { 2, 1 },
            { -2, 0 }, { -1, 0 }, { 1, 0 }, { 2, 0 },
            { -2, -1 }, { -1, -1 }, { 0, -1 }, { 1, -1 }, { 2, -1 },
            { -1, -2 }, { 0, -2 }, { 1, -2 }
        }
        for _, rel in pairs(relative_coords) do
            local cand_x, cand_y = idx_x + rel[1], idx_y + rel[2] --周围网格
            if cand_x >= 1 and cand_x <= nx and cand_y >= 1 and cand_y <= ny then
                if occupied[cand_y][cand_x] == 1 then
                    local cood = occupied_coord[cand_y][cand_x]
                    if (_x - cood[1]) ^ 2 + (_y - cood[2]) ^ 2 < minDis ^ 2 then
                        return false
                    end
                end
            end
        end
        return true
    end

    local x, y = randomPoint()                                        --初始随机点
    local idx_x, idx_y = math.floor(x / d) + 1, math.floor(y / d) + 1 --确定该点所在网格
    occupied[idx_y][idx_x] = 1
    occupied_coord[idx_y][idx_x] = { x, y }
    table.insert(active_list, { x, y })
    table.insert(sampled, { x = x + startPos.x, z = y + startPos.z })

    while #active_list > 0 and (count and #sampled < count) do
        local idx = math.random(#active_list)
        -- local idx = #active_list --不随机取一个点，而是每次都处理元素最后一个点
        local point = active_list[idx]
        local ref_x, ref_y = point[1], point[2]
        local flag_out = false

        -- 尝试K次，找到就不再进行，并且不会从活动队列中删除该点，因为该点附近可能还有，还要继续查找
        for i = 1, k do
            local radius = (math.random() + 1) *
                minDis                                                                                            --[r,2r]圆环范围
            local theta = math.random() * pi2
            local _x, _y = math.abs(radius * math.cos(theta) + ref_x), math.abs(radius * math.sin(theta) + ref_y) --新点

            if isValidCoords(_x, _y) then
                local idx_x, idx_y = math.floor(_x / d) + 1, math.floor(_y / d) + 1 --新网格
                if occupied[idx_y][idx_x] == 0 and checkNeighbours(idx_x, idx_y, _x, _y) then
                    occupied[idx_y][idx_x] = 1
                    occupied_coord[idx_y][idx_x] = { _x, _y }
                    table.insert(sampled, { x = _x + startPos.x, z = _y + startPos.z })
                    table.insert(active_list, { _x, _y })
                    flag_out = true
                    break
                end
            end
        end

        if not flag_out then
            table.remove(active_list, idx)
        end
    end

    if count and #sampled < count and isSatisfy then
        -- 也不考虑是否可能靠的太近了,数量够了就行
        -- local r = math.min(width / 2, height / 2)
        -- for i = 1, count - #sampled do
        --     local p = FN.GetRandomLocation(pos, 0, r)
        --     table.insert(sampled, { x = p.x, z = p.z })
        -- end
        -- 折半再次查找
        for _, v in ipairs(FN.GetRandomLocations(pos, width, height, minDis / 2, count - #sampled, k, isSatisfy)) do
            table.insert(sampled, v)
        end
    end

    return sampled
end

---以给定点为矩形中心，insideX和insideZ为矩形大小，从矩形外border宽度的一圈随机取n个点
---@param pos Vector3 矩形中心
---@param insideX number 矩形X方向的半长
---@param insideZ number 矩形Z方向的半长
---@param border number 边框的宽度，取数的范围
---@param num number|nil 个数
---@param checkFn function|nil 校验函数
---@param threshold number|nil 查找次数，超过这个值不再继续查找
function FN.GetRandomBorderLocation(pos, insideX, insideZ, border, num, checkFn, threshold)
    num = num or 1
    threshold = threshold or num * 2

    local res = {}

    local topX = pos.x - insideX - border
    local botX = pos.x + insideX + border
    local lefZ = pos.z - insideZ - border
    local rigZ = pos.z + insideZ + border
    while #res < num and threshold > 0 do
        threshold = threshold - 1
        local x, z

        -- 随机选择边框上的一条边
        local side = math.random(4)
        if side == 1 then -- 左侧边
            x = topX + math.random() * (botX - topX)
            z = lefZ + math.random() * border
        elseif side == 2 then -- 上侧边
            x = topX + math.random() * border
            z = lefZ + math.random() * (rigZ - lefZ)
        elseif side == 3 then -- 右侧边
            x = topX + math.random() * (botX - topX)
            z = rigZ - math.random() * border
        else -- 下侧边
            x = botX - math.random() * border
            z = lefZ + math.random() * (rigZ - lefZ)
        end

        local newPos = Vector3(x, pos.y, z)
        if not checkFn or checkFn(newPos) then
            table.insert(res, newPos)
        end
    end

    return res
end

---以给定点和给定方向形成一个矩形范围，判断目标是否在矩形范围内，可以用于激光攻击
---@param pos table{x,z} 攻击者坐标
---@param targetPos table{x,z} 被攻击者坐标
---@param rotate number 角度
---@param width number 矩形的半宽
---@param length number 矩形的长度
function FN.IsInRectangle(pos, targetPos, rotate, width, length)
    local relativePos = { x = targetPos.x - pos.x, z = targetPos.z - pos.z }
    local rad = math.rad(rotate)

    local rotatedPos = {
        x = relativePos.x * math.cos(rad) + relativePos.z * math.sin(rad),
        z = -relativePos.x * math.sin(rad) + relativePos.z * math.cos(rad)
    }

    -- 判断是否在无朝向矩形范围内
    if rotatedPos.x >= 0 and rotatedPos.x <= length and math.abs(rotatedPos.z) <= width then
        return true  -- 目标在攻击范围内
    else
        return false -- 目标不在攻击范围内
    end
end

---返回一个爱心形状点集
---@param centerX number
---@param centerY number
---@param scale number
---@param numPoints number
function FN.GenerateHeartPoints(centerX, centerY, scale, numPoints)
    local points = {}
    local pi = math.pi
    local step = 2 * pi / numPoints

    for i = 1, numPoints do
        local t = step * (i - 1)
        local x = 16 * math.sin(t) ^ 3
        local y = 13 * math.cos(t) - 5 * math.cos(2 * t) - 2 * math.cos(3 * t) - math.cos(4 * t)
        x = x * scale + centerX
        y = y * scale + centerY
        table.insert(points, { x, y })
    end

    return points
end

---小圆圆心位于大圆边长上，用给定的小圆围绕大圆平均一圈，返回小圆圆心表
---@param bigRadius number 小圆半径
---@param smallRadius number 大圆半径
---@param initAngle number|nil 初始角度，单位为弧度
function FN.SmallCircleCentersWithSpacing(bigRadius, smallRadius, initAngle)
    initAngle = initAngle or 0

    local centers = {}
    -- 小圆的直径
    local smallDiameter = 2 * smallRadius
    -- 估算最多能放置的小圆数量
    local estimateCircles = math.floor((2 * math.pi * bigRadius) / smallDiameter)
    -- 通过二分查找法来确定实际能放置的小圆数量
    local left, right = 1, estimateCircles
    local n
    while left <= right do
        local mid = math.floor((left + right) / 2)
        local angle = (2 * math.pi) / mid
        local distance = 2 * bigRadius * math.sin(angle / 2)
        if distance > smallDiameter then
            n = mid
            left = mid + 1
        else
            right = mid - 1
        end
    end

    -- 计算每个小圆圆心之间的角度
    local angleStep = (2 * math.pi) / n

    -- 计算每个小圆的圆心坐标
    for i = 1, n do
        -- 当前小圆圆心的角度
        local angle = initAngle + angleStep * (i - 1)
        -- 转换极坐标为笛卡尔坐标
        local x = bigRadius * math.cos(angle)
        local y = bigRadius * math.sin(angle)
        -- 添加到结果表中
        table.insert(centers, { x, y })
    end

    return centers
end

return FN
