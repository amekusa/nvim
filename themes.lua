---- THEMES ----
local theme = 'kanagawa' -- choose from below
local themes = {
	nordic = {'AlexvZyl/nordic.nvim'},
	gruvbox = {'ellisonleao/gruvbox.nvim'},
	tokyonight = {'folke/tokyonight.nvim'},
	kanagawa = {'rebelot/kanagawa.nvim'},
}

-- theme options
local t = themes[theme]
if theme == 'tokyonight' then
	t.opts = {
		style = 'moon',
	}

elseif theme == 'kanagawa' then
	t.opts = {
		colors = {
			palette = {
				---- default palette ----
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
						bg_gutter = 'none',
						bg_p2 = '#2a2a37', -- line highlight
						whitespace = '#363646',
					},
					syn = {
						comment = '#54546d',
					},
				},
			},
		},
	}

end

return {
	select = theme,
	list = themes
}

