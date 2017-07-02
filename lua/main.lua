
require('config')
require('color')
require('util')
require('class')
require('math')
require('matrix')
require('vector4')
require('vector2')

require('vertex')
require('geometry_creator')

require('shader')

require('device')
require('device_context')

require('cube')

PI 			= 3.1415926535
HALF_PI 	= 1.5707963268
HALF_SQRT	= 0.7853981634

function lerp(v1, v2, t)
	return v1 + (v2 - v1) * t
end

local cube = Cube.new()

local tt = 0
local nt = 0

function tick()
	tt = os.time()

	cube:tick(nt)
	cube:draw()
	
	local dtime = os.time() - tt
	--print('dtime is '..dtime)
end
