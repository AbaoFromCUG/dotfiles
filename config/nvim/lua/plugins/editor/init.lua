local conf = require 'plugins.editor.conf'


local function ufo()
    vim.o.foldcolumn = '1' -- '0' is not bad
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

    require 'ufo'.setup {
        provider_selector = function(bufnr, filetype, buftype)
            return { 'treesitter', 'indent' }
        end,
    }
end

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

    -- treesitter highlight
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = require 'plugins.editor.treesitter',
    },
    { 'andymass/vim-matchup' },
    { 'p00f/nvim-ts-rainbow' },
    { 'nvim-treesitter/nvim-treesitter-refactor' },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    {
        'windwp/nvim-autopairs',
        opts = {
            check_ts = true,
        }
    },
    -- fold
    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        config = ufo,
    },

    -- surround edit
    {
        'kylechui/nvim-surround',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        config = true
    },

    -- search and replace
    { 'cshuaimin/ssr.nvim',      config = true },

    -- annotation gen
    {
        'danymat/neogen',
        dependencies = 'nvim-treesitter/nvim-treesitter',
        config = true,
    },

    -- comment
    { 'numToStr/Comment.nvim',   config = require 'plugins.editor.comment' },

    -- git
    { 'lewis6991/gitsigns.nvim', config = conf.gitsigns },
    {
        'sindrets/diffview.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        config = true,
    },

    -- terminal
    { 'akinsho/nvim-toggleterm.lua', config = require 'plugins.editor.toggleterm' },
    {
        'glacambre/firenvim',
        build = function()
            vim.fnk 'firenvim#install' (0)
        end,
    },

    -- zen mode
    { 'Pocco81/true-zen.nvim',       config = conf.zen_mode },

    -- jump anywhere
    { 'phaazon/hop.nvim',            config = conf.hop },

    -- session
    {
        'rmagatti/auto-session',
        priority = 10000,
        config = require 'plugins.editor.session'
    },
}
