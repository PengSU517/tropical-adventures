local total_day_time = 480
local night_time = 60
local CANDLEHAT_LIGHTTIME = night_time * 2
local BANDITHAT_PERISHTIME = total_day_time * 1
local THUNDERHAT_PERISHTIME = total_day_time * 4
local GASMASK_PERISHTIME = total_day_time * 3
local PITHHAT_PERISHTIME = total_day_time * 8
local PEAGAWKHAT_PERISHTIME = total_day_time * 0.9
local ARMORMETAL = 150 * 8
local ARMORMETAL_ABSORPTION = .85
local ARMORMETAL_SLOW = 0.90
local ARMOR_KNIGHT = 150 * 8
local ARMOR_KNIGHT_ABSORPTION = .85

local function generic_perish(inst)
    inst:Remove()
end

local function MakeHat(name)
    local fname = "hat_" .. name
    local symname = name .. "hat"
    local prefabname = symname

    --If you want to use generic_perish to do more, it's still
    --commented in all the relevant places below in this file.
    --[[local function generic_perish(inst)
        inst:Remove()
    end]]
    local swap_data = { bank = symname, anim = "anim" }

    local function onequip(inst, owner, symbol_override)
        local skin_build = inst:GetSkinBuild()
        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, symbol_override or "swap_hat", inst.GUID,
                fname)
        else
            owner.AnimState:OverrideSymbol("swap_hat", fname, symbol_override or "swap_hat")
        end
        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAIR_HAT")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")

        if owner:HasTag("player") then
            owner.AnimState:Hide("HEAD")
            owner.AnimState:Show("HEAD_HAT")
        end

		if inst:HasTag("antmask") then
			owner:AddTag("has_antmask")
		end

		if inst:HasTag("gasmask") then
			owner:AddTag("has_gasmask")
		end

		if inst:HasTag("venting") then
			owner:AddTag("venting")
		end

		if inst:HasTag("sneaky") then
			if not owner:HasTag("monster") then
				owner:AddTag("monster")
			else
				owner:AddTag("originaly_monster")
			end
			owner:AddTag("sneaky")
        end
        if not owner:HasTag("equipmentmodel") then
            if inst.components.fueled ~= nil then
                inst.components.fueled:StartConsuming()
            end
        end
    end

    local function onunequip(inst, owner)
        local skin_build = inst:GetSkinBuild()
        if skin_build ~= nil then
            owner:PushEvent("unequipskinneditem", inst:GetSkinName())
        end

        owner.AnimState:ClearOverrideSymbol("swap_hat")
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAIR_HAT")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")

        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
        end

        if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end

		if inst:HasTag("antmask") then
			owner:RemoveTag("has_antmask")
		end
		if inst:HasTag("gasmask") then
			owner:RemoveTag("has_gasmask")
		end

		if inst:HasTag("venting") then
			owner:RemoveTag("venting")
		end

		if inst:HasTag("sneaky") then
			if not owner:HasTag("originaly_monster") then
				owner:RemoveTag("monster")
			else
				owner:RemoveTag("originaly_monster")
			end
			owner:RemoveTag("sneaky")
        end
    end

    local function opentop_onequip(inst, owner)
        local skin_build = inst:GetSkinBuild()
        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, "swap_hat", inst.GUID, fname)
        else
            owner.AnimState:OverrideSymbol("swap_hat", fname, "swap_hat")
        end

        owner.AnimState:Show("HAT")
        owner.AnimState:Hide("HAIR_HAT")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")

        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
       end

        if not owner:HasTag("equipmentmodel") then
            if inst.components.fueled ~= nil then
                inst.components.fueled:StartConsuming()
            end
        end
    end

    local function simple(custom_init)
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(symname)
        inst.AnimState:SetBuild(fname)
        inst.AnimState:PlayAnimation("anim")

        inst:AddTag("hat")

        if custom_init ~= nil then
            custom_init(inst)
        end

        MakeInventoryFloatable(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inventoryitem")
        inst:AddComponent("inspectable")

        inst:AddComponent("tradable")

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)

        MakeHauntableLaunch(inst)

        return inst
    end

    local function default()
        return simple()
    end

    local function bat_turnon(owner)
        owner.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/batmask/on")
    end

    local function bat_turnoff(owner)
        owner.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/batmask/off")
    end

    local function bat_onequip(inst, owner)
        onequip(inst, owner)
        bat_turnon(owner)
        owner:AddTag("bat")
    end

    local function bat_onunequip(inst, owner)
        onunequip(inst, owner)
        bat_turnoff(owner)
        owner:RemoveTag("bat")
    end

    local function bat_perish(inst)
        if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
            if owner ~= nil then
                bat_turnoff(owner)
            end
        end
        inst:Remove() --generic_perish(inst)
    end

    local function bat_custom_init(inst)
        inst:AddTag("nightvision")
    end

    local function bat()
        local inst = simple(bat_custom_init)

        inst:AddTag("goggles")
        inst:AddTag("invisiblegoggles")
        inst:AddTag("batvision")
        inst:AddTag("no_sewing")
        inst:AddTag("venting")
        inst:AddTag("bat_hat")
        inst:AddTag("clearfog")

        inst.components.floater:SetBankSwapOnFloat(false, nil, { bank = "bathat", anim = "anim" })

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable:SetOnEquip(bat_onequip)
        inst.components.equippable:SetOnUnequip(bat_onunequip)

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.BLOOD
        inst.components.fueled:InitializeFuelLevel(TUNING.BATHAT_PERISHTIME)
        inst.components.fueled:SetDepletedFn(bat_perish)
        inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
        inst.components.fueled.accepting = true

        return inst
    end

    local function peagawkfeather()
        local inst = simple()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(PEAGAWKHAT_PERISHTIME)
        inst.components.fueled:SetDepletedFn(generic_perish)

        return inst
    end

	local function disguise_onequip(inst, owner)
		opentop_onequip(inst, owner)
        inst.monster = owner:HasTag("monster")
        owner:RemoveTag("monster")

        inst.spiderwhisperer = owner:HasTag("spiderwhisperer")
        owner:RemoveTag("spiderwhisperer")

        inst.merm = owner:HasTag("merm")
        owner:RemoveTag("merm")

        if owner.components.leader then
             owner.components.leader:RemoveFollowersByTag("merm")
             owner.components.leader:RemoveFollowersByTag("spider")
        end
	end

	local function disguise_unequip(inst, owner)
		onunequip(inst, owner)
        if inst.monster then owner:AddTag("monster") end

        if inst.spiderwhisperer then owner:AddTag("spiderwhisperer") end

        if inst.merm then owner:AddTag("merm") end

        if owner.components.leader then
             owner.components.leader:RemoveFollowersByTag("pig")
        end
	end

    local function disguise()
		local inst = simple()
		inst:AddTag("disguise")
        inst:AddTag("open_top_hat")

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.floater:SetBankSwapOnFloat(false, nil, { bank = "disguisehat", anim = "anim" })
        inst.components.floater:SetSize("med")
        inst.components.floater:SetScale(0.68)

		inst.components.equippable:SetOnEquip( disguise_onequip )
		inst.components.equippable:SetOnUnequip( disguise_unequip )
		inst.opentop = true

        return inst
    end

    local function antmask_onupdate(inst)
        inst.components.armor:SetPercent(inst.components.fueled:GetPercent())
    end

    local function antmask_ontakedamage(inst, damage_amount, absorbed)
        if inst.components.fueled then
            local percent = inst.components.fueled:GetPercent()
            local newPercent = percent - 0.03
            inst.components.fueled:SetPercent(newPercent)
        end
    end

    local function onequipantmask(inst, owner, symbol_override)
        owner.AnimState:OverrideSymbol("swap_hat", fname, symbol_override or "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAIR_HAT")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")
        owner:AddTag("has_antmask")

        if owner:HasTag("player") then
            owner.AnimState:Hide("HEAD")
            owner.AnimState:Show("HEAD_HAT")
        end
        if not owner:HasTag("equipmentmodel") then
            if inst.components.fueled ~= nil then
                inst.components.fueled:StartConsuming()
            end
        end
    end

    local function onunequipantmask(inst, owner)
        owner.AnimState:ClearOverrideSymbol("swap_hat")
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAIR_HAT")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")
        owner:RemoveTag("has_antmask")

        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
        end

        if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end
    end

    local function antmask()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("antmaskhat")
        inst.AnimState:SetBuild("hat_antmask")
        inst.AnimState:PlayAnimation("anim")

        inst:AddTag("hat")
        inst:AddTag("antmask")

        MakeInventoryFloatable(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inventoryitem")
        inst:AddComponent("inspectable")

        inst:AddComponent("tradable")

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(onequipantmask)
        inst.components.equippable:SetOnUnequip(onunequipantmask)

        MakeHauntableLaunch(inst)

        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING.ARMOR_FOOTBALLHAT, TUNING.ARMOR_FOOTBALLHAT_ABSORPTION)
        inst.components.armor.ontakedamage = antmask_ontakedamage

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(4800)
        inst.components.fueled:SetDepletedFn(generic_perish)
        inst.components.fueled:SetUpdateFn(antmask_onupdate)

        return inst
    end

    local function pigcrown()
        local inst = simple()
        inst:AddTag("regal")

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED_LARGE
        inst:AddTag("pigcrown")

        return inst
    end

    local function bandit()
        local inst = simple()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(BANDITHAT_PERISHTIME)
        inst.components.fueled:SetDepletedFn(generic_perish)
        inst:AddTag("sneaky")


        return inst
    end

    local function pith()
        local inst = simple()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(PITHHAT_PERISHTIME)
        inst.components.fueled:SetDepletedFn(generic_perish)

        --inst.components.equippable.walkspeedmult = 0.1
        --inst:AddComponent("armor")
        --inst.components.armor:InitCondition(TUNING.ARMOR_PITHHAT, TUNING.ARMOR_PITHHAT_ABSORPTION)
        --inst.components.armor:SetTags({"antmask"})

        inst:AddTag("venting")
        inst:AddTag("fogproof")

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_MED)

        return inst
    end

    local function gasmask()
        local inst = simple()
        inst:AddTag("gasmask")

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
        --		inst.components.equippable.poisongasblocker = true

        inst.components.equippable:SetOnEquip(opentop_onequip)

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(GASMASK_PERISHTIME)
        inst.components.fueled:SetDepletedFn(generic_perish)

        return inst
    end


    local function thunder_equip(inst, owner)
        onequip(inst, owner)
        inst:AddTag("lightningrod")
    end

    local function thunder_unequip(inst, owner)
        onunequip(inst, owner)
        inst:RemoveTag("lightningrod")
    end

    local function thunder()
        local inst = simple()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(THUNDERHAT_PERISHTIME)
        inst.components.fueled:SetDepletedFn(generic_perish)

        inst.components.equippable:SetOnEquip(thunder_equip)
        inst.components.equippable:SetOnUnequip(thunder_unequip)


        inst:ListenForEvent("lightningstrike",
            function(inst, data) inst.components.fueled:DoDelta(-inst.components.fueled.maxfuel * 0.05) end)

        return inst
    end

    local function metalplate()
        local inst = simple()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("armor")

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

        inst.components.equippable.walkspeedmult = ARMORMETAL_SLOW

        inst.components.armor:InitCondition(ARMOR_KNIGHT, ARMOR_KNIGHT_ABSORPTION)

        return inst
    end

    local function candle_turnon(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
        if not inst.components.fueled:IsEmpty() then
            if inst._light == nil or not inst._light:IsValid() then
                inst._light = SpawnPrefab("torchfire")
                local follower = inst._light.entity:AddFollower()
                follower:FollowSymbol(owner.GUID, "swap_hat", 0, -250, 0)
            end
            if owner ~= nil then
                onequip(inst, owner)
                inst._light.entity:SetParent(owner.entity)
            end
            inst.components.fueled:StartConsuming()
            local soundemitter = owner ~= nil and owner.SoundEmitter or inst.SoundEmitter
            soundemitter:PlaySound("dontstarve/common/fireAddFuel")
        elseif owner ~= nil then
            onequip(inst, owner)
        end
    end

    local function candle_turnoff(inst)
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
        if owner ~= nil and inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
            onequip(inst, owner)
        end
        inst.components.fueled:StopConsuming()
        if inst._light ~= nil then
            if inst._light:IsValid() then
                inst._light:Remove()
            end
            inst._light = nil
            local soundemitter = owner ~= nil and owner.SoundEmitter or inst.SoundEmitter
            soundemitter:PlaySound("dontstarve/common/minerhatOut")
        end
    end

    local function candle_unequip(inst, owner)
        onunequip(inst, owner)
        candle_turnoff(inst)
    end

    local function candle_perish(inst)
        local equippable = inst.components.equippable
        if equippable ~= nil and equippable:IsEquipped() then
            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
            if owner ~= nil then
                local data =
                {
                    prefab = inst.prefab,
                    equipslot = equippable.equipslot,
                }
                candle_turnoff(inst)
                owner:PushEvent("torchranout", data)
                return
            end
        end
        candle_turnoff(inst)
    end

    local function candle_takefuel(inst)
        inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
        if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
            candle_turnon(inst)
        end
    end

    local function candle_onremove(inst)
        if inst._light ~= nil and inst._light:IsValid() then
            inst._light:Remove()
        end
    end

    local function candle_custom_init(inst)
        inst.entity:AddSoundEmitter()
        --waterproofer (from waterproofer component) added to pristine state for optimization
        inst:AddTag("waterproofer")
    end

    local function candle()
        local inst = simple(candle_custom_init)

        inst.components.floater:SetSize("med")
        inst.components.floater:SetScale(0.6)

        if not TheWorld.ismastersim then
            return inst
        end

        inst.entity:AddSoundEmitter()
        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

        inst.components.inventoryitem:SetOnDroppedFn(candle_turnoff)
        inst.components.equippable:SetOnEquip(candle_turnon)
        inst.components.equippable:SetOnUnequip(candle_unequip)

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "CORK"
        inst.components.fueled:InitializeFuelLevel(CANDLEHAT_LIGHTTIME)
        inst.components.fueled:SetDepletedFn(candle_perish)
        inst.components.fueled.ontakefuelfn = candle_takefuel
        inst.components.fueled.accepting = true


        inst._light = nil
        inst.OnRemoveEntity = candle_onremove

        return inst
    end

    local fn = nil
    local assets = { Asset("ANIM", "anim/" .. fname .. ".zip") }
    local prefabs = nil

        if name == "peagawkfeather" then
        fn = peagawkfeather
    elseif name == "disguise" then
        fn = disguise
    elseif name == "antmask" then
        fn = antmask
    elseif name == "pigcrown" then
        fn = pigcrown
    elseif name == "gasmask" then
        fn = gasmask
    elseif name == "pith" then
        fn = pith
    elseif name == "bandit" then
        fn = bandit
    elseif name == "bat" then
        fn = bat
    elseif name == "candle" then
        fn = candle
    elseif name == "thunder" then
        fn = thunder
    elseif name == "metalplate" then
        fn = metalplate
    end

    return Prefab(prefabname, fn or default, assets, prefabs)
end

return MakeHat("peagawkfeather"),
    MakeHat("disguise"),
    MakeHat("antmask"),
    MakeHat("pigcrown"),
    MakeHat("gasmask"),
    MakeHat("pith"),
    MakeHat("bandit"),
    MakeHat("bat"),
    MakeHat("candle"),
    MakeHat("thunder"),
    MakeHat("metalplate")

