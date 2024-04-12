---@param config lspconfig.options.lua_ls
return function(config)
    -- local Path = require("pathlib")

    -- local vim_lib = {}
    -- for index, value in ipairs(vim.api.nvim_get_runtime_file("", true)) do
    --     local path = Path(value)
    --     local lua_path = path:child("lua")
    --     if lua_path:is_dir() then
    --         table.insert(vim_lib, lua_path:tostring())
    --     else
    --     end
    -- end

    config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
        Lua = {
            workspace = {
                -- library = vim_lib
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    -- "vim",
                    "describe",
                    "it",
                    "before_each",
                    "after_each",
                },
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
    })
end
