---- PLUGINS ----
local map = vim.keymap.set
local on_read = {'BufReadPre', 'BufNewFile'}

local plugins = {
	{
		-- jump around with keypresses (*****)
		'folke/flash.nvim', enabled = true,
		event = 'VeryLazy',
		config = function()
			local api = require('flash')
			api.setup({
				search = {
					mode = 'search', -- exact/search/fuzzy
					incremental = true,
				},
				jump = {
					nohlsearch = true, -- clear highlight after jump?
					autojump = true, -- automatically jump when there is only one match?
				},
				label = {
					uppercase = false, -- allow uppercase labels?
				},
				modes = {
					search = { -- '/' mode options
						enabled = true,
					},
					char = { -- 'f' mode options
						enabled = true,
						jump_labels = true, -- show jump labels?
						multi_line = true, -- multi-line or current-line-only
						keys = {'f','F','t','T'},
						label = {
							exclude = 'fthjkliardc', -- exclude these letters from jump labels
						},
					},
				},
			})
		end
	},
	{
		-- automatically close brackets (****.)
		'windwp/nvim-autopairs', enabled = true,
		event = 'VeryLazy',
		config = function()
			require('nvim-autopairs').setup({
				-- options
			})
		end
	},
	{
		-- jump around with keypresses (*****)
		'ggandor/leap.nvim', enabled = false,
		dependencies = {'tpope/vim-repeat'},
		event = 'VeryLazy',
		config = function()
			local api = require('leap')

			-- options
			local opts = api.opts
			opts.case_sensitive = true
			opts.max_highlighted_traversal_targets = 12
			opts.special_keys = {
				next_target = '<enter>',
				prev_target = '<tab>',
				next_group = '<space>',
				prev_group = '<tab>',
			}

			-- keymaps
			if true then -- use default?
				api.create_default_mappings()
			else -- custom keymaps
				map({'n','x','o'}, '<leader>l', '<Plug>(leap-forward)', {desc = 'Leap forward'})
				map({'n','x','o'}, '<leader>L', '<Plug>(leap-backward)', {desc = 'Leap backward'})
			end
		end
	},
	{
		-- guess indent style (***..)
		'nmac427/guess-indent.nvim', enabled = true,
		event = on_read,
		config = function()
			require('guess-indent').setup({
				auto_cmd = true,
				override_editorconfig = false,
				filetype_exclude = {
					'netrw',
					'tutor',
				},
				buftype_exclude = {
					'help',
					'nofile',
					'terminal',
					'prompt',
				},
			})
		end
	},
	{
		-- file-tree widget (***..)
		'nvim-tree/nvim-tree.lua', enabled = true,
		dependencies = {'nvim-tree/nvim-web-devicons'},
		lazy = false,
		init = function()
			-- disable netrw
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		config = function()
			local api = require('nvim-tree.api')
			require('nvim-tree').setup({
				filters = {
					git_ignored = false, -- do not hide ignored files
					custom = {
						'.git',
						'.DS_Store'
					},
				},
				diagnostics = {
					enable = true,
				},
				modified = {
					enable = true,
				},
				renderer = {
					special_files = {},
					highlight_git = 'name', -- none/icon/name/all
					highlight_diagnostics = 'name',
					highlight_opened_files = 'none',
					highlight_modified = 'name',
					icons = {
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
						show = {
							git = false,
						},
					},
				},
				on_attach = function(bufnr)
					local function desc(s)
						return {desc = 'nvim-tree: ' .. s, buffer = bufnr, noremap = true, silent = true, nowait = true}
					end
					-- default keymaps
					map('n', '<C-]>', api.tree.change_root_to_node,          desc 'CD')
					--map('n', '<C-e>', api.node.open.replace_tree_buffer,     desc 'Open: In Place')
					map('n', '<C-k>', api.node.show_info_popup,              desc 'Info')
					--map('n', '<C-r>', api.fs.rename_sub,                     desc 'Rename: Omit Filename')
					map('n', '<C-t>', api.node.open.tab,                     desc 'Open: New Tab')
					map('n', '<C-v>', api.node.open.vertical,                desc 'Open: Vertical Split')
					map('n', '<C-x>', api.node.open.horizontal,              desc 'Open: Horizontal Split')
					map('n', '<BS>',  api.node.navigate.parent_close,        desc 'Close Directory')
					map('n', '<CR>',  api.node.open.edit,                    desc 'Open')
					map('n', '<Tab>', api.node.open.preview,                 desc 'Open Preview')
					map('n', '>',     api.node.navigate.sibling.next,        desc 'Next Sibling')
					map('n', '<',     api.node.navigate.sibling.prev,        desc 'Previous Sibling')
					map('n', '.',     api.node.run.cmd,                      desc 'Run Command')
					map('n', '-',     api.tree.change_root_to_parent,        desc 'Up')
					map('n', 'a',     api.fs.create,                         desc 'Create')
					map('n', 'bmv',   api.marks.bulk.move,                   desc 'Move Bookmarked')
					--map('n', 'B',     api.tree.toggle_no_buffer_filter,      desc 'Toggle No Buffer')
					map('n', 'c',     api.fs.copy.node,                      desc 'Copy')
					--map('n', 'C',     api.tree.toggle_git_clean_filter,      desc 'Toggle Git Clean')
					map('n', '[c',    api.node.navigate.git.prev,            desc 'Prev Git')
					map('n', ']c',    api.node.navigate.git.next,            desc 'Next Git')
					map('n', 'd',     api.fs.remove,                         desc 'Delete')
					map('n', 'D',     api.fs.trash,                          desc 'Trash')
					map('n', 'E',     api.tree.expand_all,                   desc 'Expand All')
					map('n', 'e',     api.fs.rename_basename,                desc 'Rename: Basename')
					--map('n', ']e',    api.node.navigate.diagnostics.next,    desc 'Next Diagnostic')
					--map('n', '[e',    api.node.navigate.diagnostics.prev,    desc 'Prev Diagnostic')
					map('n', 'F',     api.live_filter.clear,                 desc 'Clean Filter')
					map('n', 'f',     api.live_filter.start,                 desc 'Filter')
					map('n', 'g?',    api.tree.toggle_help,                  desc 'Help')
					map('n', 'gy',    api.fs.copy.absolute_path,             desc 'Copy Absolute Path')
					map('n', 'H',     api.tree.toggle_hidden_filter,         desc 'Toggle Dotfiles')
					map('n', 'I',     api.tree.toggle_gitignore_filter,      desc 'Toggle Git Ignore')
					map('n', 'J',     api.node.navigate.sibling.last,        desc 'Last Sibling')
					map('n', 'K',     api.node.navigate.sibling.first,       desc 'First Sibling')
					map('n', 'm',     api.marks.toggle,                      desc 'Toggle Bookmark')
					map('n', 'o',     api.node.open.edit,                    desc 'Open')
					map('n', 'O',     api.node.open.no_window_picker,        desc 'Open: No Window Picker')
					map('n', 'p',     api.fs.paste,                          desc 'Paste')
					map('n', 'P',     api.node.navigate.parent,              desc 'Parent Directory')
					map('n', 'q',     api.tree.close,                        desc 'Close')
					map('n', 'r',     api.fs.rename,                         desc 'Rename')
					map('n', 'R',     api.tree.reload,                       desc 'Refresh')
					--map('n', 's',     api.node.run.system,                   desc 'Run System')
					--map('n', 'S',     api.tree.search_node,                  desc 'Search')
					map('n', 'U',     api.tree.toggle_custom_filter,         desc 'Toggle Hidden')
					map('n', 'W',     api.tree.collapse_all,                 desc 'Collapse')
					map('n', 'x',     api.fs.cut,                            desc 'Cut')
					map('n', 'y',     api.fs.copy.filename,                  desc 'Copy Name')
					map('n', 'Y',     api.fs.copy.relative_path,             desc 'Copy Relative Path')
					map('n', '<2-LeftMouse>',  api.node.open.edit,           desc 'Open')
					map('n', '<2-RightMouse>', api.tree.change_root_to_node, desc 'CD')
				end,
			})
			-- toggle focus nvim-tree
			map({'n','v','i','t'}, '<C-e>',
				function()
					if api.tree.is_tree_buf() then -- is current pane nvim-tree?
						local key = '<C-w>p' -- ctrl+w,p = switch to previous window
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'n', false) -- emulate keypresses
						return
					end
					-- switch to nvim-tree
					vim.cmd('stopinsert') -- force normal mode
					api.tree.find_file({
						open = true, current_window = false,
						focus = true,
					})
				end,
				{desc = 'Toggle nvim-tree'}
			)
		end
	},
	{
		-- smartly edit surrounding chars like {}, [], "", etc.
		'kylechui/nvim-surround', enabled = true,
		event = 'VeryLazy',
		config = function()
			require('nvim-surround').setup({
				-- options
			})
		end
	},
	{
		-- fuzzy finder (*****)
		'nvim-telescope/telescope.nvim', enabled = true,
		dependencies = {'nvim-lua/plenary.nvim'},
		event = 'VimEnter',
		config = function()
			local api = require('telescope')
			api.setup({
				-- options
			})
			---- KEYMAPS ----
			api = require('telescope.builtin')
			local function desc(msg)
				return {desc = 'telescope: '..msg}
			end
			map('n', '<leader>t',  api.builtin, desc 'Telescope')
			map('n', '<leader>ff', api.find_files, desc 'Find Files')
			map('n', '<leader>fg', api.live_grep, desc 'Live Grep')
			map('n', '<leader>fb', api.buffers, desc 'Buffers')
			map('n', '<leader>f;', api.commands, desc 'Commands')
			map('n', '<leader>fh', api.help_tags, desc 'Help')
			map('n', '<leader>fm', api.man_pages, desc 'Man Pages')
			map('n', '<leader>fq', api.quickfix, desc 'Quickfix')
			map('n', '<leader>fv', api.vim_options, desc 'Vim Options')
			map('n', '<leader>fr', api.registers, desc 'Registers')
			map('n', '<leader>fk', api.keymaps, desc 'Key Maps')
			map('n', '<leader>fs', api.treesitter, desc 'Treesitter Symbols')
			map('n', '<leader>fC', api.git_commits, desc 'Commits')
			map('n', '<leader>fc', api.git_bcommits, desc 'Commits for the buffer')
			--map('v', '<leader>fc', api.git_bcommits_range, desc 'Commits in the range')
			--   NOTE: this causes error bc 'git_bcommits_range' is nil. no idea how to fix it.
		end
	},
	{
		-- cheatsheet
		'sudormrfbin/cheatsheet.nvim', enabled = true,
		dependencies = {'nvim-telescope/telescope.nvim'},
		event = 'VeryLazy',
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
		-- shows pending keybinds
		'folke/which-key.nvim', enabled = true,
		event = 'VeryLazy',
		config = function()
			local api = require('which-key')
			api.setup()
		end,
	},
	{
		-- shows git related signs to the gutter (*****)
		'lewis6991/gitsigns.nvim', enabled = true,
		event = on_read,
		config = function()
			local api = require('gitsigns')
			api.setup({
				signs = {
					add          = {text = '+'}, -- {text = '│'},
					change       = {text = '*'}, -- {text = '│'},
					delete       = {text = '_'},
					topdelete    = {text = '‾'},
					changedelete = {text = '~'},
					untracked    = {text = '┆'},
				},
				on_attach = function(bufnr)
					local function desc(msg, opts)
						local r = opts or {}
						r.desc = 'gitsigns: '..msg
						r.buffer = bufnr
						return r
					end
					---- KEYMAPS ----
					-- prev hunk
					map('n', '[c',
						function()
							if vim.wo.diff then return '[c' end
							vim.schedule(api.prev_hunk)
							return '<Ignore>'
						end,
						desc('Previous hunk', {expr = true})
					)
					-- next hunk
					map('n', ']c',
						function()
							if vim.wo.diff then return ']c' end
							vim.schedule(api.next_hunk)
							return '<Ignore>'
						end,
						desc('Next hunk', {expr = true})
					)
					-- stage hunk
					map('n', '<leader>gs', api.stage_hunk, desc 'Stage hunk')
					map('v', '<leader>gs', function() api.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, desc 'Stage hunk')
					-- reset hunk
					map('n', '<leader>gr', api.reset_hunk, desc 'Reset hunk')
					map('v', '<leader>gr', function() api.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, desc 'Reset hunk')
					-- stage the whole buffer
					map('n', '<leader>gS', api.stage_buffer, desc 'Stage buffer')
					-- undo stage hunk
					map('n', '<leader>gu', api.undo_stage_hunk, desc 'Undo stage hunk')
					-- reset the whole buffer
					map('n', '<leader>gR', api.reset_buffer, desc 'Reset buffer')
					-- preview hunk
					map('n', '<leader>gp', api.preview_hunk, desc 'Preview hunk')
					-- blame line
					map('n', '<leader>gb', function() api.blame_line {full = true} end, desc 'Blame line')
					-- toggle blame
					map('n', '<leader>gB', api.toggle_current_line_blame, desc 'Toggle blame')
					-- diff
					map('n', '<leader>gd', api.diffthis, desc 'Diff')
					map('n', '<leader>gD', function() api.diffthis('~') end, desc 'Diff')
					-- toggle deleted
					map('n', '<leader>gx', api.toggle_deleted, desc 'Toggle deleted')
				end,
			})
		end
	},

}

-- lsp, syntax-highlighter, etc.
for _,v in ipairs(require(ns_custom..'langs')) do
	table.insert(plugins, v)
end

-- themes
local themes = require(ns_custom..'themes')
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

-- install plugins
require('lazy').setup(plugins, {
	defaults = { -- default options for each plugin
		lazy = true,
		version = '*', -- try installing the latest stable versions of plugins
	},
	lockfile = vim.fn.stdpath('config')..'/lua/'..
		ns_custom:gsub('%.', '/').. -- replace '.' with '/'
		'plugins-lock.json'
})

