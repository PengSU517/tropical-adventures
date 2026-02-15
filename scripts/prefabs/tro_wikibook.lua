local assets = {Asset("ANIM", "anim/cookbook.zip")}

local function OnReadBook(inst, doer)
    doer:ShowPopUp(POPUPS.WIKIBOOK, true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("books")
    inst.AnimState:SetBuild("books")
    inst.AnimState:PlayAnimation("book_research_station")

    inst.Transform:SetScale(1.2, 1.2, 1.2)

    MakeInventoryFloatable(inst, "med", nil, 0.75)

    -- for simplebook component
    inst:AddTag("simplebook")
    inst:AddTag("bookcabinet_item")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -----------------------------------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "book_research_station"

    inst:AddComponent("simplebook")
    inst.components.simplebook.onreadfn = OnReadBook

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("wikibook", fn, assets, prefabs)

