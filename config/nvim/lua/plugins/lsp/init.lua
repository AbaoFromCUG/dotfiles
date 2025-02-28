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
            enabled = true,

            completion = {

                list = {
                    selection = {
                        preselect = false,
                    },
                },
                menu = {
                    auto_show = true,
                },
            },
            keymap = {
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
                auto_show = true,
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
        snippets = { preset = "luasnip" },
        sources = {
            default = {
                "lsp",
                "buffer",
                "path",
                "avante",
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
                avante = {
                    module = "blink-cmp-avante",
                    name = "Avante",
                    opts = {
                        -- options for blink-cmp-avante
                    },
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
        version = "v0.13.0",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "Kaiser-Yang/blink-cmp-avante",
        },
        config = blink,
    },

    {
        "L3MON4D3/LuaSnip",
        config = function()
            require("luasnip").filetype_extend("yaml", { "kubernetes" })
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
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
