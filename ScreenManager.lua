local ScreenManager = Core.class(Sprite)

function ScreenManager:init()
	self.currentScreen = false
end

function ScreenManager:loadScreen(screen)
	-- Скрыть текущий экран
	if self.currentScreen and self.currentScreen:getParent() then
		self:removeChild(self.currentScreen)
		self.currentScreen:unload()
		self.currentScreen = false
	end
	application:configureFrustum(0, 100)
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
	return true
end

function ScreenManager:update(deltaTime)
	if self.currentScreen then
		self.currentScreen:update(deltaTime)
	end
end

function ScreenManager:getCurrentScreen()
	return self.currentScreen
end

return ScreenManager