local MapTags = { "frost", "tropical", "hamlet", "shipwrecked", "underwater" }

AddGlobalClassPostConstruct("map/storygen", "Story", function(self)
    for k, v in pairs(MapTags) do
        self.map_tags.Tag[v] = function(tagdata) return "TAG", v end
    end
end)

require("map/storygen")

local troadv = TA_CONFIG
-------------以下代码可以直接改变主大陆但是 background room都不会生成
if (troadv.together_not_mainland) and (not troadv.testmode) then
    local land = troadv.startlocation

    function Story:AddRegionsToMainland(on_region_added_fn)
        -- print("!!!!!!!!!!!!!")
        -- print(self.id)
        -- print(self.level.location)

        land = (self.level.location == "forest") and land or "mainland"
        for region_id, region_taskset in pairs(self.region_tasksets) do
            if region_id ~= land then
                local c1, c2 = self:FindMainlandNodesForNewRegion()
                local new_region = self:GenerateNodesForRegion(region_taskset, "RestrictNodesByKey")

                local new_task_nodes = {}
                for k, v in pairs(region_taskset) do
                    new_task_nodes[k] = self.TERRAIN[k]
                end
                self:AddCoveNodes(new_task_nodes)
                self:InsertAdditionalSetPieces(new_task_nodes)

                self:LinkRegions(c1, new_region.entranceNode)
                self:LinkRegions(c2, new_region.finalNode)

                if on_region_added_fn ~= nil then
                    on_region_added_fn()
                end
            end
        end
    end

    function Story:GenerateNodesFromTasks()
        land = (self.level.location == "forest") and land or "mainland"
        local g = self:GenerateNodesForRegion(self.region_tasksets[land], self.gen_params.layout_mode)
        self.startNode = self:_AddPlayerStartNode(g) -- Adds where the player portal will be spawned and used in placement.lua to force the starting point to be at the center of the map
    end
end
