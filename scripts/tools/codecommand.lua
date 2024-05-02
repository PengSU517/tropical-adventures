--@author: 绯世行
--欢迎其他开发者直接使用，但是强烈谴责搬用代码后对搬用代码加密的行为！
--使用案例及最新版：https://n77a3mjegs.feishu.cn/docx/K9bUdpb5Qo85j2xo8XkcOsU1nuh?from=from_copylink
--这个文件不会被调用，单纯写一些源码的注解，虽然删了更节省体积，不过我相信也许会对其他moder有些帮助，而且全局函数在一些编译器下会提供代码补全功能


Prefab = Class(function(self, name, fn, assets, deps, force_path_search)
end)

------------------------------------------------------------------------------------------------------------------------
--1. simutil.lua

---输出当前代码所在行信息，格式为所在文件+行数+函数名，例如：@scripts/components/weapon.lua:106 in OnAttack
function CalledFrom()
end

---FindEntity 按条件寻找任意符合条件的实体，内部使用TheSim:FindEntities，如果没有符合条件的会返回nil
---@param fn function 在标签筛选后再使用函数进行判断
---@param musttags table|nil 对象必须含有的标签
---@param canttags table|nil 对象不能含有的标签
---@param mustoneoftags table|nil 对象必须含有其中一个标签
---@return table|nil 实体对象或nil
function FindEntity(inst, radius, fn, musttags, canttags, mustoneoftags)
end

---按条件寻找最近的实体
---@param ignoreheight boolean 是否不考虑高度
---@param fn function():boolean 进一步筛选
function FindClosestEntity(inst, radius, ignoreheight, musttags, canttags, mustoneoftags, fn)
end

---FindClosestPlayerInRangeSq 根据距离的平方查找玩家
---@param rangesq number 查找范围的平方，这个值要跟距离的平方比较
---@param isalive boolean 是否要求玩家存活
---@return table|nil,number|nil 查找到的玩家，该玩家与指定位置的距离，如果没找到两个值都为nil
function FindClosestPlayerInRangeSq(x, y, z, rangesq, isalive)
end

---FindClosestPlayerInRangeSq 根据距离查找玩家
function FindClosestPlayerInRange(x, y, z, range, isalive)
end

-- 查找最近的玩家，查找玩家列表，随机查找玩家...

---FindNearbyLand 根据给定位置在附近随机选择一处陆地位置
---@param position Vector3 查找位置
---@param range number 查找距离，默认8
---@return Vector3|nil
function FindNearbyLand(position, range)
end

---FindNearbyOcean 根据给定位置在附近随机选择一处海洋位置
function FindNearbyOcean(position, range)
end

---GetRandomInstWithTag 查找实体对象附近标签符合要求的任意一个对象，有可能是inst
---@param tag table|string 单个标签或标签组，标签组的话要求所有标签都含有
function GetRandomInstWithTag(tag, inst, radius)
end

---GetClosestInstWithTag 查找实体对象附近标签符合要求的最近的一个对象，不包含inst
---@param tag table|string 单个标签或标签组，标签组的话要求所有标签都含有
function GetClosestInstWithTag(tag, inst, radius)
end

---抖动所有玩家屏幕
function ShakeAllCameras(mode, duration, speed, scale, source_or_pt, maxDist)
end

---FindValidPositionByFan 以原点为圆心，扇形展开的方式查找任意一个可用的点
---@param start_angle number 开始查找的角度，查找会从该角度向两边同时查找
---@param radius number 查找半径
---@param attempts number 查找次数，这也是将圆等分几点
---@param test_fn function(Vector3):boolean 判断找到的点是否合法
---@return Vector3
function FindValidPositionByFan(start_angle, radius, attempts, test_fn)
end

---FindValidPositionByFan 以原点为圆心，扇形展开的方式查找任意一个可以行走的点
function FindWalkableOffset(position, start_angle, radius, attempts, check_los, ignore_walls, customcheckfn, allow_water,
                            allow_boats)
end

---海洋版本
function FindSwimmableOffset(position, start_angle, radius, attempts, check_los, ignore_walls, customcheckfn, allow_boats)
end

---FindPickupableItem 在地上查找一个可以拾取或采集的对象（像ACTIONS.PICKUP或者ACTIONS.CHECKTRAP），一般来说就是可以采集的对象和捕获猎物的陷阱，一般用于NPC的分工采集机制，例如麦斯威尔的暗影仆
---除了参数里限制的，还默认排除可装备的、正在燃烧的、不能放入物品栏的、没有上钩的诱饵或陷阱、背包拾取达到数量上限的可拾取对象、查找人正在执行动作的对象
---@param owner Entity 查找人，需要含有inventory组件，如果查找人对对象已经有动作了也会排除
---@param radius number 查找半径
---@param furthestfirst boolean 是否从最远的对象开始遍历
---@param positionoverride Vector3 如果存在则从该点查找，否则从查找人所在位置开始查找
---@param ignorethese table[] 工人工作数组，如果对遍历到的对象v有 ignorethese[v].worker ~= nil，表示该对象已经有工人正在工作了，直接忽略，用该表让多个NPC对不同的对象执行动作
---@param onlytheseprefabs table 只允许的对象预制体名，如果是可采集的（含有pickable标签）则表内为采集后的产物名，否则就是对象名
---@param allowpickables boolean 如果对象可采集是否允许采集
---@param worker void 要执行动作的工人
---@param extra_filter function(worker, v, owner):boolean 过滤器
function FindPickupableItem(owner, radius, furthestfirst, positionoverride, ignorethese, onlytheseprefabs, allowpickables,
                            worker, extra_filter)
end

---对象是否能在夜晚看见，会通过playervision组件检查或者是否已经装备含有nightvision标签的装备
function CanEntitySeeInDark(inst)
end

--在沙尘暴中看见、是否能看见某个点、是否能看见某个对象...

---移除对象碰撞体积一段时间，没有Physics的对象会报错的（可惜没有把定时任务返回，让开发者随意控制）
function TemporarilyRemovePhysics(obj, time)
end

---ErodeAway 让对象的动画在几秒后消失，这中间是一个被腐蚀的过渡效果，绝对可以为懒得做动画的预制体派上用场，腐蚀动画结束后会Remove方法
function ErodeAway(inst, erode_time)
end

---ErodeCB 让对象的动画在几秒后消失，不过在消失后执行执行后续操作
---@param inst Entity 执行的对象
---@param erode_time number 腐蚀时间
---@param cb function(Entity) 腐蚀结束后的对对象执行的后续操作
---@param restore boolean 腐蚀结束后是否恢复，这个恢复是直接让对象可见，没有过渡的动画
function ErodeCB(inst, erode_time, cb, restore)
end

---ApplySpecialEvent 修改当前游戏活动，可在游戏中生效
---@param event string 活动名，在 SPECIAL_EVENTS 中查找所有活动名
function ApplySpecialEvent(event)
end

---GetInventoryItemAtlas 获取物体图像别名，输入images/../XXX.xml后可以得到更简单的图像名
---@param imagename string 原本包含路径的图像名
---@param no_fallback boolean|nil 如果为false并且图像不存在时，返回 "images/inventoryimages3.xml" ，否则为true
function GetInventoryItemAtlas(imagename, no_fallback)
end

--注册图像别名、ScrapbookIcon、SkilltreeBG...
------------------------------------------------------------------------------------------------------------------------

--2.componentutil.lua

---对象是否死亡
---@param require_health boolean Require_health为true意味着如果实体缺乏健康副本，则认为它“死亡”。
function IsEntityDead(inst, require_health)
end

---判断实体是否死亡
function IsEntityDeadOrGhost(inst, require_health)
end

---获取物品数量
function GetStackSize(inst)
end

---掉落一个地皮
function HandleDugGround(dug_ground, x, y, z)
end

------------------------------------------------------------------------------------------------------------------------

--3.consolecommands.lua
--指令太多了，只挑一些讲

--返回鼠标选中的对象
function c_select(inst)
end

---获取一个玩家，优先选择鼠标所选的玩家
function ConsoleCommandPlayer()
end

---返回鼠标选中位置,c_spawn用的就是该函数获取鼠标位置
function ConsoleWorldPosition()
end

---获取鼠标所选的对象，查找半径为1
function ConsoleWorldEntityUnderMouse()
end

---发送服务公告
function c_announce(msg, interval, category)
end

---鼠标所选位置生成鱼人王
function c_mermking()
end

---鼠标所选位置生成还没建好的鱼人王，并把升级材料给玩家
function c_mermthrone()
end

---把所有书给玩家
function c_allbooks()
end

---回滚
function c_rollback(count)
end

---重新启动服务器
function c_reset()
end

--删除世界、重新生成世界、保存、退出程序...

---鼠标所选位置生成对象
function c_spawn(prefab, count, dontselect)
end

---解锁全科技
function c_freecrafting(player)
end

---锁血
function c_setminhealth(n)
end

---查找指定预制体，范围为9001
function c_list(prefab)
end

---强制崩溃，不知道搞这个有啥用
function c_forcecrash(unique)
end

---一堆初始装备和材料
function c_goadventuring(player)
end

---弹出声音日志检测面板，实时监测播放的声音，还能显示对象的音量大小，moder喜欢哪种声音找不到源码的话可以试试用这个找
function c_sounddebugui()
end

---一艘好船和满船的物资
function c_makeboat()
end

---给指定单位挂一个圆形指示器的动画，也许是给作者参考用的
function c_showradius(radius, parent)
end

------------------------------------------------------------------------------------------------------------------------

--4.debugcommands.lua
--科雷懒，有些指令有bug

---一地的玩家专属物品
function d_playeritems()
end

---一堆蜘蛛，初始就是被雇佣的状态
function d_spiders()
end

---所有火焰特效，并且还把名字挂上去了，真贴心，这些粒子特效作为一些对象的尾气效果特别好
function d_particles()
end

---生成时空裂隙
function d_riftspawns()
end

--月亮裂隙、暗影裂隙...

---技能树解锁技能点
function d_resetskilltree()
end

---下雨/下玻璃雨
function d_togglelunarhail()
end

---一头训化的牛
function d_domesticatedbeefalo(tendency, saddle)
end

---改变鼠标所选单位的sg
function d_teststate(state)
end

---蚁狮的地震效果，做到mod里也许不错
function d_sinkhole()
end

---设置指定位置的地皮，可用于填海
function d_ground(ground, pt)
end

---不知道有啥用，但是角色会有一个从全黑到正常的过渡动画
function d_portalfx()
end

---生成一圈正方形墙体
function d_walls(width, height)
end

---生成一个麦斯威尔的暗影仆从收集资源，还会给你
function d_waxwellworker()
end

---同上
function d_waxwellprotector()
end

---生成预设的布局，这个功能有些强大，游戏中可以一下子改变大块儿地形，布局可以在layouts.lua中查找，例如 Waterlogged1
function d_spawnlayout(name, offset)
end

---以鼠标所指位置为圆心，摆一圈燧石
function d_radius(radius, num, lifetime)
end

---马上让玩家在月亮风暴之中
function d_startmoonstorm()
end

---停止月亮风暴
function d_stopmoonstorm()
end

---这个似乎能读取文件，生成文件里的所有预制体
function d_spawnfilelist(filename, spacing)
end

---训练用的假人，打不死
function d_punchingbags()
end

--Hash distribution checks for collisions.
---一个算法，没研究是干什么的，待补充
function d_testhashes_random(bitswanted, tests)
end

function d_testhashes_prefabs(bitswanted)
end

function d_testdps(time, target)
end

---解锁所有图鉴，可以反过来关闭所有图鉴
function d_unlockscrapbook() end

---展示龙蝇之年的所有箭头
function d_boatracepointers() end

------------------------------------------------------------------------------------------------------------------------

--5.debughelpers.lua
---打印组件信息
function DumpComponent(comp)
end

---打印实体对象信息
function DumpEntity(ent)
end

------------------------------------------------------------------------------------------------------------------------
--6.debugkeys.lua
-- 可以在modmain.lua中写下 GLOBAL.CHEATS_ENABLED = true 来开启测试模式，或者控制台开启也行

--快捷键介绍
--R：重载游戏，无法重载动画资源
--F3：切换季节
--F4：一个简单的家
--CTRL+F5：天降陨石
--CTRL+K：删除选中物
--ALT+K：传送指定位置
--CTLR+S：保存
--CTLR+H：隐藏制作栏、物品栏、状态等面板（其实调用了 ThePlayer.HUD:Toggle()）
--ALT+H：猎犬袭击
------------------------------------------------------------------------------------------------------------------------

--7.entityscript.lua

---获取实体对象的各项数据，使用SpawnSaveRecord复原一个一样的对象出来，返回的数据可在onsave中保存，实现随从跟随上下洞穴的效果
function EntityScript:GetSaveRecord() end

---从屏幕中移除
function EntityScript:RemoveFromScene()
end

---回到屏幕中
function EntityScript:ReturnToScene()
end

---根据两对象之间的位置，计算target朝inst前进distance后的最终落点，注意这里是计算target的最终落点
function EntityScript:GetPositionAdjacentTo(target, distance)
end

---使实体面向远离指定点的方向
function EntityScript:FaceAwayFromPoint(dest, force)
end

--- 使对象绑定自己，相对位置、形变保持不变，例如如果inst缩放后，inst的所有child都会被缩放
--- 需要注意的是如果是对fx.lua里定义的特效则不行，那个好像是服务端直接删除对象的
function EntityScript:AddChild(child) end

--- 大概是取消所有延时任务和周期任务，可以在想要修改一些预制体但是拿不到延时任务的函数时取消任务用的，
--- 比如海浪特效wave_med会在生成时启动一个延时任务，判断是否在陆地，如果在陆地直接消失并生成浪花，任务没有赋值给inst并且调用的是一个local函数，你想做一个可以在陆地播放的海浪特效就必须移除这个任务
function EntityScript:CancelAllPendingTasks() end

---对单位施加一个buff，比如植物人受到攻击后会禁锢敌人 attacker:AddDebuff("wormwood_vined_debuff", "wormwood_vined_debuff")
---@param name string
---@param prefab string
---@param data any
---@param skip_test any
---@param pre_buff_fn any
function EntityScript:AddDebuff(name, prefab, data, skip_test, pre_buff_fn) end

---单位脱离加载范围就会进入sleep，对于客机上的特效有时候会调用inst.entity:SetCanSleep(false)让其一直运行（我猜的）
---可以用这个判断来决定执行的操作，比如我想让猪人房的猪人回家，如果在加载范围我会让它跑回家，如果不在我会直接把它传送到加载范围内屏幕外再让它跑回家
function EntityScript:IsAsleep() end

---使用SpawnSaveRecord函数还原对象时会调用该方法，该方法会调用对象的OnPreLoad、OnLoad还有组件的OnLoad，用于加载对象和组件保存的数据用的
function EntityScript:SetPersistData(data, newents) end

--- 修改预制件的描述和名称，但不会覆盖预制件本身。nameoverride应该是您希望用于名称和描述的预制件。
function EntityScript:SetPrefabNameOverride(nameoverride) end

--- 获取对象的当前皮肤名
function EntityScript:GetSkinName() end

------------------------------------------------------------------------------------------------------------------------
--8.mainfunctions.lua

---@return Entity
function SpawnPrefab(name, skin, skin_id, creator)
end

--- 根据GetSaveRecord的数据复原对象，inventory、container等组件都会调用SpawnSaveRecord来还原对象，该操作还会加载对象或组件保存的数据
function SpawnSaveRecord(saved, newents) end

---SavePersistentString 持久化存储，保存在客机上，可以通过键能找到对应的文件，读出方式为
---TheSim:GetPersistentString("vsroom",
---        function(load_success, str)
---            if load_success then print(str) end
---        end)
---@param name string 键
---@param data string 数据，必须为字符串
---@param encode boolean|nil 猜测是编码方式
---@param callback function|nil 保存成功后的回调函数
function SavePersistentString(name, data, encode, callback)
end

---SavePersistentString 删除存储的数据
function ErasePersistentString(name, callback)
end

---秒数转时间字符串
function SecondsToTimeString(total_seconds)
end

---获取一个时钟周期，我测试的结果为0.03333...，正好是一帧（FRAMES）的时间
function GetTickTime()
end

---游戏时间，单位为秒，暂停后不记时，每次启动服务器重置
---TheSim:GetTick()
function GetTime()
end

---游戏运行时间，单位为秒，暂停后依旧计时，每次启动服务器重置
function GetStaticTime()
end

---真实时间，单位为毫秒
function GetTimeReal()
end

------------------------------------------------------------------------------------------------------------------------

--9.mathutil.lua

---根据游戏时间返回正弦波。Mod会修改周期的波浪和腹肌是你是否想要的波浪的abs值
function GetSineVal(mod, abs, inst)
end

---规格化角度在[-180,180]，方便一些math.cos、math.sin的计算
function ReduceAngle(rot)
end

---两角度之差，在[0,180]
function DiffAngle(rot1, rot2)
end

---规格化弧度在[-pi,pi]
function ReduceAngleRad(rot)
end

---两弧度之差，在[0,pi]
function DiffAngleRad(rot1, rot2)
end

------------------------------------------------------------------------------------------------------------------------

--10.vecutil.lua

---返回规格化之后的两个值，两个参数不能都为0
---单位向量除了用于计算距离和速度外，把其中一个值取反就变成与原向量垂直的单位向量，可以用于计算圆周运动的速度
function VecUtil_Normalize(p1_x, p1_z)
end

---计算两个二维向量之间的夹角，返回值在[0, 2π]
function VecUtil_GetAngleInRads(p1_x, p1_z)
end

---VecUtil_Slerp 根据给定百分比，计算从一边到另一边的过程端点偏移量（球面线性插值），这应该不是把对象的坐标输入进去，而是把偏移向量作为参数，不然坐标距离零点太远了
---@param percent number 从角度1到角度2的百分比
function VecUtil_Slerp(p1_x, p1_z, p2_x, p2_z, percent)
end

---涉及向量方面的知识，结论就是以点a为圆心，点b顺时针旋转指定弧度
---@param theta number 旋转的弧度，[-π,π]
function VecUtil_RotateAroundPoint(a_x, a_z, b_x, b_z, theta)
end

---距离的平方
function VecUtil_DistSq(p1_x, p1_z, p2_x, p2_z) end

---距离
function VecUtil_Dist(p1_x, p1_z, p2_x, p2_z) end

------------------------------------------------------------------------------------------------------------------------
--11.util.lua

---距离的平方
function distsq(v1, v2, v3, v4) end

---浅拷贝
function shallowcopy(orig, dest) end

---深拷贝
function deepcopy(object) end

--- 获取表中键值对的个数
function GetTableSize(table) end

function table.getkeys(t) end

--- 数组追加
function ConcatArrays(ret, ...) end

--- 合并数组，不查重
function JoinArrays(...) end

--- 把参数的所有的键值表合并为一个新表，浅拷贝，后面的会覆盖前面的
function MergeMaps(...) end

--- 把其他表的元素追加到ret表中
function ConcatArrays(ret, ...) end

--- 获取task的剩余执行时间，不存在时返回-1
function GetTaskRemaining(task) end

---循环数组，可以一直添加元素，溢出的部分会覆盖前面的
RingBuffer()

---链表，经典又好用，对于先进先出的数据比较友好（虽然方法少的还没初学者写的链表方法多）
LinkedList()

---从给定的对象表里面选一个距离target最近的对象出来
function GetClosest(target, entities)
end

---在指定位置生成对象
---@param prefab any
---@param loc Entity|Vector3 对象或坐标
---@param scale Vector3|table|nil
---@param offset array|nil 三个方向上的偏移量
function SpawnAt(prefab, loc, scale, offset)
end

---从表中随机取一个元素，也适用于键值对的表
function GetRandomItem(choices)
end

---同上，但是包含key，也就是说挑一个键值对出来
function GetRandomItemWithIndex(choices) end

---带有权重的随机取数，越大的值越有可能选中
---@param choices array[number] 权重值表
function weighted_random_choice(choices)
end

---打印
function PrintTable(tab)
end

---从表中随机选一个，支持键值对表
function weighted_random_choice(choices) end

---从表中随机选指定个
function weighted_random_choices(choices, num_choices) end

--表查找、表排序、数组打乱、获取任务剩余时间、键值对排序、浅拷贝、深度拷贝对象、环形缓冲区、链表、颜色格式转换、（好像还有压缩包解码）...
------------------------------------------------------------------------------------------------------------------------

--11.input.lua
--对鼠标事件和键盘事件的一系列监听方法，以及屏幕相关信息

---获取鼠标位置
function Input:GetWorldPosition()
end

---监听鼠标移动事件，注意初始并不会调用
function Input:AddMoveHandler(fn)
end

---...移动、按键等等

------------------------------------------------------------------------------------------------------------------------

--12. scheduler.lua

---启动一个线程任务
---@param id number 一般是对象的GUID
function StartThread(fn, id, param)

end

-- 13. emitters.lua
-- 有一些粒子相关的工具函数

--- 根据参数计算x和z，随机在[-radius, radius]取，这个范围是一个矩形
function CreateDiscEmitter(radius) end

--- 根据参数计算x和z，圆内随机取一点，这个范围是一个圆
function CreateCircleEmitter(radius) end

--- 根据参数计算x和z，在半径为radius的圆边上取一点，这个范围是一个圈
function CreateRingEmitter(radius) end

--- 根据参数计算x,y,z，在半径为radius的球表面取一点，这个范围是一个球体
function CreateSphereEmitter(radius) end

--- 根据参数计算x,y,z，随机在指定区域内取，这个范围是一个长方体
function CreateBoxEmitter(x_min, y_min, z_min, x_max, y_max, z_max) end

--- 根据参数计算x和y，在提供的多边形区域内随机地生成一个点，随机取两相邻顶点和中心组成三角形，返回三角形内的一点，组合起来就是在所有顶点组成的多边形区域内取一点，这个范围是一个多边形
---@param polygon table 顶点数组，表示多边形的角点
---@param centroid table 多边形的质心或中心点的坐标
function CreateAreaEmitter(polygon, centroid) end

--- 根据参数计算x,y,z，在给定的三角形组里随机挑一个三角形，这个三角形内的随机一点并应用一个缩放变换，组合起来就是在所有给定的三角形区域内取一点儿，这个范围是多个三角形
function Create2DTriEmitter(tris, scale) end

------------------------------------------------------------------------------------------------------------------------
--13. AnimState
owner.AnimState:OverrideSymbol("swap_hat", "myflowerhat", "swap_hat")
-- 表示用myflowerhat.scml动画中的swap_hat(后)文件夹中的图，替换owner中swap_hat(前)中的图。

owner.AnimState:ClearOverrideSymbol("swap_hat")
-- 取消替换某个文件夹的图，即替换回来。

-- 参数：单位GUID、图层名、x偏移、y偏移、z偏移、是否跟随层级，为false允许缩放和层级设置、（不知道）、对应哪个面，玩家范围是0-2，如果特效有四个面会在玩家改变面时自动改变
ThePlayer.fx.Follower:FollowSymbol(ThePlayer.GUID, "headbase", 0, 0, -4, true, nil, 0);
-- 颜色乘积，r、g、b、alpha，可以调整颜色和不透明度
ThePlayer.fx.AnimState:SetMultColour(1, 1, 1, 1);
-- 颜色相加，也是r、g、b、alpha，可以调整颜色和不透明度
ThePlayer.fx.AnimState:SetAddColour(0, 0, 0, 0);
-- 动画播放速度
ThePlayer.fx.AnimState:SetDeltaTimeMultiplier(1);
-- 缩放
ThePlayer.fx.AnimState:SetScale(1, 1, 1);
-- 应该叫后期处理吧
ThePlayer.fx.AnimState:SetBloomEffectHandle("shaders/anim_bloom_ghost.ksh");
ThePlayer.fx.AnimState:SetBloomEffectHandle("shaders/anim.ksh");
-- 夜晚可见度
ThePlayer.fx.AnimState:SetLightOverride(1);
-- 动画层级，FollowSymbol倒数第三个参数为false时起效
ThePlayer.fx.AnimState:SetSortOrder(1);
-- 图层优先级
ThePlayer.fx.AnimState:SetFinalOffset(0);

ThePlayer.fx.AnimState:SetLayer(LAYER_BACKGROUND);

------------------------------------------------------------------------------------------------------------------------
-- 14. physics.lua

--从单位身上向目标扔一个掉落物出来
function LaunchAt(inst, launcher, target, speedmult, startheight, startradius, randomangleoffset) end

---摧毁workable、pickable、无移动组件的
function DestroyEntity(ent, destroyer, kill_all_creatures, remove_entity_as_fallback) end

------------------------------------------------------------------------------------------------------------------------
-- 15. HUD相关
-- 本地调用，服务端调用没用

-- 打开小地图
ThePlayer.HUD.controls:ToggleMap()

-- 当前小地图是否打开
ThePlayer.HUD:IsMapScreenOpen()


------------------------------------------------------------------------------------------------------------------------
-- 16. ocean_util.lua

--- 生成向前冲击的海浪
function SpawnAttackWave(position, rotation, waveSpeed, wavePrefab, idleTime, instantActive) end

---判断是否落水
---@param entity_sinks_in_water boolean 单位是否沉入水底
function ShouldEntitySink(entity, entity_sinks_in_water) end

--- 单位落水处理
function SinkEntity(entity) end

------------------------------------------------------------------------------------------------------------------------
-- 17. player_common.lua


local function SnapCamera(inst, resetrot) end

---玩家屏幕亮度，方法绑定在玩家身上，注意不要随便调用，屏幕黑了后按Esc不行，控制台也打不开
---示例：ThePlayer:ScreenFade(true, 1) 由黑过渡到亮
---@param inst any
---@param isfadein any 为true就是从黑到亮，否则就是由亮到黑
---@param time any 过渡时间
---@param iswhite any
local function ScreenFade(inst, isfadein, time, iswhite) end

-- 18. commonstates.lua
-- 封装了很多stategraph相关的函数，简化很多代码

--- 创建简单的走路state
CommonStates.AddSimpleWalkStates = function(states, anim, timelines) end
--- 创建简单的奔跑state
CommonStates.AddSimpleRunStates = function(states, anim, timelines) end

--- 返回一个EventHandler，处理locomote事件，方法会GoToState：run_start、run_stop、walk_start、walk_stop
CommonHandlers.OnLocomote = function(can_run, can_walk) end

------------------------------------------------------------------------------------------------------------------------

-- 19. skilltreedata.lua
-- 玩家技能树的数据保存在本地，在加载后会有一个全局变量TheSkillTree记录玩家的技能树数据

--- 得到已经激活的技能{已激活技能名,true}
function SkillTreeData:GetActivatedSkills(characterprefab) end

--- 添加一个激活技能
---@param skill string 技能名
---@param characterprefab string 技能树拥有者，角色预制体名
function SkillTreeData:DeactivateSkill(skill, characterprefab) end

--- 某个技能是否已经激活
function SkillTreeData:IsActivated(skill, characterprefab) end

------------------------------------------------------------------------------------------------------------------------

-- 20. widgets/redux/skilltreebuilder.lua
-- 控制技能面板组件的绘制

--- 刷新面板组件，角色打开技术树，点击技能等操作都会调用该方法重绘
function SkillTreeBuilder:RefreshTree() end

------------------------------------------------------------------------------------------------------------------------
-- 20. TheNet
TheNet:GetIsServer() -- 判断是否是主机（创建游戏者）
TheNet:GetIsClient() -- 判断是否是客机（加入游戏者）
TheNet:IsDedicated() -- 判断是否是服务器

------------------------------------------------------------------------------------------------------------------------

-- 21. standardcomponents.lua

---装备耐久为0不消失，可修复
function MakeForgeRepairable(inst, material, onbroken, onrepaired) end

------------------------------------------------------------------------------------------------------------------------
-- 22. components/map.lua
--可以通过TheWorld.Map:XXX() 直接调用

---map组件方法，获取指定位置的地皮信息tile，类型为WORLD_TILES、GROUND常量里定义的值，整数类型，表示地皮编号
print(TheWorld.Map:GetTileAtPoint(ConsoleWorldPosition():Get()));
-- 参数为地皮坐标
-- TheWorld.Map:GetTile(newX, newZ)

-- 有效地面
print(TheWorld.Map:IsAboveGroundAtPoint(ConsoleWorldPosition():Get()));

-- 所给位置地皮坐标，单位大小为地皮，草叉显示虚线方块就是调用该方法
print(TheWorld.Map:GetTileCoordsAtPoint(ConsoleWorldPosition():Get()));

-- 所给位置所处地皮的中心位置
print(TheWorld.Map:GetTileCenterPoint(ConsoleWorldPosition():Get()));

-- 添加一个隐形墙体，玩家还是可以用键盘空间角色穿过，但是自动寻路会规避墙体
TheWorld.Pathfinder:AddWall(x + 0.5, 0, z + 0.5);

----------------------------------------------------------------------------------------------------
-- prefabutil.lua

-- 制作placer，如果希望有吸附效果的placer，可以参考月亮虹吸器的，prefabs/moon_device.lua
function MakePlacer(name, bank, build, anim, onground, snap, metersnap, scale, fixedcameraoffset, facing, postinit_fn,
                    offset, onfailedplacement)
end

----------------------------------------------------------------------------------------------------
-- followcamera.lua

-- 客机获取玩家摄像头旋转角度
print(TheCamera.headingtarget)


TheShard:GetShardId()


--- 将Lua中的数据结构（如表、数字、字符串等）转换为一个字符串形式的Lua代码，这样就可以将这个字符串保存到文件中，在需要的时候再加载回来，实现数据的持久化。这个函数在游戏开发中可能用于保存游戏状态，或者在调试时导出数据结构。
--- value: 需要被转储为字符串的 Lua 值。
--- varname: 转储后的 Lua 代码中，变量的名称。
--- fastmode: 一个布尔值，指示是否使用快速模式，快速模式可能不会处理一些复杂的数据结构，但速度更快。
--- ident: 缩进级别，用于格式化生成的 Lua 代码，使其更易于阅读。
function DataDumper(value, varname, fastmode, ident) end

---还原DataDumper处理后的数据
function RunInSandboxSafe(untrusted_code, error_handler) end

----------------------------------------------------------------------------------------------------
-- combat_replica.lua

AddClassPostConstruct("components/combat_replica", function(self)
    -- 攻击玩家三要素
    self.IsValidTarget = Utils.TrueFn
    self.CanTarget = Utils.TrueFn     --可以攻击，但无伤害
    self.CanBeAttacked = Utils.TrueFn --攻击玩家有伤害
end)

----------------------------------------------------------------------------------------------------
-- components/weather.lua

-- 推送下雨事件
TheWorld:PushEvent("ms_forceprecipitation", true)

function AddClassPostConstruct(package, postfn) end