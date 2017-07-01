
require('config')
require('color')
require('util')
require('class')
require('math')
require('vector4')

require('device')


device = Device.new(win_width, win_height)

function tick()
	local tt = os.time()
	
	device:clear(COLOR_GRAY)

	device:drawTriangle(Vector4.new(400,100,0,1), Vector4.new(300,200,0,1), Vector4.new(500,200,0,1), COLOR_RED)

	local dtime = os.time() - tt
	--print('dtime is '..dtime)
end
