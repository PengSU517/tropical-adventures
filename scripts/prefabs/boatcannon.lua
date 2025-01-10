local BOATCANNON_AMMO_COUNT = 15

local function OnBoatQeuipped(inst, data)
    data.owner.AnimState:OverrideSymbol("swap_lantern", inst.symbol_build, inst.symbol)
    local boatfx = data.owner.components.shipwreckedboat.boatfx
    if boatfx then
        boatfx.AnimState:OverrideSymbol("swap_lantern", inst.symbol_build, inst.symbol)
    end
end

local function OnBoatUnQeuipped(inst, data)
    data.owner.AnimState:ClearOverrideSymbol("swap_lantern")
    local boatfx = data.owner.components.shipwreckedboat.boatfx
    if boatfx then
        boatfx.AnimState:ClearOverrideSymbol("swap_lantern")
    end
end

local function OnFinished(inst)
    local boat = inst.components.shipwreckedboatparts:GetBoat()
    if boat then
        boat.AnimState:ClearOverrideSymbol("swap_lantern")
    end

    inst:Remove()
end

local function ReticuleTargetFn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local pos = Vector3()
    --Attack range is 8, leave room for error
    --Min range was chosen to not hit yourself (2 is the hit range)
    for r = 6.5, 3.5, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
            return pos
        end
    end
    return pos
end

local function common(bank, build, anim, symbol_build, symbol)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.symbol_build = symbol_build
    inst.symbol = symbol

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation(anim)

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst:AddTag("boatcannon")
    inst:AddTag("shipwrecked_boat_head")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(BOATCANNON_AMMO_COUNT)
    inst.components.finiteuses:SetUses(BOATCANNON_AMMO_COUNT)
    inst.components.finiteuses:SetOnFinished(OnFinished)

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.ease = true

    inst:AddComponent("shipwreckedboatparts")

    inst:ListenForEvent("boat_equipped", OnBoatQeuipped)
    inst:ListenForEvent("boat_unequipped", OnBoatUnQeuipped)

    return inst
end

----------------------------------------------------------------------------------------------------

local boatcannon_assets = {
    Asset("ANIM", "anim/swap_cannon.zip"),
}

local boatcannon_prefabs = {
    "cannonshot",
    "collapse_small",
}

local function boatcannon_fn()
    return common("cannon", "swap_cannon", "idle", "swap_cannon", "swap_cannon")
end

local obsidian_boatcannon_assets = {
    Asset("ANIM", "anim/cannon_obsidian.zip"),
    Asset("ANIM", "anim/swap_cannon_pirate.zip"),
}

local obsidian_boatcannon_prefabs = {
    "collapse_small",
}

local function obsidian_boatcannon_fn()
    return common("cannon_obsidian", "cannon_obsidian", "idle", "swap_cannon_pirate", "swap_cannon")
end

return Prefab("boatcannon", boatcannon_fn, boatcannon_assets, boatcannon_prefabs),
    Prefab("obsidian_boatcannon", obsidian_boatcannon_fn, obsidian_boatcannon_assets, obsidian_boatcannon_prefabs)
