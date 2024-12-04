local assets =
{
    Asset("ANIM", "anim/book_meteor.zip"),
    Asset("ANIM", "anim/obsidian.zip"),
}

local prefabs = -- this should really be broken up per book...
{
    "firepen",
    "tentacle",
    "booklight",
}

local VOLCANOBOOK_FIRERAIN_COUNT = 4
local VOLCANOBOOK_FIRERAIN_RADIUS = 5
local VOLCANOBOOK_FIRERAIN_DELAY = 0.5

local TENTACLES_BLOCKED_CANT_TAGS = { "INLIMBO", "FX" }
local BIRDSMAXCHECK_MUST_TAGS = { "magicalbird" }
local SLEEPTARGET_PVP_ONEOF_TAGS = { "sleeper", "player" }
local SLEEPTARGET_NOPVP_MUST_TAGS = { "sleeper" }
local SLEEPTARGET_CANT_TAGS = { "playerghost", "FX", "DECOR", "INLIMBO" }
local GARDENING_CANT_TAGS = { "pickable", "stump", "withered", "barren", "INLIMBO" }

local SILVICULTURE_ONEOF_TAGS = { "silviculture", "tree", "winter_tree" }
local SILVICULTURE_CANT_TAGS = { "pickable", "stump", "withered", "barren", "INLIMBO" }

local HORTICULTURE_CANT_TAGS = { "pickable", "stump", "withered", "barren", "INLIMBO", "silviculture", "tree",
    "winter_tree" }

local book_defs =
{
    {
        name = "book_meteor",
        uses = 5,

        fn = function(inst, reader)
            local delay = 0.0
            for i = 1, VOLCANOBOOK_FIRERAIN_COUNT, 1 do
                local pos = Vector3(reader.Transform:GetWorldPosition())
                local x, y, z = VOLCANOBOOK_FIRERAIN_RADIUS * UnitRand() + pos.x, pos.y,
                    VOLCANOBOOK_FIRERAIN_RADIUS * UnitRand() + pos.z
                reader:DoTaskInTime(delay, function(inst)
                    local firerain = SpawnPrefab("firerain")
                    firerain.Transform:SetPosition(x, y, z)
                    firerain:StartStep()
                end)
                delay = delay + VOLCANOBOOK_FIRERAIN_DELAY
            end
            return true
        end,
    },
}

local function MakeBook(def)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("book_meteor")
        inst.AnimState:SetBuild("book_meteor")
        inst.AnimState:PlayAnimation("book_meteor1")

        inst:AddTag("book")
        inst:AddTag("bookcabinet_item")

        MakeInventoryFloatable(inst, "med", nil, 0.75)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        -----------------------------------

        inst:AddComponent("inspectable")
        inst:AddComponent("book")
        inst.components.book.onread = def.fn
        inst.components.book.onperuse = def.perusefn

        inst:AddComponent("inventoryitem")
        if def.name == "book_meteor" then
        end
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(def.uses)
        inst.components.finiteuses:SetUses(def.uses)
        inst.components.finiteuses:SetOnFinished(inst.Remove)

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL

        MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
        MakeSmallPropagator(inst)

        --MakeHauntableLaunchOrChangePrefab(inst, TUNING.HAUNT_CHANCE_OFTEN, TUNING.HAUNT_CHANCE_OCCASIONAL, nil, nil, morphlist)
        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(def.name, fn, assets, prefabs)
end

local books = {}
for i, v in ipairs(book_defs) do
    table.insert(books, MakeBook(v))
end
book_defs = nil



local function fnobsidian(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)


    inst.AnimState:SetRayTestOnBB(true);
    inst.AnimState:SetBank("obsidian")
    inst.AnimState:SetBuild("obsidian")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("molebait")
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 3

    inst:AddComponent("stackable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")



    inst:AddComponent("bait")

    return inst
end

return Prefab("obsidian", fnobsidian, assets), unpack(books)
