---- THEMES ----
return {

	nordic = {
		'AlexvZyl/nordic.nvim',
	},

	gruvbox = {
		'ellisonleao/gruvbox.nvim',
	},

	tokyonight = {
		'folke/tokyonight.nvim',
		opts = {
			style = 'moon',
		},
	},

	kanagawa = {
		'rebelot/kanagawa.nvim',
		opts = {
			colors = {
				palette = {
					---- default ----
					-- sumiInk0 = '#16161d', -- border
					-- sumiInk1 = '#181820',
					-- sumiInk2 = '#1a1a22',
					-- sumiInk3 = '#1f1f28', -- background
					-- sumiInk4 = '#2a2a37',
					-- sumiInk5 = '#363646', -- line highlight
					-- sumiInk6 = '#54546d', -- whitespace
					-- fujiGray = '#727169', -- comments
				},
				theme = {
					wave = {
						ui = {
							bg_gutter  = 'none',
							bg_m3      = '#2a2a37', -- border
							bg_p2      = '#2a2a37', -- line highlight
							whitespace = '#363646',
						},
						syn = {
							comment = '#54546d',
						},
					},
				},
			},
			overrides = function(c)
				local th = c.theme
				return {
					---- Transparent floating windows ----
					NormalFloat = {bg = 'none'},
					FloatBorder = {bg = 'none'},
					FloatTitle  = {bg = 'none'},

					-- Save an hlgroup with dark background and dimmed foreground
					-- so that you can use it where your still want darker windows.
					-- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
					NormalDark = {fg = th.ui.fg_dim, bg = th.ui.bg_m3},

					-- Popular plugins that open floats will link to NormalFloat by default;
					-- set their background accordingly if you wish to keep them dark and borderless
					LazyNormal  = {bg = th.ui.bg_m3, fg = th.ui.fg_dim},
					MasonNormal = {bg = th.ui.bg_m3, fg = th.ui.fg_dim},
				}
			end,
		}
	},
}

