local Plane 		= require "Plane"
local PlaneMesh 	= require "PlaneMesh"
local TexturePNG 	= require "TexturePNG"
local Player 		= require "Player"

local World = Core.class(Sprite)

local defaultWorldSize = 3000
local DEFAULT_FALLING_SPEED = 9000
local defaultDecorativePlanesCount = 30
local defaultPlanesCount = 3
local WALLS_COUNT = 10

function World:init(player, levelID)
	if not levelID then
		levelID = 1
	end
	-- Размеры мира
	self.size = defaultWorldSize
	self.depth = self.size * 10

	self.defaultFallingSpeed = DEFAULT_FALLING_SPEED
	self.fallingSpeed = self.defaultFallingSpeed

	-- Игрок
	self.player = player
	self:addChild(self.player)
	self.player:addEventListener(Player.LOST_PART, self.onPlayerLostPart, self)
	self.player:setPosition(0, 0, self.depth/2 - 3600)

	-- Боковые стены
	self.walls = {}
	local wallTexture = Assets:getTexture("assets/levels/" .. tostring(levelID) .."/wall.png")
	local currentZ = self.depth/2
	for i = 1, WALLS_COUNT do
		local wallContainer = Sprite.new()
		wallContainer:setZ(currentZ)
		for i = 1, 4 do
			local wall = PlaneMesh.new(wallTexture, self.size)
			wall:setRotationX(90)
			wall:setRotationY(90 * (i - 1))
			wall:setZ(self.size / 2)
			wallContainer:addChild(wall)
		end
		self:addChild(wallContainer)
		table.insert(self.walls, wallContainer)
		currentZ = currentZ - self.size
	end

	-- Передние декоративные стены
	self.decorativePlanesCount = math.floor(defaultDecorativePlanesCount * SettingsManager.settings.graphics_quality)
	self.decorativePlanes = {}
	self.decorativeTextures = {}
	-- Загрузка текстур
	for i = 1, 50 do
		local path = "assets/levels/" .. tostring(levelID) .."/deco/" .. tostring(i) ..".png"
		if utils.fileExists(path) then
			self.decorativeTextures[i] = Assets:getTexture(path)
		else
			break
		end
	end
	-- Создание стен
	for i = 1, self.decorativePlanesCount do
		local d = self.depth / self.decorativePlanesCount
		local texture = self.decorativeTextures[math.random(1, #self.decorativeTextures)]
		self.decorativePlanes[i] = PlaneMesh.new(texture, self.size)
		self.decorativePlanes[i]:setPosition(0, 0, -i * d + self.depth / 2)
		self.decorativePlanes[i]:setRotation(math.random(1, 4) * 90)
		self:addChild(self.decorativePlanes[i])
	end

	-- Передние стены
	self.planesCount = defaultPlanesCount
	self.planes = {}
	self.planeTextures = {}
	for i = 1, 50 do
		local path = "assets/levels/" .. tostring(levelID) .. "/planes/" .. tostring(i) ..".png"
		if utils.fileExists(path) then
			self.planeTextures[i] = TexturePNG.new(path)
		else
			break
		end
	end
	for i = 1, self.planesCount do
		local texture = self.planeTextures[math.random(1, #self.planeTextures)]
		local plane = Plane.new(texture, self.size)
		plane:setPosition(0, 0, -i * self.depth / self.planesCount + 10)
		plane:setRotation(math.random(1, 4) * 90)
		self:addChild(plane)
		self.planes[i] = plane
	end
	self.totalDistance = 0

	-- Отлетающие части тела
	self.flyingBodyparts = {}
end

function World:updatePlane(plane, dt)
	local wasMovedToBottom = false
	plane:setZ(plane:getZ() + self.fallingSpeed * dt)

	if plane:getZ() > self.depth / 2 then
		plane:setZ(plane:getZ() - self.depth)
		plane:setRotation(math.random(1, 4) * 90)
		wasMovedToBottom = true
	end

	local mul = math.clamp((plane:getZ() + self.depth / 2) / self.depth, 0, 1)
	plane:setColorTransform(mul, mul, mul, 1)
	return wasMovedToBottom
end

function World:respawn()
	for i, plane in ipairs(self.planes) do
		plane:setZ(plane:getZ() + 3200)
		self:updatePlane(plane, 0)
	end

	self.player:respawn()
	self.player:startGodMode()
	self.fallingSpeed = self.defaultFallingSpeed
end

function World:update(dt)
	-- Движение боковых стен
	for i, wall in ipairs(self.walls) do
		self:updatePlane(wall, dt)
		--local mul = math.clamp((wall:getZ() + self.depth / 2 + self.size * 2) / self.depth, 0, 1)
		--wall:setColorTransform(mul, mul, mul, 1)
	end

	-- Движение декораций
	for i, plane in ipairs(self.decorativePlanes) do
		if self:updatePlane(plane, dt) then
			plane:setPlaneTexture(self.decorativeTextures[math.random(1, #self.decorativeTextures)])
		end
	end

	-- Обновление передних стен
	for i, plane in ipairs(self.planes) do
		if self:updatePlane(plane, dt) then
			-- Обновление текстуры
			plane:setPlaneTexture(self.planeTextures[math.random(1, #self.planeTextures)])
		end
		-- Исчезновение в прозрачность
		--[[if plane:getZ() > self.depth / 2 - 800 then
			local alpha = 1 - (plane:getZ() - self.depth / 2) / 800
			local r, g, b = plane:getColorTransform()
			plane:setColorTransform(r, g, b, alpha)
		end]]

		-- Проверка столкновений
		if self.player.isAlive and not self.player.godModeEnabled then
			if plane:getZ() >= self.player:getZ() - self.fallingSpeed * dt  * 2 and plane:getZ() <= self.player:getZ() + self.fallingSpeed * dt  * 2 then
				if self.player:hitTestPlane(plane) then
					--plane:setZ(self.player:getZ())
					self.player:die()
					self.fallingSpeed = 0
				end
			end
		end
	end

	-- Обновление разлетающихся конечностей
	for i, part in ipairs(self.flyingBodyparts) do
		part:setX(part:getX() + part.sx * dt)
		part:setY(part:getY() + part.sy * dt)
		part:setZ(part:getZ() + self.fallingSpeed * dt * 2)
		part:setRotation(part:getRotation() + part.rotationSpeed * dt)

		if part:getZ() > self.depth / 2 then
			self:removeChild(part)
			table.remove(self.flyingBodyparts, i)
		end
	end

	self.totalDistance = self.totalDistance + self.fallingSpeed * dt
end

function World:setFallingSpeed(speed)
	self.fallingSpeed = speed
	self.defaultFallingSpeed = speed
end

function World:onPlayerLostPart(e)
	local part = PlaneMesh.new(e.texture, self.player.size * 2)
	part:setPosition(self.player:getPosition())
	self:addChild(part)
	part.sx = math.random(-100, 100)
	part.sy = math.random(-100, 100)
	part.rotationSpeed = math.random(600, 800)
	part:setColorTransform(self.player:getColorTransform())
	part:setRotation(self.player:getRotation())
	table.insert(self.flyingBodyparts, part)
end

return World
