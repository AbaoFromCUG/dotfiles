local conf = require 'plugins.lsp.conf'

return {
    -- completion engine
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'ray-x/cmp-treesitter',
            'paopaol/cmp-doxygen',
            'hrsh7th/cmp-vsnip',
        },
        config = require 'plugins.lsp.cmp'
    },
    -- completion source
    { 'hrsh7th/vim-vsnip',               config = conf.snippet },
    { 'rafamadriz/friendly-snippets' },
    -- show signature
    { 'ray-x/lsp_signature.nvim',        config = conf.signature },
    -- pictograms for lsp
    { 'onsails/lspkind-nvim' },
    -- diagnostic list
    { 'folke/trouble.nvim',              config = require 'plugins.lsp.trouble' },
    { 'jose-elias-alvarez/null-ls.nvim', config = require 'plugins.lsp.null-ls' },
    { 'folke/neodev.nvim',               config = true },

    { 'neovim/nvim-lspconfig',           config = require 'plugins.lsp.lspconfig' },
}
