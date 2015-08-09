function math.clamp(val, lower, upper)
    assert(val and lower and upper, "math.clamp: number expected but got nil")
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

function math.rotateVector(vx, vy, angle)
	local radians = angle / 180 * math.pi
	local ca = math.cos(radians)
	local sa = math.sin(radians)
	return ca * vx - sa * vy, sa * vx + ca * vy
end