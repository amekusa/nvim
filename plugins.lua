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

			require('nvim-tree').setup({
				filters = {
					git_ignored = false, -- do not hide ignored files
					custom = {'.git', '.DS_Store'},
				}
			})
		end
	},
	{
		-- trim trailing whitespaces
		"cappyzawa/trim.nvim",
		opts = {
			trim_on_write = true,
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
	},
	{
		-- shows pending keybinds
		'folke/which-key.nvim',
		event = 'VimEnter',
		config = function()
			require('which-key').setup()

			-- document existing key chains
			require('which-key').register {
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
