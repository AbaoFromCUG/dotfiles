local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

local group = vim.api.nvim_create_augroup("CodeCompanionProgress", { clear = true })
vim.api.nvim_create_autocmd({ "User" }, {
    pattern = { "CodeCompanionRequestStarted", "CodeCompanionRequestStreaming", "CodeCompanionRequestFinished" },
    group = group,
    callback = function(request)
        local msg = request.match:gsub("CodeCompanionRequest", "")
        vim.notify(msg .. "...", vim.log.levels.INFO, {
            id = request.data.id,
            title = "Code Companion",
            opts = function(notif)
                notif.icon = ""
                if msg == "Finished" then
                    notif.icon = " "
                else
                    notif.icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                end
            end,

            keep = function()
                return msg ~= "Finished"
            end,
        })
    end,
})

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
            },
            extensions = {
                editor = {
                    enabled = true,
                    opts = {},
                    callback = {
                        setup = function(ext_config)
                            -- Add a new action to chat keymaps
                            local open_editor = {
                                modes = {
                                    n = "ge", -- Keymap to open editor
                                },
                                description = "Open Editor",
                                callback = function(chat)
                                    -- Implementation of editor opening logic
                                    -- You have access to the chat buffer via the chat parameter
                                    vim.notify("Editor opened for chat " .. chat.id)
                                end,
                            }

                            -- Add the action to chat keymaps config
                            local chat_keymaps = require("codecompanion.config").strategies.chat.keymaps
                            chat_keymaps.open_editor = open_editor
                        end,

                        -- Optional: Expose functions
                        exports = {
                            is_editor_open = function()
                                return false -- Implementation
                            end
                        }
                    }
                }
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
            opts.sources.per_filetype.codecompanion = { "buffer", "codecompanion" }
        end,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = function(_, ft)
            table.insert(ft, "codecompanion")
            return ft
        end
    },

}
