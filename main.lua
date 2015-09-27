-- Globals
require "utils"
require "math"
Assets 				= require "Assets"
SettingsManager 	= require "SettingsManager"
SavesManager		= require "SavesManager"
-- Locals
local ScreenManager = require "screens/ScreenManager"

SettingsManager:load()
SavesManager:load()
application:configureFrustum(45, 60000, 0)

screenManager = ScreenManager.new()
local startupScreen = "MainMenuScreen"
--local startupScreen = "SettingsMenuScreen"
--local startupScreen = "LevelSelectScreen"
--local startupScreen = "GameScreen"
screenManager:loadScreen(startupScreen)
stage:addChild(screenManager)

local function updateGame(e)
	screenManager:update(e.deltaTime)
end

stage:addEventListener(Event.ENTER_FRAME, updateGame)

local function gameExit()
	SettingsManager:save()
	SavesManager:save()
end

stage:addEventListener(Event.APPLICATION_EXIT, gameExit)