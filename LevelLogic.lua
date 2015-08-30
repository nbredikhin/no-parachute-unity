local LevelLogic = Core.class()
-- Режимы камеры
LevelLogic.CAMERA_STATIC = "static"
LevelLogic.CAMERA_ROTATING_CONSTANTLY = "rotating_constantly"

function LevelLogic:init(world)
	self.world = world
	self.gameTime = 0
	self.defaultFallingSpeed = 9000

	-- Camera
	self.cameraType = LevelLogic.CAMERA_STATIC
	self.cameraSpeed = 0
end

function LevelLogic:initialize()
	-- to override
end

function LevelLogic:update(deltaTime)
	-- to override
end

function LevelLogic:setFallingSpeed(speed)
	self.world.fallingSpeed = speed
end

function LevelLogic:setCameraType(cameraType)
	self.cameraType = cameraType
end

function LevelLogic:setCameraSpeed(speed)
	self.cameraSpeed = speed
end

return LevelLogic