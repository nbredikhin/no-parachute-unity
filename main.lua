require "utils"
require "math"
local ScreenManager 	= require "screens/ScreenManager"
local GameScreen 		= require "screens/GameScreen"
local MainMenuScreen 	= require "screens/MainMenuScreen"

local startupScreen = GameScreen

application:configureFrustum(45, 10000)

screenManager = ScreenManager.new()
screenManager:loadScreen(startupScreen.new())
stage:addChild(screenManager)

local function updateGame(e)
	screenManager:update(e.deltaTime)
end

stage:addEventListener(Event.ENTER_FRAME, updateGame)