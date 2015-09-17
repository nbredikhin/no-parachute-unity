-- Level 4
-- Spaceship

local LevelLogicBase = require "LevelLogic"

local LevelLogic = Core.class(LevelLogicBase)

function LevelLogic:init()
	self.requiredTime = 120
end

function LevelLogic:initialize()
	self:setFallingSpeed(self.defaultFallingSpeed * 1)

	self:setCameraType(LevelLogic.CAMERA_ROTATING_CONSTANTLY)
	self:setCameraSpeed(-20)
	
	self:setBackgroundColor(10, 20, 80)
end

return LevelLogic