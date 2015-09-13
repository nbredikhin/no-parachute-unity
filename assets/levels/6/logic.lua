-- Level 6

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.requiredTime = 120
	self.planesCount = 3
end

function LevelLogic:initialize()
	self:setCameraType(LevelLogic.CAMERA_ROTATING_SIN)
	self:setCameraSpeed(90)
	self:setFallingSpeed(self.defaultFallingSpeed * 1.4)
end

return LevelLogic