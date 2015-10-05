-- Level 6

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.requiredTime = 180
	self.planesCount = 3

	self.movingPlanes[8] = function(plane, _, gameTime)
		local progress = math.cos(gameTime * 5) + 1
		plane:setRotation(0)
		plane:setX(-progress * plane.size / 8)
		plane.decoPlane:setX(progress * plane.size / 8)
	end

	self.movingPlanes[9] = function(plane, deltaTime)
		plane.basePlane:setRotation(plane:getRotation() - 90 * deltaTime)
	end

	self.movingPlanes[10] = function(plane, deltaTime)
		plane.basePlane:setRotation(plane:getRotation() + 360 * deltaTime)
	end

	self.movingPlanes[11] = function(plane, deltaTime)
		plane.basePlane:setRotation(plane:getRotation() + 90 * deltaTime)
	end

	self.movingPlanes[15] = function(plane, deltaTime)
		plane.decoPlane:setRotation(plane.decoPlane:getRotation() - 90 * deltaTime)
	end

	self.planesIntervals = {
		{0, 1, {1}},
		{1, 18, {1, 2, 3, 4}},
		{18, 30, {1, 2, 3, 4, 5, 6, 7}},
		{30, 50, {2, 3, 4, 5, 6, 7, 8}},
		{50, 70, {3, 4, 5, 6, 7, 8, 9, 10, 12}},
		{70, 90, {15, 11, 9, 10}},
		{90, 120, {3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}},
		{120, self.requiredTime, {15, 11, 9, 10, 14, 6, 8, 10, 10, 9, 11}}
	}
end

function LevelLogic:initialize()
	self:setCameraType(LevelLogic.CAMERA_ROTATING_SIN)
	self:setCameraSpeed(90)
	self:setFallingSpeed(self.defaultFallingSpeed * 1.5)
end

return LevelLogic