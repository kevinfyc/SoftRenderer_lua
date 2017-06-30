
require('device')

require('color')

require('util')

function tick()
	local tt = os.time()
	
	drawPixel(100, 100, COLOR_RED)

	local dtime = os.time() - tt
	print('dtime is '..dtime)
end
