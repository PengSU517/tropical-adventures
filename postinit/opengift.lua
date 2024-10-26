local mygift = GLOBAL.require("widgets/mygift")
local function Addgift(self)
	self.gift = self:AddChild(mygift())
	self.gift:SetHAnchor(1)
	self.gift:SetVAnchor(1)
	local old_OnUpdate = self.OnUpdate
	self.OnUpdate = function(self, dt) --(self.inst.components.age:GetAge()or 0)
		old_OnUpdate(self, dt)
		if self.owner:HasTag("God") then
			self.owner.state = "god"
		end
		if self.owner:HasTag("Gift1") then
			self.owner.gift_count = 1
		elseif self.owner:HasTag("Gift2") then
			self.owner.gift_count = 2
		elseif self.owner:HasTag("Gift3") then
			self.owner.gift_count = 3
		elseif self.owner:HasTag("Gift4") then
			self.owner.gift_count = 4
		end
		self.owner.amount = self.owner.amount or 0
		if self.owner:HasTag("Gift1") and not self.owner:HasTag("Gift2") and self.owner.amount == 0 then
			self.owner.gift_time = GLOBAL.os.date("%X", GLOBAL.os.time())
			self.owner.amount = 1
		elseif self.owner:HasTag("Gift2") and not self.owner:HasTag("Gift3") and self.owner.amount == 1 then
			self.owner.gift_time = ((self.owner.gift_time or " ") .. " " .. GLOBAL.os.date("%X", GLOBAL.os.time()))
			self.owner.amount = 2
		elseif self.owner:HasTag("Gift3") and not self.owner:HasTag("Gift4") and self.owner.amount == 2
		then
			self.owner.gift_time = ((self.owner.gift_time or " ") .. " " .. GLOBAL.os.date("%X", GLOBAL.os.time()))
			self.owner.amount = 3
		elseif self.owner:HasTag("Gift4") and not self.owner:HasTag("Gift5") and self.owner.amount == 3
		then
			self.owner.gift_time = ((self.owner.gift_time or " ") .. " " .. GLOBAL.os.date("%X", GLOBAL.os.time()))
			self.owner.amount = 4
		end

		self.gift:SetString("numbers of my gift(礼物数):" ..
			(self.owner.gift_count or 0) ..
			"\n state(状态):" ..
			(self.owner.state or "not god") ..
			"\ntime(获得礼物时刻):" ..
			(self.owner.gift_time or " ") .. "\ngift's name(获得的礼物名称):" .. (self.owner.giftname or " "))
	end
end
AddPlayerPostInit(function(inst)
	inst.giftcount = inst.giftcount or 0
	--inst.giftname=" "
	inst:ListenForEvent("death", function(inst)
		inst:DoTaskInTime(2, function(inst)
			inst:PushEvent("respawnfromghost")
		end)
	end)
	inst:DoPeriodicTask(8, function()
		local gift_count = GLOBAL.TheInventory:GetClientGiftCount(inst.userid)
		if gift_count > 0 then
			inst:PushEvent("ms_opengift")
			inst:RemoveTag("Gift" .. inst.giftcount)
			inst.giftcount = inst.giftcount + 1
			inst:AddTag("Gift" .. inst.giftcount)
			--print("获得礼物")
		else
			--print("监测到没有礼物")
		end

		-- if inst.components.health ~= nil and not inst.components.health.invincible then
		-- 	inst.components.health:SetInvincible(true)
		-- 	inst.components.talker:Say("Dear lord！")
		-- 	inst.components.health:SetPercent(1)
		-- 	inst.components.hunger:SetPercent(1)
		-- 	inst.components.sanity:SetPercent(1)
		-- 	inst.components.temperature:SetTemperature(25)
		-- 	inst.components.moisture:SetPercent(0)
		-- 	inst:AddTag("God")
		-- end
	end)
	--	inst:DoTaskInTime(10, function()
	--	GLOBAL.TheFrontEnd:PopScreen()
	--end)
end)

AddClassPostConstruct("widgets/inventorybar", Addgift)

local Menu = GLOBAL.require "widgets/menu"

AddClassPostConstruct("screens/giftitempopup", function(self)
	function self:ShowMenu()
		self.show_menu = true

		if not GLOBAL.TheInput:ControllerAttached() then
			--creates the buttons
			local button_w = 200
			local space_between = 40
			local spacing = button_w + space_between
			local buttons = { { text = GLOBAL.STRINGS.UI.ITEM_SCREEN.USE_LATER, cb = function() self:OnClose() end },
				{ text = GLOBAL.STRINGS.UI.ITEM_SCREEN.USE_NOW,   cb = function() self:ApplySkin() end }
			}
			self.menu = self.proot:AddChild(Menu(buttons, spacing, true))
			self.menu:SetPosition(25 - (spacing * (#buttons - 1)) / 2, -290, 0)
			self.menu:SetScale(0.8)
			self.menu:Show()
			self.menu:SetFocus()

			if self.disable_use_now then
				self.menu:DisableItem(2)
			end
			self.owner.giftname = self.owner.giftname or " "
			self.inst:DoTaskInTime(1, function()
				self:OnClose()
				local item_name = self.item_types[1]
				if item_name ~= nil then
					--print("获得礼物名称1")
					item_name = string.gsub(item_name, "swap_", "")
					name_string = GLOBAL.GetSkinName(item_name)
					if name_string ~= nil then
						--print("获得礼物名称2")
						self.owner.giftname = (self.owner.giftname .. " " .. name_string)
					end
				end --]]
			end)

			self.default_focus = self.menu
		end
	end
end)
local function IsNearDanger(inst)
	return false
end
local function ForceStopHeavyLifting(inst)
	if inst.components.inventory:IsHeavyLifting() then
		inst.components.inventory:DropItem(
			inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.BODY),
			true,
			true
		)
	end
end
AddStategraphPostInit("wilson", function(sg)
	sg.states["opengift"].onenter = function(inst)
		inst.components.locomotor:Stop()
		inst.components.locomotor:Clear()
		inst:ClearBufferedAction()

		local failstr =
			(IsNearDanger(inst) and "ANNOUNCE_NODANGERGIFT") or
			(inst.components.rider:IsRiding() and "ANNOUNCE_NOMOUNTEDGIFT") or
			nil

		if failstr ~= nil then
			inst.sg.statemem.isfailed = true
			inst.sg:GoToState("idle")
			if inst.components.talker ~= nil then
				inst.components.talker:Say(GLOBAL.GetString(inst, failstr))
			end
			return
		end
		ForceStopHeavyLifting(inst)


		inst.SoundEmitter:PlaySound("dontstarve/common/player_receives_gift")
		inst.AnimState:PlayAnimation("gift_pre")
		inst.AnimState:PushAnimation("giift_loop", true)
		-- NOTE: the previously used ripping paper anim is called "giift_loop"

		if inst.components.playercontroller ~= nil then
			inst.components.playercontroller:RemotePausePrediction()
			inst.components.playercontroller:EnableMapControls(false)
			inst.components.playercontroller:Enable(false)
		end
		inst.components.inventory:Hide()
		inst:PushEvent("ms_closepopups")
		inst:ShowActions(false)
		inst:ShowPopUp(GLOBAL.POPUPS.GIFTITEM, true)

		if inst.components.giftreceiver ~= nil then
			inst.components.giftreceiver:OnStartOpenGift()
		end
	end
end)

AddModRPCHandler("wilson", "dadada", function(player)
	if not player:HasTag("playerghost") then
		local currentscale = player.Transform:GetScale()
		player.Transform:SetScale(math.min(currentscale + 0.1, 5), math.min(currentscale + 0.1, 5),
			math.min(currentscale + 0.1, 5))
		player.components.locomotor.walkspeed = (7 - currentscale)
		player.components.locomotor.runspeed = (5 - currentscale)
	end
end)

AddModRPCHandler("wilson", "xixixi", function(player)
	if not player:HasTag("playerghost") then
		local currentscale = player.Transform:GetScale()
		player.Transform:SetScale(math.max(currentscale - 0.1, 0.2), math.max(currentscale - 0.1, 0.2),
			math.max(currentscale - 0.1, 0.2))
		player.components.locomotor.walkspeed = (7 - currentscale)
		player.components.locomotor.runspeed = (5 - currentscale)
	end
end)

AddModRPCHandler("wilson", "restart", function(player)
	if not player:HasTag("playerghost") then
		if player.components.age and player.components.age:GetAge() >= 480 then
			GLOBAL.TheWorld:PushEvent("ms_playerdespawnanddelete", player)
		elseif player.components.talker and player.components.age then
			player.components.talker:Say("需要" .. math.ceil(480 - player.components.age:GetAge()) .. "秒冷却")
		end
	end
end)


local handlers = {}

AddPlayerPostInit(function(inst)
	inst:DoTaskInTime(0.1, function()
		if inst == GLOBAL.ThePlayer then
			handlers[122] = GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_Z, function()
				SendModRPCToServer(MOD_RPC["wilson"]["dadada"])
			end)
			handlers[120] = GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_X, function()
				SendModRPCToServer(MOD_RPC["wilson"]["xixixi"])
			end)
			handlers[285] = GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_F4, function()
				SendModRPCToServer(MOD_RPC["wilson"]["restart"])
			end)
		else
			for k, v in pairs(handlers) do
				handlers[k] = nil
			end
		end
	end)
end)

--[[local function choose_skin()
		local topscreen=GLOBAL.TheFrontEnd:GetActiveScreen()
			if topscreen and topscreen.name~="choose_skin" and GLOBAL.TheFrontEnd:GetScreenStackSize()<=1 then
				local choose_skin=GLOBAL.require("screens/choose_skin")
				GLOBAL.TheFrontEnd:PushScreen(choose_skin(GLOBAL.ThePlayer))
				print("输出1111111")
			else
				print("输出2222")
			end
	end


local function Addchoose(self)
	local TextButton =GLOBAL.require("widgets/textbutton")
	self.choose_skin=self:AddChild(TextButton("images/ui.xml","blank.tex","blank.tex","blank.tex","blank.tex"))
	--self.choose_skin:SetVRegPoint(ANCHOR_MIDDLE)
	--self.choose_skin:SetHRegPoint(ANCHOR_MIDDLE)

	self.choose_skin:SetHAnchor(0)
    self.choose_skin:SetVAnchor(0)
	self.choose_skin:SetOnClick(choose_skin)
	self.choose_skin:SetText("选择皮肤")
end
	AddClassPostConstruct("widgets/controls", Addchoose)--]]
local character = ""
local acter_tab = { "wilson", "willow", "wolfgang", "wendy", "wx78", "wickerbottom", "woodie", "wes", "waxwell",
	"wathgrithr", "webber", "winona" }
local baby = { "face", "hair", "hairpigtails", "headbase", "torso" }
if GLOBAL.TheNet:GetIsServer() then
	local function choose_skin0(inst, num)
		character = acter_tab[num]
	end

	AddModRPCHandler("choose_skin0", "choose_skin0", choose_skin0)
	local function choose_skin1(inst, num)
		if character ~= "" then
			inst.AnimState:OverrideSymbol(baby[num], character, baby[num])
		end
	end

	AddModRPCHandler("choose_skin1", "choose_skin1", choose_skin1)
else
	AddModRPCHandler("choose_skin0", "choose_skin0", function() end)
	AddModRPCHandler("choose_skin1", "choose_skin1", function() end)
end


GLOBAL.TheInput:AddKeyUpHandler(GLOBAL.KEY_C,
	function()
		local topscreen = GLOBAL.TheFrontEnd:GetActiveScreen()
		if topscreen and topscreen.name ~= "choose_skin" and GLOBAL.TheFrontEnd:GetScreenStackSize() <= 1 then
			local choose_skin = GLOBAL.require("screens/choose_skin")
			GLOBAL.TheFrontEnd:PushScreen(choose_skin(GLOBAL.ThePlayer))
		end
	end) --]]

AddPrefabPostInit("multiplayer_portal", function(inst)
	inst:AddComponent("wardrobe")
end)
