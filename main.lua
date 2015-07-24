local ScreenManager = require "ScreenManager"
local GameScreen 	= require "GameScreen"

screenManager = ScreenManager.new()
screenManager:loadScreen(GameScreen.new())
stage:addChild(screenManager)

local function updateGame(e)
	screenManager:update(e.deltaTime)
end

stage:addEventListener(Event.ENTER_FRAME, updateGame)