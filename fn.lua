---- FUNCTIONS ----
local vim = vim
local my = _custom
local fn = {}

-- Notifies the user with the given message.
-- levels:
--   - DEBUG
--   - ERROR
--   - INFO
--   - TRACE
--   - WARN
--   - OFF
function fn.log(msg, level)
	vim.api.nvim_notify(msg, vim.log.levels[level or 'INFO'], {})
end

-- Returns whether the given value is truthy
function fn.yes(x)
	if not x then return false end
	return x ~= '' and x ~= 0
end

-- Returns whether the given value is falsey
function fn.no(x)
	if not x then return true end
	return x == '' or x == 0
end

-- Writes a file with the given date
function fn.write(file, data, mode)
	local f = io.open(file, mode or 'w')
	if not f then
		return fn.log("fn.write(): failed to open: "..file, 'ERROR')
	end
	f:write(data)
	f:close()
end

-- Returns an array of keys in the given table
function fn.table_keys(t)
	local r,i = {},1
	for k,_ in pairs(t) do
		r[i] = k
		i = i + 1
	end
	return r
end

-- Returns an array of values in the given table
function fn.table_values(t)
	local r,i = {},1
	for _,v in pairs(t) do
		r[i] = v
		i = i + 1
	end
	return r
end

-- Creates a copy of the given table
function fn.table_copy(t)
	local r = {}
	for k,v in pairs(t) do
		r[k] = v
	end
	return r
end

-- Merges one table into another
function fn.table_merge(t1, t2, new)
	local r
	if new
		then r = fn.table_copy(t1)
		else r = t1
	end
	for k,v in pairs(t2) do
		r[k] = v
	end
	return r
end

-- Returns whether `str` starts with `with`
function fn.starts(str, with)
   return string.sub(str, 1, string.len(with)) == with
end

-- Alias of `vim.keymap.set` but the description comes first
function fn.map(desc, mode, from, to, opts, opts2)
	if not opts then opts = {} end
	opts.desc = desc
	if opts2 then -- merge
		for k,v in pairs(opts2) do opts[k] = v end
	end
	return vim.keymap.set(mode, from, to, opts)
end

-- Converts the given special keycode (like <CR>, <Tab>, or <Esc>, etc.)
-- into the format that is applicable to `feedkeys()`
local keycodes = {}
function fn.key(code)
	if not keycodes[code] then
		keycodes[code] = vim.api.nvim_replace_termcodes(code, true, false, true)
	end
	return keycodes[code]
end

--- Smartly indents the current line
function fn.smart_indent()
	local _
	local line = vim.api.nvim_get_current_line()
	if line == '' then -- empty line
		vim.cmd.startinsert()
		local lnum     = vim.api.nvim_win_get_cursor(0)[1]
		local lnum_max = vim.api.nvim_buf_line_count(0)

		-- get indents in the prev line
		local indents_prev = ''
		if lnum > 1 then
			_,_,indents_prev = vim.api.nvim_buf_get_lines(0, lnum - 2, lnum - 1, true)[1]:find([[^(%s*)]])
		end

		-- get indents in the next line
		local indents_next = ''
		if lnum < lnum_max then
			_,_,indents_next = vim.api.nvim_buf_get_lines(0, lnum, lnum + 1, true)[1]:find([[^(%s*)]])
		end

		-- use longer one
		local len_prev = indents_prev:len()
		local len_next = indents_next:len()
		if len_prev > 0 or len_next > 0 then
			if len_prev > len_next
				then vim.api.nvim_set_current_line(indents_prev)
				else vim.api.nvim_set_current_line(indents_next)
			end
			vim.api.nvim_win_set_cursor(0, {lnum, 1000}) -- set cursor to EoL
		else
			vim.api.nvim_feedkeys(fn.key('<Tab>'), 'n', false) -- just type <Tab>
		end
	else
		vim.cmd('>') -- shift the current line to right
	end
end

-- Closes the given buffer
function fn.buf_close(buf, force, bufs)
	local curr = vim.api.nvim_get_current_buf()
	buf = buf or curr
	bufs = bufs or vim.fn.getbufinfo({buflisted = 1})

	-- if the buffer is current, move to the prev/next buffer first
	if buf == curr and fn.buf_is_last(buf, bufs)
		then fn.buf_cycle(-1, bufs)
		else fn.buf_cycle(1, bufs)
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
function fn.buf_is_last(buf, bufs)
	buf = buf or vim.api.nvim_get_current_buf()
	bufs = bufs or vim.fn.getbufinfo({buflisted = 1})
	return bufs[#bufs] and (bufs[#bufs].bufnr == buf)
end

-- Shows the given buffer
function fn.buf_show(buf)
	buf = type(buf) == 'table' and buf or vim.fn.getbufinfo(buf)[1]
	if not buf then return fn.log("buf_show(): invalid buffer", 'ERROR') end
	vim.fn.bufload(buf.bufnr)

	local win = buf.variables.scope
	if win then win = vim.fn.getwininfo(win)[1] end
	if not win then win = vim.fn.getwininfo(buf.windows[1] or vim.api.nvim_get_current_win())[1] end

	vim.api.nvim_set_current_tabpage(win.tabnr)
	vim.api.nvim_set_current_win(win.winid)
	vim.api.nvim_win_set_buf(win.winid, buf.bufnr)
end


-- Cycles through buffers
function fn.buf_cycle(to, bufs, from)
	from = from or vim.api.nvim_get_current_buf()
	bufs = bufs or vim.fn.getbufinfo({buflisted = 1})
	local n = #bufs
	for i = 1, n do
		if bufs[i].bufnr == from then
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
	if type(my.var.buf_history) == 'table' and #my.var.buf_history > 0 then
		fn.buf_cycle(to, bufs, my.var.buf_history[#my.var.buf_history])
	end
end

-- Set the current window to "typewriter" mode
function fn.typewriter_mode(set)
	if set == nil then -- toggle
		set = vim.wo.scrolloff <= vim.go.scrolloff
	end
	if set then
		fn.log("typewriter mode: ON")
		vim.wo.scrolloff = 100
	else
		fn.log("typewriter mode: OFF")
		vim.wo.scrolloff = vim.go.scrolloff
	end
end

return fn

