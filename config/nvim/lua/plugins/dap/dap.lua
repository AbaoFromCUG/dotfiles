local function enrich_config(finalConfig, on_config)
    local final_config = vim.deepcopy(finalConfig)
    if final_config.envFile then
        local filePath = final_config.envFile
        vim.iter(io.lines(filePath))
            :filter(function(line)
                return not line:match("^#")
            end)
            :each(function(line)
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

return function()
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
    local dapui = require("dap")
    dap.listeners.before.attach.dapui_config = function()
        require("dapui").open()
    end
    dap.listeners.before.launch.dapui_config = function()
        require("dapui").open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
        require("dapui").close(1)
    end
    dap.listeners.before.event_exited.dapui_config = function()
        require("dapui").close(1)
    end
end
