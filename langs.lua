---- LANGUAGES ----
return function(plugins)

	-- languages (filetypes) to support
	local langs = {
		'lua', 'vim', 'vimdoc',
		'html', 'css', 'javascript', 'json', 'php',
	}

	table.insert(plugins, {
		-- language parser & syntax highlighter
		'nvim-treesitter/nvim-treesitter',
		enabled = true,
		lazy = true,
		ft = langs,
		build = ':TSUpdate',
		config = function ()
			require('nvim-treesitter.configs').setup({
				ensure_installed = langs,
				sync_install = false,
				auto_install = false,
				indent = {enable = true},
				highlight = {enable = true},
			})
		end
	})

	table.insert(plugins, {
		-- lsp package manager
		'williamboman/mason.nvim',
		lazy = true,
		cmd = {'Mason'},
		opts = {},
	})

	table.insert(plugins, {
		-- total lsp management
		'williamboman/mason-lspconfig.nvim',
		enabled = true,
		lazy = true,
		ft = langs,
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
					'lua_ls', -- lua
					'tsserver', -- js
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
	})

end
