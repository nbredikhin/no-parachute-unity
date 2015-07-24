local PlaneMesh = require "PlaneMesh"

local Player = Core.class(Sprite)

function Player:init()
	self.movementSpeed = 10
	self.textures = {}
	self.textures[1] = Texture.new("assets/player1.png")
	self.textures[2] = Texture.new("assets/player2.png")
	self.currentFrame = 1
	self.currentDelay = 0
	self.animationDelay = 0.07

	self.plane = PlaneMesh.new(self.textures[1], 100)
	self:addChild(self.plane)

	self:setColorTransform(0.2, 0.4, 1, 1)

	self.inputX, self.inputY = 0, 0
end

function Player:updateAnimation()
	self.currentFrame = self.currentFrame + 1
	if self.currentFrame > 2 then
		self.currentFrame = 1
	end
	self.plane:setPlaneTexture(self.textures[self.currentFrame])
end

function Player:update(dt)
	-- Анимация
	self.currentDelay = self.currentDelay + dt
	if self.currentDelay >= self.animationDelay then
		self.currentDelay = 0
		self:updateAnimation() 
	end

	-- Движение
	self:setX(self:getX() + self.inputX * self.movementSpeed)
	self:setY(self:getY() + self.inputY * self.movementSpeed)

	self:setRotation(self.inputX * 30)
end

function Player:setInput(x, y)
	self.inputX, self.inputY = x, getY()
end

return Player