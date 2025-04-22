local SoundEmitter = SoundEmitter
local SoundRedirectMap = {}

local old_play = SoundEmitter.PlaySound
function SoundEmitter.PlaySound(self, name, ...)
    -- print("SoundEmitter.PlaySound", name)
    return old_play(self, SoundRedirectMap[name] or name, ...)
end

local old_playp = SoundEmitter.PlaySoundWithParams
function SoundEmitter.PlaySoundWithParams(self, name, ...)
    return old_playp(self, SoundRedirectMap[name] or name, ...)
end

GLOBAL.setfenv(1, GLOBAL)
RemapSound = function(name, alias)
    SoundRedirectMap[name] = alias
end


RemapSound("dontstarve/movement/run_rock", "dontstarve/movement/run_dirt")
RemapSound("dontstarve/movement/run_rock_small", "dontstarve/movement/run_dirt_small")
RemapSound("dontstarve/movement/run_rock_large", "dontstarve/movement/run_dirt_large")
RemapSound("dontstarve/movement/walk_rock", "dontstarve/movement/walk_dirt")
RemapSound("dontstarve/movement/walk_rock_small", "dontstarve/movement/walk_dirt_small")
RemapSound("dontstarve/movement/walk_rock_large", "dontstarve/movement/walk_dirt_large")
