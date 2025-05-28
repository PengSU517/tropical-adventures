local BOAT_TYPES = {
    armouredboat = {
        name = "armouredboat",
        build = "rowboat_armored_build",
        icon = "armouredboat.tex",
        maxuses = 500,
        loottable = { "boards", "boards", "boards", "rope", "seashell", "seashell", "seashell", "seashell", "seashell" },
        collapse = "flotsam_armoured_build",
        useamount = 0.00862, -- Updated value
    },
    cargoboat = {
        name = "cargoboat",
        build = "rowboat_cargo_build",
        icon = "cargo.tex",
        maxuses = 300,
        loottable = { "boards", "boards", "boards", "rope" },
        collapse = "flotsam_cargo_build",
        useamount = 0.00625, -- Updated value
    },
    corkboat = {
        name = "corkboat",
        build = "coracle_boat_build",
        icon = "coracle_boat.tex",
        maxuses = 80,
        loottable = { "cork" },
        collapse = "flotsam_lograft_build",
        tags = { "pegabarco" },
        useamount = 0.00468, -- Not specified in your code snippet
    },
    encrustedboat = {
        name = "encrustedboat",
        build = "rowboat_encrusted_build",
        icon = "encrustedboat.tex",
        maxuses = 800,
        loottable = { "limestone", "limestone", "boards", "boards", "boards" },
        collapse = "flotsam_encrusted_build",
        useamount = 0.0100, -- Updated value
    },
    lograft_old = {
        name = "lograft_old",
        build = "raft_log_build",
        bank = "raft",
        icon = "lograft.tex",
        maxuses = 150,
        loottable = { "log", "log", "log", "cutgrass", "cutgrass" },
        collapse = "flotsam_lograft_build",
        onfinished = true,
        useamount = 0.00468, -- Updated value
    },
    woodlegsboat = {
        name = "woodlegsboat",
        build = "pirate_boat_build",
        icon = "woodlegsboat.tex",
        maxuses = 500,
        loottable = { "boards", "boards", "dubloon", "dubloon" },
        collapse = "flotsam_rowboat_build",
        useamount = 0.00468, -- Updated value
    },
    raft_old = {
        name = "raft_old",
        build = "raft_build",
        bank = "raft",
        icon = "raft.tex",
        maxuses = 150,
        loottable = { "vine", "bamboo", "bamboo" },
        collapse = "flotsam_bamboo_build",
        onfinished = true,
        useamount = 0.00468, -- Updated value
    },
    rowboat = {
        name = "rowboat",
        build = "rowboat_build",
        icon = "rowboat.tex",
        maxuses = 250,
        loottable = { "boards", "vine", "vine" },
        collapse = "flotsam_rowboat_build",
        useamount = 0.00781, -- Updated value
    },
    surfboard = {
        name = "surfboard",
        build = "raft_surfboard_build",
        bank = "raft",
        icon = "surfboard.tex",
        maxuses = 100,
        loottable = { "seashell" },
        collapse = "flotsam_surfboard_build",
        onfinished = true,
        tags = { "pegabarco", "surfboard" },
        useamount = 0.00312, -- Updated value
    },
}

-- 设置元表以实现默认访问
local mt = {
    __index = function(t, k)
        return rawget(t, k) or BOAT_TYPES.rowboat
    end,
}

setmetatable(BOAT_TYPES, mt)

return BOAT_TYPES
