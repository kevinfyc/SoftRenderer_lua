
Vector2 = class()

function Vector2:ctor(x, y)
	self.x = x
	self.y = y
end

function vector2_mul(p1, p2)
	local p = Vector2.new(p1.x*p2.x, p1.y*p2.y)
	return p
end

function vector2_scl(p1, p)
	local p = Vector2.new(p1.x*p, p1.y*p)
	return p
end

function vector2_lerp(v1, v2, t)
	return Vector2.new( lerp(v1.x, v2.x, t), lerp(v1.y, v2.y, t) )
end
