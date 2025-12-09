return {
    {
        "mfussenegger/nvim-dap",
        dependencies = { "jay-babu/mason-nvim-dap.nvim", "nvim-dap-ui" },
        init = function() end,
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
            local signs = {
                DapBreakpoint = "",
                DapBreakpointCondition = "",
                DapLogPoint = "",
                DapStopped = "",
                DapBreakpointRejected = "",
            }
            vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "", linehl = "", numhl = "" })
            vim.fn.sign_define("DapLogPoint", { text = "", texthl = "", linehl = "", numhl = "" })
            vim.fn.sign_define("DapStopped", { text = "", texthl = "DapUIBreakpointsCurrentLine", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "", linehl = "", numhl = "" })

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
            dap.listeners.before.attach.dapui_config = function() require("dapui").open() end

            dap.listeners.before.launch.dapui_config = function() require("dapui").open() end
            dap.listeners.before.event_terminated.dapui_config = function()
                print("terminated")
                require("dapui").close()
            end
            dap.listeners.before.event_exited.dapui_config = function() require("dapui").close() end

            return {}
        end,
        keys = {
            { "<F5>", "<cmd>DapContinue<cr>", mode = { "n", "i" }, desc = "run" },
            { "<F6>", "<cmd>DapTerminate<cr>", mode = { "n", "i" }, desc = "terminate" },
            { "<F9>", "<cmd>DapToggleBreakpoint<cr>", mode = { "n", "i" }, desc = "terminate" },
            { "<F11>", "<cmd>DapStepInto<cr>", mode = { "n", "i" }, desc = "step into" },
            { "<S-F11>", "<cmd>DapStepOut<cr>", mode = { "n", "i" }, desc = "step out" },
            { "<F12>", "<cmd>DapStepOver<cr>", mode = { "n", "i" }, desc = "step over" },
        },
    },
    {
        "rcarriga/nvim-dap-ui",
        opts = {
            mappings = {
                edit = "e",
                expand = { "o", "<2-LeftMouse>" },
                open = "<CR>",
                remove = "x",
                repl = "r",
                toggle = "t",
            },

            layouts = {
                {
                    elements = {
                        {
                            id = "scopes",
                            size = 0.5,
                        },
                        {
                            id = "breakpoints",
                            size = 0.5,
                        },
                    },
                    position = "left",
                    size = 20,
                },
                {
                    elements = {
                        {
                            id = "stacks",
                            size = 0.5,
                        },
                        {
                            id = "watches",
                            size = 0.5,
                        },
                    },
                    position = "right",
                    size = 20,
                },
                {
                    elements = {
                        {
                            id = "repl",
                            size = 0.5,
                        },
                        {
                            id = "console",
                            size = 0.5,
                        },
                    },
                    position = "bottom",
                    size = 10,
                },
            },
        },
        keys = {
            { "<leader>vdt", function() require("dapui").toggle() end, desc = "dap ui", mode = { "n", "i" } },
        },
    },
    { "theHamsta/nvim-dap-virtual-text", config = true },
    {
        "stevearc/overseer.nvim",
        cmd = { "OverseerToggle", "OverseerInfo", "OverseerRun" },
        dependencies = "toggleterm.nvim",
        version = "v1.6.0",
        opts = {
            templates = { "builtin", "devcontainer" },
            ---@diagnostic disable-next-line: assign-type-mismatch
            strategy = {
                "toggleterm",
                direction = "float",
                close_on_exit = false,
                quit_on_exit = "never",
                -- use_shell = true,
            },
        },
        config = function(_, opts)
            require("overseer").setup(opts)
            require("overseer.shell").escape_cmd = function(cmd)
                cmd = table.concat(vim.tbl_map(vim.fn.shellescape, cmd), " ")
                return cmd
            end
        end,
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
