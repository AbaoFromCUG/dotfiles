return function(config)
    config.init_options = { documentFormatting = true }
    config.settings = {
        rootMarkers = { ".git/" },
        languages = {
            lua = {
                require("efmls-configs.formatters.stylua"),
                require("efmls-configs.linters.luacheck"),
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
        },
    }
end
