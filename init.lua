---[ Amekusa's NeoVim Configuration ]---
-- github.com/amekusa/nvim

local vim = vim

-- namespace
local ns = (...)..'.'

-- root path
local root = vim.fn.stdpath('config')..'/lua/'..ns:gsub('%.', '/') -- replace '.' in namespace with '/'

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

-- custom global
_custom = {
	ns   = ns,
	root = root,
	conf = conf,
	var  = {},
}

-- functions
_custom.fn = require(ns..'fn')

-- load modules
if conf.options.enable then require(ns..'options') end
if conf.keymaps.enable then require(ns..'keymaps') end
if conf.plugins.enable then require(ns..'plugins') end
if conf.autocmds.enable then require(ns..'autocmds') end

