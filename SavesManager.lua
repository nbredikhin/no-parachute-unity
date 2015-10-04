require "json"
local arcfour = require "lib/sha1"

local THIS_KEY_IS_SECRET_SO_YOU_SHOULD_NOT_SEE_IT = "OH NO, YOU'VE JUST HACKED MY GAME, BASTARD!!!"
local SOME_RANDOM_SECRET_NUMBER = 1337

local PRINT_MESSAGES = false

local print_old = print
local function print(...)
	if PRINT_MESSAGES then
		print_old(...)
	end
end

local SavesManager = {}
SavesManager.savesFilePath = "|D|game.dat"
SavesManager.defaultSaves = {
	current_level = 1
}

function SavesManager:reset()
	local settingsFile = io.open(self.savesFilePath, "w+")
	settingsFile:write(self:encode(self.defaultSaves))
	settingsFile:close()

	self.saves = self.defaultSaves
end

function SavesManager:load()
	if not DEBUG_RESET_SAVES then
		print("SavesManager: loading saves...")
		local settingsFile = io.open(self.savesFilePath, "r")
		if not settingsFile then
			print("SavesManager: no saves file found. Reset")
			self:reset()
			return
		end
		local settingsJSON = settingsFile:read()
		settingsFile:close()
		self.saves = self:decode(settingsJSON)
		if not self.saves then
			self.saves = {}
		end
		print("SavesManager: saves loaded. Checking...")
		for k, v in pairs(self.defaultSaves) do
			if not self.saves[k] then
				self.saves[k] = v
				print("SavesManager: missing '" .. tostring(k) .. "'. Loaded default value: '" .. tostring(v) .. "'")
			end
		end
	else
		print_old("DEBUG_RESET_SAVES")
		self:reset()
	end
	print("SavesManager: done loading saves")
end

function SavesManager:save()
	print("SavesManager: saving saves...")
	local settingsFile = io.open(self.savesFilePath, "w+")
	settingsFile:write(self:encode(self.saves))
	settingsFile:close()
	print("SavesManager: done saving saves")
end

function SavesManager:encode(obj)
	local jsonString = json.encode(obj)

	local enc_state = arcfour.new(THIS_KEY_IS_SECRET_SO_YOU_SHOULD_NOT_SEE_IT)
	enc_state:generate(SOME_RANDOM_SECRET_NUMBER)
	return enc_state:cipher(jsonString)
end

function SavesManager:decode(str)
	local dec_state = arcfour.new(THIS_KEY_IS_SECRET_SO_YOU_SHOULD_NOT_SEE_IT)
	dec_state:generate(SOME_RANDOM_SECRET_NUMBER)
	local plaintext = dec_state:cipher(str)

	local obj = {}
	local result, err = pcall(function() obj = json.decode(plaintext) end)
	if not result then
		print("Failed to parse JSON. " .. err)
		obj = self.defaultSaves
	end
	return obj
end

return SavesManager