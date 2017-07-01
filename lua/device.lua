
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
	local x1 = pa.x
	local y1 = pa.y
	local x2 = pb.x
	local y2 = pb.y
	local x3 = pc.x
	local y3 = pc.y

	if y1 == y2 then
		if y3 <= y1 then -- 平底
			self:drawTriangle_bottom(pc, pa, pb, color)
		else -- 平顶
			self:drawTriangle_top(pa, pb, pc, color)
		end
	elseif y1 == y3 then
		if y2 <= y1 then -- 平地
			self:drawTriangle_bottom(pb, pa, pc, color)
		else -- 平顶
			self:drawTriangle_top(pa, pc, pb, color)
		end
	elseif y2 == y3 then
		if y1 <= y2 then -- 平底
			self:drawTriangle_bottom(pa, pb, pc, color)
		else -- 平顶
			self:drawTriangle_top(pb, pc, pa, color)
		end
	else
		local xtop, ytop, xmid, ymid, xbot, ybot
		
		if y1 < y2 and y2 < y3 then -- y1 y2 y3
			xtop = x1
			ytop = y1
			xmid = x2
			ymid = y3
			xbot = x2
			ybot = y2
		elseif y1 < y3 and y3 < y2 then -- y1 y3 y2
			xtop = x1
			ytop = y1
			xmid = x3
			ymid = y3
			xbot = x2
			ybot = y2
		elseif y2 < y1 and y1 < y3 then -- y2 y1 y3
			xtop = x2
			ytop = y2
			xmid = x1
			ymid = y1
			xbot = x3
			ybot = y3
		elseif y2 < y3 and y3 < y1 then -- y2 y3 y1
			xtop = x2
			ytop = y2
			xmid = x3
			ymid = y3
			xbot = x1
			ybot = y1
		elseif y3 < y1 and y1 < y2 then -- y3 y1 y2
			xtop = x3
			ytop = y3
			xmid = x1
			ymid = y1
			xbot = x2
			ybot = y2
		elseif y3 < y2 and y2 < y1 then -- y3 y2 y1
			xtop = x3
			ytop = y3
			xmid = x2
			ymid = y2
			xbot = x1
			ybot = y1
		end

		local xl = (ymid - ytop) * (xtop - xtop) / (ybot - ytop) + xtop + 0.5

		if x1 < xmid then
			local v1 = Vector4.new(xtop, ytop, 0, 1)
			local v2 = Vector4.new(xl, ymid, 0, 1)
			local v3 = Vector4.new(xmid, ymid, 0, 1)
			self:drawTriangle_bottom(v1, v2, v3, color)
			local v4 = Vector4.new(xl, ymid, 0, 1)
			local v5 = Vector4.new(xmid, ymid, 0, 1)
			local v6 = Vector4.new(xbot, ybot, 0, 1)
			self:drawTriangle_top(v4, v5, v6, color)
		else
			local v1 = Vector4.new(xtop, ytop, 0, 1)
			local v2 = Vector4.new(xmid, ymid, 0, 1)
			local v3 = Vector4.new(xl, ymid, 0, 1)
			self:drawTriangle_bottom(v1, v2, v3, color)
			local v4 = Vector4.new(xmid, ymid, 0, 1)
			local v5 = Vector4.new(xl, ymid, 0, 1)
			local v6 = Vector4.new(xbot, ybot, 0, 1)
			self:drawTriangle_top(v4, v5, v6, color)
		end
	end
end

function Device:drawTriangle_top(pa, pb, pc, color)
	local x1 = pa.x
	local y1 = pa.y
	local x2 = pb.x
	local y2 = pb.y
	local x3 = pc.x
	local y3 = pc.y

	for y = y1, y3 do
		local xs = (y - y1) * (x3 - x1) / (y3 - y1) + x1 + 0.5
		local xe = (y - y2) * (x3 - x2) / (y3 - y2) + x2 + 0.5

		local v1 = Vector4.new(xs, y, 0, 1)
		local v2 = Vector4.new(xe, y, 0, 1)
		self:drawLine(v1, v2, color)
	end
end

function Device:drawTriangle_bottom(pa, pb, pc, color)
	local x1 = pa.x
	local y1 = pa.y
	local x2 = pb.x
	local y2 = pb.y
	local x3 = pc.x
	local y3 = pc.y

	for y = y1, y2 do
		local xs = (y - y1) * (x2 - x1) / (y2 - y1) + x1 + 0.5
		local xe = (y - y1) * (x3 - x1) / (y3 - y1) + x1 + 0.5

		local v1 = Vector4.new(xs, y, 0, 1)
		local v2 = Vector4.new(xe, y, 0, 1)
		self:drawLine(v1, v2, color)
	end
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

