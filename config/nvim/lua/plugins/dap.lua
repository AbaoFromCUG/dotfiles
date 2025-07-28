local function overseer()
    ---@diagnostic disable-next-line: missing-fields
    require("overseer").setup({
        templates = { "builtin" },
        ---@diagnostic disable-next-line: assign-type-mismatch
        strategy = {
            "toggleterm",
            direction = "float",
            -- use_shell = true,
        },
    })
    ---@diagnostic disable-next-line: duplicate-set-field
    require("overseer.shell").escape_cmd = function(cmd) return table.concat(vim.tbl_map(vim.fn.shellescape, cmd), " ") end
end


return {
    {
        "mfussenegger/nvim-dap",
        dependencies = { "jay-babu/mason-nvim-dap.nvim" },
        config = function()
            local function enrich_config(finalConfig, on_config)
                local final_config = vim.deepcopy(finalConfig)
                if final_config.envFile then
                    local filePath = final_config.envFile
                    vim.iter(io.lines(filePath)):filter(function(line) return not line:match("^#") end):each(function(line)
                        local words = {}
                        for word in string.gmatch(line, "[^=]+") do
                            table.insert(words, word)
                        end
                        if not final_config.env then
                            final_config.env = {}
                        end
                        final_config.env[words[1]] = words[2]
                    end)
                end
                on_config(final_config)
            end

            local dap = require("dap")

            require("dap.ext.vscode").json_decode = require("overseer.json").decode

            vim.fn.sign_define("DapBreakpoint", { text = "⚫", texthl = "", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointRejected", { text = "⚪", texthl = "", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointRejected", { text = "❓", texthl = "", linehl = "", numhl = "" })

            dap.adapters.cppdbg = {
                id = "cppdbg",
                type = "executable",
                command = "OpenDebugAD7", -- adjust as needed
            }
            dap.adapters.debugpy = {
                type = "executable",
                command = "python",
                args = { "-m", "debugpy.adapter" },
                enrich_config = enrich_config,
            }

            dap.adapters.node = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "js-debug-adapter",
                    args = { "${port}" },
                },
            }
            local dapui = require("dapui")
            -- dap.listeners.before.attach.dapui_config = function() dapui.open() end
            -- dap.listeners.before.launch.dapui_config = function() dapui.open() end
            -- dap.listeners.before.event_terminated.dapui_config = function() dapui.close(1) end
            -- dap.listeners.before.event_exited.dapui_config = function() require("dapui").close(1) end
            -- local dap, dapui = require("dap"), require("dapui")
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                print("terminated")
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                print("exited")
                dapui.close()
            end

            return {}
        end,
        keys = {
            { "<F5>",  "<cmd>DapContinue<cr>",         mode = { "n", "i" }, desc = "run" },
            { "<F6>",  "<cmd>DapTerminate<cr>",        mode = { "n", "i" }, desc = "terminate" },
            { "<F9>",  "<cmd>DapToggleBreakpoint<cr>", mode = { "n", "i" }, desc = "toggle breakpoint" },
            { "<F11>", "<cmd>DapStepInto<cr>",         mode = { "n", "i" }, desc = "step into" },
            { "<F12>", "<cmd>DapStepOver<cr>",         mode = { "n", "i" }, desc = "step over" },
        },
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = "nvim-dap",
        opts = {},
        keys = {
            { "<leader>vdt", function() require("dapui").toggle() end, desc = "dap ui", mode = { "n", "i" } }
        }
    },
    { "theHamsta/nvim-dap-virtual-text", config = true },
    {
        "stevearc/overseer.nvim",
        config = overseer,
    },

    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        opts = {
            ensure_installed = {
                "cppdbg",
                "python",
                -- "node2",
                "codelldb",
                "js",
            },
            automatic_installation = true,
        },
    },
}
