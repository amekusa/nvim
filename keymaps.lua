---- KEYMAPS ----
local map = vim.keymap

-- <leader> key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- clear search highlight
map.set('n', '<Esc>', '<Cmd>nohlsearch<CR>')
-- move line up/down
map.set('n', '<C-j>', ':m .+1<CR>==')
map.set('n', '<C-k>', ':m .-2<CR>==')
-- move line up/down (visual mode)
map.set('v', '<C-j>', ":m '>+1<CR>gv=gv")
map.set('v', '<C-k>', ":m '<-2<CR>gv=gv")

-- nvim-tree
map.set({'n','v','i'}, '<C-n>', '<Cmd>NvimTreeOpen<CR>')
