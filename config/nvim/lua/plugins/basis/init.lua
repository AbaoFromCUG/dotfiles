local conf = require 'plugins.basis.conf'
local M = {}

function M.load_plugins(use)
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-lua/popup.nvim'
    use 'skywind3000/asyncrun.vim'
    use 'tami5/sqlite.lua'
    use 'kyazdani42/nvim-web-devicons'

    use { 'folke/which-key.nvim', config = conf.which_key }

    -- installer
    use { 'williamboman/mason.nvim', config = conf.mason }
    use { 'williamboman/mason-lspconfig.nvim', dependencies = 'mason.nvim', config = conf.mason_lspconfig }
    use { 'jayp0521/mason-null-ls.nvim', dependencies = 'mason.nvim', config = conf.mason_null_ls }
    use { 'jay-babu/mason-nvim-dap.nvim', dependencies = 'mason.nvim', config = conf.mason_dap }
end

return M
