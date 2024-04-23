---- EXPERIMENTS ----
-- do not load this file.


-- testing TSNode (treesitter node)
vim.api.nvim_create_user_command('Foo', function(args)
	local node = vim.treesitter.get_node()
	--vim.print(node:sexpr())
	local parent = node:parent()
	vim.print(parent:type())
end, {desc = 'Foo'})


-- testing rerieving lines in buffer
vim.api.nvim_create_user_command('Wah', function(args)
	--vim.print(args)
	local row,col = unpack(vim.api.nvim_win_get_cursor(0))
	local range = 4
	local from = row - (range + 1)
	if from < 0 then from = 0 end
	local to = row + range
	local lines = vim.api.nvim_buf_get_lines(0, from, to, false)
	for i,v in ipairs(lines) do
		vim.print(lines[i])
	end
	vim.print(lines)
end, {desc = 'My Custom Command'});

