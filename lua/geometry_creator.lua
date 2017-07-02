
MeshData = class()
function MeshData:ctor()
	self.vertices = {}
	self.indices = {}
end


function create_cube(width, height, depth)
	local mesh = MeshData.new()

	local halfW = width * 0.5
	local halfH = height * 0.5
	local halfD = height * 0.5

	-- front
	local v0 = VertexIn.new(
		Vector4.new(-halfW, -halfH, -halfD, 1.0),
		color_rgba2hex(1.0, 0.0, 0.0, 1.0),
		Vector2.new(0.0, 1.0),
		Vector4.new(0.0, 0.0, -1.0)
	)
	local v1 = VertexIn.new(
		Vector4.new(-halfW, halfH, -halfD,1.0),
		color_rgba2hex(0.0, 0.0, 0.0, 1.0),
		Vector2.new(0.0, 0.0),
		Vector4.new(0.0, 0.0, -1.0)
	)
	local v2 = VertexIn.new(
		Vector4.new(halfW, halfH, -halfD, 1.0),
		color_rgba2hex(1.0, 0.0, 0.0, 1.0),
		Vector2.new(1.0, 0.0),
		Vector4.new(0.0, 0.0, -1.0)
	)
	local v3 = VertexIn.new(
		Vector4.new(halfW, -halfH, -halfD, 1.0),
		color_rgba2hex(0.0, 1.0, 0.0, 1.0),
		Vector2.new(1.0, 1.0),
		Vector4.new(0.0, 0.0, -1.0)
	)
	
	-- left
	local v4 = VertexIn.new(
		Vector4.new(-halfW, -halfH, halfD, 1.0),
		color_rgba2hex(0.0, 0.0, 1.0, 1.0),
		Vector2.new(0.0, 1.0),
		Vector4.new(-1.0, 0.0, 0.0)
	)
	local v5 = VertexIn.new(
		Vector4.new(-halfW, halfH, halfD, 1.0),
		color_rgba2hex(1.0, 1.0, 0.0, 1.0),
		Vector2.new(0.0, 0.0),
		Vector4.new(-1.0, 0.0, 0.0)
	)
	local v6 = VertexIn.new(
		Vector4.new(-halfW, halfH, -halfD, 1.0),
		color_rgba2hex(0.0, 0.0, 0.0, 1.0),
		Vector2.new(1.0, 0.0),
		Vector4.new(-1.0, 0.0, 0.0)
	)
	local v7 = VertexIn.new(
		Vector4.new(-halfW, -halfH, -halfD, 1.0),
		color_rgba2hex(1.0, 1.0, 1.0, 1.0),
		Vector2.new(1.0, 1.0),
		Vector4.new(-1.0, 0.0, 0.0)
	)
	
	-- back
	local v8 = VertexIn.new(
		Vector4.new(halfW, -halfH, halfD, 1.0),
		color_rgba2hex(1.0, 0.0, 1.0, 1.0),
		Vector2.new(0.0, 1.0),
		Vector4.new(0.0, 0.0, 1.0)
	)
	local v9 = VertexIn.new(
		Vector4.new(halfW, halfH, halfD, 1.0),
		color_rgba2hex(0.0, 1.0, 1.0, 1.0),
		Vector2.new(0.0, 0.0),
		Vector4.new(0.0, 0.0, 1.0)
	)
	local v10 = VertexIn.new(
		Vector4.new(-halfW, halfH, halfD, 1.0),
		color_rgba2hex(1.0, 1.0, 0.0, 1.0),
		Vector2.new(1.0, 0.0),
		Vector4.new(0.0, 0.0, 1.0)
	)
	local v11 = VertexIn.new(
		Vector4.new(-halfW, -halfH, halfD, 1.0),
		color_rgba2hex(0.0, 0.0, 1.0, 1.0),
		Vector2.new(1.0, 1.0),
		Vector4.new(0.0, 0.0, 1.0)
	)
	
	-- right
	local v12 = VertexIn.new(
		Vector4.new(halfW, -halfH, -halfD, 1.0),
		color_rgba2hex(0.0, 1.0, 0.0, 1.0),
		Vector2.new(0.0, 1.0),
		Vector4.new(1.0, 0.0, 0.0)
	)
	local v13 = VertexIn.new(
		Vector4.new(halfW, halfH, -halfD, 1.0),
		color_rgba2hex(1.0, 0.0, 0.0, 1.0),
		Vector2.new(0.0, 0.0),
		Vector4.new(1.0, 0.0, 0.0)
	)
	local v14 = VertexIn.new(
		Vector4.new(halfW, halfH, halfD, 1.0),
		color_rgba2hex(0.0, 1.0, 1.0, 1.0),
		Vector2.new(1.0, 0.0),
		Vector4.new(1.0, 0.0, 0.0)
	)
	local v15 = VertexIn.new(
		Vector4.new(halfW, -halfH, halfD, 1.0),
		color_rgba2hex(1.0, 0.0, 1.0, 1.0),
		Vector2.new(1.0, 1.0),
		Vector4.new(1.0, 0.0, 0.0)
	)
	
	-- top
	local v16 = VertexIn.new(
		Vector4.new(-halfW, halfH, -halfD, 1.0),
		color_rgba2hex(0.0, 0.0, 0.0, 1.0),
		Vector2.new(0.0, 1.0),
		Vector4.new(0.0, 1.0, 0.0)
	)
	local v17 = VertexIn.new(
		Vector4.new(-halfW, halfH, halfD, 1.0),
		color_rgba2hex(1.0, 1.0, 0.0, 1.0),
		Vector2.new(0.0, 0.0),
		Vector4.new(0.0, 1.0, 0.0)
	)
	local v18 = VertexIn.new(
		Vector4.new(halfW, halfH, halfD, 1.0),
		color_rgba2hex(0.0, 1.0, 1.0, 1.0),
		Vector2.new(1.0, 0.0),
		Vector4.new(0.0, 1.0, 0.0)
	)
	local v19 = VertexIn.new(
		Vector4.new(halfW, halfH, -halfD, 1.0),
		color_rgba2hex(1.0, 0.0, 0.0, 1.0),
		Vector2.new(1.0, 1.0),
		Vector4.new(0.0, 1.0, 0.0)
	)
	
	-- bottom
	local v20 = VertexIn.new(
		Vector4.new(-halfW, -halfH, halfD, 1.0),
		color_rgba2hex(0.0, 0.0, 1.0, 1.0),
		Vector2.new(0.0, 1.0)),
		Vector4.new(0.0, -1.0, 0.0)
	local v21 = VertexIn.new(
		Vector4.new(-halfW, -halfH, -halfD, 1.0),
		color_rgba2hex(1.0, 1.0, 1.0, 1.0),
		Vector2.new(0.0, 0.0),
		Vector4.new(0.0, -1.0, 0.0)
	)
	local v22 = VertexIn.new(
		Vector4.new(halfW, -halfH, -halfD, 1.0),
		color_rgba2hex(0.0, 1.0, 0.0, 1.0),
		Vector2.new(1.0, 0.0),
		Vector4.new(0.0, -1.0, 0.0)
	)
	local v23 = VertexIn.new(
		Vector4.new(halfW, -halfH, halfD, 1.0),
		color_rgba2hex(1.0, 0.0, 1.0, 1.0),
		Vector2.new(1.0, 1.0),
		Vector4.new(0.0, -1.0, 0.0)
	)

	mesh.vertices = {
			v0,  v1,  v2,  v3,
			v4,  v5,  v6,  v7,
			v8,  v9,  v10, v11,
			v12, v13, v14, v15,
			v16, v17, v18, v19,
			v20, v21, v22, v23,
		}

	-- index
	mesh.indices = {
			 0,  1,  2,  0,  2,  3,
			 4,  5,  6,  4,  6,  7,
			 8,  9, 10,  8, 10, 11,
			12, 13, 14, 12, 14, 15,
			16, 17, 18, 16, 18, 19,
			20, 21, 22, 20, 22, 23,
		}

	return mesh
end
