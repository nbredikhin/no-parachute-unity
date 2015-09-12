local FramerateCounter 		= require "FramerateCounter"
local GameScreen 			= require "screens/GameScreen"
local LevelSelectScreen 	= require "screens/LevelSelectScreen"
local MainMenuScreen 		= require "screens/MainMenuScreen"
local SettingsMenuScreen 	= require "screens/SettingsMenuScreen"

local ScreenManager = Core.class(Sprite)

local FADE_TIME = 0.5

function ScreenManager:init()
	self.currentScreen = false

	-- Счётчик фпс
	self.framerateCounter = FramerateCounter.new()
	self:addChild(self.framerateCounter)

	self.infoText = TextField.new(nil, "No Parachute! development version")
	self.infoText:setTextColor(0xFFFFFF)
	self.infoText:setPosition(5, utils.screenHeight - 5)
	self:addChild(self.infoText)

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
	self.currentScreen:setAlpha(0)
	self.currentScreen:load(unpack(self.nextScreenArgs))
	self:addChildAt(self.currentScreen, 1)

	self.nextScreen = nil
	return true
end

function ScreenManager:loadScreen(screen, ...)
	self.nextScreen = screen
	self.nextScreenArgs = {...}
end

function ScreenManager:update(deltaTime)
	if self.currentScreen then
		self.currentScreen:update(deltaTime)
		if self.nextScreen then
			self.currentScreen:setAlpha(self.currentScreen:getAlpha() - deltaTime / FADE_TIME)
			if self.currentScreen:getAlpha() <= 0 then
				self:changeScreen()
			end
		elseif self.currentScreen:getAlpha() < 1 then
			self.currentScreen:setAlpha(math.min(1, self.currentScreen:getAlpha() + deltaTime / FADE_TIME))
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