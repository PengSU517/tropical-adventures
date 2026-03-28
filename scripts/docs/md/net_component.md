# 世界网络实体(`TheWorld.net`)

通常的网络实体由主机持有`Entity`和`EntityReplica`, 客机仅持有加载范围内的`EntityReplica`, 不同于其他网络实体, 客机`TheWorld`并不是主机`TheWorld`的`EntityReplica`, `TheWorld`的网络实体实际上是`TheWorld.net`。`TheWorld`的**网络变量**以及**同步组件**要放到`TheWorld.net`中进行同步。

网络组件一般都是为了方便客机读取参数，进而执行一些客机的操作，一般涉及到两个位置的配合：组件本身，以及`worldstate`组件。

## 示例

```lua
local PHASE_NAMES = { "fiesta", "calm", "near", "aporkalypse", }
local PHASES = table.invert(PHASE_NAMES)

local function NetAporkalypsePostInit(inst)
    if TUNING.aporkalypse then
        inst._aporkalypse_phase = net_tinybyte(inst.GUID, "aporkalypse.phase", "aporkalypse.phasedirty") -- 添加一个用于大灾变组件phase同步的网络变量
        inst._aporkalypse_phase:set_local(2)
        inst:ListenForEvent("aporkalypse.phasedirty", function()
            TheWorld:PushEvent("aporkalypsephasechanged", PHASE_NAMES[inst._aporkalypse_phase:value()])
        end)
        if TheWorld and TheWorld.ismastersim and TheWorld.components.aporkalypse then -- 仅主机有同步权限
            inst._aporkalypse_phase:set(TheWorld.components.aporkalypse._phase)
        end
    end
end

AddPrefabPostInit("forest_network", function(inst) -- 地面世界的网络实体名
    NetAporkalypsePostInit(inst)
    inst:AddComponent("weatherham")
end)

AddPrefabPostInit("cave_network", NetAporkalypsePostInit) -- 洞穴世界的网络实体名


```