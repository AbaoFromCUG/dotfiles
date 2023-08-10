return function()
    local dap = require("dap")
    local session = require("session")
    local launcher = require("integrator.launcher")
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

    session.register_hook("pre_restore", "refresh_launchjs", function()
        launcher.reload()
    end)
    session.register_hook("extra_save", "save_selected_launch", function()
        local current_launch = launcher.selected_configuration
        if current_launch then
            return string.format("lua require('integrator.launcher').select_by_name('%s')", current_launch.name)
        end
    end)
    session.register_hook("post_restore", "restore_breakpoints", function()
        persistent_bp.load_breakpoints()
    end)
end
