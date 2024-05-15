---[ amekusa's NeoVim Configuration ]---
---- github.com/amekusa/nvim

-- global
local my = {
	ns = (...), -- namespace
	conf = {
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
			detect_large_file_size = 256 * 1024,
			clear_jumplist = true,
			close_with_esc = true,
			close_with_esc_ft = {'help', 'man', 'qf', 'lazy'},
			typewriter_mode = true,
			typewriter_mode_ft = {'help', 'man'},
		},
	},
}

-- root path
my.path = vim.fn.stdpath('config')..'/lua/'..my.ns:gsub('%.', '/') -- replace '.' in namespace with '/'

-- vim options
if my.conf.options.enable then require(my.ns..'.options') end

-- custom functions
my.fn = require(my.ns..'.fn')

-- save to global
vim.g._custom = my

if my.conf.keymaps.enable then require(my.ns..'.keymaps') end
if my.conf.plugins.enable then require(my.ns..'.plugins') end
if my.conf.autocmds.enable then require(my.ns..'.autocmds') end

