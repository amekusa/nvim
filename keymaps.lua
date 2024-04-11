---- KEYMAPS ----
local my = vim.g._custom
local map = my.fn.map

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
local nv  = {'n','v'}
local nvo = {'n','v','o'}
local nvi = {'n','v','i'}


-- <Leader> key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


-- move to the prev/next word
map('custom: Prev Word', nvo, '<M-Left>',  'b')
map('custom: Prev Word', 'i', '<M-Left>',  '<C-o>b')
map('custom: Prev Word', 't', '<M-Left>',  '<Esc>b')
map('custom: Next Word', nvo, '<M-Right>', 'w')
map('custom: Next Word', 'i', '<M-Right>', '<C-o>w')
map('custom: Next Word', 't', '<M-Right>', '<Esc>w')

-- better page-up/down
map('custom: Page Up',   nvo, '<PageUp>',   'Hzz')
map('custom: Page Up',   'i', '<PageUp>',   '<Esc>Hzzi')
map('custom: Page Down', nvo, '<PageDown>', 'Lzz')
map('custom: Page Down', 'i', '<PageDown>', '<Esc>Lzzi')

-- move line(s) up/down
map('custom: Move Line Up',    'n', '<C-k>', '<Cmd>m.-2<CR>==')
map('custom: Move Line Down',  'n', '<C-j>', '<Cmd>m.+1<CR>==')
map('custom: Move Lines Up',   'v', '<C-k>', "<Esc><Cmd>'<,'>m'<-2<CR>gv")
map('custom: Move Lines Down', 'v', '<C-j>', "<Esc><Cmd>'<,'>m'>+1<CR>gv")
--   NOTE:  m: move to X
--          .: the current line
--         '<: the first line of the selection
--         '>: the last line of the selection
--         gv: restart visual mode with the last selection
--          =: autoindent

-- prev/next buffer
map('custom: Prev Buffer', nvi, '<C-h>', '<Cmd>bp<CR>')
map('custom: Next Buffer', nvi, '<C-l>', '<Cmd>bn<CR>')


-- normal mode
map('custom: Normal Mode', 'i', 'jk', '<Esc>')
map('custom: Normal Mode', 'i', 'kj', '<Esc>')
map('custom: Normal Mode', 'v', 'v',  '<Esc>')

-- insert mode
map('custom: Insert Mode', 'v', 'i', '<Esc>i')

-- command line mode
map('custom: Command Line Mode', nv, ';', ':')

-- visual mode
map('custom: Up with Visual Mode',    'i', '<S-Up>',    '<Esc>v<Up>')    -- switch to visual mode and move
map('custom: Right with Visual Mode', 'i', '<S-Right>', '<Esc>v<Right>')
map('custom: Down with Visual Mode',  'i', '<S-Down>',  '<Esc>v<Down>')
map('custom: Left with Visual Mode',  'i', '<S-Left>',  '<Esc>v<Left>')
map('custom: Up with Visual Mode',    'n', '<S-Up>',    'v<Up>')    -- switch to visual mode and move
map('custom: Right with Visual Mode', 'n', '<S-Right>', 'v<Right>')
map('custom: Down with Visual Mode',  'n', '<S-Down>',  'v<Down>')
map('custom: Left with Visual Mode',  'n', '<S-Left>',  'v<Left>')
map('custom: Up',                     'v', '<S-Up>',    '<Up>')                     -- keep moving in visual mode
map('custom: Right',                  'v', '<S-Right>', '<Right>')
map('custom: Down',                   'v', '<S-Down>',  '<Down>')
map('custom: Left',                   'v', '<S-Left>',  '<Left>')

-- quit
map('custom: Quit', nvi, '<C-q>', '<Cmd>q<CR>')
map('custom: Escape Command Line', 'c', '<C-q>', '<C-c>')
--   NOTE: for some reason, <Esc> as rhs for command line, works like <Esc><CR> actually,
--         which is unwanted behavior. so, use <C-c> instead.

-- save
map('custom: Save', nv,  '<C-s>', '<Cmd>w<CR>')
map('custom: Save', 'i', '<C-s>', '<Esc><Cmd>w<CR>')

-- undo
map('custom: Undo', nvi, '<C-z>', '<Cmd>u<CR>')

-- reopen (discard unsaved changes)
map('custom: Reopen', nv, '<Leader>z', '<Cmd>conf e<CR>')

-- close buffer
map('custom: Close', nv, '<Leader>x', '<Cmd>bd<CR>')


-- clear search highlight
map('custom: Clear Search Highlight', 'n', '<Esc>', '<Cmd>nohls<CR><Cmd>redr!<CR>')

-- search with "magic (\v)"
--map('custom: Forward search (with "magic")', nv,  '/', [[/\v]])
--map('custom: Backward Search (with "magic")', nv,  '?', [[?\v]])
--   NOTE: "magic" allows you to use regex-special chars without escaping.

-- search & replace with "magic (\v)"
map('custom: Search & Replace', 'n', '<C-f>', [[:%s/\v//gc<Left><Left><Left><Left>]])
map('custom: Search & Replace', 'i', '<C-f>', [[<Esc>:%s/\v//gc<Left><Left><Left><Left>]])
map('custom: Search & Replace in the Range', 'v', '<C-f>', [[:s/\v%V//gc<Left><Left><Left><Left>]])

-- search & replace the current word
map('custom: Search & Replace the Word', 'n', '<Leader>fw', [[:%s/\v<C-r><C-w>//gc<Left><Left><Left>]])

-- search & replace the selected text
map('custom: Search & Replace the Selected', 'v', '<Leader>fv', [[y:%s/\v<C-r>"//gc<Left><Left><Left>]])
--   NOTE: <C-r>" outputs the last yanked text

