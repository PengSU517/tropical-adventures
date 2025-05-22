local AddComponentAction = AddComponentAction
local ACTIONS = ACTIONS

-------------ATTENTION!!!!!addcomponentaction  同目录会相互覆盖

AddComponentAction("SCENE", "hackable", function(inst, doer, actions, right)
    local equipamento = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if not right then
        if equipamento and equipamento:HasTag("machete") and not (doer.replica.rider:IsRiding()) then
            table.insert(actions, ACTIONS.HACK1)
        end
    end
end)


AddComponentAction("SCENE", "melter", function(inst, doer, actions, right)
    if not inst:HasTag("burnt") then
        if right and not inst:HasTag("alloydone") and inst.replica.container ~= nil and inst.replica.container:IsFull() then
            table.insert(actions, ACTIONS.SMELT)
        elseif not right and inst:HasTag("alloydone") then
            table.insert(actions, ACTIONS.HARVEST)
        end
    end
end)

-------------------------------------------
AddComponentAction("SCENE", "dislodgeable", function(inst, doer, actions, right)
    local equipamento = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if not right then
        if equipamento and equipamento:HasTag("ballpein_hammer") and inst:HasTag("dislodgeable") and
            not (doer.replica.rider:IsRiding()) then
            table.insert(actions, ACTIONS.DISLODGE)

            return
        end
    end
end)

AddComponentAction("SCENE", "breeder", function(inst, doer, actions, right)
    if not right then
        if inst.components.breeder and inst.components.breeder.volume > 0 then
            table.insert(actions, ACTIONS.HARVEST)
            return
        end
    end
end)


AddComponentAction("SCENE", "mystery", function(inst, doer, actions, right)
    if not right then
        local equipamento = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if equipamento and equipamento:HasTag("magnifying_glass") and
            not (doer.replica.rider:IsRiding()) then
            table.insert(actions, ACTIONS.INVESTIGATEGLASS)
        end
    end
end)


AddComponentAction("SCENE", "interactions", function(inst, doer, actions, right)
    if not right then
        if inst:HasTag("boatsw") and not inst:HasTag("boat_occupied") and
            not (doer.replica.rider:IsRiding())
        then
            table.insert(actions, ACTIONS.BOATMOUNT)
        end
    else
        if not inst:HasTag("boat_occupied") and (inst.prefab == "surfboard" or inst.prefab == "corkboat")
        then
            table.insert(actions, ACTIONS.RETRIEVE)
        end
    end
end
)

AddComponentAction("SCENE", "health",
    function(inst, doer, actions, right)
        local containedsail = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
        if right and doer:HasTag("aquatic") and containedsail and containedsail.replica.container and
            containedsail.replica.container:GetItemInSlot(2) ~= nil and containedsail.replica.container:GetItemInSlot(2):HasTag("boatcannon") and
            not (doer.replica.rider:IsRiding() or doer.replica.inventory:IsHeavyLifting() or doer:HasTag("deleidotiro")) then
            table.insert(actions, ACTIONS.BOATCANNON)
        end
    end)

AddComponentAction("SCENE", "shopped", function(inst, doer, actions, right)
    if not right then
        if doer.components.shopper then
            table.insert(actions, ACTIONS.SHOP)
        end
    end
end)


AddComponentAction("USEITEM", "interactions",
    function(inst, doer, target, actions, right)
        if inst:HasTag("boatrepairkit") and (target:HasTag("boatsw") or target:HasTag("boat_proxy")) then
            table.insert(actions, ACTIONS.BOATREPAIR)
        end
    end)

AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if not right then
        if target:HasTag("shelfcanaccept") then
            table.insert(actions, ACTIONS.GIVE2)
        end
    end
end)

AddComponentAction("USEITEM", "fuel", function(inst, doer, target, actions, right)
    if not target.components.container then return end
    if right then
        if inst:HasTag("ANCIENT_REMNANT_fuel") and
            target:HasTag("ANCIENT_REMNANT_fueled") then
            RemoveByValue(actions, ACTIONS.STORE)
        end
    else
        if target.components.inventoryitem and not target:IsInLimbo() then
            RemoveByValue(actions, ACTIONS.ADDFUEL)
        end
    end
end)

AddComponentAction("INVENTORY", "interactions", function(inst, doer, actions)
    if inst:HasTag("boatlight") and not inst:HasTag("ligado") and
        inst.components.inventoryitem.owner and inst.components.inventoryitem.owner:HasTag("boatsw") then --and inst:HasTag("nonavio")
        table.insert(actions, ACTIONS.ACTIVATESAIL)
    elseif inst:HasTag("boatlight") and inst:HasTag("ligado") and
        inst.components.inventoryitem.owner and inst.components.inventoryitem.owner:HasTag("boatsw") then
        table.insert(actions, ACTIONS.DESACTIVATESAIL)
    elseif inst:HasTag("tunacan") then
        table.insert(actions, ACTIONS.OPENTUNA) ----这个需要修改
    end
end)


AddComponentAction("EQUIPPED", "gasser", function(inst, doer, target, actions, right)
    if right and not (doer.replica.rider:IsRiding() or doer:HasTag("bonked")) then
        table.insert(actions, ACTIONS.GAS)
    end
end)

AddComponentAction("POINT", "gasser", function(inst, doer, pos, actions, right)
    if right then
        table.insert(actions, ACTIONS.GAS)
    end
end)

AddComponentAction("POINT", "equippable", function(inst, doer, pos, actions, right, target)
    if not doer:HasTag("aquatic") then return end

    if right then
        local containedsail = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
        if containedsail and containedsail.replica.container and
            containedsail.replica.container:GetItemInSlot(2) ~= nil and
            containedsail.replica.container:GetItemInSlot(2):HasTag("boatcannon") and
            not (doer.replica.inventory:IsHeavyLifting() or doer:HasTag("deleidotiro")) then
            return table.insert(actions, ACTIONS.BOATCANNON)
        end
    else
        if TheWorld.Map:IsPassableAtPoint(pos:Get()) then
            table.insert(actions, ACTIONS.BOATDISMOUNT)
        end
    end

    --ACTIONS.SURF完全触发不了啊
end)
