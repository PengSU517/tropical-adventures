local assets =
{
	Asset("SOUND", "sound/forest.fsb"),
	Asset("ANIM", "anim/wind_fx.zip"),
}

local prefabs =
{
	"windtrail",
	"windswirl",
	"wave_shimmer_hurricane",
	"wave_ripple",
	"rogue_wave",
}

function SpawnWindSwirl(x, y, z, speed, angle)
	local swirl = SpawnPrefab("windswirl")
	swirl.Transform:SetPosition(x, y, z)
	swirl.Transform:SetRotation(angle + 180)
	swirl.AnimState:SetMultColour(1, 1, 1, math.clamp(speed, 0.0, 1.0))
	--swirl.Physics:SetMotorVel(speed, 0, 0)
end

local angle = 0


local function OnInit(inst)
	local px, py, pz = inst.Transform:GetWorldPosition()
	local dx, dz = 16 * UnitRand(), 16 * UnitRand()
	local x, y, z = px + dx, py, pz + dz

	if inst:HasTag("ventania") then
		angle = math.random(1, 8)
		if angle == 1 then angle = 0 end
		if angle == 2 then angle = 45 end
		if angle == 3 then angle = 90 end
		if angle == 4 then angle = 135 end
		if angle == 5 then angle = 180 end
		if angle == 6 then angle = 225 end
		if angle == 7 then angle = 270 end
		if angle == 8 then angle = 315 end


		if TheWorld.state.isday then
			angle = 225
		else
			angle = 45
		end


		local player = GetClosestInstWithTag("player", inst, 25)
		if player and player.components.inventory then
			local mao = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if mao and mao.prefab == "sail_stick" then
				angle = player.Transform:GetRotation() + 180
			end
		end

		inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/wind_tree_creak")
		inst:RemoveTag("ventania")
	end
	local speed = math.random(0.05, 0.8)
	local swirl = SpawnPrefab("windswirl")
	swirl.Transform:SetPosition(x, y, z)
	swirl.Transform:SetRotation(angle)
	--swirl.AnimState:SetMultColour(1, 1, 1, math.clamp(speed, 0.0, 1.0))

	local trail = SpawnPrefab("windtrail")
	trail.Transform:SetPosition(x, y, z)
	trail.Transform:SetRotation(angle)
	--trail.AnimState:SetMultColour(1, 1, 1, math.clamp(speed, 0.0, 1.0))
end

local function apaga(inst)
	inst:Remove()
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst:AddTag("NOCLICK")
	inst:AddTag("ventania")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:DoPeriodicTask(0.1, OnInit)
	inst:DoTaskInTime(6, apaga)

	return inst
end

return Prefab("ventania", fn, assets, prefabs)
