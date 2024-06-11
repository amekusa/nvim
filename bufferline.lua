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
		max_length = 0,
		symbols = {
			-- cur = '', -- Nerdfont eb2c
			cur = '󰐊', -- Nerdfont f040a
			-- cur = '▷', -- U+25B7 White right-pointing triangle
			-- cur = '▶', -- U+25B6 Black right-pointing triangle
			mod = '*',
			sep = ' ',
			ell = '', -- Nerdfont
		}
	})
end

function M:render_buf(buf, is_curr)
	local sym = self.options.symbols
	return (is_curr and sym.cur..' ' or '  ')
		..(buf.name ~= '' and vim.fs.basename(buf.name) or '[No Name]')
		..(buf.changed == 1 and ' '..sym.mod or '  ')
end

function M:update_status()
	local bufs = vim.fn.getbufinfo({buflisted = 1})
	if #bufs == 0 then return '' end

	local max = self.options.max_length
	local sym = self.options.symbols

	-- find current index
	local curr = vim.api.nvim_get_current_buf()
	local i = #bufs
	while i > 1 and bufs[i].bufnr ~= curr do
		i = i - 1
	end

	-- render current item (or the 1st one)
	local buf = bufs[i]
	local r = self:render_buf(buf, buf.bufnr == curr)

	-- expand rendering from the current index towards left and right,
	-- until exceeds the max length
	local left_done, right_done
	local j = 1
	repeat
		local len = #r

		if not left_done then
			buf = bufs[i - j]
			if buf then
				local left = self:render_buf(buf)..sym.sep
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
				local right = sym.sep..self:render_buf(buf)
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
	if not left_done  then r = sym.ell..r end
	if not right_done then r = r..sym.ell end

	return r
end

return M

