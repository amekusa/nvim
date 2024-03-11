local map = vim.keymap.set

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

-- load plugins
require('lazy').setup({
	{
		-- theme: gruvbox
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = true,
	},
	{
		-- file-tree widget
		'nvim-tree/nvim-tree.lua',
		version = '*',
		lazy = false,
		dependencies = {
			'nvim-tree/nvim-web-devicons',
		},
		config = function()
			-- disable netrw
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			local api = require('nvim-tree.api')
			require('nvim-tree').setup({
				filters = {
					git_ignored = false, -- do not hide ignored files
					custom = {'.git', '.DS_Store'},
				},
				on_attach = function(bufnr)
					local function desc(s)
						return {desc = 'nvim-tree: ' .. s, buffer = bufnr, noremap = true, silent = true, nowait = true}
					end
					-- default keymaps
					map('n', '<C-]>', api.tree.change_root_to_node,          desc('CD'))
					--map('n', '<C-e>', api.node.open.replace_tree_buffer,     desc('Open: In Place'))
					map('n', '<C-k>', api.node.show_info_popup,              desc('Info'))
					map('n', '<C-r>', api.fs.rename_sub,                     desc('Rename: Omit Filename'))
					map('n', '<C-t>', api.node.open.tab,                     desc('Open: New Tab'))
					map('n', '<C-v>', api.node.open.vertical,                desc('Open: Vertical Split'))
					map('n', '<C-x>', api.node.open.horizontal,              desc('Open: Horizontal Split'))
					map('n', '<BS>',  api.node.navigate.parent_close,        desc('Close Directory'))
					map('n', '<CR>',  api.node.open.edit,                    desc('Open'))
					map('n', '<Tab>', api.node.open.preview,                 desc('Open Preview'))
					map('n', '>',     api.node.navigate.sibling.next,        desc('Next Sibling'))
					map('n', '<',     api.node.navigate.sibling.prev,        desc('Previous Sibling'))
					map('n', '.',     api.node.run.cmd,                      desc('Run Command'))
					map('n', '-',     api.tree.change_root_to_parent,        desc('Up'))
					map('n', 'a',     api.fs.create,                         desc('Create'))
					map('n', 'bmv',   api.marks.bulk.move,                   desc('Move Bookmarked'))
					map('n', 'B',     api.tree.toggle_no_buffer_filter,      desc('Toggle No Buffer'))
					map('n', 'c',     api.fs.copy.node,                      desc('Copy'))
					map('n', 'C',     api.tree.toggle_git_clean_filter,      desc('Toggle Git Clean'))
					map('n', '[c',    api.node.navigate.git.prev,            desc('Prev Git'))
					map('n', ']c',    api.node.navigate.git.next,            desc('Next Git'))
					map('n', 'd',     api.fs.remove,                         desc('Delete'))
					map('n', 'D',     api.fs.trash,                          desc('Trash'))
					map('n', 'E',     api.tree.expand_all,                   desc('Expand All'))
					map('n', 'e',     api.fs.rename_basename,                desc('Rename: Basename'))
					map('n', ']e',    api.node.navigate.diagnostics.next,    desc('Next Diagnostic'))
					map('n', '[e',    api.node.navigate.diagnostics.prev,    desc('Prev Diagnostic'))
					map('n', 'F',     api.live_filter.clear,                 desc('Clean Filter'))
					map('n', 'f',     api.live_filter.start,                 desc('Filter'))
					map('n', 'g?',    api.tree.toggle_help,                  desc('Help'))
					map('n', 'gy',    api.fs.copy.absolute_path,             desc('Copy Absolute Path'))
					map('n', 'H',     api.tree.toggle_hidden_filter,         desc('Toggle Dotfiles'))
					map('n', 'I',     api.tree.toggle_gitignore_filter,      desc('Toggle Git Ignore'))
					map('n', 'J',     api.node.navigate.sibling.last,        desc('Last Sibling'))
					map('n', 'K',     api.node.navigate.sibling.first,       desc('First Sibling'))
					map('n', 'm',     api.marks.toggle,                      desc('Toggle Bookmark'))
					map('n', 'o',     api.node.open.edit,                    desc('Open'))
					map('n', 'O',     api.node.open.no_window_picker,        desc('Open: No Window Picker'))
					map('n', 'p',     api.fs.paste,                          desc('Paste'))
					map('n', 'P',     api.node.navigate.parent,              desc('Parent Directory'))
					map('n', 'q',     api.tree.close,                        desc('Close'))
					map('n', 'r',     api.fs.rename,                         desc('Rename'))
					map('n', 'R',     api.tree.reload,                       desc('Refresh'))
					map('n', 's',     api.node.run.system,                   desc('Run System'))
					map('n', 'S',     api.tree.search_node,                  desc('Search'))
					map('n', 'U',     api.tree.toggle_custom_filter,         desc('Toggle Hidden'))
					map('n', 'W',     api.tree.collapse_all,                 desc('Collapse'))
					map('n', 'x',     api.fs.cut,                            desc('Cut'))
					map('n', 'y',     api.fs.copy.filename,                  desc('Copy Name'))
					map('n', 'Y',     api.fs.copy.relative_path,             desc('Copy Relative Path'))
					map('n', '<2-LeftMouse>',  api.node.open.edit,           desc('Open'))
					map('n', '<2-RightMouse>', api.tree.change_root_to_node, desc('CD'))
				end,
			})
			-- toggle focus nvim-tree
			map({'n','v','i'}, '<C-e>',
				function()
					if api.tree.is_tree_buf() then -- is current pane nvim-tree?
						local key = '<C-w>p' -- ctrl+w,p = switch to previous pane
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'n', false) -- emulate keypresses
						return
					end
					-- switch to nvim-tree
					vim.cmd('stopinsert') -- force normal mode
					vim.cmd('NvimTreeOpen')
				end,
				{desc='Toggle nvim-tree'}
			)
		end
	},
	{
		-- trim trailing whitespaces
		"cappyzawa/trim.nvim",
		opts = {
			trim_on_write = true,
			trim_first_line = true,
			trim_last_line = false,
			highlight = false,
			ft_blocklist = {'markdown'},
			patterns = {
				[[%s/\(\n\n\)\n\+/\1/]], -- replace multiple blank lines with a single line
			},
		}
	},
	{
		-- language parser
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function ()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					'lua', "vim", "vimdoc",
					"javascript", "html", 'css'
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end
	},
	{
		-- fuzzy finder
		'nvim-telescope/telescope.nvim',
		event = 'VimEnter',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim'
		}
	},
	{
		-- cheatsheet
		'sudormrfbin/cheatsheet.nvim',
		dependencies = {'nvim-telescope/telescope.nvim'},
		opts = {
			bundled_cheatsheets = {
				enabled = {'default'}
			},
			bundled_plugin_cheatsheets = {
				enabled = {'telescope.nvim'}
			},
		}
	},
	{
		-- shows pending keybinds
		'folke/which-key.nvim',
		event = 'VeryLazy',
		config = function()
			local api = require('which-key')
			api.setup()

			-- document existing key chains
			api.register {
				['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
				['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
				['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
				['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
				['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
			}
		end,
	},
	{
		-- shows git related signs to the gutter
		'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			preview_config = {
				-- options passed to nvim_open_win
				border = 'single',
				style = 'minimal',
				relative = 'cursor',
				row = 0,
				col = 1
			},
		},
	},

})
