AddRoomPreInit("OceanCoastal", function(room)
    -- if not room.contents.countstaticlayouts then
    -- 	room.contents.countstaticlayouts = {}
    -- end
    -- room.contents.distributepercent = 0.1
    -- room.value = WORLD_TILES.LILYPOND ---似乎改不了地皮,改了地皮反而生成不了任何东西
    room.contents.distributeprefabs.messagebottle1 = 0.1
    room.contents.distributeprefabs.seaweed_planted = 2
end)

-- AddRoomPreInit("OceanCoastalShore", function(room)
--     room.value = GROUND.LILYPOND
-- end)
