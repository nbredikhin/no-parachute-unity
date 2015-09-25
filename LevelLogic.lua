local LevelLogic = Core.class()
-- Режимы камеры
LevelLogic.CAMERA_STATIC = "static"
LevelLogic.CAMERA_ROTATING_CONSTANTLY = "rotating_constantly"
LevelLogic.CAMERA_ROTATING_SIN = "rotating_sin"
LevelLogic.CAMERA_ROTATING_PLAYER = "rotating_player"

function LevelLogic:init()
	self.planesCount = 3
	self.requiredTime = 120
	self.gameTime = 0
	self.defaultFallingSpeed = 7500
	self.movingPlanes = {}

	-- Camera
	self.cameraType = LevelLogic.CAMERA_STATIC
	self.cameraSpeed = 0

	self.enabledPlanes = {}
	self.currentInterval = 0
	self.planesIntervals = {}
end

function LevelLogic:initialize()
	-- to override
end

function LevelLogic:updatePlanesIntervals()
	if self.planesIntervals[self.currentInterval + 1] and
		self.gameTime > self.planesIntervals[self.currentInterval + 1][1] and
		self.gameTime < self.planesIntervals[self.currentInterval + 1][2] 
	then
		self.enabledPlanes = self.planesIntervals[self.currentInterval + 1][3]
		self.currentInterval = self.currentInterval + 1
		print("Switch interval: ", self.currentInterval)
	end
end

function LevelLogic:update()
	self:updatePlanesIntervals()
end

function LevelLogic:setBackgroundColor(r, g, b)
	self.world:setBackgroundColor(r, g, b)
end

function LevelLogic:setFallingSpeed(speed)
	self.world:setFallingSpeed(speed)
end

function LevelLogic:setCameraType(cameraType)
	self.cameraType = cameraType
end

function LevelLogic:setCameraSpeed(speed)
	self.cameraSpeed = speed
end

function LevelLogic:setPowerupsEnabled(isEnabled)
	self.world.powerupsEnabled = isEnabled
end

return LevelLogic