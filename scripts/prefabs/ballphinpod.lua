local prefabs =
{
    "ballphin",
}

local assets =
{
}

local function InMood(inst)
    if inst.components.periodicspawner ~= nil then
        inst.components.periodicspawner:Start()
    end
    if inst.components.herd ~= nil then
        for k, v in pairs(inst.components.herd.members) do
            k:PushEvent("entermood")
        end
    end
end

local function LeaveMood(inst)
    if inst.components.periodicspawner ~= nil then
        inst.components.periodicspawner:Stop()
    end
    if inst.components.herd ~= nil then
        for k, v in pairs(inst.components.herd.members) do
            k:PushEvent("leavemood")
        end
    end
    inst.components.mood:CheckForMoodChange()
end

local function AddMember(inst, member)
    if inst.components.mood ~= nil then
        member:PushEvent(inst.components.mood:IsInMood() and "entermood" or "leavemood")
    end
end

local function SpawnableParent(inst)
    for member, _ in pairs(inst.components.herd.members) do
        if member.components.domesticatable == nil
            or (member.components.domesticatable:IsDomesticated() == false and member.components.rideable:GetRider() == nil)
        then
            return member
        end
    end
    return nil
end

local function CanSpawn(inst)
    -- Note that there are other conditions inside periodic spawner governing this as well.

    if inst.components.herd == nil or inst.components.herd:IsFull() then
        return false
    end

    local found = SpawnableParent(inst)

    local x, y, z = inst.Transform:GetWorldPosition()
    return found ~= nil
        and
        #TheSim:FindEntities(x, y, z, inst.components.herd.gatherrange, { "herdmember", inst.components.herd.membertag }) <
        TUNING.BEEFALOHERD_MAX_IN_RANGE
end

local function OnSpawned(inst, newent)
    --print("At ONSPAWNED",inst)
    if inst.components.herd ~= nil then
        inst.components.herd:AddMember(newent)
    end
    local parent = SpawnableParent(inst)
    if parent ~= nil then
        newent.Transform:SetPosition(parent.Transform:GetWorldPosition())
    end
end

--local function OnFull(inst)
--TODO: mark some beefalo for death
--end

local function OnInit(inst)
    inst.components.mood:ValidateMood()
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("herd")
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("herd")
    if inst:HasTag("migratory") then
        inst.components.herd:SetMemberTag("ballphin_migratory")
    else
        inst.components.herd:SetMemberTag("ballphin")
    end
    inst.components.herd:SetGatherRange(TUNING.BEEFALOHERD_RANGE)
    inst.components.herd:SetUpdateRange(20)
    inst.components.herd:SetOnEmptyFn(inst.Remove)
    --inst.components.herd:SetOnFullFn(OnFull)
    inst.components.herd:SetAddMemberFn(AddMember)

    inst:AddComponent("mood")
    inst.components.mood:SetMoodTimeInDays(TUNING.BEEFALO_MATING_SEASON_LENGTH, TUNING.BEEFALO_MATING_SEASON_WAIT)
    inst.components.mood:SetMoodSeason(SEASONS.SPRING)
    inst.components.mood:SetInMoodFn(InMood)
    inst.components.mood:SetLeaveMoodFn(LeaveMood)
    inst.components.mood:CheckForMoodChange()
    inst:DoTaskInTime(0, OnInit)

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetRandomTimes(TUNING.BEEFALO_MATING_SEASON_BABYDELAY,
        TUNING.BEEFALO_MATING_SEASON_BABYDELAY_VARIANCE)
    inst.components.periodicspawner:SetPrefab("ballphin")
    inst.components.periodicspawner:SetOnSpawnFn(OnSpawned)
    inst.components.periodicspawner:SetSpawnTestFn(CanSpawn)
    inst.components.periodicspawner:SetDensityInRange(20, 6)
    inst.components.periodicspawner:SetOnlySpawnOffscreen(true)

    return inst
end

return Prefab("forest/animals/ballphinpod", fn, assets, prefabs)
