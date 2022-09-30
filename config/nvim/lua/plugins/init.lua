-- Packer Bootstrapping
local fn = vim.fn
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd [[packadd packer.nvim]]
end

local packer = require 'packer'
packer.init {
    max_jobs = 10
}

packer.startup(function(use)
    require 'plugins.basis'.load_plugins(use)
    require 'plugins.ui'.load_plugins(use)
    require 'plugins.lsp'.load_plugins(use)
    require 'plugins.dap'.load_plugins(use)
    require 'plugins.editor'.load_plugins(use)
    require 'plugins.misc'.load_plugins(use)
end)
