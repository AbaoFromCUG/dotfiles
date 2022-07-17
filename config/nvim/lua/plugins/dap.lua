return function()
    local dap = require "dap"
   dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode", -- adjust as needed
        name = "lldb",
    }
end
