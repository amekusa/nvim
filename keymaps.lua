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
local nvo = {'n','v','o'}
local nvi = {'n','v','i'}
local ni = {'n','i'}

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

-- search with "magic (\v)"
map(nv,  '/', [[/\v]],  desc 'Search (with "magic")')
--   NOTE: "magic" allows you to use regex-special chars without escaping.

-- search & replace with "magic (\v)"
map('n', '<C-f>', [[:%s/\v//gc<Left><Left><Left><Left>]],       desc 'Search & replace')
map('i', '<C-f>', [[<Esc>:%s/\v//gc<Left><Left><Left><Left>]],  desc 'Search & replace')
map('v', '<C-f>', [[:s/\v%V//gc<Left><Left><Left><Left>]],      desc 'Search & replace in the selected range')

-- search & replace the current word
map('n', '<leader>f', ':%s/<C-r><C-w>//gc<Left><Left><Left>', desc 'Search & replace the word')

-- search & replace the selected text
map('v', '<leader>f', 'y:%s/<C-r>"//gc<Left><Left><Left>',    desc 'Search & replace the selected text')
--   NOTE: <C-r>" outputs the last yanked text

