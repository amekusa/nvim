---- CONFIG ----
-- @version 1.1
-- copy this file (config-default.lua) as config.lua

return {
	os = nil, -- linux/mac/win or nil to autodetect
	loader = true, -- enable vim.loader ?
	options = {
		enable = true,
	},
	keymaps = {
		enable = true,
	},
	plugins = {
		enable = true,
		themes = true,
		tree = {
			autoclose = true,
		},
		disable_builtins = {
			-- 'editorconfig', -- editorconfig integration
			'gzip',         -- editing *.gzip directly
			-- 'health',       -- :checkhealth command
			-- 'man',          -- :Man command
			-- 'matchit',      -- matching brackets with `%`
			-- 'matchparen',   -- matching parens
			'netrwPlugin',  -- netrw plugins
			-- 'nvim',         -- :Inspect, :InspectTree commands
			'rplugin',      -- remote plugins
			'shada',        -- persistent data between sessions
			-- 'spellfile',    -- whitelists for the spell checker
			'tarPlugin',    -- editing *.tar directly
			'tohtml',       -- 2html integration(?)
			-- 'tutor',        -- vimtutor
			'zipPlugin',    -- editing *.zip directly
		},
	},
	autocmds = {
		enable = true,
		trim_trailing_whitespace = true,
		detect_large_file = true,
		detect_large_file_size        =  200 * 1024,
		detect_large_file_size_bigger = 1000 * 1024,
		clear_jumplist = true,
		auto_stopinsert = true,
		auto_switch_inputs = true,
		auto_switch_inputs_opts = {
			linux = {
				enable = true,
				cmd_get = 'ibus engine',
				cmd_set = 'ibus engine',
				input_n = nil, -- auto
			},
			mac = {
				enable = true,
				cmd_get = 'im-select',
				cmd_set = 'im-select',
				input_n = nil, -- auto
				-- input_n = 'com.apple.keylayout.ABC',
				-- input_n = 'com.apple.keylayout.US',
				-- input_n = 'com.apple.keylayout.USExtended',
			},
			win = {
				enable = true,
				cmd_get = 'im-select.exe',
				cmd_set = 'im-select.exe',
				input_n = nil, -- auto
			},
		},
		close_with_esc = true,
		close_with_esc_ft = {'help', 'man', 'qf', 'lazy'},
		typewriter_mode = true,
		typewriter_mode_ft = {'help', 'man'},
		buffer_history = true,
		buffer_history_limit = 15,
		scoped_buffers = true,
	},
}

