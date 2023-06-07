local assets =
{
    Asset("ANIM", "anim/goddess_shrine.zip"),
	Asset("IMAGE", "images/map_icons/goddess_shrine.tex"),
	Asset("ATLAS", "images/map_icons/goddess_shrine.xml")
}

local GODDESS = {SCIENCE = 0, ANCIENT = 0, GODDESS = 2, MAGIC = 0, SHADOW = 0, CARTOGRAPHY = 0, ORPHANAGE = 0, SCULPTING = 0, PERDOFFERING = 0}

local function complete_onturnon(inst)
	inst.AnimState:PlayAnimation("extinguish",true)
	inst.page.AnimState:PlayAnimation("idle_loop",true)
	inst.statue1.AnimState:PlayAnimation("idle_loop",true)
	inst.statue2.AnimState:PlayAnimation("idle_loop",true)
	
	if inst.light == nil then
		inst.light = inst.statue2:SpawnChild("goddess_statue_fire1")
	end 
	
	if inst.light1 == nil then
		inst.light1 = inst.statue1:SpawnChild("goddess_statue_fire")
	end 
	
    if not inst.SoundEmitter:PlayingSound("idlesound") then
        inst.SoundEmitter:PlaySound("dontstarve/common/ancienttable_LP", "idlesound")
    end
end

local function complete_onturnoff(inst)
	inst.AnimState:PlayAnimation("idle_loop_01")
	inst.page.AnimState:PlayAnimation("idle")
	inst.statue1.AnimState:PlayAnimation("idle_off",true)
	inst.statue2.AnimState:PlayAnimation("idle_off",true)
	
	if inst.light ~= nil then
		inst.light:Remove()
		inst.light = nil
	end
		
	if inst.light1 ~= nil then
		inst.light1:Remove()
		inst.light1 = nil
	end
	
    inst.SoundEmitter:KillSound("dontstarve/common/ancienttable_LP", "idlesound")
end

local function complete_doonact(inst)
    if inst._activecount > 1 then
        inst._activecount = inst._activecount - 1
    else
        inst._activecount = 0
        inst.SoundEmitter:KillSound("sound")
    end
	inst.AnimState:PushAnimation("extinguish")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/raise")
end

local function complete_onactivate(inst)
	inst.AnimState:PlayAnimation("extinguish",true)

    inst._activecount = inst._activecount + 1

    if not inst.SoundEmitter:PlayingSound("sound") then
        inst.SoundEmitter:PlaySound("dontstarve/common/ancienttable_craft", "sound")
    end

    inst:DoTaskInTime(1.5, complete_doonact)
end

local function statue(inst)
	if inst.statue1 == nil then
		inst.statue1 = inst:SpawnChild("goddess_statue5")
		inst.statue1.Transform:SetPosition(2.1, 0, 0)
	end
	if inst.statue2 == nil then
		inst.statue2 = inst:SpawnChild("goddess_statue4")
		inst.statue2.Transform:SetPosition(-2.1, 0, 0)
	end
	if inst.page == nil then
		inst.page = inst:SpawnChild("page")
		inst.page.Transform:SetPosition(0, 1, 0)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()
	
	inst.MiniMapEntity:SetIcon( "goddess_shrine.tex" )
	
	MakeObstaclePhysics(inst, 0.75)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	
	local s = 1.5
	inst.Transform:SetScale(s,s,s)

    inst.AnimState:SetBank("goddess_shrine")
    inst.AnimState:SetBuild("goddess_shrine")
    inst.AnimState:PlayAnimation("idle_loop_01")
	
    inst.entity:SetPristine()

	inst:AddTag("altar")
	inst:AddTag("prototyper")
	inst:AddTag("giftmachine")
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddTag("goddess")
	inst:AddTag("antlion_sinkhole_blocker")
	
	inst:AddComponent("prototyper")
	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.GODDESS_TWO
	
	inst.components.prototyper.onturnon = complete_onturnon
    inst.components.prototyper.onturnoff = complete_onturnoff
    inst.components.prototyper.onactivate = complete_onactivate
	
    inst:AddComponent("inspectable")
	
	inst:DoTaskInTime(0, statue)
	
	inst._activecount = 0

    return inst
end

return Prefab("goddess_shrine", fn, assets)