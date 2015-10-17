platformName = application:getDeviceInfo()
if string.find(string.lower(platformName), "android") then
	ANDROID_GIFTIZ = true
end
DEBUG_GIFTIZ_TEST		= false
DEBUG_SHOW_FPS 			= false
DEBUG_UNLOCK_ALL_LEVELS = true
DEBUG_RESET_SAVES 		= false 
DEBUG_SPAWN_PLANE 		= nil 		-- Спавн стен с определенным ID
DEBUG_START_LEVEL		= nil 		-- Пропуск меню и запуск определенного уровня
DEBUG_START_TIME 		= nil

-- Globals
require "utils"
require "math"
if not DEBUG_GIFTIZ_TEST and ANDROID_GIFTIZ then
	require "giftiz"
else
	giftiz = {}
	Giftiz = giftiz
	Giftiz.DEFAULT = "default"
	function giftiz:getButtonState()
		return Giftiz.DEFAULT
	end
	
	function giftiz:buttonClicked()
	end	
	
	function giftiz:missionComplete()
	end	
	
	function giftiz:addEventListener()
	end	
	
	function giftiz:removeEventListener()
	end	
end
require "lib/GiftizButton"

Assets 				= require "Assets"
SettingsManager 	= require "SettingsManager"
SavesManager		= require "SavesManager"
-- Locals
local ScreenManager = require "screens/ScreenManager"

application:configureFrustum(45, 60000, 0)

-- Global managers
SettingsManager:load()
SavesManager:load()

-- Music
local backgroundSound = Sound.new("assets/music/menu_theme.mp3")
backgroundMusic = backgroundSound:play(0, true, true)
backgroundMusic:setPaused(not SettingsManager.settings.sound_enabled)

-- Screen Manager
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