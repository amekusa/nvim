---- PLUGINS ----
local my = vim.g._custom
local map = my.fn.map
local on_read = {'BufReadPre', 'BufNewFile'}

local plugins = {
	{
		-- align text interactively (****.)
		'echasnovski/mini.align', enabled = true,
		event = on_read,
		config = function()
			require('mini.align').setup({
				-- options
			})
		end
	},
	{
		-- jump around with keypresses (*****)
		'folke/flash.nvim', enabled = true,
		event = 'VeryLazy',
		config = function()
			require('flash').setup({
				search = {
					mode = 'exact', -- exact/search/fuzzy
					incremental = true,
					multi_window = false,
				},
				jump = {
					nohlsearch = true, -- clear highlight after jump?
					autojump = true, -- automatically jump when there is only one match?
				},
				label = {
					uppercase = false, -- allow uppercase labels?
				},
				modes = {
					search = { -- '/' mode options
						enabled = true,
					},
					char = { -- 'f' mode options
						enabled = true,
						jump_labels = true, -- show jump labels?
						multi_line = true, -- multi-line or current-line-only
						keys = {'f','F','t','T'},
						label = {
							exclude = 'fthjkliardc', -- exclude these letters from jump labels
						},
					},
				},
			})
		end
	},
	{
		-- automatically close brackets (****.)
		'windwp/nvim-autopairs', enabled = true,
		event = 'VeryLazy',
		config = function()
			require('nvim-autopairs').setup({
				-- options
			})
		end
	},
	{
		-- guess indent style (***..)
		'nmac427/guess-indent.nvim', enabled = true,
		event = on_read,
		config = function()
			require('guess-indent').setup({
				auto_cmd = true,
				override_editorconfig = false,
				filetype_exclude = {
					'netrw',
					'tutor',
				},
				buftype_exclude = {
					'help',
					'nofile',
					'terminal',
					'prompt',
				},
			})
		end
	},
	{
		-- file-tree widget (***..)
		'nvim-tree/nvim-tree.lua', enabled = true,
		dependencies = {'nvim-tree/nvim-web-devicons'},
		lazy = false,
		init = function()
			-- disable netrw
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		config = function()
			local api = require('nvim-tree.api')
			require('nvim-tree').setup({
				filters = {
					git_ignored = false, -- do not hide ignored files
					custom = {
						'.git',
						'.DS_Store',
						'Thumbs.db',
					},
				},
				update_focused_file = {
					enable = true, -- highlight the current buffer
				},
				modified = {
					enable = true, -- highlight modified files
				},
				diagnostics = {
					enable = true, -- highlight the files with issues
				},
				renderer = {
					special_files = {},
					highlight_git = 'name', -- none/icon/name/all
					highlight_diagnostics = 'none',
					highlight_opened_files = 'name',
					highlight_modified = 'none',
					icons = {
						show = {
							git = false,
						},
						web_devicons = {
							file = {
								enable = true,
								color = true,
							},
							folder = {
								enable = false,
								color = false,
							},
						},
					},
				},
				on_attach = function(buf)
					local opts = {buffer = buf, nowait = true}
					map('nvim-tree: CD',                      'n', '<C-]>',          api.tree.change_root_to_node,       opts)
					--map('nvim-tree: Open: In Place',        'n', '<C-e>',          api.node.open.replace_tree_buffer,  opts)
					map('nvim-tree: Info',                    'n', '<C-k>',          api.node.show_info_popup,           opts)
					--map('nvim-tree: Rename: Omit Filename', 'n', '<C-r>',          api.fs.rename_sub,                  opts)
					map('nvim-tree: Open: New Tab',           'n', '<C-t>',          api.node.open.tab,                  opts)
					map('nvim-tree: Open: Vertical Split',    'n', '<C-v>',          api.node.open.vertical,             opts)
					map('nvim-tree: Open: Horizontal Split',  'n', '<C-x>',          api.node.open.horizontal,           opts)
					map('nvim-tree: Close Directory',         'n', '<BS>',           api.node.navigate.parent_close,     opts)
					map('nvim-tree: Open',                    'n', '<CR>',           api.node.open.edit,                 opts)
					map('nvim-tree: Open Preview',            'n', '<Tab>',          api.node.open.preview,              opts)
					map('nvim-tree: Next Sibling',            'n', '>',              api.node.navigate.sibling.next,     opts)
					map('nvim-tree: Previous Sibling',        'n', '<',              api.node.navigate.sibling.prev,     opts)
					map('nvim-tree: Run Command',             'n', '.',              api.node.run.cmd,                   opts)
					map('nvim-tree: Up',                      'n', '-',              api.tree.change_root_to_parent,     opts)
					map('nvim-tree: Create',                  'n', 'a',              api.fs.create,                      opts)
					map('nvim-tree: Move Bookmarked',         'n', 'bmv',            api.marks.bulk.move,                opts)
					--map('nvim-tree: Toggle No Buffer',      'n', 'B',              api.tree.toggle_no_buffer_filter,   opts)
					map('nvim-tree: Copy',                    'n', 'c',              api.fs.copy.node,                   opts)
					--map('nvim-tree: Toggle Git Clean',      'n', 'C',              api.tree.toggle_git_clean_filter,   opts)
					map('nvim-tree: Prev Git',                'n', '[c',             api.node.navigate.git.prev,         opts)
					map('nvim-tree: Next Git',                'n', ']c',             api.node.navigate.git.next,         opts)
					map('nvim-tree: Delete',                  'n', 'd',              api.fs.remove,                      opts)
					map('nvim-tree: Trash',                   'n', 'D',              api.fs.trash,                       opts)
					map('nvim-tree: Expand All',              'n', 'E',              api.tree.expand_all,                opts)
					map('nvim-tree: Rename: Basename',        'n', 'e',              api.fs.rename_basename,             opts)
					--map('nvim-tree: Next Diagnostic',       'n', ']e',             api.node.navigate.diagnostics.next, opts)
					--map('nvim-tree: Prev Diagnostic',       'n', '[e',             api.node.navigate.diagnostics.prev, opts)
					map('nvim-tree: Clean Filter',            'n', 'F',              api.live_filter.clear,              opts)
					map('nvim-tree: Filter',                  'n', 'f',              api.live_filter.start,              opts)
					map('nvim-tree: Help',                    'n', 'g?',             api.tree.toggle_help,               opts)
					map('nvim-tree: Copy Absolute Path',      'n', 'gy',             api.fs.copy.absolute_path,          opts)
					map('nvim-tree: Toggle Dotfiles',         'n', 'H',              api.tree.toggle_hidden_filter,      opts)
					map('nvim-tree: Toggle Git Ignore',       'n', 'I',              api.tree.toggle_gitignore_filter,   opts)
					map('nvim-tree: Last Sibling',            'n', 'J',              api.node.navigate.sibling.last,     opts)
					map('nvim-tree: First Sibling',           'n', 'K',              api.node.navigate.sibling.first,    opts)
					map('nvim-tree: Toggle Bookmark',         'n', 'm',              api.marks.toggle,                   opts)
					map('nvim-tree: Open',                    'n', 'o',              api.node.open.edit,                 opts)
					map('nvim-tree: Open: No Window Picker',  'n', 'O',              api.node.open.no_window_picker,     opts)
					map('nvim-tree: Paste',                   'n', 'p',              api.fs.paste,                       opts)
					map('nvim-tree: Parent Directory',        'n', 'P',              api.node.navigate.parent,           opts)
					map('nvim-tree: Close',                   'n', 'q',              api.tree.close,                     opts)
					map('nvim-tree: Rename',                  'n', 'r',              api.fs.rename,                      opts)
					map('nvim-tree: Refresh',                 'n', 'R',              api.tree.reload,                    opts)
					--map('nvim-tree: Run System',            'n', 's',              api.node.run.system,                opts)
					--map('nvim-tree: Search',                'n', 'S',              api.tree.search_node,               opts)
					map('nvim-tree: Toggle Hidden',           'n', 'U',              api.tree.toggle_custom_filter,      opts)
					map('nvim-tree: Collapse',                'n', 'W',              api.tree.collapse_all,              opts)
					map('nvim-tree: Cut',                     'n', 'x',              api.fs.cut,                         opts)
					map('nvim-tree: Copy Name',               'n', 'y',              api.fs.copy.filename,               opts)
					map('nvim-tree: Copy Relative Path',      'n', 'Y',              api.fs.copy.relative_path,          opts)
					map('nvim-tree: Open',                    'n', '<2-LeftMouse>',  api.node.open.edit,                 opts)
					map('nvim-tree: CD',                      'n', '<2-RightMouse>', api.tree.change_root_to_node,       opts)
				end,
			})
			-- toggle focus nvim-tree
			map('nvim-tree: Toggle focus', {'n','v','i','t'}, '<C-e>', function()
				if api.tree.is_tree_buf() then -- is current pane nvim-tree?
					vim.cmd.wincmd('p') -- previous window (<C-w>p)
					return
				end
				-- switch to nvim-tree
				vim.cmd.stopinsert() -- force normal mode
				api.tree.find_file({
					open = true, current_window = false,
					focus = true,
				})
			end)
		end
	},
	{
		-- smartly edit surrounding chars like {}, [], "", etc.
		'kylechui/nvim-surround', enabled = true,
		event = 'VeryLazy',
		config = function()
			require('nvim-surround').setup({
				-- options
			})
		end
	},
	{
		-- fuzzy finder (*****)
		'nvim-telescope/telescope.nvim', enabled = true,
		dependencies = {'nvim-lua/plenary.nvim'},
		event = 'VimEnter',
		config = function()
			require('telescope').setup({
				defaults = {
					layout_strategy = 'vertical',
				},
			})
			local api = require('telescope.builtin')
			map('telescope: Builtin',                'n', '<Leader>t',  api.builtin)
			map('telescope: Files',                  'n', '<Leader>ff', api.find_files)
			map('telescope: Grep',                   'n', '<Leader>fg', api.live_grep)
			map('telescope: Buffers',                'n', '<Leader>fb', api.buffers)
			map('telescope: Commands',               'n', '<Leader>f;', api.commands)
			map('telescope: Help',                   'n', '<Leader>fh', api.help_tags)
			map('telescope: Man Pages',              'n', '<Leader>fm', api.man_pages)
			map('telescope: Quickfix',               'n', '<Leader>fq', api.quickfix)
			map('telescope: Options',                'n', '<Leader>fo', api.vim_options)
			map('telescope: Registers',              'n', '<Leader>fr', api.registers)
			map('telescope: Keymaps',                'n', '<Leader>fk', api.keymaps)
			map('telescope: Treesitter Symbols',     'n', '<Leader>fs', api.treesitter)
			map('telescope: Commits',                'n', '<Leader>fC', api.git_commits)
			map('telescope: Commits for the Buffer', 'n', '<Leader>fc', api.git_bcommits)
			--map('telescope: Commits in the Range', 'v', '<Leader>fc', api.git_bcommits_range)
			--   NOTE: this causes error bc 'git_bcommits_range' is nil. no idea how to fix it.
		end
	},
	{
		-- cheatsheet
		'sudormrfbin/cheatsheet.nvim', enabled = true,
		dependencies = {'nvim-telescope/telescope.nvim'},
		event = 'VeryLazy',
		config = function()
			require('cheatsheet').setup({
				bundled_cheatsheets = {
					enabled = {'default'}
				},
				bundled_plugin_cheatsheets = {
					enabled = {'telescope.nvim'}
				},
			})
		end
	},
	{
		-- shows pending keybinds
		'folke/which-key.nvim', enabled = true,
		event = 'VeryLazy',
		config = function()
			local api = require('which-key')
			api.setup()
		end,
	},
	{
		-- shows git related signs to the gutter (*****)
		'lewis6991/gitsigns.nvim', enabled = true,
		event = on_read,
		config = function()
			local api = require('gitsigns')
			api.setup({
				signs = {
					add          = {text = '+'}, -- {text = '│'},
					change       = {text = '*'}, -- {text = '│'},
					delete       = {text = '_'},
					topdelete    = {text = '‾'},
					changedelete = {text = '~'},
					untracked    = {text = '┆'},
				},
				on_attach = function(buf)
					local opts = {buffer = buf}
					map('gitsigns: Stage Hunk',      'n', '<Leader>gs', api.stage_hunk,                               opts)
					map('gitsigns: Stage Hunk',      'v', '<Leader>gs', function() api.stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, opts)
					map('gitsigns: Reset Hunk',      'n', '<Leader>gr', api.reset_hunk,                               opts)
					map('gitsigns: Reset Hunk',      'v', '<Leader>gr', function() api.reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, opts)
					map('gitsigns: Stage Buffer',    'n', '<Leader>gS', api.stage_buffer,                             opts)
					map('gitsigns: Undo Stage Hunk', 'n', '<Leader>gu', api.undo_stage_hunk,                          opts)
					map('gitsigns: Reset Buffer',    'n', '<Leader>gR', api.reset_buffer,                             opts)
					map('gitsigns: Preview Hunk',    'n', '<Leader>gp', api.preview_hunk,                             opts)
					map('gitsigns: Blame Line',      'n', '<Leader>gb', function() api.blame_line({full = true}) end, opts)
					map('gitsigns: Toggle Blame',    'n', '<Leader>gB', api.toggle_current_line_blame,                opts)
					map('gitsigns: Diff',            'n', '<Leader>gd', api.diffthis,                                 opts)
					map('gitsigns: Diff',            'n', '<Leader>gD', function() api.diffthis('~') end,             opts)
					map('gitsigns: Toggle Deleted',  'n', '<Leader>gx', api.toggle_deleted,                           opts)

					map('gitsigns: Prev Hunk', 'n', '[c', function()
						if vim.wo.diff then return '[c' end
						vim.schedule(api.prev_hunk)
						return '<ignore>'
					end, {buffer = buf, expr = true})

					map('gitsigns: Next Hunk', 'n', ']c', function()
						if vim.wo.diff then return ']c' end
						vim.schedule(api.next_hunk)
						return '<ignore>'
					end, {buffer = buf, expr = true})

				end,
			})
		end
	},

}

-- lsp, syntax-highlighter, etc.
for _,v in ipairs(require(my.base..'langs')) do
	table.insert(plugins, v)
end

-- themes
local themes = require(my.base..'themes')
for k,v in pairs(themes.list) do
	if k == themes.select then
		v.cond = true
		v.priority = 1000
		local main = v.main or v.name or themes.select
		v.config = function(_, opts)
			require(main).setup(opts)
			vim.cmd.colorscheme(main)
		end
	else
		v.cond = false
		v.config = true
	end
	v.lazy = false
	table.insert(plugins, v)
end

-- setup lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git', 'clone', '--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- install plugins
require('lazy').setup(plugins, {
	defaults = { -- default options for each plugin
		lazy = true,
		version = '*', -- try installing the latest stable versions of plugins
	},
	lockfile = vim.fn.stdpath('config')..'/lua/'..
		my.base:gsub('%.', '/').. -- replace '.' with '/'
		'plugins-lock.json'
})

