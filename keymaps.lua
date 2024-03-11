---- KEYMAPS ----
local map = vim.keymap.set
local function desc(s)
	return {desc = 'custom: ' .. s}
end

-- <leader> key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- use semicolon as colon to start typing a command
map({'n','v'}, ';', ':', desc 'Use semicolon as colon')
-- clear search highlight
map('n', '<Esc>', '<Cmd>nohlsearch<CR>', desc 'Clear search highlight')
-- move line up/down
map('n', '<C-k>', ':m .-2<CR>==', desc 'Move line up')
map('n', '<C-j>', ':m .+1<CR>==', desc 'Move line down')
-- move line up/down (visual mode)
map('v', '<C-k>', ":m '<-2<CR>gv=gv", desc 'Move line up')
map('v', '<C-j>', ":m '>+1<CR>gv=gv", desc 'Move line down')
-- move to prev/next word
map({'n','v'}, '<M-Left>',  'b', desc 'Move to next word')
map({'n','v'}, '<M-Right>', 'w', desc 'Move to previous word')
-- move to prev/next word (insert mode)
map('i', '<M-Left>',  '<C-o>b', desc 'Move to next word')
map('i', '<M-Right>', '<C-o>w', desc 'Move to previous word')
-- quit
map({'n','v','i'}, '<C-q>', '<Cmd>qa<CR>', desc 'Quit')
-- save
map({'n','v','i'}, '<C-s>', '<Cmd>w<CR>', desc 'Save')
