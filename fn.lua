---- FUNCTIONS ----
local vim = vim
local api = vim.api
local fn = vim.fn
local my = _custom
local M = {}

-- Notifies the user with the given message.
-- levels:
--   - DEBUG
--   - ERROR
--   - INFO
--   - TRACE
--   - WARN
--   - OFF
function M.log(msg, level)
	api.nvim_notify(msg, vim.log.levels[level or 'INFO'], {})
end

-- Returns whether the given value is truthy
function M.yes(x)
	if not x then return false end
	return x ~= '' and x ~= 0
end

-- Returns whether the given value is falsey
function M.no(x)
	if not x then return true end
	return x == '' or x == 0
end

-- Writes a file with the given date
function M.write(file, data, mode)
	local f = io.open(file, mode or 'w')
	if not f then
		return M.log("write(): failed to open: "..file, 'ERROR')
	end
	f:write(data)
	f:close()
end

-- Searches a value in the given array and returns the index or 0 if not found
function M.arr_index_of(a, find)
	for i = 1, #a do
		if a[i] == find then return i end
	end
	return 0
end

-- Returns an array of keys in the given table
function M.tbl_keys(t)
	local r,i = {},1
	for k,_ in pairs(t) do
		r[i] = k
		i = i + 1
	end
	return r
end

-- Returns an array of values in the given table
function M.tbl_values(t)
	local r,i = {},1
	for _,v in pairs(t) do
		r[i] = v
		i = i + 1
	end
	return r
end

-- Creates a copy of the given table
function M.tbl_copy(t)
	local r = {}
	for k,v in pairs(t) do
		r[k] = v
	end
	return r
end

-- Merges one table into another
function M.tbl_merge(t1, t2, new)
	local r
	if new
		then r = M.tbl_copy(t1)
		else r = t1
	end
	if t2 then
		for k,v in pairs(t2) do
			r[k] = v
		end
	end
	return r
end

-- Returns whether `str` starts with `with`
function M.starts(str, with)
   return string.sub(str, 1, string.len(with)) == with
end

-- Alias of `vim.keymap.set` but the description comes first
function M.map(desc, mode, from, to, opts)
	if opts
		then opts.desc = desc
		else opts = {desc = desc}
	end
	return vim.keymap.set(mode, from, to, opts)
end

do
	local keycodes = {}

	-- Converts the given special keycode (like <CR>, <Tab>, or <Esc>, etc.)
	-- into the format that is applicable to `feedkeys()`
	function M.key(code)
		if not keycodes[code] then
			keycodes[code] = api.nvim_replace_termcodes(code, true, false, true)
		end
		return keycodes[code]
	end
end

--- Smartly indents the current line
function M.smart_indent()
	local _
	local line = api.nvim_get_current_line()
	if line == '' then -- empty line
		vim.cmd.startinsert()
		local lnum     = api.nvim_win_get_cursor(0)[1]
		local lnum_max = api.nvim_buf_line_count(0)

		-- get indents in the prev line
		local indents_prev = ''
		if lnum > 1 then
			_,_,indents_prev = api.nvim_buf_get_lines(0, lnum - 2, lnum - 1, true)[1]:find([[^(%s*)]])
		end

		-- get indents in the next line
		local indents_next = ''
		if lnum < lnum_max then
			_,_,indents_next = api.nvim_buf_get_lines(0, lnum, lnum + 1, true)[1]:find([[^(%s*)]])
		end

		-- use longer one
		local len_prev = indents_prev:len()
		local len_next = indents_next:len()
		if len_prev > 0 or len_next > 0 then
			if len_prev > len_next
				then api.nvim_set_current_line(indents_prev)
				else api.nvim_set_current_line(indents_next)
			end
			api.nvim_win_set_cursor(0, {lnum, 1000}) -- set cursor to EoL
		else
			api.nvim_feedkeys(M.key('<Tab>'), 'n', false) -- just type <Tab>
		end
	else
		vim.cmd('>') -- shift the current line to right
	end
end

-- Closes the given buffer
function M.buf_close(buf, force, bufs)
	local curr = api.nvim_get_current_buf()
	buf = fn.getbufinfo(buf or curr)[1]
	if buf.changed ~= 0 then
		local choice = fn.confirm(
			'The buffer has unsaved changes. Force close?',
			'&Yes\n&No',
			2  -- default choice (2 = No)
		)
		if choice == 1
			then force = true
			else return
		end
	end
	bufs = bufs or fn.getbufinfo({buflisted = 1})

	-- if the buffer is current, move to the prev/next buffer first
	if buf.bufnr == curr and M.buf_is_last(buf.bufnr, bufs)
		then M.buf_cycle(-1, bufs)
		else M.buf_cycle(1, bufs)
	end
	if force -- delete the given (or current) buffer in background
		then vim.cmd('bd! '..buf.bufnr)
		else vim.cmd('bd '..buf.bufnr)
	end
	-- NOTE:
	--   Due to ':bd (nil)' not respecting 'buflisted',
	--   it can cause undesired side-effects.
	--   This function does the better job.
end

-- Returns whether the given buffer is the last entry
function M.buf_is_last(buf, bufs)
	buf = buf or api.nvim_get_current_buf()
	bufs = bufs or fn.getbufinfo({buflisted = 1})
	return bufs[#bufs] and (bufs[#bufs].bufnr == buf)
end

-- Shows the given buffer
function M.buf_show(buf)
	buf = type(buf) == 'table' and buf or fn.getbufinfo(buf)[1]
	if not buf then return M.log("buf_show(): invalid buffer", 'ERROR') end
	fn.bufload(buf.bufnr)

	local win = buf.variables.scope
	if win then win = fn.getwininfo(win)[1] end
	if not win then win = fn.getwininfo(buf.windows[1] or api.nvim_get_current_win())[1] end

	api.nvim_set_current_tabpage(win.tabnr)
	api.nvim_set_current_win(win.winid)
	api.nvim_win_set_buf(win.winid, buf.bufnr)
end

-- Cycles through buffers
function M.buf_cycle(to, bufs, from)
	from = from or api.nvim_get_current_buf()
	bufs = bufs or fn.getbufinfo({buflisted = 1})
	local n = #bufs
	for i = 1, n do
		if bufs[i].bufnr == from then
			i = i + to
			if i <= 0 then
				M.buf_show(bufs[n])
			elseif i > n then
				M.buf_show(bufs[1])
			else
				M.buf_show(bufs[i])
			end
			return
		end
	end
	if type(my.var.buf_history) == 'table' and #my.var.buf_history > 0 then
		M.buf_cycle(to, bufs, my.var.buf_history[#my.var.buf_history])
	end
end

-- Set the current window to "typewriter" mode
function M.typewriter_mode(set)
	if set == nil then -- toggle
		set = vim.wo.scrolloff <= vim.go.scrolloff
	end
	if set then
		M.log("typewriter mode: ON")
		vim.wo.scrolloff = 100
	else
		M.log("typewriter mode: OFF")
		vim.wo.scrolloff = vim.go.scrolloff
	end
end

return M

