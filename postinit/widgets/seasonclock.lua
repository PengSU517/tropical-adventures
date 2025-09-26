if TheNet:IsDedicated() then return end

local dirs = { "widgets/seasonclock", "widgets/cb/seasonclock" }

local state, SeasonClock, dir
for i = 1, #dirs do
    state, SeasonClock = pcall(require, dirs[i])
    if state then
        dir = dirs[i]
        print("Loaded SeasonClock from " .. dir)
        break
    end
end

if not state then return end


local COLOUR_ROG =
{
    AUTUMN = Vector3(205 / 255, 79 / 255, 57 / 255),
    WINTER = Vector3(149 / 255, 191 / 255, 242 / 255),
    SPRING = Vector3(84 / 168, 200 / 255, 84 / 255),
    SUMMER = Vector3(205 / 255, 133 / 255, 0 / 255),
}

local COLOUR_SW =
{
    AUTUMN = Vector3(255 / 255, 206 / 255, 139 / 255),
    WINTER = Vector3(200 / 255, 220 / 255, 255 / 255),
    SPRING = Vector3(0 / 255, 150 / 255, 150 / 255),
    SUMMER = Vector3(180 / 255, 80 / 255, 57 / 255),
}

local COLOUR_HAM =
{
    AUTUMN = Vector3(255 / 255, 226 / 255, 139 / 255),
    WINTER = Vector3(220 / 255, 220 / 255, 255 / 255),
    SPRING = Vector3(104 / 168, 200 / 255, 80 / 255),
    SUMMER = Vector3(60 / 168, 179 / 255, 113 / 255),
}

local COLOUR_VOLCANO =
{
    AUTUMN = Vector3(180 / 255, 80 / 255, 57 / 255),
    WINTER = Vector3(238 / 255, 121 / 255, 66 / 255),
    SPRING = Vector3(180 / 255, 80 / 255, 57 / 255),
    SUMMER = Vector3(100 / 255, 80 / 255, 57 / 255),
}


local seasonmap = {
    rog = {
        autumn = "autumn",
        winter = "winter",
        spring = "spring",
        summer = "summer",
    },
    sw = {
        autumn = "mild",
        winter = "wet",
        spring = "green",
        summer = "dry",
    },
    ham = {
        autumn = "temperate",
        winter = "humid",
        spring = "lush",
        summer = "lush",
    },
}

AddClassPostConstruct(dir, function(self)
    local COLOURS = upvaluehelper.Get(self.OnSeasonLengthsChanged, "COLOURS")

    function self:ChangeRegion()
        if ThePlayer and TheWorld then
            if ThePlayer:AwareInVolcanoArea() then
                tableutil.deep_merge(COLOURS, COLOUR_VOLCANO, true)
            elseif ThePlayer:AwareInShipwreckedArea() then
                tableutil.deep_merge(COLOURS, COLOUR_SW, true)
            elseif ThePlayer:AwareInHamletArea() then
                tableutil.deep_merge(COLOURS, COLOUR_HAM, true)
            else
                tableutil.deep_merge(COLOURS, COLOUR_ROG, true)
                -- STRINGS.UI.SERVERLISTINGSCREEN.SEASONS = seasonmap.rog  ----这样的话没法转换成中文
            end
            self:OnCyclesChanged()
            self:OnSeasonLengthsChanged()

            ---需要给大陆加forest标签并调整regionaware----这个再说
            -- if TheWorld.state.isnight then
            --     self._phase = "dusk"
            --     self:OnPhaseChanged("night")
            -- elseif TheWorld.state.isdusk then
            --     self._phase = "day"
            --     self:OnPhaseChanged("dusk")
            -- else
            --     self._phase = "night"
            --     self:OnPhaseChanged("day")
            -- end
        end
    end

    self:ChangeRegion()

    -- ThePlayer:ListenForEvent("changearea", function(inst, data)
    ThePlayer:ListenForEvent("regionchange_client", function(inst, data)
        self:ChangeRegion()
    end)

    local GetSeasonString = self.GetSeasonString
    function self:GetSeasonString()
        local str = GetSeasonString(self)
        -- print("SEASON", str)
        if ThePlayer and TheWorld then
            local season = TheWorld.state.season
            if ThePlayer:AwareInShipwreckedArea() or ThePlayer:AwareInVolcanoArea() then ----每次要判断两次位置，有点无语
                str = STRINGS.UI.SANDBOXMENU[string.upper(seasonmap.sw[season])] or str
            elseif ThePlayer:AwareInHamletArea() then
                str = STRINGS.UI.SANDBOXMENU[string.upper(seasonmap.ham[season])] or str
            end
        end
        -- print("SEASON", str)
        return str
    end
end)
