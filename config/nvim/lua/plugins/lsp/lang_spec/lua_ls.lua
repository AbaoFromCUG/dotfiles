return function(config)
    config.settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                pathStrict = true,
                path = {
                    "lua/?.lua",
                    "?.lua",
                },
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    "vim",
                    "describe",
                    "it",
                    "before_each",
                    "after_each",
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                -- library = { vim.env.VIMRUNTIME },
                checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
            format = {
                enable = false,
            },
            completion = {
                autoRequire = true,
                callSnippet = "Replace",
            },
        },
    }
end
