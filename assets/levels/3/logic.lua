local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.requiredTime = 100

	self.movingPlanes[5] = function(plane, deltaTime, gameTime)
		plane.basePlane:setRotation(plane:getRotation() + 90 * deltaTime)
	end

	self.planesIntervals = {
		{0, 1, {1}},
		{1, 40, {1, 2, 3, 4}},
		{40, 65, {2, 3, 4, 5}},
		{65, 75, {5, 5, 5, 2}},
		{75, self.requiredTime, {2, 3, 4, 5}}
	}
end

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed * 1.15)

	self:setCameraType(LevelLogic.CAMERA_ROTATING_CONSTANTLY)
	self:setCameraSpeed(5)
end

return LevelLogic