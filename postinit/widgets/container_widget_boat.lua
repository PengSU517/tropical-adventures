require "tro_containers"

local boat_health =
{
    cargoboat = 300,
    encrustedboat = 800,
    rowboat = 250,
    armouredboat = 500,
    raft_old = 150,
    lograft_old = 150,
    woodlegsboat = 500,
    surfboard = 100,
}

AddClassPostConstruct("widgets/containerwidget", function(self)
    local BoatBadge = require("widgets/boatbadge")
    self.boatbadge = self:AddChild(BoatBadge(self.owner))
    self.boatbadge:SetPosition(0, 45, 0)
    self.boatbadge:Hide()

    local function CheckBoatState(inst)
        local percent = inst and inst.GetPercentUsed and inst:GetPercentUsed() or 1.

        self.boatbadge:SetPercent(percent, boat_health[inst.prefab] or 150)

        if self.boathealth then
            if percent > self.boathealth then
                self.boatbadge:PulseGreen()
            elseif percent < self.boathealth - 0.015 then
                self.boatbadge:PulseRed()
            end
        end

        self.boathealth = percent

        if percent <= .25 then
            self.boatbadge:StartWarning()
        else
            self.boatbadge:StopWarning()
        end
    end

    local OldOpen = self.Open
    function self:Open(container, doer)
        OldOpen(self, container, doer)
        local widget = container.replica.container:GetWidget()
        if self.boatbadge and widget.badgepos then
            self.boatbadge:SetPosition(widget.badgepos)
        end
        if widget and (widget.isboat or widget.isboatinspect) then
            self.boatbadge:Show()
            self.isboat = not widget.isboatinspect
            self.isboatinspect = widget.isboatinspect
            CheckBoatState(container)
            self.inst:ListenForEvent("boatrow._percentuseddirty", CheckBoatState, container)
            self:UpdatePosition()
        end
        if widget.bgpos then
            self.bganim:SetPosition(widget.bgpos)
        end
    end

    local OldClose = self.Close
    function self:Close()
        OldClose(self)
        self.bganim:SetPosition(0, 0, 0)
        if self.isboat or self.isboatinspect then
            self.boatbadge:Hide()
            self.inst:RemoveEventCallback("boatrow._percentuseddirty", CheckBoatState, self.container)
        end
    end

    function self:GetNextPosition()
        if not self.isboat then
            return self:GetPosition()
        end
        if TUNING.INVSLOT45 then
            return BOATHUDPOSPRESET + Vector3(0, 40, 0)
        elseif Profile:GetIntegratedBackpack() then
            local backpack = self.owner.replica.inventory:GetOverflowContainer()
            if backpack and backpack:IsOpenedBy(self.owner) then
                return BOATHUDPOSPRESET + Vector3(0, 40, 0)
            end
        end
        return BOATHUDPOSPRESET
    end

    function self:UpdatePosition()
        self:CancelMoveTo()
        self:MoveTo(self:GetPosition(), self:GetNextPosition(), .2)
    end

end)
