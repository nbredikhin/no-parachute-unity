-- Level 6

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.requiredTime = 120
	self.planesCount = 2
end

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed * 1.5)
	self:setBackgroundColor(61, 33, 33)

	self:setCameraType(LevelLogic.CAMERA_ROTATING_CONSTANTLY)
	self:setCameraSpeed(-50)
end

return LevelLogic