local conf = require 'plugins.dap.conf'

return {
    { 'mfussenegger/nvim-dap',               config = require 'plugins.dap.dap' },
    { 'rcarriga/nvim-dap-ui',                config = require 'plugins.dap.dapui' },
    { 'theHamsta/nvim-dap-virtual-text',     config = conf.dap_virtual_text },
    { 'Weissle/persistent-breakpoints.nvim', config = conf.persistent_bp },
}
