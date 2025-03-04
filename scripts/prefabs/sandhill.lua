local assets =
{
	Asset("ANIM", "anim/sand_dune.zip")
}

local prefabs =
{
	"sand",
}
local SAND_REGROW_TIME = 480 * 2 -- sand dune regrow time
local SAND_REGROW_VARIANCE = 480 -- sand dune regrow variance
local SAND_DEPLETE_CHANCE = 0.25 -- chance of sandhill depleting during "green" season (0.25 means a 25% chance)

local startregen

-- these should match the animation names to the workleft
local anims = { "low", "med", "full" }

local function onregen(inst)
	--if inst.components.workable.workleft > 0 then
	inst.components.activatable.inactive = false
	--end
	if inst.components.workable.workleft < #anims - 1 then
		inst.components.workable:SetWorkLeft(inst.components.workable.workleft + 1)
		startregen(inst)
	else
		inst.targettime = nil
	end
	--print('onregen', inst.components.activatable.inactive)
end

startregen = function(inst, regentime)
	if inst.components.workable.workleft < #anims - 1 then
		-- more to grow
		regentime = regentime or (SAND_REGROW_TIME + math.random() * SAND_REGROW_VARIANCE)

		-- TODO
		if TheWorld.state.iswinter then
			regentime = regentime / 2
		elseif TheWorld.state.isspring then
			regentime = regentime * 2
		end

		if inst.task then
			inst.task:Cancel()
		end
		inst.task = inst:DoTaskInTime(regentime, onregen, "regen")
		inst.targettime = GetTime() + regentime
	else
		-- no more to do
		if inst.task then
			inst.task:Cancel()
		end
		inst.targettime = nil
	end

	if inst.components.workable.workleft < 1 then
		inst.AnimState:PlayAnimation(anims[1])
	else
		if inst.components.workable.workleft == 1 then inst.AnimState:PlayAnimation("med") end
		if inst.components.workable.workleft == 2 then inst.AnimState:PlayAnimation("low") end
		if inst.components.workable.workleft >= 3 then inst.AnimState:PlayAnimation("full") end
	end
end

local function workcallback(inst, worker, workleft)
	--print('trying to spawn sand', inst, worker, workleft)

	if workleft < 0 then
		-- the devtool probably did this, spit out 2
		inst.components.lootdropper:SetLoot({ "sand", "sand" })
	else
		inst.components.lootdropper:SetLoot({ "sand" })
	end

	if workleft <= 0 then
		inst.components.activatable.inactive = true
	end

	inst.components.lootdropper.numrandomloot = 1
	inst.components.lootdropper.chancerandomloot = 0.03 -- drop some random item 1% of the time

	inst.components.lootdropper:AddRandomLoot("seashell", 0.01)
	inst.components.lootdropper:AddRandomLoot("rock", 0.01)
	inst.components.lootdropper:AddRandomLoot("feather_crow", 0.01)
	inst.components.lootdropper:AddRandomLoot("feather_robin", 0.01)
	inst.components.lootdropper:AddRandomLoot("feather_robin_winter", 0.01)
	inst.components.lootdropper:AddRandomLoot("venom_gland", 0.001)
	inst.components.lootdropper:AddRandomLoot("coconut", 0.001)
	inst.components.lootdropper:AddRandomLoot("crab", 0.001)
	inst.components.lootdropper:AddRandomLoot("snake", 0.001)
	inst.components.lootdropper:AddRandomLoot("gears", 0.002)
	inst.components.lootdropper:AddRandomLoot("redgem", 0.002)
	inst.components.lootdropper:AddRandomLoot("goldnugget", 0.002)
	inst.components.lootdropper:AddRandomLoot("dubloon", 0.002)
	inst.components.lootdropper:AddRandomLoot("purplegem", 0.001)

	-- figure out which side to drop the loot
	local pt = Vector3(inst.Transform:GetWorldPosition())
	local hispos = Vector3(worker.Transform:GetWorldPosition())

	local he_right = ((hispos - pt):Dot(TheCamera:GetRightVec()) > 0)

	if he_right then
		inst.components.lootdropper:DropLoot(pt - (TheCamera:GetRightVec() * (.5 + math.random())))
	else
		inst.components.lootdropper:DropLoot(pt + (TheCamera:GetRightVec() * (.5 + math.random())))
	end

	--	inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sandpile")

	startregen(inst)
end

local function onsave(inst, data)
	if inst.targettime then
		local time = GetTime()
		if inst.targettime > time then
			data.time = math.floor(inst.targettime - time)
		end
		data.workleft = inst.components.workable.workleft
		--print('sandhill onsave', data.workleft)
	end
end
local function onload(inst, data)
	if data and data.workleft then
		inst.components.workable.workleft = data.workleft

		if data.workleft <= 0 then
			inst.components.activatable.inactive = true
		end
	end
	--print('sandhill onload', inst.components.workable.workleft)
	if data and data.time then
		startregen(inst, data.time)
	end
end

local function onwake(inst, israining)
	if TheWorld.state.isspring and israining then
		if math.random() < SAND_DEPLETE_CHANCE and inst.components.workable.workleft > 0 then
			-- the rain made this sandhill shrink
			inst.components.workable.workleft = inst.components.workable.workleft -
			math.random(0, inst.components.workable.workleft)
			startregen(inst)
		end
	end
end

local function sandhillfn(Sim)
	--print ('sandhillfn')
	local inst = CreateEntity()
	inst.OnSave = onsave
	inst.OnLoad = onload
	--inst.OnEntityWake = onwake
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	anim:SetBuild("sand_dune")
	anim:SetBank("sand_dune")
	anim:PlayAnimation(anims[#anims])

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:WatchWorldState("israining", onwake)

	----------------------
	inst:AddComponent("inspectable")
	----------------------
	inst:AddComponent("lootdropper")

	--full, med, low
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(#anims - 1)
	inst.components.workable:SetOnWorkCallback(workcallback)

	inst:AddComponent("activatable")
	inst.components.activatable.inactive = false
	inst.components.activatable.getverb = function() return "SAND" end
	inst.components.activatable.OnActivate = function() inst:Remove() end

	return inst
end

return Prefab("sandhill", sandhillfn, assets, prefabs)
