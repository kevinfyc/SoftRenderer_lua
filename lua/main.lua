
require('config')

require('device')

require('color')

require('util')

require('class')

require('math')

require('vector4')

--[[
-- 测试Vector4
--]]

local v = Vector4.new(1, 0, 0, 1)
print(v.x, v.y, v.z, v.w)

local v1 = Vector4.new(0, 0, 0, 0)
local v2 = Vector4.new(100, 100, 0, 0)
drawLine(v1, v2, COLOR_RED)

function tick()
	local tt = os.time()
	
	drawPixel(100, 100, COLOR_RED)

	local dtime = os.time() - tt
	--print('dtime is '..dtime)
end
