
Cube = class()



function Cube:ctor()
	self.world = Matrix.new()
	self.world:identity()

	self.worldViewProj = Matrix.new()
	self.worldViewProj:identity()

	self.worldInvTranspose = Matrix.new()
	self.worldInvTranspose:identity()

	self.device = Device.new(win_width, win_height)
	self.device_context = DeviceContext.new(self.device)

	self.mesh = {
		VertexIn.new( Vector4.new( 1, -1,  1, 1 ), color_rgba2hex( 1.0, 0.2, 0.2, 1.0 ), Vector2.new( 0, 0 ), Vector4.new( 0,  1, 0, 0  ) ),
		VertexIn.new( Vector4.new(-1, -1,  1, 1 ), color_rgba2hex( 0.2, 1.0, 0.2, 1.0 ), Vector2.new( 0, 0 ), Vector4.new( 0,  1, 0, 0  ) ),
		VertexIn.new( Vector4.new(-1,  1,  1, 1 ), color_rgba2hex( 0.2, 0.2, 1.0, 1.0 ), Vector2.new( 1, 1 ), Vector4.new( 0,  1, 0, 0  ) ),
		VertexIn.new( Vector4.new( 1,  1,  1, 1 ), color_rgba2hex( 1.0, 0.2, 1.0, 1.0 ), Vector2.new( 1, 0 ), Vector4.new( 0,  1, 0, 0  ) ),
		VertexIn.new( Vector4.new( 1, -1, -1, 1 ), color_rgba2hex( 1.0, 1.0, 0.2, 1.0 ), Vector2.new( 0, 0 ), Vector4.new( 0, -1, 0, 0  ) ),
		VertexIn.new( Vector4.new(-1, -1, -1, 1 ), color_rgba2hex( 0.2, 1.0, 1.0, 1.0 ), Vector2.new( 0, 1 ), Vector4.new( 0, -1, 0, 0  ) ),
		VertexIn.new( Vector4.new(-1,  1, -1, 1 ), color_rgba2hex( 1.0, 0.3, 0.3, 1.0 ), Vector2.new( 1, 1 ), Vector4.new( 0, -1, 0, 0  ) ),
		VertexIn.new( Vector4.new( 1,  1, -1, 1 ), color_rgba2hex( 0.2, 1.0, 0.3, 1.0 ), Vector2.new( 1, 0 ), Vector4.new( 0, -1, 0, 0  ) )
	}

	self.shader = CubeShader.new()

	self.device_context:setShader(self.shader)
end

function Cube:tick(dt)
	local pos = Vector4.new(0, 1.54508531, -4.75528240, 1)
	local target = Vector4.new(0, 0, 0, 1)
	local up = Vector4.new(0, 1, 0, 0)

	local view = matrix_look_at_lh(pos, target, up)
	local proj = matrix_perspective_fov_lh(HALF_PI, self.device.width / self.device.height, 1, 100)

	self.worldViewProj = matrix_mul(matrix_mul(self.world, view), proj)

	local tmp = self.world
	tmp:inverse()
	tmp:transpose()

	self.worldInvTranspose = tmp

	self.shader:setWVP(self.worldViewProj)
	self.shader:setWVP(self.world)
	self.shader:setWorldInvTranspose(self.worldInvTranspose)

	self.device_context:setShader(self.shader)

	self.device_context:setCameraPos(pos)

end

function Cube:drawPlane(a, b, c, d)
	local p1 = self.mesh[a + 1]
	local p2 = self.mesh[b + 1]
	local p3 = self.mesh[c + 1]
	local p4 = self.mesh[d + 1]

	p1.tex.x = 0
	p1.tex.y = 0
	p2.tex.x = 0
	p2.tex.y = 1
	p3.tex.x = 1
	p3.tex.y = 1
	p4.tex.x = 1
	p4.tex.y = 0

	self.device_context:drawPrimitive(p1, p2, p3)
	self.device_context:drawPrimitive(p3, p4, p1)
end

function Cube:draw()
	self.device:clear(COLOR_GRAY)
	self.device_context:setRenderMode(RENDER_STATE_WIREFRAME)

	self:drawPlane(0, 1, 2, 3)
	self:drawPlane(4, 5, 6, 7)
	self:drawPlane(0, 4, 5, 1)
	self:drawPlane(1, 5, 6, 2)
	self:drawPlane(2, 6, 7, 3)
	self:drawPlane(3, 7, 4, 0)
end

