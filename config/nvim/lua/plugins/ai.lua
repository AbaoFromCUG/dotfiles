local function toggle_mode()
    require("opencode.promise").spawn(function()
        local config_file = require("opencode.config_file")
        local modes = config_file.get_opencode_agents():await()
        local state = require("opencode.state")
        local current_mode = state.current_mode
        local current_index = require("utils.list").index_of(modes, current_mode)

        local next_index = (current_index % #modes) + 1
        local next_mode = modes[next_index]
        require("opencode.core").switch_to_mode(next_mode)
    end)
end

---@type LazySpec[]
return {
    {
        "sudo-tee/opencode.nvim",
        dev = true,
        dependencies = {
            "nvim-lua/plenary.nvim",

        },
        opts = {
            keymap = {
                editor = false,
                input_window = {
                    ["<esc>"] = false,
                    ["~"] = false,
                    ["<tab>"] = { toggle_mode, "Toggle mode", mode = "n" },
                    ["<C-s>"] = { "submit_input_prompt", mode = { "n", "i" } },
                    ["+"] = { "mention_file", mode = "i" },
                },

                output_window = {
                    ["<esc>"] = false,
                    ["<tab>"] = { toggle_mode, "Toggle mode", mode = "n" },
                },
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
                    enabled = true
                }
            },
        },
        keys = {
            { "<leader>a",  group = true,                                        desc = "ai" },
            { "<leader>ai", function() require("opencode.api").quick_chat() end, desc = "quick chat",     mode = { "n", "x" } },
            { "<leader>ac", function() require("opencode.api").toggle() end,     desc = "chat assistant", mode = { "n", "x" } },
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
