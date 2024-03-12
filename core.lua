local opt = vim.opt
local autocmd = vim.api.nvim_create_autocmd

---- GENERAL ----
-- clipboard support
opt.clipboard = 'unnamedplus'
-- mouse support ('a' for all modes)
opt.mouse = 'a'
-- decrease update time
--opt.updatetime = 250
--opt.timeoutlen = 300

---- UI ----
-- hide those ugly '~' (tilde) symbols
opt.fillchars = 'eob: '
-- line numbers
opt.number = true
opt.relativenumber = true
-- mode indicator
opt.showmode = true
-- sign column
opt.signcolumn = 'yes'
-- how new splits should be opened
opt.splitright = true
opt.splitbelow = true

---- EDITOR ----
-- show whitespace chars
opt.list = true
opt.listchars = {
	tab   = '» ',
	trail = '·',
	nbsp  = '␣'
}
-- break indent
opt.breakindent = true
-- preview substitutions as you type
opt.inccommand = 'split'
-- highlight the current line
opt.cursorline = true
-- minimal number of screen lines to keep above and below the cursor
opt.scrolloff = 10

---- SEARCH ----
-- case-insensitive search unless \C or capital in query
opt.ignorecase = true
opt.smartcase = true
-- set highlight on search
opt.hlsearch = true


---- LIBRARY ----

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

