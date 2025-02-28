-- Runar: 当前只有在重新上船时才会更新船UI位置，需要实时根据设置或容器开关进行更新可以继续添加逻辑
AddComponentPostInit("container", function(self)
    local old = self.OnUpdate
    self.OnUpdate = function(self, dt)
        if self.widget and self.widget.isboat and self.widget.intergratedbackpack ~= Profile:GetIntegratedBackpack() then
            self.widget.intergratedbackpack = Profile:GetIntegratedBackpack()
            if self.widget.pos then
                self.widget.pos.y = self.widget.pos.y + (self.widget.intergratedbackpack and 40 or -40)
            end
        end
        return old(self, dt)
    end
end)
