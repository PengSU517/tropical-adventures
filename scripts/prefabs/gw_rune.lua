--modimport "helpfunctions"

local assets =
{
    Asset("ANIM", "anim/runes.zip"),
}

local prefabs = {}

local function GetRuneColour(type)
    local cList = {
        death = {178, 34, 34, 1},
        beast = {107, 142, 35, 1},
        rich = {255, 215, 0, 1},
        sacrifice = {220, 20, 60, 1},
        magic = {0, 51, 154, 1},
    }
    local color = cList[type] ~= nil 
        and {cList[type][1] / 255, cList[type][2]  / 255, cList[type][3]  / 255, cList[type][4]}
        or {1, 0, 0, 1}

    return color
end

local function GFSoftColourChange(inst, fc, sc, time, step)
    if sc == nil then sc = {1, 1, 1, 1} end
    if time == nil then time = 1 end
    if step == nil or step > 1 then step = 0.1 end
    local totalSteps = math.ceil (time / step)
    inst.AnimState:SetMultColour(sc[1], sc[2], sc[3], sc[4])
    local dRed      = (fc[1] - sc[1]) / totalSteps
    local dGreen    = (fc[2] - sc[2]) / totalSteps
    local dBlue     = (fc[3] - sc[3]) / totalSteps
    local dAlpha    = (fc[4] - sc[4]) / totalSteps
    local deltaColor = {dRed, dGreen, dBlue, dAlpha}
    local currStep = 0
    if inst._softColorTask ~= nil then inst._softColorTask:Cancel() end

    inst._softColorTask = inst:DoPeriodicTask(step, function(inst)
        if currStep <= totalSteps then
            --print(time)
            inst.AnimState:SetMultColour(sc[1] + deltaColor[1] * currStep, 
                sc[2] + deltaColor[2] * currStep, 
                sc[3] + deltaColor[3] * currStep, 
                sc[4] + deltaColor[4] * currStep)
            currStep = currStep + 1
        else
            inst._softColorTask:Cancel() 
            inst._atask = nil
        end
    end, nil, deltaColor, totalSteps, currStep)
end

local function ExtinguishRune(inst)
    if inst.owner ~= nil then
        inst.owner:OnRuneDone()
    end
    inst.components.trader:Disable()
    inst.extinguished = true
    inst.active = false
    if inst._dtask ~= nil then 
        inst._dtask:Cancel() 
        inst._dtask = nil 
    end

    local red, green, blue = 1, 0, 0
    GFSoftColourChange(inst, {0.2, 0.2, 0.2, 1}, GetRuneColour(inst.type), 1, 0.1)
    --[[ if inst._atask ~= nil then inst._atask:Cancel() end
    inst._atask = inst:DoPeriodicTask(0.1, function(inst)
        if red >= 0.2 then
            inst.AnimState:SetMultColour(red, green, blue, 1)
            red = red - 0.08
            green = green + 0.02
            blue = blue + 0.02
        else
            inst._atask:Cancel()
            inst._atask = nil
        end
    end, red, green, blue) ]]
end

local function DeactivateRune(inst)
    if inst.extinguished or not inst.active then 
        return 
    end

    if inst._dtask ~= nil then 
        inst._dtask:Cancel() 
        inst._dtask = nil 
    end

    local DeactivateEvents = {
        death = function(inst, doer) 
            inst:RemoveEventCallback("killed", inst.OnEx, inst.doer)
        end,
        sacrifice = function(inst, doer) 
            inst:RemoveEventCallback("damaged", inst.OnEx, inst.doer)
        end,
        beast = function(inst, doer) 
            inst:RemoveEventCallback("oneat", inst.OnEx, inst.doer)
        end,
        rich = function(inst, doer) 
            inst:RemoveEventCallback("runetradeaccept", inst.OnEx, inst.doer)
        end,
        magic = function(inst, doer) 
            inst:RemoveEventCallback("gemaccept", inst.OnEx, inst.doer)
        end,
    }

    inst.active = false
    inst.components.trader:Disable()
    DeactivateEvents[inst.type](inst)
    inst.doer = nil
    GFSoftColourChange(inst, {0, 0, 0, 1}, GetRuneColour(inst.type), 1, 0.1)
    inst:DoTaskInTime(1, function(inst) inst.components.activatable.inactive = true end)
    --[[ local red = 1
    if inst._atask ~= nil then inst._atask:Cancel() end
    inst._atask = inst:DoPeriodicTask(0.1, function(inst)
        if red >= 0 then
            inst.AnimState:SetMultColour(red, 0, 0, 1)
            red = red - 0.1
        else
            inst.components.activatable.inactive = true
            inst._atask:Cancel()
            inst._atask = nil
        end
    end, red) ]]
end

local function ActivateRune(inst, doer)--, red, green, blue, alpha)

    local ActivateEvents = {
        death = function(inst, doer) 
            local function OnEx()
                if inst:IsValid() and inst.doer ~= nil and inst.doer:IsValid() then --added these checks, because recieve some crash report, no idea why it's crushing
                    if inst.doer:IsNear(inst, 3) then
                        ExtinguishRune(inst)
                        inst:RemoveEventCallback("killed", inst.OnEx, inst.doer)
						local x, y, z = inst.Transform:GetWorldPosition()
						local fx = SpawnPrefab("maxwell_smoke")
						fx.Transform:SetPosition(x, y, z)
                    end
                end
            end
            inst.OnEx = OnEx
            inst.doer = doer
            inst:ListenForEvent("killed", inst.OnEx, inst.doer) 
        end,
        sacrifice = function(inst, doer) 
            local function OnEx(_, data)
                if inst:IsValid() and inst.doer ~= nil and inst.doer:IsValid() then --added these checks, because recieve some crash report, no idea why it's crushing
                    if data and data.item and data.item.prefab == "reviver" and inst.doer:IsNear(inst, 3) then
                        ExtinguishRune(inst)
                        inst:RemoveEventCallback("builditem", inst.OnEx, inst.doer)
						local x, y, z = inst.Transform:GetWorldPosition()
						local fx = SpawnPrefab("maxwell_smoke")
						fx.Transform:SetPosition(x, y, z)
                    end
                end
            end
            inst.OnEx = OnEx
            inst.doer = doer
            inst:ListenForEvent("builditem", inst.OnEx, inst.doer) 
        end,
        beast = function(inst, doer) 
            local function OnEx()
                if inst:IsValid() and inst.doer ~= nil and inst.doer:IsValid() then --added these checks, because recieve some crash report, no idea why it's crushing
                    if inst.doer:IsNear(inst, 3) then
                        ExtinguishRune(inst)
                        inst:RemoveEventCallback("oneat", inst.OnEx, inst.doer)
						local x, y, z = inst.Transform:GetWorldPosition()
						local fx = SpawnPrefab("maxwell_smoke")
						fx.Transform:SetPosition(x, y, z)						
                    end
                end
            end
            inst.OnEx = OnEx
            inst.doer = doer
            inst:ListenForEvent("oneat", inst.OnEx, inst.doer) 
        end,
        rich = function(inst, doer) 
            local function OnEx()
                if inst:IsValid() and inst.doer ~= nil and inst.doer:IsValid() then --added these checks, because recieve some crash report, no idea why it's crushing
                    ExtinguishRune(inst)
                    inst:RemoveEventCallback("runetradeaccept", inst.OnEx, inst.doer)
					local x, y, z = inst.Transform:GetWorldPosition()
					local fx = SpawnPrefab("maxwell_smoke")
					fx.Transform:SetPosition(x, y, z)					
                end
            end
            inst.OnEx = OnEx
            inst.doer = doer
            inst.tradeItems["goldnugget"] = true
            
            inst:ListenForEvent("runetradeaccept", inst.OnEx, inst.doer) 
        end,
		
        magic = function(inst, doer) 
            local function OnEx()
                if inst:IsValid() and inst.doer ~= nil and inst.doer:IsValid() then --added these checks, because recieve some crash report, no idea why it's crushing
                        ExtinguishRune(inst)
                        inst:RemoveEventCallback("gemaccept", inst.OnEx, inst.doer)
						local x, y, z = inst.Transform:GetWorldPosition()
						local fx = SpawnPrefab("maxwell_smoke")
						fx.Transform:SetPosition(x, y, z)						
				end
            end
            inst.OnEx = OnEx
            inst.doer = doer
			inst.tradeItems["purplegem"] = true
			inst.tradeItems["bluegem"] = true
			inst.tradeItems["redgem"] = true
			inst.tradeItems["orangegem"] = true
			inst.tradeItems["yellowgem"] = true
			inst.tradeItems["greengem"] = true
			inst.tradeItems["opalgem"] = true			
			
            inst:ListenForEvent("gemaccept", inst.OnEx, inst.doer) 
        end,
    }

    if inst.owner == nil then return end
    
    inst.active = true
    inst.owner:DeactivateOtherRunes(inst)
    inst.components.trader:Enable()

    ActivateEvents[inst.type](inst, doer)

    if inst._dtask ~= nil then inst._dtask:Cancel() end
    inst._dtask = inst:DoTaskInTime(600, function(inst) 
        inst:DeactivateRune()
    end)

    GFSoftColourChange(inst, GetRuneColour(inst.type), {0, 0, 0, 1}, 1, 0.1)
end

local function SetRune(inst, type, owner)
    if type == nil then 
        inst:Remove()
        return
    end

    if inst.extinguished then
        inst.AnimState:SetMultColour(0.2, 0.2, 0.2, 1)
        inst.components.activatable.inactive = false
    else
        inst.AnimState:SetMultColour(0, 0, 0, 1) 
        inst.components.activatable.OnActivate = ActivateRune
    end

    if owner then inst.owner = owner end

    inst.type = type
    inst.persists = false
    inst.components.inspectable:SetDescription(STRINGS.CHARACTERS.GENERIC.DESCRIBE["RUNE_" .. string.upper(inst.type)])
    inst.components.inspectable.descriptionfn = function(inst, viewer)
        return GetString(viewer, "DESCRIBE", "GW_RUNE_" .. string.upper(inst.type))
    end
    inst.AnimState:PlayAnimation("idle_" .. type)
end

local function OnSave(inst, data)
    data.type = inst.type
	data.extinguished = inst.extinguished
	return data
end

local function OnLoad(inst, data)
    if data then
        inst.extinguished = data.extinguished
        if data.type then
            inst:SetRune(data.type)
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("runes")
    inst.AnimState:SetBuild("runes")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetMultColour(1, 1, 1, 1)

    inst:AddTag("rune")
    inst:AddTag("trader")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(function(inst, item) 
        return inst.tradeItems[item.prefab]
    end)
    inst.components.trader.onaccept = function(inst, giver, item)
	if item.prefab == "purplegem" or item.prefab == "bluegem" or item.prefab == "redgem" or item.prefab == "orangegem" or item.prefab == "yellowgem" or item.prefab == "greengem" or item.prefab == "opalgem" then	
        giver:PushEvent("gemaccept", {item = item})
	end	
	if item.prefab == "goldnugget" then	
        giver:PushEvent("runetradeaccept", {item = item})
	end
    end
    inst.components.trader.onrefuse = function(inst, giver, item)
        if giver.components.talker then
            giver.components.talker:Say(GetString(giver, "REFUSE_GW_RUNE_TRADE"), 1.5)
        end
    end
    inst.components.trader:Disable()
    inst.tradeItems = {}

    inst:AddComponent("activatable")
    inst.components.activatable.quickaction = true
    inst.components.activatable.inactive = true
    --inst.components.activatable.OnActivate = ActivateEvents["death"]()

    inst._atask = nil
    inst._dtask = nil
    inst.owner = nil
    inst.active = false
    inst.extinguished = false
    inst.doer = nil

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.SetRune = SetRune
    inst.OnEx = nil
    inst.DeactivateRune = DeactivateRune
    inst.ActivateRune = ActivateRune

    SetRune(inst, "beast")

    return inst
end

return Prefab("gw_rune", fn, assets, prefabs)
