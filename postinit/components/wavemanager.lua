local TROENV = env
GLOBAL.setfenv(1, GLOBAL)


local tro_shimmer = {
	[WORLD_TILES.LILYPOND] = { per_sec = 80, spawn_rate = 0, tryspawn = TrySpawnWavesOrShore },
	-- [WORLD_TILES.OCEAN_SHALLOW] = {per_sec = 75, spawn_rate = 0, tryspawn = TrySpawnIAWavesOrShore},
	-- [WORLD_TILES.OCEAN_CORAL] = {per_sec = 80, spawn_rate = 0, tryspawn = TrySpawnIAWavesOrShore},
	-- [WORLD_TILES.OCEAN_MEDIUM] = {per_sec = 75, spawn_rate = 0, tryspawn = TrySpawnIAWaveShimmerMedium},
	-- [WORLD_TILES.OCEAN_DEEP] = {per_sec = 70, spawn_rate = 0, tryspawn = TrySpawnIAWaveShimmerDeep},
	-- [WORLD_TILES.OCEAN_SHIPGRAVEYARD] = {per_sec = 80, spawn_rate = 0, tryspawn = TrySpawnIAWaveShimmerDeep},
	-- [WORLD_TILES.MANGROVE] = {per_sec = 80, spawn_rate = 0, tryspawn = TrySpawnIAWavesOrShore},
	-- FLOOD = {per_sec = 80, spawn_rate = 0, checkfn = CheckFlood, spawnfn = SpawnIAWaveFlood},
}

-- local function SetWaveSettings(self, shimmer)
-- 	self.shimmer_per_sec_mod = shimmer
-- end

TROENV.AddComponentPostInit("wavemanager", function(cmp)
	for i, v in pairs(tro_shimmer) do
		cmp.shimmer[i] = v
	end

	-- cmp.SetWaveSettings = SetWaveSettings
end)
