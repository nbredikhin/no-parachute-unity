local PlaneMesh = require "PlaneMesh"
local Blood 	= require "Blood"

local Player = Core.class(Sprite)
Player.WASTED = "playerDead"
Player.LOST_PART = "lostPart"

local GOD_MODE_DELAY = 3
local GOD_MODE_ALPHA_DELAY = 0.08
local GOD_MODE_ALPHA = 0

local MISSING_HAND_SPEED_ADD = 0.4

local SMALL_DELAY = 15
local SMALL_SCALE = 0.7
local SMALL_MUL = 0.98

function Player:init()
	self.size = 150
	self.size_scale = 150 / 32
	self.defaultMovementSpeed = 1500
	self.movementSpeed = self.defaultMovementSpeed
	self.textures = {}
	self.textures[1] = Assets:getTexture("assets/player/main1.png")
	self.textures[2] = Assets:getTexture("assets/player/main2.png")
	self.currentFrame = 1
	self.currentDelay = 0
	self.animationDelay = 0.07

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

	self.partsTextures = {}
	self.parts = {}
	self.partsPoints = {}
	self.partsStates = {}

	self:createPart("left_hand", -0.35, -0.35)
	self:createPart("right_hand", 0.35, -0.35)
	self:createPart("left_leg", -0.25, 0.45)
	self:createPart("right_leg", 0.25, 0.45)

	self.plane = PlaneMesh.new(self.textures[1], self.size * 2)
	self:addChild(self.plane)

	self.missingPartsCount = 0
	self.time = 0

	self.smallDelay = 0
	self.isSmall = false
end

function Player:hitTestPlane(plane)
	if plane:hitTestPoint(self:getX(), self:getY()) then
		application:vibrate(500)
		return true
	end
	-- Если игрок взял уменьшение, конечности не отрываются
	if not self.isSmall then
		for i, point in ipairs(self.partsPoints) do
			local pointX, pointY = math.rotateVector(point.x * self.size * 2, point.y * self.size * 2, self:getRotation() + self.parts[point.name]:getRotation())
			local x = self:getX() + pointX
			local y = self:getY() + pointY
			if plane:hitTestPoint(x, y) and self:getPartState(point.name) == "ok" then
				self:setPartState(point.name, "missing")
				self:sprayBloodAtPart(point.x * self.size * 2, point.y * self.size * 2)
				self.missingPartsCount = self.missingPartsCount + 1
				self.sx = self.sx - point.x * self.size / 80
				self.sy = self.sy - point.y * self.size / 80

				local event = Event.new(Player.LOST_PART)
				event.texture = self.partsTextures[point.name .. "_ok"]
				self:dispatchEvent(event)
				application:vibrate(100)
			end
		end
	end
	return false
end

function Player:restoreParts()
	for name, part in pairs(self.parts) do
		self:setPartState(name, "ok")
	end
	self.missingPartsCount = 0
end

function Player:createPart(name, x, y)
	self.partsTextures[name .. "_ok"] 		= Assets:getTexture("assets/player/" .. name .. "_ok.png")
	self.partsTextures[name .. "_missing"] 	= Assets:getTexture("assets/player/" .. name .. "_missing.png")
	self.parts[name] = PlaneMesh.new(self.partsTextures[name .. "_ok"], self.size * 2)
	self:addChild(self.parts[name])
	self.partsStates[name] = "ok"
	table.insert(self.partsPoints, {x=x, y=y, name=name})
end

function Player:getPart(name)
	return self.parts[name]
end

function Player:getPartState(name)
	return self.partsStates[name]
end

function Player:setPartState(name, state)
	if not self.parts[name] then
		return
	end
	if state ~= "ok" and state ~= "missing" then
		return
	end
	if not self.partsTextures[name .. "_" .. state] then
		return
	end
	self.partsStates[name] = state
	self.parts[name]:setTexture(self.partsTextures[name .. "_" .. state])
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
		local inputMul = (1 - self.missingPartsCount / 4)
		local sxAdd = 0
		if self:getPartState("right_hand") == "missing" then
			sxAdd = MISSING_HAND_SPEED_ADD * math.sin(self.time * math.random() * 2) / 2 + MISSING_HAND_SPEED_ADD / 2
		end
		if self:getPartState("left_hand") == "missing" then
			sxAdd = sxAdd - (MISSING_HAND_SPEED_ADD * math.sin(self.time * math.random() * 2) / 2 + MISSING_HAND_SPEED_ADD / 2)
		end
		self.sx = self.sx + (self.inputX * inputMul - self.sx + sxAdd) * 10 * dt
		self.sy = self.sy + (self.inputY * inputMul - self.sy) * 10 * dt

		-- Перемещение
		local moveX = self.sx * self.movementSpeed * dt
		local moveY = self.sy * self.movementSpeed * dt
		moveX, moveY = math.rotateVector(moveX, moveY, self.cameraRotation)
		self:setX(self:getX() + moveX)
		self:setY(self:getY() + moveY)

		-- Вращение
		local missingLegsRotation = 0
		local missingLegsRotationHands = 0
		if self:getPartState("left_leg") == "missing" or self:getPartState("right_leg") == "missing" then
			missingLegsRotation = math.sin(self.time * 3) * 3 * self.missingPartsCount
			missingLegsRotationHands = math.sin(self.time * 16) * 8
		end
		self:setRotation(self.cameraRotation + self.sx * 30 + missingLegsRotation)
		
		-- Поворот рук
		local handsAngle = self.inputX * 10
		self.parts["left_hand"]:setRotation(handsAngle + missingLegsRotationHands)
		self.parts["right_hand"]:setRotation(handsAngle - missingLegsRotationHands)

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
	self.time = self.time + dt

	-- Уменьшение 
	if self.isSmall then
		if self.smallDelay > 0 then
			self.smallDelay = self.smallDelay - dt
			if self.smallDelay < 1 then
				self:setScale(math.min(1, self:getScale() / SMALL_MUL))
			else
				self:setScale(math.max(SMALL_SCALE, self:getScale() * SMALL_MUL))
			end
		else
			self:stopSmall()
		end
	end
end

function Player:setInput(x, y)
	if self.isAlive then
		self.inputX, self.inputY = x, getY()
	end
end

function Player:die()
	self:sprayBloodDeath()
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
	self:restoreParts()
	self:stopSmall()
end

function Player:clearBlood()
	for i,v in ipairs(self.bloodParticles) do
		self:removeChild(v)
	end
	self.bloodParticles = {}
end

function Player:startGodMode(delay)
	self.godModeDelay = delay or GOD_MODE_DELAY
	self.godModeEnabled = true
end

function Player:disableGodMode()
	self.godModeDelay = 0
	self.godModeEnabled = false
	self:setAlpha(1)
end

function Player:sprayBloodDeath()
	local particlesCount = math.floor(35 * SettingsManager.settings.graphics_quality)
	for i = 1, particlesCount do
		local b = Blood.new(self.bloodTexture)
		local angle = math.random() * math.pi * 2
		b.sx = math.cos(angle) * math.random(6, 16)
		b.sy = math.sin(angle) * math.random(6, 16)
		--b:setRotation(angle / math.pi * 180)
		b:setScale(math.random() * 0.5 + 0.5)
		table.insert(self.bloodParticles, b)
		self:addChild(b)
	end
end

function Player:sprayBloodAtPart(x, y)
	local particlesCount = math.floor(math.random(5, 10) * SettingsManager.settings.graphics_quality)
	for i = 1, particlesCount do
		local b = Blood.new(self.bloodTexture)
		b:setPosition(x, y)
		b.sx = math.random(0, 60) - 30
		b.sy = math.random(0, 60) - 30
		b.sz = math.random(200, 300)
		b:setRotation(360 * math.random())
		table.insert(self.bloodParticles, b)
		self:addChild(b)
	end
end

function Player:startSmall()
	self.smallDelay = SMALL_DELAY
	if self.isSmall then
		return
	end
	self.isSmall = true
	self:setScale(1)
end

function Player:stopSmall()
	self.isSmall = false
	self:setScale(1)
	self.smallDelay = 0
end

return Player