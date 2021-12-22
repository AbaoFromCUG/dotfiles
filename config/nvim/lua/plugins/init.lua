-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

return require("packer").startup(function(use)
    -- base plugin
    use "wbthomason/packer.nvim"
    use { "nvim-lua/plenary.nvim" }
    use "nvim-lua/popup.nvim"

    -- theme & color
    use { "projekt0n/github-nvim-theme", config = require "plugins.theme" }
    use {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    }
    -- status line
    use { "hoob3rt/lualine.nvim", config = require "plugins.lualine" }

    -- terminal
    use { "akinsho/nvim-toggleterm.lua", config = require "plugins.toggleterm" }

    -- telescope
    use { "nvim-telescope/telescope.nvim", config = require "plugins.telescope" }
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use { "nvim-telescope/telescope-hop.nvim" }
    use { "nvim-telescope/telescope-project.nvim" }
    use { "nvim-telescope/telescope-dap.nvim" }
    use { "nvim-telescope/telescope-symbols.nvim" }

    -- session
    use { "Shatur/neovim-session-manager", config = require "plugins.session" }

    -- icon
    use "kyazdani42/nvim-web-devicons"
    -- fileexplor
    use "kevinhwang91/rnvimr"
    -- treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = require "plugins.treesitter",
    }

    -- debug
    use { "mfussenegger/nvim-dap", config = require "plugins.dap" }
    use { "Pocco81/DAPInstall.nvim" }
    use { "rcarriga/nvim-dap-ui", config = require "plugins.dapui" }
    use { "theHamsta/nvim-dap-virtual-text" }

    -- cmake
    use "skywind3000/asyncrun.vim"
    use { "Shatur/neovim-cmake", config = require "plugins.cmake" }

    -- project
    use { "windwp/nvim-projectconfig", config = require "plugins.projectconfig" }

    -- dashboard
    use { "glepnir/dashboard-nvim", config = require "plugins.dashboard" }

    -- editor
    use { "windwp/nvim-autopairs", config = require "plugins.autopairs" }

    -- lsp
    use { "neovim/nvim-lspconfig", config = require "plugins.lspconfig" }
    use { "williamboman/nvim-lsp-installer", config = require "plugins.lspinstall" }

    -- lsp completion engine
    use { "hrsh7th/nvim-cmp", config = require "plugins.cmp" } -- Autocompletion plugin
    -- source for builtin lsp
    use { "hrsh7th/cmp-nvim-lsp" }
    -- snippets source
    use { "hrsh7th/cmp-buffer" }
    use { "hrsh7th/cmp-path" }
    use { "hrsh7th/cmp-cmdline" }
    use { "ray-x/cmp-treesitter" }
    use {
        "SirVer/ultisnips",
        requires = {
            { "honza/vim-snippets", rtp = "." },
        },
    }
    use "quangnguyen30192/cmp-nvim-ultisnips"
    use { "onsails/lspkind-nvim", config = require "plugins.lspkind" }
    use { "folke/trouble.nvim", config = require "plugins.trouble" }

    -- formatter
    use { "jose-elias-alvarez/null-ls.nvim", config = require "plugins.null-ls" }
end)
