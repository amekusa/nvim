---- KEYMAPS ----

local map = vim.keymap.set
local unmap = vim.keymap.del

-- modes:
--   n: normal
--   v: visual
--   s: select
--   x: visual & select
--   o: operator pending
--   i: insert
--   t: terminal
--   c: command line

-- mode combos
local nv = {'n','v'}
local nx = {'n','x'}
local nvo = {'n','v','o'}
local nxo = {'n','x','0'}
local nvi = {'n','v','i'}
local nxi = {'n','x','i'}

local function desc(s) -- keymap description
	return {desc = 'custom: '..s}
end


-- <leader> key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


-- move to the prev/next word
map(nvo, '<M-Left>',  'b',      desc 'Prev word')
map('i', '<M-Left>',  '<C-o>b', desc 'Prev word')
map('t', '<M-Left>',  '<Esc>b', desc 'Prev word')
map(nvo, '<M-Right>', 'w',      desc 'Next word')
map('i', '<M-Right>', '<C-o>w', desc 'Next word')
map('t', '<M-Right>', '<Esc>w', desc 'Next word')

-- better page-up/down
map(nvo, '<PageUp>',   'Hzz',       desc 'Page up')
map('i', '<PageUp>',   '<Esc>Hzzi', desc 'Page up')
map(nvo, '<PageDown>', 'Lzz',       desc 'Page down')
map('i', '<PageDown>', '<Esc>Lzzi', desc 'Page down')

-- move line(s) up/down
map('n', '<C-k>', ':m .-2<CR>==',     desc 'Move line up')
map('n', '<C-j>', ':m .+1<CR>==',     desc 'Move line down')
map('v', '<C-k>', ":m '<-2<CR>gv=gv", desc 'Move lines up')
map('v', '<C-j>', ":m '>+1<CR>gv=gv", desc 'Move lines down')


-- normal mode
map('i', 'jk', '<Esc>', desc 'Normal mode')
map('i', 'kj', '<Esc>', desc 'Normal mode')
map('v', 'v',  '<Esc>', desc 'Normal mode')

-- command line mode
map(nv,  ';',  ':',      desc 'Command line mode')
map('i', ';;', '<Esc>:', desc 'Command line mode')

-- quit
map(nvi, '<C-q>', '<Cmd>q<CR>', desc 'Quit')

-- save
map(nvi, '<C-s>', '<Cmd>w<CR>', desc 'Save')


-- clear search highlight
map('n', '<Esc>', '<Cmd>nohlsearch<CR>', desc 'Clear search highlight')

map('n', '<C-f>', [[:%s/\v//g<Left><Left>]])
map('i', '<C-f>', [[<C-o>:%s/\v//g<Left><Left>]])

map('n', '<leader>f', ':%s/<C-r><C-w>//g<Left><Left>', desc 'Search & replace the word')
map('v', '<leader>f', ':%s/<C-r>"//g<Left><Left>', desc 'Search & replace selected text')

-- search & replace with "magic (\v)"
map(nv,  '/', [[:%s/\v//gc<Left><Left><Left><Left>]],  desc 'Search & replace')
map('v', '/', [[:s/\v%V//gc<Left><Left><Left><Left>]], desc 'Search & replace in selected range')
--   NOTE: "magic" allows you to use regex-special chars without escaping.
