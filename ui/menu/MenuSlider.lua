local MenuSlider = Core.class(Sprite)

function MenuSlider:init(width, height)
	local background = Shape.new()
	background:setLineStyle(2, 0xFFFFFF, 0.2)
	background:setFillStyle(Shape.SOLID, 0, 0.5)
	background:beginPath()
	background:moveTo(0, 0)
	background:lineTo(width, 0)
	background:lineTo(width, height)
	background:lineTo(0, height)
	background:lineTo(0, 0)
	background:endPath()
	self:addChild(background)

	self.space = height * 0.2
	local sliderSize = height - self.space

	self.minPos = self.space / 2 + 1
	self.maxPos = width - sliderSize - self.minPos + 1
	self.slider = Shape.new()
	self.slider:setFillStyle(Shape.SOLID, 0xFFFFFF, 1)
	self.slider:beginPath()
	self.slider:moveTo(0, 0)
	self.slider:lineTo(sliderSize, 0)
	self.slider:lineTo(sliderSize, sliderSize)
	self.slider:lineTo(0, sliderSize)
	self.slider:lineTo(0, 0)
	self.slider:endPath()
	self.slider:setPosition(self.minPos, self.space / 2 + 1)
	self:addChild(self.slider)

	self:addEventListener(Event.TOUCHES_MOVE, self.touchUpdate, self)
	self:addEventListener(Event.TOUCHES_BEGIN, self.touchBegin, self)
	self:addEventListener(Event.TOUCHES_END, self.touchEnd, self)
	self:addEventListener(Event.ENTER_FRAME, self.update, self)

	self.targetX = self.minPos
	self:setScale(math.min(1, utils.screenHeight / 450))

	self.isTouching = false
end

function MenuSlider:updatePosition(x, y)
	local newX = x - self:getX() - self.slider:getWidth() / 2
	newX = math.max(self.minPos, newX)
	newX = math.min(self.maxPos, newX)
	self.targetX = newX
end

function MenuSlider:touchBegin(e)
	if not self:hitTestPoint(e.touch.x, e.touch.y) then
		return
	end
	self.isTouching = true
	self:updatePosition(e.touch.x, e.touch.y)
end

function MenuSlider:touchUpdate(e)
	if not self.isTouching then
		return
	end
	self:updatePosition(e.touch.x, e.touch.y)
end

function MenuSlider:touchEnd(e)
	if not self.isTouching then
		return
	end
	self.isTouching = false
end

function MenuSlider:getValue()
	return math.floor((self.targetX - self.minPos) / (self.maxPos - self.minPos) * 100) / 100
end

function MenuSlider:setValue(value)
	local newX = self.maxPos * value
	newX = math.max(self.minPos, newX)
	newX = math.min(self.maxPos, newX)
	self.targetX = newX
	self.slider:setX(self.targetX)
end

function MenuSlider:update(e)
	self.slider:setX(self.slider:getX() + (self.targetX - self.slider:getX()) * 0.3)
end

return MenuSlider