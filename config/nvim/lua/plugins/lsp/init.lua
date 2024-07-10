local function luasnip()
    local snippet_path = vim.fn.stdpath("config") .. "/snippets"
    require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippet_path } })
    require("luasnip.loaders.from_vscode").load()
end

local function none_ls()
    local null_ls = require("null-ls")
    null_ls.setup({
        debug = true,
        sources = {
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.shfmt,
            null_ls.builtins.diagnostics.markdownlint,
            null_ls.builtins.formatting.markdownlint,
        },
    })
end

---@type LazySpec[]
return {
    {
        "neovim/nvim-lspconfig",
        config = require("plugins.lsp.lspconfig"),
        dependencies = {
            "neoconf.nvim",
        },
        event = { "VeryLazy" },
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
            "saadparwaiz1/cmp_luasnip",
        },
        config = require("plugins.lsp.cmp"),
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        build = "make install_jsregexp",
        config = luasnip,
    },
    -- show signature
    {
        "ray-x/lsp_signature.nvim",
        config = true,
        event = "VeryLazy",
    },
    -- pictograms for lsp
    { "onsails/lspkind-nvim" },
    -- lsp progress
    {
        "j-hui/fidget.nvim",
        config = true,
        event = "VeryLazy",
    },
    -- diagnostic list
    {
        "folke/trouble.nvim",
        opts = {},
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        config = none_ls,
        event = "VeryLazy",
    },
    {
        "AbaoFromCUG/lua_ls.nvim",
        ---@type lua_ls.Config
        opts = {
            settings = {
                Lua = {
                    diagnostics = {},
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false,
                    },
                    format = {
                        enable = false,
                    },
                    completion = {
                        autoRequire = true,
                        callSnippet = "Replace",
                    },
                },
            },
        },
        event = "VeryLazy",
        dev = true,
    },
}
