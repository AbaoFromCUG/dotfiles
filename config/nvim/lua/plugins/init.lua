-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
    --[[
    --      Basic
    --]]
    use "wbthomason/packer.nvim"
    use "nvim-lua/plenary.nvim"
    use "nvim-lua/popup.nvim"
    use "skywind3000/asyncrun.vim"
    --[[
    --      UI & Theme
    --]]
    -- theme & color
    use { "projekt0n/github-nvim-theme", config = require "plugins.theme" }
    -- color text colorizer, e.g. #612208
    use { "norcalli/nvim-colorizer.lua", config = require "plugins.colorizer" }
    -- icon
    use "kyazdani42/nvim-web-devicons"
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

    -- session
    use { "rmagatti/auto-session" }
    use { "rmagatti/session-lens", config = require "plugins.session" }

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
    -- null-ls: out-of-the-box functionality lsp source
    use { "jose-elias-alvarez/null-ls.nvim", config = require "plugins.null-ls" }
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
    --[[
    --      Tool
    --]]
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
        "iamcco/markdown-preview.nvim",
        config = require "plugins.markdown",
        run = "cd app && npm install && ./install.sh",
        ft = { "markdown" },
    }

    --[[
    --      Project manager
    --]]
    -- cmake
    use { "Shatur/neovim-cmake", config = require "plugins.cmake" }
    -- project
    use { "windwp/nvim-projectconfig", config = require "plugins.projectconfig" }
end)
