vim.api.nvim_create_autocmd("FileType", {
    pattern = { "opencode_output" },
    callback = function()
        require("ufo").detach()
    end
})


---@type LazySpec[]
return {
    {
        "sudo-tee/opencode.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            keymap = {
                editor = {
                    ["<leader>zo"] = { "toggle_zoom", desc = "Toggle zoom" },
                },
                input_window = {
                    ["<esc>"] = false,
                    ["~"] = false,
                    ["<tab>"] = { "switch_mode", "Toggle mode", mode = "n" },
                    ["<C-s>"] = { "submit_input_prompt", mode = { "n", "i" } },
                    ["+"] = { "mention_file", mode = "i" },
                },
                --
                output_window = {
                    ["<esc>"] = false,
                    ["<tab>"] = { "switch_mode", "Toggle mode", mode = "n" },
                }
            },
            context = {
                enabled = true,
                diagnostics = {
                    enabled = false,
                    info = false,
                    warn = false,
                    error = false,
                },
                current_file = {
                    enabled = false,
                },
                selection = {
                    enabled = true,
                },
            },
            ui = {
                output = {
                    tools = {
                        use_folds = 2,
                    }
                }
            }
        },
        config = function(_, opts)
            require("opencode").setup(opts)
            -- require("opencode.context.chat_context").unload_attachments = function()
            --     local state = require("opencode.state")
            --     state.context.set_context_updated_at(vim.uv.now())
            -- end
        end,
        cmd = "Opencode",
        keys = {
            { "<leader>a",  group = true,                             desc = "ai" },
            -- { "<leader>ai", function() require("opencode.api").quick_chat() end, desc = "quick chat",     mode = { "n", "x" } },
            -- { "<leader>ac", function() require("opencode.api").toggle() end,     desc = "chat assistant", mode = { "n", "x" } },
            { "<leader>ai", "<cmd>Opencode quick_chat<cr>",           desc = "chat assistant", mode = { "n", "x" } },
            { "<leader>ac", "<cmd>Opencode toggle focus<cr>",         desc = "quick chat" },
            { "<leader>ac", "<cmd>Opencode add_visual_selection<cr>", desc = "quick chat",     mode = "x" },
        },
    },
    {
        "folke/sidekick.nvim",
        event = "InsertEnter",
        opts = {
            cli = {
                mux = {
                    backend = "tmux",
                },
            },
        },
        keys = {
            {
                "<tab>",
                function()
                    -- if there is a next edit, jump to it, otherwise apply it if any
                    if not require("sidekick").nes_jump_or_apply() then
                        return "<Tab>" -- fallback to normal tab
                    end
                end,
                expr = true,
                desc = "Goto/Apply Next Edit Suggestion",
            },
        },
    },
    {
        "saghen/blink.cmp",
        dependencies = { "fang2hou/blink-copilot" },
        opts = {
            keymap = {
                ["<Tab>"] = {
                    "snippet_forward",
                    function() return require("sidekick").nes_jump_or_apply() end,
                    "fallback",
                },
            },
            sources = {
                default = { "copilot" },
                per_filetype = {
                    codecompanion = { "buffer", "codecompanion" },
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
                        },
                    },
                },
            },

            completion = {
                trigger = {
                    prefetch_on_insert = false,
                },
            },
        },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = function(_, ft)
            table.insert(ft, "Avante")
            table.insert(ft, "codecompanion")
            table.insert(ft, "copilot-chat")
            table.insert(ft, "opencode_output")
            return ft
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            sections = {
                lualine_c = {
                    {
                        function() return " " end,
                        -- color = function()
                        --     local status = require("sidekick.status").get()
                        --     if status then
                        --         return status.kind == "Error" and "DiagnosticError" or status.busy and "DiagnosticWarn" or "Special"
                        --     end
                        -- end,
                        cond = function()
                            local status = require("sidekick.status")
                            return status.get() ~= nil
                        end,
                    },
                },
                lualine_x = {
                    {
                        function()
                            local status = require("sidekick.status").cli()
                            return " " .. (#status > 1 and #status or "")
                        end,
                        cond = function() return #require("sidekick.status").cli() > 0 end,
                        color = function() return "Special" end,
                    },
                },
            },
        },
    },
}
