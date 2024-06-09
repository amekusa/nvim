---- CONFIG ----
-- @version 1.0
-- copy this file (config-default.lua) as config.lua

return {
	options = {
		enable = true,
	},
	keymaps = {
		enable = true,
	},
	plugins = {
		enable = true,
		themes = true,
	},
	autocmds = {
		enable = true,
		trim_trailing_whitespace = true,
		detect_large_file = true,
		detect_large_file_size        =  200 * 1024,
		detect_large_file_size_bigger = 1000 * 1024,
		clear_jumplist = true,
		auto_stopinsert = true,
		close_with_esc = true,
		close_with_esc_ft = {'help', 'man', 'qf', 'lazy'},
		typewriter_mode = true,
		typewriter_mode_ft = {'help', 'man'},
	},
}

