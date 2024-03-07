-- hide those ugly '~' (tilde) symbols
vim.wo.fillchars="eob: "

-- set space as the <leader> key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- nerd font support
vim.g.have_nerd_font = false

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = false

-- mouse support ('a' for all modes)
vim.opt.mouse = 'a'

-- mode indicator
vim.opt.showmode = true

-- clipboard support
vim.opt.clipboard = 'unnamedplus'

-- break indent
vim.opt.breakindent = true

-- case-insensitive search unless \C or capital in query
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- sign column
vim.opt.signcolumn = 'yes'

-- decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- show whitespace chars
vim.opt.list = true
vim.opt.listchars = {
	tab   = '» ',
	trail = '·',
	nbsp  = '␣'
}

-- preview substitutions as you type
vim.opt.inccommand = 'split'

-- highlight the current line
vim.opt.cursorline = true

-- minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10
