local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.requiredTime = 110
end

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed * 1.1)

	self:setCameraType(LevelLogic.CAMERA_ROTATING_CONSTANTLY)
	self:setCameraSpeed(5)
end

return LevelLogic