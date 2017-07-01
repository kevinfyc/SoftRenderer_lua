
Vector4 = class()

function Vector4:ctor(x, y, z, w)
	self.x = x
	self.y = y
	self.z = z
	self.w = w
end

function Vector4:length()
	local sq = self.x * self.x + self.y * self.y + self.z * self.z
	return math.sqrt(sq)
end

function Vector4:dot(v)
	return self.x * v.x + self.y * v.y + self.z * v.z
end

function Vector4:cross(v)
	local m1 = self.y * v.z - self.z * v.y
	local m2 = self.z * v.x - self.x * v.z
	local m3 = self.x * v.y - self.y * v.x
	return Vector4.new(m1, m2, m3, 0)
end

function vector4_mul(p1, p2)
	local p = Vector4.new(p1.x*p2.x, p1.y*p2.y, p1.z*p2.z, p1.w*p2.w)
	return p
end

function vector4_lerp(v1, v2, t)
	return Vector4.new( 
		lerp(v1.x, v2.x, t),
		lerp(v1.y, v2.y, t),
		lerp(v1.z, v2.z, t),
		lerp(v1.w, v2.w, t) 
	)
end
