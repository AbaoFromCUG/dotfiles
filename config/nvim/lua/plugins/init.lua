return require 'packer'.startup(function(use)
    --[[
    --      Basic
    --]]
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-lua/popup.nvim'
    use 'skywind3000/asyncrun.vim'
    use 'tami5/sqlite.lua'
    use 'kyazdani42/nvim-web-devicons'
    --[[
    --      UI & Theme
    --]]
    -- theme & color
    use { 'glepnir/zephyr-nvim', config = require 'plugins.theme' }
    use { 'ellisonleao/gruvbox.nvim' }
    -- color text colorizer, e.g. #5F9EA0 Aqua #91f
    use { 'NvChad/nvim-colorizer.lua', config = require 'plugins.colorizer' }
    -- tab line
    use { 'akinsho/bufferline.nvim', config = require 'plugins.bufferline' }
    -- status line
    use { 'hoob3rt/lualine.nvim', config = require 'plugins.lualine' }
    use { 'arkav/lualine-lsp-progress' }
    use { 'SmiteshP/nvim-navic', config = require 'plugins.code-navigation' }
    use { 'lukas-reineke/indent-blankline.nvim', config = require 'plugins.indent_blankline' }
    use {
        'petertriho/nvim-scrollbar',
        config = function()
            require 'scrollbar'.setup()
        end,
    }
    use { 'rcarriga/nvim-notify', config = require 'plugins.notify' }
    use { 'stevearc/dressing.nvim', config = require 'plugins.dressing' }

    use { 'nvim-telescope/telescope.nvim', config = require 'plugins.telescope' }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { 'nvim-telescope/telescope-hop.nvim' }
    use { 'nvim-telescope/telescope-project.nvim' }
    use { 'nvim-telescope/telescope-dap.nvim' }
    use { 'nvim-telescope/telescope-symbols.nvim' }
    use { 'nvim-telescope/telescope-frecency.nvim' }

    --[[
    --      Treesitter
    --]]
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = require 'plugins.treesitter',
    }
    use { 'andymass/vim-matchup' }
    use { 'p00f/nvim-ts-rainbow' }
    use { 'nvim-treesitter/nvim-treesitter-refactor' }
    use { 'nvim-treesitter/nvim-treesitter-textobjects' }

    --[[
    --       Language server protocol
    --]]
    use { 'neovim/nvim-lspconfig', config = require 'plugins.lspconfig' }
    -- completion engine
    use { 'hrsh7th/nvim-cmp', config = require 'plugins.cmp' } -- Autocompletion plugin
    -- completion source
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'hrsh7th/cmp-buffer' }
    use { 'hrsh7th/cmp-path' }
    use { 'hrsh7th/cmp-cmdline' }
    use { 'ray-x/cmp-treesitter' }
    -- snippets
    use { 'hrsh7th/cmp-vsnip' }
    use { 'hrsh7th/vim-vsnip', config = require 'plugins.snippet' }
    use { 'rafamadriz/friendly-snippets' }
    -- show signature
    use { 'ray-x/lsp_signature.nvim', config = require 'plugins.lsp_signature' }
    -- pictograms for lsp
    use { 'onsails/lspkind-nvim' }
    -- diagnostic list
    use { 'folke/trouble.nvim', config = require 'plugins.trouble' }

    --[[
    --      Debug adapter protocol
    --]]
    use { 'mfussenegger/nvim-dap', config = require 'plugins.dap' }
    use { 'rcarriga/nvim-dap-ui', config = require 'plugins.dapui' }
    use { 'theHamsta/nvim-dap-virtual-text' }
    use { 'Weissle/persistent-breakpoints.nvim', config = function()
              require 'persistent-breakpoints'.setup()
          end }

    --[[
   --       Mason 
   --]]
    use { 'williamboman/mason.nvim', config = require 'plugins.mason' }
    use { 'williamboman/mason-lspconfig.nvim' }
    use { 'jose-elias-alvarez/null-ls.nvim', config = require 'plugins.null-ls' }

    --[[
    --      Editor
    --]]
    use { 'windwp/nvim-autopairs', config = require 'plugins.autopairs' }
    use { 'numToStr/Comment.nvim', config = require 'plugins.comment' }
    use { 'lewis6991/gitsigns.nvim', config = require 'plugins.gitsigns' }
    use { 'akinsho/nvim-toggleterm.lua', config = require 'plugins.toggleterm' }
    use {
        'glacambre/firenvim',
        run = function()
            vim.fn['firenvim#install'](0)
        end,
    }
    use { 'folke/which-key.nvim', config = require 'plugins.which-key' }
    use { 'kyazdani42/nvim-tree.lua', config = require 'plugins.filetree' }
    use { 'simrat39/symbols-outline.nvim', config = require 'plugins.outline' }
    use { 'glepnir/dashboard-nvim', config = require 'plugins.dashboard' }

    --[[
    --      Project & Session
    --]]
    use { 'Shatur/neovim-cmake', config = require 'plugins.cmake' }
    use { 'rmagatti/auto-session', config = require 'plugins.session' }

    --[[
    --      Language specific
    --]]
    use { 'AckslD/nvim-FeMaco.lua', ft = { 'markdown' }, config = require 'plugins.markdown' }
end)
