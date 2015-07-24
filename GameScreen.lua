local FramerateCounter 	= require "FramerateCounter"
local InputManager 		= require "InputManager"
local Screen 			= require "Screen"
local World  			= require "World"
local Camera 			= require "Camera"
local Player 			= require "Player"

local GameScreen = Core.class(Screen)

function GameScreen:load()
	application:configureFrustum(45, 10000)
	application:setBackgroundColor(0)

	-- Мир
	self.world = World.new()
	self:addChild(self.world)

	-- Камера
	self.camera = Camera.new(self.world)
	self.camera:setCenter(self.camera.width / 2, self.camera.height / 2, -self.world.depth / 2)
	self.camera:setPosition(0, 0, -self.camera.width)

	-- Игрок
	self.player = Player.new()
	self.world:addChild(self.player)
	self.player:setPosition(32, -12, self.world.depth/2 - 1200)

	-- Счётчик фпс
	self.framerateCounter = FramerateCounter.new(1)
	self:addChild(self.framerateCounter)

	-- Ввод
	self.input = InputManager.new()
	self:addChild(self.input)
end

function GameScreen:unload()

end

function GameScreen:update(dt)
	self.world:update(dt)
	self.player:update(dt)
	self.framerateCounter:update(dt)

	-- Следование камеры за игроком
	self.camera:setPosition(self.player:getX(), self.player:getY(), -self.camera.width)

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

return GameScreen