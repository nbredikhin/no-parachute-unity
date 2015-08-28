local InputManager = Core.class(Sprite)
InputManager.TOUCH_BEGIN = "InputTouchBegin"
InputManager.TOUCH_END = "InputTouchEnd"

function InputManager:init()
	self.valueX, self.valueY = 0, 0
	self.maxTouchValue = 70
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
	local touch = e.allTouches[1]
	self.startX = touch.x
	self.startY = touch.y

	local touchBeginEvent = Event.new(InputManager.TOUCH_BEGIN)
	touchBeginEvent.x = touch.x
	touchBeginEvent.y = touch.y
	self:dispatchEvent(touchBeginEvent)
end

function InputManager:touchMove(e)
	local touch = e.allTouches[1]
	local x, y = touch.x - self.startX, touch.y - self.startY
	local sensitivity = (SettingsManager.settings.input_sensitivity + 0.5)
	x = x * sensitivity
	y = y * sensitivity
	local maxLen = self.maxTouchValue
	local len = math.sqrt((x*x)+(y*y))
	if len > maxLen then
		x = x / len * maxLen
		y = y / len * maxLen
	end

	self.valueX = math.clamp(x / self.maxTouchValue, -1, 1)
	self.valueY = math.clamp(y / self.maxTouchValue, -1, 1)
end

function InputManager:touchEnd(e)
	self.valueX = 0
	self.valueY = 0

	self:dispatchEvent(Event.new(InputManager.TOUCH_END))
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
