--晾肉架悬挂物品，以后可晾物品只用在fn里添加dryable组件并SetProduct和DryTime，Symbol写在这里就行了
local tro_buildfile = "meat_rack_food_tro"
local meatrack_items = { --前面是prefab名，后面是bulid里面的Symbol
    coi = "coi",
    dogfish_dead = "dogfish",
    jellyjerky = "jellyjerky",
    seaweed_dried = "seaweed_dried",
    fish2 = "fish2",
    fish3 = "fish3",
    fish4 = "fish4",
    fish5 = "fish5",
    froglegs_poison = "froglegs_poison",
    jellyfish_dead = "jellyfish_dead",
    --quagmire_crabmeat = "quagmire_crabmeat",
    --quagmire_smallmeat = "quagmire_smallmeat",
    rainbowjellyfish_dead = "rainbowjellyfish_dead",
    salmon = "salmon",
    seaweed = "seaweed",
    swordfish_dead = "dead_swordfish",
    venus_stalk = "venus_stalk",
    walkingstick = "walkingstick"

}

AddPrefabPostInit("meatrack", function(inst)
    if not TheWorld.ismastersim then return end

    local _OnStartDrying = inst.components.dryer.onstartdrying --开始晾的时候，即可晾物品
    local function OnStartDrying(inst, ingredient, buildfile)
        if meatrack_items[ingredient] then
            ingredient = meatrack_items[ingredient]
            buildfile = tro_buildfile
        end
        _OnStartDrying(inst, ingredient, buildfile)
    end

    inst.components.dryer:SetStartDryingFn(OnStartDrying)

    local _ondonedrying = inst.components.dryer.ondonedrying --晾完的时候，即产物
    local function OnDoneDrying(inst, product, buildfile)
        if meatrack_items[product] then
            product = meatrack_items[product]
            buildfile = tro_buildfile
        end
        _ondonedrying(inst, product, buildfile)
    end

    inst.components.dryer:SetDoneDryingFn(OnDoneDrying)
    --[[
    local _StartDrying = inst.components.dryer.StartDrying
    local function StartDrying(self, dryable, ...)
        if inst:GetIsInInterior() then
            inst.components.dryer.protectedfromrain = true
        else
            inst.components.dryer.protectedfromrain = nil
        end
        return _StartDrying(self, dryable, ...)
    end

    inst.components.dryer.StartDrying = StartDrying]]
end)
