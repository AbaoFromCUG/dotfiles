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

            keep = function() return msg ~= "Finished" end,
        })
    end,
})

---@type LazySpec[]
return {
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "ravitemer/codecompanion-history.nvim",
        },
        -- dev = true,
        cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
        opts = {
            language = "Chinese",
            display = {
                chat = {
                    show_settings = true,
                },
            },
            interactions = {
                chat = {
                    adapter = "copilot",
                    opts = {
                        system_prompt = table.concat(vim.fn.readfile(vim.fn.stdpath("config") .. "/share/chat-system-prompt.md"), "\n"),
                    },
                    keymaps = {
                        codeblock = {
                            modes = { n = "gic" },
                        },
                        clear = {
                            modes = { n = "gc" },
                        },
                    },
                },
                inline = {

                    adapter = "copilot",
                    keymaps = {
                        accept_change = {
                            modes = { n = "gaa" },
                        },
                        reject_change = {
                            modes = { n = "gar" },
                        },
                    },
                },
            },
            extensions = {
                history = {
                    enabled = true,
                    opts = {},
                },
            },
        },
        keys = {
            { "<leader>a",  group = true,                    desc = "ai",               mode = { "v", "n" } },
            { "<leader>ai", "<cmd>CodeCompanion<cr>",        desc = "inline assistant", mode = { "v", "n" } },
            { "<leader>ac", "<cmd>CodeCompanionChat<cr>",    desc = "chat assistant",   mode = { "v", "n" } },
            { "<leader>ap", "<cmd>CodeCompanionActions<cr>", desc = "action palette",   mode = { "v", "n" } },
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
            table.insert(ft, "codecompanion")
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
