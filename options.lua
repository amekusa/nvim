---- OPTIONS ----

-- OS RELATED --
-- clipboard support
vim.o.clipboard = 'unnamedplus'
-- mouse support ('a' for all modes)
vim.o.mouse = 'a'
-- enable 24-bit color
vim.o.termguicolors = true


-- MINOR TWEAKS --
-- wait-time for idle state (ms) [default: 4000]
vim.o.updatetime = 1000
-- wait-time for key-combos (ms) [default: 1000]
vim.o.timeoutlen = 250
-- redraw the screen lazily [default: false]
vim.o.lazyredraw = true
-- default regex engine [default: 0]
vim.o.regexpengine = 0
--   0: auto
--   1: old engine
--   2: NFA engine

-- fix slow matchparen on large files
vim.g.matchparen_timeout = 20 -- (ms)
vim.g.matchparen_insert_timeout = 20 -- (ms)
--   See: https://vi.stackexchange.com/questions/5128/matchpairs-makes-vim-slow/5318#5318


-- UI --
-- hide those ugly '~' (tilde) symbols
vim.o.fillchars = 'eob: '
-- line numbers
vim.o.number = true
vim.o.relativenumber = false
-- mode indicator
vim.o.showmode = true
-- sign column
vim.o.signcolumn = 'yes'
-- how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true


-- EDITOR --
-- show whitespace chars
vim.o.list = true
vim.opt.listchars = {
	tab   = '» ',
	trail = '·',
	nbsp  = '␣'
}
-- indent style
vim.o.expandtab = false -- use soft-tab?
vim.o.tabstop = 4       -- tab width
vim.o.shiftwidth = 0    -- 0: fallback to tabstop
vim.o.breakindent = true -- indent wrapped lines
vim.o.smartindent = true -- autoindent new line [default: false]

-- preview substitutions as you type
vim.o.inccommand = 'split'
-- highlight the current line
vim.o.cursorline = true
-- minimal number of screen lines to keep above and below the cursor
vim.o.scrolloff = 10


-- SEARCH --
-- case-insensitive search unless \C or capital in query
vim.o.ignorecase = true
vim.o.smartcase = true
-- set highlight on search
vim.o.hlsearch = true

