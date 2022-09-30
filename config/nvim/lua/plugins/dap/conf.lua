local M = {}

function M.dap_virtual_text()
    require 'nvim-dap-virtual-text'.setup {}
end

function M.persistent_bp()
    require 'persistent-breakpoints'.setup()
end

return M
