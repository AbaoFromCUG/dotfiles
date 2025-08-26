vim.opt.exrc = true

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
vim.opt.spelllang = "en,cjk"

-- encoding
vim.opt.langmenu = "zh_CN.UTF-8"
vim.opt.helplang = "cn"
vim.opt.encoding = "utf8"

vim.opt.splitbelow = true
vim.opt.splitright = true

-- edgy.nvim
vim.opt.laststatus = 3
vim.opt.splitkeep = "screen"

vim.opt.swapfile = false
vim.opt.sessionoptions = { "buffers", "folds", "curdir", "winsize", "winpos" }

vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.opt.fillchars = {
    eob = " ",
    fold = " ",
    foldopen = "",
    foldsep = " ",
    foldclose = ""
}

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

-- nvim-tree required
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- vim.o.switchbuf = "useopen"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end


vim.opt.rtp:prepend(lazypath)

-- Add support for the LazyFile event
local Event = require("lazy.core.handler.event")

local lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }
Event.mappings.LazyFile = { id = "LazyFile", event = lazy_file_events }
Event.mappings["User LazyFile"] = Event.mappings.LazyFile

require("lazy").setup({
    spec = {
        { import = "plugins.core",       cond = not vim.g.vscode },
        { import = "plugins.snacks",     cond = not vim.g.vscode },
        { import = "plugins.ui",         cond = not vim.g.vscode },
        { import = "plugins.heirline",   cond = not vim.g.vscode },
        { import = "plugins.editor",     cond = not vim.g.vscode },
        { import = "plugins.misc",       cond = not vim.g.vscode },
        { import = "plugins.complete",   cond = not vim.g.vscode },
        { import = "plugins.diagnostic", cond = not vim.g.vscode },
        { import = "plugins.dap",        cond = not vim.g.vscode },
        { import = "plugins.test",       cond = not vim.g.vscode },
        { import = "plugins.ai",         cond = (not not vim.env.AI_CODER_KEY) and (not vim.g.vscode) },
        { import = "plugins.luasnip",    cond = not vim.g.vscode },
        { import = "plugins.neopyter",   cond = not vim.g.vscode },
        { import = "plugins.latex",      cond = not vim.g.vscode },
        { import = "plugins.leetcode",   cond = not vim.g.vscode },

    },

    rocks = {
        hererocks = true,
    },
    dev = {
        path = "~/Documents/plugins",
        fallback = true,
    },
    defaults = {
        lazy = true,
    },

})


vim.cmd([[colorscheme nightfox]])
