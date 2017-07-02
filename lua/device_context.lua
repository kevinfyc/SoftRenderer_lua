
DeviceContext = class()

function DeviceContext:ctor(device)
	self.device = device
	self.renderMode = RENDER_STATE_WIREFRAME

	self.vertex_buffer = {}
	self.index_buffer = {}

	self.shader = nil

	self.camera_pos = Vector4.new(0, 0, 0, 0)
end

function DeviceContext:setRenderMode(mode)
	self.renderMode = mode
end

function DeviceContext:setVertexBuffer(vertex_buffer)
	self.vertex_buffer = vertex_buffer
end

function DeviceContext:setIndexBuffer(index_buffer)
	self.index_buffer = index_buffer
end

function DeviceContext:setCameraPos(pos)
	self.camera_pos = pos
end

function DeviceContext:setShader(shader)
	self.shader = shader
end
 


function DeviceContext:transform2proj(vertex)
	local out = self.shader:vs(vertex)
	out.oneDivZ = 1 / out.pos_proj.w
	out.color = out.color * out.oneDivZ
	out.normal = vector4_scl(out.normal, out.oneDivZ)
	out.tex = vector2_scl(out.tex, out.oneDivZ)
	return out
end

function DeviceContext:Clip(v)
	print('DeviceContext Clip x '..v.pos_proj.x..' y '.. v.pos_proj.y..' z '..v.pos_proj.z..' w '..v.pos_proj.w)
	if v.pos_proj.x >= v.pos_proj.w and v.pos_proj.x <= v.pos_proj.w and
		v.pos_proj.y >= v.pos_proj.w and v.pos_proj.y < v.pos_proj.w and
		v.pos_proj.z >= 0 and v.pos_proj.z < v.pos_proj.w then
		print('return true')
		return true
	end

	print('return false')
	
	return false
end

function DeviceContext:CVV(v)
	v.pos_proj.x = v.pos_proj.x / w.pos_proj.w
	v.pos_proj.y = v.pos_proj.y / w.pos_proj.w
	v.pos_proj.z = v.pos_proj.z / w.pos_proj.w

	v.pos_proj.w = 1
	return v
end

function DeviceContext:transform2screen(mat, v)
	v.pos_proj = v.pos_proj * mat
	return v
end

function DeviceContext:backFaceCulling(p1, p2, p3)
	if self.renderMode == RENDER_STATE_WIREFRAME then
		return true
	end

	local vec1 = vector4_sub(p2.pos, p1.pos)
	local vec2 = vector4_sub(p3.pos, p2.pos)

	local normal = vec1:cross(vec2)

	local viewDir = vector4_sub(p1.pos, self.camera_pos)

	if normal:dot(viewDir) < 0 then
		return true
	end

	return false
end

function DeviceContext:drawPrimitive(p1, p2, p3)
	local screen_mat = screen_transform(self.device.width, self.device.height)

	if not self:backFaceCulling(p1, p2, p3) then
		return
	end

	local v1 = self:transform2proj(p1)
	local v2 = self:transform2proj(p2)
	local v3 = self:transform2proj(p3)

	if not self:Clip(v1) or not self:Clip(v2) or not self:Clip(v3) then
		return
	end

	print("################## ")

	v1 = self:CVV(v1)
	v2 = self:CVV(v2)
	v3 = self:CVV(v3)

	v1 = self:transform2screen(screen_mat, v1)
	v2 = self:transform2screen(screen_mat, v2)
	v3 = self:transform2screen(screen_mat, v3)

	self.device:draw_triangle_out(v1, v2, v3)
end
