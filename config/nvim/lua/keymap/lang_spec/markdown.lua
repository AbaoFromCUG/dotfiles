local wk = require 'which-key'

return function(bufno)
    wk.register({
        ['<space>'] = {
            ['<space>'] = { '<cmd>Glow<cr>', 'preview markdown' }
        }
    }, {
        buffer = bufno,
        silent = false,
    })
end
