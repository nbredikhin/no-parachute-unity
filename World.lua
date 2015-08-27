local Plane 		= require "Plane"
local PlaneMesh 	= require "PlaneMesh"
local TexturePNG 	= require "TexturePNG"

local World = Core.class(Sprite)

local defaultWorldSize = 3000
local defaultFallingSpeed = 9000
local defaultDecorativePlanesCount = 30
local defaultPlanesCount = 2

local wallsColors = { 0xBBBBBB, 0x999999, 0xBBBBBB, 0xDDDDDD }

function World:init(player, levelID)
	if not levelID then
		levelID = 1
	end
	-- Размеры мира
	self.size = defaultWorldSize
	self.depth = self.size * 10

	self.fallingSpeed = defaultFallingSpeed

	-- Игрок
	self.player = player
	self:addChild(self.player)
	self.player:setPosition(0, 0, self.depth/2 - 3600)

	-- Боковые стены
	self.walls = Sprite.new()
	local wallTexture = Assets:getTexture("assets/levels/" .. tostring(levelID) .."/wall.png")
	for i = 1, 4 do
		local wall = PlaneMesh.new(wallTexture, self.size, wallsColors[i])
		wall:setRotationX(90)
		wall:setRotationY(90 * (i - 1))
		self.walls:addChild(wall)
	end
	self.walls:setScaleZ(self.depth / self.size)
	self:addChild(self.walls)

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
	self.fallingSpeed = defaultFallingSpeed
end

function World:update(dt)
	for i, plane in ipairs(self.decorativePlanes) do
		if self:updatePlane(plane, dt) then
			plane:setPlaneTexture(self.decorativeTextures[math.random(1, #self.decorativeTextures)])
		end
	end

	for i, plane in ipairs(self.planes) do
		if self:updatePlane(plane, dt) then
			-- Обновление текстуры
			plane:setPlaneTexture(self.planeTextures[math.random(1, #self.planeTextures)])
		end
		if plane:getZ() > self.depth / 2 - 800 then
			local alpha = 1 - (plane:getZ() - self.depth / 2) / 800
			local r, g, b = plane:getColorTransform()
			plane:setColorTransform(r, g, b, alpha)
		end

		-- Проверка столкновений
		if self.player.isAlive then
			if plane:getZ() >= self.player:getZ() - self.fallingSpeed * dt  * 2 and plane:getZ() <= self.player:getZ() + self.fallingSpeed * dt  * 2 then
				if 	plane:hitTestPoint(self.player:getX(), self.player:getY() + self.player.size / 2.5) or
				 	plane:hitTestPoint(self.player:getX() + self.player.size / 3, self.player:getY() + self.player.size / 2.5) or
					plane:hitTestPoint(self.player:getX() + self.player.size / 3, self.player:getY() - self.player.size / 2.5) or
					plane:hitTestPoint(self.player:getX() - self.player.size / 3, self.player:getY() - self.player.size / 2.5)
				then
					--plane:setZ(self.player:getZ())
					self.player:die()
					self.fallingSpeed = 0
				end
			end
		end
	end
end

return World
