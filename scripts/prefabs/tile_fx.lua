-- "C:\Program Files (x86)\Steam\steamapps\common\Don't Starve Mod Tools\mod_tools\tools\bin\ShaderCompiler.exe" -little "tile_particle_water" "tile_particle_water.vs" "tile_particle_water.ps" "tile_particle_lilypond.ksh" -oglsl

-- 定义颜色包络线名称，用于粒子颜色动画曲线
local COLOUR_ENVELOPE_NAME = "pl_tilecolourenvelope" -- Name of the color animation curve envelope
-- 定义缩放包络线名称，用于粒子缩放动画曲线
local SCALE_ENVELOPE_NAME = "pl_tilescaleenvelope"   -- Name of the scale animation curve envelope

-- 定义粒子最大生命周期，单位为纳秒(2秒)
local MAX_LIFETIME = 2 * 1e9 -- shader中的PS_TEXCOORD_LIFE.z为生命周期进度百分比

-- 资源列表，包含纹理和着色器资源
local assets =
{
    Asset("IMAGE", "levels/merged_tex/water_shallow.tex"),

    -- Asset("SHADER", "shaders/tile_particle.ksh"),
    Asset("SHADER", "shaders/tile_particle_lilypond.ksh"),
}

-- 地砖纹理坐标表，定义了每种地砖变体在纹理图中的UV坐标
-- 每个条目对应一种地砖样式，存储其在纹理图中的u,v坐标


local xmlrst = ReadAtlasXml("levels/merged_tex/water_shallow.xml")
local TileTexcoord = xmlrst.elements

--------------------------------------------------------------------------

-- 初始化颜色和缩放包络线 (Animation envelopes for particle color and scale over lifetime)
-- 该函数只在首次调用时执行，之后会设为nil避免重复初始化
local function InitEnvelope()
    -- 颜色包络线: 定义粒子在其生命周期内颜色的变化
    -- 格式: {时间点, {红, 绿, 蓝, 透明度}}
    EnvelopeManager:AddColourEnvelope(
        COLOUR_ENVELOPE_NAME,
        {
            { 0, { 1, 1, 1, 0.85 } }, -- 开始时为白色/完全不透明
            { 1, { 1, 1, 1, 0.85 } }, -- 结束时为白色/完全不透明 (整个生命周期无颜色变化)
        }
    )

    local width, height = 1.171875 * 4, 1.171875 * 4 ----这个是用来控制显示窗口的缩放
    --------如果设置为半透明 那么分缝就会比较明显
    EnvelopeManager:AddVector2Envelope(
        SCALE_ENVELOPE_NAME,
        {
            { 0, { width, height } }, -- 初始缩放
            { 1, { width, height } }, -- 最终缩放 (整个生命周期无缩放变化)
        }
    )

    -- 将函数设为nil，确保只初始化一次
    InitEnvelope = nil
end

--------------------------------------------------------------------------

-- 在指定位置生成地砖粒子效果
-- 参数:
-- inst: 实体实例
-- pos: 生成位置(Vector3)
-- overhang_type: 地砖类型(决定使用哪种纹理)
-- index: 粒子发射器索引
local function SpawnTile(inst, pos, overhang_type, index)
    local overhang_type = overhang_type and overhang_type <= 48 and overhang_type or 17
    inst.Transform:SetPosition(pos.x, pos.y, pos.z)

    inst.VFXEffect:AddParticleUV(
        index,
        MAX_LIFETIME, -- 生命周期
        0, 0, 0,      -- 位置
        0, 0, 0,      -- 速度
        -- 0, 0,
        -- 0.000488281, 0.375488
        TileTexcoord[overhang_type].u1, TileTexcoord[overhang_type].v1
    )
end

-- 清除指定索引的地砖粒子效果
-- 参数:
-- inst: 实体实例
-- index: 要清除的粒子发射器索引
local function ClearTile(inst, index)
    inst.VFXEffect:ClearAllParticles(index)
end

-- 测试生成函数，在当前位置周围生成地砖粒子效果
-- 用于调试，在以当前实体为中心的13x13网格区域内生成粒子
local function TestSpawn(inst)
    local pos = inst:GetPosition()
    for i = -6, 6, 1 do
        for j = -6, 6, 1 do
            inst:SpawnTile(pos + Vector3(i * 4, 0, j * 4), 0)
        end
    end
end

-- 存储地砖特效数据的全局变量
local tile_fx_datas = {}

-- 创建地砖特效实体的工厂函数
-- 接收地砖数据配置，创建并返回地砖特效实体
function SpawnTileFxEntity(tile_datas)
    tile_fx_datas = tile_datas
    local tile_fx = SpawnPrefab("tile_fx")
    tile_fx_datas = {}
    return tile_fx
end

-- 实体创建函数
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()

    inst:AddTag("FX")              -- 特效标签
    inst:AddTag("CLASSIFIED")      -- 分类标签
    --[[Non-networked entity]]     -- 非网络同步实体
    inst.entity:SetCanSleep(false) -- 禁用休眠
    inst.persists = false          -- 不保存游戏状态

    -- 初始化包络线(如果尚未初始化)
    if InitEnvelope ~= nil then
        InitEnvelope()
    end

    -- 添加VFX效果组件并初始化发射器
    local effect = inst.entity:AddVFXEffect()
    effect:InitEmitters(GetTableSize(tile_fx_datas)) -- 根据数据表大小初始化发射器数量

    -- 遍历地砖特效数据，为每个发射器设置参数
    for name, data in pairs(tile_fx_datas) do
        local i = data.id
        -- 设置渲染资源(纹理和着色器)
        effect:SetRenderResources(i, resolvefilepath(data.texture), resolvefilepath(data.shader))
        effect:SetMaxNumParticles(i, 10000)               -- 设置最大粒子数
        effect:SetMaxLifetime(i, MAX_LIFETIME)            -- 设置最大生命周期
        effect:SetColourEnvelope(i, COLOUR_ENVELOPE_NAME) -- 应用颜色动画包络线
        effect:SetScaleEnvelope(i, SCALE_ENVELOPE_NAME)   -- 应用缩放动画包络线
        effect:SetUVFrameSize(i, 0.0625, 0.0625)          -- 设置UV帧大小 -----也就是控制在texture截取多大懂的部分作为显示窗口-------------需要修改
        effect:SetLayer(i, LAYER_BACKGROUND)              -- 设置渲染层
        effect:SetSortOrder(i, -3)                        -- 设置排序顺序
        effect:SetBlendMode(0, BLENDMODE.AlphaBlended)    ----用于处理边缘接缝处的混合效果----------------------------需要修改
        effect:SetKillOnEntityDeath(i, true)              -- 实体死亡时销毁粒子
        effect:SetSpawnVectors(i,                         -- 设置生成向量
            1, 0, 0,
            0, 0, 1
        )
    end

    -- 绑定函数到实例
    inst.SpawnTile = SpawnTile
    inst.ClearTile = ClearTile
    inst.TestSpawn = TestSpawn

    return inst
end

return Prefab("tile_fx", fn, assets)
