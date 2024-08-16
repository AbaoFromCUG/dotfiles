local function none_ls()
    local null_ls = require("null-ls")
    null_ls.setup({
        debug = true,
        sources = {
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.shfmt,

            null_ls.builtins.diagnostics.markdownlint,
            null_ls.builtins.diagnostics.qmllint,
            null_ls.builtins.diagnostics.cmake_lint,

            null_ls.builtins.formatting.markdownlint,
            null_ls.builtins.formatting.qmlformat,
            null_ls.builtins.formatting.cmake_format,
        },
    })
end

local function typescript()
    local Path = require("pathlib")
    -- local mason_path = "mason/packages/vue-language-server/node_modules/@vue/language-server"
    -- local plugin_path = tostring(Path(vim.fn.stdpath("data")) / mason_path)
    require("typescript-tools").setup({
        filetypes = {
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "vue",
        },
        settings = {
            tsserver_plugins = {
                "@vue/typescript-plugin",
                "@styled/typescript-styled-plugin",
            },
            tsserver_file_preferences = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                -- includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                -- includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
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
        event = { "LazyFile" },
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
            "lukas-reineke/cmp-under-comparator",
        },
        config = require("plugins.lsp.cmp"),
    },
    {
        "garymjr/nvim-snippets",
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = { friendly_snippets = true, create_cmp_source = true },
        event = "InsertEnter",
    },
    -- show signature
    {
        "ray-x/lsp_signature.nvim",
        config = true,
        event = "VeryLazy",
    },
    -- pictograms for lsp
    { "onsails/lspkind-nvim" },
    {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        opts = {
            color_square_width = 2,
        },
    },
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
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        config = typescript,
    },
    {
        "AbaoFromCUG/lua_ls.nvim",
        ---@type lua_ls.Config
        opts = {
            settings = {
                Lua = {
                    hint = {
                        enable = true,
                    },
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
        ft = "lua",
        dev = true,
    },
}
