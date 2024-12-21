--[[
SHORT DESCRIPTION OF WHAT YOUR MOD DOES GOES HERE

Author:     w33zl
Version:    1.0.0
Modified:   2024-12-07

Changelog:

]]

--***heck https://github.com/w33zl/FS25_WeezlsModLib for details about the "Mod" class ***

DestructiblePlaceableObjects = Mod:init()

DestructiblePlaceableObjects:source("scripts/modLib/I3DHelper.lua")
DestructiblePlaceableObjects:source("scripts/modLib/PlaceableExtension.lua")

-- -- Event that is executed when your mod is loading (after the map has been loaded and before the game starts)
-- function DestructiblePlaceableObjects:loadMap(filename)
-- end

-- -- Event that is continuously, USE WITH CAUTION! Any demanding code here (even just a simple "print()" command) will cause poor performance, stuttering and FPS drops
-- function DestructiblePlaceableObjects:update(dt)
-- end

-- Event that is executed when the player chooses to start the mission (after the map has been loaded and before the game starts)
function DestructiblePlaceableObjects:startMission()
    --HACK: this is a bit of a hack, maybe we can find a better way to do this?
    DestructibleMapObjectSystem.loadFromSavegameXML(g_currentMission.destructibleMapObjectSystem, g_currentMission.missionInfo.destructibleMapObjectsXMLLoad)
end

