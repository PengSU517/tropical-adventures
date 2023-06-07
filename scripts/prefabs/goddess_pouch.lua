local assets =
{
    Asset("ANIM", "anim/goddess_pouch.zip"),
	Asset("ATLAS", "images/inventoryimages/goddess_pouch.xml"),
	Asset("IMAGE", "images/inventoryimages/goddess_pouch.tex")
}

local function MakeLoot(inst)
    local possible_loot =
    {
        {chance = 0.5,	item = "purplegem"},
        {chance = 0.5, 	item = "bluegem"},
        {chance = 0.5, 	item = "redgem"},
        {chance = 0.5, 	item = "orangegem"},
        {chance = 0.5, 	item = "yellowgem"},
        {chance = 0.5, 	item = "greengem"},
		{chance = 0.1, 	item = "mixed_gem"},
		{chance = 0.5, 	item = "goggleshat_blueprint"},
		{chance = 1.5, 	item = "honeycomb"},
		{chance = 0.5, 	item = "succulent_picked"},
		{chance = 0.5, 	item = "shroom_skin"},
		{chance = 0.5, 	item = "dragon_scales"},
		{chance = 0.5, 	item = "goose_feather"},
		{chance = 0.5, 	item = "livinglog"},
		{chance = 0.5, 	item = "fossil_piece"},
		{chance = 1, 	item = "trinket_8"},
        {chance = 1, 	item = "trinket_15"},
        {chance = 1, 	item = "trinket_24"},
		{chance = 1, 	item = "trinket_26"},
		{chance = 1, 	item = "antliontrinket"},
		{chance = 1, 	item = "gem_seeds"},
		{chance = 3.9, 	item = "seeds"},
		{chance = 2, 	item = "feather_canary"},
		{chance = 2, 	item = "goddess_feather"},
		{chance = 1, 	item = "goddess_ribbon"},
        {chance = 2,  	item = "goddess_rabbit"},
		{chance = 1,  	item = "goddess_rabbit_fur"},
		{chance = 2,  	item = "fish"},
		{chance = 2,  	item = "eel"},
		{chance = 18,  	item = "empty_bottle_green"},
		{chance = 10, 	item = "full_bottle_green"},
		{chance = 2, 	item = "peach_juice_bottle_green"},
		{chance = 10, 	item = "full_bottle_green_dirty"},
		{chance = 5, 	item = "full_bottle_green_milk"},
        {chance = 9.5,  item = "cutgreengrass"},
		{chance = 3,    item = "goddess_butterflywings"},
        {chance = 2,    item = "peach"},
		{chance = 2,    item = "dragonfruit"},
		{chance = 2,    item = "pomegranate"},
		{chance = 2,  	item = "giftwrap"},
        {chance = 0.5,  item = "TOOLS_blueprint"},
        {chance = 0.5,  item = "LIGHT_blueprint"},
        {chance = 0.5,  item = "SURVIVAL_blueprint"},
        {chance = 0.5,  item = "FARM_blueprint"},
        {chance = 0.5,  item = "SCIENCE_blueprint"},
        {chance = 0.5,  item = "WAR_blueprint"},
        {chance = 0.5,  item = "TOWN_blueprint"},
        {chance = 0.5,  item = "REFINE_blueprint"},
        {chance = 0.5,  item = "MAGIC_blueprint"},
        {chance = 0.5,  item = "DRESS_blueprint"},
        {chance = 2, 	item = "gears"},
    }
    local totalchance = 0
    for m, n in ipairs(possible_loot) do
        totalchance = totalchance + n.chance
    end

    inst.loot = {}
    inst.lootaggro = {}
    local next_loot = nil
    local next_aggro = nil
    local next_chance = nil
    local num_loots = 1 + math.random(4)
    while num_loots > 0 do
        next_chance = math.random()*totalchance
        next_loot = nil
        next_aggro = nil
        for m, n in ipairs(possible_loot) do
            next_chance = next_chance - n.chance
            if next_chance <= 0 then
                next_loot = n.item
                if n.aggro then next_aggro = true end
                break
            end
        end
        if next_loot ~= nil then
            table.insert(inst.loot, next_loot)
            if next_aggro then 
                table.insert(inst.lootaggro, true)
            else
                table.insert(inst.lootaggro, false)
            end
            num_loots = num_loots - 1
        end
    end
end

local function OnUnwrapped(inst, pos, doer)
	if inst.burnt then
		SpawnPrefab("ash").Transform:SetPosition(pos:Get())
	else
		local item = nil
		local moisture = inst.components.inventoryitem:GetMoisture()
		local iswet = inst.components.inventoryitem:IsWet()
		for i, v in ipairs(inst.loot) do
			local item = SpawnPrefab(v)
			if item ~= nil then
				if item.Physics ~= nil then
					item.Physics:Teleport(pos:Get())
				else
					item.Transform:SetPosition(pos:Get())
				end
				if item.components.inventoryitem ~= nil then
					item.components.inventoryitem:InheritMoisture(moisture, iswet)
					item.components.inventoryitem:OnDropped(true, .5)
				end
			end
		end
	end
	if doer ~= nil and doer.SoundEmitter ~= nil then
		doer.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
	end
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)	

    inst.AnimState:SetBank("goddess_pouch")
    inst.AnimState:SetBuild("goddess_pouch")
    inst.AnimState:PlayAnimation("idle_onesize")
	
	inst.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
	
	inst:AddTag("bundle")
	inst:AddTag("unwrappable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")

	MakeLoot(inst)
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/goddess_pouch.xml"

	inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)
	
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("goddess_pouch", fn, assets)