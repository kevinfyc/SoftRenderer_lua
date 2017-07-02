
Matrix = class()

function Matrix:ctor(m11,m12,m13,m14,
					m21,m22,m23,m24,
					m31,m32,m33,m34,
					m41,m42,m43,m44)
	self.m = {
		{m11,m12,m13,m14},
		{m21,m22,m23,m24}, 
		{m31,m32,m33,m34},
		{m41,m42,m43,m44}
	}

	self.m11 = m11 self.m12 = m12 self.m13 = m13 self.m14 = m14
	self.m21 = m21 self.m22 = m22 self.m23 = m23 self.m24 = m24
	self.m31 = m31 self.m32 = m32 self.m33 = m33 self.m34 = m34
	self.m41 = m41 self.m42 = m42 self.m43 = m43 self.m44 = m44
end

function Matrix:identity()
	self.m11, self.m12, self.m13, self.m14 = 1, 0, 0, 0
	self.m21, self.m22, self.m23, self.m24 = 0, 1, 0, 0
	self.m31, self.m32, self.m33, self.m34 = 0, 0, 1, 0
	self.m41, self.m42, self.m43, self.m44 = 0, 0, 0, 1
end

function Matrix:transpose()
	return Matrix.new(
		self.m11, self.m21, self.m31, self.m41,
		self.m12, self.m22, self.m32, self.m42,
		self.m13, self.m23, self.m33, self.m43,
		self.m14, self.m24, self.m34, self.m44
	)
end

function Matrix:det()
	local ret = 0

	ret = ret + self.m11 * (self.m22 * self.m33 - self.m23 * self.m32)
	ret = ret - self.m12 * (self.m21 * self.m33 - self.m23 * self.m31)
	ret = ret + self.m13 * (self.m21 * self.m32 - self.m22 * self.m31)

	return ret
end

function Matrix:inverse()
	local matrix = Matrix.new(
			self.m11, self.m12, self.m13, self.m14,
			self.m21, self.m22, self.m23, self.m24,
			self.m31, self.m32, self.m33, self.m34,
			self.m41, self.m42, self.m43, self.m44
	)

	local determinant = matrix:det()

	if determinant == 0 then
		return false
	end

	local rcp = 1 / determinant
	self.m11 = matrix.m22 * matrix.m33 - matrix.m23 * matrix.m32
	self.m12 = matrix.m13 * matrix.m32 - matrix.m12 * matrix.m33
	self.m13 = matrix.m12 * matrix.m23 - matrix.m13 * matrix.m22
	self.m21 = matrix.m23 * matrix.m31 - matrix.m21 * matrix.m33
	self.m22 = matrix.m11 * matrix.m33 - matrix.m13 * matrix.m31
	self.m23 = matrix.m13 * matrix.m21 - matrix.m11 * matrix.m23
	self.m31 = matrix.m21 * matrix.m32 - matrix.m22 * matrix.m31
	self.m32 = matrix.m12 * matrix.m31 - matrix.m11 * matrix.m32
	self.m33 = matrix.m11 * matrix.m22 - matrix.m12 * matrix.m21

	self.m11 = self.m11 * rcp
	self.m12 = self.m12 * rcp
	self.m13 = self.m13 * rcp

	self.m21 = self.m21 * rcp
	self.m22 = self.m22 * rcp
	self.m23 = self.m23 * rcp

	self.m31 = self.m31 * rcp
	self.m32 = self.m32 * rcp
	self.m33 = self.m33 * rcp

	self.m41 = -(matrix.m41 * self.m11 + matrix.m42 * self.m21 + matrix.m43 * self.m31)
	self.m42 = -(matrix.m41 * self.m12 + matrix.m42 * self.m22 + matrix.m43 * self.m32)
	self.m43 = -(matrix.m41 * self.m13 + matrix.m42 * self.m23 + matrix.m43 * self.m33)

	if determinant == 0 then
		self:identity()
	end

	return true
end


function matrix_add(v1, v2)
	return Matrix.new(
				v1.m11 + v2.m11, v1.m12 + v2.m12, v1.m13 + v2.m13, v1.m14 + v2.m14,
				v1.m21 + v2.m21, v1.m22 + v2.m22, v1.m23 + v2.m23, v1.m24 + v2.m24,
				v1.m31 + v2.m31, v1.m32 + v2.m32, v1.m33 + v2.m33, v1.m34 + v2.m34,
				v1.m41 + v2.m41, v1.m42 + v2.m42, v1.m43 + v2.m43, v1.m44 + v2.m44
				)
end

function matrix_sub(v1, v2)
	return Matrix.new(
				v1.m11 - v2.m11, v1.m12 - v2.m12, v1.m13 - v2.m13, v1.m14 - v2.m14,
				v1.m21 - v2.m21, v1.m22 - v2.m22, v1.m23 - v2.m23, v1.m24 - v2.m24,
				v1.m31 - v2.m31, v1.m32 - v2.m32, v1.m33 - v2.m33, v1.m34 - v2.m34,
				v1.m41 - v2.m41, v1.m42 - v2.m42, v1.m43 - v2.m43, v1.m44 - v2.m44
				)
end

function matrix_mul(v1, v2)
	return Matrix.new(
				v1.m11 * v2.m11 + v1.m12 * v2.m21 + v1.m13 * v2.m31 + v1.m14 * v2.m41,
				v1.m11 * v2.m12 + v1.m12 * v2.m22 + v1.m13 * v2.m33 + v1.m14 * v2.m42,
				v1.m11 * v2.m13 + v1.m12 * v2.m23 + v1.m13 * v2.m33 + v1.m14 * v2.m43,
				v1.m11 * v2.m14 + v1.m12 * v2.m24 + v1.m13 * v2.m34 + v1.m14 * v2.m44,

				v1.m21 * v2.m11 + v1.m22 * v2.m21 + v1.m23 * v2.m31 + v1.m24 * v2.m41,
				v1.m21 * v2.m12 + v1.m22 * v2.m22 + v1.m23 * v2.m33 + v1.m24 * v2.m42,
				v1.m21 * v2.m13 + v1.m22 * v2.m23 + v1.m23 * v2.m33 + v1.m24 * v2.m43,
				v1.m21 * v2.m14 + v1.m22 * v2.m24 + v1.m23 * v2.m34 + v1.m24 * v2.m44,
				
				v1.m31 * v2.m11 + v1.m32 * v2.m21 + v1.m33 * v2.m31 + v1.m34 * v2.m41,
				v1.m31 * v2.m12 + v1.m32 * v2.m22 + v1.m33 * v2.m33 + v1.m34 * v2.m42,
				v1.m31 * v2.m13 + v1.m32 * v2.m23 + v1.m33 * v2.m33 + v1.m34 * v2.m43,
				v1.m31 * v2.m14 + v1.m32 * v2.m24 + v1.m33 * v2.m34 + v1.m34 * v2.m44,
				
				v1.m41 * v2.m11 + v1.m42 * v2.m21 + v1.m43 * v2.m31 + v1.m44 * v2.m41,
				v1.m41 * v2.m12 + v1.m42 * v2.m22 + v1.m43 * v2.m33 + v1.m44 * v2.m42,
				v1.m41 * v2.m13 + v1.m42 * v2.m23 + v1.m43 * v2.m33 + v1.m44 * v2.m43,
				v1.m41 * v2.m14 + v1.m42 * v2.m24 + v1.m43 * v2.m34 + v1.m44 * v2.m44
				)
end


function matrix_look_at_lh(eyePos, lookAt, up)
	local zaxis = vector4_sub(lookAt, eyePos)
	zaxis:normalize()

	local xaxis = up:cross(zaxis):normalize()

	local yaxis = zaxis:cross(xaxis)

	return Matrix.new(
				xaxis.x, yaxis.x, zaxis.x, 0,
				xaxis.y, yaxis.y, zaxis.y, 0,
				xaxis.z, yaxis.z, zaxis.z, 0,
				-xaxis:dot(eyePos), -yaxis:dot(eyePos), -zaxis:dot(eyePos), 1
				)
end

function matrix_perspective_fov_lh(fov, aspect, near, far)
	local height = math.cos(fov*0.5) / math.sin(fov*0.5)

	local mat = Matrix.new(
				height / aspect, 0, 0, 0,
				0, height, 0, 0,
				0, 0, far / (far - near), 1,
				0, 0,  near * far / (near - far), 0
				)
	return mat
end

function matrix_transpose()
	return Matrix.new(
			self.m11, self.m21, self.m31, self.m41,
			self.m12, self.m22, self.m32, self.m42,
			self.m13, self.m23, self.m33, self.m43,
			self.m14, self.m24, self.m34, self.m44
	)
end

function screen_transform(width, height)
	return Matrix.new(
				width * 0.5, 0, 0, 0,
				0, height * 0.5, 0, 0,
				0, 0, 1, 0,
				width * 0.5, height * 0.5, 0, 1
				)
end

