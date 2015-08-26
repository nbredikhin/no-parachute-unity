require "utils"
require "math"
Assets = require "Assets"
local ScreenManager = require "screens/ScreenManager"

application:configureFrustum(45, 60000)

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
