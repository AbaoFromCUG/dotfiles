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
        -- event = "VeryLazy",
        lazy = false,
        opts = {
            ensure_installed = {
                "lua_ls",
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
                    "lua_ls",
                    "jdtls",
                }
            },
        },
        config = function(_, opts)
            require("mason-lspconfig").setup(opts)
            vim.iter({
                "ruff",
            }):each(vim.lsp.enable)
        end
    },

    -- completion engine
    {
        "saghen/blink.cmp",
        event = "VeryLazy",
        version = "v1.7.0",
        opts_extend = { "sources.default" },
        opts = {
            keymap = {
                preset = "enter",
                ["<C-y>"] = { "select_and_accept" },
                ["<A-space>"] = { "show", "show_documentation", "hide_documentation" },
            },

            completion = {
                trigger = {},
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = false
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
                            }
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
                    python = { inherit_defaults = true, },
                    sql = { inherit_defaults = true, "dadbod" },
                    snacks_input = { "path" }
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
                    menu = { auto_show = true }
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
        build = "cargo build --release",
        opts = {
            mappings = {
                pairs = {
                },
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
            }
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
        confmiig = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    -- null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.shfmt.with({ filetypes = { "sh", "bash", "zsh", "shell" } }),

                    null_ls.builtins.diagnostics.markdownlint,
                    null_ls.builtins.diagnostics.qmllint,
                    -- null_ls.builtins.diagnostics.cmake_lint,

                    null_ls.builtins.formatting.markdownlint,
                    null_ls.builtins.formatting.qmlformat,
                    -- null_ls.builtins.formatting.cmake_format,
                    null_ls.builtins.formatting.typstyle,
                    null_ls.builtins.formatting.yamlfmt,
                    null_ls.builtins.formatting.sqlfmt,
                },
            })
        end,
        event = "VeryLazy",
    },
    { "b0o/schemastore.nvim" },
    {
        "AbaoFromCUG/lua_ls.nvim",
        dev = true,
        ---@type lua_ls.Config
        opts = {},
        ft = "lua",
    },
    {
        "SmiteshP/nvim-navic",
        opts = {
            lsp = {
                auto_attach = true
            },
            depth_limit = 5,
        },
        event = "LspAttach",
    },
}
