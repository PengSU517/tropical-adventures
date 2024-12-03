local assets = {Asset("ANIM", "anim/poison.zip")}

local function Removefx(inst)
    inst.AnimState:PushAnimation("level" .. inst.level .. "_pst", false)
    inst:RemoveEventCallback("animqueueover", Removefx)
    inst:ListenForEvent("animqueueover", function()
        inst.SoundEmitter:KillSound("poisoned")
        inst:Remove()
    end)
end

local function MakeBubble(name, level, loop)
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        local anim = inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        inst.entity:AddFollower()

        anim:SetBank("poison")
        anim:SetBuild("poison")
        anim:SetFinalOffset(2)

        inst.level = level or 2
        anim:PlayAnimation("level" .. inst.level .. "_pre")
        anim:PushAnimation("level" .. inst.level .. "_loop", loop) -- Let this loop until something externally calls StopBubbles
        if not loop then inst:ListenForEvent("animqueueover", Removefx) end

        inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/poisoned", "poisoned")

        inst:AddTag("fx")

        if not TheWorld.ismastersim then return inst end

        inst.persists = false

        return inst
    end

    return Prefab("common/fx/" .. name, fn, assets)
end

--[[
local bubbles = {}

for lvl = 1, 4 do
    table.insert(bubbles, MakeBubble("poisonbubble_level" .. lvl, lvl))
    table.insert(bubbles, MakeBubble("poisonbubble_level" .. lvl .. "_loop", lvl, true))
end

return unpack(bubbles)
]]

-- Runar: Other bubbles haven't been used, just keep them away from Prefabs
return MakeBubble("poisonbubble_level1_loop", 1, true)