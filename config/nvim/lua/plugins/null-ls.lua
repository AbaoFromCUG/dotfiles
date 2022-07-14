return function()
    local null_ls = require "null-ls"
    --- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
    null_ls.setup {
        sources = {
            null_ls.builtins.formatting.cmake_format,
            null_ls.builtins.completion.spell,
            null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.diagnostics.shellcheck,
        },
    }
end
