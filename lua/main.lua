
require('config')
require('color')
require('util')
require('class')
require('math')
require('vector4')
require('vector2')

require('vertex')
require('geometry_creator')

require('device')

PI 			= 3.1415926535
HALF_PI 	= 1.5707963268
HALF_SQRT	= 0.7853981634

function lerp(v1, v2, t)
	return v1 + (v2 - v1) * t
end

device = Device.new(win_width, win_height)

local cube = create_cube(100, 100)
print(cube)
print_r(cube.vertices)

function tick()
	local tt = os.time()
	
	device:clear(COLOR_GRAY)

	device:drawTriangle(Vector2.new(400,100), Vector2.new(300,200), Vector2.new(500,200), COLOR_RED)

	local dtime = os.time() - tt
	--print('dtime is '..dtime)
end
