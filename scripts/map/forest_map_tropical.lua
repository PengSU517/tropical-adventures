local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IA_worldtype = "islandsonly"

IAENV.modimport("main/util")
IAENV.modimport("main/spawnutil")

require("map/water")
local startlocations = require("map/startlocations")
local forest_map = require("map/forest_map")
local TRANSLATE_TO_PREFABS = forest_map.TRANSLATE_TO_PREFABS
local TRANSLATE_AND_OVERRIDE = forest_map.TRANSLATE_AND_OVERRIDE

TRANSLATE_TO_PREFABS["crabhole"] =			{"crabhole"}
TRANSLATE_TO_PREFABS["ox"] =				{"ox"}
TRANSLATE_TO_PREFABS["solofish"] =			{"solofish", "solofish_spawner"}
TRANSLATE_TO_PREFABS["jellyfish"] =			{"jellyfish_planted", "jellyfish_spawner"}
TRANSLATE_TO_PREFABS["fishinhole"] =		{"fishinhole"}
TRANSLATE_TO_PREFABS["seashell"] =			{"seashell_beached"}
TRANSLATE_TO_PREFABS["seaweed"] =			{"seaweed_planted"}
TRANSLATE_TO_PREFABS["obsidian"] =			{"obsidian"}
TRANSLATE_TO_PREFABS["limpets"] =			{"rock_limpet"}
TRANSLATE_TO_PREFABS["coral"] =				{"rock_coral"}
TRANSLATE_TO_PREFABS["coral_brain_rock"] =	{"coral_brain_rock"}
--TRANSLATE_TO_PREFABS["bermudatriangle"] =	{"bermudatriangle_MARKER"}
TRANSLATE_TO_PREFABS["flup"] =				{"flup", "flupspawner", "flupspawner_sparse", "flupspawner_dense"}
TRANSLATE_TO_PREFABS["sweet_potato"] =		{"sweet_potato_planted"}
TRANSLATE_TO_PREFABS["wildbores"] =			{"wildborehouse"}
TRANSLATE_TO_PREFABS["bush_vine"] =			{"bush_vine", "snakeden"}
TRANSLATE_TO_PREFABS["bamboo"] =			{"bamboo", "bambootree"}
TRANSLATE_TO_PREFABS["crate"] =				{"crate"}
TRANSLATE_TO_PREFABS["tidalpool"] =			{"tidalpool"}
TRANSLATE_TO_PREFABS["sandhill"] =			{"sanddune"}
TRANSLATE_TO_PREFABS["poisonhole"] =		{"poisonhole"}
TRANSLATE_TO_PREFABS["mussel_farm"] =		{"mussel_farm"}
TRANSLATE_TO_PREFABS["doydoy"] =			{"doydoy", "doydoybaby"}
TRANSLATE_TO_PREFABS["lobster"] =			{"lobster", "lobsterhole"}
TRANSLATE_TO_PREFABS["primeape"] =			{"primeape", "primeapebarrel"}
TRANSLATE_TO_PREFABS["bioluminescence"] =	{"bioluminescence", "bioluminescence_spawner"}
TRANSLATE_TO_PREFABS["ballphin"] =			{"ballphin", "ballphin_spawner", "ballphinhouse"}
TRANSLATE_TO_PREFABS["swordfish"] =			{"swordfish", "swordfish_spawner"}
TRANSLATE_TO_PREFABS["stungray"] =			{"stungray", "stungray_spawner"}

TRANSLATE_AND_OVERRIDE["volcano"] =			{"volcano"}
TRANSLATE_AND_OVERRIDE["seagull"] =			{"seagullspawner"}

local SEASONS = forest_map.SEASONS

local function seasonfn(datafn, friendly)
    local function datafn_tropical(data, season, ...)
        if not data.seasons then
            data.seasons = {}
        end
        -- TODO: add custom tuning values for these

        local totaldaysinseason
        local remainingdaysinseason
        if friendly then
            totaldaysinseason = TUNING.SEASON_LENGTH_FRIENDLY_DEFAULT*2
            remainingdaysinseason = TUNING.SEASON_LENGTH_FRIENDLY_DEFAULT
        else
            totaldaysinseason = TUNING.SEASON_LENGTH_HARSH_DEFAULT
            remainingdaysinseason = TUNING.SEASON_LENGTH_HARSH_DEFAULT
        end
        data.seasons.seasontropical = season
        data.seasons.totaldaysinseasontropical = totaldaysinseason
        data.seasons.elapseddaysinseasontropical = 0
        data.seasons.remainingdaysinseasontropical = remainingdaysinseason
        return data
    end
    return function(season, ...)
        local data = datafn(season, ...)
        data = datafn_tropical(data, season, ...)
        return data
    end
end

for season, datafn in pairs(SEASONS) do
    SEASONS[season] = seasonfn(datafn, not (season == "summer" or season == "winter"))
end

local function ValidateGroundTile_Shipwrecked(tile)
    return WORLD_TILES.IMPASSABLE
end

local function ValidateGroundTile_Volcano(tile)
    return WORLD_TILES.VOLCANO_LAVA
end

local SKIP_GEN_CHECKS = false
local _Generate = forest_map.Generate
local GetTileForNoiseTile = UpvalueHacker.GetUpvalue(_Generate, "GetTileForNoiseTile")
local ValidateGroundTile = UpvalueHacker.GetUpvalue(_Generate, "ValidateGroundTile")
local pickspawnprefab = UpvalueHacker.GetUpvalue(_Generate, "pickspawnprefab")
local pickspawngroup = UpvalueHacker.GetUpvalue(_Generate, "pickspawngroup")
local pickspawncountprefabforground = UpvalueHacker.GetUpvalue(_Generate, "pickspawncountprefabforground")
local TranslateWorldGenChoices = UpvalueHacker.GetUpvalue(_Generate, "TranslateWorldGenChoices")

forest_map.Generate = function(prefab, map_width, map_height, tasks, level, level_type, ...)
    assert(level.overrides ~= nil, "Level must have overrides specified.")

    if not level.overrides.primaryworldtype then  --Haack, but needed so the override function always gets called. -M
        level.overrides.primaryworldtype = "default"
    end

    --We should compare this to the shard somehow. (Is this master or caves/volcano?) -M
    IA_worldtype = WORLDTYPES.worldgen[level.overrides.primaryworldtype] or "default"
    if IA_worldtype == "default" and prefab == "caves" then
        IA_worldtype = "caves"
    end

    local IsShipwrecked = IA_worldtype == "shipwrecked"
    local IsVolcano = IA_worldtype == "volcano"
    local IsDefault = IA_worldtype == "default" or IA_worldtype == "caves" or IA_worldtype == nil

    if IsDefault then
        return _Generate(prefab, map_width, map_height, tasks, level, level_type, ...)
    end

    WorldSim:SetPointsBarrenOrReservedTile(WORLD_TILES.ROAD)
    WorldSim:SetResolveNoiseFunction(GetTileForNoiseTile)

    local ValidateGroundTileFn = ValidateGroundTile_Shipwrecked
    if IsVolcano then
        ValidateGroundTileFn = ValidateGroundTile_Volcano
    end
    WorldSim:SetValidateGroundTileFunction(ValidateGroundTileFn)

    local SpawnFunctions = {
        pickspawnprefab = pickspawnprefab,
        pickspawngroup = pickspawngroup,
        pickspawncountprefabforground = pickspawncountprefabforground,
    }

    local current_gen_params = deepcopy(level.overrides)
    local default_impassible_tile = WORLD_TILES.IMPASSABLE

    local story_gen_params = {}
    story_gen_params.impassible_value = default_impassible_tile
    story_gen_params.level_type = level_type

    if current_gen_params.start_location == nil then
        current_gen_params.start_location = "default"
    end

    if current_gen_params.start_location ~= nil then
        local start_loc = startlocations.GetStartLocation( current_gen_params.start_location )
        story_gen_params.start_setpeice = type(start_loc.start_setpeice) == "table" and start_loc.start_setpeice[math.random(#start_loc.start_setpeice)] or start_loc.start_setpeice
        story_gen_params.start_node = type(start_loc.start_node) == "table" and start_loc.start_node[math.random(#start_loc.start_node)] or start_loc.start_node
        if story_gen_params.start_node == nil then
            -- existing_start_node is no longer supported
            story_gen_params.start_node = type(start_loc.existing_start_node) == "table" and start_loc.existing_start_node[math.random(#start_loc.existing_start_node)] or start_loc.existing_start_node
        end
    end

    if  current_gen_params.islands ~= nil then
        local percent = {always = 1, never = 0, default = 0.2, sometimes = 0.1, often = 0.8}
        story_gen_params.island_percent = percent[current_gen_params.islands]
    end

    if  current_gen_params.branching ~= nil then
        story_gen_params.branching = current_gen_params.branching
    end

    if  current_gen_params.loop ~= nil then
        local loop_percent = { never = 0, default = nil, always = 1.0 }
        local loop_target = { never = "any", default = nil, always = "end"}
        story_gen_params.loop_percent = loop_percent[current_gen_params.loop]
        story_gen_params.loop_target = loop_target[current_gen_params.loop]
    end

    if current_gen_params.keep_disconnected_tiles ~= nil then
        story_gen_params.keep_disconnected_tiles = current_gen_params.keep_disconnected_tiles
    end

    if current_gen_params.no_joining_islands ~= nil then
        story_gen_params.no_joining_islands = current_gen_params.no_joining_islands
    end

    if current_gen_params.has_ocean ~= nil then
        story_gen_params.has_ocean = current_gen_params.has_ocean
    end

    if current_gen_params.no_wormholes_to_disconnected_tiles ~= nil then
        story_gen_params.no_wormholes_to_disconnected_tiles = current_gen_params.no_wormholes_to_disconnected_tiles
    end

    if current_gen_params.wormhole_prefab ~= nil then
        story_gen_params.wormhole_prefab = current_gen_params.wormhole_prefab
    end

    ApplySpecialEvent(current_gen_params.specialevent)
    for k, event_name in pairs(SPECIAL_EVENTS) do
        if current_gen_params[event_name] == "enabled" then
            ApplyExtraEvent(event_name)
        end
    end

    local min_size = 350
    if current_gen_params.world_size ~= nil then
        local sizes
        if PLATFORM == "PS4" then
            sizes = {
                ["default"] = 350,
                ["medium"] = 400,
                ["large"] = 425,
            }
        else
            sizes = {
                ["tiny"] = 75,
                ["small"] = 150,
                ["medium"] = 250,
                ["default"] = 350, -- default == large, at the moment...
                ["large"] = 350,
                ["huge"] = 425,
            }
        end

        if sizes[current_gen_params.world_size] then
            min_size = sizes[current_gen_params.world_size]
            print("New size:", min_size, current_gen_params.world_size)
        else
            print("ERROR: Worldgen preset had an invalid size: "..current_gen_params.world_size)
        end
    end
    map_width = min_size
    map_height = min_size
    WorldSim:SetWorldSize(map_width, map_height)

    print("Creating story...")
    require("map/storygen")
    local topology_save, storygen = BuildShipwreckedStory(tasks, story_gen_params, level)

    WorldSim:WorldGen_InitializeNodePoints();

    WorldSim:WorldGen_VoronoiPass(100)

    print("... story created")

    print("Baking map...", min_size)

    if not WorldSim:WorldGen_Commit() then
        return nil
    end

    if WorldSim:GenerateVoronoiMap(math.random(), 0, TUNING.MAPEDGE_PADDING) == false then--math.random(0,100)) -- AM: Dont use the tend
        return nil
    end

    topology_save.root:ApplyPoisonTag()
    WorldSim:ConvertToTileMap(min_size)

    -- WorldSim:SeparateIslands()

    print("Map Baked!")
    map_width, map_height = WorldSim:GetWorldSize()

    local join_islands = not current_gen_params.no_joining_islands

    -- Note: This also generates land tiles
    local ground_fill = WORLD_TILES.BEACH
    if IsShipwrecked then
        ground_fill = WORLD_TILES.BEACH
    elseif IsVolcano then
        ground_fill = WORLD_TILES.VOLCANO
    end
    WorldSim:ForceConnectivity(join_islands, false, ground_fill)

    local entities = {}

    -- Run Node specific functions here
    local nodes = topology_save.root:GetNodes(true)
    for _, node in pairs(nodes) do
        node:SetTilesViaFunction(entities, map_width, map_height)
    end

    print("Encoding...")

    local save = {}
    save.ents = {}
    save.map = {
        tiles = "",
        topology = {},
        prefab = prefab,
        has_ocean = current_gen_params.has_ocean,
    }
    topology_save.root:SaveEncode({width = map_width, height = map_height}, save.map.topology)
    WorldSim:CreateNodeIdTileMap(save.map.topology.ids)
    print("Encoding... DONE")

    -- TODO: Double check that each of the rooms has enough space (minimimum # tiles generated) - maybe countprefabs + %
    -- For each item in the topology list
    -- Get number of tiles for that node
    -- if any are less than minumum - restart the generation

    for idx, val in ipairs(save.map.topology.nodes) do
        if string.find(save.map.topology.ids[idx], "LOOP_BLANK_SUB") == nil  then
             local area = WorldSim:GetSiteArea(save.map.topology.ids[idx])
            if area < 8 then
                print ("ERROR: Site "..save.map.topology.ids[idx].." area < 8: "..area)
                if SKIP_GEN_CHECKS == false then
                    return nil
                end
               end
           end
    end

    local translated_prefabs, runtime_overrides = TranslateWorldGenChoices(current_gen_params)

    print("Checking Tags")
    local obj_layout = require("map/object_layout")

    if level.water_prefill_setpieces then
        local add_fn = {
            fn = function(prefab, points_x, points_y, current_pos_idx, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
                local tile = WorldSim:GetTile(points_x[current_pos_idx], points_y[current_pos_idx])
                PopulateWorld_AddEntity(prefab, points_x[current_pos_idx], points_y[current_pos_idx], tile, entitiesOut, width, height, {}, prefab_data, rand_offset)
            end,
            args={entitiesOut = entities, width= map_width, height = map_height, rand_offset = false, debug_prefab_list = nil}
        }

        PlaceWaterSetPieces(level.water_prefill_setpieces, add_fn, function(ground) return ground == WORLD_TILES.IMPASSABLE end)
    end

    if IsShipwrecked then
        ConvertImpassibleToWater(map_width, map_height, require("map/watergen"))
    end

    print("Populating voronoi...")

    topology_save.root:GlobalPrePopulate(entities, map_width, map_height)
    topology_save.root:ShipwreckedConvertGround(SpawnFunctions, entities, map_width, map_height)
    WorldSim:ReplaceSingleNonLandTiles()

    if not story_gen_params.keep_disconnected_tiles then
        local replace_count = WorldSim:DetectDisconnect()
        --allow at most 5% of tiles to be disconnected
        if replace_count > math.floor(map_width * map_height * 0.05) then
            print("PANIC: Too many disconnected tiles...", replace_count)
            if SKIP_GEN_CHECKS == false then
                return nil
            end
        else
            print("disconnected tiles...", replace_count)
        end
    else
        print("Not checking for disconnected tiles.")
    end

    save.map.generated = {}
    save.map.generated.densities = {}

    for _, node in pairs(nodes) do
        if node.custom_tiles_data ~= nil then
            node.populated = false
            node:PopulateVoronoi(SpawnFunctions, entities, map_width, map_height, node.custom_tiles_data.data.world_gen_choices, save.map.generated.densities)
        end
    end

    topology_save.root:PopulateVoronoi(SpawnFunctions, entities, map_width, map_height, translated_prefabs, save.map.generated.densities)

    if IsShipwrecked then
        RemoveSingleWaterTile(map_width, map_height)
        AddShipwreckedShoreline(map_width, map_height)
        LinkCoralTile(map_width, map_height)
        PopulateWater(SpawnFunctions, entities, map_width, map_height, topology_save.water, current_gen_params)
    end

    topology_save.root.isshipwrecked = IsShipwrecked
    topology_save.root:GlobalPostPopulate(entities, map_width, map_height)

    for k, ents in pairs(entities) do
        for i=#ents, 1, -1 do
            local x = ents[i].x/TILE_SCALE + map_width/2.0
            local y = ents[i].z/TILE_SCALE + map_height/2.0

            local tiletype = WorldSim:GetVisualTileAtPosition(x,y) -- Warning: This does not quite work as expected. It thinks the ground type id is in rendering order, which it totally is not!
            if TileGroupManager:IsImpassableTile(tiletype) then
                print("Removing entity on IMPASSABLE", k, x, y, ""..ents[i].x..", 0, "..ents[i].z)
                table.remove(entities[k], i)
            end
        end
    end

    if translated_prefabs ~= nil then
        -- Filter out any etities over our overrides
        for prefab, mult in pairs(translated_prefabs) do
            if type(mult) == "number" and mult < 1 and entities[prefab] ~= nil and #entities[prefab] > 0 then
                local new_amt = math.floor(#entities[prefab]*mult)
                if new_amt == 0 then
                    entities[prefab] = nil
                else
                    entities[prefab] = shuffleArray(entities[prefab])
                    while #entities[prefab] > new_amt do
                        table.remove(entities[prefab], 1)
                    end
                end
            end
        end
    end

    BunchSpawnerInit(entities, map_width, map_height)
    BunchSpawnerRun(WorldSim)

    AncientArchivePass(entities, map_width, map_height, WorldSim)

    local double_check = {}
    for i, prefab in ipairs(level.required_prefabs or {}) do
        if not translated_prefabs or translated_prefabs[prefab] ~= 0 then
            if double_check[prefab] == nil then
                double_check[prefab] = 1
            else
                double_check[prefab] = double_check[prefab] + 1
            end
        end
    end
    for prefab, count in pairs(topology_save.root:GetRequiredPrefabs()) do
        if not translated_prefabs or translated_prefabs[prefab] ~= 0 then
            if double_check[prefab] == nil then
                double_check[prefab] = count
            else
                double_check[prefab] = double_check[prefab] + count
            end
        end
    end

    for prefab, count in pairs(double_check) do
        print ("Checking Required Prefab " .. prefab .. " has at least " .. count .. " instances (" .. (entities[prefab] ~= nil and #entities[prefab] or 0) .. " found).")

        if entities[prefab] == nil or #entities[prefab] < count then
            if level.overrides[prefab] == "never" then
                print(string.format(" - missing required prefab [%s] was disabled in the world generation options!", prefab))
            else
                print(string.format("PANIC: missing required prefab [%s]! Expected %d, got %d", prefab, count, entities[prefab] == nil and 0 or #entities[prefab]))
                if SKIP_GEN_CHECKS == false then
                    return nil
                end
            end
        end
    end

    if level.required_prefab_count then
        for _prefab, count in pairs(level.required_prefab_count) do
            if entities[_prefab] == nil or #entities[_prefab] < count then
                print("PANIC: missing required prefab count!", _prefab, count)
                if SKIP_GEN_CHECKS == false then
                    return nil
                end
            end
        end
    end

    save.ents = entities

    save.map.tiles, save.map.tiledata, save.map.nav, save.map.adj, save.map.nodeidtilemap = WorldSim:GetEncodedMap(join_islands)
    save.map.world_tile_map = GetWorldTileMap()

    save.map.topology.overrides = deepcopy(current_gen_params)
    save.map.topology.ia_worldgen_version = 2
    -- Feel free to increase this version when making big changes. -M
    -- Test this during simulation via TheWorld.topology.ia_worldgen_version
    -- Go through 2 years, updata 1 version to 2 to get better worldgen - Jerry
    if save.map.topology.overrides == nil then
        save.map.topology.overrides = {}
    end

    save.map.width, save.map.height = map_width, map_height

    local start_season = current_gen_params.season_start or "autumn"
    if string.find(start_season, "|", nil, true) then
        start_season = GetRandomItem(string.split(start_season, "|"))
    elseif start_season == "default" then
        start_season = forest_map.DEFAULT_SEASON
    end

    local componentdata = SEASONS[start_season](start_season)

    if save.world_network == nil then
        save.world_network = {persistdata = {}}
    elseif save.world_network.persistdata == nil then
        save.world_network.persistdata = {}
    end

    for k, v in pairs(componentdata) do
        save.world_network.persistdata[k] = v
    end

    if (save.ents.spawnpoint_multiplayer == nil or #save.ents.spawnpoint_multiplayer == 0)
        and (save.ents.multiplayer_portal == nil or #save.ents.multiplayer_portal == 0)
        and (save.ents.quagmire_portal == nil or #save.ents.quagmire_portal == 0)
        and (save.ents.lavaarena_portal == nil or #save.ents.lavaarena_portal == 0) then
        print("PANIC: No start location!")
        if SKIP_GEN_CHECKS == false then
            return nil
        else
            save.ents.spawnpoint={{x=0,y=0,z=0}}
        end
    end

    save.map.roads = {}

    print("Done "..prefab.." map gen!")

    return save
end
