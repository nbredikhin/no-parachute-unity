require "utils"
require "math"
local ScreenManager 	= require "screens/ScreenManager"

application:configureFrustum(45, 10000)

screenManager = ScreenManager.new()
local startupScreen = screenManager.screens.GameScreen
screenManager:loadScreen(startupScreen.new())
stage:addChild(screenManager)

local function updateGame(e)
	screenManager:update(e.deltaTime)
end

stage:addEventListener(Event.ENTER_FRAME, updateGame)