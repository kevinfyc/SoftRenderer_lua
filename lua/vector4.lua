
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

function Vector4:normalize()
	local l = self:length()
	if l ~= 0.0 then
		local inv = 1 / l
		self.x = self.x * inv
		self.y = self.y * inv
		self.z = self.z * inv

		return self
	end
end

function vector4_add(p1, p2)
	return Vector4.new(p1.x+p2.x, p1.y+p2.y, p1.z+p2.z, p1.w+p2.w)
end

function vector4_sub(p1, p2)
	return Vector4.new(p1.x-p2.x, p1.y-p2.y, p1.z-p2.z, p1.w-p2.w)
end

function vector4_mul(p1, p2)
	local p = Vector4.new(p1.x*p2.x, p1.y*p2.y, p1.z*p2.z, p1.w*p2.w)
	return p
end

function vector4_scl(p1, p)
	local p = Vector4.new(p1.x*p, p1.y*p, p1.z*p, p1.w*p)
	return p
end

function vector4_apply(p, mat)
	return Vector4.new(
		p.x * mat.m11 + p.y * mat.m21 + p.z * mat.m31 + p.w * mat.m41,
		p.x * mat.m12 + p.y * mat.m22 + p.z * mat.m32 + p.w * mat.m42,
		p.x * mat.m13 + p.y * mat.m23 + p.z * mat.m33 + p.w * mat.m43,
		p.x * mat.m14 + p.y * mat.m24 + p.z * mat.m34 + p.w * mat.m44
	)
end

function vector4_lerp(v1, v2, t)
	return Vector4.new( 
		lerp(v1.x, v2.x, t),
		lerp(v1.y, v2.y, t),
		lerp(v1.z, v2.z, t),
		lerp(v1.w, v2.w, t) 
	)
end
