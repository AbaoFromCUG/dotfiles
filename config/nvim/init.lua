vim.opt.filetype = "on"
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.cursorline = true
vim.opt.hidden = true
vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.linebreak = true
vim.opt.list = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.magic = false

-- code indent
-- vim.opt.autoindent = true
-- vim.opt.cindent = true
-- vim.opt.smartindent = true

-- encoding
vim.opt.langmenu = "zh_CN.UTF-8"
vim.opt.helplang = "cn"
vim.opt.encoding = "utf8"

vim.opt.laststatus = 3
vim.opt.swapfile = false
vim.opt.sessionoptions = { "blank", "buffers", "curdir", "folds", "help", "tabpages", "winsize", "winpos", "terminal" }

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local opts = {
    dev = {
        path = "~/Documents/plugins",
    },
}

require("lazy").setup("plugins", opts)
