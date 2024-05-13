return function()
    local dap = require("dap")
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

    vim.defer_fn(function()
        local session = require("session")
        session.register_hook("post_restore", "restore_breakpoints", function()
            persistent_bp.load_breakpoints()
        end)
    end, 100)

    local function smart_run()
        if dap.session() then
            dap.continue()
        else
            dap.run_last()
        end
    end
    vim.keymap.set({ "n", "i" }, "<F5>", smart_run, { desc = "run" })
    vim.keymap.set({ "n", "i" }, "<F6>", dap.terminate, { desc = "terminate" })
    vim.keymap.set({ "n", "i" }, "<F9>", "<cmd>PBToggleBreakpoint<cr>", { desc = "toggle breakpoint" })
    vim.keymap.set({ "n", "i" }, "<F11>", dap.step_into, { desc = "step into" })
    vim.keymap.set({ "n", "i" }, "<F12>", dap.step_over, { desc = "step over" })
end
