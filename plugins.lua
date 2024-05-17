---- PLUGINS ----
local my = vim.g._custom
local conf = my.conf.plugins
local map = my.fn.map
local autoload = my.fn.autoload

-- editor events
local on_edit = {
	'BufReadPre',
	'BufNewFile'
}

-- filetypes to load treesitter
local ts_filetypes = {
	'vim',
	'lua',
	'sh', 'bash', 'zsh',
	'json', 'yaml',
	'markdown',

	'html', 'xml', 'svg',
	'css', 'less', 'scss',
	'javascript', 'typescript',
	'php',
}

-- treesitter language modules
local ts_langs = {
	'vim', 'vimdoc', 'query',
	'lua',
	'bash',
	'json', 'yaml',
	'markdown',

	'html', 'xml',
	'css', 'scss', -- no `less` module :(
	'javascript', 'jsdoc', 'typescript',
	'php', 'phpdoc',
}

local plugins = { -- in alphabetical order
	{
		-- cheatsheet (***..)
		'sudormrfbin/cheatsheet.nvim', enabled = true,
		dependencies = {'nvim-telescope/telescope.nvim'},
		init = function()
			map('cheatsheet: Open', 'n', '<Leader>?', '<Cmd>Cheatsheet<CR>')
		end,
		cmd = {
			'Cheatsheet',
			'CheatsheetEdit',
		},
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
		-- code runner (****.)
		'CRAG666/code_runner.nvim', enabled = true,
		init = function()
			map('coderunner: Run Code', 'n', '<Leader><CR><CR>', '<Cmd>RunCode<CR>')
			map('coderunner: Run File', 'n', '<Leader><CR>f',    '<Cmd>RunFile<CR>')
			map('coderunner: Close',    'n', '<Leader><CR>x',    '<Cmd>RunClose<CR>')
		end,
		cmd = {
			'RunCode',
			'RunFile',
			'RunProject',
			'RunClose',
		},
		config = function()
			require('code_runner').setup({
				mode = 'term',
				focus = false,
				hot_reload = true,
				term = {
					size = 8,
				},
				filetype = {
					lua = 'lua',
					javascript = 'node',
				}
			})
		end
	},
	{
		-- smart comment-out
		'numToStr/Comment.nvim', enabled = true,
		dependencies = {'nvim-treesitter/nvim-treesitter'},
		ft = ts_filetypes,
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
		-- jump with keypresses (*****)
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
					uppercase = true, -- allow uppercase labels?
					current = false, -- add a label for the first match?
				},
				modes = {
					search = { -- '/' mode options
						enabled = true,
					},
					char = { -- 'f' mode options
						enabled = true,
						keys = {'f','F'},
						jump_labels = true, -- show jump labels?
						multi_line = true, -- multi-line or current-line-only
						label = {
							exclude = '', -- exclude these letters from jump labels
						},
					},
				},
			})
		end
	},
	{
		-- shows git related signs to the gutter (*****)
		'lewis6991/gitsigns.nvim', enabled = true,
		event = on_edit,
		config = function()
			local api = require('gitsigns')
			api.setup({
				signs = {
					add          = {text = '+'}, -- {text = '│'},
					change       = {text = '*'}, -- {text = '│'},
					delete       = {text = '_'},
					topdelete    = {text = '‾'},
					changedelete = {text = '~'},
					untracked    = {text = '?'},
				},
				on_attach = function(buf)
					local opts = {buffer = buf}
					map('gitsigns: Stage Hunk',      'n', '<Leader>gs', api.stage_hunk,                               opts)
					map('gitsigns: Stage Hunk',      'x', '<Leader>gs', function() api.stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, opts)
					map('gitsigns: Reset Hunk',      'n', '<Leader>gr', api.reset_hunk,                               opts)
					map('gitsigns: Reset Hunk',      'x', '<Leader>gr', function() api.reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, opts)
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
	{
		-- guess indent style (***..)
		'nmac427/guess-indent.nvim', enabled = true,
		event = on_edit,
		config = function()
			require('guess-indent').setup({
				auto_cmd = true,
				override_editorconfig = false,
				filetype_exclude = {
					'tutor',
					'help',
					'man',
					'qf',
				},
				buftype_exclude = {
					'help',
					'nofile',
					'nowrite',
					'quickfix',
					'terminal',
					'prompt',
				},
			})
		end
	},
	{
		-- 'gx' functionajity without the need of netrw (****.)
		'chrishrb/gx.nvim', enabled = true,
		dependencies = {'nvim-lua/plenary.nvim'},
		init = function()
			vim.g.netrw_nogx = 1 -- disable netrw gx
			map('gx: Browse', 'n', 'gx', '<Cmd>Browse<CR>')
		end,
		cmd = 'Browse',
		config = true,
	},
	{
		-- snippet engine (***..)
		'L3MON4D3/LuaSnip', enabled = true,
		build = 'make install_jsregexp',
		config = function()
			require('luasnip.loaders.from_vscode').lazy_load({
				paths = {my.path..'/snippets'}
			})
		end
	},
	{
		-- LSP package manager (***..)
		'williamboman/mason.nvim', enabled = true,
		init = function(this)
			autoload(this, 'Mason')
		end,
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
		-- total LSP management
		'williamboman/mason-lspconfig.nvim', enabled = true,
		dependencies = {
			'williamboman/mason.nvim', -- LSP package manager
			'neovim/nvim-lspconfig', -- LSP configurator
			'hrsh7th/nvim-cmp', -- auto-completion
			'hrsh7th/cmp-nvim-lsp', -- completion source: nvim_lsp
			'L3MON4D3/LuaSnip', -- snippet engine
			'saadparwaiz1/cmp_luasnip', -- required for nvim-cmp to work with LuaSnip
		},
		ft = ts_filetypes,
		cmd = {
			'LspInfo',
			'LspInstall',
			'LspUninstall'
		},
		config = function()
			-- setup auto-completion
			local luasnip = require('luasnip')
			local cmp = require('cmp')
			cmp.setup({
				snippet = { -- snippet engine
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end
				},
				confirmation = {
					default_behavior = cmp.ConfirmBehavior.Replace
				},
				mapping = {
					-- activate manually
					['<C-Space>'] = cmp.mapping.complete(),
					-- confirm selected suggestion
					['<CR>'] = cmp.mapping(function(fallback)
						if cmp.visible() and cmp.get_selected_entry() then
							if luasnip.expandable()
								then luasnip.expand()
								else cmp.confirm({select = false})
							end
						else
							fallback()
						end
					end),
					-- next suggestion
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible()
							then cmp.select_next_item()
							else fallback()
						end
					end),
					-- prev suggestion
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible()
							then cmp.select_prev_item()
							else fallback()
						end
					end),
					-- next placeholder in a snippet
					['<C-n>'] = cmp.mapping(function(fallback)
						if luasnip.locally_jumpable(1)
							then luasnip.jump(1)
							else fallback()
						end
					end, {'i','s'}),
					-- prev placeholder in a snippet
					['<C-p>'] = cmp.mapping(function(fallback)
						if luasnip.locally_jumpable(-1)
							then luasnip.jump(-1)
							else fallback()
						end
					end, {'i','s'}),
				},
				sources = cmp.config.sources({ -- completion sources
					{name = 'luasnip'},
					{name = 'nvim_lsp'},
					{name = 'path'},
				}),
			})
			-- setup LSPs
			local caps = require('cmp_nvim_lsp').default_capabilities()
			local lsp = require('lspconfig')
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
							root_dir = function()
								return vim.loop.cwd()
							end,
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
	{
		-- align text interactively (****.)
		'echasnovski/mini.align', enabled = true,
		-- usage:
		--   1. select the lines to align
		--   2. type 'ga'
		--   3. type 's' to specify the splitter
		event = on_edit,
		config = function()
			require('mini.align').setup({
				mappings = {
					start = '',
					start_with_preview = 'ga'
				},
			})
		end
	},
	{
		-- automatically close brackets (****.)
		'windwp/nvim-autopairs', enabled = true,
		event = on_edit,
		config = function()
			require('nvim-autopairs').setup({
				-- options
			})
		end
	},
	{
		-- devdocs viewer (****.)
		'luckasRanarison/nvim-devdocs', enabled = true,
		branch = 'master', -- latest commit on master
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-treesitter/nvim-treesitter',
			'nvim-telescope/telescope.nvim',
		},
		init = function(this)
			autoload(this, 'Devdocs')
			map('devdocs: Open',         'n', '<Leader>D', '<Cmd>DevdocsOpen<CR>')
			map('devdocs: Open Current', 'n', '<Leader>d', '<Cmd>DevdocsOpenCurrent<CR>')
		end,
		cmd = {
			'DevdocsOpen',
			'DevdocsOpenCurrent',
			'DevdocsInstall',
			'DevdocsUpdateAll',
		},
		config = function()
			require('nvim-devdocs').setup({
				ensure_installed = {
					'lua-5.1', 'lua-5.2',
					'javascript', 'node',
					'html', 'css',
					'php',
				},
				filetypes = {
					lua = {'lua-5.1', 'lua-5.2'},
					javascript = {'javascript', 'node'},
					html = {'html', 'css', 'javascript'},
					css = {'css'},
					php = {'php', 'html', 'css', 'javascript'},
				},
				after_open = function(buf)
					vim.bo[buf].buflisted = true -- enable going back to opened docs
					map('devdocs: Close', 'n', '<Esc>', function() my.fn.close_buf(buf, true) end, {buffer = buf})
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
		-- snippets manager (****.)
		'chrisgrieser/nvim-scissors', enabled = true,
		dependencies = {'nvim-telescope/telescope.nvim'}, -- optional
		cmd = {
			'ScissorsEditSnippet',
			'ScissorsAddNewSnippet',
		},
		config = function()
			require('scissors').setup({
				snippetDir = my.path..'/snippets',
				jsonFormatter = 'jq',
			})
		end
	},
	{
		-- smartly edit surrounding chars like {}, [], "", etc.
		'kylechui/nvim-surround', enabled = true,
		event = on_edit,
		config = function()
			require('nvim-surround').setup({
				-- options
			})
		end
	},
	{
		-- file-tree widget (***..)
		'nvim-tree/nvim-tree.lua', enabled = true,
		dependencies = {'nvim-tree/nvim-web-devicons'},
		init = function()
			-- disable netrw
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		lazy = false,
		config = function()
			local api = require('nvim-tree.api')
			require('nvim-tree').setup({
				disable_netrw = true,
				filters = {
					git_ignored = true, -- hide ignored files?
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
				filesystem_watchers = {
					enable = true,
					ignore_dirs = {'node_modules'}, -- this fixes the slow-shutdown issue
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
					map('nvim-tree: Delete',                  'n', 'D',              api.fs.remove,                      opts)
					map('nvim-tree: Trash',                   'n', 'd',              api.fs.trash,                       opts)
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
					map('nvim-tree: Run System',              'n', 's',              api.node.run.system,                opts)
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
			map('nvim-tree: Toggle focus', {'n','x','i','t'}, '<C-e>', function()
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
		ft = ts_filetypes,
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = ts_langs,
				sync_install = false,
				auto_install = false,
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
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
							smart_rename = '<Leader>r',
						}
					}
				}
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
			map('telescope: Builtin',                'n', '<Leader>t', api.builtin)
			map('telescope: Files',                  'n', '<Leader>f', api.find_files)
			map('telescope: Grep',                   'n', '<Leader><Leader>f', api.live_grep)
			map('telescope: Buffers',                'n', '<Leader>b', api.buffers)
			map('telescope: Commands',               'n', '<Leader>;', api.commands)
			map('telescope: Help',                   'n', '<Leader>h', api.help_tags)
			map('telescope: Man Pages',              'n', '<Leader><Leader>m', api.man_pages)
			map('telescope: Quickfix',               'n', '<Leader><Leader>q', api.quickfix)
			map('telescope: Options',                'n', '<Leader><Leader>o', api.vim_options)
			map('telescope: Registers',              'n', '<Leader><Leader>r', api.registers)
			map('telescope: Keymaps',                'n', '<Leader>k', api.keymaps)
			map('telescope: Treesitter Symbols',     'n', '<Leader>s', api.treesitter)
			map('telescope: Commits',                'n', '<Leader><Leader>C', api.git_commits)
			map('telescope: Commits for the Buffer', 'n', '<Leader><Leader>c', api.git_bcommits)
			--map('telescope: Commits in the Range', 'x', '<Leader><Leader>c', api.git_bcommits_range)
			--   NOTE: this causes error bc 'git_bcommits_range' is nil. no idea how to fix it.
		end
	},
	{
		-- shows pending keybinds
		'folke/which-key.nvim', enabled = true,
		event = 'VeryLazy',
		config = function()
			require('which-key').setup({
				-- options
			})
		end,
	},

}

-- themes
if conf.themes then
	local themes = require(my.ns..'.themes')
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
end

-- setup lazy.nvim (plugin manager)
local lazy = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazy) then
	vim.fn.system({
		'git', 'clone', '--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazy,
	})
end
vim.opt.rtp:prepend(lazy)

-- install plugins
lazy = require('lazy')
lazy.setup(plugins, {
	lockfile = my.path..'/plugins-lock.json',
	defaults = { -- default options for each plugin
		lazy = true,
		version = '*', -- try installing the latest stable versions of plugins
	},
})

-- set custom autoloader
my.fn.set_autoloader(function(plugin)
	if plugin._.loaded then return end
	lazy.load({plugins = plugin})
end)

