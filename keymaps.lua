---- KEYMAPS ----
local vim = vim
local my = _custom
local fn = my.fn
local map = fn.map
local buf_cycle = fn.buf_cycle

-- | Mode | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
-- +------+------+-----+-----+-----+-----+-----+------+------+
-- |    n | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
-- |    ! |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
-- |    i |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
-- |    c |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
-- |    v |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
-- |    x |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
-- |    s |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
-- |    o |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
-- |    t |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
-- |    l |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |

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

-- better home key
map('custom: Home', nxo, '<Home>', '^')
map('custom: Home', 'i', '<Home>', '<C-o>^')

-- remap end key
map('custom: End', nxo, ';', '<End>')

-- scrolling
map('custom: Scroll Up',    nx, '<C-e>', '<C-u>')
map('custom: Scroll Left',  nx, 'zh',    '16zh')
map('custom: Scroll Right', nx, 'zl',    '16zl')


-- indent/outdent
map('custom: Indent',  ni,  '<Tab>',   fn.smart_indent)
map('custom: Indent',  'x', '<Tab>',   ':><CR>gv')
map('custom: Outdent', ni,  '<S-Tab>', '<Cmd><<CR>')
map('custom: Outdent', 'x', '<S-Tab>', ':<<CR>gv')

-- insert line below/above
map('custom: Insert Line Below', 'n', '<C-CR>', 'o')
map('custom: Insert Line Below', 'i', '<C-CR>', '<Esc>o')
map('custom: Insert Line Above', 'n', '<S-CR>', 'O')
map('custom: Insert Line Above', 'i', '<S-CR>', '<Esc>O')

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
map('custom: Normal Mode', 'i', 'jk', '<Esc><Right>')
map('custom: Normal Mode', 'i', 'kj', '<Esc>')
map('custom: Normal Mode', 'x', 'v',  '<Esc>')
map('custom: Normal Mode', 'c', '<C-q>', '<C-c>')
--   NOTE: for some reason, <Esc> as rhs for command line, works like <Esc><CR> actually,
--         which is unwanted behavior. so, use <C-c> instead.

-- insert mode
map('custom: Insert Mode', 'x', 'i', '<Esc>i')


-- prev/next buffer
map('custom: Prev Buffer', nxi, '<C-h>', function() buf_cycle(-1) end)
map('custom: Next Buffer', nxi, '<C-l>', function() buf_cycle(1)  end)

-- close/reopen buffer
map('custom: Close Buffer',  nx, '<Leader>x', fn.buf_close)
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
map('custom: Find & Replace the Word', 'n', '<C-x>', [[:%s/<C-r><C-w>//gc<Left><Left><Left>]])
map('custom: Find & Replace the Word', 'i', '<C-x>', [[<Esc>:%s/<C-r><C-w>//gc<Left><Left><Left>]])

-- find & replace the selected text
map('custom: Find & Replace the Selected', 'x', '<C-x>', [[y:%s/<C-r>"//gc<Left><Left><Left>]])
--   NOTE: <C-r>" outputs the last yanked text


-- increment/decrement the number
map('custom: Increment the Number', nx, '+', '<C-a>')
map('custom: Decrement the Number', nx, '-', '<C-x>')


-- toggle typewriter mode
map('custom: Typewriter Mode', nx, '<S-z>', fn.typewriter_mode)

