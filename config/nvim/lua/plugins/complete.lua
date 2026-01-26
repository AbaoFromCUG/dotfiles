---{command:"github.copilot.openModelPicker",title:"Change Completions Model",category:"GitHub Copilot",enablement:"!isWeb"}
---@type LazySpec[]
return {
    "neovim/nvim-lspconfig",
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason.nvim",
            "nvim-lspconfig",
        },
        event = "VeryLazy",
        opts = {
            ensure_installed = {
                -- "lua_ls",
                "pyright",
                "vimls",
                "bashls",
                "clangd",
                "jsonls",
                "yamlls",
                "html",
                "cssls",
                "vue_ls",
                "texlab",
                "marksman",
                "taplo",
                "tailwindcss",
                "eslint",
                "tinymist",
                "vtsls",
                "helm_ls",
            },
            automatic_enable = {
                exclude = {
                    "emmylua_ls",
                    "lua_ls",
                    "jdtls",
                },
            },
        },
        config = function(_, opts)
            vim.lsp.config("*", {
                before_init = function(_, config)
                    local codesettings = require("codesettings")
                    codesettings.with_local_settings(config.name, config)
                end,
            })
            require("mason-lspconfig").setup(opts)
            vim.lsp.enable({ "ruff" })
        end,
    },

    -- completion engine
    {
        "saghen/blink.cmp",
        event = "VeryLazy",
        version = "*",
        opts_extend = { "sources.default" },
        opts = {
            keymap = {
                preset = "enter",
                ["<C-y>"] = { "select_and_accept" },
            },

            completion = {
                trigger = {},
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = false,
                    },
                },
                menu = {
                    draw = {
                        padding = { 1, 1 },
                        columns = { { "label" }, { "kind_icon", "kind", gap = 1 }, { "label_description" }, { "source" } },
                        components = {
                            ---@type blink.cmp.DrawComponent
                            source = {
                                width = { max = 30 },
                                ---@param ctx blink.cmp.DrawItemContext
                                text = function(ctx)
                                    local source_map = {
                                        Snippets = "Snip",
                                        LSP = "LSP",
                                        Buffer = "BUF",
                                        Path = "PATH",
                                        Cmdline = "CMD",
                                        Neopyter = "JUPY",
                                        Copilot = "AI",
                                    }
                                    return string.format("[%s] ", source_map[ctx.item.source_name] or ctx.item.source_name)
                                end,
                                highlight = "BlinkCmpSource",
                            },
                        },
                        treesitter = { "lsp" },
                    },
                },

                -- accept = { auto_brackets = { enabled = false } },

                documentation = {
                    auto_show = true,
                },
                ghost_text = {
                    enabled = true,
                },
            },
            signature = {
                enabled = true,
            },
            sources = {
                default = {
                    "lsp",
                    "buffer",
                    "path",
                    "snippets",
                },
                per_filetype = {
                    python = { inherit_defaults = true },
                    sql = { inherit_defaults = true, "dadbod" },
                    snacks_input = { "path" },
                },
                providers = {
                    dadbod = {
                        name = "Dadbod",
                        module = "vim_dadbod_completion.blink",
                    },
                },
            },
            cmdline = {
                enabled = true,

                completion = {
                    list = { selection = { preselect = false } },
                    menu = { auto_show = true },
                },
                keymap = {
                    preset = "none",
                    ["<Tab>"] = { "select_next", "fallback" },
                    ["<S-Tab>"] = { "select_prev", "fallback" },
                    ["<Up>"] = { "fallback" },
                    ["<Down>"] = { "fallback" },
                    ["<CR>"] = { "accept", "fallback" },
                    ["<left>"] = { "fallback" },
                    ["<right>"] = { "fallback" },
                },
            },
        },
    },
    -- autopairs
    {
        "Saghen/blink.pairs",
        version = "*",
        dependencies = "saghen/blink.download",
        opts = {
            mappings = {
                pairs = {},
            },
            highlights = {
                groups = {
                    "RainbowDelimiterBlue",
                    "RainbowDelimiterCyan",
                    "RainbowDelimiterGreen",
                    "RainbowDelimiterOrange",
                    "RainbowDelimiterRed",
                    "RainbowDelimiterPurple",
                    "RainbowDelimiterYellow",
                },
            },
        },
        event = "InsertEnter",
    },
    {
        "jmbuhr/otter.nvim",
        dependencies = {
            "nvim-treesitter",
        },
        opts = {
            lsp = {
                diagnostic_update_events = { "TextChanged" },
            },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        opts = function()
            local null_ls = require("null-ls")
            return {
                sources = {
                    null_ls.builtins.formatting.shfmt.with({ filetypes = { "sh", "bash", "zsh", "shell" } }),

                    null_ls.builtins.diagnostics.markdownlint.with({ args = { "--disable", "MD002", "MD013", "MD026", "MD029", "MD033", "--stdin" } }),
                    null_ls.builtins.diagnostics.qmllint,
                    -- null_ls.builtins.diagnostics.cmake_lint,

                    null_ls.builtins.formatting.markdownlint.with({ args = { "--disable", "MD002", "MD013", "MD026", "MD029", "MD033", "--fix", "$FILENAME" } }),
                    null_ls.builtins.formatting.qmlformat,
                    -- null_ls.builtins.formatting.cmake_format,
                    null_ls.builtins.formatting.typstyle,
                    null_ls.builtins.formatting.yamlfmt,
                    null_ls.builtins.formatting.sqlfmt,
                    null_ls.builtins.formatting.clang_format,
                },
            }
        end,
        event = "VeryLazy",
    },
    { "b0o/schemastore.nvim" },
    {
        "AbaoFromCUG/luadev.nvim",
        ft = "lua",
        dev = true,
        ---@type luadev.Config
        opts = {
            enabled_lsp = "emmylua_ls",
        },
    },
}
