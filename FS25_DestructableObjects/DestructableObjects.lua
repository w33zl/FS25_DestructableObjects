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
Mission00.loadAdditionalFilesFinished = Utils.overwrittenFunction(Mission00.loadAdditionalFilesFinished, function(self, superFunc, ...)
    local xmlFile = g_currentMission ~= nil and g_currentMission.missionInfo ~= nil and g_currentMission.missionInfo.destructibleMapObjectsXMLLoad
    Log:var("g_currentMission.missionInfo.destructibleMapObjectsXMLLoad [loadAdditionalFilesFinished]", xmlFile)
    Log:trace("loadAdditionalFilesFinished")

    self.destructibleMapObjectsXMLLoad = xmlFile
    g_currentMission.missionInfo.destructibleMapObjectsXMLLoad = nil

    local retVal = superFunc(self, ...)

    -- g_currentMission.missionInfo.destructibleMapObjectsXMLLoad = self.destructibleMapObjectsXMLLoad
    

    return retVal
end)
Mission00.onFinishedPlaceables = Utils.appendedFunction(Mission00.onFinishedPlaceables, function(self)
	Log:trace("Mission00.onFinishedPlaceables")

    DestructibleMapObjectSystem.loadFromSavegameXML(g_currentMission.destructibleMapObjectSystem, self.destructibleMapObjectsXMLLoad)
end)

-- Event that is executed when the player chooses to start the mission (after the map has been loaded and before the game starts)
function DestructiblePlaceableObjects:startMission()
    --HACK: this is a bit of a hack, maybe we can find a better way to do this?
    -- DestructibleMapObjectSystem.loadFromSavegameXML(g_currentMission.destructibleMapObjectSystem, self.destructibleMapObjectsXMLLoad)
end

g_globalMods = g_globalMods or {}
g_globalMods.g_destructibleObjects = g_globalMods.g_destructibleObjects or {}
g_globalMods.g_destructibleObjects.PlaceableDestructibleObject = g_globalMods.g_destructibleObjects.PlaceableDestructibleObject or PlaceableDestructibleObject