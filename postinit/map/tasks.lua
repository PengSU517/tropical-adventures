AddTaskPreInit("GreenForest", function(task)
    task.keys_given = { KEYS.CAVE, KEYS.TIER3, KEYS.GREEN, KEYS.ENTRANCE_INNER, KEYS.HAM_CAVE }
end)

AddTaskPreInit("RedForest", function(task)
    task.keys_given = { KEYS.CAVE, KEYS.TIER3, KEYS.RED, KEYS.ENTRANCE_INNER, KEYS.VOLCANO_ENTRANCE }
end)


AddTaskPreInit("CaveExitTask5", function(task)
    task.locks = { LOCKS.ENTRANCE_INNER }
end)

AddTaskPreInit("CaveExitTask6", function(task)
    task.locks = { LOCKS.ENTRANCE_INNER }
end)

AddTaskPreInit("CaveExitTask7", function(task)
    task.locks = { LOCKS.ENTRANCE_INNER }
end)

AddTaskPreInit("CaveExitTask8", function(task)
    task.locks = { LOCKS.ENTRANCE_INNER }
end)

AddTaskPreInit("CaveExitTask9", function(task)
    task.locks = { LOCKS.ENTRANCE_INNER }
end)

AddTaskPreInit("CaveExitTask10", function(task)
    task.locks = { LOCKS.ENTRANCE_INNER }
end)
