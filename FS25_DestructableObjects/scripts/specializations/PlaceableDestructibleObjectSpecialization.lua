--[[
Linked Placeable Specialization (Weezls Mod Lib for FS22) - Enables the possibility to have multiple placeables to be placed at once

Author:     w33zl (github.com/w33zl)

COPYRIGHT:
You may redistribute the script, in original or modified state. All I request in return is that you leave this header intact and let me (the author, w33zl) know that you have used the script. Contact me on Facebook let me know in which mod you used the script.

I will also kindly ask you to, if possible, share your creations freely to the community, together we will create better mods and we all benefit of an open and sharing community!
]]

assert(Log, "The dependency 'Log' from WeezlsModLibrary was not found! Please add '<sourceFile filename=\"scripts/modLib/LogHelper.lua\" />' to your <extraSourceFiles> section in modDesc.xml")

local function makeSpec(specClass, specName)
	Log:var("specClass.SPEC_NAME", specClass.SPEC_NAME)
	specClass.MOD_DIRECTORY = g_currentModDirectory
	specClass.MOD_NAME = g_currentModName
	specClass.SPEC_NAME = specClass.SPEC_NAME or ("spec_%s.%s"):format(g_currentModName, specName)
	specClass.getSpec = specClass.getSpec or function(self)
		return self[specClass.SPEC_NAME]
	end
end


PlaceableDestructibleObject = {
	prerequisitesPresent = function (specializations)
		return true
	end,
	-- MOD_DIRECTORY = g_currentModDirectory,
	-- MOD_NAME = g_currentModName,
    -- SPEC_NAME2 = ("spec_%s.placeableDestructibleObject"):format(g_currentModName)
}

makeSpec(PlaceableDestructibleObject, "placeableDestructibleObject")



function PlaceableDestructibleObject.registerEventListeners(placeableType)
	SpecializationUtil.registerEventListener(placeableType, "onLoad", PlaceableDestructibleObject)
	SpecializationUtil.registerEventListener(placeableType, "onLoadFinished", PlaceableDestructibleObject)
	
	SpecializationUtil.registerEventListener(placeableType, "onDelete", PlaceableDestructibleObject)
	SpecializationUtil.registerEventListener(placeableType, "onPostFinalizePlacement", PlaceableDestructibleObject)
	-- SpecializationUtil.registerEventListener(placeableType, "onOwnerChanged", PlaceableDestructibleObject)
	
	-- SpecializationUtil.registerEventListener(p3, "onFinalizePlacement", PlaceableDestructibleObject)

end

function PlaceableDestructibleObject.registerXMLPaths(schema, typePath)
	Log:debug("PlaceableDestructibleObject.registerXMLPaths")
	PlaceableDestructibleObject.TYPE_PATH = typePath
	PlaceableDestructibleObject.BASE_PATH = typePath .. ".destructibleObjects"
    Log:debug("PlaceableDestructibleObject.registerXMLPaths")
    local baseKey = PlaceableDestructibleObject.BASE_PATH
	schema:setXMLSpecializationType("PlaceableDestructibleObjects")
	schema:register(XMLValueType.NODE_INDICES, baseKey .. "#node", "Destructible Base Node", nil, true)
	schema:setXMLSpecializationType()
end

-- Local values: schema, basePath
function PlaceableDestructibleObject.registerSavegameXMLPaths(schema, basePath)
	Log:debug("PlaceableDestructibleObject.registerSavegameXMLPaths")
	Log:var("basePath", basePath)
	schema:register(XMLValueType.FLOAT, basePath .. "#groupId", "GroupID")
end

function PlaceableDestructibleObject:onPostFinalizePlacement()
	Log:debug("PlaceableDestructibleObject:onPostFinalizePlacement")
	-- Log:table("PlaceableDestructibleObject:onPostFinalizePlacement:self", self, 2)
	-- self:registerPlaceableAsDestructibleObejects()registerPlaceableAsDestructibleObejects
end

function PlaceableDestructibleObject:registerPlaceableAsDestructibleObejects()
	local spec = PlaceableDestructibleObject.getSpec(self)
	local nodeId = spec.nodeId
	-- Log:table("spec", spec, 2)
	-- if self.isServer then
	-- end

	if nodeId == nil then
		Log:error("PlaceableDestructibleObject:onPostFinalizePlacement: nodeId is nil")
		return
	end

    local groupIdToGroupRoot = g_currentMission.destructibleMapObjectSystem.groupIdToGroupRoot

    -- Log:var("groupId", groupId)

    local function findFirstFreeGroupId()
        local newGroupId = 0
        
        for i = 1, (#groupIdToGroupRoot + 1), 1 do
            if groupIdToGroupRoot[i] == nil then
                newGroupId = i
                Log:debug("Found first free slot: %d", i)
                break
            end
            -- Log:debug("Skip %d", i)
        end

        return newGroupId
    end	

	local groupId = spec.groupId or findFirstFreeGroupId() -- Use value from savegame or generate new id
	-- Log:var("GENERATED groupId", groupId)

	setUserAttribute(nodeId, "groupId", UserAttributeType.INTEGER, groupId)
	local success = g_currentMission.destructibleMapObjectSystem:addGroup(nodeId)

	if success then
		spec.groupId = groupId
		Log:var("spec.groupId", spec.groupId)
	else
		Log:error("PlaceableDestructibleObject:onPostFinalizePlacement: Failed to add to group #%d for nodeId %d", groupId, nodeId)
	end
end

function PlaceableDestructibleObject:loadFromXMLFile(xmlFile, key)
	Log:debug("PlaceableDestructibleObject:loadFromXMLFile")
	-- Log:var("key" , key)
	local spec = PlaceableDestructibleObject.getSpec(self)
	local groupId = xmlFile:getValue(key .. "#groupId", nil)
	spec.groupId = groupId
	Log:var("LOADED groupId", groupId)
end

function PlaceableDestructibleObject:saveToXMLFile(xmlFile, key, usedModNames)
	Log:debug("PlaceableDestructibleObject:saveToXMLFile")
	local spec = PlaceableDestructibleObject.getSpec(self)
	xmlFile:setValue(key .. "#groupId", spec.groupId)
end


function PlaceableDestructibleObject:onLoadFinished()
	Log:debug("PlaceableDestructibleObject:onLoadFinished")
	Log:var("isLoadedFromSavegame", self.isLoadedFromSavegame)
	local spec = PlaceableDestructibleObject.getSpec(self)
	local groupId = spec.groupId
	local nodeId = spec.nodeId
	local isConstructionPreview = self.propertyState == PlaceablePropertyState.CONSTRUCTION_PREVIEW
	Log:var("groupId", groupId)
	Log:var("nodeId", nodeId)
	Log:var("isConstructionPreview", isConstructionPreview)

	if self.isLoadingFromSavegame or not isConstructionPreview then
		PlaceableDestructibleObject.registerPlaceableAsDestructibleObejects(self)
	end

end

function PlaceableDestructibleObject:onLoad(savegame)
    
    Log:debug("PlaceableDestructibleObject:onLoad")
	-- Log:table("PlaceableDestructibleObject:onLoad", savegame, 1)
	local spec = PlaceableDestructibleObject.getSpec(self)
	-- local name = "spec_FS25_MapExtensions.placeableDestructibleObject"
	-- local spec2 = self[name]
	-- local spec3 = self["spec_FS25_MapExtensions.PlaceableDestructibleObject"]

	-- Log:var("isLoadedFromSavegame", self.isLoadedFromSavegame)
	
	local xmlFile = self.xmlFile
	local isLoadingFromSavegame = savegame ~= nil
	local isConstructionPreview = self.propertyState == PlaceablePropertyState.CONSTRUCTION_PREVIEW
	-- Log:var("isLoadingFromSavegame", isLoadingFromSavegame)
	-- Log:var("isConstructionPreview", isConstructionPreview)
	local basePath = PlaceableDestructibleObject.BASE_PATH
	-- local nodeId = xmlFile:getValue(basePath .. ".destructibleObjects#node", nil)
	local nodeId = xmlFile:getValue(basePath .. "#node", nil, self.components, self.i3dMappings)
	local groupId = spec.groupId

	-- Log:var("nodeId", nodeId)
	-- Log:var("groupId", groupId)

	spec.nodeId = nodeId

	
end

function PlaceableDestructibleObject:onDelete()
	Log:debug("PlaceableDestructibleObject:onDelete")
	local spec = PlaceableDestructibleObject.getSpec(self)
	Log:var("spec.groupId", spec.groupId)
	if spec.groupId ~= nil then
		Log:table("g_currentMission.destructibleMapObjectSystem BEFORE", g_currentMission.destructibleMapObjectSystem, 1)
		PlaceableDestructibleObject.removeGroup(spec.nodeId)
		Log:table("g_currentMission.destructibleMapObjectSystem AFTER", g_currentMission.destructibleMapObjectSystem, 1)
	end
end

function PlaceableDestructibleObject.removeGroup(nodeId)
	local destructibleMapObjectSystem = g_currentMission.destructibleMapObjectSystem
	local group = destructibleMapObjectSystem.groups[nodeId]
	local destructibleType = group.destructibleType
	local groupId = group.groupId
	local maxChildren = getNumOfChildren(nodeId)
	
	for childIndex = 0, maxChildren - 1 do
		local destructibleNodeId = getChildAt(nodeId, childIndex) --TG
		local foundRigidBodies = false
		local function scanForRigidChildren(childNodeId)
			if getRigidBodyType(childNodeId) ~= RigidBodyType.NONE then
				destructibleMapObjectSystem.nodeToDestructible[childNodeId] = nil -- rigid
			end
			return true
		end
		I3DUtil.iterateRecursively(destructibleNodeId, scanForRigidChildren, true)
		destructibleMapObjectSystem.destructibleToRigidBodies[destructibleNodeId] = nil
		destructibleMapObjectSystem.destructibleToGroup[destructibleNodeId] = nil
	end

	destructibleMapObjectSystem.groupIdToGroupRoot[groupId] = nil
	destructibleMapObjectSystem.groups[nodeId] = nil
	destructibleMapObjectSystem.destructibleTypes[destructibleType][group] = nil

	return true
end



