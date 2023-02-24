local M = {}

function M.snippets()
    vim.g.vsnip_snippet_dir = vim.fn.stdpath 'config' .. '/snippets/'
end

function M.signature()
    local lsp_signature = require 'lsp_signature'
    lsp_signature.setup {
        floating_window_above_cur_line = false,
    }
end

function M.neodev()
    require 'neodev'.setup()

end
return M
