if false then ----------GetModConfigData("kindofworld") == 5
    function HamletcloudPostInit()
        local World = GLOBAL.TheWorld
        if not TheNet:IsDedicated() and World and World.WaveComponent then
            World.Map:SetUndergroundFadeHeight(0)
            World.Map:AlwaysDrawWaves(true)
            World.WaveComponent:SetWaveTexture(GLOBAL.resolvefilepath("images/fog_cloud.tex"))
            local scale = 1
            local map_width, map_height = World.Map:GetSize()
            World.WaveComponent:SetWaveParams(13.5, 2.5, -1)
            World.WaveComponent:Init(map_width, map_height)
            World.WaveComponent:SetWaveSize(80 * scale, 3.5 * scale)
            World.WaveComponent:SetWaveMotion(0.3, 0.5, 0.35)

            local map = World.Map
            local tuning = TUNING.OCEAN_SHADER
            map:SetOceanEnabled(true)
            map:SetOceanTextureBlurParameters(tuning.TEXTURE_BLUR_PASS_SIZE, tuning.TEXTURE_BLUR_PASS_COUNT)
            map:SetOceanNoiseParameters0(tuning.NOISE[1].ANGLE, tuning.NOISE[1].SPEED, tuning.NOISE[1].SCALE,
                tuning.NOISE[1].FREQUENCY)
            map:SetOceanNoiseParameters1(tuning.NOISE[2].ANGLE, tuning.NOISE[2].SPEED, tuning.NOISE[2].SCALE,
                tuning.NOISE[2].FREQUENCY)
            map:SetOceanNoiseParameters2(tuning.NOISE[3].ANGLE, tuning.NOISE[3].SPEED, tuning.NOISE[3].SCALE,
                tuning.NOISE[3].FREQUENCY)

            local waterfall_tuning = TUNING.WATERFALL_SHADER.NOISE
            map:SetWaterfallFadeParameters(TUNING.WATERFALL_SHADER.FADE_COLOR[1] / 255,
                TUNING.WATERFALL_SHADER.FADE_COLOR[2] / 255, TUNING.WATERFALL_SHADER.FADE_COLOR[3] / 255,
                TUNING.WATERFALL_SHADER.FADE_START)
            map:SetWaterfallNoiseParameters0(waterfall_tuning[1].SCALE, waterfall_tuning[1].SPEED,
                waterfall_tuning[1].OPACITY, waterfall_tuning[1].FADE_START)
            map:SetWaterfallNoiseParameters1(waterfall_tuning[2].SCALE, waterfall_tuning[2].SPEED,
                waterfall_tuning[2].OPACITY, waterfall_tuning[2].FADE_START)

            local minimap_ocean_tuning = TUNING.OCEAN_MINIMAP_SHADER
            map:SetMinimapOceanEdgeColor0(minimap_ocean_tuning.EDGE_COLOR0[1] / 255,
                minimap_ocean_tuning.EDGE_COLOR0[2] / 255, minimap_ocean_tuning.EDGE_COLOR0[3] / 255)
            map:SetMinimapOceanEdgeParams0(minimap_ocean_tuning.EDGE_PARAMS0.THRESHOLD,
                minimap_ocean_tuning.EDGE_PARAMS0.HALF_THRESHOLD_RANGE)

            map:SetMinimapOceanEdgeColor1(minimap_ocean_tuning.EDGE_COLOR1[1] / 255,
                minimap_ocean_tuning.EDGE_COLOR1[2] / 255, minimap_ocean_tuning.EDGE_COLOR1[3] / 255)
            map:SetMinimapOceanEdgeParams1(minimap_ocean_tuning.EDGE_PARAMS1.THRESHOLD,
                minimap_ocean_tuning.EDGE_PARAMS1.HALF_THRESHOLD_RANGE)

            map:SetMinimapOceanEdgeShadowColor(minimap_ocean_tuning.EDGE_SHADOW_COLOR[1] / 255,
                minimap_ocean_tuning.EDGE_SHADOW_COLOR[2] / 255, minimap_ocean_tuning.EDGE_SHADOW_COLOR[3] / 255)
            map:SetMinimapOceanEdgeShadowParams(minimap_ocean_tuning.EDGE_SHADOW_PARAMS.THRESHOLD,
                minimap_ocean_tuning.EDGE_SHADOW_PARAMS.HALF_THRESHOLD_RANGE,
                minimap_ocean_tuning.EDGE_SHADOW_PARAMS.UV_OFFSET_X, minimap_ocean_tuning.EDGE_SHADOW_PARAMS.UV_OFFSET_Y)

            map:SetMinimapOceanEdgeFadeParams(minimap_ocean_tuning.EDGE_FADE_PARAMS.THRESHOLD,
                minimap_ocean_tuning.EDGE_FADE_PARAMS.HALF_THRESHOLD_RANGE,
                minimap_ocean_tuning.EDGE_FADE_PARAMS.MASK_INSET)

            map:SetMinimapOceanEdgeNoiseParams(minimap_ocean_tuning.EDGE_NOISE_PARAMS.UV_SCALE)

            map:SetMinimapOceanTextureBlurParameters(minimap_ocean_tuning.TEXTURE_BLUR_SIZE,
                minimap_ocean_tuning.TEXTURE_BLUR_PASS_COUNT, minimap_ocean_tuning.TEXTURE_ALPHA_BLUR_SIZE,
                minimap_ocean_tuning.TEXTURE_ALPHA_BLUR_PASS_COUNT)
            map:SetMinimapOceanMaskBlurParameters(minimap_ocean_tuning.MASK_BLUR_SIZE,
                minimap_ocean_tuning.MASK_BLUR_PASS_COUNT)

            if World.ismastersim then World:AddComponent("cloudpuffmanager") end
        end
    end

    AddSimPostInit(HamletcloudPostInit)
end
