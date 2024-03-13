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
vim.opt.spell = true

-- encoding
vim.opt.langmenu = "zh_CN.UTF-8"
vim.opt.helplang = "cn"
vim.opt.encoding = "utf8"

vim.opt.laststatus = 3
vim.opt.swapfile = false
vim.opt.sessionoptions = { "buffers", "curdir", "folds", "winsize", "winpos", "terminal" }

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

local uname = vim.loop.os_uname()
if uname.sysname == "Windows_NT" then
    -- for mason.nvim
    vim.g.python3_host_prog = vim.fn.exepath("python")
elseif uname.release:find("WSL") then
    -- WSL
    vim.system({ "/mnt/c/Windows/system32/cmd.exe", "/c", "echo", "%path%" }, { text = true }, function(obj)
        local paths = string.gsub(obj.stdout, "C:", "/mnt/c")
        paths = paths:gsub("\\", "/")
        paths = paths:gsub(";", ":")
        vim.schedule(function()
            vim.env.PATH = vim.env.PATH .. ":" .. paths
        end)
    end)
end

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
