local Camera 			= require "Camera"
local GameUI			= require "ui/game/GameUI"
local InputManager 		= require "InputManager"
local Player 			= require "Player"
local Screen 			= require "screens/Screen"
local World  			= require "World"
local LevelLogic 		= require "LevelLogic"

local GameScreen = Core.class(Screen)

local cameraRotationRadiusAlive = 5
local cameraRotationSpeedAlive = 5

local cameraRotationRadiusDead = 5
local cameraRotationSpeedDead = 2.5

local defaultWorldRotationSpeed = 32

function GameScreen:init()
end

function GameScreen:load(levelID)
	if not levelID then
		levelID = 1
	end
	self.levelID = levelID

	application:setBackgroundColor(0)

	-- Игрок
	self.player = Player.new()
	self.player:addEventListener(Player.WASTED, self.onPlayerWasted, self)

	-- Мир
	self.world = World.new(self.player, self.levelID)
	self:addChild(self.world)

	-- Камера
	self.camera = Camera.new(self.world)
	self.camera:setCenter(self.camera.width / 2, self.camera.height / 2, -self.world.depth / 2)

	-- Ввод
	self.input = InputManager.new()
	self:addChild(self.input)
	-- Нажатие на экран
	self.input:addEventListener(InputManager.TOUCH_BEGIN, self.onTouchBegin, self)
	self.input:addEventListener(InputManager.TOUCH_END, self.onTouchEnd, self)

	-- Избежать обновления игры, пока происходит загрузка уровня
	self.skipUpdate = true

	-- Интерфейс игры
	self.ui = GameUI.new()
	self:addChild(self.ui)

	-- Вращение мира
	self.worldRotationSpeed = defaultWorldRotationSpeed
	self.camera:setRotation(0)

	-- Пауза
	self.isPaused = false

	-- Время
	self.timeAlive = 0 

	-- Жизни
	self.lifes = 3

	-- Скрипт уровня
	local scriptPath = "assets/levels/" .. tostring(levelID) .."/logic"
	local LevelLogicClass = require(scriptPath)
	if LevelLogicClass then
		self.levelLogic = LevelLogicClass.new(self.world)
		self.levelLogic:initialize()
	else
		print("Failed to load 'logic.lua' for level " .. tostring(levelID))
	end
end

function GameScreen:unload()
	self.input:removeEventListener(InputManager.TOUCH_BEGIN, self.onTouchBegin, self)
	self.input:removeEventListener(InputManager.TOUCH_END, self.onTouchEnd, self)
end

function GameScreen:update(dt)
	if self.skipUpdate then
		self.skipUpdate = false
		return
	end

	self.ui:update(dt)
	self.ui:setProgress(self.timeAlive / 120)

	if self.isPaused then
		return
	end

	self.player:update(dt)
	self.world:update(dt)

	-- Следование камеры за игроком
	local cameraRotationRadius = cameraRotationRadiusAlive
	local cameraRotationSpeed = cameraRotationSpeedAlive
	if not self.player.isAlive then
		cameraRotationRadius = cameraRotationRadiusDead
		cameraRotationSpeed = cameraRotationSpeedDead
	end
	local rotX = math.cos(os.timer() * cameraRotationSpeed) * cameraRotationRadius
	local rotY = math.sin(os.timer() * cameraRotationSpeed) * cameraRotationRadius
 	self.camera:setPosition(self.player:getX() + rotX, self.player:getY() + rotY, -800)

 	-- Вращение камеры
 	if self.player.isAlive then
 		if self.levelLogic.cameraType == LevelLogic.CAMERA_STATIC then

 		elseif self.levelLogic.cameraType == LevelLogic.CAMERA_ROTATING_CONSTANTLY then
		 	local cameraRotation = self.camera:getRotation()
		 	self.camera:setRotation(cameraRotation + self.levelLogic.cameraSpeed * dt)
		 	self.player.cameraRotation = cameraRotation
		end
	end

	-- Управление игроком
	self.player.inputX, self.player.inputY = self.input.valueX, self.input.valueY

	-- Столкновение игрока с боковыми стенами
	if self.player:getX() > self.world.size / 2 - self.player.size then
		self.player:setX(self.world.size / 2 - self.player.size)
	elseif self.player:getX() < -(self.world.size / 2 - self.player.size) then
		self.player:setX(-(self.world.size / 2 - self.player.size))
	end
	if self.player:getY() > self.world.size / 2 - self.player.size then
		self.player:setY(self.world.size / 2 - self.player.size)
	elseif self.player:getY() < -(self.world.size / 2 - self.player.size) then
		self.player:setY(-(self.world.size / 2 - self.player.size))
	end

	-- Ограничение движения камеры
	if self.camera:getX() < -self.world.size / 2 + self.camera.width / 2 then
		self.camera:setX(-self.world.size / 2 + self.camera.width / 2)
	elseif self.camera:getX() > self.world.size / 2 - self.camera.width / 2 then
		self.camera:setX(self.world.size / 2 - self.camera.width / 2)
	end
	if self.camera:getY() < -self.world.size / 2 + self.camera.height / 2 then
		self.camera:setY(-self.world.size / 2 + self.camera.height / 2)
	elseif self.camera:getY() > self.world.size / 2 - self.camera.height / 2 then
		self.camera:setY(self.world.size / 2 - self.camera.height / 2)
	end

	-- Обновление интерфейса
	if self.ui.touchButton:isVisible() then
		local touchX = self.input.startX + self.input.valueX * self.input.maxTouchValue
		local touchY = self.input.startY + self.input.valueY * self.input.maxTouchValue
		local touchAlpha = (self.input.valueX * self.input.valueX + self.input.valueY * self.input.valueY) * 0.5
		self.ui.touchButton:setAlpha(touchAlpha)
		self.ui.touchButton:setPosition(touchX, touchY)
	end

	if self.player.isAlive then
		self.timeAlive = self.timeAlive + dt
	end
end

function GameScreen:onTouchBegin(e)
	-- Игрок мёртв
	if not self.player.isAlive then
		-- Нажатие на кнопку "Back to menu"
		if self.ui.backButton:hitTestPoint(e.x, e.y) then
			self:back()
		-- Нажатие на кнопку "Tap to restart"
		elseif self.ui.deathUI.restartButton:hitTestPoint(e.x, e.y) then
			self.ui:setDeathUIVisible(false)
			self.world:respawn()
		end
	else -- Если игрок жив
		-- Во время игры
		if not self.isPaused then 
			if self.ui.pauseButton:hitTestPoint(e.x, e.y) then
				self.ui:setPauseUIVisible(true)
				self.isPaused = true
			end
		else -- Во время паузы
			-- Нажатие на кнопку "Back to menu"
			if self.ui.backButton:hitTestPoint(e.x, e.y) then
				self:back()
			-- Нажатие на кнопку "Tap to continue"
			elseif self.ui.pauseUI.continueText:hitTestPoint(e.x, e.y) then
				self.ui:setPauseUIVisible(false)
				self.isPaused = false
			end
		end
	end

	if self.player.isAlive and not self.isPaused then
		self.ui.touchButton:setPosition(e.x, e.y)
		self.ui.touchButton:setVisible(true)
	else
		self.ui.touchButton:setVisible(false)
	end
end

function GameScreen:onTouchEnd()
	self.ui.touchButton:setVisible(false)
end

function GameScreen:onPlayerWasted()
	self.ui:setDeathUIVisible(true)
	self.lifes = self.lifes - 1
	if self.lifes <= 0 then
		self.lifes = 3
	end
	self.ui:setLifesCount(self.lifes)
end

function GameScreen:back()
	screenManager:loadScreen(screenManager.screens.MainMenuScreen.new())
end

return GameScreen