local function blink()
    local source_map = {
        Snippets = "Snip",
        LSP = "LSP",
        Buffer = "Buf",
        Path = "Path",
    }

    ---@type blink.cmp.DrawComponent
    local source_component = {
        width = { max = 30 },
        ---@param ctx blink.cmp.DrawItemContext
        text = function(ctx) return string.format("[%s] ", source_map[ctx.item.source_name] or ctx.item.source_name) end,
        highlight = "BlinkCmpSource",
    }

    ---@diagnostic disable: missing-fields
    require("blink-cmp").setup({
        keymap = {
            ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
            ["<Down>"] = { "select_next", "snippet_forward", "fallback" },
            ["<Up>"] = { "select_prev", "snippet_backward", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
            cmdline = {
                preset = "super-tab",
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
                ["<Up>"] = { "fallback" },
                ["<Down>"] = { "fallback" },
                ["<CR>"] = { "accept", "fallback" },
            },
        },
        completion = {
            list = {
                selection = {
                    preselect = false
                },
            },
            menu = {
                draw = {
                    padding = { 1, 1 },
                    columns = { { "label" }, { "kind_icon", "kind", gap = 1 }, { "label_description" }, { "source" } },
                    components = {
                        source = source_component,
                    },
                    treesitter = { "lsp" },
                },
            },

            -- experimental auto-brackets support
            accept = { auto_brackets = { enabled = false } },

            documentation = {
                auto_show = true,
            },
            ghost_text = {
                enabled = true,
            },
        },
        signature = {
            enabled = false,
        },
        appearance = {
            -- use_nvim_cmp_as_default = true,
        },
        sources = {
            default = {
                "lsp",
                "buffer",
                "path",
                "snippets",
            },
            per_filetype = {
                python = {
                    "lsp",
                    "buffer",
                    "path",
                    "snippets",
                    "neopyter",
                },
            },

            providers = {
                neopyter = {
                    name = "Neopyter",
                    module = "neopyter.blink",
                    ---@type neopyter.CompleterOption
                    opts = {},
                },
            },
        },
    })
    ---@diagnostic enable: missing-fields
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
        "saghen/blink.cmp",
        event = "InsertEnter",
        build = "cargo build --release",
        dependencies = "rafamadriz/friendly-snippets",
        tag = "v0.11.0",
        config = blink,
    },

    -- diagnostic list
    {
        "folke/trouble.nvim",
        opts = {},
        keys = {
            { "<space>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "diagnostics" },
            { "<space>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "buffer diagnostics" },
            { "<space>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "symbos" },
            { "<space>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "lsp definitions/references" },
            { "<space>xL", "<cmd>Trouble loclist toggle<cr>", desc = "location list" },
            { "<space>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "quickfix list" },
        },
    },
    {
        "jmbuhr/otter.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            lsp = {
                diagnostic_update_events = { "TextChanged" },
            },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.shfmt,

                    null_ls.builtins.diagnostics.markdownlint,
                    null_ls.builtins.diagnostics.qmllint,
                    -- null_ls.builtins.diagnostics.cmake_lint,

                    null_ls.builtins.formatting.markdownlint,
                    null_ls.builtins.formatting.qmlformat,
                    -- null_ls.builtins.formatting.cmake_format,
                    null_ls.builtins.formatting.typstyle,
                    null_ls.builtins.formatting.yamlfmt,
                },
            })
        end,
        event = "VeryLazy",
    },
    { "b0o/schemastore.nvim" },
    {
        "AbaoFromCUG/luals-addonmanager.nvim",
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
    },
}
