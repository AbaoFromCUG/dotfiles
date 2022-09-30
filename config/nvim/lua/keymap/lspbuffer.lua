local which_key = require 'which-key'

return function(bufno)
    which_key.register({
        f = { vim.lsp.buf.format, 'format' },
        g = {
            name = 'jump',
            d = { vim.lsp.buf.definition, 'jump to definition' },
            D = { vim.lsp.buf.declaration, 'jump to declaration' },
            i = { vim.lsp.buf.implementation, 'list implementations' },
            r = { vim.lsp.buf.references, 'list references' },
        },
        K = { vim.lsp.buf.hover, 'symbol info' },
        ['<space>'] = {
            l = {
                name = 'lsp',
                l = { vim.diagnostic.open_float, 'show diagnostics' },
                j = { vim.diagnostic.goto_next, 'goto next diagnostic' },
                k = { vim.diagnostic.goto_prev, 'goto previous diagnostic' },
                w = { vim.lsp.buf.list_workspace_folders, 'list workspace folders' },
                rn = { vim.lsp.buf.rename, 'symbol rename' },
                ca = { vim.lsp.buf.code_action, 'code action' },
            },
        }
    }, {
        buffer = bufno,
        silent = false,
    })
end
