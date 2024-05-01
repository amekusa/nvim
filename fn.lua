---- FUNCTIONS ----
local fn = {}

fn.map = function(desc, mode, from, to, opts)
	if not opts then opts = {} end
	opts.desc = desc
	return vim.keymap.set(mode, from, to, opts)
end

fn.close_buf = function(buf, force)
	if buf == nil then
		buf = vim.api.nvim_get_current_buf()
	end
	if fn.is_last_buf(buf, true)
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

fn.is_last_buf = function(buf, listed)
	if buf == 0 then buf = vim.api.nvim_get_current_buf() end
	local bufs = vim.api.nvim_list_bufs()
	if not listed then return buf == bufs[#bufs] end
	for i = #bufs, 1, -1 do
		if vim.fn.getbufinfo(bufs[i])[1].listed == 1 then
			return buf == bufs[i]
		end
	end
	return false
end

return fn
