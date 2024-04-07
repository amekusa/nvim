---- AUTO COMMANDS ----
local my = vim.g._custom
local conf = my.conf.autocmds
local autocmd = vim.api.nvim_create_autocmd

local function regex_ext(ext) -- returns a regex that matches with given file extensions
	if type(ext) ~= 'table' then ext = {ext} end
	return vim.regex([[\.\(]]..table.concat(ext, [[\|]])..[[\)$]])
end

if conf.trim_trailing_whitespace then
	autocmd('BufWritePre', {
		desc = 'Trim trailing whitespace on save',
		pattern = '*',
		callback = function(ctx)
			local ignore = {'md'}
			if regex_ext(ignore):match_str(ctx.file) then return end
			vim.cmd([[silent! %s/\s\+$//g]]) -- trim
		end
	})
end

if conf.detect_large_file then
	autocmd('BufEnter', {
		desc = 'Disable certain features on large files',
		callback = function(ctx)
			if vim.fn.getfsize(ctx.file) > conf.detect_large_file_size then
				if vim.fn.exists(':TSBufDisable') ~= 0 then -- disable treesitter modules
					vim.cmd('TSBufDisable autotag')
					vim.cmd('TSBufDisable highlight')
					vim.cmd('TSBufDisable incremental_selection')
					vim.cmd('TSBufDisable indent')
					vim.cmd('TSBufDisable playground')
					vim.cmd('TSBufDisable query_linter')
					vim.cmd('TSBufDisable rainbow')
					vim.cmd('TSBufDisable refactor.highlight_definitions')
					vim.cmd('TSBufDisable refactor.navigation')
					vim.cmd('TSBufDisable refactor.smart_rename')
					vim.cmd('TSBufDisable refactor.highlight_current_scope')
					vim.cmd('TSBufDisable textobjects.swap')
					--vim.cmd('TSBufDisable textobjects.move')
					vim.cmd('TSBufDisable textobjects.lsp_interop')
					vim.cmd('TSBufDisable textobjects.select')
				end
			end
		end
	})
end

