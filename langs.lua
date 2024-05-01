---- LANGUAGES ----
local my = vim.g._custom
local map = my.fn.map

-- filetypes to support
local filetypes = {
	'lua',
	'sh', 'zsh',
	'json', 'yaml',

	'html', 'xml', 'svg',
	'css', 'less', 'scss',
	'javascript', 'typescript',
	'php',
}

-- treesitter language modules
local langs = {
	'lua', 'vim', 'vimdoc', 'query',
	'bash',
	'json', 'yaml',

	'html', 'xml',
	'css', 'scss', -- no `less` module :(
	'javascript', 'jsdoc', 'typescript',
	'php', 'phpdoc',
}

local plugins = {
	{
		-- devdocs viewer
		'luckasRanarison/nvim-devdocs', enabled = true,
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
			'nvim-treesitter/nvim-treesitter',
		},
		cmd = {'DevdocsOpen'},
		init = function()
			map('DevDocs: Open', 'n', '<Leader>d', '<Cmd>DevdocsOpen<CR>')
		end,
		config = function()
			require('nvim-devdocs').setup({
				ensure_installed = {
					'javascript', 'node'
				},
				filetypes = {
					javascript = {'javascript', 'node'},
				},
				after_open = function(buf)
					vim.bo[buf].buflisted = true -- enable going back to opened docs
					map('DevDocs: Close', 'n', '<Esc>', function() my.fn.close_buf(buf, true) end, {buffer = buf})
				end,
				-- use external markdown viewer
				previewer_cmd   = 'glow',
				cmd_args        = {'-s', 'dark', '-w', '128'},
				picker_cmd      = 'glow',
				picker_cmd_args = {'-s', 'dark', '-w', '80'},
			})
		end
	},
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
				ensure_installed = langs,
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

