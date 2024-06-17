---[ Amekusa's Bufferline ]---
-- @author github.com/amekusa

local M = require('lualine.component'):extend()
local highlight = require('lualine.highlight')

local default_options = {
	max_length = nil,
	use_mode_colors = false,
	buffers_color = {
		active   = {gui = 'bold'},
		inactive = nil,
	},
	symbols = {
		mod = '*',
		sep = '',
		ell = '', -- nerdfont
	}
}

local section_redirects = {
	lualine_x = 'lualine_c',
	lualine_y = 'lualine_b',
	lualine_z = 'lualine_a',
}

local function get_hl(section, is_active)
	local suffix = is_active and highlight.get_mode_suffix() or '_inactive'
	if section_redirects[section] and not highlight.highlight_exists(section..suffix)
		then return section_redirects[section]..suffix
		else return section..suffix
	end
end

function M:init(options)
	M.super.init(self, vim.tbl_deep_extend('keep', options or {}, default_options))

	local hl = self.options.buffers_color
	local section = 'lualine_'..self.options.self.section

	if not hl.active then
		hl.active = not self.options.use_mode_colors and get_hl(section, true) or function()
			return get_hl(section, true)
		end
	end

	if not hl.inactive then
		hl.inactive = get_hl(section, false)
	end

	self.highlights = {
		active   = self:create_hl(hl.active,   'active'),
		inactive = self:create_hl(hl.inactive, 'inactive'),
	}
end

function M:render_buf(buf)
	return ' '..(buf.changed == 1 and self.options.symbols.mod or '')..
		(buf.name ~= '' and vim.fs.basename(buf.name) or '[No Name]')..' '
end

function M:update_status()
	local bufs = vim.fn.getbufinfo({buflisted = 1})
	if #bufs == 0 then return '' end

	local sym = self.options.symbols
	local max = self.options.max_length; if max
		then if type(max) == 'function' then max = max(self) end
		else max = -60 + (self.options.globalstatus and vim.go.columns or vim.fn.winwidth(0))
	end

	local hl1 = highlight.component_format_highlight(self.highlights.active)
	local hl2 = highlight.component_format_highlight(self.highlights.inactive)

	-- find current index
	local curr = vim.api.nvim_get_current_buf()
	local i = #bufs
	while i > 1 and bufs[i].bufnr ~= curr do
		i = i - 1
	end

	-- render current item (or the 1st one)
	local buf = bufs[i]
	local is_curr = buf.bufnr == curr
	local r = self:render_buf(buf)
	local len = #r
	r = (is_curr and hl1 or hl2)..r

	-- expand rendering from the current index towards left and right,
	-- until exceeds the max length
	local left_done, right_done
	local j = 1
	repeat

		if not left_done then
			buf = bufs[i - j]
			if buf then
				local left = self:render_buf(buf)
				len = #left + #sym.sep + len
				if len > max then break end
				r = hl2..left..sym.sep..r
			else
				left_done = true
			end
		end

		if not right_done then
			buf = bufs[i + j]
			if buf then
				local right = self:render_buf(buf)
				len = len + #sym.sep + #right
				if len > max then break end
				r = r..sym.sep..hl2..right
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

