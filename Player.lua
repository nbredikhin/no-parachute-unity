local PlaneMesh = require "PlaneMesh"
local Blood 	= require "Blood"

local Player = Core.class(Sprite)
Player.WASTED = "playerDead"

local GOD_MODE_DELAY = 5
local GOD_MODE_ALPHA_DELAY = 0.08
local GOD_MODE_ALPHA = 0

function Player:init()
	self.size = 150
	self.movementSpeed = 1500
	self.textures = {}
	self.textures[1] = Assets:getTexture("assets/player1.png")
	self.textures[2] = Assets:getTexture("assets/player2.png")
	self.currentFrame = 1
	self.currentDelay = 0
	self.animationDelay = 0.07
	self.plane = PlaneMesh.new(self.textures[1], self.size * 2)
	self:addChild(self.plane)
	self:setColorTransform(0.2, 0.4, 1, 1)
	self.inputX, self.inputY = 0, 0

	self.sx, self.sy = 0, 0
	self.isAlive = true
	self.cameraRotation = 0

	self.bloodTexture = Assets:getTexture("assets/blood.png")
	self.bloodParticles = {}

	self.godModeEnabled = false
	self.godModeDelay = 0
	self.godModeAlphaDelay = 0
end

function Player:updateAnimation()
	self.currentFrame = self.currentFrame + 1
	if self.currentFrame > 2 then
		self.currentFrame = 1
	end
	self.plane:setPlaneTexture(self.textures[self.currentFrame])
end

function Player:update(dt)
	if self.isAlive then
		-- Анимация
		self.currentDelay = self.currentDelay + dt
		if self.currentDelay >= self.animationDelay then
			self.currentDelay = 0
			self:updateAnimation() 
		end

		-- Скорость
		self.sx = self.sx + (self.inputX - self.sx) * 10 * dt
		self.sy = self.sy + (self.inputY - self.sy) * 10 * dt

		-- Перемещение
		local moveX = self.sx * self.movementSpeed * dt
		local moveY = self.sy * self.movementSpeed * dt
		moveX, moveY = math.rotateVector(moveX, moveY, self.cameraRotation)
		self:setX(self:getX() + moveX)
		self:setY(self:getY() + moveY)

		-- Вращение
		self:setRotation(self.cameraRotation + self.sx * 30)

		-- God mode
		if self.godModeEnabled then
			if self.godModeAlphaDelay > 0 then
				self.godModeAlphaDelay = self.godModeAlphaDelay - dt
			else
				self.godModeAlphaDelay = GOD_MODE_ALPHA_DELAY
				if self:getAlpha() == GOD_MODE_ALPHA then
					self:setAlpha(1)
				else
					self:setAlpha(GOD_MODE_ALPHA)
				end
			end
			if self.godModeDelay > 0 then
				self.godModeDelay = self.godModeDelay - dt
			else
				self:disableGodMode()
			end
		end
	end
	if #self.bloodParticles > 0 then
		for i,p in ipairs(self.bloodParticles) do
			p:update(dt)
		end
	end
end

function Player:setInput(x, y)
	if self.isAlive then
		self.inputX, self.inputY = x, getY()
	end
end

function Player:die()
	self:sprayBlood()
	self.sx = 0
	self.sy = 0
	self.isAlive = false
	self.inputX, self.inputY = 0, 0
	self:dispatchEvent(Event.new(Player.WASTED))
	self:disableGodMode()
end

function Player:respawn()
	self.isAlive = true
	self:setPosition(0, 0)
	self:clearBlood()
	self:disableGodMode()
end

function Player:clearBlood()
	for i,v in ipairs(self.bloodParticles) do
		self:removeChild(v)
	end
	self.bloodParticles = {}
end

function Player:startGodMode()
	self.godModeDelay = GOD_MODE_DELAY
	self.godModeEnabled = true
end

function Player:disableGodMode()
	self.godModeDelay = 0
	self.godModeEnabled = false
	self:setAlpha(1)
end

function Player:sprayBlood()
	local particlesCount = math.floor(math.random(20, 30) * SettingsManager.settings.graphics_quality)
	for i = 1, particlesCount do
		local b = Blood.new(self.bloodTexture)
		b.sx = math.random(0, 30) - 15
		b.sy = math.random(0, 30) - 15
		table.insert(self.bloodParticles, b)
		self:addChild(b)
	end
end

return Player