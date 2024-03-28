local function luasnip()
    local snippet_path = vim.fn.stdpath("config") .. "/snippets"
    require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippet_path } })
    require("luasnip.loaders.from_vscode").load()
end

local function signature()
    local lsp_signature = require("lsp_signature")
    lsp_signature.setup({
        -- floating_window_above_cur_line = false,
    })
end

local function none_ls()
    local null_ls = require("null-ls")
    null_ls.setup({
        debug = true,
        sources = {
            null_ls.builtins.formatting.stylua,
        },
    })
end

---
return {
    -- completion engine
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        config = require("plugins.lsp.cmp"),
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        build = "make install_jsregexp",
        config = luasnip,
    },
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "ray-x/cmp-treesitter",
    "paopaol/cmp-doxygen",
    -- show signature
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        config = signature,
    },
    -- pictograms for lsp
    { "onsails/lspkind-nvim" },
    -- diagnostic list
    { "folke/trouble.nvim", config = require("plugins.lsp.trouble") },
    {
        "nvimtools/none-ls.nvim",
        config = none_ls,
    },
    { "folke/neodev.nvim", opts = {} },

    {
        "neovim/nvim-lspconfig",
        config = require("plugins.lsp.lspconfig"),
        dependencies = {
            "neodev.nvim",
            "rust-tools.nvim",
        },
    },
}
