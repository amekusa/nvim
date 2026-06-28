---[ Amekusa's NeoVim Configuration ]---
-- github.com/amekusa/nvim

-- localize globals
local vim = vim

-- namespace
local ns = (...)..'.'

-- root path
local root = vim.fn.stdpath('config')..'/lua/'..string.gsub(ns, '%.', '/') -- replace '.' in namespace with '/'

-- default config
local conf = require(ns..'config-default')

-- user config (if it exists)
if vim.fn.filereadable(root..'config.lua') ~= 0 then
	conf = vim.tbl_deep_extend('force', conf, require(ns..'config'))
end

-- enable vim.loader
-- NOTE: Cached lua files are in ~/.cache/nvim/luac
if conf.loader then
	require('vim.fs')
	vim.loader.enable()
end

-- globals
local expose = {
	ns   = ns,
	root = root,
	conf = conf,
	var  = {},
}

-- functions
expose.fn = require(ns..'fn')

-- expose globals
_custom = expose

-- load modules
if conf.options.enable then require(ns..'options') end
if conf.keymaps.enable then require(ns..'keymaps') end
if conf.plugins.enable then require(ns..'plugins') end
if conf.autocmds.enable then require(ns..'autocmds') end

