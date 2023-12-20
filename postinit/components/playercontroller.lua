----- desembarque automatico resto do código dentro de locomotor ----------------
AddClassPostConstruct("components/playercontroller", function(self)
    local RUBBER_BAND_PING_TOLERANCE_IN_SECONDS = 0.7
    local RUBBER_BAND_DISTANCE = 4

    function self:OnRemoteStartHop(x, z, platform)
        if not self.ismastersim then return end
        if not self:IsEnabled() then return end
        if not self.handler == nil then return end

        local my_x, my_y, my_z = self.inst.Transform:GetWorldPosition()
        local target_x, target_y, target_z = x, 0, z
        local platform_for_velocity_calculation = platform

        if platform ~= nil then
            target_x, target_z = platform.components.walkableplatform:GetEmbarkPosition(my_x, my_z)
        else
            platform_for_velocity_calculation = self.inst:GetCurrentPlatform()
            --		if TUNING.tropical.disembarkation then platform_for_velocity_calculation = self.inst:GetCurrentPlatform() or GetClosestInstWithTag("barcoapto", self.inst, 0.5) end
            platform_for_velocity_calculation = self.inst:GetCurrentPlatform() or
                GetClosestInstWithTag("barcoapto", self.inst, 0.5)
        end

        if platform == nil and (platform_for_velocity_calculation == nil or GLOBAL.TheWorld.Map:IsOceanAtPoint(target_x, 0, target_z)) then
            return
        end

        local hop_dir_x, hop_dir_z = target_x - my_x, target_z - my_z
        local hop_distance_sq = hop_dir_x * hop_dir_x + hop_dir_z * hop_dir_z

        local target_velocity_rubber_band_distance = 0
        local platform_velocity_x, platform_velocity_z = 0, 0
        if platform_for_velocity_calculation ~= nil then
            local platform_physics = platform_for_velocity_calculation.Physics
            if platform_physics ~= nil then
                platform_velocity_x, platform_velocity_z = platform_physics:GetVelocity()
                if platform_velocity_x ~= 0 or platform_velocity_z ~= 0 then
                    local hop_distance = math.sqrt(hop_distance_sq)
                    local normalized_hop_dir_x, normalized_hop_dir_z = hop_dir_x / hop_distance, hop_dir_z / hop_distance
                    local velocity = math.sqrt(platform_velocity_x * platform_velocity_x +
                        platform_velocity_z * platform_velocity_z)
                    local normalized_platform_velocity_x, normalized_platform_velocity_z = platform_velocity_x / velocity,
                        platform_velocity_z / velocity
                    local hop_dir_dot_platform_velocity = normalized_platform_velocity_x * normalized_hop_dir_x +
                        normalized_platform_velocity_z * normalized_hop_dir_z
                    if hop_dir_dot_platform_velocity > 0 then
                        target_velocity_rubber_band_distance = RUBBER_BAND_PING_TOLERANCE_IN_SECONDS * velocity *
                            hop_dir_dot_platform_velocity
                    end
                end
            end
        end

        local locomotor = self.inst.components.locomotor
        local hop_rubber_band_distance = RUBBER_BAND_DISTANCE + target_velocity_rubber_band_distance +
            locomotor:GetHopDistance()
        local hop_rubber_band_distance_sq = hop_rubber_band_distance * hop_rubber_band_distance

        if hop_distance_sq > hop_rubber_band_distance_sq then
            print("Hop discarded:", "\ntarget_velocity_rubber_band_distance", target_velocity_rubber_band_distance,
                "\nplatform_velocity_x", platform_velocity_x, "\nplatform_velocity_z", platform_velocity_z,
                "\nhop_distance", math.sqrt(hop_distance_sq), "\nhop_rubber_band_distance",
                math.sqrt(hop_rubber_band_distance_sq))
            return
        end

        self.remote_vector.y = 6
        self.inst.components.locomotor:StartHopping(x, z, platform)
    end
end)
