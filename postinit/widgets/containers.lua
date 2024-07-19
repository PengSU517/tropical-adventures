local containers = GLOBAL.require "containers"
-- local containers = require("containers")

---------------------------------------configura os slots--------------------------------------------------------------------
--local params = getval(containers.widgetsetup, "params")
local params = {}

params.armorvortexcloak =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_krampusbag_2x5",
        animbuild = "ui_krampusbag_2x5",
        bgimage = nil,
        bgatlas = nil,
        pos = Vector3(-5, -60, 0),
    },
    issidewidget = true,
    type = "pack",
    openlimit = 1,
}
for y = 0, 4 do
    for x = 0, 1 do
        table.insert(params.armorvortexcloak.widget.slotpos, Vector3(75 * x - 162, 75 * y - 186, 0))
    end
end

for k, v in pairs(params) do
    containers.params[k] = v

    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
params = nil


local function deepval(fn, name, member, depth)
    depth = depth or 20
    local i = 1
    while true do
        local n, v = GLOBAL.debug.getupvalue(fn, i)
        if v == nil then
            return
        elseif n == name and (not member or v[member]) then
            return v
        elseif type(v) == "function" and depth > 0 then
            local temp = deepval(v, name, member, depth - 1)
            if temp then return temp end
        end
        i = i + 1
    end
end

local params
if containers.smartercrockpot_old_widgetsetup then
    params = deepval(containers.smartercrockpot_old_widgetsetup, "params", "icepack")
else
    params = deepval(containers.widgetsetup, "params", "icepack")
end



local smelter =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, -135, 0),
            Vector3(0, -60, 0),
            Vector3(0, 15, 0),
            Vector3(0, 90, 0),

        },

        animbank = "ui_cookpot_1x4",
        animbuild = "ui_cookpot_1x4",
        bgimage = nil,
        bgatlas = nil,
        pos = Vector3(80, 80, 0),
        --	isboat = true,
    },
    issidewidget = false,
    type = "cookpot",
}

local corkchest =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, -135, 0),
            Vector3(0, -60, 0),
            Vector3(0, 15, 0),
            Vector3(0, 90, 0),

        },

        animbank = "ui_cookpot_1x4",
        animbuild = "ui_cookpot_1x4",
        bgimage = nil,
        bgatlas = nil,
        pos = Vector3(80, 80, 0),
        --	isboat = true,
    },
    issidewidget = false,
    type = "cookpot",
}

local thatchpack =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, -135, 0),
            Vector3(0, -60, 0),
            Vector3(0, 15, 0),
            Vector3(0, 90, 0),

        },

        animbank = "ui_cookpot_1x4",
        animbuild = "ui_cookpot_1x4",
        bgimage = nil,
        bgatlas = nil,
        pos = Vector3(-60, -60, 0),
        --	isboat = true,
    },
    issidewidget = true,
    type = "cookpot",
}

local cargoboatslot =
{
    widget =
    {
        slotpos =
        {
            Vector3(-80, 45, 0),
            Vector3(-155, 45, 0),
            Vector3(-250, 45, 0),
            Vector3(-330, 45, 0),
            Vector3(-410, 45, 0),
            Vector3(-490, 45, 0),
            Vector3(-570, 45, 0),
            Vector3(-650, 45, 0),
        },

        slotbg =
        {
            -- for 1st slot
            {
                atlas = "images/barco.xml",
                texture = "barco.tex",
            },
            -- for 2nd
            {
                atlas = "images/barco.xml",
                texture = "luz.tex",
            },
            -- and so on
        },

        animbank = "boat_hud_cargo",
        animbuild = "boat_hud_cargo",
        bgimage = nil,
        bgatlas = nil,
        pos = Vector3(440, 80 --[[+ GetModConfigData("boatlefthud")]], 0),
        isboat = true,
    },
    issidewidget = false,
    type = "chest",
}

local rowboatslot =
{
    widget =
    {
        slotpos =
        {
            Vector3(-80, 45, 0),
            Vector3(-155, 45, 0),
            --    Vector3(65, 45, 0),

        },

        slotbg =
        {
            -- for 1st slot
            {
                atlas = "images/barco.xml",
                texture = "barco.tex",
            },
            -- for 2nd
            {
                atlas = "images/barco.xml",
                texture = "luz.tex",
            },
            -- and so on
        },

        animbank = "boat_hud_row",
        animbuild = "boat_hud_row",
        bgimage = nil,
        bgatlas = nil,
        pos = Vector3(440, 80 --[[+ GetModConfigData("boatlefthud")]], 0),
        isboat = true,
    },
    issidewidget = false,
    type = "chest",
}

local pirateslot =
{
    widget =
    {
        slotpos =
        {
            Vector3(-80, 45, 0),
            Vector3(-155, 45, 0),
            Vector3(-300, 45, 0),

        },

        slotbg =
        {
            -- for 1st slot
            {
                atlas = "images/barco.xml",
                texture = "barco.tex",
            },
            -- for 2nd
            {
                atlas = "images/barco.xml",
                texture = "luz.tex",
            },
            -- and so on
        },

        animbank = "boat_hud_encrusted",
        animbuild = "boat_hud_encrusted",
        bgimage = nil,
        bgatlas = nil,
        pos = Vector3(440, 80 --[[+ GetModConfigData("boatlefthud")]], 0),
        isboat = true,
    },
    issidewidget = false,
    type = "chest",
}

local encrustedslot =
{
    widget =
    {
        slotpos =
        {
            Vector3(-80, 45, 0),
            Vector3(-155, 45, 0),
            Vector3(-250, 45, 0),
            Vector3(-330, 45, 0),

        },

        slotbg =
        {
            -- for 1st slot
            {
                atlas = "images/barco.xml",
                texture = "barco.tex",
            },
            -- for 2nd
            {
                atlas = "images/barco.xml",
                texture = "luz.tex",
            },
            -- and so on
        },

        animbank = "boat_hud_encrusted",
        animbuild = "boat_hud_encrusted",
        bgimage = nil,
        bgatlas = nil,
        pos = Vector3(440, 80 --[[+ GetModConfigData("boatlefthud")]], 0),
        isboat = true,
    },
    issidewidget = false,
    type = "chest",
}

local raftslot =
{
    widget =
    {
        slotpos =
        {
            --    Vector3(-80, 45, 0),

        },

        animbank = "boat_hud_raft",
        animbuild = "boat_hud_raft",
        bgimage = nil,
        bgatlas = nil,
        pos = Vector3(440, 80 --[[+ GetModConfigData("boatlefthud")]], 0),
        isboat = true,
    },
    issidewidget = false,
    type = "chest",
}

local trawlnetdroppedslot =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, -75, 0),
            Vector3(-75, -75, 0),
            Vector3(75, -75, 0),
            Vector3(0, 75, 0),
            Vector3(-75, 75, 0),
            Vector3(75, 75, 0),
            Vector3(0, 0, 0),
            Vector3(-75, 0, 0),
            Vector3(75, 0, 0),
        },


        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        bgimage = nil,
        bgatlas = nil,
        pos = Vector3(0, 200, 0)
    },
    issidewidget = false,
    type = "chest",
}

params["cargoboat"] = cargoboatslot
params["encrustedboat"] = encrustedslot
params["rowboat"] = rowboatslot
params["armouredboat"] = rowboatslot
params["raft_old"] = raftslot
params["lograft_old"] = raftslot
params["woodlegsboat"] = pirateslot
params["surfboard"] = raftslot
params["trawlnetdropped"] = trawlnetdroppedslot
params["corkboat"] = rowboatslot
params["smelter"] = smelter
params["corkchest"] = corkchest
params["thatchpack"] = thatchpack

function params.thatchpack.itemtestfn(container, item, slot)
    if slot == 1 then
        return true
    elseif slot == 2 then
        return true
    elseif slot == 3 then
        return true
    elseif slot == 4 then
        return true
    else
        return false
    end
end

function params.corkchest.itemtestfn(container, item, slot)
    if slot == 1 then
        return true
    elseif slot == 2 then
        return true
    elseif slot == 3 then
        return true
    elseif slot == 4 then
        return true
    else
        return false
    end
end

function params.smelter.itemtestfn(container, item, slot)
    -- if slot == 1 and (item:HasTag("iron") or item.prefab == "iron" or item.prefab == "goldnugget" or item.prefab == "gold_dust" or item.prefab == "flint" or item.prefab == "nitre" or item.prefab == "dubloon" or item.prefab == "obsidian" or item.prefab == "magnifying_glass" or item.prefab == "goldpan" or item.prefab == "ballpein_hammer" or item.prefab == "shears" or item.prefab == "candlehat") then
    --     return true
    -- elseif slot == 2 and (item:HasTag("iron") or item.prefab == "iron" or item.prefab == "goldnugget" or item.prefab == "gold_dust" or item.prefab == "flint" or item.prefab == "nitre" or item.prefab == "dubloon" or item.prefab == "obsidian" or item.prefab == "magnifying_glass" or item.prefab == "goldpan" or item.prefab == "ballpein_hammer" or item.prefab == "shears" or item.prefab == "candlehat") then
    --     return true
    -- elseif slot == 3 and (item:HasTag("iron") or item.prefab == "iron" or item.prefab == "goldnugget" or item.prefab == "gold_dust" or item.prefab == "flint" or item.prefab == "nitre" or item.prefab == "dubloon" or item.prefab == "obsidian" or item.prefab == "magnifying_glass" or item.prefab == "goldpan" or item.prefab == "ballpein_hammer" or item.prefab == "shears" or item.prefab == "candlehat") then
    --     return true
    -- elseif slot == 4 and (item:HasTag("iron") or item.prefab == "iron" or item.prefab == "goldnugget" or item.prefab == "gold_dust" or item.prefab == "flint" or item.prefab == "nitre" or item.prefab == "dubloon" or item.prefab == "obsidian" or item.prefab == "magnifying_glass" or item.prefab == "goldpan" or item.prefab == "ballpein_hammer" or item.prefab == "shears" or item.prefab == "candlehat") then
    --     return true
    -- else
    --     return false
    -- end
    return true
end

function params.cargoboat.itemtestfn(container, item, slot)
    if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
        return true
    elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
        return true
    elseif slot == 3 then
        return true
    elseif slot == 4 then
        return true
    elseif slot == 5 then
        return true
    elseif slot == 6 then
        return true
    elseif slot == 7 then
        return true
    elseif slot == 8 then
        return true
    else
        return false
    end
end

function params.encrustedboat.itemtestfn(container, item, slot)
    if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
        return true
    elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
        return true
    elseif slot == 3 then
        return true
    elseif slot == 4 then
        return true
    else
        return false
    end
end

function params.rowboat.itemtestfn(container, item, slot)
    if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
        return true
    elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
        return true
    else
        return false
    end
end

function params.armouredboat.itemtestfn(container, item, slot)
    if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
        return true
    elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
        return true
    else
        return false
    end
end

function params.raft_old.itemtestfn(container, item, slot)
    if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
        return true
    elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
        return true
    else
        return false
    end
end

function params.raft_old.itemtestfn(container, item, slot)
    if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
        return true
    elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
        return true
    else
        return false
    end
end

function params.lograft_old.itemtestfn(container, item, slot)
    if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
        return true
    elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
        return true
    else
        return false
    end
end

function params.woodlegsboat.itemtestfn(container, item, slot)
    if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
        return true
    elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
        return true
    elseif slot == 3 then
        return true
    else
        return false
    end
end

function params.surfboard.itemtestfn(container, item, slot)
    if slot == 1 and (item:HasTag("sail") or item.prefab == "trawlnet") then
        return true
    elseif slot == 2 and (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab == "woodlegs_boatcannon") then
        return true
    else
        return false
    end
end

function params.trawlnetdropped.itemtestfn(container, item, slot)
    return true
end
