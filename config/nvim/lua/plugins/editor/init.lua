local conf = require 'plugins.editor.conf'

local M = {}

function M.load_plugins(use)
    use { 'nvim-telescope/telescope.nvim', config = require 'plugins.editor.telescope' }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { 'nvim-telescope/telescope-hop.nvim' }
    use { 'nvim-telescope/telescope-dap.nvim' }
    use { 'nvim-telescope/telescope-symbols.nvim' }
    use { 'nvim-telescope/telescope-frecency.nvim' }
    --[[
    --      Treesitter
    --]]
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = require 'plugins.editor.treesitter',
    }
    use { 'andymass/vim-matchup' }
    use { 'p00f/nvim-ts-rainbow' }
    use { 'nvim-treesitter/nvim-treesitter-refactor' }
    use { 'nvim-treesitter/nvim-treesitter-textobjects' }

    --[[
    --       Installer for third executable
    --]]
    use { 'williamboman/mason.nvim', config = conf.mason }
    use { 'williamboman/mason-lspconfig.nvim', config = conf.mason_lspconfig }

    use { 'windwp/nvim-autopairs', config = conf.autopairs }
    use { 'numToStr/Comment.nvim', config = require 'plugins.editor.comment' }
    use { 'lewis6991/gitsigns.nvim', config = conf.gitsigns }
    use { 'akinsho/nvim-toggleterm.lua', config = require 'plugins.editor.toggleterm' }
    use {
        'glacambre/firenvim',
        run = function()
            vim.fn['firenvim#install'](0)
        end,
    }
    use { 'Pocco81/true-zen.nvim', config = conf.zen_mode }

    --[[
    --      Project & Session
    --]]
    use { 'rmagatti/auto-session', config = require 'plugins.editor.session' }

end

return M
