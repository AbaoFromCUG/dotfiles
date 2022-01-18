-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

return require("packer").startup(function(use)
    -- base plugin
    use "wbthomason/packer.nvim"
    use "nvim-lua/plenary.nvim"
    use "nvim-lua/popup.nvim"
    use "skywind3000/asyncrun.vim"

    --[[
    --  Editor UI
    --]]

    -- theme & color
    use { "projekt0n/github-nvim-theme", config = require "plugins.theme" }

    -- color text colorizer, e.g. #612208
    use { "norcalli/nvim-colorizer.lua", config = require("colorizer").setup() }
    -- icon
    use "kyazdani42/nvim-web-devicons"

    -- tab line
    use { "akinsho/bufferline.nvim", config = require "plugins.bufferline" }

    -- status line
    use { "hoob3rt/lualine.nvim", config = require "plugins.lualine" }
    use { "arkav/lualine-lsp-progress" }
    use { "SmiteshP/nvim-gps", config = require "plugins.gps" }

    use { "lukas-reineke/indent-blankline.nvim", config = require "plugins.indent_blankline" }

    -- git
    use { "lewis6991/gitsigns.nvim", config = require "plugins.gitsigns" }

    -- terminal
    use { "akinsho/nvim-toggleterm.lua", config = require "plugins.toggleterm" }

    -- browsers
    use {
        "glacambre/firenvim",
        run = function()
            vim.fn["firenvim#install"](0)
        end,
    }

    -- which key
    use { "folke/which-key.nvim", config = require "plugins.which-key" }

    -- telescope
    use { "nvim-telescope/telescope.nvim", config = require "plugins.telescope" }
    use { "nvim-telescope/telescope-ui-select.nvim" }
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use { "nvim-telescope/telescope-hop.nvim" }
    use { "nvim-telescope/telescope-project.nvim" }
    use { "nvim-telescope/telescope-dap.nvim" }
    use { "nvim-telescope/telescope-symbols.nvim" }

    -- session
    use { "Shatur/neovim-session-manager", config = require "plugins.session" }

    -- fileexplor
    use { "kyazdani42/nvim-tree.lua", config = require "plugins.filetree" }

    -- dashboard
    use { "glepnir/dashboard-nvim", config = require "plugins.dashboard" }

    -- treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = require "plugins.treesitter",
    }

    -- debugger
    use { "mfussenegger/nvim-dap", config = require "plugins.dap" }
    use { "rcarriga/nvim-dap-ui", config = require "plugins.dapui" }
    use { "theHamsta/nvim-dap-virtual-text" }

    -- cmake
    use { "Shatur/neovim-cmake", config = require "plugins.cmake" }

    -- project
    use { "windwp/nvim-projectconfig", config = require "plugins.projectconfig" }

    --[[
    --       Neovim language server protocol
    --]]
    use { "neovim/nvim-lspconfig", config = require "plugins.lspconfig" }
    use { "williamboman/nvim-lsp-installer", config = require "plugins.lspinstall" }
    --[[
    --       LSP server source
    --]]
    use { "jose-elias-alvarez/null-ls.nvim", config = require "plugins.null-ls" }
    --[[
    --       LSP completion
    --]]
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
    use { "hrsh7th/vim-vsnip" }
    use { "rafamadriz/friendly-snippets" }

    use { "ray-x/lsp_signature.nvim" ,config = require"plugins.lsp_signature"}

    -- autopair
    use { "windwp/nvim-autopairs", config = require "plugins.autopairs" }
    -- pictograms for lsp
    use { "onsails/lspkind-nvim" }
    -- diagnostic
    use { "folke/trouble.nvim", config = require "plugins.trouble" }
end)
