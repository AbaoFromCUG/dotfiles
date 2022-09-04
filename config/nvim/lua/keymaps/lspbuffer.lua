local which_key = require 'which-key'

return function(bufno)
    which_key.register({
        f = { '<cmd>lua vim.lsp.buf.formatting()<cr>', 'format' },
        g = {
            name = 'jump',
            d = { '<cmd>lua vim.lsp.buf.definition()<cr>', 'jump to definition' },
            D = { '<cmd>lua vim.lsp.buf.declaration()<cr>', 'jump to declaration' },
            i = { '<cmd>lua vim.lsp.buf.implementation()<cr>', 'list implementations' },
            r = { '<cmd>lua vim.lsp.buf.references()<cr>', 'list references' },
        },
        K = { '<cmd>lua vim.lsp.buf.hover()<cr>', 'symbol info' },
        ['<space>'] = {
            l = {
                name = 'diagnostic',
                l = { '<cmd>lua vim.diagnostic.open_float()<cr>', 'show diagnostics' },
                j = { '<cmd>lua vim.diagnostic.goto_next()<cr>', 'goto next diagnostic' },
                k = { '<cmd>lua vim.diagnostic.goto_prev()<cr>', 'goto previous diagnostic' },
                w = { '<cmd>lua vim.lsp.buf.list_workspace_folders()<cr>', 'list workspace folders' },
                rn = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'symbol rename' },
                ca = { '<cmd>lua vim.lsp.buf.code_action()<cr>', 'code action' },
            },
        }
    }, {
        buffer = bufno,
    })
end
