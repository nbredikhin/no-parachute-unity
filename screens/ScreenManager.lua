local FramerateCounter 	= require "FramerateCounter"
local GameScreen 		= require "screens/GameScreen"
local MainMenuScreen 	= require "screens/MainMenuScreen"

local ScreenManager = Core.class(Sprite)

function ScreenManager:init()
	self.currentScreen = false

	-- Счётчик фпс
	self.framerateCounter = FramerateCounter.new(0.4)
	self:addChild(self.framerateCounter)

	self.screens = {
		GameScreen = GameScreen,
		MainMenuScreen = MainMenuScreen
	}
end

function ScreenManager:loadScreen(screen)
	-- Скрыть текущий экран
	if self.currentScreen and self.currentScreen:getParent() then
		self:removeChild(self.currentScreen)
		self.currentScreen:unload()
		self.currentScreen = false
	end
	application:setBackgroundColor(0xFFFFFF)

	-- Если нового экрана нет, ничего не делать
	if not screen then
		return false
	end
	-- Если новый экран уже отображается, скрыть его
	local parent = screen:getParent() 
	if parent then
		parent:removeChild(screen)
	end
	-- Отобразить новый экран
	self.currentScreen = screen
	self.currentScreen:load()
	self:addChild(self.currentScreen)

	self:removeChild(self.framerateCounter)
	self:addChild(self.framerateCounter)
	return true
end

function ScreenManager:update(deltaTime)
	if self.currentScreen then
		self.currentScreen:update(deltaTime)
	end
	self.framerateCounter:update(deltaTime)
end

function ScreenManager:getCurrentScreen()
	return self.currentScreen
end

return ScreenManager