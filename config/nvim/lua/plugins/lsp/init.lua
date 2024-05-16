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
            null_ls.builtins.formatting.shfmt,
        },
    })
end

return {

    {
        "neovim/nvim-lspconfig",
        config = require("plugins.lsp.lspconfig"),
        dependencies = {
            "neodev.nvim",
            "neoconf.nvim",
            "lua_ls.nvim",
        },
        event = { "VeryLazy", "BufReadPre" },
        lazy = true,
    },
    {
        "folke/neodev.nvim",
        lazy = true,
        config = true,
    },
    -- completion engine
    {
        "hrsh7th/nvim-cmp",
        event = "VeryLazy",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "ray-x/cmp-treesitter",
            "paopaol/cmp-doxygen",
            "saadparwaiz1/cmp_luasnip",
        },
        config = require("plugins.lsp.cmp"),
    },
    {
        "L3MON4D3/LuaSnip",
        lazy = true,
        dependencies = { "rafamadriz/friendly-snippets" },
        build = "make install_jsregexp",
        config = luasnip,
    },
    "rafamadriz/friendly-snippets",
    -- show signature
    {
        "ray-x/lsp_signature.nvim",
        config = signature,
        lazy = true,
        event = "VeryLazy",
    },
    -- pictograms for lsp
    { "onsails/lspkind-nvim" },
    -- diagnostic list
    { "folke/trouble.nvim", config = require("plugins.lsp.trouble") },
    {
        "nvimtools/none-ls.nvim",
        config = none_ls,
    },
    {
        "AbaoFromCUG/lua_ls.nvim",
        ---@type lua_ls.Config
        config = {
            
            
        },
        lazy = true,
        dev = true,
    },
    {
        "AbaoFromCUG/texlab.nvim",
        dependencies = { "nvim-lspconfig" },
        ---@type texlab.Config
        opts = {
            compiler = {
                name = "latexmk",
                engine = "xelatex",
            },
        },
        lazy = true,
        event = "VeryLazy",
        dev = true,
    },
}
