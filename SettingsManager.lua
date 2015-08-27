require "json"

local SettingsManager = {}
SettingsManager.settingsFilePath = "|D|settings.json"
SettingsManager.defaultSettings = {
	sound_volume = 1,
	graphics_quality = 1,
	input_sensitivity = 1
}

function SettingsManager:reset()
	local settingsFile = io.open(self.settingsFilePath, "w+")
	settingsFile:write(json.encode(self.defaultSettings))
	settingsFile:close()

	self.settings = self.defaultSettings
end

function SettingsManager:load()
	print("SettingsManager: loading settings...")
	local settingsFile = io.open(self.settingsFilePath, "r")
	if not settingsFile then
		print("SettingsManager: no settings file found. Reset")
		self:reset()
		return
	end
	local settingsJSON = settingsFile:read()
	settingsFile:close()
	self.settings = json.decode(settingsJSON)
	if not self.settings then
		self.settings = {}
	end
	print("SettingsManager: settings loaded. Checking...")
	for k, v in pairs(self.defaultSettings) do
		if not self.settings[k] then
			self.settings[k] = v
			print("SettingsManager: missing '" .. tostring(k) .. "'. Loaded default value: '" .. tostring(v) .. "'")
		end
	end
	print("SettingsManager: done loading settings")
end

function SettingsManager:save()
	print("SettingsManager: saving settings...")
	local settingsFile = io.open(self.settingsFilePath, "w+")
	settingsFile:write(json.encode(self.settings))
	settingsFile:close()
	print("SettingsManager: done saving settings")
end

return SettingsManager