AddClassPostConstruct("widgets/crafttabs", function(self)
    local numtabs = 0

    for i, v in ipairs(self.tabs.tabs) do
        if not v.collapsed then
            numtabs = numtabs + 1
        end
    end

    if numtabs > 11 then
        self.tabs.spacing = 67

        local scalar = self.tabs.spacing * (1 - numtabs) * .5
        local offset = self.tabs.offset * scalar

        for i, v in ipairs(self.tabs.tabs) do
            if i > 1 and not v.collapsed then
                offset = offset + self.tabs.offset * self.tabs.spacing
            end
            v:SetPosition(offset)
            self.tabs.base_pos[v] = Vector3(offset:Get())
        end

        local scale = 67 * numtabs / 750.0
        self.bg:SetScale(1, scale, 1)
        self.bg_cover:SetScale(1, scale, 1)
    end
end)
