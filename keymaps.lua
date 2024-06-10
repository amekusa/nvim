---- KEYMAPS ----
local my = vim.g._custom
local map = my.fn.map

--  Mode | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
-- ------+------+-----+-----+-----+-----+-----+------+------+
--     n | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
--     ! |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
--     i |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
--     c |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
--     v |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
--     x |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
--     s |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
--     o |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
--     t |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
--     l |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |

-- mode combos
local ni  = {'n','i'}
local nx  = {'n','x'}
local nxo = {'n','x','o'}
local nxi = {'n','x','i'}


-- <Leader> key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


-- move to the prev/next word
map('custom: Prev Word', nxo, '<M-Left>',  'b')
map('custom: Prev Word', 'i', '<M-Left>',  '<C-o>b')
map('custom: Prev Word', 't', '<M-Left>',  '<Esc>b')
map('custom: Next Word', nxo, '<M-Right>', 'w')
map('custom: Next Word', 'i', '<M-Right>', '<C-o>w')
map('custom: Next Word', 't', '<M-Right>', '<Esc>w')

-- better page-up/down
map('custom: Page Up',   nxo, '<PageUp>',   '10kzz')
map('custom: Page Up',   'i', '<PageUp>',   '<Esc>10kzzi')
map('custom: Page Down', nxo, '<PageDown>', '10jzz')
map('custom: Page Down', 'i', '<PageDown>', '<Esc>10jzzi')

-- better home key
map('custom: Home', nxo, '<Home>', '^')
map('custom: Home', 'i', '<Home>', '<C-o>^')


-- indent/outdent
map('custom: Indent',  'i', '<Tab>',   function() my.fn.indent() end);
map('custom: Indent',  'x', '<Tab>',   ':><CR>gv');
map('custom: Outdent', 'i', '<S-Tab>', '<Cmd><<CR>');
map('custom: Outdent', 'x', '<S-Tab>', ':<<CR>gv');

-- move line(s) up/down
map('custom: Move Line Up',    'n', '<C-k>', '<Cmd>m.-2<CR>==')
map('custom: Move Line Down',  'n', '<C-j>', '<Cmd>m.+1<CR>==')
map('custom: Move Lines Up',   'x', '<C-k>', ":'<,'>m'<-2<CR>gv")
map('custom: Move Lines Down', 'x', '<C-j>', ":'<,'>m'>+1<CR>gv")
--   NOTE:  m: move to X
--          .: the current line
--         '<: the first line of the selection
--         '>: the last line of the selection
--         gv: restart visual mode with the last selection
--          =: autoindent

-- shift + arrows = move with visual mode
map('custom: Up with Visual Mode',    'i', '<S-Up>',    '<Esc>v<Up>')
map('custom: Right with Visual Mode', 'i', '<S-Right>', '<Esc>v<Right>')
map('custom: Down with Visual Mode',  'i', '<S-Down>',  '<Esc>v<Down>')
map('custom: Left with Visual Mode',  'i', '<S-Left>',  '<Esc>v<Left>')
map('custom: Up with Visual Mode',    'n', '<S-Up>',    'v<Up>')
map('custom: Right with Visual Mode', 'n', '<S-Right>', 'v<Right>')
map('custom: Down with Visual Mode',  'n', '<S-Down>',  'v<Down>')
map('custom: Left with Visual Mode',  'n', '<S-Left>',  'v<Left>')
map('custom: Up',                     'x', '<S-Up>',    '<Up>')
map('custom: Right',                  'x', '<S-Right>', '<Right>')
map('custom: Down',                   'x', '<S-Down>',  '<Down>')
map('custom: Left',                   'x', '<S-Left>',  '<Left>')


-- normal mode
map('custom: Normal Mode', 'i', 'jk', '<Esc>')
map('custom: Normal Mode', 'i', 'kj', '<Esc>')
map('custom: Normal Mode', 'x', 'v',  '<Esc>')
map('custom: Normal Mode', 'c', '<C-q>', '<C-c>')
--   NOTE: for some reason, <Esc> as rhs for command line, works like <Esc><CR> actually,
--         which is unwanted behavior. so, use <C-c> instead.

-- insert mode
map('custom: Insert Mode', 'x', 'i', '<Esc>i')


-- prev/next buffer
map('custom: Prev Buffer', nxi, '<C-h>', function() my.fn.buf_rotate(-1) end)
map('custom: Next Buffer', nxi, '<C-l>', function() my.fn.buf_rotate(1)  end)

-- close/reopen buffer
map('custom: Close Buffer',  nx, '<Leader>x', function() my.fn.buf_close(0, true) end)
map('custom: Reopen Buffer', nx, '<Leader>z', '<Cmd>conf e<CR>')


-- save/undo/quit
map('custom: Save', nx,  '<C-s>', '<Cmd>w<CR>')
map('custom: Save', 'i', '<C-s>', '<Esc><Cmd>w<CR>')
map('custom: Undo', nxi, '<C-z>', '<Cmd>u<CR>')
map('custom: Quit', nxi, '<C-q>', '<Cmd>conf q<CR>')


-- clear search highlight
map('custom: Clear Search Highlight', 'n', '<Esc>', '<Cmd>nohls<CR><Cmd>redr!<CR>')

-- find & replace with "magic (\v)"
map('custom: Find & Replace',              'n', '<Leader>/', [[:%s/\v//gc<Left><Left><Left><Left>]])
map('custom: Find & Replace in the Range', 'x', '<Leader>/', [[:s/\v%V//gc<Left><Left><Left><Left>]])
--   NOTE: "magic" allows you to use regex-special chars without escaping.

-- find & replace the current word
map('custom: Find & Replace the Word', 'n', '<C-f>', [[:%s/<C-r><C-w>//gc<Left><Left><Left>]])
map('custom: Find & Replace the Word', 'i', '<C-f>', [[<Esc>:%s/<C-r><C-w>//gc<Left><Left><Left>]])

-- find & replace the selected text
map('custom: Find & Replace the Selected', 'x', '<C-f>', [[y:%s/<C-r>"//gc<Left><Left><Left>]])
--   NOTE: <C-r>" outputs the last yanked text


-- toggle typewriter mode
map('custom: Typewriter Mode', nx, '<S-z>', function() my.fn.typewriter_mode() end)

