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


-- <leader> key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


-- move to the prev/next word
map('custom: Prev word', nvo, '<M-Left>',  'b')
map('custom: Prev word', 'i', '<M-Left>',  '<C-o>b')
map('custom: Prev word', 't', '<M-Left>',  '<Esc>b')
map('custom: Next word', nvo, '<M-Right>', 'w')
map('custom: Next word', 'i', '<M-Right>', '<C-o>w')
map('custom: Next word', 't', '<M-Right>', '<Esc>w')

-- better page-up/down
map('custom: Page up',   nvo, '<PageUp>',   'Hzz')
map('custom: Page up',   'i', '<PageUp>',   '<Esc>Hzzi')
map('custom: Page down', nvo, '<PageDown>', 'Lzz')
map('custom: Page down', 'i', '<PageDown>', '<Esc>Lzzi')

-- move line(s) up/down
map('custom: Move line up',    'n', '<C-k>', '<Cmd>m.-2<CR>==')
map('custom: Move line down',  'n', '<C-j>', '<Cmd>m.+1<CR>==')
map('custom: Move lines up',   'v', '<C-k>', "<Esc><Cmd>'<,'>m'<-2<CR>gv=gv")
map('custom: Move lines down', 'v', '<C-j>', "<Esc><Cmd>'<,'>m'>+1<CR>gv=gv")
--   NOTE:  m: move to X
--          .: the current line
--         '<: the first line of the selection
--         '>: the last line of the selection
--         gv: restart visual mode with the last selection
--          =: autoindent

-- prev/next buffer
map('custom: Prev buffer', nvi, '<C-h>', '<Cmd>bp<CR>')
map('custom: Next buffer', nvi, '<C-l>', '<Cmd>bn<CR>')


-- normal mode
map('custom: Normal mode', 'i', 'jk', '<Esc>')
map('custom: Normal mode', 'i', 'kj', '<Esc>')
map('custom: Normal mode', 'v', 'v',  '<Esc>')

-- command line mode
map('custom: Command line mode', nv, ';', ':')

-- visual mode
map('custom: Up with visual mode',    'i', '<S-Up>',    '<Esc>v<Up>')    -- switch to visual mode and move
map('custom: Right with visual mode', 'i', '<S-Right>', '<Esc>v<Right>')
map('custom: Down with visual mode',  'i', '<S-Down>',  '<Esc>v<Down>')
map('custom: Left with visual mode',  'i', '<S-Left>',  '<Esc>v<Left>')
map('custom: Up with visual mode',    'n', '<S-Up>',    'v<Up>')    -- switch to visual mode and move
map('custom: Right with visual mode', 'n', '<S-Right>', 'v<Right>')
map('custom: Down with visual mode',  'n', '<S-Down>',  'v<Down>')
map('custom: Left with visual mode',  'n', '<S-Left>',  'v<Left>')
map('custom: Up',                     'v', '<S-Up>',    '<Up>')                     -- keep moving in visual mode
map('custom: Right',                  'v', '<S-Right>', '<Right>')
map('custom: Down',                   'v', '<S-Down>',  '<Down>')
map('custom: Left',                   'v', '<S-Left>',  '<Left>')

-- quit
map('custom: Quit', nvi, '<C-q>', '<Cmd>q<CR>')
map('custom: Escape command line', 'c', '<C-q>', '<C-c>')
--   NOTE: for some reason, <Esc> as rhs for command line, works like <Esc><CR> actually,
--         which is unwanted behavior. so, use <C-c> instead.

-- save
map('custom: Save', nv,  '<C-s>', '<Cmd>w<CR>')
map('custom: Save', 'i', '<C-s>', '<Esc><Cmd>w<CR>')

-- undo
map('custom: Undo', nvi, '<C-z>', '<Cmd>u<CR>')

-- reopen (discard unsaved changes)
map('custom: Reopen', nv, '<leader>z', '<Cmd>conf e<CR>')

-- paste & select
map('custom: Paste & select', nv, 'p', function()
	return "p'["..vim.fn.getregtype().."']"
end, {expr = true})


-- clear search highlight
map('custom: Clear search highlight', 'n', '<Esc>', '<Cmd>nohls<CR><Cmd>redr!<CR>')

-- search with "magic (\v)"
--map('custom: Forward search (with "magic")', nv,  '/', [[/\v]])
--map('custom: Backward Search (with "magic")', nv,  '?', [[?\v]])
--   NOTE: "magic" allows you to use regex-special chars without escaping.

-- search & replace with "magic (\v)"
map('custom: Search & replace', 'n', '<C-f>', [[:%s/\v//gc<Left><Left><Left><Left>]])
map('custom: Search & replace', 'i', '<C-f>', [[<Esc>:%s/\v//gc<Left><Left><Left><Left>]])
map('custom: Search & replace in the selected range', 'v', '<C-f>', [[:s/\v%V//gc<Left><Left><Left><Left>]])

-- search & replace the current word
map('custom: Search & replace the word', 'n', '<leader>fw', [[:%s/\v<C-r><C-w>//gc<Left><Left><Left>]])

-- search & replace the selected text
map('custom: Search & replace the selected text', 'v', '<leader>fv', [[y:%s/\v<C-r>"//gc<Left><Left><Left>]])
--   NOTE: <C-r>" outputs the last yanked text

