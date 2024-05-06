return function(config)
    config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
        texlab = {
            build = {
                args = { "-xelatex", "-interaction=batchmode", "-halt-on-error", "-synctex=1", "%f" },
                executable = "latexmk",
            },
            forwardSearch = {
                executable = "sioyek",
                args = {
                    "--reuse-window",
                    "--execute-command",
                    "toggle_synctex", -- Open Sioyek in synctex mode.
                    "--inverse-search",
                    [[nvim-texlabconfig -file %%%1 -line %%%2 -server ]] .. vim.v.servername,
                    "--forward-search-file",
                    "%f",
                    "--forward-search-line",
                    "%l",
                    "%p",
                },
            },
        },
    })
end
