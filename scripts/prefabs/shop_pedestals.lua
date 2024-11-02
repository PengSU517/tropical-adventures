-- shop_interior
local assets =
{
    --Asset("ANIM", "anim/store_items.zip"),
    Asset("ANIM", "anim/pedestal_crate.zip"),
}


local shopdefs = require("datadefs/pig_shop_defs").SHOPTYPES
local prefabs = {}

local function shopkeeper_speech(inst, speech)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 20, { "shopkeep" })
    for i, ent in ipairs(ents) do
        ent.shopkeeper_speech(ent, speech)
        --ent.components.talker:Say(speech)
    end
end

local function SetImage(inst, ent)
    local src = ent
    local image = nil

    if src ~= nil and src.components.inventoryitem ~= nil then
        image = src.prefab
        if src.components.inventoryitem.imagename then
            image = src.components.inventoryitem.imagename
        end
    end

    if image ~= nil then
        local texname = image .. ".tex"
        local atlas = src.replica.inventoryitem:GetAtlas()
        inst.AnimState:OverrideSymbol("SWAP_SIGN", atlas, texname)
        inst.imagename = image
    else
        inst.imagename = ""
        inst.AnimState:ClearOverrideSymbol("SWAP_SIGN")
    end
end

local function SetImageFromName(inst, name)
    local image = name

    if image ~= nil then
        local texname = image .. ".tex"
        local atlas = GetInventoryItemAtlas(texname)
        inst.AnimState:OverrideSymbol("SWAP_SIGN", atlas, texname)
        inst.imagename = image
    else
        inst.imagename = ""
        inst.AnimState:ClearOverrideSymbol("SWAP_SIGN")
    end
end

local function SetCost(inst, costprefab, cost)
    local image = costprefab or nil

    if costprefab == "oinc" and cost then
        image = "cost-" .. cost
    end

    if image ~= nil then
        local texname = image .. ".tex"
        local atlas = GetInventoryItemAtlas(texname)
        inst.AnimState:OverrideSymbol("SWAP_COST", atlas, texname)
        inst.costimagename = image
    else
        inst.costimagename = ""
        inst.AnimState:ClearOverrideSymbol("SWAP_COST")
    end
end

local function SpawnInventory(inst, prefabtype, costprefab, cost)
    inst.costprefab = costprefab
    inst.cost = cost

    local item = nil
    if prefabtype ~= nil then
        item = SpawnPrefab(prefabtype)
    else
        item = SpawnPrefab(inst.prefabtype)
    end

    if item ~= nil then
        inst:SetImage(item)
        inst:SetCost(costprefab, cost)
        item.prefab = prefabtype
        inst.components.shopdispenser:SetItem(item)
        item:Remove()
    end
end


local function TimedInventory(inst, prefabtype)
    inst.prefabtype = prefabtype
    local time = 300 + math.random() * 300
    inst.components.shopdispenser:RemoveItem()
    inst:SetImage(nil)
    inst:DoTaskInTime(time, function() inst:SpawnInventory(nil) end)
end

local function SoldItem(inst)
    inst.components.shopdispenser:RemoveItem()
    inst:SetImage(nil)
end

local function restock(inst, force)
    if inst:HasTag("nodailyrestock") then
        --        print("NO DAILY RESTOCK")
        return
    elseif inst:HasTag("robbed") then
        inst.costprefab = "cost-nil"
        SetCost(inst, "cost-nil")
        shopkeeper_speech(inst, STRINGS.CITY_PIG_SHOPKEEPER_ROBBED[math.random(1, #STRINGS.CITY_PIG_SHOPKEEPER_ROBBED)])
    elseif not inst:HasTag("justsellonce") or force then
        --        print("CHANGING ITEM")



        local newproduct
        if type(inst.shoptype) == "string" then
            newproduct = GetRandomItem(shopdefs[inst.shoptype])
        elseif type(inst.shoptype) == "table" then
            newproduct = GetRandomItem(inst.shoptype)
        end

        if inst.saleitem then
            newproduct = inst.saleitem
        end

        local vendendor = GetClosestInstWithTag("shopkeep", inst, 20)
        if vendendor then
            if newproduct == nil then return end
            SpawnInventory(inst, newproduct[1], newproduct[2], newproduct[3])
        end
    end
end


local function displaynamefn(inst)
    return "whatever"
end

local function onsave(inst, data)
    data.imagename = inst.imagename
    data.costprefab = inst.costprefab
    data.cost = inst.cost
    data.interiorID = inst.interiorID
    data.startAnim = inst.startAnim
    data.saleitem = inst.saleitem
    data.justsellonce = inst:HasTag("justsellonce")
    data.nodailyrestock = inst:HasTag("nodailyrestock")
    data.shoptype = inst.shoptype
end

local function onload(inst, data)
    if data then
        if data.imagename then
            SetImageFromName(inst, data.imagename)
        end
        if data.cost then
            inst.cost = data.cost
        end
        if data.costprefab then
            inst.costprefab = data.costprefab
            SetCost(inst, inst.costprefab, inst.cost)
        end
        if data.interiorID then
            inst.interiorID = data.interiorID
        end
        if data.startAnim then
            inst.startAnim = data.startAnim
            inst.AnimState:PlayAnimation(data.startAnim)
        end
        if data.saleitem then
            inst.saleitem = data.saleitem
        end
        if data.justsellonce then
            inst:AddTag("justsellonce")
        end
        if data.nodailyrestock then
            inst:AddTag("nodailyrestock")
        end
        if data.shoptype then
            inst.shoptype = data.shoptype
        end
    end
end

local function setobstical(inst)
    local ground = TheWorld
    if ground then
        local pt = Point(inst.Transform:GetWorldPosition())
        ground.Pathfinder:AddWall(pt.x, pt.y, pt.z)
    end
end

local function common()
    local inst = CreateEntity()
    inst.entity:AddNetwork()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    local minimap = inst.entity:AddMiniMapEntity()
    -- inst.MiniMapEntity:SetIcon("accomplishment_shrine.tex")
    inst.Transform:SetTwoFaced()
    MakeObstaclePhysics(inst, .25)

    inst.AnimState:SetBank("pedestal")
    inst.AnimState:SetBuild("pedestal_crate")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetFinalOffset(1)

    inst:AddTag("shop_pedestal")

    inst.imagename = nil
    inst.shoptype = shopdefs.default

    --    MakeMediumBurnable(inst)
    --    MakeSmallPropagator(inst)

    inst.SetImage = SetImage
    inst.SetCost = SetCost
    inst.SetImageFromName = SetImageFromName
    inst.SpawnInventory = SpawnInventory
    inst.TimedInventory = TimedInventory
    inst.shopkeeper_speech = shopkeeper_speech
    inst.SoldItem = SoldItem

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst.setobstical = setobstical
    inst.setobstical(inst)

    return inst
end


local function buyer()
    local inst = common()
    inst.restock = restock


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("shopdispenser")
    inst:AddComponent("shopped")

    inst:WatchWorldState("isday", restock)
    inst:DoTaskInTime(1, restock)
    return inst
end


return Prefab("shop_buyer", buyer, assets, prefabs)
