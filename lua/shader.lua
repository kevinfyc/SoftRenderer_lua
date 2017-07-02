CubeShader = class()

function CubeShader:ctor()
	self.wvp = Matrix.new()
	self.wvp:identity()

	self.world = Matrix.new()
	self.world:identity()

	self.worldInvTranspose = Matrix.new()
	self.worldInvTranspose:identity()

	self.texture = nil
end

function CubeShader:setWVP(mat)
	self.wvp = mat
end

function CubeShader:setTexture(texture)
	self.texture = texture
end

function CubeShader:setWorld(world)
	self.world = world
end

function CubeShader:setWorldInvTranspose(mat)
	self.worldInvTranspose = mat
end

function CubeShader:vs(v)
	print('CubeShader:vs v.pos ')
	print_r(v.pos)
	local pos_world = vector4_apply(v.pos, self.world)
	print('CubeShader:vs pos_world')
	print_r(pos_world)
	local pos_proj = vector4_apply(v.pos, self.wvp)
	print('CubeShader:vs pos_proj')
	print_r(pos_proj)

	local out = VertexOut.new(
		pos_world,
		pos_proj,
		v.tex,
		v.color,
		v.normal,
		1
	)

	return out
end

function CubeShader:ps(v)
	return v.color
end

