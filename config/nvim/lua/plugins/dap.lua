return function()
    local dap = require "dap"
    local tasks = require("tasks")
    local launcher = require("launcher")
    local persistent_bp = require("persistent-breakpoints.api")

    vim.fn.sign_define('DapBreakpoint', { text = '⚫', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '⚪', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '❓', texthl = '', linehl = '', numhl = '' })

    dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode", -- adjust as needed
        name = "lldb",
    }
    dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { '-m', 'debugpy.adapter' }
    }

    tasks:register_prerestore_task("refresh_launchjs", function()
        launcher.refresh_launcher()
    end)
    tasks:register_saveextra_task("save_selected_launch", function()
        local current_launch = launcher.current_launch_conf
        if current_launch then
            return string.format("lua require('launcher').select_by_name('%s')", current_launch.name)
        end
    end)
    tasks:register_postrestore_task("restore_breakpoints", function()
        persistent_bp.load_breakpoints()
    end)
end
