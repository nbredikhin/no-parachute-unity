-- Level 6

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.requiredTime = 120
	self.planesCount = 3

	self.movingPlanes[8] = function(plane, deltaTime, gameTime)
		local progress = math.cos(gameTime * 2) + 1
		plane:setRotation(0)
		plane:setX(-progress * plane.size / 2)
		plane.decoPlane:setX(progress * plane.size / 2)
	end

	self.movingPlanes[9] = function(plane, deltaTime, gameTime)
		plane.basePlane:setRotation(plane:getRotation() - math.random(70, 90) * deltaTime)
	end

	self.movingPlanes[10] = function(plane, deltaTime, gameTime)
		plane.basePlane:setRotation(plane:getRotation() + math.random(360 * 3) * deltaTime)
	end
end

function LevelLogic:initialize()
	self:setCameraType(LevelLogic.CAMERA_ROTATING_SIN)
	self:setCameraSpeed(90)
	self:setFallingSpeed(self.defaultFallingSpeed * 1.4)
end

return LevelLogic