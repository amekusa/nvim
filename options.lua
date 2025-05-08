---- OPTIONS ----
local vim = vim
local g = vim.g
local o = vim.o
local opt = vim.opt


-- GENERAL --
-- clipboard support
o.clipboard = 'unnamedplus'
-- mouse support ('a' for all modes)
o.mouse = 'a'
-- enable 24-bit color?
o.termguicolors = true
-- enable swap files?
o.swapfile = true


-- MINOR TWEAKS --
-- wait-time for idle state
o.updatetime = 1000 -- (ms) [default: 4000]
-- wait-time for key combos
o.timeoutlen = 250 -- (ms) [default: 1000]
-- wait-time for <esc> key combos
o.ttimeoutlen = 10 -- (ms) [default: 50]
-- timeout for redraw
o.redrawtime = 500 -- (ms) [default: 2000]
-- max column for syntax highlighting
o.synmaxcol = 400 -- [default: 3000]
-- redraw the screen lazily
o.lazyredraw = true -- [default: false]
-- default regex engine
o.regexpengine = 0 -- [default: 0]
--   0: auto
--   1: old engine
--   2: NFA engine

-- fix slow matchparen on large files
g.matchparen_timeout = 20 -- (ms)
g.matchparen_insert_timeout = 20 -- (ms)
--   See: https://vi.stackexchange.com/questions/5128/matchpairs-makes-vim-slow/5318#5318


-- UI --
-- hide ugly '~' (tilde) symbols
o.fillchars = 'eob: '
-- line numbers
o.number = true
o.relativenumber = false
-- mode indicator
o.showmode = true
-- sign column
o.signcolumn = 'yes'
-- how new splits should be opened
o.splitright = true
o.splitbelow = true
-- item limit of the popup menu
o.pumheight = 5 -- [default: 0 (unlimited)]


-- EDITOR --
-- highlight the current line
o.cursorline = true
-- whitespace chars --
o.list = true -- show them?
opt.listchars = {
	tab   = '» ',
	trail = '·',
	nbsp  = '␣'
}
-- indent style --
vim.cmd('filetype indent off') -- do not override indentexpr
o.indentexpr = ''
o.autoindent  = true -- copy the current indentation level?
o.smartindent = true -- enable a bit more advanced indentation?
o.cindent     = false -- optimize for C-style languages?
o.breakindent = false -- indent wrapped lines?
o.expandtab = false  -- use soft-tabs?
o.tabstop = 4        -- tab width
o.shiftwidth = 0     -- 0: fallback to tabstop
-- scroll threshold
o.scrolloff = 16
-- horizontal scrolling --
o.wrap = false       -- wrap long lines?
o.sidescroll = 8     -- scroll amount
o.sidescrolloff = 16 -- scroll threshold
-- preview substitutions as you type
o.inccommand = 'split'


-- SEARCH --
-- case-insensitive search unless \C or capital in query
o.ignorecase = true
o.smartcase = true
-- set highlight on search
o.hlsearch = true

