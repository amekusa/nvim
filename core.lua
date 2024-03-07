---- KEY BINDINGS ----
-- space: <leader> key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- (normal mode) esc: clear search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

---- GENERAL ----
-- clipboard support
vim.opt.clipboard = 'unnamedplus'
-- mouse support ('a' for all modes)
vim.opt.mouse = 'a'
-- decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

---- UI ----
-- hide those ugly '~' (tilde) symbols
vim.wo.fillchars='eob: '
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
-- break indent
vim.opt.breakindent = true
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
