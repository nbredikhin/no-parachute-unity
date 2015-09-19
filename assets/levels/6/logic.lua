-- Level 6

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.requiredTime = 120
	self.planesCount = 3

	self.movingPlanes[8] = function(plane, deltaTime, gameTime)
		local progress = math.cos(gameTime * 5) + 1
		plane:setRotation(0)
		plane:setX(-progress * plane.size / 8)
		plane.decoPlane:setX(progress * plane.size / 8)
	end

	self.movingPlanes[9] = function(plane, deltaTime, gameTime)
		plane.basePlane:setRotation(plane:getRotation() - 90 * deltaTime)
	end

	self.movingPlanes[10] = function(plane, deltaTime, gameTime)
		plane.basePlane:setRotation(plane:getRotation() + 360 * deltaTime)
	end

	self.movingPlanes[11] = function(plane, deltaTime, gameTime)
		plane.basePlane:setRotation(plane:getRotation() + 90 * deltaTime)
	end

	self.movingPlanes[15] = function(plane, deltaTime, gameTime)
		plane.decoPlane:setRotation(plane.decoPlane:getRotation() - 90 * deltaTime)
	end
end

function LevelLogic:initialize()
	self:setCameraType(LevelLogic.CAMERA_ROTATING_SIN)
	self:setCameraSpeed(90)
	self:setFallingSpeed(self.defaultFallingSpeed * 1.4)
end

return LevelLogic