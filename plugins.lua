---- PLUGINS ----
local vim = vim
local autocmd = vim.api.nvim_create_autocmd
local my = _custom
local map = my.fn.map
local conf = my.conf.plugins

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

local plugins = { -- in alphabetical order (ignore 'nvim-' prefix)
	---- #A ----
	{
		-- #auto-input-switch: automatically switch the input sources
		'amekusa/auto-input-switch.nvim', enabled = true,
		lazy = false,
		config = function()
			require('auto-input-switch').setup({
				restore = {enable = false},
				match = {
					enable = true,
					file_pattern = {
						'*.md',
						'*.txt',
					},
					languages = {
						Ja = {enable = true},
					},
				},
			})
		end
	},
	{
		-- #autopairs: automatically close brackets (****.)
		'windwp/nvim-autopairs', enabled = true,
		lazy = false,
		config = function()
			require('nvim-autopairs').setup({
				-- options
			})
		end
	},
	---- #B ----
	---- #C ----
	{
		-- #cheatsheet (***..)
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
		-- #coderunner (****.)
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
		-- #colorizer: preview color values
		'norcalli/nvim-colorizer.lua', enabled = true,
		ft = {
			'html', 'php',
			'css', 'less',
			'javascript',
			'svg',
		},
		config = function(this)
			require('colorizer').setup(this.ft, {
				names = false, -- color names
				rgb_fn = true, -- rgb(...) function
				hsl_fn = true, -- hsl(...) function
			})
		end
	},
	{
		-- #comment: smartly commenting out
		'numToStr/Comment.nvim', enabled = true,
		dependencies = {'nvim-treesitter/nvim-treesitter'},
		ft = ts_filetypes,
		config = function()
			require('Comment').setup({
				mappings = {
					basic = true,
					extra = false,
				},
				toggler = {
					line  = '#',
					block = '*',
				},
				opleader = { -- operator-pending mappings in NORMAL and VISUAL mode
					line  = '#',
					block = '*',
				},
			})
		end
	},
	---- #D ----
	---- #E ----
	---- #F ----
	{
		-- #flash: jump with keypresses (*****)
		'folke/flash.nvim', enabled = true,
		lazy = false,
		config = function()
			require('flash').setup({
				search = {
					mode = 'exact', -- exact/search/fuzzy
					incremental = true,
					multi_window = false,
				},
				jump = {
					nohlsearch = true, -- clear highlight after jump?
					autojump = false, -- automatically jump when there is only one match?
				},
				label = {
					uppercase = false, -- allow uppercase labels?
					current = true, -- add a label for the first match?
				},
				modes = {
					search = { -- '/' mode options
						enabled = true,
					},
					char = { -- 'f' mode options
						enabled = false,
					},
				},
			})
		end
	},
	---- #G ----
	{
		-- #gitsigns: shows git related infos in the gutter (*****)
		'lewis6991/gitsigns.nvim', enabled = true,
		config = function()
			local api = require('gitsigns')
			api.setup({
				signs = {
					add          = {text = '+'}, -- {text = '│'},
					change       = {text = '*'}, -- {text = '│'},
					delete       = {text = '_'},
					topdelete    = {text = '‾'},
					changedelete = {text = '~'},
					untracked    = {text = '+'},
				},
				on_attach = function(buf)
					local opts = {buffer = buf}
					map('gitsigns: Stage Hunk',      'n', 'gs', api.stage_hunk, opts)
					map('gitsigns: Stage Hunk',      'x', 'gs', function() api.stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, opts)
					map('gitsigns: Reset Hunk',      'n', 'gr', api.reset_hunk, opts)
					map('gitsigns: Reset Hunk',      'x', 'gr', function() api.reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, opts)
					map('gitsigns: Undo Stage Hunk', 'n', 'gS', api.undo_stage_hunk, opts)
					map('gitsigns: Preview Hunk',    'n', 'gp', api.preview_hunk, opts)
					map('gitsigns: Diff',            'n', 'gd', api.diffthis, opts)
					map('gitsigns: Blame Line',      'n', 'gb', function() api.blame_line({full = true}) end, opts)
					map('gitsigns: Toggle Blame',    'n', 'gB', api.toggle_current_line_blame, opts)
					map('gitsigns: Toggle Deleted',  'n', 'gD', api.toggle_deleted, opts)

					map('gitsigns: Prev Hunk', 'n', 'gk', function()
						if vim.wo.diff then return  'gk' end
						vim.schedule(api.prev_hunk)
						return '<Ignore>'
					end, {buffer = buf, expr = true})

					map('gitsigns: Next Hunk', 'n', 'gj', function()
						if vim.wo.diff then return  'gj' end
						vim.schedule(api.next_hunk)
						return '<Ignore>'
					end, {buffer = buf, expr = true})
				end,
			})
		end
	},
	{
		-- #guess-indent: guessing indent style (***..)
		'nmac427/guess-indent.nvim', enabled = true,
		config = function()
			map('guess-indent: Guess Indent', 'n', 'gI', '<Cmd>GuessIndent<CR>')
			require('guess-indent').setup({
				auto_cmd = true,
				override_editorconfig = true,
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
		-- #gx: browsing the page under the cursor (****.)
		'chrishrb/gx.nvim', enabled = true,
		dependencies = {'nvim-lua/plenary.nvim'},
		init = function()
			vim.g.netrw_nogx = 1 -- disable netrw gx
			map('gx: Browse', 'n', 'gx', '<Cmd>Browse<CR>')
		end,
		cmd = 'Browse',
		config = true,
	},
	---- #H ----
	---- #I ----
	---- #J ----
	---- #K ----
	---- #L ----
	{
		-- #live-preview: preview files in a web browser with live-updates (****.)
		-- usage:
		--   :LivePreview start
		--   :LivePreview pick
		--   :LivePreview close
		'brianhuster/live-preview.nvim', enabled = true,
		dependencies = {'nvim-telescope/telescope.nvim'},
		lazy = true,
		cmd = {
			'LivePreview',
		},
	},
	{
		-- #lualine: status bar
		'nvim-lualine/lualine.nvim', enabled = true,
		commit = '640260d7c2d98779cab89b1e7088ab14ea354a02',
		--   NOTE: This is at right before the commit: 0978a6c. (https://github.com/nvim-lualine/lualine.nvim/commit/0978a6c8a862d999baf51366926c7b56eb9cf3d1)
		--         The commit: 0978a6c introduced some unwanted changes which makes lualine doesn't refresh via autocmds.
    	dependencies = {'nvim-tree/nvim-web-devicons'},
		lazy = false,
		config = function()
			vim.o.showmode = false -- hide mode indicator which is redundant
			-- vim.o.cmdheight = 0 -- hide commandline when not in use
			--   NOTE: This somehow breaks my keymaps in visual mode (NVIM v0.9.4)

			local refresh = 3000

			-- components
			local branch   = {'branch', icons_enabled = false}
			local filetype = {'filetype', icon_only = true}
			local diff     = {'diff', symbols = {modified = '*'}}

			local buffers = {
				require(my.ns..'extras.bufferline'),
				max_length_offset = 50,
				highlights = {
					-- active   = {gui = 'bold'},
					inactive = {fg = '#938aa9'}, -- kanagawa:springViolet1
				}
			}

			require('lualine').setup({
				options = {
					icons_enabled = true,
					theme = 'auto',
					component_separators = '',
					section_separators   = '',
					always_divide_middle = true,
					globalstatus = true,
					refresh = {
						statusline = refresh,
						tabline    = refresh,
						winbar     = refresh,
					}
				},
				sections = {
					lualine_a = {'mode'},
					lualine_b = {branch},
					lualine_c = {filetype, buffers},
					lualine_x = {'diagnostics', diff, 'filesize'},
					lualine_y = {'progress'},
					lualine_z = {'location'}
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {'filename'},
					lualine_x = {'location'},
					lualine_y = {},
					lualine_z = {}
				},
			})
		end
	},
	{
		-- #luasnip: snippet engine (***..)
		'L3MON4D3/LuaSnip', enabled = true,
		build = 'make install_jsregexp',
		config = function()
			require('luasnip.loaders.from_vscode').lazy_load({
				paths = {my.root..'snippets'}
			})
		end
	},
	---- #M ----
	{
		-- #mason: LSP package manager (***..)
		'williamboman/mason.nvim', enabled = true,
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
		-- #mason-lspconfig: total LSP management
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
			---- SETUP LSPS ----
			local caps = require('cmp_nvim_lsp').default_capabilities()
			local lsp = require('lspconfig')

			-- returns a new root_dir finder
			local root_finder = function(marker, fallback)
				if fallback == nil then -- fallback to cwd
					fallback = vim.uv.cwd()
				elseif fallback == false then -- do not fallback
					fallback = nil
				end
				return function(_,buf)
					return vim.fs.root(buf, marker) or fallback
				end
			end

			-- repository root (generic root-finder)
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
					['lua_ls'] = function()
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
					['eslint'] = function()
						lsp.eslint.setup({
							capabilities = caps,
							root_dir = root_finder('eslint.config.js', false),
							settings = {
								packageManager = 'npm', -- this enables the lsp to find the global eslint
							}
						})
					end,
					['ts_ls'] = function()
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

			---- SETUP AUTOCOMPLETION ----
			local luasnip = require('luasnip')
			local cmp = require('cmp')
			cmp.setup({
				snippet = { -- snippet engine
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end
				},
				sources = cmp.config.sources({ -- completion sources
					{name = 'luasnip', priority = 10},
					{name = 'nvim_lsp', priority = 5, max_item_count = 12},
				}),
				completion = {
					keyword_length = 2,
				},
				confirmation = {
					default_behavior = cmp.ConfirmBehavior.Replace
				},
				experimental = {
					ghost_text = false,
				},
				mapping = {
					-- activate manually
					['<C-Space>'] = cmp.mapping(function(_)
						if cmp.visible()
							then cmp.abort()
							else cmp.complete()
						end
					end),
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
					-- confirm the first suggestion (or selected one)
					['<C-CR>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if luasnip.expandable()
								then luasnip.expand()
								else cmp.confirm({select = true})
							end
						else
							fallback()
						end
					end),
					-- next suggestion
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible()
							then cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
							else fallback()
						end
					end),
					-- prev suggestion
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible()
							then cmp.select_prev_item({behavior = cmp.SelectBehavior.Select})
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
			})
		end
	},
	{
		-- #mini.align: aligning text interactively (****.)
		'echasnovski/mini.align', enabled = true,
		-- usage:
		--   1. select the lines to align
		--   2. type 'ga'
		--   3. type 's' to specify the splitter
		keys = {
			{'ga', mode = {'n','x'}, desc = "Align with preview"},
		},
		config = function()
			require('mini.align').setup({
				mappings = {
					start = '',
					start_with_preview = 'ga'
				},
			})
		end
	},
	---- #N ----
	---- #O ----
	---- #P ----
	---- #Q ----
	---- #R ----
	---- #S ----
	{
		-- #scissors: snippets manager (****.)
		'chrisgrieser/nvim-scissors', enabled = true,
		commit = '6cf49a2244dd618b88a4c8d08a8daf939219758d',
		dependencies = {'nvim-telescope/telescope.nvim'}, -- optional
		cmd = {
			'ScissorsEditSnippet',
			'ScissorsAddNewSnippet',
		},
		config = function()
			require('scissors').setup({
				snippetDir = my.root..'snippets',
				jsonFormatter = 'jq', -- yq/jq/none
				editSnippetPopup = {
					height = 0.4,
					width  = 0.6,
					border = 'solid',
					keymaps = {
						cancel                   = '<C-q>',
						saveChanges              = '<C-s>', -- alternatively, can also   use `:w`
						goBackToSearch           = '<Esc>',
						deleteSnippet            = '<Leader>x',
						duplicateSnippet         = '<Leader>d',
						openInFile               = '<C-o>',
						insertNextToken          = '<C-t>', -- insert         &   normal mode
						jumpBetweenBodyAndPrefix = '<C-y>', -- insert         &   normal mode
					},
				},
				telescope = {
					alsoSearchSnippetBody = true,
				},
			})
		end
	},
	{
		-- #surround: smartly edit surrounding chars like {}, [], "", etc.
		'kylechui/nvim-surround', enabled = true,
		config = function()
			require('nvim-surround').setup({
				keymaps = {
					-- insert          = '<C-g>s',
					-- insert_line     = '<C-g>S',
					normal          = 's',
					normal_cur      = 'ss',
					normal_line     = 'S',
					normal_cur_line = 'SS',
					visual          = 's',
					visual_line     = 'S',
					-- delete          = 'ds',
					-- change          = 'cs',
					-- change_line     = 'cS',
				},
			})
		end
	},
	---- #T ----
	{
		-- #telescope: fuzzy finder (*****)
		'nvim-telescope/telescope.nvim', enabled = true,
		dependencies = {'nvim-lua/plenary.nvim'},
		config = function()
			local actions = require('telescope.actions')
			local layout  = require('telescope.actions.layout')
			local mappings = {
				['<C-w>'] = actions.close,
				['<C-e>'] = actions.preview_scrolling_up,
				['<C-k>'] = actions.move_selection_previous,
				['<C-j>'] = actions.move_selection_next,
				['<C-p>'] = actions.cycle_history_prev,
				['<C-n>'] = actions.cycle_history_next,
				['<C-h>'] = layout.cycle_layout_prev,
				['<C-l>'] = layout.cycle_layout_next,
			}
			require('telescope').setup({
				defaults = {
					layout_strategy = 'vertical',
					mappings = {
						n = mappings,
						i = mappings,
					},
				},
			})
			local pick = require('telescope.builtin') -- builtin pickers
			map('telescope: Builtin',            'n', '<Leader>t',         pick.builtin)
			map('telescope: Files',              'n', '<Leader>f',         pick.find_files)
			map('telescope: Grep',               'n', '<Leader>g',         pick.live_grep)
			map('telescope: Buffers',            'n', '<Leader>b',         pick.buffers)
			map('telescope: Commands',           'n', '<Leader>;',         pick.commands)
			map('telescope: Help',               'n', '<Leader>h',         pick.help_tags)
			map('telescope: Marks',              'n', '<Leader>m',         pick.marks)
			map('telescope: Quickfix',           'n', '<Leader>q',         pick.quickfix)
			map('telescope: Options',            'n', '<Leader><Leader>o', pick.vim_options)
			map('telescope: Registers',          'n', '<Leader><Leader>r', pick.registers)
			map('telescope: Keymaps',            'n', '<Leader><Leader>k', pick.keymaps)
			map('telescope: Treesitter Symbols', 'n', '<Leader>s',         pick.treesitter)
			map('telescope: Commits',            'n', 'gC',                pick.git_commits)
			map('telescope: Commits: Buffer',    'n', 'gc',                pick.git_bcommits)
		end
	},
	{
		-- #tree: file-tree widget (***..)
		'nvim-tree/nvim-tree.lua', enabled = true,
		dependencies = {'nvim-tree/nvim-web-devicons'},
		config = function()
			-- disable netrw
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			local api = require('nvim-tree.api')
			local api_tree  = api.tree
			local api_node  = api.node
			local api_marks = api.marks
			local api_fs    = api.fs
			require('nvim-tree').setup({
				disable_netrw = true,
				hijack_cursor = true,
				filters = {
					git_ignored = true, -- hide ignored files?
					custom = {
						[[^\(\.git\|\.DS_Store\|Thumbs\.db\)$]],
					},
				},
				update_focused_file = {
					enable = true, -- highlight the current buffer
				},
				modified = {
					enable = true, -- highlight modified files
					show_on_dirs = true,
					show_on_open_dirs = false,
				},
				diagnostics = {
					enable = true, -- highlight the files with issues
				},
				filesystem_watchers = {
					enable = true,
					debounce_delay = 250, -- (ms) [default: 50]
					ignore_dirs = { -- this fixes the slow-shutdown issue
						'.git',
						'node_modules',
						'vendor',
						'build',
					},
				},
				actions = {
					open_file = {
						quit_on_open = false,
					},
					file_popup = { -- settings for show_info_popup
						open_win_config = {
							col = 0,
							row = 1,
							relative = 'cursor',
							border   = 'single',
							style    = 'minimal',
						},
					},
				},
				view = {
					float = {
						enable = false,
						open_win_config = {
							width  = 32,
							height = 24,
							row    = 0,
							col    = 1,
						},
					},
				},
				renderer = {
					special_files = {},
					root_folder_label = ':t',
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
						symlink_arrow = ' 󰌷 ',
						glyphs = {
							symlink = '󰌹',
						},
					},
				},
				help = {
					sort_by = 'desc',
				},
				on_attach = function(buf)
					local opts = {buffer = buf, nowait = true}
					local function open()
						local node = api_tree.get_node_under_cursor()
						api_node.open.edit()
						if node.open and node.nodes and #node.nodes > 0 then
							vim.api.nvim_feedkeys(my.fn.key('<Down>'), 'n', false)
						end
					end
					map('nvim-tree: Help',                   'n', '?',             api_tree.toggle_help,           opts)
					map('nvim-tree: Quit',                   'n', 'q',             api_tree.close,                 opts)
					map('nvim-tree: Refresh',                'n', 'R',             api_tree.reload,                opts)
					map('nvim-tree: Info',                   'n', 'i',             api_node.show_info_popup,       opts)
					map('nvim-tree: Close',                  'n', 'h',             api_node.navigate.parent_close, opts)
					map('nvim-tree: Close',                  'n', '<Left>',        api_node.navigate.parent_close, opts)
					map('nvim-tree: Open',                   'n', 'l',             open,                           opts)
					map('nvim-tree: Open',                   'n', '<Right>',       open,                           opts)
					map('nvim-tree: Open',                   'n', '<CR>',          open,                           opts)
					map('nvim-tree: Open',                   'n', '<2-LeftMouse>', open,                           opts)
					map('nvim-tree: Open & Close',           'n', 'e',             function()
						open()
						api_tree.close()
					end, opts)
					map('nvim-tree: Open: Vertical Split',   'n', 'I',             api_node.open.vertical,         opts)
					map('nvim-tree: Open: Horizontal Split', 'n', '-',             api_node.open.horizontal,       opts)
					map('nvim-tree: Open: System',           'n', 'o',             api_node.run.system,            opts)
					map('nvim-tree: Prev Sibling',           'n', 'K',             api_node.navigate.sibling.prev, opts)
					map('nvim-tree: Next Sibling',           'n', 'J',             api_node.navigate.sibling.next, opts)
					map('nvim-tree: Prev Git',               'n', 'gk',            api_node.navigate.git.prev,     opts)
					map('nvim-tree: Next Git',               'n', 'gj',            api_node.navigate.git.next,     opts)
					map('nvim-tree: Collapse All',           'n', 'x',             api_tree.collapse_all,          opts)
					map('nvim-tree: Expand All',             'n', 'X',             api_tree.expand_all,            opts)
					map('nvim-tree: Descend',                'n', '<Tab>',         api_tree.change_root_to_node,   opts)
					map('nvim-tree: Ascend',                 'n', 'u',             api_tree.change_root_to_parent, opts)
					map('nvim-tree: Ascend',                 'n', '<S-Tab>',       api_tree.change_root_to_parent, opts)
					map('nvim-tree: Create',                 'n', 'a',             api_fs.create,                  opts)
					map('nvim-tree: Copy',                   'n', 'y',             api_fs.copy.node,               opts)
					map('nvim-tree: Copy Relative Path',     'n', 'Y',             api_fs.copy.relative_path,      opts)
					map('nvim-tree: Copy Absolute Path',     'n', '<C-y>',         api_fs.copy.absolute_path,      opts)
					map('nvim-tree: Mark',                   'n', 'v',             function()
						api_marks.toggle()
						api_node.navigate.sibling.next()
					end, opts)
					map('nvim-tree: Cut (Move)',             'n', 'd',             function()
						if #api_marks.list() > 0
							then api_marks.bulk.move()
							else api_fs.cut()
						end
					end, opts)
					map('nvim-tree: Trash',                  'n', 'D',             function()
						if #api_marks.list() > 0
							then api_marks.bulk.trash()
							else api_fs.trash()
						end
					end, opts)
					map('nvim-tree: Paste',                  'n', 'p',             api_fs.paste,                   opts)
					map('nvim-tree: Rename',                 'n', 'r',             api_fs.rename,                  opts)
					map('nvim-tree: Run Command',            'n', ';',             api_node.run.cmd,               opts)
					map('nvim-tree: Filter',                 'n', 'f',             api.live_filter.start,          opts)
					map('nvim-tree: Filter',                 'n', 'F',             api.live_filter.start,          opts)
					map('nvim-tree: Clear',                  'n', '<Esc>',         function()
						api.live_filter.clear()
						api_marks.clear()
						api_tree.reload()
					end, opts, {remap = true})
					map('nvim-tree: Toggle Hidden',          'n', '.',             function()
						api_tree.toggle_gitignore_filter()
						api_tree.toggle_custom_filter()
					end, opts)
				end,
			})

			-- toggle focus nvim-tree
			map('nvim-tree: Toggle Focus', {'n','x','i','t'}, '<C-f>', function()
				if api_tree.is_tree_buf() then -- is current pane nvim-tree?
					my.fn.buf_cycle(0)
					return
				end
				-- switch to nvim-tree
				api_tree.find_file({open = true, current_window = false, focus = true})
				vim.api.nvim_feedkeys(my.fn.key('<Esc>'), 'n', false) -- force normal mode
				--   NOTE: stopinsert() doesn't work on visual mode
			end)

			-- close tree on leave
			if conf.tree.autoclose then
				autocmd('BufEnter', {
					callback = function(ctx)
						local buf = vim.fn.getbufinfo(ctx.buf)[1]
						if buf.listed == 1 then
							api_tree.close()
						end
					end
				})
			end

		end
	},
	{
		-- #treesitter: parser & syntax highlighter
		'nvim-treesitter/nvim-treesitter', enabled = true,
		dependencies = {
			-- optional modules:
			'nvim-treesitter/nvim-treesitter-refactor',
			--'nvim-treesitter/nvim-treesitter-textobjects',
			--'nvim-treesitter/nvim-treesitter-context',
		},
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
					enable = false,
				},
				refactor = { -- nvim-treesitter-refactor module is required
					navigation = {
						enable = false, -- doesn't always work. use LSP instead
					},
					highlight_definitions = {
						enable = true,
						clear_on_cursor_move = false,
					},
					highlight_current_scope = {
						enable = false,
					},
					smart_rename = {
						enable = false, -- this is not smart at all. don't use it
					}
				}
			})
		end
	},
	---- #U ----
	---- #V ----
	---- #W ----
	{
		-- #which-key: showing pending keybinds
		'folke/which-key.nvim', enabled = true,
		config = function()
			require('which-key').setup({
				-- options
			})
			require('which-key.config').options.operators = {} -- disable hooking `gc` operator
		end,
	},
	---- #X ----
	---- #Y ----
	---- #Z ----
}

-- themes
if conf.themes then
	local themes = require(my.ns..'themes')
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
	lockfile = my.root..'plugins-lock.json',
	defaults = { -- default options for each plugin
		lazy = false,
	},
	performance = {
		rtp = {
			disabled_plugins = conf.disable_builtins,
		}
	},
})

