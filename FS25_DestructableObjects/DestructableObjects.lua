--[[
SHORT DESCRIPTION OF WHAT YOUR MOD DOES GOES HERE

Author:     w33zl
Version:    1.0.0
Modified:   2024-12-07

Changelog:

]]

--*** Check https://github.com/w33zl/FS25_WeezlsModLib for details about the "Mod" class ***

DestructiblePlaceableObjects = Mod:init()

DestructiblePlaceableObjects:source("scripts/modLib/I3DHelper.lua")
DestructiblePlaceableObjects:source("scripts/modLib/PlaceableExtension.lua")

--TODO: is it possible to use the uniqueId from the placeable to ensure groupId always matches the correct placeable? Maybe this can prevent the "Group with id 'XX' does not exist in map" issue?
--NOTE: or maybe we can create a derived class that isolates the placeable destuctable objects from the default destructable objects from the map? We can inherit the class and override the loading and saving methods, and hook into the jackhammer (easiest via DestructibleMapObjectSystem.getDestructibleFromNode?)

-- function DestructiblePlaceableObjects:beforeLoadMap()
--     local xmlFile = g_currentMission ~= nil and g_currentMission.missionInfo ~= nil and g_currentMission.missionInfo.destructibleMapObjectsXMLLoad
--     Log:var("g_currentMission.missionInfo.destructibleMapObjectsXMLLoad [beforeLoadMap]", xmlFile)

--     self.destructibleMapObjectsXMLLoad = xmlFile
--     g_currentMission.missionInfo.destructibleMapObjectsXMLLoad = nil
-- end
function DestructiblePlaceableObjects:loadMap(filename)
    local xmlFile = g_currentMission ~= nil and g_currentMission.missionInfo ~= nil and g_currentMission.missionInfo.destructibleMapObjectsXMLLoad
    Log:var("g_currentMission.missionInfo.destructibleMapObjectsXMLLoad [loadMap]", xmlFile)

    Log:trace("loadMap")
end

BaseMission.loadMapFinished = Utils.appendedFunction(BaseMission.loadMapFinished, function(baseMission, ...) 
    local xmlFile = g_currentMission ~= nil and g_currentMission.missionInfo ~= nil and g_currentMission.missionInfo.destructibleMapObjectsXMLLoad
    -- Log:var("g_currentMission.missionInfo.destructibleMapObjectsXMLLoad [loadMap]", xmlFile)
    Log:trace("loadMapFinished")
end)

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

PlaceableSystem.loadFromXMLFile = Utils.appendedFunction(PlaceableSystem.loadFromXMLFile, function(self, xmlFile, key)
	Log:trace("PlaceableSystem.loadFromXMLFile")
end)

PlaceableSystem.loadMapData = Utils.appendedFunction(PlaceableSystem.loadMapData, function()
	Log:trace("PlaceableSystem.loadMapData")
end)

Mission00.onFinishedPlaceables = Utils.appendedFunction(Mission00.onFinishedPlaceables, function(self)
	Log:trace("Mission00.onFinishedPlaceables")

    DestructibleMapObjectSystem.loadFromSavegameXML(g_currentMission.destructibleMapObjectSystem, self.destructibleMapObjectsXMLLoad)
end)

DestructibleMapObjectSystem.loadFromSavegameXML = Utils.overwrittenFunction(DestructibleMapObjectSystem.loadFromSavegameXML, function(self, superFunc, xmlPath)
    Log:var("destructibleMapObjectSystem.loadFromSavegameXML [loadFromSavegameXML]", xmlPath)
    Log:trace("loadFromSavegameXML")
    return superFunc(self, xmlPath)
end)

-- Event that is executed when the player chooses to start the mission (after the map has been loaded and before the game starts)
function DestructiblePlaceableObjects:startMission()
    local xmlFile = g_currentMission ~= nil and g_currentMission.missionInfo ~= nil and g_currentMission.missionInfo.destructibleMapObjectsXMLLoad
    Log:var("g_currentMission.missionInfo.destructibleMapObjectsXMLLoad [startMission]", xmlFile)

    --HACK: this is a bit of a hack, maybe we can find a better way to do this?
    -- DestructibleMapObjectSystem.loadFromSavegameXML(g_currentMission.destructibleMapObjectSystem, self.destructibleMapObjectsXMLLoad)
end

g_globalMods = g_globalMods or {}
g_globalMods.g_destructibleObjects = g_globalMods.g_destructibleObjects or {}
g_globalMods.g_destructibleObjects.PlaceableDestructibleObject = g_globalMods.g_destructibleObjects.PlaceableDestructibleObject or PlaceableDestructibleObject