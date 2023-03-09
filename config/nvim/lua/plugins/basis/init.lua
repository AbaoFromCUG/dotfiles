local conf = require 'plugins.basis.conf'

return {
    'nvim-lua/plenary.nvim',
    'nvim-lua/popup.nvim',
    'tami5/sqlite.lua',
    'nvim-tree/nvim-web-devicons',
    {
        'folke/which-key.nvim',
        lazy = true,
        config = true,
    },
    -- installer
    { 'williamboman/mason.nvim', config = conf.mason },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = 'mason.nvim',
        config = conf.mason_lspconfig
    },
    {
        'jayp0521/mason-null-ls.nvim',
        dependencies = 'mason.nvim',
        config = conf.mason_null_ls
    },
    {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = 'mason.nvim',
        config = conf.mason_dap
    },
}
