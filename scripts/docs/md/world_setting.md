# 添加配置项

## 世界配置和mod配置

一般来说，玩家可以通过两个方式来配置世界的一些参数，即为
- 世界设置项
- mod设置项

其中mod设置项在modinfo中进行添加，世界设置项需要通过`AddCustomizeGroup`函数添加，添加内容详见`main/ta_customize.lua`。
但是两种设置方式都有一定的缺点：

- 在客户端开服时，mod设置项不能对地上、地下世界分别设置
- 在服务器开服时，很多服务器并不兼容添加的世界设置项

所以我们将同一套设置（这些设置定义在modinfo中），同时添加到了世界设置项和mod设置项中，便可以做到：

- 在客户端开服时，可以在森林/洞穴设置中分别进行世界设置
- 在服务器开服时，如果没有相应的世界配置选项，可以在mod设置中对服务器进行分别设置


## 世界设置项

### 导入
世界设置项可以直接通过modworldgenmain导入（详见main/ta_customize），但是在前端配置的时候，需要加载设置项相关的美术资源，这点modworldgenmain做不到。
所以我们还需要通过worldservercreationmain.lua加载前端所需要的内容（主要是美术资源）。

### 读取
modworldgenmain在生成世界和加载世界的时候都会被导入到游戏中，但是两个过程所暴露出来的内容是不一样的。

#### 世界生成阶段
这个阶段暴露出来的函数是WorldSim,这时候世界配置项已经加载到了全局变量`GEN_PARAMETERS`中，我们只需要读取这个就好了

```lua 
require("json")
        local world_gen_data = json.decode(rawget(_G, "GEN_PARAMETERS"))
        world_overrides = deepcopy(world_gen_data.level_data.overrides)
```
#### 世界加载阶段

这个阶段暴露出来的函数是TheSim，没有可以直接读取的`"GEN_PARAMETERS"`参数，这时候就需要自行读取当前服务器内的`../leveldataoverride.lua`。
读取过程详见`scripts/tools/configutil.lua`中定义的函数

但还存在一点问题是，客机是读不到主机的`leveldataoverride.lua`的，甚至在主客机一体时这个问题也存在。
这种情况下，就要在客机加载世界时，读取主机的配置项,主机的配置项会被保存在`TheWorld.topology.overrides`中。

```lua
if not TheNet:IsDedicated() then 
    print("reupdate overrides in client")
    AddSimPostInit(function() modimport("main/ta_config_client") end)
else
    print("not reupdate overrides in client")
end
```
这个读取方式也许并不是最优方案，因为客户端读取主机的overrides的时机仍然有些晚，导致有些操作没法实现.但是目前没有找到更好的解决办法。

## Mod设置项

mod设置比较简单，一点需要注意的是，客机的mod设置也会和主机保持同步

## TODO事项

#### 客户端读取主机的overrides的时机仍然有些晚，导致有些操作没法实现
#### 设置几个自定义的预制世界选项