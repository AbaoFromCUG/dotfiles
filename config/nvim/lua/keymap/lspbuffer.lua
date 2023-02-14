local which_key = require 'which-key'

return function(bufno)
    which_key.register({
        ['<space>'] = {
            l = { vim.diagnostic.open_float, 'show diagnostics' },
            j = { vim.diagnostic.goto_next, 'goto next diagnostic' },
            k = { vim.diagnostic.goto_prev, 'goto previous diagnostic' },
            K = { vim.lsp.buf.hover, 'symbol info' },
            w = { vim.lsp.buf.list_workspace_folders, 'list workspace folders' },
            rn = { vim.lsp.buf.rename, 'symbol rename' },
            ca = { vim.lsp.buf.code_action, 'code action' },
            gd = { vim.lsp.buf.definition, 'jump to definition' },
            gD = { vim.lsp.buf.declaration, 'jump to declaration' },
            gi = { vim.lsp.buf.implementation, 'list implementations' },
            gr = { vim.lsp.buf.references, 'list references' },
        },
        K = { vim.lsp.buf.hover, 'symbol info' },

    }, {
        buffer = bufno,
        silent = false,
    })
end
