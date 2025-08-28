local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

local packer_bootstrap = false
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = true
	print("Installing packer.nvim...")
	fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
	vim.cmd [[packadd packer.nvim]]
end

-- Load your plugins here
require("editor.plugins")

if packer_bootstrap then
	require('packer').sync()
	-- return here if you want to stop loading rest of config until plugins installed
	return
end

-- Workaround for deprecated functions
if vim.fn.has('nvim-0.10') == 0 then
	vim.tbl_islist = vim.isarray or vim.tbl_islist
end

-- Load all configs
for _, source in ipairs({
	"editor.options",
	"editor.keymaps",
	"editor.colorscheme",
}) do
	local status_ok, fault = pcall(require, source)
	if not status_ok then
		vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault)
	end
end
