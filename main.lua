application:configureFrustum(45, 9000)
application:setBackgroundColor(0x000000)
application:setFps(60)
screenHeight, screenWidth = application:getDeviceWidth(), application:getDeviceHeight()

local world = Sprite.new()
stage:addChild(world)

local worldHeightScale = 10
local worldSize = 1000
local worldHeight = worldSize * worldHeightScale

local cameraCenterPos = {screenWidth / 2, screenHeight / 2, -worldSize * worldHeightScale / 2}

local cameraPos = {}
function setCameraX(x)
	world:setX(cameraCenterPos[1] - x)
	cameraPos[1] = x
end

function setCameraY(y)
	world:setY(cameraCenterPos[2] - y)
	cameraPos[2] = y
end

function setCameraZ(z)
	world:setZ(cameraCenterPos[3] - z)
	cameraPos[3] = z
end

function getCameraX()
	return cameraPos[1]
end

function getCameraY()
	return cameraPos[2]
end

function getCameraZ()
	return cameraPos[3]
end

function setCameraPos(x, y, z)
	setCameraX(x)
	setCameraY(y)
	setCameraZ(z)
end

function buildWalls()
	local wallsSprite = Sprite.new()
	local wallTexture = Texture.new("assets/wall.png")
	local walls = {}
	local size = worldSize
	for i = 1, 4 do
		walls[i] = createPlaneMesh(size)
		wallsSprite:addChild(walls[i])
		setPlaneTexture(walls[i], wallTexture)
	end
	walls[1]:setRotationX(90)
	walls[1]:setRotationY(90)
	setPlaneColor(walls[1], 0x999999)
	
	walls[2]:setRotationX(90)
	walls[2]:setRotationY(180)
	setPlaneColor(walls[2], 0xBBBBBB)
	
	walls[3]:setRotationX(90)
	walls[3]:setRotationY(270)
	setPlaneColor(walls[3], 0xDDDDDD)
	
	walls[4]:setRotationX(90)
	walls[4]:setRotationY(0)
	setPlaneColor(walls[2], 0xBBBBBB)
	
	wallsSprite:setScaleZ(worldHeightScale)
	return wallsSprite
end

setCameraPos(0, 0, -screenWidth)

local walls = buildWalls()
world:addChild(walls)
walls:setRotationY(0)
walls:setRotationX(0)
walls:setPosition(0,0,0)

function buildPlanes(count)
	local planes = {}
	local planeTexture = Texture.new("assets/plane.png")
	for i = 1, count do
		local d = worldHeight / count
		planes[i] = createPlaneMesh(worldSize)
		setPlaneTexture(planes[i], planeTexture)
		world:addChild(planes[i])
		planes[i]:setPosition(0, 0, -i * d)
		planes[i]:setRotation(math.random(1, 4) * 90)
	end
	return planes
end

local planes = buildPlanes(30)
local fallingSpeed = 3000

local fpsText = TextField.new(nil, "FPS: 0")
fpsText:setX(5)
fpsText:setY(10)
fpsText:setTextColor(0xFFFFFF)
stage:addChild(fpsText)

local fpsDelay = 0.1

stage:addEventListener(Event.ENTER_FRAME,
	function(e)
		fpsDelay = fpsDelay - e.deltaTime 
		if fpsDelay <= 0 then
			fpsDelay = 1
			
			local fps = math.floor(1 / e.deltaTime )
			fpsText:setText("FPS: " .. fps)
		end
		for i, plane in ipairs(planes) do
			plane:setZ(plane:getZ() + fallingSpeed * e.deltaTime)
			if plane:getZ() > worldHeight / 2 then
				plane:setZ(plane:getZ() - worldHeight)
			end
			
			local mul = (plane:getZ() + worldHeight/2) / worldHeight
			plane:setColorTransform(mul, mul, mul, 1)
		end
	end
)

local startX = 0
local startY = 0

stage:addEventListener(Event.TOUCHES_BEGIN, 
	function(e)
		startX = e.touch.x
		startY = e.touch.y
	end
)

stage:addEventListener(Event.TOUCHES_MOVE, 
	function(e)
		local mul = 3
		local dx = (startX - e.touch.x) * mul
		setCameraX(math.min(math.max(-worldSize / 2 + screenWidth / 2, getCameraX() + dx), worldSize / 2 - screenWidth / 2))

		local dy = (startY - e.touch.y) * mul
		setCameraY(math.min(math.max(-worldSize / 2 + screenHeight / 2, getCameraY() + dy), worldSize / 2 - screenHeight / 2))

		startX = e.touch.x
		startY = e.touch.y
	end
)

require "lib/png"
img = pngImage("assets/plane.png")
print(img:getPixel(16, 16):format())
