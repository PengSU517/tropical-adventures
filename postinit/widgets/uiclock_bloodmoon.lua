------------------------------------bloodmoon ----------------------------------------------

-- if GLOBAL.TUNING.aporkalypse == true then
--     local function bloodmoon(self)
--         local luavermelha = GLOBAL.require "widgets/bloodmoon"
--         self.luadesangue = self:AddChild(luavermelha(self.owner))
--         --	local badge_brain = self.brain:GetPosition()
--         local AlwaysOnStatus = false
--         for k, v in ipairs(GLOBAL.KnownModIndex:GetModsToLoad()) do
--             local Mod = GLOBAL.KnownModIndex:GetModInfo(v).name
--             if Mod == "Combined Status" then
--                 AlwaysOnStatus = true
--             end
--         end
--         if AlwaysOnStatus then
--             self.luadesangue:SetPosition(0, 0, 0)
--         else
--             self.luadesangue:SetPosition(0, 0, 0)
--         end
--     end

--     AddClassPostConstruct("widgets/uiclock", bloodmoon)
-- end

------------------------------------coofee badge ----------------------------------------------

local function bloodmoon(self)
    if not TheWorld:HasTag("cave") then
        local luavermelha = require("widgets/bloodmoon")
        self.luadesangue = self:AddChild(luavermelha(self.owner))
        self.luadesangue:SetPosition(0, 0, 0)
        self.luadesangue.owner = ThePlayer or nil
    end
end
AddClassPostConstruct("widgets/uiclock", bloodmoon)
