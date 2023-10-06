return function(config)
    config.init_options = { documentFormatting = true }
    local front_end = {
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
            typescript = front_end,
            typescriptreact = front_end,
            javascript = front_end,
        },
    }
end
