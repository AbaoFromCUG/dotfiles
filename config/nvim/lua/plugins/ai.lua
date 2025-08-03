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
                            api_key = "AI_CODER_KEY",
                            url = vim.env.AI_CODER_URL .. "/v1",
                            chat_url = "/chat/completions",
                            models_endpoint = "/models",
                        },
                        schema = {
                            model = {
                                default = vim.env.AI_CODER_MODEL, -- define llm model to be used
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
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                cpp = false,
                javascript = true,
                typescript = true,
                typescriptreact = true,

                ["*"] = function()
                    local forbidden_patterns = { "^.*%.local", "^%.env.*" }
                    local basename = vim.fs.basename(vim.fn.bufname())
                    local forbidden = vim.iter(forbidden_patterns):any(function(pattern)
                        return not not basename:match(pattern)
                    end)
                    -- vim.print(forbidden)
                    return not forbidden
                end
            },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = "AndreM222/copilot-lualine",
        opts = {
            sections = {
                lualine_x = { "copilot" },
            },
        },
    },
    {
        "saghen/blink.cmp",
        dependencies = { "fang2hou/blink-copilot" },
        opts = {
            sources = {
                default = { "copilot" },
                per_filetype = {
                    codecompanion = { "buffer", "codecompanion" }
                },
                providers = {
                    copilot = {
                        name = "Copilot",
                        module = "blink-copilot",
                        score_offset = 100,
                        async = true,
                        opts = {
                            kind_name = "Copilot",
                            kind_icon = "",
                        }
                    },
                },
            },

            completion = {
                trigger = {
                    prefetch_on_insert = false
                }
            },
            keymap = {
            }
        },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = function(_, ft)
            table.insert(ft, "codecompanion")
            return ft
        end
    },
}
