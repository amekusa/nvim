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
				-- sumiink0 = '#16161d', -- border
				-- sumiink1 = '#181820',
				-- sumiink2 = '#1a1a22',
				-- sumiink3 = '#1f1f28', -- background
				-- sumiink4 = '#2a2a37',
				-- sumiink5 = '#363646', -- line highlight
				-- sumiink6 = '#54546d', -- whitespace
				-- fujiGray = '#727169', -- comments
			},
			theme = {
				wave = {
					ui = {
						bg_gutter = 'none',
						bg_p2 = '#1a1a22', -- line highlight
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

