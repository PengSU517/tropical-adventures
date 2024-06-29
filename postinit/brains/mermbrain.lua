local IAENV = env
GLOBAL.setfenv(1, GLOBAL)
--------------------------------------------------------------

local SEE_BUSH_DIST      = 15
local KEEP_HACKING_DIST  = 10

local HACK_TAGS = { "hack_workable" }
local function KeepHackingAction(inst)
    return (inst.components.follower.leader ~= nil and
            inst:IsNear(inst.components.follower.leader, KEEP_HACKING_DIST)) or false
end

local function StartHackingCondition(inst)
    return (inst.components.follower.leader ~= nil and
            inst.components.follower.leader.sg ~= nil and
            inst.components.follower.leader.sg:HasStateTag("hacking")) or false
end

local function FindBushToHackAction(inst)
    local target = FindEntity(inst, SEE_BUSH_DIST, nil, HACK_TAGS)
    if target ~= nil then
        return BufferedAction(inst, target, ACTIONS.HACK)
    end
end
local function mermbrainfn(brain) --note we need to start using the new follower setup with braincommons ugh
    for i,node in ipairs(brain.bt.root.children) do
        if node.name == "Parallel" and node.children[1].name == "CHOP" then
            local hackingnode = IfThenDoWhileNode(function() return StartHackingCondition(brain.inst) end, function() return KeepHackingAction(brain.inst) end, "hack",
	        LoopNode{
	            ChattyNode(brain.inst, "MERM_TALK_HELP_HACK_BUSH",
	                DoAction(brain.inst, FindBushToHackAction ))})
            table.insert(brain.bt.root.children, i, hackingnode)
            break
        end
    end
end

IAENV.AddBrainPostInit("mermbrain", mermbrainfn)
IAENV.AddBrainPostInit("mermguardbrain", mermbrainfn)
