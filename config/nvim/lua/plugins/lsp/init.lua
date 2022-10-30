local conf = require 'plugins.lsp.conf'

local M = {}


function M.load_plugins(use)
    use { 'neovim/nvim-lspconfig', config = require 'plugins.lsp.lspconfig' }
    -- completion engine
    use { 'hrsh7th/nvim-cmp', config = require 'plugins.lsp.cmp' }
    -- completion source
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'hrsh7th/cmp-buffer' }
    use { 'hrsh7th/cmp-path' }
    use { 'hrsh7th/cmp-cmdline' }
    use { 'ray-x/cmp-treesitter' }
    use { 'paopaol/cmp-doxygen' }
    -- snippets
    use { 'hrsh7th/cmp-vsnip' }
    use { 'hrsh7th/vim-vsnip', config = conf.snippet }
    use { 'rafamadriz/friendly-snippets' }
    -- show signature
    use { 'ray-x/lsp_signature.nvim', config = conf.signature }
    -- pictograms for lsp
    use { 'onsails/lspkind-nvim' }
    -- diagnostic list
    use { 'folke/trouble.nvim', config = require 'plugins.lsp.trouble' }

    use { 'jose-elias-alvarez/null-ls.nvim', config = require 'plugins.lsp.null-ls' }

end

return M
