---[ amekusa's NeoVim Configuration ]---
---- github.com/amekusa/nvim

---- GLOBAL ----
local my = {
	base = (...)..'.', -- require base
	conf = {
		trim_trailing_whitespace = true,
	},
	fn = { -- utils
		map = function(desc, mode, from, to, opts)
			if not opts then opts = {} end
			opts.desc = desc
			return vim.keymap.set(mode, from, to, opts)
		end,
	}
}
vim.g._custom = my


---- OS RELATED ----
-- clipboard support
vim.opt.clipboard = 'unnamedplus'
-- mouse support ('a' for all modes)
vim.opt.mouse = 'a'
-- enable 24-bit color
vim.opt.termguicolors = true


---- MINOR TWEAKS ----
-- wait-time for idle state (ms) [default: 4000]
vim.opt.updatetime = 1000
-- wait-time for key-combos (ms) [default: 1000]
vim.opt.timeoutlen = 250
-- redraw the screen lazily [default: false]
vim.opt.lazyredraw = true
-- default regex engine [default: 0]
vim.opt.regexpengine = 0
--   0: auto
--   1: old engine
--   2: NFA engine


---- UI ----
-- hide those ugly '~' (tilde) symbols
vim.opt.fillchars = 'eob: '
-- line numbers
vim.opt.number = true
vim.opt.relativenumber = false
-- mode indicator
vim.opt.showmode = true
-- sign column
vim.opt.signcolumn = 'yes'
-- how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true


---- EDITOR ----
-- show whitespace chars
vim.opt.list = true
vim.opt.listchars = {
	tab   = '» ',
	trail = '·',
	nbsp  = '␣'
}
-- tab width
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0  -- 0 falls back to tabstop
-- indent wrapped lines [default: false]
vim.opt.breakindent = true
-- autoindent new line [default: false]
vim.opt.smartindent = true
-- preview substitutions as you type
vim.opt.inccommand = 'split'
-- highlight the current line
vim.opt.cursorline = true
-- minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10


---- SEARCH ----
-- case-insensitive search unless \C or capital in query
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- set highlight on search
vim.opt.hlsearch = true


---- KEYMAPS & PLUGINS ----
require(my.base..'keymaps')
require(my.base..'plugins')


---- AUTO COMMANDS ----
local autocmd = vim.api.nvim_create_autocmd

local function regex_ext(ext) -- returns a regex that matches with given file extensions
	if type(ext) ~= 'table' then ext = {ext} end
	return vim.regex([[\.\(]]..table.concat(ext, [[\|]])..[[\)$]])
end

if my.conf.trim_trailing_whitespace then
	autocmd('BufWritePre', {
		desc = 'Trim trailing whitespace on save',
		pattern = '*',
		callback = function(ev)
			local ignore = {'md'}
			if regex_ext(ignore):match_str(ev.file) then return end
			vim.cmd([[silent! %s/\s\+$//g]]) -- trim
		end
	})
end

