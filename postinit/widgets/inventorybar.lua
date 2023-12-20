--[[
AddClassPostConstruct("widgets/inventorybar", function(self)

	local OldRefresh = self.Refresh
    local OldRebuild = self.Rebuild

    function self:ScaleInv()
		slot_num = #self.equipslotinfo
		if not (TheInput:ControllerAttached() or GLOBAL.GetGameModeProperty("no_avatar_popup")) then
			slot_num = slot_num + 1
		end
		local inv_scale = 0.98 + 0.06 * slot_num
		self.bg:SetScale(inv_scale,1,1)
		self.bgcover:SetScale(inv_scale,1,1)
    end

    function self:Refresh()
        self:ScaleInv()
        OldRefresh(self)
    end

    function self:Rebuild()
        self:ScaleInv()
        OldRebuild(self)
    end
	
end)
]]
