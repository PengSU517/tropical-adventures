单机版哈姆雷特的Action.lua中action类的定义为：

```lua
require "class"
require "bufferedaction"


Action = Class(function(self, data, priority, instant, rmb, distance, crosseswaterboundary, overrides_direct_walk)
--Action = Class(function(self, priority, instant, rmb, distance, crosseswaterboundary) 
	self.priority = priority or 0
	self.fn = function() return false end
	self.strfn = nil
	self.testfn = nil
	self.instant = instant or false
	self.rmb = rmb or nil
	self.distance = distance or nil
	self.crosseswaterboundary = crosseswaterboundary or false
	self.mount_enabled = data.mount_enabled or false
	self.valid_hold_action = data.valid_hold_action or false
	self.overrides_direct_walk = overrides_direct_walk
end)
```

联机版的Action.lua中action类的定义：

```lua
--Positional parameters have been deprecated, pass in a table instead.
Action = Class(function(self, data, instant, rmb, distance, ghost_valid, ghost_exclusive, canforce, rangecheckfn)
    if data == nil then
        data = {}
    end
    if type(data) ~= "table" then
        --#TODO: get rid of the positional parameters all together, this warning here is for mods that may be using the old interface.
        print("WARNING: Positional Action parameters are deprecated. Please pass action a table instead.")
        print(string.format("Action defined at %s", debugstack_oneline(4)))
        local priority = data
        data = {priority=priority, instant=instant, rmb=rmb, ghost_valid=ghost_valid, ghost_exclusive=ghost_exclusive, canforce=canforce, rangecheckfn=rangecheckfn}
    end

    self.priority = data.priority or 0
    self.fn = function() return false end
    self.strfn = nil
    self.instant = data.instant or false
    self.rmb = data.rmb or nil -- note! This actually only does something for tools, everything tests 'right' in componentactions
    self.distance = data.distance or nil
    self.mindistance = data.mindistance or nil
    self.arrivedist = data.arrivedist or nil
    self.ghost_exclusive = data.ghost_exclusive or false
    self.ghost_valid = self.ghost_exclusive or data.ghost_valid or false -- If it's ghost-exclusive, then it must be ghost-valid
    self.mount_valid = data.mount_valid or false
    self.encumbered_valid = data.encumbered_valid or false
    self.canforce = data.canforce or nil
    self.rangecheckfn = self.canforce ~= nil and data.rangecheckfn or nil
    self.mod_name = nil
	self.silent_fail = data.silent_fail or nil

    --new params, only supported by passing via data field
    self.paused_valid = data.paused_valid or false
    self.actionmeter = data.actionmeter or nil
    self.customarrivecheck = data.customarrivecheck
    self.is_relative_to_platform = data.is_relative_to_platform
    self.disable_platform_hopping = data.disable_platform_hopping
    self.skip_locomotor_facing = data.skip_locomotor_facing
    self.do_not_locomote = data.do_not_locomote
    self.extra_arrive_dist = data.extra_arrive_dist
    self.tile_placer = data.tile_placer
    self.show_tile_placer_fn = data.show_tile_placer_fn
	self.theme_music = data.theme_music
	self.theme_music_fn = data.theme_music_fn -- client side function
    self.pre_action_cb = data.pre_action_cb -- runs on client and server
    self.invalid_hold_action = data.invalid_hold_action

    self.show_primary_input_left = data.show_primary_input_left
    self.show_secondary_input_right = data.show_secondary_input_right

    self.map_action = data.map_action -- Should only be handled from the map and has action translations.
end)
```
