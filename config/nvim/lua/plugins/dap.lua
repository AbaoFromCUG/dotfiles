return function()
  local dap = require('dap')
  dap.adapters.lldb = {
    type = 'executable',
    command = 'lldb-vscode', -- adjust as needed
    name = "lldb"
  }
  dap.configurations.cpp = {
    {
      name = "Launch C Family",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/',
                            'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},

      -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
      --
      --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
      --
      -- Otherwise you might get the following error:
      --
      --    Error on launch: Failed to attach to the target process
      --
      -- But you should be aware of the implications:
      -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
      runInTerminal = false
    }
  }
  -- If you want to use this for rust and c, add something like this:
  dap.configurations.c = dap.configurations.cpp
  dap.configurations.rust = dap.configurations.cpp

  dap.adapters.node2 = {
    name = 'node2',
    type = 'executable',
    command = 'node',
    args = {
        '/Volumes/Demon/github/vscode-node-debug2/out/src/nodeDebug.js'
    }
  }

  dap.configurations.javascript = {
    {
      name = "Default Js",
      type = 'node2',
      request = 'launch',
      program = '${workspaceFolder}/${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      console = 'integratedTerminal'
    }
  }
end
