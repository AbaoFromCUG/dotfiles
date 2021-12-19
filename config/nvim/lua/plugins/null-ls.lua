return function()
    local null_ls = require "null-ls"
    --- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
    null_ls.setup {
        sources = {
            null_ls.builtins.formatting.stylua.with {
                condition = function(utils)
                    return utils.root_has_file "stylua.toml" or utils.root_has_file ".stylua.toml"
                end,
            },
            null_ls.builtins.formatting.cmake_format,

            null_ls.builtins.completion.spell,

            null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.diagnostics.shellcheck,
        },
    }
end
