local FramerateCounter 		= require "FramerateCounter"
local GameScreen 			= require "screens/GameScreen"
local LevelSelectScreen 	= require "screens/LevelSelectScreen"
local MainMenuScreen 		= require "screens/MainMenuScreen"
local SettingsMenuScreen 	= require "screens/SettingsMenuScreen"

local ScreenManager = Core.class(Sprite)

local FADE_TIME = 0.5

function ScreenManager:init()
	self.currentScreen = false
	
	-- Черный прямоугольник
	self.blackBackground = Shape.new()
	self.blackBackground:setFillStyle(Shape.SOLID, 0, 1)
	self.blackBackground:beginPath()
	self.blackBackground:moveTo(0, 0)
	self.blackBackground:lineTo(utils.screenWidth, 0)
	self.blackBackground:lineTo(utils.screenWidth, utils.screenHeight)
	self.blackBackground:lineTo(0, utils.screenHeight)
	self.blackBackground:lineTo(0, 0)
	self.blackBackground:endPath()
	self:addChild(self.blackBackground)
	self.blackBackground:setAlpha(0)

	-- Версия
	self.infoText = TextField.new(nil, "No Parachute! Beta 0.9.81")
	self.infoText:setTextColor(0xFFFFFF)
	self.infoText:setPosition(5, utils.screenHeight - 5)
	self:addChild(self.infoText)

	-- Счётчик фпс
	self.framerateCounter = FramerateCounter.new()
	self:addChild(self.framerateCounter)
	
	self.screens = {
		GameScreen 			= GameScreen,
		LevelSelectScreen 	= LevelSelectScreen,
		MainMenuScreen 		= MainMenuScreen,
		SettingsMenuScreen 	= SettingsMenuScreen
	}

	-- Возврат назад
	stage:addEventListener(Event.KEY_DOWN, self.onKey, self)
	stage:addEventListener(Event.TOUCHES_BEGIN, function(self, e) if e.touch.x < 10 and e.touch.y < 10 then self:onKey({keyCode=8}) end end, self)
end

function ScreenManager:onKey(e)
	-- Хардварная кнопка "назад" или backspace (для десктопа)
	if e.keyCode == KeyCode.BACK or e.keyCode == 8 then
		if self.currentScreen then
			self.currentScreen:back()
		end	
	end
end

function ScreenManager:changeScreen()
	local screen = self.nextScreen
	if not screen then
		return
	end
	-- Скрыть текущий экран
	if self.currentScreen and self.currentScreen:getParent() then
		self:removeChild(self.currentScreen)
		self.currentScreen:unload()
		self.currentScreen = false
	end
	application:setBackgroundColor(0xFFFFFF)

	-- Выгрузить ассеты из кэша
	Assets:clearCache()

	-- Если нового экрана нет, ничего не делать
	if not screen then
		return false
	end
	if type(screen) == "string" and self.screens[screen] then
		screen = self.screens[screen].new() 
	end
	-- Если новый экран уже отображается, скрыть его
	local parent = screen:getParent() 
	if parent then
		parent:removeChild(screen)
	end
	-- Отобразить новый экран
	self.currentScreen = screen
	self.blackBackground:setAlpha(1)
	self.currentScreen:load(unpack(self.nextScreenArgs))
	self:addChildAt(self.currentScreen, 1)

	self.nextScreen = nil
	self.nextScreenArgs = {}
	return true
end

function ScreenManager:loadScreen(screen, ...)
	if self.nextScreen then
		return
	end
	self.blackBackground:setAlpha(0)
	self.nextScreen = screen
	self.nextScreenArgs = {...}
end

function ScreenManager:update(deltaTime)
	if self.currentScreen then
		self.currentScreen:update(deltaTime)
		if self.nextScreen then
			self.blackBackground:setAlpha(self.blackBackground:getAlpha() + deltaTime / FADE_TIME)
			if self.blackBackground:getAlpha() >= 1 then
				self:changeScreen()
			end
		elseif self.blackBackground:getAlpha() > 0 then
			self.blackBackground:setAlpha(math.min(1, self.blackBackground:getAlpha() - deltaTime / FADE_TIME))
		end
	elseif self.nextScreen then
		self:changeScreen()
	end
	self.framerateCounter:update(deltaTime)
end

function ScreenManager:getCurrentScreen()
	return self.currentScreen
end

return ScreenManager