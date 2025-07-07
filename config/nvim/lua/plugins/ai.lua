---@type LazySpec[]
return {
    {
        "olimorris/codecompanion.nvim",
        cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
        opts = {
            language = "Chinese",
            display = {
                chat = {
                    show_settings = true

                }

            },
            strategies = {
                chat = {
                    adapter = "llm"
                },
                inline = {
                    adapter = "llm",
                    keymaps = {
                        accept_change = {
                            modes = { n = "gaa" }
                        },
                        reject_change = {
                            modes = { n = "gar" }
                        },
                    }
                }
            },
            adapters = {
                llm = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        env = {
                            api_key = "AI_CODE_KEY",
                            url = vim.env.AI_CODE_URL,
                            chat_url = "/chat/completions",
                            models_endpoint = "/models",
                        },
                        schema = {
                            model = {
                                default = vim.env.AI_CODE_MODEL, -- define llm model to be used
                                choices = {
                                    ["qwen3-235b-a22b"] = { opts = { can_reason = true } }
                                }
                            },
                        },
                    })
                end
            }
        },
        keys = {
            { "<leader>a",  group = true,                    desc = "ai",               mode = { "v", "n" } },
            { "<leader>ai", "<cmd>CodeCompanion<cr>",        desc = "inline assistant", mode = { "v", "n" } },
            { "<leader>ac", "<cmd>CodeCompanionChat<cr>",    desc = "chat assistant",   mode = { "v", "n" } },
            { "<leader>ap", "<cmd>CodeCompanionActions<cr>", desc = "action palette",   mode = { "v", "n" } },
        }
    },
    {
        "milanglacier/minuet-ai.nvim",
        enabled = vim.env.AI_CODE_KEY,
        opts = function()
            return {
                provider = "openai_compatible",
                n_completions = 1,
                context_window = 1024,
                provider_options = {
                    openai_compatible = {
                        api_key = "AI_CODE_KEY",
                        name = "AI",
                        end_point = vim.env.AI_CODE_URL .. "/chat/completions",
                        model = vim.env.AI_CODE_MODEL,
                        optional = {
                            max_tokens = 256,
                            top_p = 0.9,
                        },
                    },
                },
            }
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            table.insert(opts.sections.lualine_x, {
                require "minuet.lualine",
            })
        end,
    },

    {
        "saghen/blink.cmp",
        opts = function(_, opts)
            table.insert(opts.sources.default, "minuet")
            opts.sources.providers.minuet = {
                name = "minuet",
                module = "minuet.blink",
                async = true,
                -- Should match minuet.config.request_timeout * 1000,
                -- since minuet.config.request_timeout is in seconds
                timeout_ms = 3000,
                score_offset = 50, -- Gives minuet higher priority among suggestions
            }
            opts.keymap["<A-y>"] = { function(cmp)
                vim.lsp.completion.get()
                require("minuet").make_blink_map()[1](cmp)
            end }
            -- vim.tbl_set
            opts.completion.trigger.prefetch_on_insert = false
        end,
    }

}
