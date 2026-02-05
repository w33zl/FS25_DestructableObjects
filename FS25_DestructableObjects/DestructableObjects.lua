--[[
Extends the destuctable object system to support placeable destructable objects

Author:     w33zl
Version:    1.0.1
Modified:   2026-02-05

Changelog:

]]

--*** Check https://github.com/w33zl/FS25_WeezlsModLib for details about the "Mod" class ***

DestructiblePlaceableObjects = Mod:init()

DestructiblePlaceableObjects:source("scripts/modLib/I3DHelper.lua")
DestructiblePlaceableObjects:source("scripts/modLib/PlaceableExtension.lua")

--TODO: is it possible to use the uniqueId from the placeable to ensure groupId always matches the correct placeable? Maybe this can prevent the "Group with id 'XX' does not exist in map" issue?
--NOTE: or maybe we can create a derived class that isolates the placeable destuctable objects from the default destructable objects from the map? We can inherit the class and override the loading and saving methods, and hook into the jackhammer (easiest via DestructibleMapObjectSystem.getDestructibleFromNode?)

Mission00.loadAdditionalFilesFinished = Utils.overwrittenFunction(Mission00.loadAdditionalFilesFinished, function(self, superFunc, ...)
    --HACK: a bit of hack, but we need to defer loading of destructible objects until the placeables have been loaded, otherwise the "Group with id 'XX' does not exist in map" error will occur

    local destructibleMapObjectsXMLFileToLoad = g_currentMission ~= nil and g_currentMission.missionInfo ~= nil and g_currentMission.missionInfo.destructibleMapObjectsXMLLoad
    self.destructibleMapObjectsXMLLoad = destructibleMapObjectsXMLFileToLoad -- Save the XML path for later
    g_currentMission.missionInfo.destructibleMapObjectsXMLLoad = nil -- Setting this to nil will prevent the destructible objects from loading at this point

    return superFunc(self, ...)
end)

Mission00.onFinishedPlaceables = Utils.appendedFunction(Mission00.onFinishedPlaceables, function(self)
    -- Now we can load the destuctable objects
    DestructibleMapObjectSystem.loadFromSavegameXML(g_currentMission.destructibleMapObjectSystem, self.destructibleMapObjectsXMLLoad)
end)

g_globalMods = g_globalMods or {}
g_globalMods.g_destructibleObjects = g_globalMods.g_destructibleObjects or {}
g_globalMods.g_destructibleObjects.PlaceableDestructibleObject = g_globalMods.g_destructibleObjects.PlaceableDestructibleObject or PlaceableDestructibleObject