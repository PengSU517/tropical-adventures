local soundremap = {

    shipwrecked = {
        ["dontstarve/music/music_epicfight"] = "dontstarve_DLC002/music/music_epicfight_season_1",
        ["dontstarve/music/music_epicfight_winter"] = "dontstarve_DLC002/music/music_epicfight_season_2",
        ["dontstarve_DLC001/music/music_epicfight_spring"] = "dontstarve_DLC002/music/music_epicfight_season_3",
        ["dontstarve_DLC001/music/music_epicfight_summer"] = "dontstarve_DLC002/music/music_epicfight_season_4",
        --Working
        ["dontstarve/music/music_work"] = "dontstarve_DLC002/music/music_work_season_1",
        ["dontstarve/music/music_work_winter"] = "dontstarve_DLC002/music/music_work_season_2",
        ["dontstarve_DLC001/music/music_work_spring"] = "dontstarve_DLC002/music/music_work_season_3",
        ["dontstarve_DLC001/music/music_work_summer"] = "dontstarve_DLC002/music/music_work_season_4",
        --dawndusk
        ["dontstarve/music/music_dawn_stinger"] = "dontstarve_DLC002/music/music_dawn_stinger",
        ["dontstarve/music/music_dusk_stinger"] = "dontstarve_DLC002/music/music_dusk_stinger",
        --Danger
        ["dontstarve/music/music_danger"] = "dontstarve_DLC002/music/music_danger_season_1",
        ["dontstarve/music/music_danger_winter"] = "dontstarve_DLC002/music/music_danger_season_2",
        ["dontstarve_DLC001/music/music_danger_spring"] = "dontstarve_DLC002/music/music_danger_season_3",
        ["dontstarve_DLC001/music/music_danger_summer"] = "dontstarve_DLC002/music/music_danger_season_4",
    },

    hamlet = {
        ["dontstarve/music/music_epicfight"] = "dontstarve_DLC003/music/fight_epic_1",
        ["dontstarve/music/music_epicfight_winter"] = "dontstarve_DLC003/music/fight_epic_2",
        ["dontstarve_DLC001/music/music_epicfight_spring"] = "dontstarve_DLC003/music/fight_epic_3",
        ["dontstarve_DLC001/music/music_epicfight_summer"] = "dontstarve_DLC003/music/fight_epic_4",
        --Working
        ["dontstarve/music/music_work"] = "dontstarve_DLC003/music/working_1",
        ["dontstarve/music/music_work_winter"] = "dontstarve_DLC003/music/working_2",
        ["dontstarve_DLC001/music/music_work_spring"] = "dontstarve_DLC003/music/working_1",
        ["dontstarve_DLC001/music/music_work_summer"] = "dontstarve_DLC003/music/working_3",
        --dawndusk
        ["dontstarve/music/music_dawn_stinger"] = "dontstarve_DLC003/music/dawn_stinger_1_temperate",
        ["dontstarve/music/music_dusk_stinger"] = "dontstarve_DLC003/music/dusk_stinger_1_temperate",
        --Danger
        ["dontstarve/music/music_danger"] = "dontstarve_DLC003/music/fight_1",
        ["dontstarve/music/music_danger_winter"] = "dontstarve_DLC003/music/fight_2",
        ["dontstarve_DLC001/music/music_danger_spring"] = "dontstarve_DLC003/music/fight_3",
        ["dontstarve_DLC001/music/music_danger_summer"] = "dontstarve_DLC003/music/fight_4",
    }
}


-- for k, v in pairs(soundremap.shipwrecked) do
--     RemapSoundEvent(k, v)
-- end


AddComponentPostInit("dynamicmusic", function(self, inst)
    ------------------------------Adding Climate Music---------------------------------
    local _activatedplayer
    local OnPlayerActivated = inst:GetEventCallbacks("playeractivated", inst, "scripts/components/dynamicmusic.lua")
    local BUSYTHEMES = upvaluehelper.Get(OnPlayerActivated, "BUSYTHEMES")


    ---勾不了函数我还勾不了参数吗，我可太牛逼了
    BUSYTHEMES.ROG = BUSYTHEMES.FOREST
    BUSYTHEMES.SHIPWRECCKED = tableutil.getlength(BUSYTHEMES) + 1
    BUSYTHEMES.HAMLET = tableutil.getlength(BUSYTHEMES) + 1
    BUSYTHEMES.VOLCANO = tableutil.getlength(BUSYTHEMES) + 1


    local function MusicReDirect()
        if _activatedplayer then
            -- print("MusicReDirect")
            if _activatedplayer:AwareInHamletArea() then
                -- print "in hamlet"
                BUSYTHEMES.FOREST = BUSYTHEMES.HAMLET
                for k, v in pairs(soundremap.hamlet) do
                    RemapSound(k, v)
                end
            elseif _activatedplayer:AwareInShipwreckedArea() then
                -- print "in shipwrecked"
                BUSYTHEMES.FOREST = BUSYTHEMES.SHIPWRECCKED
                for k, v in pairs(soundremap.shipwrecked) do
                    RemapSound(k, v)
                end
            else
                -- print "in neither"
                BUSYTHEMES.FOREST = BUSYTHEMES.ROG
                for k, v in pairs(soundremap.shipwrecked) do
                    RemapSound(k, nil)
                end
            end
        end
    end

    self.inst:ListenForEvent("playeractivated", function(src, player)
        -- print "playeractivated111111111"
        if player and _activatedplayer ~= player then
            player:ListenForEvent("regionchange_client", MusicReDirect)
            player:DoTaskInTime(0, MusicReDirect) --initialise
        end
        _activatedplayer = player
    end)
    self.inst:ListenForEvent("playerdeactivated", function(src, player)
        if player then
            player:RemoveEventCallback("regionchange_client", MusicReDirect)
            if _activatedplayer == player then
                _activatedplayer = nil
            end
        end
    end)
end)
