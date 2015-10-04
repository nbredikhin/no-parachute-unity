DEBUG_SHOW_FPS 			= false
DEBUG_UNLOCK_ALL_LEVELS = true
DEBUG_RESET_SAVES 		= false 
DEBUG_SPAWN_PLANE 		= nil 		-- Спавн стен с определенным ID
DEBUG_START_LEVEL		= nil 		-- Пропуск меню и запуск определенного уровня
DEBUG_START_TIME 		= nil

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
if not DEBUG_START_LEVEL then
	screenManager:loadScreen(startupScreen)
else
	screenManager:loadScreen("GameScreen", DEBUG_START_LEVEL)
end
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