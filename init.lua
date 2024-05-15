---[ amekusa's NeoVim Configuration ]---
---- github.com/amekusa/nvim

---- GLOBAL ----
local my = {
	ns = (...), -- namespace
	conf = { -- config of the config
		keymaps = {
			enable = true,
		},
		plugins = {
			enable = true,
			themes = true,
		},
		autocmds = {
			enable = true,
			trim_trailing_whitespace = true,
			detect_large_file = true,
			detect_large_file_size = 256 * 1024,
			clear_jumplist = true,
		},
	},
}

-- custom functions
my.fn = require(my.ns..'.fn')

-- root path
my.path = vim.fn.stdpath('config')..'/lua/'..
	my.ns:gsub('%.', '/') -- replace . in namespace with /

-- save to global
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

-- fix slow matchparen on large files
vim.g.matchparen_timeout = 20 -- (ms)
vim.g.matchparen_insert_timeout = 20 -- (ms)
--   See: https://vi.stackexchange.com/questions/5128/matchpairs-makes-vim-slow/5318#5318


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


if my.conf.keymaps.enable then require(my.ns..'.keymaps') end
if my.conf.plugins.enable then require(my.ns..'.plugins') end
if my.conf.autocmds.enable then require(my.ns..'.autocmds') end

