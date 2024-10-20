-- shop_interior
local assets =
{
    --Asset("ANIM", "anim/store_items.zip"),
    Asset("ANIM", "anim/pedestal_crate.zip"),
    Asset("ATLAS_BUILD", "images/inventoryimages1.xml", 256),
    Asset("ATLAS_BUILD", "images/inventoryimages2.xml", 256),
    Asset("ATLAS_BUILD", "images/inventoryimages3.xml", 256),
    Asset("ATLAS_BUILD", "images/inventoryimages/volcanoinventory.xml", 256),
    Asset("ATLAS_BUILD", "images/inventoryimages/hamletinventory.xml", 256),
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

        if ent.caminho then
            atlas = ent.caminho
        elseif atlas and atlas == "images/inventoryimages1.xml" then
            atlas = "images/inventoryimages1.xml"
        elseif atlas and atlas == "images/inventoryimages2.xml" then
            atlas = "images/inventoryimages2.xml"
        elseif atlas and atlas == "images/inventoryimages3.xml" then
            atlas = "images/inventoryimages3.xml"
        else
            atlas = "images/inventoryimages/hamletinventory.xml"
        end

        if (image == "waffles_plate_generic") then
            inst.AnimState:OverrideSymbol("SWAP_SIGN", "images/inventoryimages2.xml", "waffles.tex")
        else
            inst.AnimState:OverrideSymbol("SWAP_SIGN", resolvefilepath(atlas), texname)
        end
        --inst.AnimState:OverrideSymbol("SWAP_SIGN", "store_items", image)
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
        inst.AnimState:OverrideSymbol("SWAP_SIGN", resolvefilepath("images/inventoryimages/hamletinventory.xml"), texname)
        --inst.AnimState:OverrideSymbol("SWAP_SIGN", "store_items", image)		

        inst.imagename = image
    else
        inst.imagename = ""
        inst.AnimState:ClearOverrideSymbol("SWAP_SIGN")
    end
end

local function SetCost(inst, costprefab, cost)
    local image = nil

    if costprefab then
        image = costprefab
    end
    if costprefab == "oinc" and cost then
        image = "cost-" .. cost
    end

    if costprefab == "goldenbar" or costprefab == "stonebar" or costprefab == "lucky_goldnugget" then
        if image ~= nil then
            local texname = image .. ".tex"
            inst.AnimState:OverrideSymbol("SWAP_COST", resolvefilepath("images/inventoryimages/volcanoinventory.xml"),
                texname)
            --inst.AnimState:OverrideSymbol("SWAP_SIGN", "store_items", image)		

            inst.costimagename = image
        else
            inst.costimagename = ""
            inst.AnimState:ClearOverrideSymbol("SWAP_COST")
        end
    else
        if image ~= nil then
            local texname = image .. ".tex"
            inst.AnimState:OverrideSymbol("SWAP_COST", resolvefilepath("images/inventoryimages/hamletinventory.xml"),
                texname)
            --inst.AnimState:OverrideSymbol("SWAP_SIGN", "store_items", image)		

            inst.costimagename = image
        else
            inst.costimagename = ""
            inst.AnimState:ClearOverrideSymbol("SWAP_COST")
        end
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
    -- inst.MiniMapEntity:SetIcon("accomplishment_shrine.png")
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

local function buyer_deli()
    local inst = common()
    inst.shoptype = "pig_shop_deli"
    inst.startAnim = "idle_cakestand_dome"
    inst.restock = restock


    inst.AnimState:PlayAnimation(inst.startAnim)

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

local function buyer_florist()
    local inst = common()
    inst.shoptype = "pig_shop_florist"
    inst.startAnim = "idle_cart"

    inst.AnimState:PlayAnimation(inst.startAnim)
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

local function buyer_general()
    local inst = common()
    inst.shoptype = "pig_shop_general"
    inst.startAnim = "idle_barrel"

    inst.AnimState:PlayAnimation(inst.startAnim)
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

local function buyer_hoofspa()
    local inst = common()
    inst.shoptype = "pig_shop_hoofspa"
    inst.startAnim = "idle_cakestand"

    inst.AnimState:PlayAnimation(inst.startAnim)
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

local function buyer_produce()
    local inst = common()
    inst.shoptype = "pig_shop_produce"
    inst.startAnim = "idle_ice_box"

    inst.AnimState:PlayAnimation(inst.startAnim)
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

local function buyer_antiquities()
    local inst = common()
    inst.shoptype = "pig_shop_antiquities"
    inst.startAnim = "idle_barrel_dome"

    inst.AnimState:PlayAnimation(inst.startAnim)
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

local function buyer_cityhall()
    local inst = common()
    inst.shoptype = "pig_shop_cityhall"
    inst.startAnim = "idle_globe_bar"

    inst.AnimState:PlayAnimation(inst.startAnim)
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

local function buyer_arcane()
    local inst = common()
    inst.shoptype = "pig_shop_arcane"
    inst.startAnim = "idle_marble"

    inst.AnimState:PlayAnimation(inst.startAnim)
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

local function buyer_weapons()
    local inst = common()
    inst.shoptype = "pig_shop_weapons"
    inst.startAnim = "idle_cablespool"

    inst.AnimState:PlayAnimation(inst.startAnim)
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

local function buyer_spears()
    local inst = common()
    inst.shoptype = "pig_shop_spears"
    inst.startAnim = "idle_cablespool"

    inst.AnimState:PlayAnimation(inst.startAnim)
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

local function buyer_hatshop()
    local inst = common()
    inst.shoptype = "pig_shop_hatshop"
    inst.startAnim = "idle_hatbox2" --idle_hatbox1 idle_hatbox3 idle_hatbox4

    inst.AnimState:PlayAnimation(inst.startAnim)
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

local function buyer_bank()
    local inst = common()
    inst.shoptype = "pig_shop_bank"
    inst.startAnim = "idle_marble_dome"

    inst.AnimState:PlayAnimation(inst.startAnim)
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

local function buyer_tinker()
    local inst = common()
    inst.shoptype = "pig_shop_tinker"
    inst.startAnim = "idle_metal"

    inst.AnimState:PlayAnimation(inst.startAnim)
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

local function buyer_academy()
    local inst = common()
    inst.shoptype = "pig_shop_academy"
    inst.startAnim = "idle_stoneslab"

    inst.AnimState:PlayAnimation(inst.startAnim)
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




local function seller()
    local inst = common()
    return inst
end

return Prefab("shop_buyer", buyer, assets, prefabs),
    Prefab("shop_seller", seller, assets, prefabs),

    Prefab("shop_buyer_deli", buyer_deli, assets, prefabs),
    Prefab("shop_buyer_florist", buyer_florist, assets, prefabs),
    Prefab("shop_buyer_general", buyer_general, assets, prefabs),
    Prefab("shop_buyer_hoofspa", buyer_hoofspa, assets, prefabs),
    Prefab("shop_buyer_produce", buyer_produce, assets, prefabs),
    Prefab("shop_buyer_antiquities", buyer_antiquities, assets, prefabs),
    Prefab("shop_buyer_cityhall", buyer_cityhall, assets, prefabs),
    Prefab("shop_buyer_arcane", buyer_arcane, assets, prefabs),
    Prefab("shop_buyer_weapons", buyer_weapons, assets, prefabs),
    Prefab("shop_buyer_spears", buyer_spears, assets, prefabs),
    Prefab("shop_buyer_hatshop", buyer_hatshop, assets, prefabs),
    Prefab("shop_buyer_bank", buyer_bank, assets, prefabs),
    Prefab("shop_buyer_tinker", buyer_tinker, assets, prefabs),
    Prefab("shop_buyer_academy", buyer_academy, assets, prefabs)
