return function()
    local dap = require("dap")
    local session = require("session")
    local persistent_bp = require("persistent-breakpoints.api")

    vim.fn.sign_define("DapBreakpoint", { text = "⚫", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "⚪", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "❓", texthl = "", linehl = "", numhl = "" })

    dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = "OpenDebugAD7", -- adjust as needed
    }
    dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
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
    dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
    end

    session.register_hook("post_restore", "restore_breakpoints", function()
        persistent_bp.load_breakpoints()
    end)
end
