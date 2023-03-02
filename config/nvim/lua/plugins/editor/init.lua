local conf = require 'plugins.editor.conf'

return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = require 'plugins.editor.telescope'
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-telescope/telescope-dap.nvim' },
    { 'nvim-telescope/telescope-symbols.nvim' },
    { 'nvim-telescope/telescope-frecency.nvim' },
    --[[
    --      Treesitter
    --]]
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = require 'plugins.editor.treesitter',
    },
    { 'andymass/vim-matchup' },
    { 'p00f/nvim-ts-rainbow' },
    { 'nvim-treesitter/nvim-treesitter-refactor' },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'windwp/nvim-autopairs',                      config = conf.autopairs },
    { 'numToStr/Comment.nvim',                      config = require 'plugins.editor.comment' },
    { 'j-hui/fidget.nvim',                          config = conf.fidget },
    { 'yaocccc/nvim-foldsign',                      event = 'CursorHold',                        config = 'require("nvim-foldsign").setup()' },
    { 'lewis6991/gitsigns.nvim',                    config = conf.gitsigns },
    { 'akinsho/nvim-toggleterm.lua',                config = require 'plugins.editor.toggleterm' },
    {
        'glacambre/firenvim',
        build = function()
            vim.fn['firenvim#install'](0)
        end,
    },
    { 'Pocco81/true-zen.nvim', config = conf.zen_mode },
    { 'phaazon/hop.nvim',      config = conf.hop },

    --[[
    --      Project & Session
    --]]
    {
        'rmagatti/auto-session',
        priority = 10000,
        config = require 'plugins.editor.session'
    },
}
