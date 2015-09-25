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
local CAMERA_SHAKING_POWER = 100
local defaultWorldRotationSpeed = 32

local GAME_SOUNDS_NAMES = {
	"lost_part",
	"ring",
	"fail",
	"powerup"
}

function GameScreen:load(levelID)
	if not levelID then
		levelID = 1
	end
	self.levelID = levelID

	application:setBackgroundColor(0)

	-- Игрок
	self.player = Player.new()
	self.player:addEventListener(Player.WASTED, self.onPlayerWasted, self)
	self.player:addEventListener(Player.LOST_PART, self.onPlayerLostPart, self)

	-- Скрипт уровня
	local scriptPath = "assets/levels/" .. tostring(levelID) .."/logic"
	local LevelLogicClass = require(scriptPath)
	if LevelLogicClass then
		self.levelLogic = LevelLogicClass.new()
	else
		print("Failed to load 'logic.lua' for level " .. tostring(levelID))
	end
	if #self.levelLogic.planesIntervals > 0 and self.levelLogic.planesIntervals[1][1] == 0 then
		self.levelLogic.enabledPlanes = self.levelLogic.planesIntervals[1][3]
	end
	-- Мир
	self.world = World.new(self, self.player, self.levelID)
	self:addChild(self.world)
	self.levelLogic.world = self.world
	self.world.levelLogic = self.levelLogic

	-- Камера
	self.camera = Camera.new(self.world)
	self.camera:setCenter(self.camera.width / 2, self.camera.height / 2, -self.world.depth / 2 + 1000)
	self.cameraShakeDelay = 0

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
	self.ui.progressMax = math.floor(self.levelLogic.requiredTime)
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

	self.levelLogic:initialize()

	stage:addEventListener(Event.APPLICATION_SUSPEND, self.onApplicationSuspend, self)

	self.sounds = {}
	for _,v in ipairs(GAME_SOUNDS_NAMES) do
		self.sounds[v] = Sound.new("assets/sounds/" .. v .. ".wav")
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
	self.ui:setProgress(self.timeAlive / self.levelLogic.requiredTime)

	if self.isPaused then
		return
	end

	self.player:update(dt)
	self.world:update(dt, self.timeAlive)

	-- Следование камеры за игроком
	local cameraRotationRadius = cameraRotationRadiusAlive
	local cameraRotationSpeed = cameraRotationSpeedAlive
	if not self.player.isAlive then
		cameraRotationRadius = cameraRotationRadiusDead
		cameraRotationSpeed = cameraRotationSpeedDead
	end
	local rotX = math.cos(os.timer() * cameraRotationSpeed) * cameraRotationRadius
	local rotY = math.sin(os.timer() * cameraRotationSpeed) * cameraRotationRadius

	local cameraFinishedOffset = 0
	--[[if self.timeAlive > self.levelLogic.requiredTime then
		cameraFinishedOffset = (self.timeAlive - self.levelLogic.requiredTime) * 2000
	end]]
	local shakeX = self.cameraShakeDelay * math.random(-CAMERA_SHAKING_POWER, CAMERA_SHAKING_POWER)
	local shakeY = self.cameraShakeDelay * math.random(-CAMERA_SHAKING_POWER, CAMERA_SHAKING_POWER)
	if self.cameraShakeDelay <= 0 then
		self.cameraShakeDelay = 0
	else
		self.cameraShakeDelay = self.cameraShakeDelay - dt
	end
 	self.camera:setPosition(self.player:getX() + rotX + shakeX, self.player:getY() + rotY + shakeY, -800 - cameraFinishedOffset)

 	-- Вращение камеры
 	if self.player.isAlive then
 		if self.levelLogic.cameraType == LevelLogic.CAMERA_ROTATING_CONSTANTLY then
		 	local cameraRotation = self.camera:getRotation()
		 	self.camera:setRotation(cameraRotation + self.levelLogic.cameraSpeed * dt)
		 	self.player.cameraRotation = cameraRotation
		elseif self.levelLogic.cameraType == LevelLogic.CAMERA_ROTATING_SIN then
		 	local cameraRotation = self.camera:getRotation()
		 	self.camera:setRotation(cameraRotation + self.levelLogic.cameraSpeed * dt * math.sin(self.world.time))
		 	self.player.cameraRotation = cameraRotation
		elseif self.levelLogic.cameraType == LevelLogic.CAMERA_ROTATING_PLAYER then
			local cameraRotation = self.camera:getRotation()
			self.levelLogic.cameraSpeed = self.levelLogic.cameraSpeed + self.input.valueX * dt * 200
			self.levelLogic.cameraSpeed = self.levelLogic.cameraSpeed * 0.99
		 	self.camera:setRotation(cameraRotation + self.levelLogic.cameraSpeed * dt)
		 	self.player.cameraRotation = cameraRotation
		end
	end

	-- Управление игроком
	if not self.world:isFinished() then
		self.player.inputX, self.player.inputY = self.input.valueX, self.input.valueY
	else
		self.player.inputX = 0
		self.player.inputY = 0
	end

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
		local add = 1
		if self.world.speedupActive then
			add = 4
		end
		self.timeAlive = self.timeAlive + add * dt

		if self.timeAlive >= self.levelLogic.requiredTime then
			if not self.ui.endUI:isVisible() then
				self.ui:showEndUI()
			end		
		end
	end
end

function GameScreen:onTouchBegin(e)
	-- Игрок мёртв
	if not self.player.isAlive then
		-- Нажатие на кнопку "Back to menu"
		if self.ui.backButton:hitTestPoint(e.x, e.y) then
			screenManager:loadScreen("MainMenuScreen")
		-- Нажатие на кнопку "Tap to restart"
		elseif self.ui.deathUI.restartButton:hitTestPoint(e.x, e.y) then
			self:restartButtonTouch()
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
				screenManager:loadScreen("MainMenuScreen")
			-- Нажатие на кнопку "Tap to continue"
			elseif self.ui.pauseUI.continueText:hitTestPoint(e.x, e.y) then
				self.ui:setPauseUIVisible(false)
				self.isPaused = false
			end
		end
	end

	if self.ui.restartButton:isVisible() and self.ui.restartButton:hitTestPoint(e.x, e.y) then
		self:restartButtonTouch(true)
	end

	if not self.world:isFinished() then
		if self.player.isAlive and not self.isPaused then
			self.ui.touchButton:setPosition(e.x, e.y)
			self.ui.touchButton:setVisible(true)
		else
			self.ui.touchButton:setVisible(false)
		end
	end

	if self.ui.endUI:isVisible() and self.ui.endUI:getAlpha() > 0.6 then
		screenManager:loadScreen(screenManager.screens.LevelSelectScreen.new(), self.levelID, true)

	end
end

function GameScreen:onTouchEnd()
	self.ui.touchButton:setVisible(false)
end

function GameScreen:restartButtonTouch(isReset)
	self.lifes = self.lifes - 1
	if self.lifes <= 0 or isReset then
		screenManager:loadScreen("GameScreen", self.levelID)
		return
	end
	self.ui:setDeathUIVisible(false)
	self.ui:setLifesCount(self.lifes)

	self.world:respawn()
end

function GameScreen:restartLevel()
	self.timeAlive = 0
	self.lifes = 3
	if #self.levelLogic.planesIntervals > 0 and self.levelLogic.planesIntervals[1][1] == 0 then
		self.levelLogic.enabledPlanes = self.levelLogic.planesIntervals[1][3]
	end
	self.levelLogic.currentInterval = 0
	self.world:reset()
end

function GameScreen:onPlayerWasted()
	local isGameOver = false
	if self.lifes <= 1 then
		isGameOver = true
	end
	self.ui:setDeathUIVisible(true, isGameOver)
	self:playSound("fail")
end

function GameScreen:onPlayerLostPart()
	self.cameraShakeDelay = 0.5
	self:playSound("lost_part")
end

function GameScreen:back()
	if not self.isPaused then
		self:pauseGame()
	end
end

function GameScreen:pauseGame()
	if self.world:isFinished() or not self.player.isAlive or self.isPaused then
		return
	end
	self.ui:setPauseUIVisible(true)
	self.isPaused = true
	self.ui.touchButton:setVisible(false)
end

function GameScreen:onApplicationSuspend()
	self:pauseGame()
end

function GameScreen:playSound(name)
	if SettingsManager.settings.sound_enabled and self.sounds[name] then
		self.sounds[name]:play()
	end
end

return GameScreen