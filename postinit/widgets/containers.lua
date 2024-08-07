local containers = require("containers")

local params = containers.params

params.armorvortexcloak = {
    widget = {
        slotpos = {},
        animbank = "ui_krampusbag_2x5",
        animbuild = "ui_krampusbag_2x5",
        bgimage = nil,
        bgatlas = nil,
        pos = Vector3(-5, -60, 0)
    },
    issidewidget = true,
    type = "pack",
    openlimit = 1
}
for y = 0, 4 do
    for x = 0, 1 do
        table.insert(params.armorvortexcloak.widget.slotpos, Vector3(75 * x - 162, 75 * y - 186, 0))
    end
end

local antchest_preservation = {"honey", "royal_jelly", "nectar_pod", "pollen_item"}
local function antchestitemtestfn(container, item, slot)
    for _, v in ipairs(antchest_preservation) do
        if item.prefab == v then
            return true
        end
    end
    return false
end
params.antchest = deepcopy(params.icebox)
params.antchest.itemtestfn = antchestitemtestfn

local hcpos = {
    x = 0,
    y = 0,
    r = 87,
    angle = 4
} -- 中心坐标 [x, y] | 半径 r | 起始角 angle(pi / 3 rad)
local hcbg = {
    image = "honeychest_slot.tex",
    atlas = resolvefilepath("images/ui/honeychest.xml")
}
params.honeychest = {
    widget = {
        slotpos = {Vector3(hcpos.x, hcpos.y + hcpos.r, 0)},
        slotbg = {hcbg},
        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        bgimage = "honeychest.tex",
        bgatlas = "images/ui/honeychest.xml",
        pos = Vector3(hcpos.x, hcpos.y + 200, 0),
        side_align_tip = 300 - hcpos.r
        -- bottom_align_tip = 0,
    },
    type = "chest",
    openlimit = 1,
    itemtestfn = antchestitemtestfn
}
for line = 1, 0, -1 do
    for rad = hcpos.angle, hcpos.angle - 2, -1 do
        table.insert(params.honeychest.widget.slotpos, Vector3(hcpos.x + hcpos.r * math.sin(rad * math.pi / 3),
            hcpos.y + hcpos.r * line + hcpos.r * math.cos(rad * math.pi / 3), 0))
        table.insert(params.honeychest.widget.slotbg, hcbg)
    end
end

params.corkchest = {
    widget = {
        slotpos = {},
        animbank = "ui_cookpot_1x4",
        animbuild = "ui_cookpot_1x4",
        pos = Vector3(80, 80, 0)
    },
    type = "cookpot"
}
for i = 3, 0, -1 do
    table.insert(params.corkchest.widget.slotpos, Vector3(0, 75 * i - 135, 0))
end

params.smelter = deepcopy(params.corkchest)
params.smelter.acceptsstacks = false
local melting = require("melting")
function params.smelter.itemtestfn(container, item, slot)
    return melting.isAttribute(item.prefab)
end

params.thatchpack = deepcopy(params.corkchest)
params.thatchpack.issidewidget = true

local function boatitemtestfn(container, item, slot)
    if slot then
        if slot == 1 and not container:GetItemInSlot(slot) then
            return (item:HasTag("sail") or item.prefab == "trawlnet") or false
        elseif slot == 2 and not container:GetItemInSlot(slot) then
            return (item.prefab == "tarlamp" or item.prefab == "boat_lantern" or item.prefab == "boat_torch" or
                       item.prefab == "quackeringram" or item.prefab == "boatcannon" or item.prefab ==
                       "woodlegs_boatcannon") or false
        else
            local slotitem = container:GetItemInSlot(slot)
            if slotitem then
                if slotitem.prefab == item.prefab then
                    return slotitem.components.stackable and not slotitem.components.stackable:IsFull() or false
                else
                    return false
                end
            else
                return true
            end
        end
    else
        return true
    end
end
params.cargoboat = {
    widget = {
        slotpos = {Vector3(-80, 45, 0), Vector3(-155, 45, 0), Vector3(-250, 45, 0), Vector3(-330, 45, 0),
                   Vector3(-410, 45, 0), Vector3(-490, 45, 0), Vector3(-570, 45, 0), Vector3(-650, 45, 0)},
        slotbg = {{
            atlas = "images/barco.xml",
            texture = "barco.tex"
        }, {
            atlas = "images/barco.xml",
            texture = "luz.tex"
        }},
        animbank = "boat_hud_cargo",
        animbuild = "boat_hud_cargo",
        pos = Vector3(440, 80 --[[+ GetModConfigData("boatlefthud")]] , 0),
        isboat = true
    },
    usespecificslotsforitems = true,
    type = "chest",
    itemtestfn = boatitemtestfn
}

params.rowboat = {
    widget = {
        slotpos = {Vector3(-80, 45, 0), Vector3(-155, 45, 0)},

        slotbg = {{
            atlas = "images/barco.xml",
            texture = "barco.tex"
        }, {
            atlas = "images/barco.xml",
            texture = "luz.tex"
        }},

        animbank = "boat_hud_row",
        animbuild = "boat_hud_row",
        pos = Vector3(440, 80 --[[+ GetModConfigData("boatlefthud")]] , 0),
        isboat = true
    },
    usespecificslotsforitems = true,
    type = "chest",
    itemtestfn = boatitemtestfn
}

params.armouredboat = params.rowboat

params.corkboat = params.rowboat

params.woodlegsboat = {
    widget = {
        slotpos = {Vector3(-80, 45, 0), Vector3(-155, 45, 0), Vector3(-300, 45, 0)},
        slotbg = {{
            atlas = "images/barco.xml",
            texture = "barco.tex"
        }, {
            atlas = "images/barco.xml",
            texture = "luz.tex"
        }},
        animbank = "boat_hud_encrusted",
        animbuild = "boat_hud_encrusted",
        pos = Vector3(440, 80 --[[+ GetModConfigData("boatlefthud")]] , 0),
        isboat = true
    },
    usespecificslotsforitems = true,
    type = "chest",
    itemtestfn = boatitemtestfn
}

params.encrustedboat = {
    widget = {
        slotpos = {Vector3(-80, 45, 0), Vector3(-155, 45, 0), Vector3(-250, 45, 0), Vector3(-330, 45, 0)},
        slotbg = {{
            atlas = "images/barco.xml",
            texture = "barco.tex"
        }, {
            atlas = "images/barco.xml",
            texture = "luz.tex"
        }},
        animbank = "boat_hud_encrusted",
        animbuild = "boat_hud_encrusted",
        pos = Vector3(440, 80 --[[+ GetModConfigData("boatlefthud")]] , 0),
        isboat = true
    },
    usespecificslotsforitems = true,
    type = "chest",
    itemtestfn = boatitemtestfn
}

params.raft_old = {
    widget = {
        slotpos = {},
        animbank = "boat_hud_raft",
        animbuild = "boat_hud_raft",
        pos = Vector3(440, 80 --[[+ GetModConfigData("boatlefthud")]] , 0),
        isboat = true
    },
    usespecificslotsforitems = true,
    type = "chest",
    itemtestfn = boatitemtestfn
}

params.lograft_old = params.raft_old

params.surfboard = params.raft_old

params.trawlnetdropped = params.treasurechest

for _, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
