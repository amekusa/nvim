---[ amekusa's NeoVim Configuration ]---
---- github.com/amekusa/nvim


---- OS RELATED ----
-- clipboard support
vim.opt.clipboard = 'unnamedplus'
-- mouse support ('a' for all modes)
vim.opt.mouse = 'a'
-- enable 24-bit color
vim.opt.termguicolors = true


---- PERFORMANCE ----
-- decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.lazyredraw = true
--vim.opt.regexpengine = 1


---- UI ----
-- hide those ugly '~' (tilde) symbols
vim.opt.fillchars = 'eob: '
-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true
-- mode indicator
vim.opt.showmode = true
-- sign column
vim.opt.signcolumn = 'yes'
-- how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true


---- EDITOR ----
-- show whitespace chars
vim.opt.list = true
vim.opt.listchars = {
	tab   = '» ',
	trail = '·',
	nbsp  = '␣'
}
-- break indent
vim.opt.breakindent = true
-- preview substitutions as you type
vim.opt.inccommand = 'split'
-- highlight the current line
vim.opt.cursorline = true
-- minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 24


---- SEARCH ----
-- case-insensitive search unless \C or capital in query
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- set highlight on search
vim.opt.hlsearch = true


---- KEYMAPS & PLUGINS ----
ns_custom = (...)..'.'
require(ns_custom..'keymaps')
require(ns_custom..'plugins')


---- AUTO COMMANDS ----
local autocmd = vim.api.nvim_create_autocmd

local function regex_ext(ext) -- returns a regex that matches with given file extensions
	if type(ext) ~= 'table' then ext = {ext} end
	return vim.regex([[\.\(]]..table.concat(ext, [[\|]])..[[\)$]])
end

autocmd('BufWritePre', {
	desc = 'Trim trailing whitespaces on save',
	pattern = '*',
	callback = function(ev)
		local ignore = {'md'}
		if regex_ext(ignore):match_str(ev.file) then return end
		vim.cmd([[silent! %s/\s\+$//g]]) -- trim
	end
})

