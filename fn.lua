---- FUNCTIONS ----
local fn = {}

-- Sets the autoloader callback
local autoloader = nil
fn.set_autoloader = function(loader)
	autoloader = loader
end

-- Adds an entry to pass to the autoloader.
-- Each entry gets loaded when user entered a command that starts with respective prefix
local autoloads = nil
fn.autoload = function(arg, prefix)
	if autoloads then
		table.insert(autoloads, {arg, prefix})
	else
		autoloads = {{arg, prefix}}
		vim.api.nvim_create_autocmd('CmdUndefined', {
			desc = 'custom: Dynamic Autoloader',
			callback = function(ctx)
				if not autoloader then return end
				local cmd = ctx.match
				for i = 1, #autoloads, 1 do
					local v = autoloads[i]
					if fn.starts(cmd, v[2]) then
						table.remove(autoloads, i)
						autoloader(v[1])
						return
					end
				end
			end
		})
	end
end

-- Notifies the user with the given message.
-- levels:
--   - DEBUG
--   - ERROR
--   - INFO
--   - TRACE
--   - WARN
--   - OFF
fn.log = function(msg, level)
	vim.api.nvim_notify(msg, vim.log.levels[level or 'INFO'], {})
end

-- Returns whether the given value is truthy
fn.yes = function(x)
	if not x then return false end
	return x ~= '' and x ~= 0
end

-- Returns whether the given value is falsey
fn.no = function(x)
	if not x then return true end
	return x == '' or x == 0
end

-- Returns an array of keys in the given table
fn.table_keys = function(t)
	local r,i = {},1
	for k,_ in pairs(t) do
		r[i] = k
		i = i + 1
	end
	return r
end

-- Returns an array of values in the given table
fn.table_values = function(t)
	local r,i = {},1
	for _,v in pairs(t) do
		r[i] = v
		i = i + 1
	end
	return r
end

-- Returns whether `str` starts with `with`
fn.starts = function(str, with)
   return string.sub(str, 1, string.len(with)) == with
end

-- Alias of `vim.keymap.set` but the description comes first
fn.map = function(desc, mode, from, to, opts)
	if not opts then opts = {} end
	opts.desc = desc
	return vim.keymap.set(mode, from, to, opts)
end

-- Converts the given special keycode (like <CR>, <Tab>, or <Esc>, etc.)
-- into the format that is applicable to `feedkeys()`
local keys = {}
fn.key = function(code)
	if not keys[code] then
		keys[code] = vim.api.nvim_replace_termcodes('<'..code..'>', true, false, true)
	end
	return keys[code]
end

-- Closes the given buffer
fn.buf_close = function(buf, force)
	if fn.no(buf) then
		buf = vim.api.nvim_get_current_buf()
	end
	if fn.buf_is_last(buf, true)
		then vim.cmd.bprevious()
		else vim.cmd.bnext()
	end
	if force -- delete the given (or current) buffer in background
		then vim.cmd('bw! '..buf)
		else vim.cmd('bw '..buf)
	end
	-- NOTE:
	--   Due to ':bd (nil)' not respecting 'buflisted',
	--   it can cause undesired side-effects.
	--   This function does the better job.
end

-- Returns whether the given buffer is the last entry
fn.buf_is_last = function(buf, listed)
	if fn.no(buf) then buf = vim.api.nvim_get_current_buf() end
	local bufs = vim.api.nvim_list_bufs()
	if not listed then return buf == bufs[#bufs] end
	for i = #bufs, 1, -1 do
		if vim.fn.getbufinfo(bufs[i])[1].listed == 1 then
			return buf == bufs[i]
		end
	end
	return false
end

-- Shows the given buffer
fn.buf_show = function(buf)
	buf = type(buf) == 'table' and buf or vim.fn.getbufinfo(buf)[1]
	if not buf then return fn.log("buf_switch(): invalid buffer", 'ERROR') end
	vim.fn.bufload(buf.bufnr)

	local win = buf.variables.scope
	if win then win = vim.fn.getwininfo(win)[1] end
	if not win then win = vim.fn.getwininfo(buf.windows[1] or vim.api.nvim_get_current_win())[1] end

	vim.api.nvim_set_current_tabpage(win.tabnr)
	vim.api.nvim_set_current_win(win.winid)
	vim.api.nvim_win_set_buf(win.winid, buf.bufnr)
end

-- Rotates buffers
fn.buf_rotate = function(to)
	local curr = vim.api.nvim_get_current_buf()
	local bufs = vim.fn.getbufinfo({buflisted = 1, bufloaded = 1})
	local n = #bufs
	for i = 1, n do
		if bufs[i].bufnr == curr then
			i = i + to
			if i <= 0 then
				fn.buf_show(bufs[n])
			elseif i > n then
				fn.buf_show(bufs[1])
			else
				fn.buf_show(bufs[i])
			end
			return
		end
	end
end

-- Indents the current line
fn.indent = function()
	local line = vim.api.nvim_get_current_line()
	if line == '' then
		vim.cmd.stopinsert()
		vim.api.nvim_feedkeys('cc', 'n', false)
	else
		vim.cmd.stopinsert()
		vim.api.nvim_feedkeys('^i'..fn.key('tab'), 'n', false)
	end
end

-- set the current window to "typewriter" mode
local scrolloff = vim.o.scrolloff
fn.typewriter_mode = function(set)
	if set == nil then -- toggle
		set = vim.wo.scrolloff <= scrolloff
	end
	if set then
		vim.wo.scrolloff = 100
		vim.api.nvim_feedkeys('zz', 'n', false)
	else
		vim.wo.scrolloff = scrolloff
	end
end

return fn

