---[ Amekusa's NeoVim Configuration ]---
-- github.com/amekusa/nvim

local vim = vim

-- global namespace
_custom = {
	ns = (...)..'.',
	var = {},
}
local my = _custom

-- root path
my.path = vim.fn.stdpath('config')..'/lua/'..my.ns:gsub('%.', '/') -- replace '.' in namespace with '/'

-- default config
my.conf = require(my.ns..'config-default')

-- user config (if it exists)
if vim.fn.filereadable(my.path..'config.lua') ~= 0 then
	my.conf = vim.tbl_deep_extend('force', my.conf, require(my.ns..'config'))
end

-- detect current os
if not my.conf.uname then
	local uname = vim.uv.os_uname().sysname:lower()
	if uname:find('darwin') then
		my.os = 'mac'
	elseif uname:find('windows') then
		my.os = 'win'
	else
		my.os = 'linux'
	end
end

-- enable vim.loader
-- NOTE: Cached lua files are in ~/.cache/nvim/luac
if my.conf.loader then
	require('vim.fs')
	vim.loader.enable()
end

-- functions
my.fn = require(my.ns..'fn')

-- load modules
if my.conf.options.enable then require(my.ns..'options') end
if my.conf.keymaps.enable then require(my.ns..'keymaps') end
if my.conf.plugins.enable then require(my.ns..'plugins') end
if my.conf.autocmds.enable then require(my.ns..'autocmds') end

