local home_dir = vim.loop.os_homedir()

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

-- code indent
vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.smartindent = true

-- encodeing
vim.opt.langmenu = "zh_CN.UTR-8"
vim.opt.helplang = "cn"
vim.opt.encoding = "utf8"

-- Plugin config
local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
end

require "plugins"

