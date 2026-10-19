local vim = vim

local plugins = {
	{
		-- mason: lsp package manager (***..)
		'williamboman/mason.nvim', enabled = true,
		lazy = true,
		cmd = {
			'Mason',
			'MasonInstall',
			'MasonUninstall',
			'MasonUpdate',
		},
		config = function()
			require('mason').setup()
		end
	},
	{
		-- mason-lspconfig: a bridge between mason and lspconfig
		'williamboman/mason-lspconfig.nvim', enabled = true,
		dependencies = {
			'neovim/nvim-lspconfig', -- lsp configurator
			'hrsh7th/cmp-nvim-lsp',  -- lsp completion source
		},
		config = function()
			-- make unused vars/functions more visible
			vim.api.nvim_set_hl(0, 'DiagnosticUnnecessary', {})

			local caps = require('cmp_nvim_lsp').default_capabilities()
			local lsp = require('lspconfig')

			-- root_dir finder
			local root_finder = function(marker, fallback)
				if fallback == nil then -- fallback to cwd
					fallback = vim.uv.cwd()
				elseif fallback == false then -- do not fallback
					fallback = nil
				end
				local root = vim.fs.root
				return function(_,buf)
					return root(buf, marker) or fallback
				end
			end

			-- repository root (generic root_dir finder)
			local repo_root = root_finder({'.git', '.hg'})

			require('mason-lspconfig').setup({
				ensure_installed = {
					-- language servers to install
					'lua_ls',
					'eslint',
					'ts_ls',
					'cssls',
				},
				handlers = {
					-- setup language servers
					lua_ls = function()
						lsp.lua_ls.setup({
							capabilities = caps,
							root_dir = repo_root,
							settings = {
								Lua = {
									runtime = {
										version = 'Lua 5.2',
										nonstandardSymbol = {
											-- pico-8's assignment operators
											'+=', '-=', '*=', '/=', [[\=]], '%=', '^=', '..=', '|=', '&=',
										}
									},
									diagnostics = {
										disable = {
											'lowercase-global',
											'undefined-global',
										},
									}
								}
							}
						})
					end,
					eslint = function()
						lsp.eslint.setup({
							capabilities = caps,
							root_dir = root_finder('eslint.config.js', false),
							settings = {
								packageManager = 'npm', -- this enables the lsp to find the global eslint
							}
						})
					end,
					ts_ls = function()
						lsp.ts_ls.setup({
							capabilities = caps,
							root_dir = repo_root,
							filetypes = {
								'javascript'
							},
						})
					end,
					function(server_name) -- default handler
						lsp[server_name].setup({
							capabilities = caps,
							root_dir = repo_root,
						})
					end,
				}
			})
		end
	}
}

return plugins
