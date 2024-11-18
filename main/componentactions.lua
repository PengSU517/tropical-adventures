local AddComponentAction = AddComponentAction
local ACTIONS = ACTIONS

-------------ATTENTION!!!!!addcomponentaction  同目录会相互覆盖
AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if not right then
        if target:HasTag("shelfcanaccept") then --target.components.shelfer and target.components.shelfer:CanAccept(inst, doer ) then
            table.insert(actions, ACTIONS.GIVE2)
        end
    end
end)


AddComponentAction("SCENE", "hackable", function(inst, doer, actions, right)
    local equipamento = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if not right then
        if equipamento and equipamento:HasTag("machete") and not (doer.replica.rider:IsRiding() or doer:HasTag("bonked")) then --and equipamento.components.hackable then --and inst.components.hackable.canbehacked then
            table.insert(actions, ACTIONS.HACK1)
        end
    end

    if right then
        if doer:HasTag("ironlord") then
            table.insert(actions, ACTIONS.HACK1)
        end
    end
end)


AddComponentAction("SCENE", "melter", function(inst, doer, actions, right)
    if not inst:HasTag("burnt") then
        if right and not inst:HasTag("alloydone") and inst.replica.container ~= nil and inst.replica.container:IsFull() then
            table.insert(actions, ACTIONS.SMELT)
        elseif not right and inst:HasTag("alloydone") then
            table.insert(actions, ACTIONS.HARVEST1)
        end
    end
end)



AddComponentAction("SCENE", "workable", function(inst, doer, actions, right)
    if right and doer:HasTag("ironlord") then
        if inst:HasTag("tree") then
            table.insert(actions, ACTIONS.CHOP)
        end

        if inst:HasTag("bush_vine") or inst:HasTag("bambootree") then
            table.insert(actions, ACTIONS.HACK)
        end

        if inst:HasTag("boulder") then
            table.insert(actions, ACTIONS.MINE)
        end

        if inst:HasTag("structure") then
            table.insert(actions, ACTIONS.HAMMER)
        end
    end
end)

-------------------------------------------
AddComponentAction("SCENE", "dislodgeable", function(inst, doer, actions, right)
    local equipamento = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if not right then
        if equipamento and equipamento:HasTag("ballpein_hammer") and inst:HasTag("dislodgeable") and not (doer.replica.rider:IsRiding() or doer:HasTag("bonked")) then
            table.insert(actions, ACTIONS.DISLODGE)
            -- print("addcomponent action aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
            -- print(equipamento.prefab)
            -- print(inst.prefab)
            return
        end
    end
end)


AddComponentAction("SCENE", "mystery", function(inst, doer, actions, right)
    if not right then
        local equipamento = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if equipamento and equipamento:HasTag("magnifying_glass") and not (doer.replica.rider:IsRiding() or doer:HasTag("bonked")) then
            table.insert(actions, ACTIONS.INVESTIGATEGLASS)
        end
    end
end)


AddComponentAction(
    "SCENE",
    "interactions",
    function(inst, doer, actions, right)
        local equipamento = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        --local rightrect = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        --  and doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.reticule ~= nil or nil
        if right then
            if equipamento and equipamento:HasTag("boatrepairkit") and doer:HasTag("aquatic") then
                table.insert(actions, ACTIONS.BOATREPAIR)
                return
            end

            if inst:HasTag("boatsw") and not inst:HasTag("ocupado") and
                not (doer.replica.rider:IsRiding() or
                    doer:HasTag("bonked"))
            then
                table.insert(actions, ACTIONS.BOATMOUNT)
            end
        end

        if not right then
            if inst:HasTag("boatsw") and not inst:HasTag("ocupado") and
                not (doer.replica.rider:IsRiding() or
                    doer:HasTag("bonked"))
            then
                table.insert(actions, ACTIONS.BOATMOUNT)
            end



            if inst.prefab == "surfboard" and not inst:HasTag("ocupado") and not doer.replica.inventory:IsFull() then
                table.insert(actions, ACTIONS.RETRIEVE)
                return
            end

            if inst.prefab == "corkboat" and not inst:HasTag("ocupado") and not doer.replica.inventory:IsFull() then
                table.insert(actions, ACTIONS.RETRIEVE)
                return
            end

            if inst.prefab == "fish_farm" then
                table.insert(actions, ACTIONS.RETRIEVE)
                return
            end

            -- if inst:HasTag("wallhousehamlet") and equipamento and equipamento:HasTag("hameletwallpaper") then
            --     table.insert(actions, ACTIONS.PAINT)
            --     return
            -- end

            if inst:HasTag("pisohousehamlet") and equipamento and equipamento:HasTag("hameletfloor") then
                table.insert(actions, ACTIONS.PAINT)
                return
            end
        end
    end
)


AddComponentAction(
    "INVENTORY",
    "interactions",
    function(inst, doer, actions)
        if inst:HasTag("boatlight") and inst:HasTag("nonavio") and not inst:HasTag("ligado") then --and inst:HasTag("nonavio")
            table.insert(actions, ACTIONS.ACTIVATESAIL)
        end
        if inst:HasTag("boatlight") and inst:HasTag("ligado") then
            table.insert(actions, ACTIONS.DESACTIVATESAIL)
        end

        if inst:HasTag("boatrepairkit") then
            table.insert(actions, ACTIONS.BOATREPAIR)
        end

        if inst:HasTag("tunacan") then
            table.insert(actions, ACTIONS.OPENTUNA)
        end

        if inst:HasTag("pooptocompact") and doer:HasTag("wilbur") then
            table.insert(actions, ACTIONS.COMPACTPOOP)
        end
    end)

AddComponentAction(
    "SCENE",
    "health",
    function(inst, doer, actions, right)
        local containedsail = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
        if right and doer:HasTag("aquatic") and containedsail and containedsail.replica.container and containedsail.replica.container:GetItemInSlot(2) ~= nil and containedsail.replica.container:GetItemInSlot(2):HasTag("boatcannon") and
            not (doer.replica.rider:IsRiding() or doer.replica.inventory:IsHeavyLifting() or doer:HasTag("bonked") or doer:HasTag("deleidotiro")) then
            table.insert(actions, ACTIONS.BOATCANNON)
        end



        if not right and doer:HasTag("ironlord") and
            inst.replica.health ~= nil and not inst.replica.health:IsDead() and
            inst.replica.combat ~= nil and inst.replica.combat:CanBeAttacked(doer) then
            table.insert(actions, ACTIONS.ATTACK)
        end

        if TheWorld.ismastersim then
            if right and doer:HasTag("ironlord") and not inst:HasTag("ironlord") and
                inst.replica.health ~= nil and not inst.replica.health:IsDead() and
                inst.replica.combat ~= nil and inst.replica.combat:CanBeAttacked(doer) then
                table.insert(actions, ACTIONS.TIRO)
            end
        end
    end)

AddComponentAction("SCENE", "shopped", function(inst, doer, actions, right)
    if not right then
        if doer.components.shopper then --and inst.components.shopdispenser and inst.components.shopdispenser.item_served then
            table.insert(actions, ACTIONS.SHOP)
        end
    end
end)

AddComponentAction("POINT", "gasser", function(inst, doer, pos, actions, right)
    if right and not (doer.replica.rider:IsRiding() or doer:HasTag("bonked")) then
        table.insert(actions, ACTIONS.GAS)
    end
end)

AddComponentAction("SCENE", "poisonable", function(inst, doer, actions, right)
    if right then
        local equipamento = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if equipamento and equipamento:HasTag("bugrepellent") and not (doer.replica.rider:IsRiding() or doer:HasTag("bonked")) then
            table.insert(actions, ACTIONS.GAS)
        end
    end
end)

local function boatdismon(inst, doer, pos, actions, right, target)
    local xjp, yjp, zjp = pos:Get()
    local xs, ys, zs = doer.Transform:GetWorldPosition()
    local dist = math.sqrt((xjp - xs) * (xjp - xs) + (zjp - zs) * (zjp - zs))
    local rightrect =
        doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO) and
        doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO).components.reticule ~= nil or
        nil
    local terraformer =
        doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO) and
        doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO).components.terraformer ~= nil or
        nil

    local containedsail = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.BARCO)
    if right and doer:HasTag("aquatic") and containedsail and containedsail.replica.container and containedsail.replica.container:GetItemInSlot(2) ~= nil and containedsail.replica.container:GetItemInSlot(2):HasTag("boatcannon") and
        not (doer.replica.rider:IsRiding() or doer.replica.inventory:IsHeavyLifting() or doer:HasTag("bonked") or doer:HasTag("deleidotiro")) then
        return table.insert(actions, ACTIONS.BOATCANNON)
    end

    if not right and rightrect == nil and terraformer == nil and doer:HasTag("aquatic") and
        TheWorld.Map:IsPassableAtPoint(pos:Get()) and not (doer.replica.rider:IsRiding() or doer:HasTag("bonked"))
    then
        table.insert(actions, ACTIONS.BOATDISMOUNT)
    end


    if right and rightrect == nil and terraformer == nil and dist <= 20 then
        local doer_x, doer_y, doer_z = doer.Transform:GetWorldPosition()
        local planchadesurf = TheWorld.Map:GetPlatformAtPoint(doer_x, doer_z)
        if planchadesurf and planchadesurf:HasTag("planchadesurf") then
            table.insert(actions, ACTIONS.SURF)
        end
    end
end

AddComponentAction("POINT", "equippable", boatdismon)


AddComponentAction("USEITEM", "fueltar", function(inst, doer, target, actions)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
        or (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)) then
        if target:HasTag("seayard") then
            table.insert(actions, ACTIONS.ADDFUEL)
        end

        if target:HasTag("tarlamp") then
            table.insert(actions, ACTIONS.ADDFUEL)
        end

        if target:HasTag("tarsuit") then
            table.insert(actions, ACTIONS.ADDFUEL)
        end

        -- if target:HasTag("wallhousehamlet") and inst:HasTag("hameletwallpaper") then
        --     table.insert(actions, ACTIONS.PAINT)
        --     return
        -- end
    end
end)


-- AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions)
--     print("addcomponentactionpaint")
--     if target:HasTag("wallhousehamlet") and inst:HasTag("hameletwallpaper") then
--         table.insert(actions, ACTIONS.PAINT)
--         return
--     end
-- end)
