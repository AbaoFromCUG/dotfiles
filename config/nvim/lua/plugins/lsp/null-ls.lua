return function()
    local null_ls = require("null-ls")
    null_ls.setup({
        debug = true,
        sources = {
            null_ls.builtins.diagnostics.qmllint,
            null_ls.builtins.formatting.qmlformat,
            null_ls.builtins.formatting.autopep8,
            null_ls.builtins.formatting.cmake_format,
            null_ls.builtins.formatting.shfmt.with({
                filetypes = { "sh", "zsh", "bash" },
            }),
            null_ls.builtins.formatting.yamlfmt,
            null_ls.builtins.formatting.stylua.with({
                condition = function(utils)
                    return utils.root_has_file({ "stylua.toml", ".editorconfig", ".stylua.toml" })
                end,
            }),
        },
    })
end
