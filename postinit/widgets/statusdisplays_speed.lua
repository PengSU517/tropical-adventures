local function speedicon(self)
    local iconedevelocidade = GLOBAL.require "widgets/speedicon"
    self.velocidadeativa = self:AddChild(iconedevelocidade(self.owner))
    self.owner.velocidadeativa = self.velocidadeativa

    -- local badge_brain = self.brain:GetPosition()
    local AlwaysOnStatus = false
    for k, v in ipairs(GLOBAL.KnownModIndex:GetModsToLoad()) do
        local Mod = GLOBAL.KnownModIndex:GetModInfo(v).name
        if Mod == "Combined Status" then
            AlwaysOnStatus = true
        end
    end
    if AlwaysOnStatus then
        self.velocidadeativa:SetPosition(-85, 6, 0)
    else
        self.velocidadeativa:SetPosition(-65.5, -9.5, 0)
    end
end

AddClassPostConstruct("widgets/statusdisplays", speedicon)
