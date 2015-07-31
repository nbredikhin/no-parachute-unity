function math.clamp(val, lower, upper)
    assert(val and lower and upper, "math.clamp: number expected but got nil")
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end
