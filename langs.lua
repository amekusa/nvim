---- LANGUAGES ----
local my = vim.g._custom
local map = my.fn.map
local autoload = my.fn.autoload

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
		init = function(this)
			autoload(this, 'Devdocs')
			map('DevDocs: Open', 'n', '<Leader>d', '<Cmd>DevdocsOpen<CR>')
		end,
		cmd = {
			'DevdocsOpen',
			'DevdocsInstall',
			'DevdocsUpdateAll',
		},
		config = function()
			require('nvim-devdocs').setup({
				ensure_installed = {
					'javascript', 'node',
					'html', 'css',
					'php',
				},
				filetypes = {
					javascript = {'javascript', 'node'},
					html = {'html', 'css', 'javascript'},
					css = {'css'},
					php = {'php', 'html', 'css', 'javascript'},
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
		-- smart comment-out
		'numToStr/Comment.nvim', enabled = true,
		dependencies = {'nvim-treesitter/nvim-treesitter'},
		ft = filetypes,
		config = function()
			require('Comment').setup({
				mappings = {
					basic = true,
					extra = true,
				},
				toggler = {
					line  = 'gcc',
					block = 'gbc',
				},
				opleader = { -- operator-pending mappings in NORMAL and VISUAL mode
					line  = 'gc',
					block = 'gb',
				},
				extra = {
					above = 'gcO', -- add comment on the line above
					below = 'gco', -- add comment on the line below
					eol   = 'gcA', -- add comment at the end of line
				},
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
		init = function(this)
			autoload(this, 'TS')
		end,
		cmd = {
			'TSInstallInfo',
			'TSConfigInfo',
			'TSInstall',
			'TSUninstall',
			'TSUpdate',
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
			-- auto-completion settings
			local cmp = require('cmp')
			cmp.setup({
				completion = {
					autocomplete = false,
				},
				snippet = { -- snippet engine
					expand = function(args)
						vim.snippet.expand(args.body) -- native neovim snippets
					end
				},
				mapping = cmp.mapping.preset.insert({
					['<C-Space>'] = cmp.mapping.complete(),
					['<Tab>'] = cmp.mapping.confirm({select = true}),
				}),
				sources = cmp.config.sources({
					{name = 'buffer'},
					{name = 'path'},
					{name = 'nvim_lsp'},
				}),
			})
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{name = 'path'},
					{name = 'cmdline'},
				}),
				matching = {disallow_symbol_nonprefix_matching = false}
			})

			-- lsp settings
			local caps = require('cmp_nvim_lsp').default_capabilities()
			local lsp = require('lspconfig')
			require('mason').setup()
			require('mason-lspconfig').setup({
				ensure_installed = {
					-- language servers to install
					'lua_ls',
					'eslint',
					'tsserver',
					'cssls',
				},
				handlers = {
					-- setup language servers
					['lua_ls'] = function()
						lsp.lua_ls.setup({
							capabilities = caps,
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
						lsp.eslint.setup({
							capabilities = caps,
							root_dir = function()
								return vim.loop.cwd()
							end,
							settings = {
								packageManager = 'npm', -- this enables the lsp to find the global eslint
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
						lsp[server_name].setup({
							capabilities = caps,
						})
					end,
				}
			})
		end
	},

}

return plugins

