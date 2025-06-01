---- OPTIONS ----
local vim = vim
local g = vim.g
local o = vim.o
local opt = vim.opt


-- GENERAL --
-- enable clipboard integration
o.clipboard = 'unnamedplus'
-- enable mouse integration ('a' for all modes)
o.mouse = 'a'
-- enable 24-bit color?
o.termguicolors = true
-- enable swap files?
o.swapfile = true


-- PERFORMANCE TWEAKS --
-- wait-time for idle state
o.updatetime = 1000 -- (ms) [default: 4000]
-- wait-time for key combos
o.timeoutlen = 250 -- (ms) [default: 1000]
-- wait-time for <Esc> key combos
o.ttimeoutlen = 10 -- (ms) [default: 50]
-- timeout for redraw
o.redrawtime = 500 -- (ms) [default: 2000]
-- max column for syntax highlighting
o.synmaxcol = 400 -- [default: 3000]
-- enable lazy-redraw?
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
-- highlight the current line?
o.cursorline = true
-- hide '~' (tilde) symbols on empty lines
o.fillchars = 'eob: '
-- show line numbers?
o.number = true
-- enable relative line numbers?
o.relativenumber = false
-- always show sign column
o.signcolumn = 'yes'
-- put the new split window right?
o.splitright = true
-- put the new split window below?
o.splitbelow = true
-- item limit of the popup menu
o.pumheight = 5 -- [default: 0 (unlimited)]


-- EDITOR --
-- show whitespace chars?
o.list = true
-- whitespace chars representations
opt.listchars = {
	tab   = '» ',
	trail = '·',
	nbsp  = '␣'
}
---- indentation style ----
vim.cmd('filetype indent off') -- do not override indentexpr
o.indentexpr = '' -- do not use indentexpr
o.autoindent = false -- copy the current indents?
o.smartindent = false -- enable a bit more advanced indenting?
o.cindent = true -- enable an even more advanced indenting?
o.cinkeys =   '0{,0},0),0],:,!^F,o,O,e' -- keys to trigger indentation
 -- [default: '0{,0},0),0],:,0#,!^F,o,O,e']
o.cinoptions = '' -- various options:
	.. ':0' -- do not indent switch-case labels
	.. '#0' -- enable indenting the lines start with #
	.. '(s,U1' -- indent inside a () block
	.. 'j1,J1' -- indent ({}) blocks correctly
o.cinwords =  'if,else,while,do,for'
 -- [default: 'if,else,while,do,for,switch']
o.breakindent = false -- indent wrapped lines?
o.expandtab = false -- use soft-tabs?
o.tabstop = 4 -- tab width
o.shiftwidth = 0 -- 0: fallback to tabstop
opt.cpoptions:append('I') -- do not delete indentation on moving cursor

-- scroll threshold
o.scrolloff = 16
---- horizontal scrolling ----
o.wrap = false -- wrap long lines?
o.sidescroll = 8 -- scroll amount
o.sidescrolloff = 16 -- scroll threshold

-- preview substitutions as you type
o.inccommand = 'split'


-- SEARCH --
-- case-insensitive search unless \C or capital in query
o.ignorecase = true
o.smartcase = true
-- highlight matches?
o.hlsearch = true

