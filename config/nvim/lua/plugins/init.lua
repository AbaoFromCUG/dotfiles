return require "packer".startup(function(use)
    --[[
    --      Basic
    --]]
    use "wbthomason/packer.nvim"
    use "nvim-lua/plenary.nvim"
    use "nvim-lua/popup.nvim"
    use "skywind3000/asyncrun.vim"
    use "tami5/sqlite.lua"
    use "kyazdani42/nvim-web-devicons"
    --[[
    --      UI & Theme
    --]]
    -- theme & color
    use { "glepnir/zephyr-nvim", config = require "plugins.theme" }
    use { "ellisonleao/gruvbox.nvim" }
    -- color text colorizer, e.g. #612208 Red
    use { "norcalli/nvim-colorizer.lua", config = require "plugins.colorizer" }
    use { "xiyaowong/nvim-transparent", config = require "plugins.transparent" }
    -- tab line
    use { "akinsho/bufferline.nvim", config = require "plugins.bufferline" }
    -- status line
    use { "hoob3rt/lualine.nvim", config = require "plugins.lualine" }
    use { "arkav/lualine-lsp-progress" }
    use { "SmiteshP/nvim-gps", config = require "plugins.gps" }
    -- indent
    use { "lukas-reineke/indent-blankline.nvim", config = require "plugins.indent_blankline" }

    --[[
    --      Telescope
    --]]
    use { "nvim-telescope/telescope.nvim", config = require "plugins.telescope" }
    use { "nvim-telescope/telescope-ui-select.nvim" }
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use { "nvim-telescope/telescope-hop.nvim" }
    use { "nvim-telescope/telescope-project.nvim" }
    use { "nvim-telescope/telescope-dap.nvim" }
    use { "nvim-telescope/telescope-symbols.nvim" }
    use { "nvim-telescope/telescope-frecency.nvim" }


    --[[
    --      Treesitter
    --]]
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = require "plugins.treesitter",
    }
    use { "andymass/vim-matchup" }
    use { "p00f/nvim-ts-rainbow" }
    use { "nvim-treesitter/nvim-treesitter-refactor" }
    use { "nvim-treesitter/nvim-treesitter-textobjects" }

    --[[
    --       Language server protocol
    --]]
    use { "neovim/nvim-lspconfig", config = require "plugins.lspconfig" }
    use { "williamboman/nvim-lsp-installer", config = require "plugins.lspinstall" }
    -- completion engine
    use { "hrsh7th/nvim-cmp", config = require "plugins.cmp" } -- Autocompletion plugin
    -- completion source
    use { "hrsh7th/cmp-nvim-lsp" }
    use { "hrsh7th/cmp-buffer" }
    use { "hrsh7th/cmp-path" }
    use { "hrsh7th/cmp-cmdline" }
    use { "ray-x/cmp-treesitter" }
    -- snippets
    use { "hrsh7th/cmp-vsnip" }
    use { "hrsh7th/vim-vsnip", config = require "plugins.snippet" }
    use { "rafamadriz/friendly-snippets" }
    -- show signature
    use { "ray-x/lsp_signature.nvim", config = require "plugins.lsp_signature" }
    -- pictograms for lsp
    use { "onsails/lspkind-nvim" }
    -- diagnostic list
    use { "folke/trouble.nvim", config = require "plugins.trouble" }

    --[[
    --      Debug adapter protocol
    --]]
    use { "mfussenegger/nvim-dap", config = require "plugins.dap" }
    use { "rcarriga/nvim-dap-ui", config = require "plugins.dapui" }
    use { "theHamsta/nvim-dap-virtual-text" }
    --[[
    --      Editor
    --]]
    use { "windwp/nvim-autopairs", config = require "plugins.autopairs" }
    use { "numToStr/Comment.nvim", config = require "plugins.comment" }
    use { "lewis6991/gitsigns.nvim", config = require "plugins.gitsigns" }
    use { "akinsho/nvim-toggleterm.lua", config = require "plugins.toggleterm" }
    use {
        "glacambre/firenvim",
        run = function()
            vim.fn["firenvim#install"](0)
        end,
    }
    use { "folke/which-key.nvim", config = require "plugins.which-key" }
    use { "kyazdani42/nvim-tree.lua", config = require "plugins.filetree" }
    use { "glepnir/dashboard-nvim", config = require "plugins.dashboard" }

    use {
        "petertriho/nvim-scrollbar",
        config = function()
            require "scrollbar".setup()
        end,
    }
    use { "rcarriga/nvim-notify", config = require "plugins.notify" }

    use { "Pocco81/TrueZen.nvim" }

    --[[
    --      Project & Session
    --]]
    -- cmake
    use { "Shatur/neovim-cmake", config = require "plugins.cmake" }
    -- project
    use { "windwp/nvim-projectconfig", config = require "plugins.projectconfig" }

    -- session
    use { "rmagatti/auto-session" }
    use { "rmagatti/session-lens", config = require "plugins.session" }

    --[[
    --      Language specific
    --]]
    use {
        "lervag/vimtex",
        config = require "plugins.latex",
    }
    use {
        "iamcco/markdown-preview.nvim",
        config = require("plugins.markdown"),
        run = "cd app && npm install",
        setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
        ft = { "markdown" },
    }
end)
