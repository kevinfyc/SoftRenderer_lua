
VertexIn = class()

function VertexIn:ctor(pos, color, tex, normal)
	self.pos = pos
	self.color = color
	self.tex = tex
	self.normal = normal
end

VertexOut = class()
function VertexOut:ctor(pos_world, pos_proj, tex, color, normal, oneDivZ)
	self.pos_world = pos_world
	self.pos_proj = pos_proj
	self.tex = tex
	self.normal = normal
	self.color = color
	self.oneDivZ = oneDivZ
end

function vertexout_lerp(v1, v2, t)
	return VertexOut.new(
		vector4_lerp(v1.pos_world, v2.pos_world, t),
		vector4_lerp(v1.pos_proj, v2.pos_proj, t),
		vector2_lerp(v1.tex, v2.tex, t),
		vector4_lerp(v1.normal, v2.normal, t),
		lerp(v1.pos_world, v2.pos_world, t),
		lerp(v1.pos_world, v2.pos_world, t)
	)
end


