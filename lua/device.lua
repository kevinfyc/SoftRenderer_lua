
Device = class()

function Device:ctor(width, height)
	self.width = width
	self.height = height
end

-----------------------------------------
-- draw pixel
-----------------------------------------

function Device:drawPixel(x, y, color)
	draw_pixel(x, y, color)
end

-----------------------------------------
-- draw line
-----------------------------------------

function Device:drawLine(pos_bgn, pos_end, color)
	local x1 = pos_bgn.x
	local y1 = pos_bgn.y

	local x2 = pos_end.x
	local y2 = pos_end.y

	local dx = x2 - x1
	local dy = y2 - y1

	local stepx = 1
	local stepy = 1

	if dx >= 0 then
		stepx = 1
	else
		stepx = -1
		dx = math.abs(dx)
	end

	if dy >= 0 then
		stepy = 1
	else
		stepy = -1
		dy = math.abs(dy)
	end

	local deltax = 2 * dx
	local deltay = 2 * dy

	local err = 0

	if dx > dy then
		err = deltay - dx
		for i = 0, dx do
			if x1 >= 0 and x1 < win_width and y1 >= 0 and y1 < win_height then
				self:drawPixel(x1, y1, color)
			end

			if err >= 0 then
				err = err - deltax
				y1 = y1 + stepy
			end

			err = err + deltay
			x1 = x1 + stepx
		end
	else
		err = deltax - dy
		for i = 0, dy do
			if x1 >= 0 and x1 < win_width and y1 >= 0 and y1 < win_height then
				self:drawPixel(x1, y1, color)
			end

			if err >= 0 then
				err = err - deltay
				x1 = x1 + stepx
			end

			err = err + deltax
			y1 = y1 + stepy
		end
	end

end
-----------------------------------------
-- draw triangle
-----------------------------------------

function Device:drawTriangle(pa, pb, pc, color)
	self:drawLine(pa, pb, color)
	self:drawLine(pa, pc, color)
	self:drawLine(pc, pb, color)
end

-----------------------------------------
-- draw clear
-----------------------------------------

RENDER_STATE_WIREFRAME      = 1		-- 渲染线框
RENDER_STATE_TEXTURE        = 2		-- 渲染纹理
RENDER_STATE_COLOR          = 4		-- 渲染颜色


function Device:clear(color)
	for i = 0, self.width do
		for j = 0, self.height do
			self:drawPixel(i, j, color)
		end
	end
end

