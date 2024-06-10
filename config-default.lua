---- CONFIG ----
-- @version 1.1
-- copy this file (config-default.lua) as config.lua

return {
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
			'spellfile',    -- spell checking(?)
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
		close_with_esc = true,
		close_with_esc_ft = {'help', 'man', 'qf', 'lazy'},
		typewriter_mode = true,
		typewriter_mode_ft = {'help', 'man'},
		scoped_buffers = true,
	},
}

