# 网络组件

这里介绍一下网络组件的用法。网络组件指的是添加到TheWorld.net中的组件。这种组件在主机客机都会添加，但在主客机会涉及不同的操作。
比如原版的暴动组件就是这样。这里以mod中的毁灭季`aporkalypse `组件为例简单介绍一下。

网络组件一般都是为了方便客机读取参数，进而执行一些客机的操作，一般涉及到两个位置的配合：组件本身，以及`worldstate`组件。

## 组件架构

```lua
local daytime = TUNING.TOTAL_DAY_TIME
local PHASE_NAMES = { "fiesta", "calm", "near", "aporkalypse", }
local PHASES = table.invert(PHASE_NAMES)
local _world = TheWorld
local _ismastersim = _world.ismastersim


local Aporkalypse = Class(function(self, inst)
	self.inst = inst

	self.first_time = true
	self.near_days = 7 * daytime
	self.aporkalypse_duration = 20 * daytime
	self.should_fiesta_duration = 3 * daytime
	self.fiesta_duration = 7 * daytime
	self.periodtime = 120 * daytime


	self.begin_date = self.periodtime
	self.real_start_date = nil
	self.fiesta_begin_date = nil

	local _phasedirty = true
	_phase = net_tinybyte(inst.GUID, "aporkalypse._phase", "aporkalypsephasedirty")
	_phase:set(PHASES.calm)

```

如毁灭季组件，这里最重要的是定义了一个网络变量`_phase = net_tinybyte(inst.GUID, "aporkalypse._phase", "aporkalypsephasedirty")`用来存储毁灭季的阶段。

网络变量进行值设置的时候，会触发一个事件`aporkalypsephasedirty`，所以这里需要监听这个事件，当这个事件触发的时候，`_phasedirty`变量会变成true，然后就可以进行更新了。
`inst:ListenForEvent("aporkalypsephasedirty", function() _phasedirty = true end)`

而`_phasedirty = true`又是为了触发TheWorld事件。（具体为什么要有这么一个中继环节不是很懂）

```lua
self.OnUpdate = function(dt)
		-- print("try update aporkalypse")
		if _phasedirty then
			print("aporkalypse phase changed:", PHASE_NAMES[_phase:value()])
			_world:PushEvent("aporkalypsephasechanged", PHASE_NAMES[_phase:value()])
			_phasedirty = false
		end
		if _ismastersim then end
	end

```

`"aporkalypsephasechanged"`事件则是预先定义在`worldstate.lua`中：

```lua

local function OnAporkalypseChange(src, phase)
        -- print("aporkalypse world state changed:", phase)
        SetVariable("aporkalypse", phase)
        SetVariable("isaporkalypsecalm", phase == "calm", "aporkalypsecalm")
        SetVariable("isaporkalypsenear", phase == "near", "aporkalypsenear")
        SetVariable("isaporkalypse", phase == "aporkalypse", "aporkalypse")
        SetVariable("isfiesta", phase == "fiesta", "fiesta")
    end

    data.isaporkalypsecalm = true
    data.isaporkalypsenear = false
    data.isaporkalypse = false
    data.isfiesta = false

    inst:ListenForEvent("aporkalypsephasechanged", OnAporkalypseChange)
```
