-- TexturePNG
-- Позволяет получить цвет пикселя текстуры (TexturePNG:getPixel)
local TexturePNG = Core.class(Texture)

function TexturePNG:init(path, ...)
	self.width = self:getWidth()
	self.height = self:getHeight()

	self.pixels = self:getPixels(path .. ".msk")
end

function TexturePNG:getPixels(path)
	local file = io.open(path, "rb")
	assert(file, "Отсутствует файл маски: " .. tostring(path))

	-- Массив пикселей
	local pixels = {}
	for i = 1, self.width do 
		pixels[i] = {} 
		for j = 1, self.height do
			pixels[i][j] = 0
		end
	end

	-- Чтение файла
	local tx, ty = 1, 1
	while true do
		local pixel = tonumber(file:read(1))
		pixels[tx][ty] = pixel
		tx = tx + 1
		if tx > self.width then
			ty = ty + 1
			tx = 1
		end
		if ty > self.height then
			break
		end
	end
	file:close()
	return pixels
end

function TexturePNG:getPixelAlpha(x, y)
	if x < 1 or x > self.width 	then return 0 end
	if y < 1 or y > self.height then return 0 end
	local pixel = self.pixels[x][y]
	if not pixel then 
		return 0
	end
	return pixel
end

return TexturePNG