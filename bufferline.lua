---[ Amekusa's Bufferline ]---
-- @author github.com/amekusa

local M = require('lualine.component'):extend()

local modules = require('lualine_require').lazy_require {
	highlight = 'lualine.highlight',
	utils = 'lualine.utils.utils',
}

function M:init(options)
	M.super.init(self, options)
	self.options = vim.tbl_deep_extend('keep', self.options or {}, {
		-- default options
		symbols = {
			sep = '  ',
		}
	})
end

function M:render_buf(buf, is_curr)
	local r = ''
	-- local icon = '' -- Nerdfont eb2c
	local icon = '󰐊' -- Nerdfont f040a
	-- local icon = '▷' -- U+25B7 White right-pointing triangle
	-- local icon = '▶' -- U+25B6 Black right-pointing triangle
	local label = buf.name ~= '' and vim.fs.basename(buf.name) or '[No Name]'
	r = r..(is_curr and icon..' ' or '  ')..label..(buf.changed == 1 and ' *' or ' ')
	return r
end

function M:update_status()
	local bufs = vim.fn.getbufinfo({buflisted = 1})
	if #bufs == 0 then return '' end

	local r
	local max = math.floor(2 * vim.o.columns / 3)
	local sep = self.options.symbols.sep

	-- find current index
	local curr = vim.api.nvim_get_current_buf()
	local i = #bufs
	while i > 1 and bufs[i].bufnr ~= curr do
		i = i - 1
	end

	-- render current (or the 1st one)
	local buf = bufs[i]
	r = self:render_buf(buf, buf.bufnr == curr)

	-- render left and right, until exceeds the max length
	local left_done, right_done
	local j = 1
	repeat
		local len = #r

		if not left_done then
			buf = bufs[i - j]
			if buf then
				local left = self:render_buf(buf)
				len = len + #left
				if len > max
					then break
					else r = left..r
				end
			else
				left_done = true
			end
		end

		if not right_done then
			buf = bufs[i + j]
			if buf then
				local right = self:render_buf(buf)
				len = len + #right
				if len > max
					then break
					else r = r..right
				end
			else
				right_done = true
			end
		end

		j = j + 1

	until left_done and right_done

	-- add ellipsis marks if truncated
	local ellip = '...'
	if not left_done  then r = ellip..r end
	if not right_done then r = r..ellip end

	return r
end

return M

