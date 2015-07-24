local FramerateCounter = require "FramerateCounter"
local Screen = require "Screen"
local World  = require "World"
local Camera = require "Camera"
local Player = require "Player"

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
	self.player:setPosition(0, 0, self.world.depth/2 - 1200)

	-- Счётчик фпс
	self.framerateCounter = FramerateCounter.new(1)
	self:addChild(self.framerateCounter)
end

function GameScreen:unload()

end

function GameScreen:update(dt)
	self.world:update(dt)
	self.player:update(dt)
	self.framerateCounter:update(dt)

	-- Следование камеры за игроком
	self.camera:setPosition(self.player:getX(), self.player:getY(), -self.camera.width)
end

return GameScreen