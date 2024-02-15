AddRoomPreInit("OceanCoastal", function(room)
    -- if not room.contents.countstaticlayouts then
    -- 	room.contents.countstaticlayouts = {}
    -- end
    -- room.contents.distributepercent = 0.1
    -- room.value = WORLD_TILES.LILYPOND ---似乎改不了地皮,改了地皮反而生成不了任何东西
    room.contents.distributeprefabs.messagebottle1 = 0.1
    room.contents.distributeprefabs.seaweed_planted = 2
    room.contents.distributeprefabs.coralreef = 0.1
    room.contents.distributeprefabs.ballphinhouse = 0.5
    room.contents.distributeprefabs.seataro_planted = 0.5
    room.contents.distributeprefabs.seacucumber_planted = 0.5


    -- room.contents.countstaticlayouts["coralpool1"] = 3
    -- room.contents.countstaticlayouts["coralpool2"] = 3
    -- room.contents.countstaticlayouts["coralpool3"] = 3
    -- room.contents.countstaticlayouts["octopuskinghome"] = 1
    -- room.contents.countstaticlayouts["mangrove1"] = 2
    -- room.contents.countstaticlayouts["mangrove2"] = 1
    -- room.contents.countstaticlayouts["wreck"] = 1
    -- room.contents.countstaticlayouts["wreck2"] = 1
    -- room.contents.countstaticlayouts["kraken"] = 1
end)

-- AddRoomPreInit("OceanCoastalShore", function(room)
--     room.value = GROUND.LILYPOND
-- end)
