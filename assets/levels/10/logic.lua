-- Endless level

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

local START_SPEED = 1.5
local MAX_SPEED = 1.6
local SPEED_MUL = 30

function LevelLogic:init()
	self.requiredTime = 200
	self.planesCount = 2

	self.movingPlanes[11] = function(plane, deltaTime)
		if not plane.direction then
			plane.direction = 1
			if math.random(1, 2) == 2 then
				plane.direction = -1
			end
		end
		plane.basePlane:setRotation(plane:getRotation() - 110 * deltaTime * plane.direction)
	end

	self.movingPlanes[12] = function(plane, deltaTime)
		if not plane.direction then
			plane.direction = 1
			if math.random(1, 2) == 2 then
				plane.direction = -1
			end
		end
		plane.basePlane:setRotation(plane:getRotation() - 90 * deltaTime * plane.direction)
	end

	self.movingPlanes[13] = function(plane, deltaTime)
		if not plane.direction then
			plane.direction = 1
			if math.random(1, 2) == 2 then
				plane.direction = -1
			end
		end
		plane.basePlane:setRotation(plane:getRotation() + 90 * deltaTime * plane.direction)
	end

	self.movingPlanes[16] = function(plane, deltaTime)
		if not plane.direction then
			plane.direction = 1
			if math.random(1, 2) == 2 then
				plane.direction = -1
			end
		end
		plane.basePlane:setRotation(plane:getRotation() - 220 * deltaTime * plane.direction)
	end

	self.movingPlanes[18] = function(plane, deltaTime)
		if not plane.direction then
			plane.direction = 1
			if math.random(1, 2) == 2 then
				plane.direction = -1
			end
		end
		plane.basePlane:setRotation(plane:getRotation() - 250 * deltaTime * plane.direction)
	end

	self.movingPlanes[20] = function(plane, deltaTime)
		if not plane.direction then
			plane.direction = 1
			if math.random(1, 2) == 2 then
				plane.direction = -1
			end
		end
		plane.basePlane:setRotation(plane:getRotation() - 230 * deltaTime * plane.direction)
	end

	self.movingPlanes[21] = function(plane, deltaTime)
		if not plane.direction then
			plane.direction = 1
			if math.random(1, 2) == 2 then
				plane.direction = -1
			end
		end
		plane.basePlane:setRotation(plane:getRotation() - 230 * deltaTime * plane.direction)
		plane.decoPlane:setRotation(plane.decoPlane:getRotation() + 230 * deltaTime * plane.direction)
	end

	self.planesIntervals = {
		{0, 1, {1, 2, 3}},
		{1, 10, {1, 2, 3, 4}},
		{10, 20, {1, 2, 3, 4, 5, 6}},
		{20, 30, {7, 8, 9, 10}},
		-- Вентиляторы
		{30, 40, {8, 9, 10, 12, 12}},
		{40, 50, {9, 10, 12, 13}},
		{50, 80, {12, 13}},
		{80, 100, {9, 10, 12, 12, 13}},
		-- Переход к металлу
		{100, 115, {7, 17, 11}},
		{115, 140, {14, 15, 16, 17}},
		{140, 150, {14, 16, 18, 19}},
		{150, 160, {16, 18, 19, 20}},
		{160, 200, {16, 18, 19, 20, 21, 21}}
	}

	self:setCameraType(LevelLogic.CAMERA_ROTATING_SIN)
	self.camSpeed = 0
end

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed * START_SPEED)
	self:setBackgroundColor(23, 45, 29)
end

function LevelLogic:update(deltaTime)
	self:updatePlanesIntervals()

	local newSpeed = math.min(self.world.defaultFallingSpeed * MAX_SPEED, self.world.fallingSpeed + deltaTime * SPEED_MUL)
	self:setFallingSpeed(newSpeed)

	self.camSpeed = math.min(90, self.camSpeed + deltaTime / 3)
	self:setCameraSpeed(self.camSpeed)
end

return LevelLogic