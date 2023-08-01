local util = require("lspconfig.util")

local root_files = {
    ".luarc.json",
    ".editorconfig",
}

return function(config)
    config.root_dir = util.root_pattern(root_files)
    config.settings = {
        Lua = {
            runtime = {
                -- LuaJIT in the case of Neovim
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
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
                callSnippet = "Replace",
            },
        },
    }
end
