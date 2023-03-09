return {
    { 'mfussenegger/nvim-dap',               config = require 'plugins.dap.dap' },
    {
        'rcarriga/nvim-dap-ui',
        dependencies = 'mfussenegger/nvim-dap',
        config = require 'plugins.dap.dapui'
    },
    { 'theHamsta/nvim-dap-virtual-text',     config = true },
    { 'Weissle/persistent-breakpoints.nvim', config = true },
}
