local PULSE_SYNC_PERIOD = 30

--Needs to save/load time alive.

local function kill_sound(inst)
    inst.SoundEmitter:KillSound("staff_star_loop")
end

local function kill_light(inst)
    inst.AnimState:PlayAnimation("disappear")
    inst:ListenForEvent("animover", kill_sound)
    inst:DoTaskInTime(1, inst.Remove) --originally 0.6, padded for network
    inst.persists = false
    inst._killed = true
end

local function ontimer(inst, data)
    if data.name == "extinguish" then
        kill_light(inst)
    end
end

local function onpulsetimedirty(inst)
    inst._pulseoffs = inst._pulsetime:value() - inst:GetTimeAlive()
end

local function pulse_light(inst)
    local timealive = inst:GetTimeAlive()

    if inst._ismastersim then
        if timealive - inst._lastpulsesync > PULSE_SYNC_PERIOD then
            inst._pulsetime:set(timealive)
            inst._lastpulsesync = timealive
        else
            inst._pulsetime:set_local(timealive)
        end

        inst.Light:Enable(true)
    end

    --Client light modulation is enabled:

    --local s = GetSineVal(0.05, true, inst)
    local s = math.abs(math.sin(PI * (timealive + inst._pulseoffs) * 0.05))
    local rad = Lerp(11, 12, s)
    local intentsity = Lerp(0.8, 0.7, s)
    local falloff = Lerp(0.8, 0.7, s) 
    inst.Light:SetFalloff(falloff)
    inst.Light:SetIntensity(intentsity)
    inst.Light:SetRadius(rad)
end

local function onhaunt(inst)
    if inst.components.timer:TimerExists("extinguish") then
        inst.components.timer:StopTimer("extinguish")
        kill_light(inst)
    end
    return true
end

local function ShouldAcceptItem(inst, item)
    return item.components.edible ~= nil or item:HasTag("magicpowder")
end

local function stargone(inst)
	if inst.spell ~= nil then
		inst.spell:Remove()
		inst.spell = nil
	end
end

local function depleted(inst)
	inst:RemoveComponent("heater")
	inst:RemoveComponent("fueled")
	if inst.components.cooker ~= nil then
		inst:RemoveComponent("cooker")
	end
end

local function OnGetItem(inst, giver, item)
	if item.components.edible ~= nil and not item:HasTag("magicpowder") then
		local refreshee = item.prefab
		local x, y, z = inst.Transform:GetWorldPosition()
		if inst.spell == nil then
			inst.spell = inst:SpawnChild("goddess_sparklefx")
			inst.spell.Transform:SetPosition(0, 2, 0)
		end
		inst.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
		SpawnPrefab(refreshee).Transform:SetPosition(x , y + 2, z)
		inst:DoTaskInTime(0.75, stargone)
	end
	if item:HasTag("magicpowder") then
		if TheWorld.state.iswinter then	
			giver.components.talker:Say("It seems to be a lot warmer now, bet I could cook on it.")
			inst:AddComponent("heater")
            inst.components.heater.heat = 100
			inst:AddComponent("fueled")
			inst.components.fueled:InitializeFuelLevel(60)
			inst.components.fueled:SetDepletedFn(depleted)
			inst.components.fueled:StartConsuming()
			inst:AddComponent("cooker")
		elseif TheWorld.state.issummer then	
			giver.components.talker:Say("It seems to be a lot cooler now.")
			inst:AddComponent("heater")
			inst.components.heater.heat = -100
            inst.components.heater:SetThermics(false, true)
			inst:AddComponent("fueled")
			inst.components.fueled:InitializeFuelLevel(60)
			inst.components.fueled:SetDepletedFn(depleted)
			inst.components.fueled:StartConsuming()
		else
			local a = math.random()
			if a > 0.50 then
				giver.components.talker:Say("It seems to be a lot cooler now.")
				inst:AddComponent("heater")
				inst.components.heater.heat = -100
				inst.components.heater:SetThermics(false, true)
				inst:AddComponent("fueled")
				inst.components.fueled:InitializeFuelLevel(60)
				inst.components.fueled:SetDepletedFn(depleted)
				inst.components.fueled:StartConsuming()
			else
				giver.components.talker:Say("It seems to be warmer now, bet I could cook on it.")
				inst:AddComponent("heater")
				inst.components.heater.heat = 100
				inst:AddComponent("fueled")
				inst.components.fueled:InitializeFuelLevel(60)
				inst.components.fueled:SetDepletedFn(depleted)
				inst.components.fueled:StartConsuming()
				inst:AddComponent("cooker")
			end
		end
	end
end

local function makestafflight(name, is_hot, anim, colour, idles, is_fx)
    local assets =
    {
        Asset("ANIM", "anim/"..anim..".zip"),
    }

    local PlayRandomStarIdle = #idles > 1 and function(inst)
        --Don't if we're extinguished
        if not inst._killed then
            inst.AnimState:PlayAnimation(idles[math.random(#idles)])
        end
    end or nil

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddLight()
        inst.entity:AddNetwork()

        inst._ismastersim = TheWorld.ismastersim
        inst._pulseoffs = 0
        inst._pulsetime = net_float(inst.GUID, "_pulsetime", "pulsetimedirty")

        inst:DoPeriodicTask(.1, pulse_light)

        inst.Light:SetColour(unpack(colour))
        inst.Light:Enable(false)
        inst.Light:EnableClientModulation(true)

        inst.AnimState:SetBank(anim)
        inst.AnimState:SetBuild(anim)
		inst.AnimState:SetMultColour(144/255, 238/255, 144/255, 1)		
        inst.AnimState:PlayAnimation("appear")
        if #idles == 1 then
            inst.AnimState:PushAnimation(idles[1], true)
        end
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

        if is_fx then
            --V2C: FX/NOCLICK will prevent sanity aura from working
            --inst:AddTag("FX")

            inst.Transform:SetScale(.92, .92, .92)

            inst.AnimState:Hide("shadow")
            inst.AnimState:SetFinalOffset(1)
        else
            MakeInventoryPhysics(inst)
			MakeInventoryFloatable(inst)	

            inst.no_wet_prefix = true
        end
		
        inst.SoundEmitter:PlaySound("dontstarve/common/staff_coldlight_LP", "staff_star_loop")

        inst.entity:SetPristine()

        if not inst._ismastersim then
            inst:ListenForEvent("pulsetimedirty", onpulsetimedirty)
            return inst
        end

        inst._pulsetime:set(inst:GetTimeAlive())
        inst._lastpulsesync = inst._pulsetime:value()

        inst:AddComponent("sanityaura")
        inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL

        if is_fx then
            inst.persists = false
        else
            inst:AddComponent("inspectable")

            inst:AddComponent("hauntable")
            inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
            inst.components.hauntable:SetOnHauntFn(onhaunt)

            inst:AddComponent("timer")
            inst.components.timer:StartTimer("extinguish", 480)
            inst:ListenForEvent("timerdone", ontimer)

            inst.SoundEmitter:PlaySound("dontstarve/common/staff_star_create")
        end

        if #idles > 1 then
            inst:ListenForEvent("animover", PlayRandomStarIdle)
        end

		inst:AddComponent("trader")
		inst.components.trader:SetAcceptTest(ShouldAcceptItem)
		inst.components.trader.onaccept = OnGetItem
		
        return inst
    end

    return Prefab(name, fn, assets)
end

return makestafflight("goddess_star", true, "star_cold", { 100 / 255, 200 / 255, 100 / 255 }, { "idle_loop" }, false)
