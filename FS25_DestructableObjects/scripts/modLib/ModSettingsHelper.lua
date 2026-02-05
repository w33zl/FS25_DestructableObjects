ModSettings = {}

local ModSettings_mt = Class(ModSettings)

local l_currentModSettingsDirectory = g_currentModSettingsDirectory

function ModSettings.new(customMt, cursor)
	local newModSettings = setmetatable({}, customMt or ModSettings_mt)
	newModSettings.XXX = nil
	return newModSettings
end


---comment
---@param mod table Mod instance
---@param defaultFilename string "File path to the default settings file to be copied to the mod settings folder [optional]" 
function ModSettings:init(mod, defaultFilename)
    self.mod = mod
    self.modName = mod.name
    self.modSettings = mod.settings

    -- Remove all occurrences of "FS25" and "LS25" in the mod name
    self.modName = string.gsub(self.modName, "FS25_", "")
    self.modName = string.gsub(self.modName, "LS25_", "")
    self.modName = string.gsub(self.modName, "FS25", "")
    self.modName = string.gsub(self.modName, "LS25", "")
    
    -- Remove all characters that are not alphanumeric or underscores
    self.modName = string.gsub(self.modName, "[^%w_]", "")

    -- Make first letter of mod name lowercase
    self.modName = string.sub(self.modName, 1, 1):lower() .. string.sub(self.modName, 2)

    -- Make the rootKey same as the mod name
    self.rootKey = self.modName

    -- Create the mod settings paths
    local settingsFolderPath = (Mod.settingsDir or l_currentModSettingsDirectory or getUserProfileAppPath() .. "modSettings/" .. self.modName .. "/")
    local settingsFilePath = settingsFolderPath .. self.modName .. ".xml"

    self.filename = settingsFilePath
    
    -- Ensure mod settings folder exist
    createFolder(settingsFolderPath)

    -- Check if the settings file exists, and if it doesn't exist, copy the default settings file to the mod settings folder (if provided)
    if defaultFilename and not fileExists(settingsFilePath) then
        local defaultFilePath = Utils.getFilename(defaultFilename, self.modName)
        copyFile(defaultFilePath, settingsFilePath, true)
    end

    -- Load XML file
    if fileExists(settingsFilePath) then
        self.xmlFile = loadXMLFile(self.modName, settingsFilePath)
        
        if self.xmlFile ~= nil and self.xmlFile ~= 0 then
            Log:debug("ModSettings: Loaded settings file for mod '%s' from '%s'", self.modName, settingsFilePath)
        else
            Log:warning("ModSettings: Failed to load settings file for mod '%s' from '%s'", self.modName, settingsFilePath)
        end
    else
        Log:debug("ModSettings: No settings file found for mod '%s', and no default file supplied. Settings will be empty.", self.modName)
    end

    FSBaseMission.load = Utils.prependedFunction(FSBaseMission.load, function(baseMission, ...)
        if mod.loadSettings ~= nil and type(mod.loadSettings) == "function" then
            mod:loadSettings(self) -- Trigger event on mod object
        end
    end)

    FSBaseMission.saveSavegame = Utils.appendedFunction(FSBaseMission.saveSavegame, function (self, ...)
        if mod.saveSettings ~= nil and type(mod.saveSettings) == "function" then
            mod:saveSettings(self) -- Trigger event on mod object
            self:save() -- Save the settings XML file
        end
    end)
end

function ModSettings:delete()
    if self.xmlFile ~= nil then
        delete(self.xmlFile)
        self.xmlFile = nil
    end
end

function ModSettings:save()
    if self.xmlFile ~= nil then
        saveXMLFile(self.xmlFile)
    end
end

local function getKey(modSettings, name)
    local keyPattern = "%s.%s"
        -- If starts with #, use different key
    if string.sub(name, 1, 1) == "#" then
        keyPattern = "%s%s"
    end

    return string.format(keyPattern, modSettings.rootKey, name)
    
end

function ModSettings:getBool(name, defaultValue)
    local key = getKey(self, name)
    self.isEnabled = self.xmlFile:getXMLBool(key, true)
end

function ModSettings:getInt(name, defaultValue)
    local key = getKey(self, name)
    return self.xmlFile:getXMLInt(key, defaultValue)
end

function ModSettings:getFloat(name, defaultValue)
    local key = getKey(self, name)
    return self.xmlFile:getXMLFloat(key, defaultValue)
end

function ModSettings:getString(name, defaultValue)
    local key = getKey(self, name)
    return self.xmlFile:getXMLString(key, defaultValue)
end

function ModSettings:setBool(name, value)
    local key = getKey(self, name)
    return self.xmlFile:setXMLBool(key, value)
end

function ModSettings:setInt(name, value)
    local key = getKey(self, name)
    return self.xmlFile:setXMLInt(key, value)
end

function ModSettings:setFloat(name, value)
    local key = getKey(self, name)
    return self.xmlFile:setXMLFloat(key, value)
end

function ModSettings:setString(name, value)
    local key = getKey(self, name)
    return self.xmlFile:setXMLString(key, value)
end