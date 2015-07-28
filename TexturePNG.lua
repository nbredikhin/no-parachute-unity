-- TexturePNG
-- Позволяет получить цвет пикселя текстуры (TexturePNG:getPixel)

require "lib/png"
local TexturePNG = Core.class(Texture)

function TexturePNG:init(path, ...)
	self.pngData = pngImage(path)
	self.width = self:getWidth()
	self.height = self:getHeight()
end

function TexturePNG:getPixel(x, y)
	return self.pngData:getPixel(x, y)
end

function TexturePNG:getPixelAlpha(x, y)
	if x < 1 or x > self.width 	then return 0 end
	if y < 1 or y > self.height then return 0 end
	local pixel = self.pngData:getPixel(x, y)
	if not pixel then 
		return 0
	end
	return pixel.A
end

return TexturePNG