-- Endless level

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

local START_SPEED = 1.2
local MAX_SPEED = 1.8
local SPEED_MUL = 30

function LevelLogic:init()
	self.requiredTime = 60 * 60 * 24 * 31
	self.planesCount = 3

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

	self.planesIntervals = {
		{0, 1, {1, 2, 3}},
		{1, 50, {1, 2, 3, 4}},
		{50, 65, {1, 2, 3, 4, 5, 6}},
		{65, 80, {5, 7, 8}},
		{80, 100, {7, 8, 9, 10}},
		-- Вентиляторы
		{100, 115, {8, 9, 10, 12, 12}},
		{115, 130, {9, 10, 12, 13}},
		{130, 160, {12, 13}},
		{130, 160, {9, 12, 13}},
	}

	self:setCameraType(LevelLogic.CAMERA_ROTATING_SIN)
	self.camSpeed = 0
end

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed * START_SPEED)
end

function LevelLogic:update(deltaTime)
	self:updatePlanesIntervals()

	local newSpeed = math.min(self.world.defaultFallingSpeed * MAX_SPEED, self.world.fallingSpeed + deltaTime * SPEED_MUL)
	self:setFallingSpeed(newSpeed)

	self.camSpeed = math.min(90, self.camSpeed + deltaTime / 3)
	self:setCameraSpeed(self.camSpeed)
end

return LevelLogic