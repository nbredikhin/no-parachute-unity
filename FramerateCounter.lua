local FramerateCounter = Core.class(Sprite)

function FramerateCounter:init(refreshRate)
	if not refreshRate then
		refreshRate = 0.5
	end
	assert(type(refreshRate) == "number", "refreshRate: number expected, but got \"" .. type(refreshRate) .. "\".")

	self.text = "FPS: "

	self.textField = TextField.new(nil, self.text .. "0")
	self.textField:setX(5)
	self.textField:setY(10)
	self.textField:setTextColor(0xFFFFFF)
	self:addChild(self.textField)

	self.delayMax = refreshRate
	self.delayCurrent = 0 
end

function FramerateCounter:update(dt)
	self.delayCurrent = self.delayCurrent + dt 
	if self.delayCurrent >= self.delayMax then
		self.delayCurrent = 0
		-- Обновление счётчика
		local currentFPS = math.floor(1/dt)
		self.textField:setText(self.text .. currentFPS)
	end
end

return FramerateCounter