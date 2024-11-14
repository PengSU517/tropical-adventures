AddModRPCHandler("ham_room", "build_height", function(player, height)
    TUNING.BUILD_HEIGHT = height
end)

local roomtype = TUNING.HAMROOM.roomtype
local roomcamera = TUNING.HAMROOM.roomcamera

local function BindKey(key, func)
    if type(key) == "string" then
        TheInput:AddKeyDownHandler(key:lower():byte(), func)
    elseif key > 0 then
        TheInput:AddKeyDownHandler(key, func)
    end
end

local extra_distance = 0
local fov_keys = TA_CONFIG_CLIENT.fov_keys or tro_pairedkey["mp"]
BindKey(fov_keys[2], function() extra_distance = math.min(math.max(extra_distance + 0.1, -5), 5) end)
BindKey(fov_keys[1], function() extra_distance = math.min(math.max(extra_distance - 0.1, -5), 5) end)

AddClassPostConstruct("cameras/followcamera", function(self)
    local Old_Apply = self.Apply
    function self:Apply()
        if self.inhamroom == true and self.hamroompos ~= nil then
            ----视角调整
            -- if TheInput:IsKeyDown(KEY_EQUALS) then
            --     extra_distance = extra_distance + 0.05
            -- elseif TheInput:IsKeyDown(KEY_MINUS) then
            --     extra_distance = extra_distance - 0.05
            -- end

            -- extra_distance = math.min(math.max(extra_distance, -5), 5)

            if not self.originalheading then
                self.originalheading = self.headingtarget
            end

            self.headingtarget = 0 ----此项记录原始视角,也和方向控制有关

            local cameraset = roomcamera[self.roomtype or "small"]
            local pitch = cameraset.pitch * DEGREES
            local heading = 0
            local distance = cameraset.distance

            local currentpos = Vector3(self.hamroompos:Get()) + Vector3(cameraset.pos, 0, 0)
            local fov = 35 + extra_distance ----直接修改fov视角就不会乱
            local currentscreenxoffset = 0
            local cos_pitch = math.cos(pitch)
            local cos_heading = math.cos(heading)
            local sin_heading = math.sin(heading)
            local dx = -cos_pitch * cos_heading
            local dy = -math.sin(pitch)
            local dz = -cos_pitch * sin_heading
            local xoffs, zoffs = 0, 0
            if self.shake ~= nil then
                local shakeOffset = self.shake:Update(FRAMES)
                if shakeOffset ~= nil then
                    local rightOffset = self:GetRightVec() * shakeOffset.x
                    currentpos.x = currentpos.x + rightOffset.x
                    currentpos.y = currentpos.y + rightOffset.y + shakeOffset.y
                    currentpos.z = currentpos.z + rightOffset.z
                else
                    self.shake = nil
                end
            end
            if currentscreenxoffset ~= 0 then
                local hoffs = 2 * currentscreenxoffset / RESOLUTION_Y
                local magic_number = 1.03
                local screen_heights = math.tan(fov * .5 * DEGREES) * distance * magic_number
                xoffs = -hoffs * sin_heading * screen_heights
                zoffs = hoffs * cos_heading * screen_heights
            end

            TheSim:SetCameraPos(
                currentpos.x - dx * distance + xoffs,
                currentpos.y - dy * distance,
                currentpos.z - dz * distance + zoffs
            )
            TheSim:SetCameraDir(dx, dy, dz)

            local right = (heading + 90) * DEGREES
            local rx = math.cos(right)
            local ry = 0
            local rz = math.sin(right)

            local ux = dy * rz - dz * ry
            local uy = dz * rx - dx * rz
            local uz = dx * ry - dy * rx

            TheSim:SetCameraUp(ux, uy, uz)
            TheSim:SetCameraFOV(fov)
            local listendist = -.1 * distance
            TheSim:SetListener(
                dx * listendist + currentpos.x,
                dy * listendist + currentpos.y,
                dz * listendist + currentpos.z,
                dx, dy, dz,
                ux, uy, uz
            )
        else
            if self.originalheading then
                self.headingtarget = self.originalheading
                self.originalheading = nil
            end

            Old_Apply(self)
        end
    end
end)


local function OnFocalFocusDirty(inst)
    if ThePlayer ~= nil and inst == ThePlayer then
        if inst._inhamroomcamea:value() ~= nil then
            local ent = inst._inhamroomcamea:value()
            TheCamera.inhamroom = true
            local x1, y1, z1 = ent.Transform:GetWorldPosition()

            TheCamera.roomtype = roomtype[ent.prefab] or "small"
            TheCamera.hamroompos = Vector3(x1 + 2, 0, z1)
        else
            TheCamera.inhamroom = false
            TheCamera.hamroompos = nil
            TheCamera.roomtype = "small"
        end
        if inst.components.playervision then
            inst.components.playervision:UpdateCCTable()
        end
    end
end

--Load
local function OnFocusCamera(inst)
    if inst.spawnanddelete_hamroom then ---------------------------额个东西是啥
        return
    end
    local ent = FindEntity(inst, 30, nil, { "interior_center" })
    if ent then
        if inst._inhamroomcamea:value() ~= ent then
            inst._inhamroomcamea:set(ent)
        end
    elseif inst._inhamroomcamea:value() ~= nil then
        inst._inhamroomcamea:set(nil)
    end
end

AddPlayerPostInit(function(inst)
    --房子的net
    inst._inhamroomcamea = net_entity(inst.GUID, "_inhamroomcamea", "inhamroomcameadirty")

    if TheWorld.ismastersim then
        inst:DoPeriodicTask(0.2, OnFocusCamera, 0.2)
    end

    if not TheNet:IsDedicated() then
        inst:ListenForEvent("inhamroomcameadirty", OnFocalFocusDirty)
    end
end)
