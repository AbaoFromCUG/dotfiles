return function(config)
    local exe_path = vim.fn.exepath("texlab")
    config.settings = {
        texlab = {
            build = {

                executable = "latexmk",
                args = { "-lualatex", "-interaction=batchmode", "-halt-on-error", "-synctex=1", "%f" },
                forwardSearchAfter = true,
            },

            forwardSearch = {
                executable = "sioyek",
                args = {
                    "--reuse-window",
                    "--execute-command",
                    "toggle_synctex", -- Open Sioyek in synctex mode.
                    "--inverse-search",
                    exe_path .. ' inverse-search -i "%%1" -l "%%2"',
                    -- [[nvim-texlabconfig -file %%%1 -line %%%2 -server ]] .. vim.v.servername,
                    "--forward-search-file",
                    "%f",
                    "--forward-search-line",
                    "%l",
                    "%p",
                },
            },
        },
    }
end
