------------------------------------------configura os slots imagem------------------------------------------------------------
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

    local function BoatState(inst, data)
        self.boatbadge:SetPercent(data.percent, boat_health[inst.prefab] or 150)

        if self.boathealth then
            if data.percent > self.boathealth then
                self.boatbadge:PulseGreen()
            elseif data.percent < self.boathealth - 0.015 then
                self.boatbadge:PulseRed()
            end
        end

        self.boathealth = data.percent

        if data.percent <= .25 then
            self.boatbadge:StartWarning()
        else
            self.boatbadge:StopWarning()
        end
    end


    local OldOpen = self.Open
    function self:Open(container, doer)
        OldOpen(self, container, doer)
        local widget = container.replica.container:GetWidget()
        if widget and widget.slotbg and type(widget.slotbg) == "table" and widget.isboat then
            for i, v in ipairs(widget.slotbg) do
                if self.inv[i] then
                    self.inv[i].bgimage:SetTexture(v.atlas, v.texture)
                end
            end
        end
        if widget and widget.isboat then
            self.isboat = true
            self.boatbadge:Show()
            self.inst:ListenForEvent("percentusedchange", BoatState, container)
            if GLOBAL.TheWorld.ismastersim then
                container:PushEvent("percentusedchange",
                    { percent = container.replica.inventoryitem.classified.percentused:value() / 100 })
            else
                container.replica.inventoryitem:DeserializeUsage()
            end
        end
    end

    local OldClose = self.Close
    function self:Close()
        OldClose(self)
        if self.isboat then
            self.inst:RemoveEventCallback("percentusedchange", BoatState, self.contanier)
        end
    end
end)
