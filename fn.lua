---- FUNCTIONS ----
local fn = {}

fn.map = function(desc, mode, from, to, opts)
	if not opts then opts = {} end
	opts.desc = desc
	return vim.keymap.set(mode, from, to, opts)
end

fn.close = function(buf, force)
	if buf == nil then
		buf = vim.api.nvim_get_current_buf()
	end
	vim.cmd.bprevious()  -- manually switch to the prev buffer
	if force -- delete the given (or current) buffer in background
		then vim.cmd('bw! '..buf)
		else vim.cmd('bw '..buf)
	end
	-- NOTE:
	--   Due to ':bd (nil)' not respecting 'buflisted',
	--   it can cause undesired side-effects.
	--   This function does the better job.
end

return fn
