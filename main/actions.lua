local AddAction = AddAction
local ACTIONS = ACTIONS
local Action = Action
local STRINGS = STRINGS




ACTIONS.ADDFUEL.priority = 1 -- Runar: 未定义的优先级，没有的话碎布加燃料会有问题
ACTIONS.GIVE.priority = 0

AddAction(
    "LAVASPIT",
    "spit",
    function(act)
        if act.doer and act.target and act.doer.prefab == "dragoon" then
            local spit = SpawnPrefab("dragoonspit")
            local x, y, z = act.doer.Transform:GetWorldPosition()
            local downvec = TheCamera:GetDownVec()
            local offsetangle = math.atan2(downvec.z, downvec.x) * (180 / math.pi)
            while offsetangle > 180 do
                offsetangle = offsetangle - 360
            end
            while offsetangle < -180 do
                offsetangle = offsetangle + 360
            end
            local offsetvec = Vector3(math.cos(offsetangle * DEGREES), -.3, math.sin(offsetangle * DEGREES)) * 1.7
            spit.Transform:SetPosition(x + offsetvec.x, y + offsetvec.y, z + offsetvec.z)
            spit.Transform:SetRotation(act.doer.Transform:GetRotation())
        end
    end
)

-- DEPLOY_AI Action [FIX FOR MOBS THAT PLANT TREES]
AddAction(
    "DEPLOY_AI",
    "Deploy AI",
    function(act)
        if act.invobject and act.invobject.components.deployable then
            local obj =
                (act.doer.components.inventory and act.doer.components.inventory:RemoveItem(act.invobject)) or
                (act.doer.replica.container and act.doer.replica.container:RemoveItem(act.invobject))
            if obj then
                if obj.components.deployable:ForceDeploy(act:GetActionPoint(), act.doer, act.rotation) then
                    return true
                else
                    act.doer.components.inventory:GiveItem(obj)
                end
            end
        end
    end
)



AddAction(
    "FLUP_HIDE",
    "Flup Hide",
    function(act)
        --Dummy action for flup hiding
    end
)

AddAction(
    "FISH1",
    "Fish1",
    function(act)
        local fishingrod =
            (act.invobject and act.invobject.components.fishingrod) or (act.doer and act.doer.components.fishingrod)

        if fishingrod then
            fishingrod:StartFishing(act.target, act.doer)
        end
        return true
    end
)

AddAction(
    "TIGERSHARK_FEED",
    "Tigershark Feed",
    function(act)
        local doer = act.doer
        if doer and doer.components.lootdropper then
            doer.components.lootdropper:SpawnLootPrefab("wetgoop")
        end
    end
)

AddAction(
    "MATE",
    "Mate",
    function(act)
        if act.target == act.doer then
            return false
        end

        if act.doer.components.mateable then
            act.doer.components.mateable:Mate()
            return true
        end
    end
)

AddAction(
    "CRAB_HIDE",
    "Crab Hide",
    function(act)
        --Dummy action for crab.
    end
)

AddAction(
    "HIDECRAB",
    "Hide",
    function(act)
        if act.doer then
            return true
        end
    end)

AddAction(
    "SHOWCRAB",
    "Emerge",
    function(act)
        if act.doer then
            return true
        end
    end)

--[[
AddAction(
    "THROW",
    "Throw",
    function(act)
	local thrown = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	if act.target and not act.pos then
		act.pos = act.target:GetPosition()
	end
	if thrown and thrown.components.throwable then
		thrown.components.throwable:Throw(act.pos, act.doer)
		return true
	end
    end
)
]]

local THROW = Action({ priority = 0, rmb = true, distance = 20, mount_valid = true })
THROW.str = "Throw"
THROW.id = "THROW"
THROW.fn = function(act)
    local thrown = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if act.target and not act.pos then
        act.pos = act.target:GetPosition()
    end
    if thrown and thrown.components.throwable then
        thrown.components.throwable:Throw(act.pos, act.doer)
        return true
    end
end
AddAction(THROW)

--actions hamlet--
AddAction(
    "PEAGAWK_TRANSFORM",
    "Peagank Transform",
    function(act)
        --Dummy action for flup hiding
    end
)

AddAction(
    "MANUALEXTINGUISH",
    "Manualextinguish",
    function(act)
        if act.doer:HasTag("extinguisher") then
            if act.target.components.burnable and act.target.components.burnable:IsBurning() then
                act.target.components.burnable:Extinguish()
                return true
            end
        elseif act.target.components.sentientball then
            act.target.components.burnable:Extinguish()
            -- damage player?
            return true
        elseif act.invobject:HasTag("frozen") and act.target.components.burnable and act.target.components.burnable:IsBurning() then
            act.target.components.burnable:Extinguish(true, TUNING.SMOTHERER_EXTINGUISH_HEAT_PERCENT, act.invobject)
            return true
        end
    end
)

AddAction(
    "SPECIAL_ACTION",
    "Special Actions",
    function(act)
        if act.doer.special_action then
            act.doer.special_action(act)
            return true
        end
    end
)

AddAction(
    "SPECIAL_ACTION2",
    "Special Actions2",
    function(act)
        if act.doer.special_action2 then
            act.doer.special_action2(act)
            return true
        end
    end
)


AddAction(
    "LAUNCH_THROWABLE",
    "Launch Throwable",
    function(act)
        if act.target and not act.pos then
            act.pos = act.target:GetPosition()
        end
        act.invobject.components.thrower:Throw(act.pos)
        return true
    end
)

AddAction(
    "INFEST",
    "Infest",
    function(act)
        if not act.doer.infesting then
            act.doer.components.infester:Infest(act.target)
        end
    end
)

AddAction(
    "DIGDUNG",
    "Digdung",
    function(act)
        act.target.components.workable:WorkedBy(act.doer, 1)
    end
)

AddAction(
    "MOUNTDUNG",
    "Mountdung",
    function(act)
        act.doer.dung_target:Remove()
        act.doer:AddTag("hasdung")
        act.doer.dung_target = nil
    end
)

AddAction(
    "BARK",
    "Bark",
    function(act)
        return true
    end
)

AddAction(
    "RANSACK",
    "Ransack",
    function(act)
        return true
    end
)

AddAction(
    "CUREPOISON",
    "Curepoison",
    function(act)
        if act.invobject and act.invobject.components.poisonhealer then
            local target = act.target or act.doer
            return act.invobject.components.poisonhealer:Cure(target)
        end
    end
)

AddAction(
    "USEDOOR",
    "Usedoor",
    function(act)
        if act.target:HasTag("secret_room") then
            return false
        end

        if act.target.components.door and not act.target.components.door.disabled then
            act.target.components.door:Activate(act.doer)
            return true
        elseif act.target.components.door and act.target.components.door.disabled then
            return false, "LOCKED"
        end
    end
)

local SHOP = Action({ priority = 9, rmb = true, distance = 1, mount_valid = false })
SHOP.stroverridefn = function(act)
    if act.target.cost then
        local itemname = act.target.components.shopdispenser:GetItem()
        local itemname = itemname and string.gsub(itemname, "_blueprint", "") or "unknown"
        local costprefab = act.target.costprefab or "oinc"
        return subfmt(STRINGS.ACTIONS.CHECKSHOP, {
            item = STRINGS.NAMES[itemname and itemname:upper()] or itemname,
            cost = act.target.cost and (act.target.cost <= 1 and "" or act.target.cost),
            costprefab = STRINGS.NAMES[costprefab:upper()],
        })
    else
        return "Shop"
    end
end
SHOP.id = "SHOP"
SHOP.fn = function(act)
    if act.doer.components.inventory then
        if act.doer:HasTag("player") and act.doer.components.shopper then
            if act.doer.components.shopper:IsWatching(act.target) then
                local sell = true
                local reason = nil

                if act.target:HasTag("shopclosed") or TheWorld.state.isnight then
                    reason = "closed"
                    sell = false
                elseif not act.doer.components.shopper:CanPayFor(act.target) then
                    local prefab_wanted = act.target.costprefab
                    if prefab_wanted == "oinc" then
                        reason = "money"
                    else
                        reason = "goods"
                    end
                    sell = false
                end

                if sell then
                    act.doer.components.shopper:PayFor(act.target)
                    act.target.components.shopdispenser:RemoveItem()
                    act.target:SetImage(nil)

                    if act.target and act.target.shopkeeper_speech then
                        act.target.shopkeeper_speech(act.target,
                            STRINGS.CITY_PIG_SHOPKEEPER_SALE[math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_SALE)])
                    end

                    return true
                else
                    if reason == "money" then
                        if act.target and act.target.shopkeeper_speech then
                            act.target.shopkeeper_speech(act.target,
                                STRINGS.CITY_PIG_SHOPKEEPER_NOT_ENOUGH
                                [math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_NOT_ENOUGH)])
                        end
                    elseif reason == "goods" then
                        local itemname = act.target.costprefab or "oinc"
                        if act.target and act.target.shopkeeper_speech then
                            act.target.shopkeeper_speech(act.target,
                                subfmt(STRINGS.CITY_PIG_SHOPKEEPER_DONT_HAVE
                                    [math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_DONT_HAVE)], {
                                        item = STRINGS.NAMES[itemname and itemname:upper()] or "UNKNOWN",
                                    })
                            )
                        end
                    elseif reason == "closed" then
                        if act.target and act.target.shopkeeper_speech then
                            act.target.shopkeeper_speech(act.target,
                                STRINGS.CITY_PIG_SHOPKEEPER_CLOSING
                                [math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_CLOSING)])
                        end
                    end
                    return true
                end
            else
                act.doer.components.shopper:Take(act.target)
                -- THIS IS WHAT HAPPENS IF ISWATCHING IS FALSE
                act.target.components.shopdispenser:RemoveItem()
                act.target:SetImage(nil)
                return true
            end
        end
    end
end
SHOP.encumbered_valid = true
AddAction(SHOP)

AddAction(
    "FIX",
    "Fix",
    function(act)
        if act.target then
            local target = act.target
            local numworks = 1
            target.components.workable:WorkedBy(act.doer, numworks)
            --	return target:fix(act.doer)		
        end
    end
)

AddAction(
    "STOCK",
    "Stock",
    function(act)
        if act.target then
            act.target.restock(act.target, true)
            act.doer.changestock = nil
            return true
        end
    end
)
-- acoes do jogador--

local function ExtrarummageRange(doer, dest)
    if dest ~= nil then
        local target_x, target_y, target_z = dest:GetPoint()

        local is_on_water = TheWorld.Map:IsOceanTileAtPoint(target_x, 0, target_z) and
            not TheWorld.Map:IsPassableAtPoint(target_x, 0, target_z)
        if is_on_water then
            return 2
        end
    end
    return 0
end

ACTIONS.RUMMAGE.extra_arrive_dist = ExtrarummageRange
---
local BOATMOUNT = Action({ priority = 10, rmb = true, distance = 8, mount_valid = false })
BOATMOUNT.str = (STRINGS.ACTIONS.BOATMOUNT)
BOATMOUNT.id = "BOATMOUNT"
BOATMOUNT.fn = function(act)
    if act.doer ~= nil and act.target ~= nil and act.doer:HasTag("player") and act.target.components.interactions and
        act.target:HasTag("boatsw")
    then
        act.doer:AddTag("pulando")
        if act.doer:HasTag("aquatic") then
            act.doer:RemoveComponent("rowboatwakespawner")
            if act.doer.components.driver then
                local barcoinv = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
                if barcoinv and barcoinv.prefab == act.doer.components.driver.vehicle.prefab then
                    local consumo = SpawnPrefab(act.doer.components.driver.vehicle.prefab)
                    consumo.Transform:SetPosition(act.doer.components.driver.vehicle:GetPosition():Get())
                    consumo.components.finiteuses.current = barcoinv.components.finiteuses.current
                    --transfere o conteudo do barco inventario para o barco do criado--
                    if barcoinv.components.container then
                        local sailslot = barcoinv.components.container:GetItemInSlot(1)
                        if sailslot then
                            consumo.components.container:GiveItem(sailslot, 1)
                        end

                        local luzslot = barcoinv.components.container:GetItemInSlot(2)
                        if luzslot and luzslot.prefab == "quackeringram" then luzslot.navio1 = nil end
                        if luzslot then
                            consumo.components.container:GiveItem(luzslot, 2)
                        end

                        local cargoslot1 = barcoinv.components.container:GetItemInSlot(3)
                        if cargoslot1 then
                            consumo.components.container:GiveItem(cargoslot1, 3)
                        end

                        local cargoslot2 = barcoinv.components.container:GetItemInSlot(4)
                        if cargoslot2 then
                            consumo.components.container:GiveItem(cargoslot2, 4)
                        end

                        local cargoslot3 = barcoinv.components.container:GetItemInSlot(5)
                        if cargoslot3 then
                            consumo.components.container:GiveItem(cargoslot3, 5)
                        end

                        local cargoslot4 = barcoinv.components.container:GetItemInSlot(6)
                        if cargoslot4 then
                            consumo.components.container:GiveItem(cargoslot4, 6)
                        end

                        local cargoslot5 = barcoinv.components.container:GetItemInSlot(7)
                        if cargoslot5 then
                            consumo.components.container:GiveItem(cargoslot5, 7)
                        end

                        local cargoslot6 = barcoinv.components.container:GetItemInSlot(8)
                        if cargoslot6 then
                            consumo.components.container:GiveItem(cargoslot6, 8)
                        end
                    end
                    ---
                    barcoinv:Remove()
                end
                act.doer.components.driver.vehicle:Remove()
                act.doer:RemoveComponent("driver")
                act.doer:RemoveTag("sail")
                act.doer:RemoveTag("surf")
                act.doer:RemoveTag("aquatic")
            end
        end
        act.target.components.interactions:BoatJump(act.doer)
        return true
    else
        return false
    end
end
BOATMOUNT.encumbered_valid = true
AddAction(BOATMOUNT)



local BOATDISMOUNT = Action({ priority = 9, rmb = true, distance = 8, mount_valid = false })
BOATDISMOUNT.str = (STRINGS.ACTIONS.BOATDISMOUNT)
BOATDISMOUNT.id = "BOATDISMOUNT"
BOATDISMOUNT.fn = function(act)
    if act.doer ~= nil and act.doer:HasTag("player") then
        act.doer:AddTag("pulando")
        if not act.doer.components.interactions then
            act.doer:AddComponent("interactions")
        end
        act.doer.components.interactions:BoatDismount(act.doer, act:GetActionPoint())
        return true
    end
end
BOATDISMOUNT.encumbered_valid = true
AddAction(BOATDISMOUNT)


local SURF = Action({
    priority = 4,
    --is_relative_to_platform=true,
    --disable_platform_hopping=true,
    distance = 20
})
SURF.str = (STRINGS.ACTIONS.SURF)
SURF.id = "SURF"
SURF.fn = function(act)
    local doer_x, doer_y, doer_z = act.doer.Transform:GetWorldPosition()
    local planchadesurf = TheWorld.Map:GetPlatformAtPoint(doer_x, doer_z)
    if planchadesurf and planchadesurf:HasTag("planchadesurf") then
        local pos = act:GetActionPoint()
        if pos == nil then
            pos = act.target:GetPosition()
        end
        planchadesurf.components.oar:Row(act.doer, pos)
        planchadesurf.components.health:DoDelta(-0.5)

        return true
    end
end
SURF.encumbered_valid = true
AddAction(SURF)





local BOATCANNON = Action({ priority = 8, rmb = true, distance = 25, mount_valid = false })
BOATCANNON.str = (STRINGS.ACTIONS.BOATCANNON)
BOATCANNON.id = "BOATCANNON"
BOATCANNON.fn = function(act)
    if act.doer ~= nil and act.doer:HasTag("player") then
        act.doer:AddTag("deleidotiro")
        act.doer:DoTaskInTime(0.5, function(inst) act.doer:RemoveTag("deleidotiro") end)


        local equipamento = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
        local canhao = equipamento.replica.container:GetItemInSlot(2)
        --posiciona pra sair no canhao--
        local angle = act.doer:GetRotation()
        local dist = 1.5
        local offset = Vector3(dist * math.cos(angle * DEGREES), 0, -dist * math.sin(angle * DEGREES))
        local x, y, z = act.doer.Transform:GetWorldPosition()
        local x1, y1, z1
        local pos
        if act.target then
            x1, y1, z1 = act.target:GetPosition():Get()
            pos = act.target:GetPosition()
        else
            x1, y1, z1 = act:GetActionPoint():Get()
            pos = act:GetActionPoint()
        end

        local pt = Vector3(x, y, z)
        local bombpos = pt + offset
        local x, y, z = bombpos:Get()

        --

        if canhao and canhao.prefab == "woodlegs_boatcannon" then
            if equipamento and canhao then canhao.components.finiteuses:Use(1) end
            local bomba = SpawnPrefab("cannonshotobsidian")
            bomba.Transform:SetPosition(x, y + 1.5, z)
            bomba.components.complexprojectile:Launch(pos)
            act.doer.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/cannon")
        else
            if equipamento and canhao and act.doer.prefab ~= "woodlegs" then
                canhao.components.finiteuses:Use(1)
                local bomba = SpawnPrefab("cannonshot")
                bomba.Transform:SetPosition(x, y + 1.5, z)
                bomba.components.complexprojectile:Launch(pos)
                act.doer.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/cannon")
            elseif equipamento and equipamento.prefab == "woodlegsboat" and canhao and act.doer.prefab == "woodlegs" then
                local bomba = SpawnPrefab("cannonshot")
                bomba.components.explosive.explosivedamage = 50
                bomba.Transform:SetPosition(x, y + 1.5, z)
                bomba.components.complexprojectile:Launch(pos)
                act.doer.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/cannon")
            elseif equipamento and canhao then
                canhao.components.finiteuses:Use(1)
                local bomba = SpawnPrefab("cannonshot")
                bomba.Transform:SetPosition(x, y + 1.5, z)
                bomba.components.complexprojectile:Launch(pos)
                act.doer.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/cannon")
            end
        end

        return true
    end
end
AddAction(BOATCANNON)

local TIRO = Action({ priority = 9, rmb = true, distance = 20, mount_valid = false })
TIRO.str = (STRINGS.ACTIONS.TIRO)
TIRO.id = "TIRO"
TIRO.fn = function(act)
    if act.doer ~= nil and act.doer:HasTag("ironlord") then
        --        act.doer:AddComponent("interactions")
        --        act.doer.components.interactions:TIRO(act.doer, act.target:GetPosition())
        return true
    end
end
--TIRO.encumbered_valid =true
AddAction(TIRO)


local RETRIEVE = Action({ priority = 11, rmb = true, distance = 2, mount_valid = false })
RETRIEVE.str = (STRINGS.ACTIONS.RETRIEVE)
RETRIEVE.id = "RETRIEVE"
RETRIEVE.fn = function(act)
    if act.target.components.breeder and act.target.components.breeder.volume > 0 then
        return act.target.components.breeder:Harvest(act.doer)
    end

    if act.doer ~= nil and act.target ~= nil and act.doer:HasTag("player") and act.target.components.interactions and act.target.prefab == "surfboard" then
        if act.target and act.target.prefab == "surfboard" then
            local panela = SpawnPrefab("SURFBOARD_ITEM")
            if act.target.components.finiteuses then
                panela.components.finiteuses.current = act.target.components.finiteuses.current
            end
            act.doer.components.inventory:GiveItem(panela, 1)
            act.target:Remove()
        end
        return true
    end

    if act.doer ~= nil and act.target ~= nil and act.doer:HasTag("player") and act.target.components.interactions and act.target.prefab == "corkboat" then
        if act.target and act.target.prefab == "corkboat" then
            local panela = SpawnPrefab("corkboatitem")
            if act.target.components.finiteuses then
                panela.components.finiteuses.current = act.target.components.finiteuses.current
            end



            --transfere o conteudo do barco inventario para o barco do criado--
            if act.target.components.container then
                local sailslot = act.target.components.container:GetItemInSlot(1)
                if sailslot then
                    act.doer.components.inventory:GiveItem(sailslot, 1)
                end

                local luzslot = act.target.components.container:GetItemInSlot(2)
                if luzslot and luzslot.prefab == "quackeringram" then luzslot.navio1 = nil end
                if luzslot then
                    act.doer.components.inventory:GiveItem(luzslot, 1)
                end
            end
            ---

            act.doer.components.inventory:GiveItem(panela, 1)
            act.target:Remove()
        end
        return true
    end
end

AddAction(RETRIEVE)

--[[
local function ExtraDeployDist(doer, dest, bufferedaction)
	if dest ~= nil then
		local target_x, target_y, target_z = dest:GetPoint()

		local is_on_water = TheWorld.Map:IsOceanTileAtPoint(target_x, 0, target_z) and not TheWorld.Map:IsPassableAtPoint(target_x, 0, target_z)
		if is_on_water then
			return ((bufferedaction ~= nil and bufferedaction.invobject ~= nil and bufferedaction.invobject:HasTag("usedeployspacingasoffset") and bufferedaction.invobject.replica.inventoryitem ~= nil and bufferedaction.invobject.replica.inventoryitem:DeploySpacingRadius()) or 0) + 1.0
		end
	end
    return 0
end


ACTIONS.DEPLOY.distance = 6
]]



local BOATREPAIR = Action({ priority = 10, rmb = true, distance = 1, mount_valid = false })
BOATREPAIR.str = (STRINGS.ACTIONS.BOATREPAIR)
BOATREPAIR.id = "BOATREPAIR"
BOATREPAIR.fn = function(act)
    if act.doer ~= nil and act.doer:HasTag("aquatic") and act.invobject ~= nil and act.invobject:HasTag("boatrepairkit") then
        local boat = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
        local boat2 = act.doer.components.driver.vehicle
        if boat and boat2 then
            if boat2.components.finiteuses and boat.components.armor.condition and boat2.components.finiteuses.current + 150 >= boat2.components.finiteuses.total then
                boat2.components.finiteuses.current = boat2.components.finiteuses.total
                boat.components.armor.condition = boat2.components.finiteuses.current
                if boat2.components.finiteuses then
                    boat2.components.finiteuses:Use(1)
                end
                if act.invobject.prefab == "sewing_tape" then
                    local nut = act.invobject
                    if act.invobject.components.stackable and act.invobject.components.stackable.stacksize > 1 then
                        nut = act.invobject.components.stackable:Get()
                    end
                    nut:Remove()
                else
                    if act.invobject.components.finiteuses then
                        act.invobject.components.finiteuses:Use(1)
                    end
                end
                return true
            end

            boat2.components.finiteuses.current = boat2.components.finiteuses.current + 150
            boat.components.armor.condition = boat.components.armor.condition + 150
            if act.invobject.components.finiteuses then
                act.invobject.components.finiteuses:Use(1)
            end
        end
        return true
    end



    if act.doer ~= nil and act.target ~= nil and act.doer:HasTag("player") and act.target.components.interactions and
        act.target:HasTag("boatsw")
    then
        local equipamento = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

        if equipamento then
            if act.target.components.finiteuses.current + 150 >= act.target.components.finiteuses.total then
                act.target.components.finiteuses.current = act.target.components.finiteuses.total
                local gastabarco = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)                      --armadura
                if gastabarco then gastabarco.components.armor.condition = act.target.components.finiteuses.current end --armadura
                if equipamento.components.finiteuses then
                    equipamento.components.finiteuses:Use(1)
                end
                return true
            end
            act.target.components.finiteuses.current = act.target.components.finiteuses.current + 150
            local gastabarco = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)                      --armadura
            if gastabarco then gastabarco.components.armor.condition = act.target.components.finiteuses.current end --armadura
            if equipamento.components.finiteuses then
                equipamento.components.finiteuses:Use(1)
            end
        end
        return true
    end
end

AddAction(BOATREPAIR)





local OPENTUNA = Action({ priority = 10, rmb = true, distance = 1, mount_valid = false })
OPENTUNA.str = (STRINGS.ACTIONS.OPENTUNA)
OPENTUNA.id = "OPENTUNA"
OPENTUNA.fn = function(act)
    if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("tunacan") then
        local nut = act.invobject
        if act.invobject.replica.inventoryitem then
            if act.invobject.components.stackable and act.invobject.components.stackable.stacksize > 1 then
                nut = act.invobject.components.stackable:Get()
            end
            if act.doer.components.inventory then
                local peixe = SpawnPrefab("fish_med_cooked")
                act.doer.components.inventory:GiveItem(peixe, 1)
            end
        end
        nut:Remove()
        return true
    end
end
AddAction(OPENTUNA)

local DISLODGE = Action({ priority = 11, rmb = true, distance = 2, mount_valid = false })
DISLODGE.str = (STRINGS.ACTIONS.DISLODGE)
DISLODGE.id = "DISLODGE"
DISLODGE.fn = function(act)
    local equipamento = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

    if act.target.components.dislodgeable and act.target.components.dislodgeable.canbedislodged and act.target.components.dislodgeable.caninteractwith then
        if act.doer ~= nil and equipamento then
            if equipamento.components.finiteuses then
                equipamento.components.finiteuses:Use(1)
            end

            if equipamento and equipamento:HasTag("ballpein_hammer") then
                if act.target.components.dislodgeable then
                    act.target.components.dislodgeable:Dislodge(act.doer)
                end
                return true
            end
        end
    else
        return false
    end
end
AddAction(DISLODGE)


local PAINT = Action({ priority = 10, rmb = true, distance = 2, mount_valid = false })
PAINT.str = (STRINGS.ACTIONS.PAINT)
PAINT.id = "PAINT"
PAINT.fn = function(act)
    local equipamento = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if act.doer ~= nil and equipamento then
        if equipamento.components.finiteuses then
            equipamento.components.finiteuses:Use(1)
        end

        if equipamento and equipamento:HasTag("shop_wall_checkered_metal") then
            act.target.AnimState:SetBank("wallhamletcity1")
            act.target.AnimState:SetBuild("wallhamletcity1")
            act.target.AnimState:PlayAnimation("shop_wall_checkered_metal", true)
            act.target.wallpaper = "shop_wall_checkered_metal"
            return true
        end

        if equipamento and equipamento:HasTag("shop_wall_circles") then
            act.target.AnimState:SetBank("wallhamletcity1")
            act.target.AnimState:SetBuild("wallhamletcity1")
            act.target.AnimState:PlayAnimation("shop_wall_circles", true)
            act.target.wallpaper = "shop_wall_circles"
            return true
        end

        if equipamento and equipamento:HasTag("shop_wall_marble") then
            act.target.AnimState:SetBank("wallhamletcity1")
            act.target.AnimState:SetBuild("wallhamletcity1")
            act.target.AnimState:PlayAnimation("shop_wall_marble", true)
            act.target.wallpaper = "shop_wall_marble"
            return true
        end

        if equipamento and equipamento:HasTag("shop_wall_sunflower") then
            act.target.AnimState:SetBank("wallhamletcity1")
            act.target.AnimState:SetBuild("wallhamletcity1")
            act.target.AnimState:PlayAnimation("shop_wall_sunflower", true)
            act.target.wallpaper = "shop_wall_sunflower"
            return true
        end

        if equipamento and equipamento:HasTag("shop_wall_woodwall") then
            act.target.AnimState:SetBank("wallhamletcity1")
            act.target.AnimState:SetBuild("wallhamletcity1")
            act.target.AnimState:PlayAnimation("shop_wall_woodwall", true)
            act.target.wallpaper = "shop_wall_woodwall"
            return true
        end

        if equipamento and equipamento:HasTag("wall_mayorsoffice_whispy") then
            act.target.AnimState:SetBank("wallhamletcity1")
            act.target.AnimState:SetBuild("wallhamletcity1")
            act.target.AnimState:PlayAnimation("wall_mayorsoffice_whispy", true)
            act.target.wallpaper = "wall_mayorsoffice_whispy"
            return true
        end

        if equipamento and equipamento:HasTag("harlequin_panel") then
            act.target.AnimState:SetBank("wallhamletcity2")
            act.target.AnimState:SetBuild("wallhamletcity2")
            act.target.AnimState:PlayAnimation("harlequin_panel", true)
            act.target.wallpaper = "harlequin_panel"
            return true
        end

        if equipamento and equipamento:HasTag("shop_wall_fullwall_moulding") then
            act.target.AnimState:SetBank("wallhamletcity2")
            act.target.AnimState:SetBuild("wallhamletcity2")
            act.target.AnimState:PlayAnimation("shop_wall_fullwall_moulding", true)
            act.target.wallpaper = "shop_wall_fullwall_moulding"
            return true
        end

        if equipamento and equipamento:HasTag("shop_wall_floraltrim2") then
            act.target.AnimState:SetBank("wallhamletcity2")
            act.target.AnimState:SetBuild("wallhamletcity2")
            act.target.AnimState:PlayAnimation("shop_wall_floraltrim2", true)
            act.target.wallpaper = "shop_wall_floraltrim2"
            return true
        end

        if equipamento and equipamento:HasTag("shop_wall_upholstered") then
            act.target.AnimState:SetBank("wallhamletcity2")
            act.target.AnimState:SetBuild("wallhamletcity2")
            act.target.AnimState:PlayAnimation("shop_wall_upholstered", true)
            act.target.wallpaper = "shop_wall_upholstered"
            return true
        end



        if equipamento and equipamento:HasTag("floor_cityhall") then
            act.target.AnimState:PlayAnimation("floor_cityhall", true)
            act.target.floorpaper = "floor_cityhall"
            return true
        end

        if equipamento and equipamento:HasTag("noise_woodfloor") then
            act.target.AnimState:PlayAnimation("noise_woodfloor", true)
            act.target.floorpaper = "noise_woodfloor"
            return true
        end

        if equipamento and equipamento:HasTag("shop_floor_checker") then
            act.target.AnimState:PlayAnimation("shop_floor_checker", true)
            act.target.floorpaper = "shop_floor_checker"
            return true
        end

        if equipamento and equipamento:HasTag("shop_floor_herringbone") then
            act.target.AnimState:PlayAnimation("shop_floor_herringbone", true)
            act.target.floorpaper = "shop_floor_herringbone"
            return true
        end

        if equipamento and equipamento:HasTag("shop_floor_hexagon") then
            act.target.AnimState:PlayAnimation("shop_floor_hexagon", true)
            act.target.floorpaper = "shop_floor_hexagon"
            return true
        end

        if equipamento and equipamento:HasTag("shop_floor_octagon") then
            act.target.AnimState:PlayAnimation("shop_floor_octagon", true)
            act.target.floorpaper = "shop_floor_octagon"
            return true
        end

        if equipamento and equipamento:HasTag("shop_floor_sheetmetal") then
            act.target.AnimState:PlayAnimation("shop_floor_sheetmetal", true)
            act.target.floorpaper = "shop_floor_sheetmetal"
            return true
        end

        if equipamento and equipamento:HasTag("shop_floor_woodmetal") then
            act.target.AnimState:PlayAnimation("shop_floor_woodmetal", true)
            act.target.floorpaper = "shop_floor_woodmetal"
            return true
        end

        if equipamento and equipamento:HasTag("shop_floor_hoof_curvy") then
            act.target.AnimState:PlayAnimation("shop_floor_hoof_curvy", true)
            act.target.floorpaper = "shop_floor_hoof_curvy"
            return true
        end

        if equipamento and equipamento:HasTag("shop_floor_woodpaneling2") then
            act.target.AnimState:PlayAnimation("shop_floor_woodpaneling2", true)
            act.target.floorpaper = "shop_floor_woodpaneling2"
            return true
        end
    end
end

AddAction(PAINT)

local SMELT = Action({ priority = 10, mount_valid = true })
SMELT.str = (STRINGS.ACTIONS.SMELT)
SMELT.id = "SMELT"
SMELT.fn = function(act)
    if act.target.components.melter then
        act.target.components.melter:StartCooking()
        return true
    end
end
AddAction(SMELT)

local GIVE2 = Action({ priority = 10, distance = 2, mount_valid = true })
GIVE2.str = (STRINGS.ACTIONS.GIVE)
GIVE2.id = "GIVE2"
GIVE2.fn = function(act)
    if act.invobject.components.inventoryitem then
        act.target.components.shelfer:AcceptGift(act.doer, act.invobject)
        return true
    end
end
AddAction(GIVE2)



local function ExtraPickupRange(doer, dest)
    if dest ~= nil then
        local target_x, target_y, target_z = dest:GetPoint()

        local is_on_water = TheWorld.Map:IsOceanTileAtPoint(target_x, 0, target_z) and
            not TheWorld.Map:IsPassableAtPoint(target_x, 0, target_z)
        if is_on_water then
            return 0.75
        end
    end
    return 0
end

local PICKUP = Action({ priority = 1, distance = 2, extra_arrive_dist = ExtraPickupRange, mount_valid = true })
PICKUP.str = (STRINGS.ACTIONS.PICKUP)
PICKUP.id = "PICKUP"
PICKUP.fn = function(act)
    if act.target and act.target.components.inventoryitem and act.target.components.shelfer then
        local item = act.target.components.shelfer:GetGift()
        if item then
            -- if act.target.components.shelfer.shelf and not act.target.components.shelfer.shelf:HasTag("playercrafted") then
            --     if act.doer.components.shopper and act.doer.components.shopper:IsWatching(item) then
            --         if act.doer.components.shopper:CanPayFor(item) then
            --             act.doer.components.shopper:PayFor(item)
            --         else
            --             return false, "CANTPAY"
            --         end
            --     else
            --         if act.target.components.shelfer.shelf and act.target.components.shelfer.shelf.curse then
            --             act.target.components.shelfer.shelf.curse(act.target)
            --         end
            --     end
            -- end
            if item.components.perishable then item.components.perishable:StartPerishing() end
            act.target = act.target.components.shelfer:GiveGift()
        end
    end

    if act.doer.components.inventory ~= nil and
        act.target ~= nil and
        act.target.components.inventoryitem ~= nil and
        (act.target.components.inventoryitem.canbepickedup or
            (act.target.components.inventoryitem.canbepickedupalive and not act.doer:HasTag("player")) or
            act.target.components.inventoryitem.grabbableoverridetag ~= nil and act.doer:HasTag(act.target.components.inventoryitem.grabbableoverridetag)
        ) and
        not (act.target:IsInLimbo() or
            (act.target.components.burnable ~= nil and act.target.components.burnable:IsBurning() and act.target.components.lighter == nil) or
            (act.target.components.projectile ~= nil and act.target.components.projectile:IsThrown())) then
        if act.doer.components.itemtyperestrictions ~= nil and not act.doer.components.itemtyperestrictions:IsAllowed(act.target) then
            return false, "restriction"
        elseif act.target.components.container ~= nil and act.target.components.container:IsOpenedByOthers(act.doer) then
            return false, "INUSE"
        elseif (act.target.components.yotc_racecompetitor ~= nil and act.target.components.entitytracker ~= nil) then
            local trainer = act.target.components.entitytracker:GetEntity("yotc_trainer")
            if trainer ~= nil and trainer ~= act.doer then
                return false, "NOTMINE_YOTC"
            end
        elseif act.doer.components.inventory.noheavylifting and act.target:HasTag("heavy") then
            return false, "NO_HEAVY_LIFTING"
        end

        if (act.target:HasTag("spider") and act.doer:HasTag("spiderwhisperer")) and
            (act.target.components.follower.leader ~= nil and act.target.components.follower.leader ~= act.doer) then
            return false, "NOTMINE_SPIDER"
        end
        if act.target.components.curseditem and not act.target.components.curseditem:checkplayersinventoryforspace(act.doer) then
            return false, "FULL_OF_CURSES"
        end

        if act.target.components.inventory ~= nil and act.target:HasTag("drop_inventory_onpickup") then
            act.target.components.inventory:TransferInventory(act.doer)
        end

        act.doer:PushEvent("onpickupitem", { item = act.target })

        if act.target.components.equippable ~= nil and not act.target.components.equippable:IsRestricted(act.doer) then
            local equip = act.doer.components.inventory:GetEquippedItem(act.target.components.equippable.equipslot)
            if equip ~= nil and not act.target.components.inventoryitem.cangoincontainer then
                --special case for trying to carry two backpacks
                if equip.components.inventoryitem ~= nil and equip.components.inventoryitem.cangoincontainer then
                    --act.doer.components.inventory:SelectActiveItemFromEquipSlot(act.target.components.equippable.equipslot)
                    act.doer.components.inventory:GiveItem(act.doer.components.inventory:Unequip(act.target.components
                        .equippable.equipslot))
                else
                    act.doer.components.inventory:DropItem(equip)
                end
                act.doer.components.inventory:Equip(act.target)
                return true
            elseif act.doer:HasTag("player") then
                if equip == nil or act.doer.components.inventory:GetNumSlots() <= 0 then
                    act.doer.components.inventory:Equip(act.target)
                    return true
                elseif GetGameModeProperty("non_item_equips") then
                    act.doer.components.inventory:DropItem(equip)
                    act.doer.components.inventory:Equip(act.target)
                    return true
                end
            end
        end

        act.doer.components.inventory:GiveItem(act.target, nil, act.target:GetPosition())
        return true
    end
end
AddAction(PICKUP)


-- local HARVEST1 = Action({ priority = 10, mount_valid = true })
-- HARVEST1.str = (STRINGS.ACTIONS.HARVEST1)
-- HARVEST1.id = "HARVEST1"
-- HARVEST1.fn = function(act)
--     if act.target.components.melter then
--         return act.target.components.melter:Harvest(act.doer)
--     end
-- end
-- AddAction(HARVEST1)
local old_HARVEST_fn = ACTIONS.HARVEST.fn
ACTIONS.HARVEST.fn = function(act)
    if act.target.components.melter then return act.target.components.melter:Harvest(act.doer) end
    return old_HARVEST_fn(act)
end


local PAN = Action({ priority = 10, mount_valid = true })
PAN.str = (STRINGS.ACTIONS.PAN)
PAN.id = "PAN"
PAN.fn = function(act)
    if act.target.components.workable and act.target.components.workable.action == ACTIONS.PAN then
        local numworks = 1

        if act.invobject and act.invobject.components.tool then
            numworks = act.invobject.components.tool:GetEffectiveness(ACTIONS.PAN)
        elseif act.doer and act.doer.components.worker then
            numworks = act.doer.components.worker:GetEffectiveness(ACTIONS.PAN)
        end
        act.target.components.workable:WorkedBy(act.doer, numworks)
    end
    return true
end
AddAction(PAN)


local INVESTIGATEGLASS = Action({ priority = 10, mount_valid = true })
INVESTIGATEGLASS.str = (STRINGS.ACTIONS.INVESTIGATEGLASS)
INVESTIGATEGLASS.id = "INVESTIGATEGLASS"
INVESTIGATEGLASS.fn = function(act)
    if act.target:HasTag("secret_room") then
        act.target.Investigate(act.doer)
        return true
    end

    if act.target and act.target.components.mystery then
        act.target.components.mystery:Investigate(act.doer)

        local equipamento = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if act.doer ~= nil and equipamento then
            equipamento.components.finiteuses:Use(1)
        end

        return true
    end
end
AddAction(INVESTIGATEGLASS)


local function DoToolWork(act, workaction)
    if
        act.target.components.workable ~= nil and act.target.components.workable:CanBeWorked() and
        act.target.components.workable.action == workaction
    then
        if act.target:HasTag("grass_tall") then
            local equipamento = act.doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equipamento and equipamento.prefab == "shears" then
                local x, y, z = act.target.Transform:GetWorldPosition()
                local gramaextra = SpawnPrefab("cutgrass")
                if gramaextra then gramaextra.Transform:SetPosition(x, y, z) end
            end
        end

        if act.target:HasTag("hedgetoshear") then
            local equipamento = act.doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equipamento and equipamento.prefab == "shears" then
                local x, y, z = act.target.Transform:GetWorldPosition()
                local gramaextra = SpawnPrefab("clippings")
                if gramaextra then gramaextra.Transform:SetPosition(x, y, z) end
            end
        end

        if act.target:HasTag("hangingvine") then
            local equipamento = act.doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equipamento and equipamento.prefab == "shears" then
                local x, y, z = act.target.Transform:GetWorldPosition()
                act.target:DoTaskInTime(1, function()
                    local gramaextra = SpawnPrefab("rope")
                    if gramaextra then gramaextra.Transform:SetPosition(x, y, z) end
                end)
            end
        end

        act.target.components.workable:WorkedBy(
            act.doer,
            (act.invobject ~= nil and act.invobject.components.tool ~= nil and
                act.invobject.components.tool:GetEffectiveness(workaction)) or
            (act.doer ~= nil and act.doer.components.worker ~= nil and
                act.doer.components.worker:GetEffectiveness(workaction)) or
            1
        )
    end
    return true
end

local HACK = Action({ priority = 10, mount_valid = true })
HACK.str = (STRINGS.ACTIONS.HACK)
HACK.id = "HACK"
HACK.fn = function(act, ...)
    return DoToolWork(act, ACTIONS.HACK)
end
AddAction(HACK)

local HACK1 = Action({ priority = 10, mount_valid = true })
HACK1.str = (STRINGS.ACTIONS.HACK)
HACK1.id = "HACK1"
HACK1.fn = function(act, ...)
    local equipamento = act.doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if equipamento and equipamento.components.finiteuses then
        equipamento.components.finiteuses:Use(1)
    end
    local numworks = 1
    if equipamento and equipamento.components.tool then
        numworks = equipamento.components.tool:GetEffectiveness(ACTIONS.HACK)
    elseif act.doer and act.doer.components.worker then
        numworks = act.doer.components.worker:GetEffectiveness(ACTIONS.HACK)
    end
    if equipamento and equipamento.components.obsidiantool then
        equipamento.components.obsidiantool:Use(act.doer, act.target)
    end
    if act.target and act.target.components.hackable then
        act.target.components.hackable:Hack(act.doer, numworks)
        return true
    end
    if act.target and act.target.components.workable and act.target.components.workable.action == ACTIONS.HACK then
        act.target.components.workable:WorkedBy(act.doer, numworks)
        return true
    end
    --    return DoToolWork(act, ACTIONS.HACK)
end
AddAction(HACK1)



local GAS = Action({ priority = 10, distance = 3, mount_valid = true })
GAS.str = (STRINGS.ACTIONS.GAS)
GAS.id = "GAS"
GAS.fn = function(act)
    if act.invobject and act.invobject.components.gasser then
        act.invobject.components.gasser:Gas(act:GetActionPoint())
        return true
    end
end
AddAction(GAS)


local ACTIVATESAIL = Action({ priority = 10, mount_valid = true })
ACTIVATESAIL.str = (STRINGS.ACTIONS.LANTERNON)
ACTIVATESAIL.id = "ACTIVATESAIL"
ACTIVATESAIL.fn = function(act)
    if act.doer ~= nil and act.invobject:HasTag("boatlight") then
        act.invobject:AddTag("ligado")
    end
    return true
end
AddAction(ACTIVATESAIL)

local COMPACTPOOP = Action({ priority = 10, mount_valid = true })
COMPACTPOOP.str = "Compact Poop"
COMPACTPOOP.id = "COMPACTPOOP"
COMPACTPOOP.fn = function(act)
    if act.invobject.components.stackable and act.invobject.components.stackable.stacksize > 1 then
        local nut = act.invobject.components.stackable:Get()
        nut:Remove()
    else
        act.invobject:Remove()
    end
    act.doer.components.inventory:GiveItem(SpawnPrefab("poop2"))
    return true
end
AddAction(COMPACTPOOP)

local DESACTIVATESAIL = Action({ priority = 10, mount_valid = true })
DESACTIVATESAIL.str = (STRINGS.ACTIONS.LANTERNOFF)
DESACTIVATESAIL.id = "DESACTIVATESAIL"
DESACTIVATESAIL.fn = function(act)
    if act.doer ~= nil and act.invobject:HasTag("boatlight") then
        act.invobject:RemoveTag("ligado")
    end
    return true
end
AddAction(DESACTIVATESAIL)

-- 渡渡羽毛扇摇扇动作写死在sg里了，没留overridebuild，勾一下
AddStategraphPostInit("wilson", function(sg)
    local old_enter = sg.states["use_fan"].onenter
    sg.states["use_fan"].onenter = function (inst, ...)
        old_enter(inst, ...)
        local invobject = nil
        if inst.bufferedaction ~= nil then
            invobject = inst.bufferedaction.invobject
        end
        local src_symbol = invobject ~= nil and invobject.components.fan ~= nil and invobject.components.fan.overridesymbol
        if src_symbol == "fan01" then
            inst.AnimState:OverrideSymbol( "fan01", "fan_tropical", src_symbol )
        end
    end
end)