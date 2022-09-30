local conf = require 'plugins.dap.conf'
local M = {}

function M.load_plugins(use)
    use { 'mfussenegger/nvim-dap', config = require 'plugins.dap.dap' }
    use { 'rcarriga/nvim-dap-ui', config = require 'plugins.dap.dapui' }
    use { 'theHamsta/nvim-dap-virtual-text', config = conf.dap_virtual_text }
    use { 'Weissle/persistent-breakpoints.nvim', config = conf.persistent_bp }
end

return M
