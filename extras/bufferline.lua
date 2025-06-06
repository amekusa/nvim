---[ Amekusa's Bufferline ]---
-- @author github.com/amekusa

local vim = vim

local M = require('lualine.component'):extend()
local highlight = require('lualine.highlight')

local default_options = {
	max_length = nil,
	max_length_offset = 60,
	use_mode_colors = false,
	highlights = {
		active   = {gui = 'bold'},
		inactive = nil,
	},
	compact = 5, -- compact mode (number of buffers to activate)
	symbols = {
		mod = '*', -- mark for a modified buffer
		sep = ' ', -- buffer separator
		ell = '', -- ellipsis (nerdfont)
		compact = {
			mod = '*',
			sep = '',
			ell = '',
		}
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

	local hl = self.options.highlights
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

	self.needs_update = true
	vim.api.nvim_create_autocmd({'BufAdd', 'BufDelete', 'BufEnter', 'BufModifiedSet'}, {
		callback = function()
			self.needs_update = true
		end
	})

	self.last_curr_i = 1
end

function M:render_buf(buf, compact)
	local r
	if buf.name == '' then
		r = '[No Name]'
	else
		r = vim.fn.fnamemodify(buf.name, ':t') -- basename
		if compact then
			r = vim.fn.fnamemodify(r, ':r') -- remove extension
		end
	end
	if buf.changed == 1 then
		r = (compact and self.options.symbols.compact.mod or self.options.symbols.mod)..r
	end
	return ' '..r..' '
end

function M:update_status()
	local bufs = vim.fn.getbufinfo({buflisted = 1})
	if #bufs == 0 then return '' end

	local opts = self.options
	local max = opts.max_length; if max
		then if type(max) == 'function' then max = max(self) end
		else max = opts.globalstatus and vim.go.columns or vim.fn.winwidth(0)
		max = max - opts.max_length_offset
	end
	local sym = opts.symbols
	local compact = #bufs >= opts.compact
	if compact then sym = sym.compact end

	local hl1 = highlight.component_format_highlight(self.highlights.active)
	local hl2 = highlight.component_format_highlight(self.highlights.inactive)

	-- find current index
	local curr = vim.api.nvim_get_current_buf()
	local i = #bufs
	while i > 0 and bufs[i].bufnr ~= curr do
		i = i - 1
	end
	if i == 0 -- if the current buffer is not listed,
		then i = self.last_curr_i -- use the last current index
		else self.last_curr_i = i -- or update the last current index
	end

	-- render current item (or the 1st one)
	local buf = bufs[i]
	local r = self:render_buf(buf, compact)
	local len = #r -- total length
	r = hl1..r

	-- extend rendering from the current index towards left/right ends
	local left_done, right_done
	local j = 1
	repeat

		if not left_done then
			buf = bufs[i - j]
			if buf then
				local left = self:render_buf(buf, compact)
				len = #left + #sym.sep + len -- total length
				if len > max then break end -- truncate
				r = hl2..left..sym.sep..r
			else
				left_done = true
			end
		end

		if not right_done then
			buf = bufs[i + j]
			if buf then
				local right = self:render_buf(buf, compact)
				len = len + #sym.sep + #right -- total length
				if len > max then break end -- truncate
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

function M:draw()
	if self.options.cond ~= nil and self.options.cond() ~= true then
		return ''
	end
	if self.needs_update then
		self.applied_separator = ''
		self.status = self:update_status()
		if #self.status > 0 then
			self:apply_section_separators()
			self:apply_separator()
		end
		self.needs_update = false
	end
	return self.status
end

return M

