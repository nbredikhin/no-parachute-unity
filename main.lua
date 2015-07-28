require "utils"
require "math"
local ScreenManager = require "screens/ScreenManager"

application:configureFrustum(45, 60000)

screenManager = ScreenManager.new()
local startupScreen = screenManager.screens.GameScreen
--local startupScreen = screenManager.screens.MainMenuScreen
screenManager:loadScreen(startupScreen.new())
stage:addChild(screenManager)

local function updateGame(e)
	screenManager:update(e.deltaTime)
end

stage:addEventListener(Event.ENTER_FRAME, updateGame)