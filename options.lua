---- OPTIONS ----
local vim = vim


-- GENERAL --
-- clipboard support
vim.o.clipboard = 'unnamedplus'
-- mouse support ('a' for all modes)
vim.o.mouse = 'a'
-- enable 24-bit color
vim.o.termguicolors = true
-- disable swap files
vim.o.swapfile = false


-- MINOR TWEAKS --
-- wait-time for idle state
vim.o.updatetime = 1000 -- (ms) [default: 4000]
-- wait-time for key-combos
vim.o.timeoutlen = 250 -- (ms) [default: 1000]
-- timeout for redraw
vim.o.redrawtime = 500 -- (ms) [default: 2000]
-- max column for syntax highlighting
vim.o.synmaxcol = 400 -- [default: 3000]
-- redraw the screen lazily
vim.o.lazyredraw = true -- [default: false]
-- default regex engine
vim.o.regexpengine = 0 -- [default: 0]
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
-- item limit of the popup menu
vim.o.pumheight = 5 -- [default: 0 (unlimited)]


-- EDITOR --
-- whitespace chars --
vim.o.list = true -- show them?
vim.opt.listchars = {
	tab   = '» ',
	trail = '·',
	nbsp  = '␣'
}
-- indent style --
vim.o.expandtab = false -- use soft-tabs?
vim.o.tabstop = 4       -- tab width
vim.o.shiftwidth = 0    -- 0: fallback to tabstop
vim.o.breakindent = true -- indent wrapped lines?
vim.o.smartindent = true -- autoindent new line?

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

