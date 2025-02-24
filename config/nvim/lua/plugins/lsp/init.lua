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
        },
        cmdline = {
            keymap = {
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
                    preselect = false,
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
                "avante_commands",
                "avante_mentions",
                "avante_files",
            },
            per_filetype = {
                python = {

                    "lsp",
                    "buffer",
                    "path",
                    "snippets",
                    "avante_commands",
                    "avante_mentions",
                    "avante_files",
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
                avante_commands = {
                    name = "avante_commands",
                    module = "blink.compat.source",
                    score_offset = 90, -- show at a higher priority than lsp
                    opts = {},
                },
                avante_files = {
                    name = "avante_commands",
                    module = "blink.compat.source",
                    score_offset = 100, -- show at a higher priority than lsp
                    opts = {},
                },
                avante_mentions = {
                    name = "avante_mentions",
                    module = "blink.compat.source",
                    score_offset = 1000, -- show at a higher priority than lsp
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
        version = "v0.12.4",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "saghen/blink.compat",
        },
        config = blink,
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
        commit = "980361",
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
    {
        "nvimdev/lspsaga.nvim",
        opts = {
            symbol_in_winbar = {
                enable = false,
            },
            lightbulb = {
                sign = false,
            },
        },
        event = "LspAttach",
    },
}
