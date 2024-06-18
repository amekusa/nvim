---- AUTO COMMANDS ----
local vim = vim
local my = _custom
local map = my.fn.map
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
	-- backup the original config values
	local wrap = vim.o.wrap
	local cursorline = vim.o.cursorline

	autocmd('BufEnter', {
		desc = 'Disable certain features on large files',
		callback = function(ctx)
			local size = vim.fn.getfsize(ctx.file)
			if size > conf.detect_large_file_size then
				if vim.fn.exists(':TSBufDisable') ~= 0 then -- disable treesitter modules
					vim.cmd('TSBufDisable autotag')
					vim.cmd('TSBufDisable highlight')
					vim.cmd('TSBufDisable incremental_selection')
					vim.cmd('TSBufDisable indent')
					vim.cmd('TSBufDisable playground')
					vim.cmd('TSBufDisable query_linter')
					vim.cmd('TSBufDisable rainbow')
					vim.cmd('TSBufDisable refactor.highlight_current_scope')
					vim.cmd('TSBufDisable refactor.highlight_definitions')
					vim.cmd('TSBufDisable refactor.navigation')
					vim.cmd('TSBufDisable refactor.smart_rename')
					vim.cmd('TSBufDisable textobjects.swap')
					--vim.cmd('TSBufDisable textobjects.move')
					vim.cmd('TSBufDisable textobjects.lsp_interop')
					vim.cmd('TSBufDisable textobjects.select')
				end
				if size > conf.detect_large_file_size_bigger then
					vim.bo.syntax = 'OFF'
				end
				vim.bo.synmaxcol = 200
				vim.wo.wrap = false -- this is the most effective hack
				vim.wo.cursorline = false
				my.fn.log("large file detected: disabled some features", 'WARN')
			else
				-- restore the original config values
				vim.wo.wrap = wrap
				vim.wo.cursorline = cursorline
			end
		end
	})
end

if conf.clear_jumplist then
	autocmd('VimEnter', {
		desc = 'Clear jumplist on start',
		callback = function()
			vim.cmd.clearjumps()
		end
	})
end

if conf.auto_stopinsert then
	autocmd({'FocusLost', 'WinLeave'}, {
		desc = 'Automatically escape insert mode',
		callback = function()
			vim.cmd.stopinsert()
		end
	})
end

if conf.close_with_esc then
	autocmd('FileType', {
		pattern = conf.close_with_esc_ft,
		callback = function(ctx)
			map('custom: Close', 'n', '<Esc>', '<Cmd>bw!<CR>', {buffer = ctx.buf})
		end
	})
end

if conf.typewriter_mode then
	autocmd('FileType', {
		pattern = conf.typewriter_mode_ft,
		callback = function(ctx)
			my.fn.typewriter_mode(true)
		end
	})
end

if conf.scoped_buffers then
	autocmd('BufWinEnter', {
		callback = function(ctx)
			local buf = vim.fn.getbufinfo(ctx.buf)[1]
			local win = buf.windows and buf.windows[1]
			if win then
				vim.api.nvim_buf_set_var(buf.bufnr, 'scope', win) -- save window id
			end
		end
	})
	autocmd('BufLeave', {
		callback = function(ctx)
			local buf = vim.fn.getbufinfo(ctx.buf)[1]
			if buf.listed == 1 then
				my.var.latest_buf = buf.bufnr
			end
		end
	})
end

