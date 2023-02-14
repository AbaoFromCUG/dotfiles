return function()
    local null_ls = require 'null-ls'
    null_ls.setup {
        sources = {
            null_ls.builtins.diagnostics.qmllint,
            null_ls.builtins.formatting.qmlformat,
            null_ls.builtins.formatting.autopep8,
            null_ls.builtins.formatting.cmake_format,
            null_ls.builtins.formatting.shfmt,
            null_ls.builtins.formatting.yamlfmt,
        },
    }
end
