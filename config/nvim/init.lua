vim.opt.filetype = 'on'
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.cursorline = true
vim.opt.hidden = true
vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.linebreak = true
vim.opt.foldlevel = 10
vim.opt.list = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.magic = false

-- code indent
vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.smartindent = true

-- encoding
vim.opt.langmenu = 'zh_CN.UTF-8'
vim.opt.helplang = 'cn'
vim.opt.encoding = 'utf8'

vim.opt.laststatus = 3
vim.opt.swapfile = false


vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0


_G.pprint = function(...)
    vim.notify(vim.inspect(...))
end


require 'plugins'
