return function()
  local dap = require('dap')
  dap.adapters.lldb = {
    type = 'executable',
    command = 'lldb-vscode', -- adjust as needed
    name = "lldb"
  }

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
