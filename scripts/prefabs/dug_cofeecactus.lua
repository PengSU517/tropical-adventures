require "prefabutil"

local function make_plantable(data)
    local bank = data.bank or data.name
    local assets =
    {
        Asset("ANIM", "anim/" .. bank .. ".zip"),
        Asset("INV_IMAGE", "dug_" .. data.name)
    }

    if data.build ~= nil then
        table.insert(assets, Asset("ANIM", "anim/" .. data.build .. ".zip"))
    end

    local function ondeploy(inst, pt, deployer)
        local tree
        if data.name == "elephantcactus" then
            tree = SpawnPrefab("elephantcactus_stump")
        else
            tree = SpawnPrefab(data.name)
        end
        if tree ~= nil then
            tree.Transform:SetPosition(pt:Get())
            inst.components.stackable:Get():Remove()
            if tree.components.pickable ~= nil then
                tree.components.pickable:OnTransplant()
            end
            if deployer ~= nil and deployer.SoundEmitter ~= nil then
                --V2C: WHY?!! because many of the plantables don't
                --     have SoundEmitter, and we don't want to add
                --     one just for this sound!
                deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
            end
            if tree:HasTag("machetecut") then
                tree.AnimState:PlayAnimation(data.anim)
                tree:RemoveTag("machetecut")
                tree.components.workable:SetWorkAction(ACTIONS.DIG)
                tree.components.workable:SetWorkLeft(1)
                tree.components.timer:StartTimer("spawndelay", 60 * 8 * 2)
            end
        end
    end

    local function test_coffee(self, pt, mouseover, deployer)
        if not self:IsDeployable(deployer) then return false end
        local tile = TheWorld.Map:GetTileAtPoint(pt:Get())
        return (tile == WORLD_TILES.MAGMAFIELD or tile == WORLD_TILES.ASH or tile == WORLD_TILES.VOLCANO) and
                   TheWorld.Map:CanDeployPlantAtPoint(pt, self.inst)
    end

    local function test_jungle(self, pt, mouseover, deployer)
        if not self:IsDeployable(deployer) then return false end
        local tile = TheWorld.Map:GetTileAtPoint(pt:Get())
        return tile == WORLD_TILES.JUNGLE and TheWorld.Map:CanDeployPlantAtPoint(pt, self.inst)
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        --inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst:AddTag("deployedplant")

        inst.AnimState:SetBank(data.bank or data.name)
        inst.AnimState:SetBuild(data.build or data.name)
        inst.AnimState:PlayAnimation("dropped")

        if data.floater ~= nil then
            MakeInventoryFloatable(inst, data.floater[1], data.floater[2], data.floater[3])
        else
            MakeInventoryFloatable(inst, "large", .2, .65)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

        inst:AddComponent("inspectable")
        inst.components.inspectable.nameoverride = data.inspectoverride or ("dug_" .. data.name)
        inst:AddComponent("inventoryitem")

        if data.name == "nettle" then
            inst.components.inventoryitem.atlasname = "images/inventoryimages/hamletinventory.xml"
        else
            inst.components.inventoryitem.atlasname = "images/inventoryimages/volcanoinventory.xml"
        end

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

        MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
        MakeSmallPropagator(inst)

        MakeHauntableLaunchAndIgnite(inst)

        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = ondeploy
        inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
        inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.DEFAULT)
        if data.name == "elephantcactus" or data.name == "coffeebush" then
            inst.components.deployable.CanDeploy = test_coffee
            inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
        elseif data.name == "bush_vine" or data.name == "bambootree" then
            inst.components.deployable.CanDeploy = test_jungle
            inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
        end

        if data.halloweenmoonmutable_settings ~= nil then
            inst:AddComponent("halloweenmoonmutable")
            inst.components.halloweenmoonmutable:SetPrefabMutated(data.halloweenmoonmutable_settings.prefab)
        end

        ---------------------
        return inst
    end
    return Prefab("dug_" .. data.name, fn, assets)
end

local plantables =
{
    { name = "bambootree",     bank = "bambootree",     build = "bambootree_build", anim = "picked",      },
    { name = "elephantcactus", bank = "cactus_volcano", build = "cactus_volcano",   anim = "idle_dead",   },
    { name = "bush_vine",      bank = "bush_vine",      build = "bush_vine",        anim = "hacked_idle", },
    { name = "nettle",         bank = "nettle",         build = "nettle",                                 },
    { name = "coffeebush",     bank = "coffeebush",     build = "coffeebush",                             },
}

local prefabs = {}
for i, v in ipairs(plantables) do
    table.insert(prefabs, make_plantable(v))
    table.insert(prefabs,
        MakePlacer("dug_" .. v.name .. "_placer", v.bank or v.name, v.build or v.name, v.anim or "idle"))
end

return unpack(prefabs)
