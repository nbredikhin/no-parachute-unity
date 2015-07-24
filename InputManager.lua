local InputManager = Core.class(Sprite)

function InputManager:init()
	self.valueX, self.valueY = 0, 0
	self.maxValue = 50
	self.startX, self.startY = 0, 0
	self:addEventListener(Event.TOUCHES_BEGIN, self.touchBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.touchMove, self)
	self:addEventListener(Event.TOUCHES_END, self.touchEnd, self)
	self:addEventListener(Event.TOUCHES_CANCEL, self.touchEnd, self)
end

function InputManager:touchBegin(e)
	self.startX = e.touch.x
	self.startY = e.touch.y
end

function InputManager:touchMove(e)
	self.valueX = math.clamp((e.touch.x - self.startX) / self.maxValue, -1, 1)
	self.valueY = math.clamp((e.touch.y - self.startY) / self.maxValue, -1, 1)
end

function InputManager:touchEnd(e)
	self.valueX = 0
	self.valueY = 0
end

return InputManager