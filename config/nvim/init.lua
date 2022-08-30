vim.opt.filetype = "on"
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.cursorline = true
vim.opt.hidden = true
vim.opt.termguicolors = true
vim.opt.relativenumber = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- code indent
vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.smartindent = true

-- encoding
vim.opt.langmenu = "zh_CN.UTR-8"
vim.opt.helplang = "cn"
vim.opt.encoding = "utf8"


vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Packer Bootstrapping
local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
    vim.cmd [[packadd packer.nvim]]
end

require "plugins"
require "keymaps.global"
