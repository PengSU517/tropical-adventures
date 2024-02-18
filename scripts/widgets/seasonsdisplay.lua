local function Badge_display(self)
    local LeafBadge = GLOBAL.require "widgets/leafbadge" -----------巨树的树荫
    self.leaf = self:AddChild(LeafBadge(self.owner))
    self.owner.leafbadge = self.leaf
    self.leaf:SetPosition(0, 0, 0)
    self.leaf:MoveToBack()

    if TUNING.tropical.hayfever then
        local HayfeverBadge = GLOBAL.require "widgets/hayfeverbadge"
        self.hayfever = self:AddChild(HayfeverBadge(self.owner))
        self.owner.hayfeverbadge = self.hayfever
        self.hayfever:SetPosition(0, 0, 0)
        self.hayfever:MoveToBack()
    end



    if TUNING.tropical.fog then
        local FogBadge = GLOBAL.require "widgets/fogbadge"
        self.fog = self:AddChild(FogBadge(self.owner))
        self.owner.fogbadge = self.fog
        self.fog:SetPosition(0, 0, 0)
        self.fog:MoveToBack()
    end
end

AddClassPostConstruct("widgets/controls", Badge_display)
