local InputManager = Core.class(Sprite)

function InputManager:init()
	self.valueX, self.valueY = 0, 0
	self.maxTouchValue = 50
	self.startX, self.startY = 0, 0

	-- Ввод тачем
	self:addEventListener(Event.TOUCHES_BEGIN, self.touchBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.touchMove, self)
	self:addEventListener(Event.TOUCHES_END, self.touchEnd, self)
	self:addEventListener(Event.TOUCHES_CANCEL, self.touchEnd, self)
	-- Ввод с клавиатуры
	self:addEventListener(Event.KEY_DOWN, self.keyDown, self)
	self:addEventListener(Event.KEY_UP, self.keyUp, self)
end

function InputManager:touchBegin(e)
	self.startX = e.touch.x
	self.startY = e.touch.y
end

function InputManager:touchMove(e)
	self.valueX = math.clamp((e.touch.x - self.startX) / self.maxTouchValue, -1, 1)
	self.valueY = math.clamp((e.touch.y - self.startY) / self.maxTouchValue, -1, 1)
end

function InputManager:touchEnd(e)
	self.valueX = 0
	self.valueY = 0
end

function InputManager:keyDown(e)
	if e.keyCode == KeyCode.LEFT then
		self.valueX = -1
	elseif e.keyCode == KeyCode.RIGHT then
		self.valueX = 1
	end

	if e.keyCode == KeyCode.UP then
		self.valueY = -1
	elseif e.keyCode == KeyCode.DOWN then
		self.valueY = 1
	end
end


function InputManager:keyUp(e)
	if e.keyCode == KeyCode.LEFT and self.valueX < 0 then
		self.valueX = 0
	end
	if e.keyCode == KeyCode.RIGHT and self.valueX > 0 then
		self.valueX = 0
	end
	if e.keyCode == KeyCode.UP and self.valueY < 0 then
		self.valueY = 0
	end
	if e.keyCode == KeyCode.DOWN and self.valueY > 0 then
		self.valueY = 0
	end

end

return InputManager
