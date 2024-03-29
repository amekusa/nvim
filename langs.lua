---- LANGUAGES ----

-- filetypes to support
local filetypes = {
	'lua',
	'html', 'css', 'javascript',
	'json', 'yaml',
	'php',
}

-- languages to support
local langs = {
	'vim', 'vimdoc',
	'jsdoc',
}

local plugins = {
	{
		-- language parser & syntax highlighter
		'nvim-treesitter/nvim-treesitter', enabled = true,
		dependencies = {
			-- optional modules
			'nvim-treesitter/nvim-treesitter-refactor',
			--'nvim-treesitter/nvim-treesitter-textobjects',
			--'nvim-treesitter/nvim-treesitter-context',
		},
		ft = filetypes,
		cmd = {'TSInstallInfo', 'TSInstall', 'TSUninstall', 'TSUpdate'},
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = vim.list_extend(langs, filetypes),
				sync_install = false,
				auto_install = false,
				indent = {enable = true},
				highlight = {enable = true},

				refactor = {
					highlight_definitions = {
						enable = true,
						clear_on_cursor_move = false,
					},
					highlight_current_scope = {
						enable = false,
					},
					smart_rename = {
						enable = true,
						keymaps = {
							smart_rename = '<leader>r',
						}
					}
				}
			})
		end
	},
	{
		-- lsp configurator
		'neovim/nvim-lspconfig',
	},
	{
		-- lsp package manager
		'williamboman/mason.nvim',
	},
	{
		-- total lsp management
		'williamboman/mason-lspconfig.nvim', enabled = true,
		dependencies = {
			'williamboman/mason.nvim', -- lsp package manager
			'neovim/nvim-lspconfig', -- lsp configurator
			'hrsh7th/nvim-cmp', -- auto completion

			-- auto completion sources
			'hrsh7th/cmp-nvim-lsp',
		},
		ft = filetypes,
		cmd = {'Mason', 'LspInfo', 'LspInstall', 'LspUninstall'},
		config = function()
			require('mason').setup()
			require('cmp').setup()
			local api = require('mason-lspconfig')
			local lsp = require('lspconfig')
			api.setup({
				ensure_installed = {
					-- language servers to install
					'lua_ls',
					'eslint',
					--'tsserver',
				},
				handlers = {
					-- setup language servers
					['lua_ls'] = function()
						lsp.lua_ls.setup({
							settings = {
								Lua = {
									runtime = {
										version = 'LuaJIT',
									},
									diagnostics = {
										globals = {'vim'} -- suppress warnings for global variables
									}
								}
							}
						})
					end,
					['eslint'] = function()
						lsp.eslint.setup {
							settings = {
								packageManager = 'npm', -- this enables the lsp to find the global eslint
							}
						}
					end,
					['tsserver'] = function()
						lsp.tsserver.setup({
							filetypes = {
								'javascript'
							},
							root_dir = function()
								return vim.loop.cwd()
							end
						})
					end,
					function(server_name) -- default handler
						lsp[server_name].setup({})
					end,
				}
			})
		end
	},

}

return plugins

