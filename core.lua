local opt = vim.opt

---- GENERAL ----
-- clipboard support
opt.clipboard = 'unnamedplus'
-- mouse support ('a' for all modes)
opt.mouse = 'a'
-- decrease update time
--opt.updatetime = 250
--opt.timeoutlen = 300

---- UI ----
-- hide those ugly '~' (tilde) symbols
opt.fillchars = 'eob: '
-- line numbers
opt.number = true
opt.relativenumber = true
-- mode indicator
opt.showmode = true
-- sign column
opt.signcolumn = 'yes'
-- how new splits should be opened
opt.splitright = true
opt.splitbelow = true

---- EDITOR ----
-- show whitespace chars
opt.list = true
opt.listchars = {
	tab   = '» ',
	trail = '·',
	nbsp  = '␣'
}
-- break indent
opt.breakindent = true
-- preview substitutions as you type
opt.inccommand = 'split'
-- highlight the current line
opt.cursorline = true
-- minimal number of screen lines to keep above and below the cursor
opt.scrolloff = 10

---- SEARCH ----
-- case-insensitive search unless \C or capital in query
opt.ignorecase = true
opt.smartcase = true
-- set highlight on search
opt.hlsearch = true
