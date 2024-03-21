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
	'json',
}

local plugins = {
	{
		-- language parser & syntax highlighter
		'nvim-treesitter/nvim-treesitter',
		enabled = true,
		lazy = true,
		ft = filetypes,
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = vim.list_extend(langs, filetypes),
				sync_install = false,
				auto_install = false,
				indent = {enable = true},
				highlight = {enable = true},
			})
		end
	},
	{
		-- lsp configurator
		'neovim/nvim-lspconfig',
		lazy = true,
	},
	{
		-- lsp package manager
		'williamboman/mason.nvim',
		lazy = true,
		opts = {},
	},
	{
		-- total lsp management
		'williamboman/mason-lspconfig.nvim',
		enabled = true,
		lazy = true,
		ft = filetypes,
		cmd = {'Mason', 'LspInfo', 'LspInstall', 'LspUninstall'},
		dependencies = {
			'williamboman/mason.nvim', -- lsp package manager
			'neovim/nvim-lspconfig', -- lsp configurator
			'hrsh7th/nvim-cmp', -- auto completion

			-- auto completion sources
			'hrsh7th/cmp-nvim-lsp',
		},
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

