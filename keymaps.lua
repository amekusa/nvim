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


-- remap operator w to aw
map('custom: Remap operator:w ➔ aw', 'o', 'w', 'aw')
--   NOTE: This makes `dw` to be `daw`.


-- prev/next WORD
map('custom: Prev WORD', nxo, '<M-Left>',  'B')
map('custom: Prev WORD', 'i', '<M-Left>',  '<C-o>B')
map('custom: Prev WORD', 't', '<M-Left>',  '<Esc>B')
map('custom: Next WORD', nxo, '<M-Right>', 'W')
map('custom: Next WORD', 'i', '<M-Right>', '<C-o>W')
map('custom: Next WORD', 't', '<M-Right>', '<Esc>W')

-- delete word (option + backspace)
map('custom: Delete Word', 'n', '<M-BS>', 'bdaw')
map('custom: Delete Word', 'i', '<M-BS>', '<Esc>bdaw<Cmd>startinsert<CR>')


-- first/last char
map('custom: First Char', nxo, 'H', '^')
map('custom: Last Char',  nxo, 'L', '$')

-- home key
map('custom: First Char', nxo, '<Home>', '^')
map('custom: First Char', 'i', '<Home>', '<C-o>^')


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
map('custom: Insert Line Below', 'n', '<S-CR>', 'o')
map('custom: Insert Line Below', 'i', '<S-CR>', '<Esc>o')
map('custom: Insert Line Above', 'n', '<C-CR>', 'O')
map('custom: Insert Line Above', 'i', '<C-CR>', '<Esc>O')

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
map('custom: Up with Visual Mode',    'i', '<S-Up>',    '<Right><Esc>V')
map('custom: Right with Visual Mode', 'i', '<S-Right>', '<Right><Esc>v')
map('custom: Down with Visual Mode',  'i', '<S-Down>',  '<Right><Esc>V')
map('custom: Left with Visual Mode',  'i', '<S-Left>',  '<Esc>v')
map('custom: Up with Visual Mode',    'n', '<S-Up>',    'V')
map('custom: Right with Visual Mode', 'n', '<S-Right>', 'v<Right>')
map('custom: Down with Visual Mode',  'n', '<S-Down>',  'V')
map('custom: Left with Visual Mode',  'n', '<S-Left>',  'v<Left>')
map('custom: Up',                     'x', '<S-Up>',    '<Up>')
map('custom: Right',                  'x', '<S-Right>', '<Right>')
map('custom: Down',                   'x', '<S-Down>',  '<Down>')
map('custom: Left',                   'x', '<S-Left>',  '<Left>')


-- mode switching
---- to normal mode
map('custom: Normal Mode', 'i', 'jk',    '<Esc><Right>')
map('custom: Normal Mode', 'i', 'kj',    '<Esc>')
map('custom: Normal Mode', 't', '<Esc>', '<C-\\><C-n>')
map('custom: Normal Mode', 'c', '<C-q>', '<C-c>')
--   NOTE: for some reason, <Esc> as rhs for command line, works like <Esc><CR> actually,
--         which is unwanted behavior. so, use <C-c> instead.

---- to insert mode
map('custom: Insert Mode', 'x', 'i', '<Esc><Cmd>startinsert<CR>')

---- to visual mode
map('custom: Visual-Block Mode', 'x', 'v', '<C-v>')


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

-- find & replace the word
map('custom: Find & Replace the Word', 'n', '<Leader>r', [[:%s/<C-r><C-w>//gc<Left><Left><Left>]])

-- find & replace the selected text
map('custom: Find & Replace the Selected', 'x', '<Leader>r', [[y:%s/<C-r>"//gc<Left><Left><Left>]])
--   NOTE: <C-r>" outputs the last yanked text


-- increment/decrement the number
map('custom: Increment the Number', nx, '+', '<C-a>')
map('custom: Decrement the Number', nx, '-', '<C-x>')


-- toggle typewriter mode
map('custom: Typewriter Mode', nx, '<S-z>', fn.typewriter_mode)

