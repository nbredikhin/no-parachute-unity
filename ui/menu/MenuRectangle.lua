local MenuRectangle = Core.class(Shape)

function MenuRectangle:init()
	self:clear()
	self:setFillStyle(Shape.SOLID, 0xFFFFFF, 1)
	self:drawRect(0, 0, 1, 1)

	self:changeColor()
end

function MenuRectangle:changeColor()
	self:setColorTransform(math.random(), math.random(), math.random(), 1)
end

function MenuRectangle:drawRect(x, y, w, h)
	self:moveTo(x, y)
	self:lineTo(x + w, y)
	self:lineTo(x + w, y + h)
	self:lineTo(x, y + h)
	self:lineTo(x, y)
	self:endPath()
end

return MenuRectangle