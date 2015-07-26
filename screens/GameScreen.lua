local InputManager 		= require "InputManager"
local Screen 			= require "screens/Screen"
local World  			= require "World"
local Camera 			= require "Camera"
local Player 			= require "Player"

local GameScreen = Core.class(Screen)

local cameraRotationRadiusAlive = 5
local cameraRotationSpeedAlive = 5

local cameraRotationRadiusDead = 5
local cameraRotationSpeedDead = 2.5

function GameScreen:load()
	application:setBackgroundColor(0)

	-- Игрок
	self.player = Player.new()

	-- Мир
	self.world = World.new(self.player)
	self:addChild(self.world)

	-- Камера
	self.camera = Camera.new(self.world)
	self.camera:setCenter(self.camera.width / 2, self.camera.height / 2, -self.world.depth / 2)
	self.camera:setPosition(0, 0, -self.camera.width)

	-- Ввод
	self.input = InputManager.new()
	self:addChild(self.input)

	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouch, self)
	stage:addEventListener(Event.KEY_DOWN, self.onKey, self)
end

function GameScreen:unload()

end

function GameScreen:update(dt)
	self.world:update(dt)
	self.player:update(dt)

	-- Следование камеры за игроком
	local cameraRotationRadius = cameraRotationRadiusAlive
	local cameraRotationSpeed = cameraRotationSpeedAlive
	if not self.player.isAlive then
		cameraRotationRadius = cameraRotationRadiusDead
		cameraRotationSpeed = cameraRotationSpeedDead
	end
	local rotX = math.cos(os.timer() * cameraRotationSpeed) * cameraRotationRadius
	local rotY = math.sin(os.timer() * cameraRotationSpeed) * cameraRotationRadius
 	self.camera:setPosition(self.player:getX() + rotX, self.player:getY() + rotY, -self.camera.width)

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
end

function GameScreen:onTouch()
	if not self.player.isAlive then
		self.world:respawn()
	end
end

function GameScreen:onKey(e)
	if e.keyCode == KeyCode.BACK or e.keyCode == 8 then
		screenManager:loadScreen(screenManager.screens.MainMenuScreen.new())
	end
end

return GameScreen