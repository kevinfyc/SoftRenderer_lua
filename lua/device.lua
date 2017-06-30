
-----------------------------------------
-- draw pixel
-----------------------------------------

function drawPixel(x, y, color)
	draw_pixel(x, y, color)
end
-----------------------------------------
-- draw line
-----------------------------------------

function drawLine(pos_bgn, pos_end, color)
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
		dx = abs(dx)
	end

	if dy >= 0 then
		stepy = 1
	else
		stepy = -1
		dy = abs(dy)
	end

	local deltax = 2 * dx
	local deltay = 2 * dy

	local err = 0

	if dx > dy then
		err = deltay - dx
		for i = 0, dx do
			if x1 >= 0 and x1 < win_width and y1 >= 0 and y1 < win_height then
				drawPixel(x1, y1, color)
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
				drawPixel(x1, y1, color)
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
-- draw
-----------------------------------------

function drawPixel(x, y, color)
	draw_pixel(x, y, color)
end
