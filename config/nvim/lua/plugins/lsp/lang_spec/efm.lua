return function(config)
    config.init_options = { documentFormatting = true }
    local eslint_d = {
        require("efmls-configs.formatters.eslint_d"),
        require("efmls-configs.linters.eslint_d"),
    }
    config.settings = {
        rootMarkers = { ".git/" },
        languages = {
            lua = {
                require("efmls-configs.formatters.stylua"),
            },
            python = {
                require("efmls-configs.formatters.autopep8"),
            },
            cpp = {
                require("efmls-configs.linters.clang_tidy"),
            },
            sh = {
                require("efmls-configs.formatters.shfmt"),
            },
            bash = {
                require("efmls-configs.formatters.shfmt"),
            },
            zsh = {
                require("efmls-configs.formatters.shfmt"),
            },
            vue = eslint_d,
            typescript = eslint_d,
            typescriptreact = eslint_d,
            javascript = eslint_d,
            css = eslint_d,
        },
    }
end
